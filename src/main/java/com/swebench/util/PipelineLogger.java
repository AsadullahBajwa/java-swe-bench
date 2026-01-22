package com.swebench.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Enhanced logging utility for the Java SWE-Bench pipeline.
 * Provides clear visual markers, progress tracking, and error categorization.
 */
public class PipelineLogger {
    private static final Logger logger = LoggerFactory.getLogger(PipelineLogger.class);

    // Stage tracking
    private static String currentStage = "";
    private static Instant stageStartTime;
    private static final Map<String, StageStats> stageStats = new HashMap<>();
    private static final List<PipelineError> errors = new ArrayList<>();

    // Visual constants
    private static final String SEPARATOR = "═".repeat(70);
    private static final String THIN_SEP = "─".repeat(70);

    /**
     * Start a new pipeline stage with visual header
     */
    public static void startStage(String stageName) {
        currentStage = stageName;
        stageStartTime = Instant.now();
        stageStats.put(stageName, new StageStats());

        System.out.println();
        System.out.println(SEPARATOR);
        System.out.println("  STAGE: " + stageName.toUpperCase());
        System.out.println(SEPARATOR);
        logger.info("Starting stage: {}", stageName);
    }

    /**
     * End current stage with summary
     */
    public static void endStage(boolean success) {
        Duration duration = Duration.between(stageStartTime, Instant.now());
        StageStats stats = stageStats.get(currentStage);
        if (stats != null) {
            stats.duration = duration;
            stats.success = success;
        }

        String status = success ? "[PASS]" : "[FAIL]";
        String statusSymbol = success ? "✓" : "✗";

        System.out.println(THIN_SEP);
        System.out.println(String.format("  %s %s completed in %s", statusSymbol, currentStage, formatDuration(duration)));
        System.out.println(String.format("  Status: %s", status));
        if (stats != null) {
            System.out.println(String.format("  Processed: %d | Passed: %d | Failed: %d",
                stats.processed, stats.passed, stats.failed));
        }
        System.out.println(SEPARATOR);
        System.out.println();

        logger.info("Stage {} completed: {} (duration: {})", currentStage, status, formatDuration(duration));
    }

    /**
     * Log a step within a stage
     */
    public static void step(String message) {
        System.out.println("  → " + message);
        logger.info(message);
    }

    /**
     * Log successful operation
     */
    public static void success(String message) {
        System.out.println("  ✓ " + message);
        logger.info("SUCCESS: {}", message);
        incrementPassed();
    }

    /**
     * Log failed operation with error categorization
     */
    public static void fail(String message, ErrorCategory category) {
        System.out.println("  ✗ " + message);
        System.out.println("    Category: " + category.getDescription());
        logger.error("FAIL [{}]: {}", category, message);

        errors.add(new PipelineError(currentStage, message, category));
        incrementFailed();
    }

    /**
     * Log warning
     */
    public static void warn(String message) {
        System.out.println("  ⚠ " + message);
        logger.warn(message);
    }

    /**
     * Log info with indentation
     */
    public static void info(String message) {
        System.out.println("    " + message);
        logger.info(message);
    }

    /**
     * Log progress (e.g., "Processing 3/10...")
     */
    public static void progress(int current, int total, String item) {
        String progressBar = createProgressBar(current, total);
        System.out.println(String.format("  [%d/%d] %s %s", current, total, progressBar, item));
        logger.info("Progress: {}/{} - {}", current, total, item);
        incrementProcessed();
    }

    /**
     * Log a sub-section within a stage
     */
    public static void section(String title) {
        System.out.println();
        System.out.println("  " + THIN_SEP.substring(0, 50));
        System.out.println("  " + title);
        System.out.println("  " + THIN_SEP.substring(0, 50));
    }

    /**
     * Print final pipeline summary
     */
    public static void printSummary() {
        System.out.println();
        System.out.println(SEPARATOR);
        System.out.println("  PIPELINE SUMMARY");
        System.out.println(SEPARATOR);

        // Stage results
        System.out.println();
        System.out.println("  Stage Results:");
        for (Map.Entry<String, StageStats> entry : stageStats.entrySet()) {
            StageStats stats = entry.getValue();
            String status = stats.success ? "PASS" : "FAIL";
            String symbol = stats.success ? "✓" : "✗";
            System.out.println(String.format("    %s %-25s [%s] (%s)",
                symbol, entry.getKey(), status, formatDuration(stats.duration)));
            System.out.println(String.format("      Processed: %d | Passed: %d | Failed: %d",
                stats.processed, stats.passed, stats.failed));
        }

        // Error summary
        if (!errors.isEmpty()) {
            System.out.println();
            System.out.println("  Errors Encountered:");
            Map<ErrorCategory, Long> errorCounts = new HashMap<>();
            for (PipelineError error : errors) {
                errorCounts.merge(error.category, 1L, Long::sum);
            }
            for (Map.Entry<ErrorCategory, Long> entry : errorCounts.entrySet()) {
                System.out.println(String.format("    - %s: %d occurrences",
                    entry.getKey().getDescription(), entry.getValue()));
            }

            System.out.println();
            System.out.println("  Error Details (last 5):");
            int count = 0;
            for (int i = errors.size() - 1; i >= 0 && count < 5; i--, count++) {
                PipelineError error = errors.get(i);
                System.out.println(String.format("    [%s] %s: %s",
                    error.stage, error.category, error.message));
            }
        }

        // Suggestions
        if (!errors.isEmpty()) {
            System.out.println();
            System.out.println("  Suggestions:");
            printSuggestions();
        }

        System.out.println();
        System.out.println(SEPARATOR);
    }

    private static void printSuggestions() {
        Map<ErrorCategory, Long> errorCounts = new HashMap<>();
        for (PipelineError error : errors) {
            errorCounts.merge(error.category, 1L, Long::sum);
        }

        for (ErrorCategory category : errorCounts.keySet()) {
            switch (category) {
                case GITHUB_API:
                    System.out.println("    → Check GITHUB_TOKEN is valid and has correct permissions");
                    break;
                case FILTER_REJECTED:
                    System.out.println("    → Consider relaxing filter criteria in application.properties");
                    System.out.println("    → Try: filter.min.quality.score=50 or filter.min.problem.statement.length=20");
                    break;
                case BUILD_FAILED:
                    System.out.println("    → Ensure Maven/Gradle are properly installed");
                    System.out.println("    → Check MAVEN_HOME environment variable");
                    break;
                case TEST_FAILED:
                    System.out.println("    → Tests failing after patch is normal - try more candidate tasks");
                    System.out.println("    → Increase filter.target.task.count to find passing tasks");
                    break;
                case PATCH_FAILED:
                    System.out.println("    → Patch application issues may indicate merge conflicts");
                    System.out.println("    → Try tasks from different repositories");
                    break;
                case CLONE_FAILED:
                    System.out.println("    → Check network connectivity");
                    System.out.println("    → Ensure enough disk space for cloning");
                    break;
                case TIMEOUT:
                    System.out.println("    → Increase execution.timeout.minutes in config");
                    break;
                default:
                    System.out.println("    → Check logs for detailed error information");
            }
        }
    }

    private static String createProgressBar(int current, int total) {
        int width = 20;
        int filled = (int) ((double) current / total * width);
        StringBuilder bar = new StringBuilder("[");
        for (int i = 0; i < width; i++) {
            bar.append(i < filled ? "█" : "░");
        }
        bar.append("]");
        return bar.toString();
    }

    private static String formatDuration(Duration duration) {
        if (duration == null) return "N/A";
        long seconds = duration.getSeconds();
        if (seconds < 60) {
            return seconds + "s";
        } else if (seconds < 3600) {
            return String.format("%dm %ds", seconds / 60, seconds % 60);
        } else {
            return String.format("%dh %dm %ds", seconds / 3600, (seconds % 3600) / 60, seconds % 60);
        }
    }

    private static void incrementProcessed() {
        StageStats stats = stageStats.get(currentStage);
        if (stats != null) stats.processed++;
    }

    private static void incrementPassed() {
        StageStats stats = stageStats.get(currentStage);
        if (stats != null) stats.passed++;
    }

    private static void incrementFailed() {
        StageStats stats = stageStats.get(currentStage);
        if (stats != null) stats.failed++;
    }

    /**
     * Reset all tracking data (call at pipeline start)
     */
    public static void reset() {
        currentStage = "";
        stageStartTime = null;
        stageStats.clear();
        errors.clear();
    }

    /**
     * Error categories for better diagnostics
     */
    public enum ErrorCategory {
        GITHUB_API("GitHub API Error"),
        FILTER_REJECTED("Filter Criteria Not Met"),
        BUILD_FAILED("Build/Compile Failed"),
        TEST_FAILED("Test Execution Failed"),
        PATCH_FAILED("Patch Application Failed"),
        CLONE_FAILED("Repository Clone Failed"),
        TIMEOUT("Operation Timed Out"),
        CONFIG_ERROR("Configuration Error"),
        UNKNOWN("Unknown Error");

        private final String description;

        ErrorCategory(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    /**
     * Track stage statistics
     */
    private static class StageStats {
        int processed = 0;
        int passed = 0;
        int failed = 0;
        Duration duration;
        boolean success = true;
    }

    /**
     * Store error information
     */
    private static class PipelineError {
        String stage;
        String message;
        ErrorCategory category;

        PipelineError(String stage, String message, ErrorCategory category) {
            this.stage = stage;
            this.message = message;
            this.category = category;
        }
    }
}
