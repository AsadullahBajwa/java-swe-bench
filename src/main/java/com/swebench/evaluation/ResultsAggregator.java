package com.swebench.evaluation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Reads all per-task result JSON files from {@code data/results/<model>/}
 * and computes overall and per-repository scores.
 *
 * <h2>Scoring rules</h2>
 * <ul>
 *   <li>A task counts as <b>resolved</b> only when {@code "status": "resolved"}</li>
 *   <li>Resolution rate = resolved / total evaluated * 100</li>
 * </ul>
 */
public class ResultsAggregator {

    private static final Logger logger = LoggerFactory.getLogger(ResultsAggregator.class);

    private final ObjectMapper mapper;

    public ResultsAggregator() {
        this.mapper = new ObjectMapper();
        this.mapper.registerModule(new JavaTimeModule());
    }

    /**
     * Aggregates all result files for the given model.
     *
     * @param resultsDir  {@code data/results/<model>/}
     * @return aggregated statistics
     */
    public AggregatedResults aggregate(File resultsDir) {
        File[] files = resultsDir.listFiles(f -> f.getName().endsWith(".json")
                && !f.getName().equals("summary.json"));

        if (files == null || files.length == 0) {
            logger.warn("[ResultsAggregator] No result files found in {}", resultsDir);
            return new AggregatedResults(Collections.emptyList(), Collections.emptyMap());
        }

        List<Map<?, ?>> records = new ArrayList<>();
        for (File f : files) {
            try {
                Map<?, ?> record = mapper.readValue(f, Map.class);
                records.add(record);
            } catch (IOException e) {
                logger.warn("[ResultsAggregator] Skipping malformed file {}: {}", f.getName(), e.getMessage());
            }
        }

        // Group by repository
        Map<String, List<Map<?, ?>>> byRepo = new LinkedHashMap<>();
        for (Map<?, ?> r : records) {
            String repo = (String) r.getOrDefault("repo", "unknown");
            byRepo.computeIfAbsent(repo, k -> new ArrayList<>()).add(r);
        }

        // Per-repo stats
        Map<String, RepoStats> repoStats = new LinkedHashMap<>();
        for (Map.Entry<String, List<Map<?, ?>>> entry : byRepo.entrySet()) {
            repoStats.put(entry.getKey(), computeRepoStats(entry.getValue()));
        }

        return new AggregatedResults(records, repoStats);
    }

    private RepoStats computeRepoStats(List<Map<?, ?>> records) {
        int total    = records.size();
        int resolved = 0;
        Map<String, Integer> byStatus = new LinkedHashMap<>();

        for (Map<?, ?> r : records) {
            String status = (String) r.getOrDefault("status", "unknown");
            byStatus.merge(status, 1, Integer::sum);
            if ("resolved".equals(status)) resolved++;
        }

        return new RepoStats(total, resolved, byStatus);
    }

    // -------------------------------------------------------------------------
    // Result types
    // -------------------------------------------------------------------------

    public static class AggregatedResults {
        public final List<Map<?, ?>>        allRecords;
        public final Map<String, RepoStats> byRepo;

        public AggregatedResults(List<Map<?, ?>> allRecords, Map<String, RepoStats> byRepo) {
            this.allRecords = allRecords;
            this.byRepo     = byRepo;
        }

        public int totalEvaluated() {
            return allRecords.size();
        }

        public int totalResolved() {
            return byRepo.values().stream().mapToInt(r -> r.resolved).sum();
        }

        public double resolutionRate() {
            int total = totalEvaluated();
            return total == 0 ? 0.0 : (double) totalResolved() / total * 100.0;
        }

        /** Count of each status value across all tasks. */
        public Map<String, Integer> statusBreakdown() {
            Map<String, Integer> counts = new LinkedHashMap<>();
            for (Map<?, ?> r : allRecords) {
                String status = (String) r.getOrDefault("status", "unknown");
                counts.merge(status, 1, Integer::sum);
            }
            // Sort by count descending
            List<Map.Entry<String, Integer>> entries = new ArrayList<>(counts.entrySet());
            entries.sort((a, b) -> b.getValue() - a.getValue());
            Map<String, Integer> sorted = new LinkedHashMap<>();
            entries.forEach(e -> sorted.put(e.getKey(), e.getValue()));
            return sorted;
        }
    }

    public static class RepoStats {
        public final int                   total;
        public final int                   resolved;
        public final Map<String, Integer>  byStatus;

        public RepoStats(int total, int resolved, Map<String, Integer> byStatus) {
            this.total    = total;
            this.resolved = resolved;
            this.byStatus = byStatus;
        }

        public double rate() {
            return total == 0 ? 0.0 : (double) resolved / total * 100.0;
        }
    }
}
