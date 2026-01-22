package com.swebench.service;

import org.eclipse.jgit.api.Git;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

/**
 * Service for running tests in Java projects.
 * Supports Maven and Gradle build systems.
 */
public class TestRunner {
    private static final Logger logger = LoggerFactory.getLogger(TestRunner.class);
    private static final int TIMEOUT_MINUTES = 10;

    /**
     * Setup repository by cloning and checking out specific commit
     */
    public File setupRepository(com.swebench.model.TaskInstance task) {
        try {
            // Create workspace directory
            File workspaceDir = new File("data/workspaces/" + task.getInstanceId());
            if (workspaceDir.exists()) {
                deleteDirectory(workspaceDir);
            }
            workspaceDir.mkdirs();

            // Clone repository
            logger.info("Cloning repository {} to {}", task.getRepo(), workspaceDir);

            String cloneUrl = "https://github.com/" + task.getRepo() + ".git";
            Git git = Git.cloneRepository()
                .setURI(cloneUrl)
                .setDirectory(workspaceDir)
                .call();

            // Checkout base commit
            git.checkout()
                .setName(task.getBaseCommit())
                .call();

            logger.info("Repository setup complete at {}", workspaceDir);
            return workspaceDir;

        } catch (Exception e) {
            logger.error("Failed to setup repository for {}: {}", task.getInstanceId(), e.getMessage(), e);
            return null;
        }
    }

    /**
     * Run tests and return results
     */
    public TestResult runTests(File repoDir, String testCommand, List<String> testCases) {
        if (testCommand == null || testCommand.isEmpty()) {
            logger.warn("No test command specified, attempting to detect");
            testCommand = detectTestCommand(repoDir);
        }

        logger.info("Running tests in {}", repoDir);
        logger.debug("Test command: {}", testCommand);
        logger.debug("Test cases: {}", testCases);

        try {
            // Build the test command
            String fullCommand = buildTestCommand(testCommand, testCases);
            logger.info("Executing: {}", fullCommand);

            // Execute tests - use cmd /c on Windows for proper command execution
            ProcessBuilder pb;
            boolean isWindows = System.getProperty("os.name").toLowerCase().contains("win");
            if (isWindows) {
                pb = new ProcessBuilder("cmd", "/c", fullCommand);
            } else {
                pb = new ProcessBuilder("sh", "-c", fullCommand);
            }
            pb.directory(repoDir);
            pb.redirectErrorStream(true);

            Process process = pb.start();

            // Capture output
            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append("\n");
                    logger.debug(line);
                }
            }

            // Wait for completion with timeout
            boolean completed = process.waitFor(TIMEOUT_MINUTES, java.util.concurrent.TimeUnit.MINUTES);

            if (!completed) {
                logger.error("Test execution timed out after {} minutes", TIMEOUT_MINUTES);
                process.destroyForcibly();
                return new TestResult(false, "Timeout", output.toString());
            }

            int exitCode = process.exitValue();
            boolean success = exitCode == 0;

            logger.info("Tests completed with exit code {}", exitCode);
            return new TestResult(success, output.toString(), parseTestResults(output.toString()));

        } catch (Exception e) {
            logger.error("Failed to run tests: {}", e.getMessage());
            return new TestResult(false, "Error: " + e.getMessage(), "");
        }
    }

    private String detectTestCommand(File repoDir) {
        boolean isWindows = System.getProperty("os.name").toLowerCase().contains("win");

        // Check for Maven
        if (new File(repoDir, "pom.xml").exists()) {
            logger.debug("Detected Maven project");
            // On Windows, use mvn.cmd; check MAVEN_HOME first
            if (isWindows) {
                String mavenHome = System.getenv("MAVEN_HOME");
                if (mavenHome != null && !mavenHome.isEmpty()) {
                    return mavenHome + "\\bin\\mvn.cmd test";
                }
                return "mvn.cmd test";
            }
            return "mvn test";
        }

        // Check for Gradle
        if (new File(repoDir, "build.gradle").exists() ||
            new File(repoDir, "build.gradle.kts").exists()) {
            logger.debug("Detected Gradle project");

            // Check for gradlew wrapper
            File gradlew = new File(repoDir, isWindows ? "gradlew.bat" : "gradlew");
            if (gradlew.exists()) {
                return isWindows ? "gradlew.bat test" : "./gradlew test";
            }
            return isWindows ? "gradle.bat test" : "gradle test";
        }

        logger.warn("Could not detect build system, defaulting to mvn test");
        return isWindows ? "mvn.cmd test" : "mvn test";
    }

    private String buildTestCommand(String baseCommand, List<String> testCases) {
        if (testCases == null || testCases.isEmpty()) {
            return baseCommand;
        }

        // Check if using auto-detection marker - this is problematic
        // Running ALL tests often fails due to unrelated issues
        if (testCases.size() == 1 && "__ALL_TESTS__".equals(testCases.get(0))) {
            logger.warn("Using __ALL_TESTS__ marker - this may cause false negatives");
            logger.info("Running with -DfailIfNoTests=false to be more lenient");
            // Add flag to not fail if specific tests aren't found
            if (baseCommand.contains("mvn")) {
                return baseCommand + " -DfailIfNoTests=false";
            }
            return baseCommand;
        }

        // For Maven: mvn test -Dtest=TestClass#testMethod
        if (baseCommand.contains("mvn")) {
            String tests = String.join(",", testCases);
            return baseCommand + " -Dtest=" + tests + " -DfailIfNoTests=false";
        }

        // For Gradle: ./gradlew test --tests TestClass.testMethod
        if (baseCommand.contains("gradle")) {
            StringBuilder cmd = new StringBuilder(baseCommand);
            for (String test : testCases) {
                cmd.append(" --tests ").append(test);
            }
            return cmd.toString();
        }

        return baseCommand;
    }

    private String parseTestResults(String output) {
        // Extract test summary from output
        StringBuilder summary = new StringBuilder();

        String[] lines = output.split("\n");
        for (String line : lines) {
            // Maven test results
            if (line.contains("Tests run:") || line.contains("Failures:") || line.contains("Errors:")) {
                summary.append(line).append("\n");
            }

            // Gradle test results
            if (line.contains("tests completed") || line.contains("failed") || line.contains("passed")) {
                summary.append(line).append("\n");
            }
        }

        return summary.toString();
    }

    /**
     * Cleanup workspace directory
     */
    public void cleanup(File repoDir) {
        try {
            if (repoDir != null && repoDir.exists()) {
                deleteDirectory(repoDir);
                logger.debug("Cleaned up workspace {}", repoDir);
            }
        } catch (Exception e) {
            logger.warn("Failed to cleanup workspace: {}", e.getMessage());
        }
    }

    private void deleteDirectory(File directory) {
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteDirectory(file);
                } else {
                    file.delete();
                }
            }
        }
        directory.delete();
    }

    /**
     * Result of test execution
     */
    public static class TestResult {
        private final boolean success;
        private final String output;
        private final String summary;
        private final List<String> failedTests;
        private final List<String> passedTests;

        public TestResult(boolean success, String output, String summary) {
            this.success = success;
            this.output = output;
            this.summary = summary;
            this.failedTests = new ArrayList<>();
            this.passedTests = new ArrayList<>();
        }

        public boolean isSuccess() {
            return success;
        }

        public boolean hasFailing() {
            return !success;
        }

        public boolean allPassing() {
            return success;
        }

        public String getOutput() {
            return output;
        }

        public String getSummary() {
            return summary;
        }

        public List<String> getFailedTests() {
            return failedTests;
        }

        public List<String> getPassedTests() {
            return passedTests;
        }
    }
}
