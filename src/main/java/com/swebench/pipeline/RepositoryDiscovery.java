package com.swebench.pipeline;

import com.swebench.model.Repository;
import com.swebench.service.GitHubService;
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
 * - Written in Java
 * - Not forked
 * - 50+ stars
 * - Updated in last 1-2 years
 * - Has issues and PRs
 * - Contains test files
 */
public class RepositoryDiscovery {
    private static final Logger logger = LoggerFactory.getLogger(RepositoryDiscovery.class);
    private static final String OUTPUT_DIR = "data/raw";
    private static final int TARGET_REPO_COUNT = 30;

    private final GitHubService gitHubService;
    private final ObjectMapper objectMapper;

    public RepositoryDiscovery() {
        this.gitHubService = new GitHubService();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
    }

    public void execute() {
        logger.info("Starting repository discovery stage");
        logger.info("Target: {} repositories", TARGET_REPO_COUNT);

        try {
            List<Repository> discoveredRepos = discoverRepositories();
            List<Repository> qualifiedRepos = filterRepositories(discoveredRepos);

            logger.info("Discovered {} total repositories", discoveredRepos.size());
            logger.info("Qualified {} repositories after filtering", qualifiedRepos.size());

            saveResults(qualifiedRepos);
            generateReport(qualifiedRepos);

        } catch (Exception e) {
            logger.error("Repository discovery failed", e);
            throw new RuntimeException("Repository discovery stage failed", e);
        }
    }

    private List<Repository> discoverRepositories() {
        logger.info("Searching GitHub for Java repositories...");

        List<Repository> repositories = new ArrayList<>();

        try {
            // Search for popular Java repositories
            repositories.addAll(gitHubService.searchRepositories(
                "language:java stars:>50 archived:false",
                TARGET_REPO_COUNT * 2 // Get more than needed for filtering
            ));

            logger.info("Found {} candidate repositories", repositories.size());

        } catch (IOException e) {
            logger.error("Failed to search repositories", e);
        }

        return repositories;
    }

    private List<Repository> filterRepositories(List<Repository> repositories) {
        logger.info("Applying repository filters...");

        List<Repository> qualified = new ArrayList<>();

        for (Repository repo : repositories) {
            if (qualified.size() >= TARGET_REPO_COUNT) {
                break;
            }

            if (repo.meetsBasicCriteria()) {
                logger.debug("Repository qualified: {}", repo.getFullName());
                qualified.add(repo);
            } else {
                logger.debug("Repository rejected: {}", repo.getFullName());
            }
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

        logger.info("Saved {} repositories to {}", repositories.size(), outputFile.getPath());
    }

    private void generateReport(List<Repository> repositories) {
        logger.info("=== Repository Discovery Report ===");
        logger.info("Total qualified repositories: {}", repositories.size());

        long mavenCount = repositories.stream()
            .filter(r -> "maven".equalsIgnoreCase(r.getBuildTool()))
            .count();
        long gradleCount = repositories.stream()
            .filter(r -> "gradle".equalsIgnoreCase(r.getBuildTool()))
            .count();

        logger.info("Maven projects: {}", mavenCount);
        logger.info("Gradle projects: {}", gradleCount);

        int avgStars = (int) repositories.stream()
            .mapToInt(Repository::getStars)
            .average()
            .orElse(0);

        double avgJavaPercentage = repositories.stream()
            .mapToDouble(Repository::getJavaPercentage)
            .average()
            .orElse(0.0);

        logger.info("Average stars: {}", avgStars);
        logger.info("Average Java percentage: {:.2f}%", avgJavaPercentage);
        logger.info("===================================");
    }
}
