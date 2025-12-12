package com.swebench.service;

import com.swebench.model.Repository;
import com.swebench.model.TaskInstance;
import org.kohsuke.github.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

/**
 * Service for interacting with GitHub API to discover repositories and extract task instances.
 */
public class GitHubService {
    private static final Logger logger = LoggerFactory.getLogger(GitHubService.class);
    private final GitHub github;

    public GitHubService() {
        try {
            // Try to connect with token from environment, fall back to anonymous
            String token = System.getenv("GITHUB_TOKEN");
            if (token != null && !token.isEmpty()) {
                this.github = new GitHubBuilder().withOAuthToken(token).build();
                logger.info("Connected to GitHub with authentication");
            } else {
                this.github = GitHub.connectAnonymously();
                logger.warn("Connected to GitHub anonymously - rate limits will be restrictive");
                logger.warn("Set GITHUB_TOKEN environment variable for higher rate limits");
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
                        tasks.add(task);
                        logger.info("✓ Extracted task from PR #{} linked to issue #{}", pr.getNumber(), task.getIssueNumber());
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
                return;
            } catch (IOException e) {
                // Not Maven
            }

            // Check for Gradle
            try {
                repo.getFileContent("build.gradle");
                task.setBuildTool("gradle");
                logger.debug("Detected Gradle build system");
                return;
            } catch (IOException e) {
                // Not Gradle
            }

            // Check for Gradle Kotlin DSL
            try {
                repo.getFileContent("build.gradle.kts");
                task.setBuildTool("gradle");
                logger.debug("Detected Gradle (Kotlin DSL) build system");
                return;
            } catch (IOException e) {
                // Not Gradle Kotlin
            }

            logger.debug("Could not detect build system");

        } catch (Exception e) {
            logger.debug("Error detecting build system: {}", e.getMessage());
        }
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
