package com.swebench.evaluation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.swebench.evaluation.ResultsAggregator.AggregatedResults;
import com.swebench.evaluation.ResultsAggregator.RepoStats;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDate;
import java.util.*;

/**
 * Results Report — Issue #17.
 *
 * <p>Reads all per-task result JSON files from {@code data/results/<model>/},
 * computes scores via {@link ResultsAggregator}, and writes:
 * <ul>
 *   <li>{@code data/EVALUATION_RESULTS_<model>.md}  — human-readable markdown report</li>
 *   <li>{@code data/results/<model>/summary.json}    — machine-readable summary</li>
 * </ul>
 *
 * <p>Run once per model to compare them side-by-side:
 * <pre>
 *   ./scripts/run_report.sh gpt-4o
 *   ./scripts/run_report.sh claude-sonnet-4-6
 * </pre>
 */
public class ResultsReporter {

    private static final Logger logger = LoggerFactory.getLogger(ResultsReporter.class);

    private static final String RESULTS_ROOT = "data/results";
    private static final String OUTPUT_DIR   = "data";

    private final ObjectMapper mapper;

    public ResultsReporter() {
        this.mapper = new ObjectMapper();
        this.mapper.registerModule(new JavaTimeModule());
        this.mapper.enable(SerializationFeature.INDENT_OUTPUT);
    }

    public void execute(String modelName) throws IOException {
        File resultsDir = new File(RESULTS_ROOT, modelName);
        if (!resultsDir.exists()) {
            logger.error("[ResultsReporter] Results directory not found: {}", resultsDir);
            logger.error("Run the evaluation harness first: bash scripts/run_evaluation.sh {}", modelName);
            return;
        }

        ResultsAggregator aggregator = new ResultsAggregator();
        AggregatedResults results = aggregator.aggregate(resultsDir);

        if (results.totalEvaluated() == 0) {
            logger.warn("[ResultsReporter] No result files found in {}", resultsDir);
            return;
        }

        // Write markdown report
        File mdFile = new File(OUTPUT_DIR, "EVALUATION_RESULTS_" + modelName + ".md");
        String markdown = buildMarkdownReport(modelName, results);
        Files.writeString(mdFile.toPath(), markdown);
        logger.info("[ResultsReporter] Wrote {}", mdFile);

        // Write summary JSON
        File summaryFile = new File(resultsDir, "summary.json");
        Map<String, Object> summary = buildSummaryJson(modelName, results);
        mapper.writeValue(summaryFile, summary);
        logger.info("[ResultsReporter] Wrote {}", summaryFile);

        // Print a quick summary to console
        logger.info("[ResultsReporter] {} — {}/{} resolved ({:.1f}%)",
                modelName,
                results.totalResolved(),
                results.totalEvaluated(),
                results.resolutionRate());
    }

    // -------------------------------------------------------------------------
    // Markdown report
    // -------------------------------------------------------------------------

    private String buildMarkdownReport(String modelName, AggregatedResults results) {
        StringBuilder sb = new StringBuilder();

        sb.append("# Java SWE-Bench Evaluation Results\n\n");
        sb.append("**Model**: ").append(modelName).append("\n");
        sb.append("**Date**: ").append(LocalDate.now()).append("\n");
        sb.append("**Tasks evaluated**: ").append(results.totalEvaluated()).append("\n");
        sb.append(String.format("**Resolved**: %d / %d (%.1f%%)\n\n",
                results.totalResolved(),
                results.totalEvaluated(),
                results.resolutionRate()));

        // Status breakdown table
        sb.append("## Results by Status\n\n");
        sb.append("| Status | Count |\n");
        sb.append("|---|---|\n");
        results.statusBreakdown().forEach((status, count) ->
                sb.append("| ").append(status).append(" | ").append(count).append(" |\n"));

        sb.append("\n");

        // Per-repository table
        sb.append("## Results by Repository\n\n");
        sb.append("| Repository | Resolved | Total | Rate |\n");
        sb.append("|---|---|---|---|\n");

        // Sort repos by resolution rate descending
        List<Map.Entry<String, RepoStats>> repoEntries = new ArrayList<>(results.byRepo.entrySet());
        repoEntries.sort((a, b) -> Double.compare(b.getValue().rate(), a.getValue().rate()));

        for (Map.Entry<String, RepoStats> entry : repoEntries) {
            String repo = entry.getKey();
            RepoStats stats = entry.getValue();
            sb.append(String.format("| %s | %d | %d | %.1f%% |\n",
                    repo, stats.resolved, stats.total, stats.rate()));
        }

        sb.append("\n");

        // Resolved tasks list
        sb.append("## Resolved Tasks\n\n");
        boolean any = false;
        for (Map<?, ?> r : results.allRecords) {
            if ("resolved".equals(r.get("status"))) {
                sb.append("- ").append(r.get("instance_id")).append("\n");
                any = true;
            }
        }
        if (!any) sb.append("_None_\n");

        sb.append("\n");

        // Failed tasks list
        sb.append("## Not Resolved Tasks\n\n");
        sb.append("| Instance ID | Status | Error |\n");
        sb.append("|---|---|---|\n");
        for (Map<?, ?> r : results.allRecords) {
            String status = (String) r.get("status");
            if (!"resolved".equals(status)) {
                String error = r.get("error") != null ? r.get("error").toString() : "";
                if (error.length() > 80) error = error.substring(0, 80) + "...";
                sb.append("| ").append(r.get("instance_id"))
                  .append(" | ").append(status)
                  .append(" | ").append(error)
                  .append(" |\n");
            }
        }

        return sb.toString();
    }

    // -------------------------------------------------------------------------
    // Summary JSON
    // -------------------------------------------------------------------------

    private Map<String, Object> buildSummaryJson(String modelName, AggregatedResults results) {
        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("model",            modelName);
        summary.put("date",             LocalDate.now().toString());
        summary.put("total_evaluated",  results.totalEvaluated());
        summary.put("total_resolved",   results.totalResolved());
        summary.put("resolution_rate",  String.format("%.1f%%", results.resolutionRate()));
        summary.put("status_breakdown", results.statusBreakdown());

        // Per-repo summary
        Map<String, Object> repoSummary = new LinkedHashMap<>();
        results.byRepo.forEach((repo, stats) -> {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("total",    stats.total);
            r.put("resolved", stats.resolved);
            r.put("rate",     String.format("%.1f%%", stats.rate()));
            repoSummary.put(repo, r);
        });
        summary.put("by_repository", repoSummary);

        return summary;
    }
}
