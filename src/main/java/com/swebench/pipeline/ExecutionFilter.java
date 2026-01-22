package com.swebench.pipeline;

import com.swebench.model.TaskInstance;
import com.swebench.service.TestRunner;
import com.swebench.service.PatchApplier;
import com.swebench.service.QualityValidator;
import com.swebench.util.PipelineLogger;
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
 */
public class ExecutionFilter {
    private static final Logger logger = LoggerFactory.getLogger(ExecutionFilter.class);
    private static final String INPUT_FILE = "data/processed/candidate_tasks.json";
    private static final String OUTPUT_DIR = "data/tasks";

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
        PipelineLogger.startStage("Execution Validation");

        boolean success = false;
        try {
            // Step 1: Load candidates
            PipelineLogger.section("Loading Candidate Tasks");
            List<TaskInstance> candidateTasks = loadCandidateTasks();

            if (candidateTasks.isEmpty()) {
                PipelineLogger.fail("No candidate tasks found. Run attribute filter stage first.",
                    PipelineLogger.ErrorCategory.CONFIG_ERROR);
                PipelineLogger.endStage(false);
                return;
            }
            PipelineLogger.success("Loaded " + candidateTasks.size() + " candidate tasks");

            // Step 2: Validate each task
            PipelineLogger.section("Validating Tasks");
            PipelineLogger.info("Running fail-to-pass tests on each task...");
            List<TaskInstance> validatedTasks = validateTasks(candidateTasks);

            // Step 3: Save results
            PipelineLogger.section("Saving Results");
            saveResults(validatedTasks);

            generateReport(validatedTasks, candidateTasks.size());
            success = validatedTasks.size() > 0;

        } catch (Exception e) {
            logger.error("Execution filtering failed", e);
            PipelineLogger.fail("Execution crashed: " + e.getMessage(),
                PipelineLogger.ErrorCategory.UNKNOWN);
        }

        PipelineLogger.endStage(success);
    }

    private List<TaskInstance> loadCandidateTasks() throws IOException {
        File inputFile = new File(INPUT_FILE);
        if (!inputFile.exists()) {
            throw new IOException("Candidate tasks not found at " + INPUT_FILE);
        }

        TaskInstance[] tasks = objectMapper.readValue(inputFile, TaskInstance[].class);
        return List.of(tasks);
    }

    private List<TaskInstance> validateTasks(List<TaskInstance> tasks) {
        List<TaskInstance> validated = new ArrayList<>();

        for (int i = 0; i < tasks.size(); i++) {
            TaskInstance task = tasks.get(i);
            PipelineLogger.progress(i + 1, tasks.size(), task.getInstanceId());
            PipelineLogger.section("Validating: " + task.getInstanceId());

            try {
                ValidationResult result = validateTask(task);

                if (result.success) {
                    validated.add(task);
                    PipelineLogger.success("VALIDATED: " + task.getInstanceId());
                } else {
                    PipelineLogger.fail(task.getInstanceId() + ": " + result.failureReason,
                        result.errorCategory);
                }
            } catch (Exception e) {
                PipelineLogger.fail(task.getInstanceId() + ": Exception - " + e.getMessage(),
                    PipelineLogger.ErrorCategory.UNKNOWN);
                logger.debug("Error details", e);
            }
        }

        return validated;
    }

    private ValidationResult validateTask(TaskInstance task) {
        // Pre-validation: Check fail-to-pass test structure
        if (!qualityValidator.hasValidFailToPassTests(task)) {
            return ValidationResult.failed("Invalid FAIL_TO_PASS test structure",
                PipelineLogger.ErrorCategory.FILTER_REJECTED);
        }
        PipelineLogger.step("Test structure validated");

        // Clone repository and checkout base commit
        PipelineLogger.step("Cloning repository...");
        File repoDir = testRunner.setupRepository(task);
        if (repoDir == null) {
            return ValidationResult.failed("Failed to clone repository",
                PipelineLogger.ErrorCategory.CLONE_FAILED);
        }
        PipelineLogger.info("Repository cloned to: " + repoDir.getPath());

        try {
            // Step 1: Verify tests fail at base commit (CRITICAL)
            PipelineLogger.step("Running tests at BASE commit (should FAIL)...");
            TestRunner.TestResult baseResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!baseResult.hasFailing()) {
                return ValidationResult.failed("Tests did NOT fail at base commit (false positive)",
                    PipelineLogger.ErrorCategory.TEST_FAILED);
            }
            PipelineLogger.info("Tests correctly FAIL at base commit");

            // Step 2: Apply patch
            PipelineLogger.step("Applying patch...");
            if (!patchApplier.applyPatch(repoDir, task.getPatch())) {
                return ValidationResult.failed("Failed to apply patch",
                    PipelineLogger.ErrorCategory.PATCH_FAILED);
            }
            PipelineLogger.info("Patch applied successfully");

            // Step 3: Verify tests pass after patch (CRITICAL)
            PipelineLogger.step("Running tests AFTER patch (should PASS)...");
            TestRunner.TestResult patchResult = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!patchResult.allPassing()) {
                return ValidationResult.failed("Tests still failing after patch",
                    PipelineLogger.ErrorCategory.TEST_FAILED);
            }
            PipelineLogger.info("Tests now PASS after patch");

            // Step 4: Verify PASS_TO_PASS tests still pass (NO REGRESSION)
            if (task.getPassToPass() != null && !task.getPassToPass().isEmpty()) {
                PipelineLogger.step("Running regression tests...");
                TestRunner.TestResult regressionCheck = testRunner.runTests(
                    repoDir,
                    task.getTestCommand(),
                    task.getPassToPass()
                );

                if (!regressionCheck.allPassing()) {
                    return ValidationResult.failed("PASS_TO_PASS tests broken (regression)",
                        PipelineLogger.ErrorCategory.TEST_FAILED);
                }
                PipelineLogger.info("No regression detected");
            }

            // Step 5: Stability check
            PipelineLogger.step("Re-running tests for stability check...");
            TestRunner.TestResult stabilityCheck = testRunner.runTests(
                repoDir,
                task.getTestCommand(),
                task.getFailToPass()
            );

            if (!stabilityCheck.allPassing()) {
                return ValidationResult.failed("Tests are flaky (not stable)",
                    PipelineLogger.ErrorCategory.TEST_FAILED);
            }
            PipelineLogger.info("Tests are stable");

            return ValidationResult.success();

        } finally {
            // Cleanup
            PipelineLogger.step("Cleaning up workspace...");
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

        PipelineLogger.success("Saved " + tasks.size() + " validated tasks to " + outputDir.getPath());
    }

    private void generateReport(List<TaskInstance> tasks, int totalCandidates) {
        PipelineLogger.section("Execution Validation Report");

        double successRate = totalCandidates > 0 ?
            (tasks.size() * 100.0 / totalCandidates) : 0;

        PipelineLogger.info("Candidates: " + totalCandidates);
        PipelineLogger.info("Validated: " + tasks.size());
        PipelineLogger.info("Success rate: " + String.format("%.1f%%", successRate));

        if (!tasks.isEmpty()) {
            long mavenTasks = tasks.stream()
                .filter(t -> "maven".equalsIgnoreCase(t.getBuildTool()))
                .count();
            long gradleTasks = tasks.stream()
                .filter(t -> "gradle".equalsIgnoreCase(t.getBuildTool()))
                .count();

            PipelineLogger.info("Maven tasks: " + mavenTasks);
            PipelineLogger.info("Gradle tasks: " + gradleTasks);

            // Group by repo
            PipelineLogger.info("Tasks per repository:");
            tasks.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                    TaskInstance::getRepo,
                    java.util.stream.Collectors.counting()
                ))
                .forEach((repo, count) ->
                    PipelineLogger.info("  " + repo + ": " + count)
                );
        }
    }

    /**
     * Result of task validation
     */
    private static class ValidationResult {
        boolean success;
        String failureReason;
        PipelineLogger.ErrorCategory errorCategory;

        static ValidationResult success() {
            ValidationResult r = new ValidationResult();
            r.success = true;
            return r;
        }

        static ValidationResult failed(String reason, PipelineLogger.ErrorCategory category) {
            ValidationResult r = new ValidationResult();
            r.success = false;
            r.failureReason = reason;
            r.errorCategory = category;
            return r;
        }
    }
}
