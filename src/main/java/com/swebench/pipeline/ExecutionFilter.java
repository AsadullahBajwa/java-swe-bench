package com.swebench.pipeline;

import com.swebench.model.TaskInstance;
import com.swebench.service.TestRunner;
import com.swebench.service.PatchApplier;
import com.swebench.service.QualityValidator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Stage 3: Execution Filtering
 * Validates task instances through execution:
 * - Tests fail at base commit
 * - Tests pass after applying patch
 * - No other tests break (PASS_TO_PASS maintained)
 * - Build succeeds in both states
 *
 * This is the final validation stage that ensures task quality.
 */
public class ExecutionFilter {
    private static final Logger logger = LoggerFactory.getLogger(ExecutionFilter.class);
    private static final String INPUT_FILE = "data/processed/candidate_tasks.json";
    private static final String OUTPUT_DIR = "data/tasks";
    private static final int MAX_RETRIES = 2;

    private final TestRunner testRunner;
    private final PatchApplier patchApplier;
    private final QualityValidator qualityValidator;
    private final ObjectMapper objectMapper;

    public ExecutionFilter() {
        this.testRunner = new TestRunner();
        this.patchApplier = new PatchApplier();
        this.qualityValidator = new QualityValidator();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
    }

    public void execute() {
        logger.info("Starting execution filtering stage");

        try {
            List<TaskInstance> candidateTasks = loadCandidateTasks();
            List<TaskInstance> validatedTasks = validateTasks(candidateTasks);

            logger.info("Validated {} tasks out of {} candidates",
                validatedTasks.size(), candidateTasks.size());

            saveResults(validatedTasks);
            generateReport(validatedTasks);

        } catch (Exception e) {
            logger.error("Execution filtering failed", e);
            throw new RuntimeException("Execution filtering stage failed", e);
        }
    }

    private List<TaskInstance> loadCandidateTasks() throws IOException {
        File inputFile = new File(INPUT_FILE);
        if (!inputFile.exists()) {
            throw new IOException("Candidate tasks not found. Run attribute filter stage first.");
        }

        TaskInstance[] tasks = objectMapper.readValue(inputFile, TaskInstance[].class);
        logger.info("Loaded {} candidate tasks from {}", tasks.length, INPUT_FILE);

        return List.of(tasks);
    }

    private List<TaskInstance> validateTasks(List<TaskInstance> tasks) {
        logger.info("Validating {} task instances through execution...", tasks.size());

        List<TaskInstance> validated = new ArrayList<>();
        int processed = 0;

        for (TaskInstance task : tasks) {
            processed++;
            logger.info("Validating task {}/{}: {}", processed, tasks.size(), task.getInstanceId());

            try {
                if (validateTask(task)) {
                    logger.info("Task {} passed validation", task.getInstanceId());
                    validated.add(task);
                } else {
                    logger.warn("Task {} failed validation", task.getInstanceId());
                }
            } catch (Exception e) {
                logger.error("Error validating task {}: {}", task.getInstanceId(), e.getMessage());
            }
        }

        return validated;
    }

    private boolean validateTask(TaskInstance task) {
        logger.debug("Setting up environment for {}", task.getInstanceId());

        // Check if this task has split patches (test_patch + code_patch)
        boolean useSplitPatch = task.getTestPatch() != null && !task.getTestPatch().isEmpty();

        if (useSplitPatch) {
            return validateTaskWithSplitPatch(task);
        } else {
            return validateTaskLegacy(task);
        }
    }

    /**
     * NEW: Split-patch validation approach.
     * 1. Apply test_patch at base commit
     * 2. Run tests → expect FAIL (new tests, old buggy code)
     * 3. Apply code_patch
     * 4. Run tests → expect PASS (new tests, fixed code)
     */
    private boolean validateTaskWithSplitPatch(TaskInstance task) {
        logger.info("Using SPLIT-PATCH validation for {}", task.getInstanceId());

        // Clone repository and checkout base commit
        File repoDir = testRunner.setupRepository(task);
        if (repoDir == null) {
            logger.warn("Failed to setup repository for {}", task.getInstanceId());
            return false;
        }

        try {
            // Step 1: Apply TEST patch at base commit
            logger.info("Step 1: Applying TEST patch for {}", task.getInstanceId());
            if (!patchApplier.applyPatch(repoDir, task.getTestPatch())) {
                logger.warn("❌ Task {} REJECTED: Failed to apply test patch", task.getInstanceId());
                return false;
            }
            logger.info("✓ Test patch applied successfully");

            // Step 2: Run tests - should FAIL (new tests + old buggy code)
            logger.info("Step 2: Running tests (expect FAIL) for {}", task.getInstanceId());
            TestRunner.TestResult testPatchResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!testPatchResult.hasFailing()) {
                logger.warn("❌ Task {} REJECTED: Tests did NOT fail after test patch (expected failure)",
                    task.getInstanceId());
                return false;
            }
            logger.info("✓ Tests correctly FAIL after test patch (new tests expose bug)");

            // Step 3: Apply CODE patch (the fix)
            logger.info("Step 3: Applying CODE patch for {}", task.getInstanceId());
            if (!patchApplier.applyPatch(repoDir, task.getPatch())) {
                logger.warn("❌ Task {} REJECTED: Failed to apply code patch", task.getInstanceId());
                return false;
            }
            logger.info("✓ Code patch applied successfully");

            // Step 4: Run tests - should PASS (new tests + fixed code)
            logger.info("Step 4: Running tests (expect PASS) for {}", task.getInstanceId());
            TestRunner.TestResult codePatchResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!codePatchResult.allPassing()) {
                logger.warn("❌ Task {} REJECTED: Tests still failing after code patch", task.getInstanceId());
                logger.warn("Test output: {}", codePatchResult.getSummary());
                return false;
            }
            logger.info("✓ Tests PASS after code patch (FAIL → PASS verified)");

            // Step 5: Stability check - run tests again
            logger.info("Step 5: Stability check for {}", task.getInstanceId());
            TestRunner.TestResult stabilityCheck = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!stabilityCheck.allPassing()) {
                logger.warn("❌ Task {} REJECTED: Tests are flaky", task.getInstanceId());
                return false;
            }
            logger.info("✓ Tests are stable");

            logger.info("✅ Task {} VALIDATED with split-patch approach", task.getInstanceId());
            return true;

        } finally {
            testRunner.cleanup(repoDir);
        }
    }

    /**
     * Legacy validation (original approach).
     * Used when task doesn't have split patches.
     */
    private boolean validateTaskLegacy(TaskInstance task) {
        logger.info("Using LEGACY validation for {}", task.getInstanceId());

        // Pre-validation: Check fail-to-pass test structure
        if (!qualityValidator.hasValidFailToPassTests(task)) {
            logger.warn("Task {} has invalid FAIL_TO_PASS structure", task.getInstanceId());
            return false;
        }

        // Clone repository and checkout base commit
        File repoDir = testRunner.setupRepository(task);
        if (repoDir == null) {
            logger.warn("Failed to setup repository for {}", task.getInstanceId());
            return false;
        }

        try {
            // Step 1: Verify tests fail at base commit (CRITICAL)
            logger.info("Running FAIL_TO_PASS tests at base commit for {}", task.getInstanceId());
            TestRunner.TestResult baseResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!baseResult.hasFailing()) {
                logger.warn("❌ Task {} REJECTED: Tests did NOT fail at base commit (false positive)",
                    task.getInstanceId());
                return false;
            }

            logger.info("✓ Tests correctly fail at base commit");

            // Step 2: Apply patch
            logger.info("Applying patch for {}", task.getInstanceId());
            if (!patchApplier.applyPatch(repoDir, task.getPatch())) {
                logger.warn("❌ Task {} REJECTED: Failed to apply patch", task.getInstanceId());
                return false;
            }

            logger.info("✓ Patch applied successfully");

            // Step 3: Verify tests pass after patch (CRITICAL)
            logger.info("Running FAIL_TO_PASS tests after patch for {}", task.getInstanceId());
            TestRunner.TestResult patchResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!patchResult.allPassing()) {
                logger.warn("❌ Task {} REJECTED: Tests still failing after patch", task.getInstanceId());
                logger.warn("Test output: {}", patchResult.getSummary());
                return false;
            }

            logger.info("✓ Tests pass after patch (FAIL → PASS verified)");

            // Step 4: Verify PASS_TO_PASS tests still pass (NO REGRESSION)
            if (task.getPassToPass() != null && !task.getPassToPass().isEmpty()) {
                logger.info("Running PASS_TO_PASS tests for {}", task.getInstanceId());
                TestRunner.TestResult regressionCheck = testRunner.runTests(
                    repoDir,
                    task.getTestCommand(),
                    task.getPassToPass()
                );

                if (!regressionCheck.allPassing()) {
                    logger.warn("❌ Task {} REJECTED: PASS_TO_PASS tests broken (regression detected)",
                        task.getInstanceId());
                    return false;
                }

                logger.info("✓ No regression (PASS → PASS maintained)");
            }

            // Step 5: Run validation again to ensure consistency (test stability)
            logger.info("Re-running FAIL_TO_PASS tests to verify stability for {}", task.getInstanceId());
            TestRunner.TestResult stabilityCheck = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!stabilityCheck.allPassing()) {
                logger.warn("❌ Task {} REJECTED: Tests are flaky (not stable)", task.getInstanceId());
                return false;
            }

            logger.info("✓ Tests are stable");

            logger.info("✅ Task {} VALIDATED: All checks passed", task.getInstanceId());
            return true;

        } finally {
            // Cleanup
            testRunner.cleanup(repoDir);
        }
    }

    private void saveResults(List<TaskInstance> tasks) throws IOException {
        File outputDir = new File(OUTPUT_DIR);
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }

        // Save complete validated dataset
        File outputFile = new File(outputDir, "validated_tasks.json");
        objectMapper.writeValue(outputFile, tasks);

        // Save individual task files
        for (TaskInstance task : tasks) {
            File taskFile = new File(outputDir, task.getInstanceId() + ".json");
            objectMapper.writeValue(taskFile, task);
        }

        logger.info("Saved {} validated tasks to {}", tasks.size(), outputDir.getPath());
    }

    private void generateReport(List<TaskInstance> tasks) {
        logger.info("=== Execution Filtering Report ===");
        logger.info("Total validated tasks: {}", tasks.size());

        // Count by repository
        tasks.stream()
            .collect(java.util.stream.Collectors.groupingBy(
                TaskInstance::getRepo,
                java.util.stream.Collectors.counting()
            ))
            .forEach((repo, count) ->
                logger.info("  {}: {} tasks", repo, count)
            );

        // Count by build tool
        long mavenTasks = tasks.stream()
            .filter(t -> "maven".equalsIgnoreCase(t.getBuildTool()))
            .count();
        long gradleTasks = tasks.stream()
            .filter(t -> "gradle".equalsIgnoreCase(t.getBuildTool()))
            .count();

        logger.info("Maven tasks: {}", mavenTasks);
        logger.info("Gradle tasks: {}", gradleTasks);
        logger.info("===================================");
    }
}
