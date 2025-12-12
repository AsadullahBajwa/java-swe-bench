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
 */
public class AttributeFilter {
    private static final Logger logger = LoggerFactory.getLogger(AttributeFilter.class);
    private static final String INPUT_FILE = "data/raw/discovered_repositories.json";
    private static final String OUTPUT_DIR = "data/processed";
    private static final int TARGET_TASK_COUNT = 200;
    private static final int MAX_FILES_CHANGED = 100;

    private final GitHubService gitHubService;
    private final PatchExtractor patchExtractor;
    private final QualityValidator qualityValidator;
    private final ObjectMapper objectMapper;

    public AttributeFilter() {
        this.gitHubService = new GitHubService();
        this.patchExtractor = new PatchExtractor();
        this.qualityValidator = new QualityValidator();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
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
        logger.info("Extracting task instances from repositories...");

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
            task.getProblemStatement().length() < 50) {
            return false;
        }

        if (task.getPatch() == null || task.getPatch().isEmpty()) {
            return false;
        }

        // Check patch size is reasonable
        int filesChanged = countFilesInPatch(task.getPatch());
        if (filesChanged > MAX_FILES_CHANGED) {
            logger.debug("Task {} has too many files changed: {}",
                task.getInstanceId(), filesChanged);
            return false;
        }

        // Check has test-related changes
        if (!hasTestChanges(task.getPatch())) {
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
