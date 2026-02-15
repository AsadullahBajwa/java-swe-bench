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

            // Execute tests - use cmd.exe on Windows for batch scripts
            ProcessBuilder pb;
            boolean isWindows = System.getProperty("os.name").toLowerCase().contains("windows");
            if (isWindows) {
                pb = new ProcessBuilder("cmd.exe", "/c", fullCommand);
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
        boolean isWindows = System.getProperty("os.name").toLowerCase().contains("windows");

        // Check for Maven
        if (new File(repoDir, "pom.xml").exists()) {
            logger.debug("Detected Maven project");
            return "mvn test";
        }

        // Check for Gradle
        if (new File(repoDir, "build.gradle").exists() ||
            new File(repoDir, "build.gradle.kts").exists()) {
            logger.debug("Detected Gradle project");

            // Check for gradlew wrapper
            if (isWindows) {
                File gradlewBat = new File(repoDir, "gradlew.bat");
                if (gradlewBat.exists()) {
                    return "gradlew.bat test";
                }
            } else {
                File gradlew = new File(repoDir, "gradlew");
                if (gradlew.exists()) {
                    return "./gradlew test";
                }
            }
            return "gradle test";
        }

        logger.warn("Could not detect build system, defaulting to mvn test");
        return "mvn test";
    }

    private String buildTestCommand(String baseCommand, List<String> testCases) {
        if (testCases == null || testCases.isEmpty()) {
            return baseCommand;
        }

        // Check if using auto-detection marker - run all tests
        if (testCases.size() == 1 && "__ALL_TESTS__".equals(testCases.get(0))) {
            logger.info("Using __ALL_TESTS__ marker - running full test suite");
            return baseCommand; // Run all tests without filtering
        }

        // For Maven: mvn test -Dtest=TestClass#testMethod
        if (baseCommand.contains("mvn")) {
            String tests = String.join(",", testCases);
            return baseCommand + " -Dtest=" + tests;
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
                    // Make file writable (required for .git files on Windows)
                    file.setWritable(true);
                    if (!file.delete()) {
                        logger.warn("Failed to delete file: {}", file.getAbsolutePath());
                    }
                }
            }
        }
        directory.setWritable(true);
        if (!directory.delete()) {
            logger.warn("Failed to delete directory: {}", directory.getAbsolutePath());
        }
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
