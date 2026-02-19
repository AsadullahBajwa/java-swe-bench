package com.swebench.service;

import com.swebench.model.Repository;
import com.swebench.model.TaskInstance;
import org.kohsuke.github.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.swebench.util.ConfigLoader;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Represents a split patch with separate test and code changes.
 */
class SplitPatch {
    private final String testPatch;
    private final String codePatch;
    private final String fullPatch;

    public SplitPatch(String testPatch, String codePatch, String fullPatch) {
        this.testPatch = testPatch;
        this.codePatch = codePatch;
        this.fullPatch = fullPatch;
    }

    public String getTestPatch() { return testPatch; }
    public String getCodePatch() { return codePatch; }
    public String getFullPatch() { return fullPatch; }

    public boolean hasTestChanges() { return testPatch != null && !testPatch.isEmpty(); }
    public boolean hasCodeChanges() { return codePatch != null && !codePatch.isEmpty(); }
    public boolean hasBothChanges() { return hasTestChanges() && hasCodeChanges(); }
}

/**
 * Service for interacting with GitHub API to discover repositories and extract task instances.
 */
public class GitHubService {
    private static final Logger logger = LoggerFactory.getLogger(GitHubService.class);
    private final GitHub github;

    public GitHubService() {
        try {
            // Try to connect with token from environment first, then config file, fall back to anonymous
            String token = System.getenv("GITHUB_TOKEN");

            // If not in environment, try config file
            if (token == null || token.isEmpty()) {
                token = ConfigLoader.get("github.token");
                if (token != null && !token.isEmpty() && !token.startsWith("${")) {
                    logger.info("Using GitHub token from config file");
                }
            }

            if (token != null && !token.isEmpty() && !token.startsWith("${")) {
                this.github = new GitHubBuilder().withOAuthToken(token).build();
                logger.info("Connected to GitHub with authentication");
            } else {
                this.github = GitHub.connectAnonymously();
                logger.warn("Connected to GitHub anonymously - rate limits will be restrictive");
                logger.warn("Set GITHUB_TOKEN environment variable or github.token in config for higher rate limits");
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to connect to GitHub", e);
        }
    }

    /**
     * Search for repositories matching the given query
     */
    public List<Repository> searchRepositories(String query, int limit) throws IOException {
        logger.info("Searching repositories: {}", query);

        List<Repository> repositories = new ArrayList<>();
        GHRepositorySearchBuilder search = github.searchRepositories().q(query);

        int count = 0;
        for (GHRepository ghRepo : search.list().withPageSize(100)) {
            if (count >= limit) break;

            try {
                Repository repo = convertToRepository(ghRepo);
                repositories.add(repo);
                count++;

                logger.debug("Found repository: {} ({} stars)", repo.getFullName(), repo.getStars());

            } catch (Exception e) {
                logger.warn("Error processing repository {}: {}", ghRepo.getFullName(), e.getMessage());
            }
        }

        logger.info("Found {} repositories", repositories.size());
        return repositories;
    }

    /**
     * Extract task instances from a repository by finding merged PRs linked to issues
     */
    public List<TaskInstance> extractTaskInstances(Repository repo) throws IOException {
        logger.info("Extracting task instances from {}", repo.getFullName());

        List<TaskInstance> tasks = new ArrayList<>();
        GHRepository ghRepo = github.getRepository(repo.getFullName());

        // Get merged pull requests
        List<GHPullRequest> allPRs = ghRepo.getPullRequests(GHIssueState.CLOSED);
        logger.info("Found {} closed PRs in {}", allPRs.size(), repo.getFullName());

        int prCount = 0;
        int mergedCount = 0;
        int withLinkedIssues = 0;

        for (GHPullRequest pr : allPRs) {
            if (prCount >= 200) break; // Increased limit to find more candidates

            try {
                if (pr.isMerged()) {
                    mergedCount++;
                    logger.debug("Checking merged PR #{}", pr.getNumber());

                    TaskInstance task = extractTaskFromPR(ghRepo, pr);
                    if (task != null) {
                        withLinkedIssues++;
                        // If the Repository model has a curated java_version, it takes priority
                        if (repo.getJavaVersion() != null && !repo.getJavaVersion().isEmpty()) {
                            task.setJavaVersion(repo.getJavaVersion());
                        }
                        tasks.add(task);
                        logger.info("✓ Extracted task from PR #{} linked to issue #{} (java={}, build={})",
                                   pr.getNumber(), task.getIssueNumber(),
                                   task.getJavaVersion(), task.getBuildTool());
                    }
                }
                prCount++;

            } catch (Exception e) {
                logger.debug("Failed to extract task from PR #{}: {}", pr.getNumber(), e.getMessage());
            }
        }

        logger.info("PR Analysis for {}: {} closed PRs checked, {} merged, {} with linked issues, {} tasks extracted",
                    repo.getFullName(), prCount, mergedCount, withLinkedIssues, tasks.size());
        return tasks;
    }

    /**
     * Extract task instances from CODE-ONLY PRs (Option 1 implementation).
     * These PRs modify source files but NOT test files.
     * We then find existing test classes by naming convention.
     */
    public List<TaskInstance> extractCodeOnlyTaskInstances(Repository repo, int maxPRs) throws IOException {
        logger.info("Extracting CODE-ONLY task instances from {} (max {} PRs)", repo.getFullName(), maxPRs);

        List<TaskInstance> tasks = new ArrayList<>();
        GHRepository ghRepo = github.getRepository(repo.getFullName());

        List<GHPullRequest> allPRs = ghRepo.getPullRequests(GHIssueState.CLOSED);
        logger.info("Found {} closed PRs in {}", allPRs.size(), repo.getFullName());

        int prCount = 0;
        int mergedCount = 0;
        int codeOnlyCount = 0;
        int withTestsFound = 0;

        for (GHPullRequest pr : allPRs) {
            if (prCount >= maxPRs) break;

            try {
                if (pr.isMerged()) {
                    mergedCount++;

                    // Fetch the patch first
                    String patch = fetchPRPatch(pr);

                    // Check if this is a code-only PR (no test file modifications)
                    if (isCodeOnlyPR(patch)) {
                        codeOnlyCount++;
                        logger.debug("Found code-only PR #{}", pr.getNumber());

                        // Extract source files modified
                        List<String> sourceFiles = extractSourceFilesFromPatch(patch);

                        // Find existing test classes for these source files
                        List<String> existingTestClasses = findExistingTestClasses(ghRepo, sourceFiles);

                        if (!existingTestClasses.isEmpty()) {
                            withTestsFound++;
                            TaskInstance task = extractCodeOnlyTaskFromPR(ghRepo, pr, patch, existingTestClasses);
                            if (task != null) {
                                // If the Repository model has a curated java_version, it takes priority
                                if (repo.getJavaVersion() != null && !repo.getJavaVersion().isEmpty()) {
                                    task.setJavaVersion(repo.getJavaVersion());
                                }
                                tasks.add(task);
                                logger.info("✓ Extracted code-only task from PR #{} with {} test classes (java={}, build={})",
                                           pr.getNumber(), existingTestClasses.size(),
                                           task.getJavaVersion(), task.getBuildTool());
                            }
                        } else {
                            logger.debug("No existing test classes found for PR #{}", pr.getNumber());
                        }
                    }
                }
                prCount++;

            } catch (Exception e) {
                logger.debug("Failed to process PR #{}: {}", pr.getNumber(), e.getMessage());
            }
        }

        logger.info("CODE-ONLY PR Analysis for {}: {} PRs checked, {} merged, {} code-only, {} with existing tests, {} tasks extracted",
                    repo.getFullName(), prCount, mergedCount, codeOnlyCount, withTestsFound, tasks.size());
        return tasks;
    }

    /**
     * Check if a PR patch only modifies source files (no test files).
     * This is the key filter for Option 1.
     */
    public boolean isCodeOnlyPR(String patch) {
        if (patch == null || patch.isEmpty()) {
            return false;
        }

        String[] lines = patch.split("\n");
        boolean hasSourceChanges = false;
        boolean hasTestChanges = false;

        for (String line : lines) {
            // Look for file paths in diff headers
            if (line.startsWith("+++ b/") || line.startsWith("--- a/")) {
                String filePath = line.substring(6).trim();

                if (isTestFile(filePath)) {
                    hasTestChanges = true;
                } else if (isSourceFile(filePath)) {
                    hasSourceChanges = true;
                }
            }
        }

        // Code-only = has source changes AND no test changes
        return hasSourceChanges && !hasTestChanges;
    }

    /**
     * Check if a file path is a Java source file (not test).
     */
    private boolean isSourceFile(String filePath) {
        if (filePath == null) return false;

        String lowerPath = filePath.toLowerCase();

        // Must be a Java file
        if (!lowerPath.endsWith(".java")) {
            return false;
        }

        // Must NOT be in test directories or be a test file
        if (lowerPath.contains("/test/") ||
            lowerPath.contains("/tests/") ||
            lowerPath.contains("test.java") ||
            lowerPath.contains("tests.java") ||
            lowerPath.contains("testcase.java") ||
            lowerPath.contains("/it/") ||  // integration tests
            lowerPath.contains("mock") ||
            lowerPath.contains("stub")) {
            return false;
        }

        // Should be in main source directory
        return lowerPath.contains("/src/main/") ||
               lowerPath.contains("/src/") && !lowerPath.contains("/test");
    }

    /**
     * Extract list of source files modified in a patch.
     */
    public List<String> extractSourceFilesFromPatch(String patch) {
        List<String> sourceFiles = new ArrayList<>();

        if (patch == null || patch.isEmpty()) {
            return sourceFiles;
        }

        String[] lines = patch.split("\n");
        for (String line : lines) {
            if (line.startsWith("+++ b/")) {
                String filePath = line.substring(6).trim();
                if (isSourceFile(filePath)) {
                    sourceFiles.add(filePath);
                    logger.trace("Found source file in patch: {}", filePath);
                }
            }
        }

        return sourceFiles;
    }

    /**
     * Find existing test classes for the given source files using naming conventions.
     *
     * Naming conventions checked:
     * - StringUtils.java → StringUtilsTest.java
     * - StringUtils.java → StringUtilsTests.java
     * - StringUtils.java → TestStringUtils.java
     * - StringUtils.java → StringUtilsTestCase.java
     */
    public List<String> findExistingTestClasses(GHRepository repo, List<String> sourceFiles) {
        Set<String> testClasses = new HashSet<>();

        for (String sourceFile : sourceFiles) {
            // Extract class name from path
            String className = extractClassName(sourceFile);
            if (className == null) continue;

            // Generate possible test class names
            List<String> possibleTestNames = generateTestClassNames(className);

            // Try to find each possible test class in the repository
            for (String testName : possibleTestNames) {
                List<String> testPaths = generateTestPaths(sourceFile, testName);

                for (String testPath : testPaths) {
                    if (fileExistsInRepo(repo, testPath)) {
                        // Convert path to fully qualified class name
                        String fqClassName = pathToClassName(testPath);
                        if (fqClassName != null) {
                            testClasses.add(fqClassName);
                            logger.debug("Found existing test class: {} for source: {}", fqClassName, sourceFile);
                        }
                        break; // Found a test for this name, move to next
                    }
                }
            }
        }

        return new ArrayList<>(testClasses);
    }

    /**
     * Extract class name from a file path.
     * e.g., "src/main/java/org/apache/commons/lang3/StringUtils.java" → "StringUtils"
     */
    private String extractClassName(String filePath) {
        if (filePath == null || !filePath.endsWith(".java")) {
            return null;
        }

        int lastSlash = filePath.lastIndexOf('/');
        String fileName = lastSlash >= 0 ? filePath.substring(lastSlash + 1) : filePath;

        // Remove .java extension
        return fileName.substring(0, fileName.length() - 5);
    }

    /**
     * Generate possible test class names for a given source class.
     */
    private List<String> generateTestClassNames(String className) {
        List<String> names = new ArrayList<>();
        names.add(className + "Test");       // Most common: StringUtilsTest
        names.add(className + "Tests");      // StringUtilsTests
        names.add("Test" + className);       // TestStringUtils
        names.add(className + "TestCase");   // StringUtilsTestCase
        return names;
    }

    /**
     * Generate possible test file paths for a test class name.
     */
    private List<String> generateTestPaths(String sourceFilePath, String testClassName) {
        List<String> paths = new ArrayList<>();

        // Convert src/main/java to src/test/java
        String testPath = sourceFilePath
            .replace("/src/main/java/", "/src/test/java/")
            .replace("/src/main/", "/src/test/");

        // Replace the class name with test class name
        int lastSlash = testPath.lastIndexOf('/');
        if (lastSlash >= 0) {
            String basePath = testPath.substring(0, lastSlash + 1);
            paths.add(basePath + testClassName + ".java");
        }

        // Also try common test directory patterns
        if (sourceFilePath.contains("/java/")) {
            // org/apache/commons/lang3/StringUtils.java pattern
            int javaIndex = sourceFilePath.indexOf("/java/");
            String packagePath = sourceFilePath.substring(javaIndex + 6);
            int classStart = packagePath.lastIndexOf('/');
            if (classStart >= 0) {
                String packageDir = packagePath.substring(0, classStart + 1);
                paths.add("src/test/java/" + packageDir + testClassName + ".java");
            }
        }

        return paths;
    }

    /**
     * Check if a file exists in the repository.
     */
    private boolean fileExistsInRepo(GHRepository repo, String filePath) {
        try {
            repo.getFileContent(filePath);
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    /**
     * Convert a file path to a fully qualified class name.
     * e.g., "src/test/java/org/apache/commons/lang3/StringUtilsTest.java"
     *       → "org.apache.commons.lang3.StringUtilsTest"
     */
    private String pathToClassName(String filePath) {
        if (filePath == null || !filePath.endsWith(".java")) {
            return null;
        }

        // Find the java/ directory marker
        int javaIndex = filePath.indexOf("/java/");
        if (javaIndex < 0) {
            javaIndex = filePath.indexOf("\\java\\");
        }

        if (javaIndex >= 0) {
            String classPath = filePath.substring(javaIndex + 6);
            // Remove .java extension and convert / to .
            classPath = classPath.substring(0, classPath.length() - 5);
            return classPath.replace('/', '.').replace('\\', '.');
        }

        return null;
    }

    /**
     * Extract a task from a code-only PR with existing test classes.
     */
    private TaskInstance extractCodeOnlyTaskFromPR(GHRepository repo, GHPullRequest pr,
                                                    String patch, List<String> existingTestClasses) throws IOException {
        // Check if PR references an issue
        List<GHIssue> linkedIssues = findLinkedIssues(pr);
        if (linkedIssues.isEmpty()) {
            logger.debug("PR #{} has no linked issues, skipping", pr.getNumber());
            return null;
        }

        GHIssue issue = linkedIssues.get(0);

        // Filter: Must have a meaningful problem statement (bug description)
        String problemStatement = issue.getBody();
        if (problemStatement == null || problemStatement.length() < 50) {
            logger.debug("PR #{} issue has insufficient problem statement", pr.getNumber());
            return null;
        }

        // Create task instance
        TaskInstance task = new TaskInstance();
        task.setInstanceId(String.format("%s-PR-%d", repo.getFullName().replace("/", "-"), pr.getNumber()));
        task.setRepo(repo.getFullName());
        task.setIssueNumber(issue.getNumber());
        task.setPullNumber(pr.getNumber());
        task.setBaseCommit(pr.getBase().getSha());
        task.setProblemStatement(problemStatement);
        task.setCreatedAt(issue.getCreatedAt().toString());
        task.setPatch(patch);

        // Set the existing test classes as FAIL_TO_PASS
        // These tests should fail at base commit (bug present) and pass after patch
        task.setFailToPass(existingTestClasses);
        logger.info("Set {} existing test classes for fail-to-pass validation", existingTestClasses.size());

        // Determine build tool and Java version
        detectBuildSystem(repo, task);

        // Generate test command targeting specific test classes
        generateTargetedTestCommand(task, existingTestClasses);

        return task;
    }

    /**
     * Generate a test command that targets specific test classes.
     */
    private void generateTargetedTestCommand(TaskInstance task, List<String> testClasses) {
        String buildTool = task.getBuildTool();

        if (testClasses.isEmpty()) {
            generateTestCommand(task);
            return;
        }

        // Extract module name from patch if this is a multi-module project
        String module = extractModuleFromPatch(task.getPatch());

        // Build a test command targeting specific classes
        if ("maven".equalsIgnoreCase(buildTool)) {
            // Maven: mvn test -Dtest=Class1,Class2
            // For multi-module: mvn test -pl <module> -Dtest=Class1,Class2
            String testList = String.join(",", testClasses.stream()
                .map(c -> c.substring(c.lastIndexOf('.') + 1)) // Just class name for Maven
                .toArray(String[]::new));

            if (module != null && !module.isEmpty()) {
                task.setTestCommand("mvn test -pl " + module + " -Dtest=" + testList);
                logger.debug("Set Maven test command for module {}: mvn test -pl {} -Dtest={}", module, module, testList);
            } else {
                task.setTestCommand("mvn test -Dtest=" + testList);
                logger.debug("Set Maven test command: mvn test -Dtest={}", testList);
            }
        } else if ("gradle".equalsIgnoreCase(buildTool)) {
            // Gradle: ./gradlew test --tests "Class1" --tests "Class2"
            // For multi-module: ./gradlew :module:test --tests "Class1"
            StringBuilder cmd = new StringBuilder();
            if (module != null && !module.isEmpty()) {
                cmd.append("./gradlew :").append(module).append(":test");
            } else {
                cmd.append("./gradlew test");
            }
            for (String testClass : testClasses) {
                cmd.append(" --tests \"").append(testClass).append("\"");
            }
            task.setTestCommand(cmd.toString());
            logger.debug("Set Gradle test command: {}", cmd);
        } else {
            // Default to Maven
            String testList = String.join(",", testClasses.stream()
                .map(c -> c.substring(c.lastIndexOf('.') + 1))
                .toArray(String[]::new));
            if (module != null && !module.isEmpty()) {
                task.setTestCommand("mvn test -pl " + module + " -Dtest=" + testList);
            } else {
                task.setTestCommand("mvn test -Dtest=" + testList);
            }
        }
    }

    /**
     * Extract the module name from a patch for multi-module projects.
     * Looks for patterns like "module-name/src/main/java/..."
     */
    private String extractModuleFromPatch(String patch) {
        if (patch == null || patch.isEmpty()) {
            return null;
        }

        String[] lines = patch.split("\n");
        for (String line : lines) {
            if (line.startsWith("+++ b/") || line.startsWith("--- a/")) {
                String filePath = line.substring(6).trim();

                // Check for multi-module pattern: module-name/src/...
                if (filePath.contains("/src/main/") || filePath.contains("/src/test/")) {
                    int srcIndex = filePath.indexOf("/src/");
                    if (srcIndex > 0) {
                        String potentialModule = filePath.substring(0, srcIndex);
                        // Verify it's a module name (doesn't contain nested paths before src)
                        // and isn't just "src" (single-module project)
                        if (!potentialModule.isEmpty() && !potentialModule.equals("src") && !potentialModule.contains("/src/")) {
                            logger.debug("Detected multi-module project, module: {}", potentialModule);
                            return potentialModule;
                        }
                    }
                }
            }
        }

        return null;
    }

    private TaskInstance extractTaskFromPR(GHRepository repo, GHPullRequest pr) throws IOException {
        // Check if PR references an issue
        List<GHIssue> linkedIssues = findLinkedIssues(pr);
        if (linkedIssues.isEmpty()) {
            return null;
        }

        GHIssue issue = linkedIssues.get(0);

        // Create task instance
        TaskInstance task = new TaskInstance();
        task.setInstanceId(String.format("%s-%d", repo.getFullName().replace("/", "-"), issue.getNumber()));
        task.setRepo(repo.getFullName());
        task.setIssueNumber(issue.getNumber());
        task.setPullNumber(pr.getNumber());
        task.setBaseCommit(pr.getBase().getSha());
        task.setProblemStatement(issue.getBody());
        task.setCreatedAt(issue.getCreatedAt().toString());

        // Extract patch from PR diff
        try {
            String patch = fetchPRPatch(pr);
            task.setPatch(patch);

            // Extract test methods from patch for FAIL_TO_PASS
            List<String> testMethods = extractTestMethodsFromPatch(patch);
            if (!testMethods.isEmpty()) {
                task.setFailToPass(testMethods);
                logger.debug("Extracted {} test methods from PR #{}", testMethods.size(), pr.getNumber());
            } else {
                // Use auto-detection marker when specific tests can't be extracted
                // This allows validation to proceed with runtime test discovery
                task.setFailToPass(java.util.Arrays.asList("__ALL_TESTS__"));
                logger.debug("No specific test methods found in PR #{}, using auto-detection", pr.getNumber());
            }
        } catch (Exception e) {
            logger.debug("Failed to fetch patch for PR #{}: {}", pr.getNumber(), e.getMessage());
            return null; // Skip tasks without patches
        }

        // Determine build tool and Java version
        detectBuildSystem(repo, task);

        // Generate test command based on build tool
        generateTestCommand(task);

        return task;
    }

    private String fetchPRPatch(GHPullRequest pr) throws IOException {
        // Use GitHub API to get PR diff in unified patch format
        String diffUrl = pr.getDiffUrl().toString();

        try {
            java.net.URL url = new java.net.URL(diffUrl);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestProperty("Authorization", "token " + System.getenv("GITHUB_TOKEN"));
            conn.setRequestProperty("Accept", "application/vnd.github.v3.diff");

            java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(conn.getInputStream()));
            StringBuilder patch = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                patch.append(line).append("\n");
            }
            reader.close();

            return patch.toString();
        } catch (Exception e) {
            throw new IOException("Failed to fetch PR diff: " + e.getMessage(), e);
        }
    }

    /**
     * Extract test methods from a patch for FAIL_TO_PASS validation
     * Parses unified diff format to find added/modified test methods
     */
    private List<String> extractTestMethodsFromPatch(String patch) {
        List<String> testMethods = new ArrayList<>();
        java.util.Set<String> seenMethods = new java.util.HashSet<>();

        if (patch == null || patch.isEmpty()) {
            return testMethods;
        }

        String[] lines = patch.split("\n");
        String currentFile = null;
        String currentPackage = null;
        String currentClass = null;

        for (int i = 0; i < lines.length; i++) {
            String line = lines[i];

            // Track current file being processed (e.g., +++ b/path/to/TestFile.java)
            if (line.startsWith("+++ b/")) {
                String filePath = line.substring(6).trim();

                // Check if this is a test file
                if (isTestFile(filePath)) {
                    currentFile = filePath;
                    currentPackage = null;
                    currentClass = null;
                    logger.trace("Processing test file: {}", filePath);
                } else {
                    currentFile = null;
                }
                continue;
            }

            // Only process lines from test files
            if (currentFile == null) {
                continue;
            }

            // Extract package name
            if (line.startsWith("+package ") || line.startsWith(" package ")) {
                String pkg = line.substring(line.indexOf("package") + 7).trim();
                pkg = pkg.replace(";", "").trim();
                currentPackage = pkg;
                logger.trace("Found package: {}", pkg);
            }

            // Extract class name
            if ((line.startsWith("+class ") || line.startsWith(" class ") ||
                 line.startsWith("+public class ") || line.startsWith(" public class ")) &&
                !line.contains("{") || line.contains("{")) {
                java.util.regex.Pattern classPattern = java.util.regex.Pattern.compile(
                    "(?:public\\s+)?(?:abstract\\s+)?class\\s+(\\w+)");
                java.util.regex.Matcher m = classPattern.matcher(line);
                if (m.find()) {
                    currentClass = m.group(1);
                    logger.trace("Found class: {}", currentClass);
                }
            }

            // Look for added test methods (lines starting with +)
            if (line.startsWith("+") && currentPackage != null && currentClass != null) {
                String testMethod = extractTestMethod(line);
                if (testMethod != null) {
                    // Build fully qualified test method name
                    String fullyQualifiedMethod = currentPackage + "." + currentClass + "::" + testMethod;

                    if (!seenMethods.contains(fullyQualifiedMethod)) {
                        testMethods.add(fullyQualifiedMethod);
                        seenMethods.add(fullyQualifiedMethod);
                        logger.trace("Extracted test method: {}", fullyQualifiedMethod);
                    }
                }
            }
        }

        return testMethods;
    }

    /**
     * Split a patch into separate test and code patches.
     * This is critical for the split-patch validation approach.
     *
     * @param fullPatch The complete patch from a PR
     * @return SplitPatch containing separate test and code patches
     */
    public SplitPatch splitPatch(String fullPatch) {
        if (fullPatch == null || fullPatch.isEmpty()) {
            return new SplitPatch("", "", fullPatch);
        }

        StringBuilder testPatch = new StringBuilder();
        StringBuilder codePatch = new StringBuilder();

        String[] lines = fullPatch.split("\n");
        StringBuilder currentFilePatch = new StringBuilder();
        boolean isCurrentFileTest = false;
        String currentFile = null;

        for (String line : lines) {
            // Detect new file in diff
            if (line.startsWith("diff --git")) {
                // Save previous file's patch
                if (currentFile != null && currentFilePatch.length() > 0) {
                    if (isCurrentFileTest) {
                        testPatch.append(currentFilePatch);
                    } else {
                        codePatch.append(currentFilePatch);
                    }
                }

                // Start new file
                currentFilePatch = new StringBuilder();
                currentFilePatch.append(line).append("\n");

                // Extract file path from diff line
                // Format: diff --git a/path/to/file b/path/to/file
                String[] parts = line.split(" ");
                if (parts.length >= 4) {
                    currentFile = parts[2].substring(2); // Remove "a/" prefix
                    isCurrentFileTest = isTestFile(currentFile);
                }
                continue;
            }

            // Add line to current file patch
            if (currentFile != null) {
                currentFilePatch.append(line).append("\n");
            }
        }

        // Don't forget the last file
        if (currentFile != null && currentFilePatch.length() > 0) {
            if (isCurrentFileTest) {
                testPatch.append(currentFilePatch);
            } else {
                codePatch.append(currentFilePatch);
            }
        }

        logger.debug("Split patch: {} chars test, {} chars code",
                    testPatch.length(), codePatch.length());

        return new SplitPatch(testPatch.toString(), codePatch.toString(), fullPatch);
    }

    /**
     * Extract task instances using the SPLIT-PATCH approach.
     * PRs must have BOTH test and code changes.
     * Validation: Apply test_patch first (should fail), then code_patch (should pass).
     */
    public List<TaskInstance> extractSplitPatchTasks(Repository repo, int maxPRs) throws IOException {
        logger.info("Extracting SPLIT-PATCH tasks from {} (max {} PRs)", repo.getFullName(), maxPRs);

        List<TaskInstance> tasks = new ArrayList<>();
        GHRepository ghRepo = github.getRepository(repo.getFullName());

        List<GHPullRequest> allPRs = ghRepo.getPullRequests(GHIssueState.CLOSED);
        logger.info("Found {} closed PRs in {}", allPRs.size(), repo.getFullName());

        int prCount = 0;
        int mergedCount = 0;
        int splitPatchCount = 0;

        for (GHPullRequest pr : allPRs) {
            if (prCount >= maxPRs) break;
            if (tasks.size() >= 20) break; // Limit tasks per repo

            try {
                if (pr.isMerged()) {
                    mergedCount++;

                    // Fetch and split the patch
                    String fullPatch = fetchPRPatch(pr);
                    SplitPatch splitPatch = splitPatch(fullPatch);

                    // We need PRs that have BOTH test and code changes
                    if (splitPatch.hasBothChanges()) {
                        splitPatchCount++;
                        logger.debug("Found split-patch candidate PR #{}", pr.getNumber());

                        TaskInstance task = extractSplitPatchTaskFromPR(ghRepo, pr, splitPatch);
                        if (task != null) {
                            // If the Repository model has a curated java_version, it takes priority
                            if (repo.getJavaVersion() != null && !repo.getJavaVersion().isEmpty()) {
                                task.setJavaVersion(repo.getJavaVersion());
                            }
                            tasks.add(task);
                            logger.info("✓ Extracted split-patch task from PR #{}: {} (java={}, build={})",
                                       pr.getNumber(), task.getInstanceId(),
                                       task.getJavaVersion(), task.getBuildTool());
                        }
                    }
                }
                prCount++;

            } catch (Exception e) {
                logger.debug("Failed to process PR #{}: {}", pr.getNumber(), e.getMessage());
            }
        }

        logger.info("SPLIT-PATCH Analysis for {}: {} PRs checked, {} merged, {} with both test+code, {} tasks extracted",
                    repo.getFullName(), prCount, mergedCount, splitPatchCount, tasks.size());
        return tasks;
    }

    /**
     * Extract a task from a PR using the split-patch approach.
     */
    private TaskInstance extractSplitPatchTaskFromPR(GHRepository repo, GHPullRequest pr,
                                                      SplitPatch splitPatch) throws IOException {
        // Create task instance
        TaskInstance task = new TaskInstance();
        task.setInstanceId(String.format("%s-PR-%d", repo.getFullName().replace("/", "-"), pr.getNumber()));
        task.setRepo(repo.getFullName());
        task.setPullNumber(pr.getNumber());
        task.setBaseCommit(pr.getBase().getSha());
        task.setCreatedAt(pr.getCreatedAt().toString());

        // Set problem statement from PR title + body
        String problemStatement = pr.getTitle();
        if (pr.getBody() != null && !pr.getBody().isEmpty()) {
            problemStatement += "\n\n" + pr.getBody();
        }
        task.setProblemStatement(problemStatement);

        // KEY: Set split patches
        task.setPatch(splitPatch.getCodePatch());      // Code-only changes
        task.setTestPatch(splitPatch.getTestPatch());  // Test-only changes

        // Try to find linked issue
        List<GHIssue> linkedIssues = findLinkedIssues(pr);
        if (!linkedIssues.isEmpty()) {
            GHIssue issue = linkedIssues.get(0);
            task.setIssueNumber(issue.getNumber());
            // Use issue body as problem statement if available
            if (issue.getBody() != null && issue.getBody().length() > 50) {
                task.setProblemStatement(issue.getBody());
            }
        }

        // Extract test classes from the test patch
        List<String> testClasses = extractTestClassesFromPatch(splitPatch.getTestPatch());
        if (!testClasses.isEmpty()) {
            task.setFailToPass(testClasses);
        } else {
            task.setFailToPass(java.util.Arrays.asList("__ALL_TESTS__"));
        }

        // Determine build tool
        detectBuildSystem(repo, task);

        // Generate test command
        generateTargetedTestCommand(task, testClasses);

        return task;
    }

    /**
     * Extract test class names from a patch.
     * Returns simple class names like "StringUtilsTest", "NumberUtilsTest".
     */
    public List<String> extractTestClassesFromPatch(String patch) {
        Set<String> testClasses = new HashSet<>();

        if (patch == null || patch.isEmpty()) {
            return new ArrayList<>(testClasses);
        }

        String[] lines = patch.split("\n");
        for (String line : lines) {
            if (line.startsWith("+++ b/") || line.startsWith("--- a/")) {
                String filePath = line.substring(6).trim();
                if (isTestFile(filePath)) {
                    // Extract class name from path
                    String className = extractClassName(filePath);
                    if (className != null) {
                        testClasses.add(className);
                        logger.trace("Found test class in patch: {}", className);
                    }
                }
            }
        }

        return new ArrayList<>(testClasses);
    }

    /**
     * Check if a file path represents a test file
     */
    private boolean isTestFile(String filePath) {
        if (filePath == null) {
            return false;
        }

        String lowerPath = filePath.toLowerCase();

        // Check common test file patterns
        return lowerPath.contains("test") &&
               (lowerPath.endsWith(".java") || lowerPath.endsWith(".kt")) &&
               (lowerPath.contains("/test/") ||
                lowerPath.endsWith("test.java") ||
                lowerPath.endsWith("tests.java") ||
                lowerPath.endsWith("testcase.java"));
    }

    /**
     * Extract test method name from a line of code
     * Looks for @Test annotation and method signatures
     */
    private String extractTestMethod(String line) {
        // Remove leading + from diff
        String cleanLine = line.substring(1).trim();

        // Look for method signatures that might be test methods
        // Pattern: void methodName() or public void methodName()
        java.util.regex.Pattern methodPattern = java.util.regex.Pattern.compile(
            "(?:public|private|protected)?\\s+(?:static\\s+)?void\\s+(test\\w+|\\w+Test)\\s*\\(");
        java.util.regex.Matcher m = methodPattern.matcher(cleanLine);

        if (m.find()) {
            return m.group(1);
        }

        // Also check for @Test annotation on previous or same line
        if (cleanLine.contains("@Test") || cleanLine.contains("@ParameterizedTest") ||
            cleanLine.contains("@RepeatedTest")) {
            // Method might be on next line or same line
            java.util.regex.Pattern annotatedMethod = java.util.regex.Pattern.compile(
                "(?:public|private|protected)?\\s+(?:static\\s+)?\\w+\\s+(\\w+)\\s*\\(");
            java.util.regex.Matcher m2 = annotatedMethod.matcher(cleanLine);
            if (m2.find()) {
                return m2.group(1);
            }
        }

        return null;
    }

    private List<GHIssue> findLinkedIssues(GHPullRequest pr) {
        List<GHIssue> issues = new ArrayList<>();
        java.util.Set<Integer> foundIssueNumbers = new java.util.HashSet<>();

        try {
            String body = pr.getBody();
            String title = pr.getTitle();

            // Combine title and body for searching
            String searchText = (title != null ? title + " " : "") + (body != null ? body : "");

            if (searchText.isEmpty()) {
                return issues;
            }

            // Look for issue references like #123, fixes #123, closes #123, resolves #123
            // More relaxed pattern that catches any #number
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
                "(?:fixes?|closes?|resolves?|fix|close|resolve)?\\s*#(\\d+)",
                java.util.regex.Pattern.CASE_INSENSITIVE
            );
            java.util.regex.Matcher m = pattern.matcher(searchText);

            while (m.find()) {
                try {
                    int issueNumber = Integer.parseInt(m.group(1));

                    // Avoid duplicates
                    if (foundIssueNumbers.contains(issueNumber)) {
                        continue;
                    }

                    GHIssue issue = pr.getRepository().getIssue(issueNumber);
                    if (!issue.isPullRequest()) {
                        issues.add(issue);
                        foundIssueNumbers.add(issueNumber);
                        logger.debug("Found linked issue #{} in PR #{}", issueNumber, pr.getNumber());
                    }
                } catch (Exception e) {
                    logger.trace("Could not fetch issue reference: {}", e.getMessage());
                }
            }
        } catch (Exception e) {
            logger.debug("Error finding linked issues for PR #{}: {}", pr.getNumber(), e.getMessage());
        }

        return issues;
    }

    private void detectBuildSystem(GHRepository repo, TaskInstance task) {
        try {
            // Check for Maven
            try {
                repo.getFileContent("pom.xml");
                task.setBuildTool("maven");
                logger.debug("Detected Maven build system");
            } catch (IOException e) {
                // Check for Gradle
                try {
                    repo.getFileContent("build.gradle");
                    task.setBuildTool("gradle");
                    logger.debug("Detected Gradle build system");
                } catch (IOException e2) {
                    // Check for Gradle Kotlin DSL
                    try {
                        repo.getFileContent("build.gradle.kts");
                        task.setBuildTool("gradle");
                        logger.debug("Detected Gradle (Kotlin DSL) build system");
                    } catch (IOException e3) {
                        logger.debug("Could not detect build system");
                    }
                }
            }

            // Always also detect Java version
            String javaVersion = detectJavaVersion(repo);
            task.setJavaVersion(javaVersion);
            logger.debug("Detected Java version: {}", javaVersion);

        } catch (Exception e) {
            logger.debug("Error detecting build environment: {}", e.getMessage());
        }
    }

    /**
     * Auto-detects the required Java version from repository configuration files.
     *
     * Detection priority:
     * 1. .mvn/jvm.config  (--release N)
     * 2. pom.xml          (<maven.compiler.release>, <maven.compiler.source>, <java.version>)
     * 3. build.gradle     (sourceCompatibility, java toolchain)
     * 4. build.gradle.kts (same patterns)
     * 5. Default: "17"
     */
    private String detectJavaVersion(GHRepository repo) {
        // 1. Check .mvn/jvm.config
        try {
            String content = new String(
                java.util.Base64.getMimeDecoder().decode(
                    repo.getFileContent(".mvn/jvm.config").getContent()));
            Matcher m = Pattern.compile("--release\\s+(\\d+)").matcher(content);
            if (m.find()) return m.group(1);
            m = Pattern.compile("-source\\s+(\\d+)").matcher(content);
            if (m.find()) return m.group(1);
        } catch (Exception e) {
            // file not present or unreadable
        }

        // 2. Check pom.xml
        try {
            String content = new String(
                java.util.Base64.getMimeDecoder().decode(
                    repo.getFileContent("pom.xml").getContent()));
            // <maven.compiler.release>17</maven.compiler.release>
            Matcher m = Pattern.compile(
                "<maven\\.compiler\\.release>\\s*(\\d+)\\s*</maven\\.compiler\\.release>").matcher(content);
            if (m.find()) return m.group(1);
            // <maven.compiler.source>17</maven.compiler.source>
            m = Pattern.compile(
                "<maven\\.compiler\\.source>\\s*(\\d+)\\s*</maven\\.compiler\\.source>").matcher(content);
            if (m.find()) return m.group(1);
            // <java.version>17</java.version>
            m = Pattern.compile("<java\\.version>\\s*(\\d+)\\s*</java\\.version>").matcher(content);
            if (m.find()) return m.group(1);
        } catch (Exception e) {
            // file not present or unreadable
        }

        // 3. Check build.gradle
        try {
            String content = new String(
                java.util.Base64.getMimeDecoder().decode(
                    repo.getFileContent("build.gradle").getContent()));
            // sourceCompatibility = 17 or sourceCompatibility = JavaVersion.VERSION_17
            Matcher m = Pattern.compile(
                "sourceCompatibility\\s*=\\s*['\"]?(?:JavaVersion\\.VERSION_)?(\\d+)['\"]?").matcher(content);
            if (m.find()) return m.group(1);
            // java { toolchain { languageVersion = JavaLanguageVersion.of(17) } }
            m = Pattern.compile("JavaLanguageVersion\\.of\\((\\d+)\\)").matcher(content);
            if (m.find()) return m.group(1);
        } catch (Exception e) {
            // file not present or unreadable
        }

        // 4. Check build.gradle.kts
        try {
            String content = new String(
                java.util.Base64.getMimeDecoder().decode(
                    repo.getFileContent("build.gradle.kts").getContent()));
            Matcher m = Pattern.compile(
                "sourceCompatibility\\s*=\\s*JavaVersion\\.VERSION_(\\d+)").matcher(content);
            if (m.find()) return m.group(1);
            m = Pattern.compile("JavaLanguageVersion\\.of\\((\\d+)\\)").matcher(content);
            if (m.find()) return m.group(1);
        } catch (Exception e) {
            // file not present or unreadable
        }

        // Default to Java 17 (LTS, widely supported)
        logger.debug("Could not detect Java version for {}, defaulting to 17", repo.getFullName());
        return "17";
    }

    /**
     * Generate appropriate test command based on build tool
     */
    private void generateTestCommand(TaskInstance task) {
        String buildTool = task.getBuildTool();

        if ("maven".equalsIgnoreCase(buildTool)) {
            task.setTestCommand("mvn test");
            logger.debug("Set test command for Maven: mvn test");
        } else if ("gradle".equalsIgnoreCase(buildTool)) {
            task.setTestCommand("./gradlew test");
            logger.debug("Set test command for Gradle: ./gradlew test");
        } else {
            // Default to Maven if unknown
            task.setTestCommand("mvn test");
            logger.debug("Build tool unknown, defaulting to: mvn test");
        }
    }

    private Repository convertToRepository(GHRepository ghRepo) throws IOException {
        Repository repo = new Repository();
        repo.setFullName(ghRepo.getFullName());
        repo.setName(ghRepo.getName());
        repo.setOwner(ghRepo.getOwner().getLogin());
        repo.setStars(ghRepo.getStargazersCount());
        repo.setForks(ghRepo.getForksCount());
        repo.setLanguage(ghRepo.getLanguage());
        repo.setFork(ghRepo.isFork());
        repo.setHasIssues(ghRepo.hasIssues());
        repo.setOpenIssuesCount(ghRepo.getOpenIssueCount());
        repo.setDefaultBranch(ghRepo.getDefaultBranch());
        repo.setCloneUrl(ghRepo.getHttpTransportUrl());

        if (ghRepo.getUpdatedAt() != null) {
            repo.setLastUpdated(
                LocalDateTime.ofInstant(ghRepo.getUpdatedAt().toInstant(), ZoneId.systemDefault())
            );
        }

        // Calculate Java percentage from language statistics
        calculateJavaPercentage(ghRepo, repo);

        // Detect build tool
        detectBuildTool(ghRepo, repo);

        // Auto-detect Java version from repo config files
        repo.setJavaVersion(detectJavaVersion(ghRepo));

        return repo;
    }

    /**
     * Calculate the percentage of Java code in the repository
     */
    private void calculateJavaPercentage(GHRepository ghRepo, Repository repo) {
        try {
            // Get language statistics (bytes of code per language)
            java.util.Map<String, Long> languages = ghRepo.listLanguages();

            if (languages == null || languages.isEmpty()) {
                repo.setJavaPercentage(0.0);
                logger.debug("No language statistics available for {}", ghRepo.getFullName());
                return;
            }

            long javaBytes = languages.getOrDefault("Java", 0L);
            long totalBytes = languages.values().stream().mapToLong(Long::longValue).sum();

            if (totalBytes > 0) {
                double percentage = (javaBytes * 100.0) / totalBytes;
                repo.setJavaPercentage(percentage);
                logger.debug("Repository {} has {:.2f}% Java code", ghRepo.getFullName(), percentage);
            } else {
                repo.setJavaPercentage(0.0);
            }

        } catch (IOException e) {
            logger.warn("Failed to get language statistics for {}: {}", ghRepo.getFullName(), e.getMessage());
            repo.setJavaPercentage(0.0);
        }
    }

    private void detectBuildTool(GHRepository ghRepo, Repository repo) {
        try {
            ghRepo.getFileContent("pom.xml");
            repo.setBuildTool("maven");
            repo.setHasTests(true); // Assume Maven projects have tests
            return;
        } catch (IOException e) {
            // Not Maven
        }

        try {
            ghRepo.getFileContent("build.gradle");
            repo.setBuildTool("gradle");
            repo.setHasTests(true);
            return;
        } catch (IOException e) {
            // Not Gradle
        }

        try {
            ghRepo.getFileContent("build.gradle.kts");
            repo.setBuildTool("gradle");
            repo.setHasTests(true);
        } catch (IOException e) {
            // No build tool detected
        }
    }
}
