package com.swebench.service;

import com.swebench.model.TaskInstance;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Validates task instances for high quality and real-world relevance.
 * Ensures only production-grade, meaningful tasks are included in the benchmark.
 */
public class QualityValidator {
    private static final Logger logger = LoggerFactory.getLogger(QualityValidator.class);

    // Patterns for low-quality issues (to REJECT)
    private static final List<String> LOW_QUALITY_PATTERNS = Arrays.asList(
        "typo", "spelling", "grammar", "formatting",
        "whitespace", "indentation", "style",
        "readme", "documentation only", "doc update",
        "comment", "javadoc only",
        "dependency version", "upgrade dependency",
        "add license", "copyright",
        "gitignore", "travis", "ci config"
    );

    // Patterns for trivial changes (to REJECT)
    private static final List<String> TRIVIAL_PATTERNS = Arrays.asList(
        "rename variable", "reformat code",
        "remove unused import", "add comment",
        "update year", "fix typo in comment"
    );

    // Patterns for real bugs/features (to ACCEPT)
    private static final List<String> HIGH_QUALITY_PATTERNS = Arrays.asList(
        "bug", "error", "exception", "crash", "fail",
        "incorrect", "wrong", "invalid", "broken",
        "memory leak", "performance", "deadlock",
        "race condition", "thread", "concurrent",
        "security", "vulnerability", "exploit",
        "data loss", "corruption", "inconsistent",
        "regression", "breaking", "not working",
        "feature", "implement", "add support for",
        "enhancement", "improve", "optimize"
    );

    // Minimum lengths for quality content
    private static final int MIN_PROBLEM_STATEMENT_LENGTH = 100;
    private static final int MIN_PATCH_LINES = 5;
    private static final int MAX_PATCH_LINES = 500;

    // Test requirements
    private static final int MIN_TEST_CHANGES = 3;
    private static final Pattern TEST_ASSERTION_PATTERN = Pattern.compile(
        "(assert|verify|expect|should|test|check).*",
        Pattern.CASE_INSENSITIVE
    );

    /**
     * Performs comprehensive quality validation on a task instance.
     * Returns true only if the task meets all high-quality criteria.
     */
    public boolean isHighQuality(TaskInstance task) {
        logger.debug("Validating quality for task: {}", task.getInstanceId());

        // 1. Check problem statement quality
        if (!hasMeaningfulProblemStatement(task)) {
            logger.debug("Task {} rejected: Low-quality problem statement", task.getInstanceId());
            return false;
        }

        // 2. Check for real-world bug/feature
        if (!isRealWorldIssue(task)) {
            logger.debug("Task {} rejected: Not a real-world issue", task.getInstanceId());
            return false;
        }

        // 3. Check patch quality
        if (!hasQualityPatch(task)) {
            logger.debug("Task {} rejected: Low-quality patch", task.getInstanceId());
            return false;
        }

        // 4. Check test quality
        if (!hasQualityTests(task)) {
            logger.debug("Task {} rejected: Insufficient test quality", task.getInstanceId());
            return false;
        }

        // 5. Ensure it's not trivial
        if (isTrivialChange(task)) {
            logger.debug("Task {} rejected: Trivial change", task.getInstanceId());
            return false;
        }

        logger.info("Task {} passed all quality checks", task.getInstanceId());
        return true;
    }

    /**
     * Check if problem statement is meaningful and detailed
     */
    private boolean hasMeaningfulProblemStatement(TaskInstance task) {
        String statement = task.getProblemStatement();

        if (statement == null || statement.length() < MIN_PROBLEM_STATEMENT_LENGTH) {
            return false;
        }

        // Remove common markup and check actual content
        String cleanStatement = statement.toLowerCase()
            .replaceAll("```[\\s\\S]*?```", "") // Remove code blocks
            .replaceAll("\\s+", " ")
            .trim();

        if (cleanStatement.length() < MIN_PROBLEM_STATEMENT_LENGTH) {
            return false;
        }

        // Must not be just a one-liner
        String[] sentences = statement.split("[.!?]+");
        if (sentences.length < 2) {
            return false;
        }

        // Should contain some explanation or context
        return statement.contains("when") ||
               statement.contains("expected") ||
               statement.contains("actual") ||
               statement.contains("reproduce") ||
               statement.contains("steps") ||
               statement.contains("because") ||
               statement.contains("should");
    }

    /**
     * Check if this represents a real-world bug or feature
     */
    private boolean isRealWorldIssue(TaskInstance task) {
        String statement = task.getProblemStatement().toLowerCase();

        // Reject low-quality issues
        for (String pattern : LOW_QUALITY_PATTERNS) {
            if (statement.contains(pattern) && !containsCodeChange(statement)) {
                return false;
            }
        }

        // Must match at least one high-quality pattern
        boolean hasQualityIndicator = false;
        for (String pattern : HIGH_QUALITY_PATTERNS) {
            if (statement.contains(pattern)) {
                hasQualityIndicator = true;
                break;
            }
        }

        if (!hasQualityIndicator) {
            logger.debug("Issue lacks quality indicators: {}",
                task.getProblemStatement().substring(0, Math.min(100, task.getProblemStatement().length())));
            return false;
        }

        return true;
    }

    /**
     * Check if patch is of reasonable quality
     */
    private boolean hasQualityPatch(TaskInstance task) {
        String patch = task.getPatch();

        if (patch == null || patch.isEmpty()) {
            return false;
        }

        // Count actual code changes (not headers)
        String[] lines = patch.split("\n");
        int codeChanges = 0;
        int additions = 0;
        int deletions = 0;

        for (String line : lines) {
            if (line.startsWith("+") && !line.startsWith("+++")) {
                additions++;
                codeChanges++;
            } else if (line.startsWith("-") && !line.startsWith("---")) {
                deletions++;
                codeChanges++;
            }
        }

        // Must have minimum changes but not too large
        if (codeChanges < MIN_PATCH_LINES || codeChanges > MAX_PATCH_LINES) {
            logger.debug("Patch has {} code changes (need {}-{})",
                codeChanges, MIN_PATCH_LINES, MAX_PATCH_LINES);
            return false;
        }

        // Reject patches that are only deletions (likely cleanup)
        if (additions == 0 && deletions > 0) {
            logger.debug("Patch is deletion-only");
            return false;
        }

        // Must affect actual Java code files
        if (!patch.contains(".java")) {
            logger.debug("Patch doesn't modify Java files");
            return false;
        }

        return true;
    }

    /**
     * Check if tests are meaningful and sufficient
     */
    private boolean hasQualityTests(TaskInstance task) {
        String patch = task.getPatch();

        if (patch == null) {
            return false;
        }

        // Count test-related changes
        String[] lines = patch.split("\n");
        int testChanges = 0;
        int assertions = 0;
        boolean hasTestFile = false;

        for (String line : lines) {
            String lowerLine = line.toLowerCase();

            // Check if modifying test files
            if (lowerLine.contains("test") && lowerLine.contains(".java")) {
                hasTestFile = true;
            }

            // Count test additions
            if (line.startsWith("+") && !line.startsWith("+++")) {
                if (lowerLine.contains("@test") ||
                    lowerLine.contains("test") ||
                    lowerLine.contains("assert") ||
                    lowerLine.contains("verify") ||
                    lowerLine.contains("expect")) {
                    testChanges++;
                }

                // Count assertions
                if (TEST_ASSERTION_PATTERN.matcher(line).find()) {
                    assertions++;
                }
            }
        }

        if (!hasTestFile) {
            logger.debug("No test files modified");
            return false;
        }

        if (testChanges < MIN_TEST_CHANGES) {
            logger.debug("Insufficient test changes: {} (need {})", testChanges, MIN_TEST_CHANGES);
            return false;
        }

        if (assertions == 0) {
            logger.debug("No assertions found in test changes");
            return false;
        }

        return true;
    }

    /**
     * Check if this is a trivial change
     */
    private boolean isTrivialChange(TaskInstance task) {
        String statement = task.getProblemStatement().toLowerCase();

        for (String pattern : TRIVIAL_PATTERNS) {
            if (statement.contains(pattern)) {
                return true;
            }
        }

        // Check if patch is only whitespace/formatting
        String patch = task.getPatch();
        if (patch != null) {
            String[] lines = patch.split("\n");
            int substantiveChanges = 0;

            for (String line : lines) {
                if (line.startsWith("+") || line.startsWith("-")) {
                    String content = line.substring(1).trim();
                    // Check if line has actual code (not just whitespace/braces)
                    if (!content.isEmpty() &&
                        !content.equals("{") &&
                        !content.equals("}") &&
                        !content.equals("(") &&
                        !content.equals(")")) {
                        substantiveChanges++;
                    }
                }
            }

            if (substantiveChanges < 3) {
                logger.debug("Patch has only {} substantive changes", substantiveChanges);
                return true;
            }
        }

        return false;
    }

    /**
     * Check if statement contains code-related content
     */
    private boolean containsCodeChange(String statement) {
        return statement.contains("code") ||
               statement.contains("method") ||
               statement.contains("function") ||
               statement.contains("class") ||
               statement.contains("implementation") ||
               statement.contains("logic");
    }

    /**
     * Validate that task has proper fail-to-pass test structure
     */
    public boolean hasValidFailToPassTests(TaskInstance task) {
        List<String> failToPass = task.getFailToPass();

        if (failToPass == null || failToPass.isEmpty()) {
            logger.debug("Task {} has no FAIL_TO_PASS tests defined", task.getInstanceId());
            return false;
        }

        // Allow __ALL_TESTS__ marker for auto-detection
        if (failToPass.size() == 1 && "__ALL_TESTS__".equals(failToPass.get(0))) {
            logger.debug("Task {} uses __ALL_TESTS__ marker - will run full test suite", task.getInstanceId());
            return true;
        }

        // Should have at least 1 but not too many (focused fix)
        if (failToPass.size() > 10) {
            logger.debug("Task {} has too many FAIL_TO_PASS tests: {}",
                task.getInstanceId(), failToPass.size());
            return false;
        }

        // Validate test names are meaningful
        for (String test : failToPass) {
            if (test == null || test.length() < 5) {
                logger.debug("Task {} has invalid test name: {}", task.getInstanceId(), test);
                return false;
            }
        }

        return true;
    }

    /**
     * Calculate overall quality score (0-100)
     */
    public int calculateQualityScore(TaskInstance task) {
        int score = 0;

        // Problem statement (0-25 points)
        if (hasMeaningfulProblemStatement(task)) {
            score += 25;
            if (task.getProblemStatement().length() > 300) score += 5;
            if (task.getProblemStatement().contains("reproduce")) score += 5;
        }

        // Real-world relevance (0-25 points)
        if (isRealWorldIssue(task)) {
            score += 25;
        }

        // Patch quality (0-25 points)
        if (hasQualityPatch(task)) {
            score += 25;
        }

        // Test quality (0-25 points)
        if (hasQualityTests(task)) {
            score += 20;
            if (hasValidFailToPassTests(task)) score += 5;
        }

        return Math.min(score, 100);
    }

    /**
     * Get quality rating
     */
    public String getQualityRating(int score) {
        if (score >= 90) return "EXCELLENT";
        if (score >= 75) return "GOOD";
        if (score >= 60) return "ACCEPTABLE";
        if (score >= 40) return "POOR";
        return "REJECTED";
    }
}
