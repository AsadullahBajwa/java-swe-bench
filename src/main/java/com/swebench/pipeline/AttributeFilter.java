package com.swebench.pipeline;

import com.swebench.model.Repository;
import com.swebench.model.TaskInstance;
import com.swebench.service.GitHubService;
import com.swebench.service.PatchExtractor;
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
 * Stage 2: Attribute Filtering
 * Extracts issue-PR-test triplets from discovered repositories and validates:
 * - Issue has clear problem statement
 * - PR is linked to issue and merged
 * - PR contains code changes (not just docs)
 * - Tests are present and related to changes
 * - Changes are not too large (< 100 files)
 *
 * Extraction Modes:
 * - SPLIT_PATCH: PRs with BOTH test and code changes. Patches are split for validation.
 * - CODE_ONLY: PRs that only modify source files, existing tests found by naming.
 * - ORIGINAL: Legacy mode extracting all PRs with linked issues.
 */
public class AttributeFilter {
    private static final Logger logger = LoggerFactory.getLogger(AttributeFilter.class);
    private static final String INPUT_FILE = "data/raw/discovered_repositories.json";
    private static final String OUTPUT_DIR = "data/processed";
    private static final int TARGET_TASK_COUNT = 200;
    private static final int MAX_FILES_CHANGED = 100;
    private static final int MAX_PRS_PER_REPO = 300; // How many PRs to check per repo

    public enum ExtractionMode {
        SPLIT_PATCH,  // PRs with both test+code changes (recommended)
        CODE_ONLY,    // PRs with only code changes (find existing tests)
        ORIGINAL      // Legacy mode
    }

    private final ExtractionMode extractionMode;
    private final boolean codeOnlyMode; // For backward compatibility

    private final GitHubService gitHubService;
    private final PatchExtractor patchExtractor;
    private final QualityValidator qualityValidator;
    private final ObjectMapper objectMapper;

    public AttributeFilter() {
        this(ExtractionMode.SPLIT_PATCH); // Default to split-patch mode
    }

    public AttributeFilter(boolean codeOnlyMode) {
        this(codeOnlyMode ? ExtractionMode.CODE_ONLY : ExtractionMode.ORIGINAL);
    }

    public AttributeFilter(ExtractionMode mode) {
        this.extractionMode = mode;
        this.codeOnlyMode = (mode == ExtractionMode.CODE_ONLY);
        this.gitHubService = new GitHubService();
        this.patchExtractor = new PatchExtractor();
        this.qualityValidator = new QualityValidator();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);

        logger.info("AttributeFilter initialized in {} mode", mode);
    }

    public void execute() {
        logger.info("Starting attribute filtering stage");
        logger.info("Target: {} task instances", TARGET_TASK_COUNT);

        try {
            List<Repository> repositories = loadRepositories();
            List<TaskInstance> taskInstances = extractTaskInstances(repositories);
            List<TaskInstance> filteredTasks = filterTaskInstances(taskInstances);

            logger.info("Extracted {} total task instances", taskInstances.size());
            logger.info("Qualified {} tasks after attribute filtering", filteredTasks.size());

            saveResults(filteredTasks);
            generateReport(filteredTasks);

        } catch (Exception e) {
            logger.error("Attribute filtering failed", e);
            throw new RuntimeException("Attribute filtering stage failed", e);
        }
    }

    private List<Repository> loadRepositories() throws IOException {
        File inputFile = new File(INPUT_FILE);
        if (!inputFile.exists()) {
            throw new IOException("Repository list not found. Run discovery stage first.");
        }

        Repository[] repos = objectMapper.readValue(inputFile, Repository[].class);
        logger.info("Loaded {} repositories from {}", repos.length, INPUT_FILE);

        return List.of(repos);
    }

    private List<TaskInstance> extractTaskInstances(List<Repository> repositories) {
        switch (extractionMode) {
            case SPLIT_PATCH:
                return extractSplitPatchTaskInstances(repositories);
            case CODE_ONLY:
                return extractCodeOnlyTaskInstances(repositories);
            case ORIGINAL:
            default:
                return extractOriginalTaskInstances(repositories);
        }
    }

    /**
     * Extract SPLIT-PATCH tasks (recommended mode).
     * These are PRs that have BOTH test and code changes.
     * The patch is split into test_patch and code_patch for proper validation.
     */
    private List<TaskInstance> extractSplitPatchTaskInstances(List<Repository> repositories) {
        logger.info("=== SPLIT-PATCH MODE ===");
        logger.info("Looking for PRs with BOTH test and code changes");
        logger.info("Patches will be split for proper fail-to-pass validation");

        List<TaskInstance> allTasks = new ArrayList<>();

        for (Repository repo : repositories) {
            try {
                logger.info("Processing repository: {} (split-patch mode)", repo.getFullName());

                // Use the new split-patch extraction method
                List<TaskInstance> repoTasks = gitHubService.extractSplitPatchTasks(repo, MAX_PRS_PER_REPO);

                logger.info("Extracted {} split-patch task candidates from {}",
                    repoTasks.size(), repo.getFullName());

                allTasks.addAll(repoTasks);

                // Stop if we have enough candidates
                if (allTasks.size() >= TARGET_TASK_COUNT * 2) {
                    logger.info("Reached candidate threshold, stopping extraction");
                    break;
                }

            } catch (Exception e) {
                logger.warn("Failed to process repository {}: {}",
                    repo.getFullName(), e.getMessage());
            }
        }

        logger.info("Total split-patch tasks extracted: {}", allTasks.size());
        return allTasks;
    }

    /**
     * Extract CODE-ONLY tasks (Option 1).
     * These are PRs that modify source files but NOT test files.
     * Existing test classes are discovered by naming convention.
     */
    private List<TaskInstance> extractCodeOnlyTaskInstances(List<Repository> repositories) {
        logger.info("=== CODE-ONLY MODE (Option 1) ===");
        logger.info("Looking for PRs that only modify source files (no test changes)");
        logger.info("Will find existing test classes by naming convention");

        List<TaskInstance> allTasks = new ArrayList<>();

        for (Repository repo : repositories) {
            try {
                logger.info("Processing repository: {} (code-only mode)", repo.getFullName());

                // Use the new code-only extraction method
                List<TaskInstance> repoTasks = gitHubService.extractCodeOnlyTaskInstances(repo, MAX_PRS_PER_REPO);

                logger.info("Extracted {} code-only task candidates from {}",
                    repoTasks.size(), repo.getFullName());

                allTasks.addAll(repoTasks);

                // Stop if we have enough candidates
                if (allTasks.size() >= TARGET_TASK_COUNT * 2) {
                    logger.info("Reached candidate threshold, stopping extraction");
                    break;
                }

            } catch (Exception e) {
                logger.warn("Failed to process repository {}: {}",
                    repo.getFullName(), e.getMessage());
            }
        }

        logger.info("Total code-only tasks extracted: {}", allTasks.size());
        return allTasks;
    }

    /**
     * Original extraction method (for comparison/fallback).
     */
    private List<TaskInstance> extractOriginalTaskInstances(List<Repository> repositories) {
        logger.info("Extracting task instances from repositories (original mode)...");

        List<TaskInstance> allTasks = new ArrayList<>();

        for (Repository repo : repositories) {
            try {
                logger.info("Processing repository: {}", repo.getFullName());

                // Get merged PRs that reference issues
                List<TaskInstance> repoTasks = gitHubService.extractTaskInstances(repo);

                logger.info("Extracted {} task candidates from {}",
                    repoTasks.size(), repo.getFullName());

                allTasks.addAll(repoTasks);

                // Stop if we have enough candidates
                if (allTasks.size() >= TARGET_TASK_COUNT * 2) {
                    logger.info("Reached candidate threshold, stopping extraction");
                    break;
                }

            } catch (Exception e) {
                logger.warn("Failed to process repository {}: {}",
                    repo.getFullName(), e.getMessage());
            }
        }

        return allTasks;
    }

    private List<TaskInstance> filterTaskInstances(List<TaskInstance> tasks) {
        logger.info("Applying attribute filters to {} tasks...", tasks.size());

        List<TaskInstance> qualified = new ArrayList<>();

        for (TaskInstance task : tasks) {
            if (qualified.size() >= TARGET_TASK_COUNT) {
                break;
            }

            if (passesAttributeFilters(task)) {
                logger.debug("Task qualified: {}", task.getInstanceId());
                qualified.add(task);
            } else {
                logger.debug("Task rejected: {}", task.getInstanceId());
            }
        }

        return qualified;
    }

    private boolean passesAttributeFilters(TaskInstance task) {
        // Basic checks first
        if (task.getProblemStatement() == null ||
            task.getProblemStatement().length() < 20) { // Relaxed for more tasks
            logger.debug("Task {} rejected: insufficient problem statement", task.getInstanceId());
            return false;
        }

        if (task.getPatch() == null || task.getPatch().isEmpty()) {
            logger.debug("Task {} rejected: no patch", task.getInstanceId());
            return false;
        }

        // Check patch size is reasonable
        int filesChanged = countFilesInPatch(task.getPatch());
        if (filesChanged > MAX_FILES_CHANGED) {
            logger.debug("Task {} has too many files changed: {}",
                task.getInstanceId(), filesChanged);
            return false;
        }

        // Mode-specific validation
        switch (extractionMode) {
            case SPLIT_PATCH:
                return passesSplitPatchFilters(task);
            case CODE_ONLY:
                return passesCodeOnlyFilters(task);
            case ORIGINAL:
            default:
                return passesOriginalFilters(task);
        }
    }

    /**
     * Filters for SPLIT_PATCH mode.
     * Task must have both test_patch and code_patch (patch field).
     */
    private boolean passesSplitPatchFilters(TaskInstance task) {
        // Must have test_patch
        if (task.getTestPatch() == null || task.getTestPatch().isEmpty()) {
            logger.debug("Task {} rejected: no test_patch", task.getInstanceId());
            return false;
        }

        // Must have code patch (stored in patch field)
        if (task.getPatch() == null || task.getPatch().isEmpty()) {
            logger.debug("Task {} rejected: no code patch", task.getInstanceId());
            return false;
        }

        // Must have test classes identified
        if (task.getFailToPass() == null || task.getFailToPass().isEmpty()) {
            logger.debug("Task {} rejected: no test classes identified", task.getInstanceId());
            return false;
        }

        logger.info("Task {} passed split-patch filters (test_patch: {} chars, code_patch: {} chars, {} test classes)",
                   task.getInstanceId(),
                   task.getTestPatch().length(),
                   task.getPatch().length(),
                   task.getFailToPass().size());
        return true;
    }

    /**
     * Filters for CODE_ONLY mode.
     */
    private boolean passesCodeOnlyFilters(TaskInstance task) {
        // Must have existing test classes identified
        if (task.getFailToPass() == null || task.getFailToPass().isEmpty()) {
            logger.debug("Task {} rejected: no existing test classes found", task.getInstanceId());
            return false;
        }

        // Verify it's actually code-only (no test changes)
        if (hasTestChanges(task.getPatch())) {
            logger.debug("Task {} rejected: has test changes (not code-only)", task.getInstanceId());
            return false;
        }

        // Must have source code changes
        if (!hasSourceChanges(task.getPatch())) {
            logger.debug("Task {} rejected: no source code changes", task.getInstanceId());
            return false;
        }

        logger.info("Task {} passed code-only filters with {} existing test classes",
                   task.getInstanceId(), task.getFailToPass().size());
        return true;
    }

    /**
     * Filters for ORIGINAL mode.
     */
    private boolean passesOriginalFilters(TaskInstance task) {
        // Original mode: Check has test-related changes
        if (!hasTestChanges(task.getPatch())) {
            logger.debug("Task {} rejected: no test changes", task.getInstanceId());
            return false;
        }

        // HIGH-QUALITY FILTER: Use QualityValidator for comprehensive checks
        if (!qualityValidator.isHighQuality(task)) {
            logger.debug("Task {} rejected by quality validator", task.getInstanceId());
            return false;
        }

        // Calculate and log quality score
        int qualityScore = qualityValidator.calculateQualityScore(task);
        String rating = qualityValidator.getQualityRating(qualityScore);
        logger.info("Task {} quality: {} (score: {})", task.getInstanceId(), rating, qualityScore);

        // Only accept high-quality tasks (score >= 75)
        if (qualityScore < 75) {
            logger.debug("Task {} quality score too low: {}", task.getInstanceId(), qualityScore);
            return false;
        }

        return true;
    }

    /**
     * Check if patch has source code changes (Java files in main source directories).
     */
    private boolean hasSourceChanges(String patch) {
        if (patch == null) return false;

        String[] lines = patch.split("\n");
        for (String line : lines) {
            if (line.startsWith("+++ b/")) {
                String filePath = line.substring(6).trim().toLowerCase();

                // Check if it's a Java source file (not test)
                if (filePath.endsWith(".java") &&
                    (filePath.contains("/src/main/") ||
                     (filePath.contains("/src/") && !filePath.contains("/test/")))) {
                    return true;
                }
            }
        }
        return false;
    }

    private int countFilesInPatch(String patch) {
        if (patch == null) return 0;
        // Count "diff --git" occurrences
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

        logger.info("Saved {} task instances to {}", tasks.size(), outputFile.getPath());
    }

    private void generateReport(List<TaskInstance> tasks) {
        logger.info("=== Attribute Filtering Report ===");
        logger.info("Total qualified tasks: {}", tasks.size());

        long mavenTasks = tasks.stream()
            .filter(t -> "maven".equalsIgnoreCase(t.getBuildTool()))
            .count();
        long gradleTasks = tasks.stream()
            .filter(t -> "gradle".equalsIgnoreCase(t.getBuildTool()))
            .count();

        logger.info("Maven tasks: {}", mavenTasks);
        logger.info("Gradle tasks: {}", gradleTasks);

        // Count unique repositories
        long uniqueRepos = tasks.stream()
            .map(TaskInstance::getRepo)
            .distinct()
            .count();

        logger.info("Tasks from {} unique repositories", uniqueRepos);
        logger.info("===================================");
    }
}
