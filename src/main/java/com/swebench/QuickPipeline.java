package com.swebench;

import com.swebench.model.Repository;
import com.swebench.model.TaskInstance;
import com.swebench.service.GitHubService;
import com.swebench.util.ConfigLoader;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * LIGHTWEIGHT PIPELINE - Designed for quick results
 *
 * Key differences from full pipeline:
 * 1. Uses curated repo list (no random search)
 * 2. Relaxed filters (more tasks pass)
 * 3. Quick mode skips execution validation
 * 4. Targets bug-fix PRs specifically
 */
public class QuickPipeline {

    private final GitHubService github;
    private final ObjectMapper json;
    private final boolean quickMode;
    private final int targetTasks;

    public QuickPipeline() {
        this.github = new GitHubService();
        this.json = new ObjectMapper();
        this.json.registerModule(new JavaTimeModule());
        this.json.enable(SerializationFeature.INDENT_OUTPUT);
        this.quickMode = "quick".equals(ConfigLoader.get("pipeline.mode", "quick"));
        this.targetTasks = ConfigLoader.getInt("filter.target.task.count", 10);
    }

    public static void main(String[] args) {
        System.out.println("\n====================================");
        System.out.println("  JAVA SWE-BENCH - Quick Pipeline");
        System.out.println("====================================\n");

        QuickPipeline pipeline = new QuickPipeline();

        try {
            List<TaskInstance> tasks = pipeline.run();
            System.out.println("\n====================================");
            System.out.println("  RESULTS: " + tasks.size() + " tasks collected");
            System.out.println("====================================");

            if (!tasks.isEmpty()) {
                System.out.println("\nTasks:");
                for (TaskInstance task : tasks) {
                    System.out.println("  - " + task.getInstanceId());
                    System.out.println("    Repo: " + task.getRepo());
                    System.out.println("    Issue: " + truncate(task.getProblemStatement(), 80));
                    System.out.println();
                }
            }

        } catch (Exception e) {
            System.err.println("Pipeline failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<TaskInstance> run() throws Exception {
        List<TaskInstance> allTasks = new ArrayList<>();

        // Step 1: Get repositories
        System.out.println("[1/3] Loading repositories...");
        List<Repository> repos = loadRepositories();
        System.out.println("      Found " + repos.size() + " repositories\n");

        // Step 2: Extract tasks from each repo
        System.out.println("[2/3] Extracting bug-fix tasks...");
        for (Repository repo : repos) {
            if (allTasks.size() >= targetTasks) break;

            System.out.println("      Processing: " + repo.getFullName());
            try {
                List<TaskInstance> repoTasks = extractTasks(repo);
                System.out.println("        -> Found " + repoTasks.size() + " tasks");
                allTasks.addAll(repoTasks);
            } catch (Exception e) {
                System.out.println("        -> Error: " + e.getMessage());
            }
        }

        // Limit to target count
        if (allTasks.size() > targetTasks) {
            allTasks = allTasks.subList(0, targetTasks);
        }

        // Step 3: Save results
        System.out.println("\n[3/3] Saving results...");
        saveResults(allTasks);

        return allTasks;
    }

    private List<Repository> loadRepositories() throws Exception {
        String source = ConfigLoader.get("repository.source", "curated");

        if ("curated".equals(source)) {
            return loadCuratedRepos();
        } else {
            return searchRepos();
        }
    }

    private List<Repository> loadCuratedRepos() throws Exception {
        String filePath = ConfigLoader.get("repository.curated.file", "config/curated_repos.txt");
        int limit = ConfigLoader.getInt("repository.curated.limit", 5);

        List<Repository> repos = new ArrayList<>();
        List<String> lines = Files.readAllLines(Paths.get(filePath));

        for (String line : lines) {
            if (repos.size() >= limit) break;

            line = line.trim();
            if (line.isEmpty() || line.startsWith("#")) continue;

            try {
                Repository repo = github.getRepository(line);
                if (repo != null) {
                    repos.add(repo);
                    System.out.println("        Loaded: " + line);
                }
            } catch (Exception e) {
                System.out.println("        Failed to load: " + line + " - " + e.getMessage());
            }
        }

        return repos;
    }

    private List<Repository> searchRepos() throws Exception {
        int count = ConfigLoader.getInt("discovery.target.count", 3);
        return github.searchRepositories("language:java stars:>100", count * 3)
            .subList(0, Math.min(count, 10));
    }

    private List<TaskInstance> extractTasks(Repository repo) throws Exception {
        List<TaskInstance> tasks = new ArrayList<>();
        int maxPRs = ConfigLoader.getInt("filter.pr.max.to.check", 50);
        int needed = targetTasks - tasks.size();

        // Use relaxed extraction - targets bug-fix PRs directly (no issue link required)
        List<TaskInstance> candidates = github.extractTasksFromMergedPRs(repo, maxPRs);

        // Apply minimal filtering
        for (TaskInstance task : candidates) {
            if (tasks.size() >= needed) break;

            if (isValidTask(task)) {
                tasks.add(task);
            }
        }

        return tasks;
    }

    private boolean isValidTask(TaskInstance task) {
        // Minimal validation for quick results
        String problem = task.getProblemStatement();
        String patch = task.getPatch();

        // Must have problem statement
        if (problem == null || problem.length() < 20) {
            return false;
        }

        // Must have patch
        if (patch == null || patch.isEmpty()) {
            return false;
        }

        // Patch shouldn't be too large
        int files = countFiles(patch);
        if (files > 50 || files == 0) {
            return false;
        }

        // Should modify Java files
        if (!patch.contains(".java")) {
            return false;
        }

        return true;
    }

    private int countFiles(String patch) {
        if (patch == null) return 0;
        return patch.split("diff --git").length - 1;
    }

    private void saveResults(List<TaskInstance> tasks) throws Exception {
        // Create output directories
        Files.createDirectories(Paths.get("data/raw"));
        Files.createDirectories(Paths.get("data/processed"));
        Files.createDirectories(Paths.get("data/tasks"));

        // Save all tasks
        File outputFile = new File("data/tasks/collected_tasks.json");
        json.writeValue(outputFile, tasks);
        System.out.println("      Saved to: " + outputFile.getPath());

        // Save summary
        saveSummary(tasks);
    }

    private void saveSummary(List<TaskInstance> tasks) throws Exception {
        StringBuilder summary = new StringBuilder();
        summary.append("# Quick Pipeline Results\n");
        summary.append("Generated: ").append(LocalDateTime.now()).append("\n\n");
        summary.append("## Summary\n");
        summary.append("- Total tasks: ").append(tasks.size()).append("\n");
        summary.append("- Mode: ").append(quickMode ? "quick" : "full").append("\n\n");

        summary.append("## Tasks\n");
        for (TaskInstance task : tasks) {
            summary.append("### ").append(task.getInstanceId()).append("\n");
            summary.append("- Repository: ").append(task.getRepo()).append("\n");
            summary.append("- Base commit: ").append(task.getBaseCommit()).append("\n");
            summary.append("- Problem: ").append(truncate(task.getProblemStatement(), 200)).append("\n");
            summary.append("- Patch files: ").append(countFiles(task.getPatch())).append("\n\n");
        }

        Files.writeString(Paths.get("data/tasks/RESULTS.md"), summary.toString());
        System.out.println("      Summary: data/tasks/RESULTS.md");
    }

    private static String truncate(String s, int max) {
        if (s == null) return "";
        s = s.replace("\n", " ").replace("\r", "");
        return s.length() > max ? s.substring(0, max) + "..." : s;
    }
}
