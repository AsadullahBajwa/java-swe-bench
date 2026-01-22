package com.swebench.util;

import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * File-based logging system for pipeline analysis.
 * Stores detailed logs for pattern analysis and debugging.
 */
public class FileLogger {
    private static final String LOG_DIR = "logs";
    private static final DateTimeFormatter TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FILE_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");

    private static PrintWriter pipelineLog;
    private static PrintWriter errorLog;
    private static PrintWriter metricsLog;
    private static String sessionId;

    // Metrics tracking
    private static final Map<String, Integer> stageMetrics = new LinkedHashMap<>();
    private static final List<LogEntry> allEntries = new ArrayList<>();

    /**
     * Initialize logging for a new pipeline run
     */
    public static void initialize() {
        try {
            // Create logs directory
            Files.createDirectories(Paths.get(LOG_DIR));

            // Generate session ID
            sessionId = FILE_DATE_FORMAT.format(LocalDateTime.now());

            // Open log files
            pipelineLog = new PrintWriter(new FileWriter(LOG_DIR + "/pipeline_" + sessionId + ".log"));
            errorLog = new PrintWriter(new FileWriter(LOG_DIR + "/errors_" + sessionId + ".log"));
            metricsLog = new PrintWriter(new FileWriter(LOG_DIR + "/metrics_" + sessionId + ".csv"));

            // Write CSV header for metrics
            metricsLog.println("timestamp,stage,event,item,status,details");

            log("SYSTEM", "Pipeline logging initialized. Session: " + sessionId);

        } catch (IOException e) {
            System.err.println("Failed to initialize file logging: " + e.getMessage());
        }
    }

    /**
     * Log a general message
     */
    public static void log(String stage, String message) {
        String timestamp = TIMESTAMP_FORMAT.format(LocalDateTime.now());
        String logLine = String.format("[%s] [%s] %s", timestamp, stage, message);

        if (pipelineLog != null) {
            pipelineLog.println(logLine);
            pipelineLog.flush();
        }

        allEntries.add(new LogEntry(timestamp, stage, "INFO", message));
    }

    /**
     * Log an error with full details
     */
    public static void error(String stage, String message, String details) {
        String timestamp = TIMESTAMP_FORMAT.format(LocalDateTime.now());
        String logLine = String.format("[%s] [%s] ERROR: %s", timestamp, stage, message);

        if (pipelineLog != null) {
            pipelineLog.println(logLine);
            if (details != null && !details.isEmpty()) {
                pipelineLog.println("  Details: " + details);
            }
            pipelineLog.flush();
        }

        if (errorLog != null) {
            errorLog.println("=" .repeat(60));
            errorLog.println("Time: " + timestamp);
            errorLog.println("Stage: " + stage);
            errorLog.println("Error: " + message);
            if (details != null && !details.isEmpty()) {
                errorLog.println("Details: " + details);
            }
            errorLog.println();
            errorLog.flush();
        }

        allEntries.add(new LogEntry(timestamp, stage, "ERROR", message + " | " + details));
    }

    /**
     * Log a metric for analysis
     */
    public static void metric(String stage, String event, String item, String status, String details) {
        String timestamp = TIMESTAMP_FORMAT.format(LocalDateTime.now());

        if (metricsLog != null) {
            // Escape CSV values
            String safeDetails = details != null ? details.replace("\"", "\"\"") : "";
            metricsLog.printf("%s,%s,%s,%s,%s,\"%s\"%n",
                timestamp, stage, event, item, status, safeDetails);
            metricsLog.flush();
        }

        // Track counts
        String key = stage + "_" + event + "_" + status;
        stageMetrics.merge(key, 1, Integer::sum);
    }

    /**
     * Log repository discovery details
     */
    public static void logRepoDiscovery(String repoName, boolean qualified, String reason) {
        String status = qualified ? "QUALIFIED" : "REJECTED";
        metric("DISCOVERY", "REPO_FILTER", repoName, status, reason);
        log("DISCOVERY", String.format("Repository %s: %s (%s)", repoName, status, reason));
    }

    /**
     * Log task filtering details
     */
    public static void logTaskFilter(String taskId, boolean qualified, String filterStage, String reason) {
        String status = qualified ? "PASSED" : "REJECTED";
        metric("FILTER", filterStage, taskId, status, reason);
        log("FILTER", String.format("Task %s [%s]: %s (%s)", taskId, filterStage, status, reason));
    }

    /**
     * Log bug type classification
     */
    public static void logBugClassification(String taskId, String bugType, int functionalScore, String details) {
        metric("CLASSIFY", "BUG_TYPE", taskId, bugType, "score=" + functionalScore + "; " + details);
        log("CLASSIFY", String.format("Task %s classified as %s (functional score: %d)", taskId, bugType, functionalScore));
    }

    /**
     * Log execution validation details
     */
    public static void logExecution(String taskId, String step, boolean success, String output) {
        String status = success ? "SUCCESS" : "FAILURE";
        metric("EXECUTION", step, taskId, status, output);
        log("EXECUTION", String.format("Task %s [%s]: %s", taskId, step, status));

        if (!success && output != null && !output.isEmpty()) {
            error("EXECUTION", taskId + " failed at " + step, output);
        }
    }

    /**
     * Write final summary report
     */
    public static void writeSummary() {
        if (pipelineLog == null) return;

        pipelineLog.println();
        pipelineLog.println("=".repeat(60));
        pipelineLog.println("PIPELINE RUN SUMMARY");
        pipelineLog.println("=".repeat(60));
        pipelineLog.println("Session: " + sessionId);
        pipelineLog.println("Completed: " + TIMESTAMP_FORMAT.format(LocalDateTime.now()));
        pipelineLog.println();

        // Group metrics by stage
        pipelineLog.println("METRICS BY STAGE:");
        pipelineLog.println("-".repeat(40));

        Map<String, Map<String, Integer>> grouped = new LinkedHashMap<>();
        for (Map.Entry<String, Integer> entry : stageMetrics.entrySet()) {
            String[] parts = entry.getKey().split("_", 3);
            if (parts.length >= 3) {
                String stage = parts[0];
                String metric = parts[1] + "_" + parts[2];
                grouped.computeIfAbsent(stage, k -> new LinkedHashMap<>())
                    .put(metric, entry.getValue());
            }
        }

        for (Map.Entry<String, Map<String, Integer>> stage : grouped.entrySet()) {
            pipelineLog.println("\n" + stage.getKey() + ":");
            for (Map.Entry<String, Integer> m : stage.getValue().entrySet()) {
                pipelineLog.println("  " + m.getKey() + ": " + m.getValue());
            }
        }

        // Count errors
        long errorCount = allEntries.stream().filter(e -> "ERROR".equals(e.level)).count();
        pipelineLog.println("\nTotal Errors: " + errorCount);

        pipelineLog.println();
        pipelineLog.println("Log files:");
        pipelineLog.println("  - Pipeline log: logs/pipeline_" + sessionId + ".log");
        pipelineLog.println("  - Error log: logs/errors_" + sessionId + ".log");
        pipelineLog.println("  - Metrics CSV: logs/metrics_" + sessionId + ".csv");
        pipelineLog.println("=".repeat(60));

        pipelineLog.flush();
    }

    /**
     * Close all log files
     */
    public static void close() {
        writeSummary();

        if (pipelineLog != null) { pipelineLog.close(); pipelineLog = null; }
        if (errorLog != null) { errorLog.close(); errorLog = null; }
        if (metricsLog != null) { metricsLog.close(); metricsLog = null; }

        stageMetrics.clear();
        allEntries.clear();
    }

    /**
     * Get current session ID
     */
    public static String getSessionId() {
        return sessionId;
    }

    /**
     * Internal log entry class
     */
    private static class LogEntry {
        String timestamp;
        String stage;
        String level;
        String message;

        LogEntry(String timestamp, String stage, String level, String message) {
            this.timestamp = timestamp;
            this.stage = stage;
            this.level = level;
            this.message = message;
        }
    }
}
