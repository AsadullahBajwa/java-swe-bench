package com.swebench.pipeline;

import com.swebench.model.Repository;
import com.swebench.service.GitHubService;
import com.swebench.util.ConfigLoader;
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
 * Stage 1: Repository Discovery
 * Searches GitHub for high-quality Java repositories that meet our criteria:
 * - Written in Java (90%+ Java code)
 * - Not forked
 * - 50+ stars
 * - Has issues and PRs
 * - Contains test files
 */
public class RepositoryDiscovery {
    private static final Logger logger = LoggerFactory.getLogger(RepositoryDiscovery.class);
    private static final String OUTPUT_DIR = "data/raw";

    private final GitHubService gitHubService;
    private final ObjectMapper objectMapper;
    private final int targetRepoCount;

    public RepositoryDiscovery() {
        this.gitHubService = new GitHubService();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        this.targetRepoCount = ConfigLoader.getInt("discovery.target.count", 30);
    }

    public void execute() {
        PipelineLogger.startStage("Repository Discovery");
        PipelineLogger.info("Target: " + targetRepoCount + " repositories");

        boolean success = false;
        try {
            // Step 1: Search GitHub
            PipelineLogger.section("Searching GitHub");
            List<Repository> discoveredRepos = discoverRepositories();

            if (discoveredRepos.isEmpty()) {
                PipelineLogger.fail("No repositories found from GitHub search",
                    PipelineLogger.ErrorCategory.GITHUB_API);
                PipelineLogger.endStage(false);
                return;
            }

            // Step 2: Filter repositories
            PipelineLogger.section("Filtering Repositories");
            List<Repository> qualifiedRepos = filterRepositories(discoveredRepos);

            if (qualifiedRepos.isEmpty()) {
                PipelineLogger.fail("No repositories passed the quality filters",
                    PipelineLogger.ErrorCategory.FILTER_REJECTED);
                PipelineLogger.warn("Try relaxing filters: discovery.min.java.percentage or discovery.min.stars");
                PipelineLogger.endStage(false);
                return;
            }

            // Step 3: Save results
            PipelineLogger.section("Saving Results");
            saveResults(qualifiedRepos);

            // Generate report
            generateReport(qualifiedRepos);
            success = true;

        } catch (Exception e) {
            logger.error("Repository discovery failed", e);
            PipelineLogger.fail("Discovery crashed: " + e.getMessage(),
                PipelineLogger.ErrorCategory.UNKNOWN);
        }

        PipelineLogger.endStage(success);
    }

    private List<Repository> discoverRepositories() {
        List<Repository> repositories = new ArrayList<>();

        try {
            // Search for MORE candidates since strict filters reject most
            int searchCount = Math.max(50, targetRepoCount * 10);
            PipelineLogger.step("Fetching " + searchCount + " candidates from GitHub API...");

            repositories.addAll(gitHubService.searchRepositories(
                "language:java stars:>50 archived:false",
                searchCount
            ));

            PipelineLogger.success("Found " + repositories.size() + " candidate repositories");

        } catch (IOException e) {
            logger.error("Failed to search repositories", e);
            PipelineLogger.fail("GitHub API error: " + e.getMessage(),
                PipelineLogger.ErrorCategory.GITHUB_API);
        }

        return repositories;
    }

    private List<Repository> filterRepositories(List<Repository> repositories) {
        PipelineLogger.step("Applying quality filters...");
        PipelineLogger.info("Criteria: 90%+ Java, 50+ stars, has issues, has tests, not a fork");

        List<Repository> qualified = new ArrayList<>();
        int rejected = 0;

        for (int i = 0; i < repositories.size(); i++) {
            Repository repo = repositories.get(i);

            if (qualified.size() >= targetRepoCount) {
                PipelineLogger.info("Reached target count, stopping filter");
                break;
            }

            if (repo.meetsBasicCriteria()) {
                qualified.add(repo);
                PipelineLogger.progress(qualified.size(), targetRepoCount, repo.getFullName());
                PipelineLogger.success("Qualified: " + repo.getFullName() +
                    " (★" + repo.getStars() + ", " + String.format("%.1f", repo.getJavaPercentage()) + "% Java)");
            } else {
                rejected++;
                logger.debug("Rejected: {} - criteria not met", repo.getFullName());
            }
        }

        if (rejected > 0) {
            PipelineLogger.info("Rejected " + rejected + " repositories (didn't meet criteria)");
        }

        return qualified;
    }

    private void saveResults(List<Repository> repositories) throws IOException {
        File outputDir = new File(OUTPUT_DIR);
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }

        File outputFile = new File(outputDir, "discovered_repositories.json");
        objectMapper.writeValue(outputFile, repositories);

        PipelineLogger.success("Saved " + repositories.size() + " repositories to " + outputFile.getPath());
    }

    private void generateReport(List<Repository> repositories) {
        PipelineLogger.section("Discovery Report");

        long mavenCount = repositories.stream()
            .filter(r -> "maven".equalsIgnoreCase(r.getBuildTool()))
            .count();
        long gradleCount = repositories.stream()
            .filter(r -> "gradle".equalsIgnoreCase(r.getBuildTool()))
            .count();

        int avgStars = (int) repositories.stream()
            .mapToInt(Repository::getStars)
            .average()
            .orElse(0);

        double avgJavaPercentage = repositories.stream()
            .mapToDouble(Repository::getJavaPercentage)
            .average()
            .orElse(0.0);

        PipelineLogger.info("Total qualified: " + repositories.size());
        PipelineLogger.info("Maven projects: " + mavenCount);
        PipelineLogger.info("Gradle projects: " + gradleCount);
        PipelineLogger.info("Average stars: " + avgStars);
        PipelineLogger.info("Average Java %: " + String.format("%.1f%%", avgJavaPercentage));
    }
}
