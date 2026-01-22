package com.swebench.pipeline;

import com.swebench.model.Repository;
import com.swebench.model.TaskInstance;
import com.swebench.service.GitHubService;
import com.swebench.service.PatchExtractor;
import com.swebench.service.QualityValidator;
import com.swebench.service.BugClassifier;
import com.swebench.util.ConfigLoader;
import com.swebench.util.PipelineLogger;
import com.swebench.util.FileLogger;
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
 * Stage 2: Attribute Filtering
 * Extracts issue-PR-test triplets from discovered repositories and validates:
 * - Issue has clear problem statement
 * - PR is linked to issue and merged
 * - PR contains code changes (not just docs)
 * - Tests are present and related to changes
 * - Changes are not too large (< 100 files)
 */
public class AttributeFilter {
    private static final Logger logger = LoggerFactory.getLogger(AttributeFilter.class);
    private static final String INPUT_FILE = "data/raw/discovered_repositories.json";
    private static final String OUTPUT_DIR = "data/processed";

    private final GitHubService gitHubService;
    private final PatchExtractor patchExtractor;
    private final QualityValidator qualityValidator;
    private final BugClassifier bugClassifier;
    private final ObjectMapper objectMapper;
    private final int targetTaskCount;
    private final int maxFilesChanged;

    public AttributeFilter() {
        this.gitHubService = new GitHubService();
        this.patchExtractor = new PatchExtractor();
        this.qualityValidator = new QualityValidator();
        this.bugClassifier = new BugClassifier();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        this.targetTaskCount = ConfigLoader.getInt("filter.target.task.count", 200);
        this.maxFilesChanged = ConfigLoader.getInt("filter.max.files.changed", 100);
    }

    public void execute() {
        PipelineLogger.startStage("Attribute Filtering");
        PipelineLogger.info("Target: " + targetTaskCount + " task instances");

        boolean success = false;
        try {
            // Step 1: Load repositories
            PipelineLogger.section("Loading Repositories");
            List<Repository> repositories = loadRepositories();

            if (repositories.isEmpty()) {
                PipelineLogger.fail("No repositories found. Run discovery stage first.",
                    PipelineLogger.ErrorCategory.CONFIG_ERROR);
                PipelineLogger.endStage(false);
                return;
            }
            PipelineLogger.success("Loaded " + repositories.size() + " repositories");

            // Step 2: Extract task candidates
            PipelineLogger.section("Extracting Task Candidates");
            List<TaskInstance> taskInstances = extractTaskInstances(repositories);

            if (taskInstances.isEmpty()) {
                PipelineLogger.fail("No task candidates extracted from PRs",
                    PipelineLogger.ErrorCategory.FILTER_REJECTED);
                PipelineLogger.warn("Repositories may not have linked PR-Issue pairs");
                PipelineLogger.endStage(false);
                return;
            }

            // Step 3: Filter tasks by quality
            PipelineLogger.section("Quality Filtering");
            List<TaskInstance> filteredTasks = filterTaskInstances(taskInstances);

            if (filteredTasks.isEmpty()) {
                PipelineLogger.fail("No tasks passed quality filters",
                    PipelineLogger.ErrorCategory.FILTER_REJECTED);
                PipelineLogger.warn("Try lowering filter.min.quality.score in config");
                PipelineLogger.endStage(false);
                return;
            }

            // Step 4: Save results
            PipelineLogger.section("Saving Results");
            saveResults(filteredTasks);

            generateReport(filteredTasks);
            success = true;

        } catch (Exception e) {
            logger.error("Attribute filtering failed", e);
            PipelineLogger.fail("Filtering crashed: " + e.getMessage(),
                PipelineLogger.ErrorCategory.UNKNOWN);
        }

        PipelineLogger.endStage(success);
    }

    private List<Repository> loadRepositories() throws IOException {
        File inputFile = new File(INPUT_FILE);
        if (!inputFile.exists()) {
            throw new IOException("Repository list not found at " + INPUT_FILE);
        }

        Repository[] repos = objectMapper.readValue(inputFile, Repository[].class);
        return List.of(repos);
    }

    private List<TaskInstance> extractTaskInstances(List<Repository> repositories) {
        List<TaskInstance> allTasks = new ArrayList<>();

        for (int i = 0; i < repositories.size(); i++) {
            Repository repo = repositories.get(i);
            PipelineLogger.progress(i + 1, repositories.size(), "Processing " + repo.getFullName());

            try {
                List<TaskInstance> repoTasks = gitHubService.extractTaskInstances(repo);
                PipelineLogger.info("Found " + repoTasks.size() + " PR-Issue pairs in " + repo.getFullName());

                allTasks.addAll(repoTasks);

                // Stop if we have enough candidates
                if (allTasks.size() >= targetTaskCount * 2) {
                    PipelineLogger.info("Reached candidate threshold (" + allTasks.size() + "), stopping extraction");
                    break;
                }

            } catch (Exception e) {
                PipelineLogger.warn("Failed to process " + repo.getFullName() + ": " + e.getMessage());
                logger.debug("Error details", e);
            }
        }

        PipelineLogger.success("Extracted " + allTasks.size() + " total task candidates");
        return allTasks;
    }

    private List<TaskInstance> filterTaskInstances(List<TaskInstance> tasks) {
        PipelineLogger.step("Applying quality filters to " + tasks.size() + " candidates...");
        PipelineLogger.info("Criteria: functional bug, problem statement, patch size, test coverage, quality >= 75");

        List<TaskInstance> qualified = new ArrayList<>();
        int rejectedNoProblem = 0;
        int rejectedNoPatch = 0;
        int rejectedTooLarge = 0;
        int rejectedNoTests = 0;
        int rejectedNonFunctional = 0;
        int rejectedLowQuality = 0;

        for (TaskInstance task : tasks) {
            if (qualified.size() >= targetTaskCount) {
                PipelineLogger.info("Reached target count, stopping filter");
                break;
            }

            // Check problem statement
            if (task.getProblemStatement() == null || task.getProblemStatement().length() < 50) {
                rejectedNoProblem++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "PROBLEM_STATEMENT", "Too short or missing");
                continue;
            }

            // Check patch exists
            if (task.getPatch() == null || task.getPatch().isEmpty()) {
                rejectedNoPatch++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "PATCH", "Missing patch");
                continue;
            }

            // Check patch size
            int filesChanged = countFilesInPatch(task.getPatch());
            if (filesChanged > maxFilesChanged) {
                rejectedTooLarge++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "PATCH_SIZE", filesChanged + " files changed");
                continue;
            }

            // Check has test changes
            if (!hasTestChanges(task.getPatch())) {
                rejectedNoTests++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "TEST_CHANGES", "No test modifications");
                continue;
            }

            // NEW: Bug classification - prioritize FUNCTIONAL bugs
            BugClassifier.BugType bugType = bugClassifier.classify(task);
            int functionalScore = bugClassifier.calculateFunctionalScore(task);

            if (bugType == BugClassifier.BugType.NON_FUNCTIONAL) {
                rejectedNonFunctional++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "BUG_TYPE",
                    "Non-functional (typo/doc/refactor). Score: " + functionalScore);
                continue;
            }

            // Quality validation
            if (!qualityValidator.isHighQuality(task)) {
                rejectedLowQuality++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "QUALITY", "Failed quality checks");
                continue;
            }

            int qualityScore = qualityValidator.calculateQualityScore(task);
            if (qualityScore < 75) {
                rejectedLowQuality++;
                FileLogger.logTaskFilter(task.getInstanceId(), false, "QUALITY_SCORE", "Score: " + qualityScore);
                continue;
            }

            // Task passed all filters!
            qualified.add(task);
            String rating = qualityValidator.getQualityRating(qualityScore);
            FileLogger.logTaskFilter(task.getInstanceId(), true, "ALL_FILTERS",
                "BugType: " + bugType + ", FuncScore: " + functionalScore + ", Quality: " + qualityScore);

            PipelineLogger.progress(qualified.size(), targetTaskCount, task.getInstanceId());
            PipelineLogger.success("Qualified: " + task.getInstanceId() +
                " (bug: " + bugType + ", funcScore: " + functionalScore + ", quality: " + qualityScore + ")");
        }

        // Log rejection summary
        PipelineLogger.section("Filter Results");
        PipelineLogger.info("Qualified tasks: " + qualified.size());
        if (rejectedNoProblem > 0) PipelineLogger.info("Rejected - no problem statement: " + rejectedNoProblem);
        if (rejectedNoPatch > 0) PipelineLogger.info("Rejected - no patch: " + rejectedNoPatch);
        if (rejectedTooLarge > 0) PipelineLogger.info("Rejected - too many files: " + rejectedTooLarge);
        if (rejectedNoTests > 0) PipelineLogger.info("Rejected - no test changes: " + rejectedNoTests);
        if (rejectedNonFunctional > 0) PipelineLogger.info("Rejected - non-functional bug: " + rejectedNonFunctional);
        if (rejectedLowQuality > 0) PipelineLogger.info("Rejected - low quality: " + rejectedLowQuality);

        return qualified;
    }

    private int countFilesInPatch(String patch) {
        if (patch == null) return 0;
        return patch.split("diff --git").length - 1;
    }

    private boolean hasTestChanges(String patch) {
        if (patch == null) return false;
        String lowerPatch = patch.toLowerCase();
        return lowerPatch.contains("test") ||
               lowerPatch.contains("junit") ||
               lowerPatch.contains("assert");
    }

    private void saveResults(List<TaskInstance> tasks) throws IOException {
        File outputDir = new File(OUTPUT_DIR);
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }

        File outputFile = new File(outputDir, "candidate_tasks.json");
        objectMapper.writeValue(outputFile, tasks);

        PipelineLogger.success("Saved " + tasks.size() + " tasks to " + outputFile.getPath());
    }

    private void generateReport(List<TaskInstance> tasks) {
        PipelineLogger.section("Attribute Filter Report");

        long mavenTasks = tasks.stream()
            .filter(t -> "maven".equalsIgnoreCase(t.getBuildTool()))
            .count();
        long gradleTasks = tasks.stream()
            .filter(t -> "gradle".equalsIgnoreCase(t.getBuildTool()))
            .count();

        long uniqueRepos = tasks.stream()
            .map(TaskInstance::getRepo)
            .distinct()
            .count();

        PipelineLogger.info("Total qualified tasks: " + tasks.size());
        PipelineLogger.info("Maven tasks: " + mavenTasks);
        PipelineLogger.info("Gradle tasks: " + gradleTasks);
        PipelineLogger.info("From " + uniqueRepos + " unique repositories");
    }
}
