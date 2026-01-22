package com.swebench.service;

import com.swebench.model.TaskInstance;
import com.swebench.util.FileLogger;

import java.util.regex.Pattern;
import java.util.*;

/**
 * Classifies bugs to prioritize FUNCTIONAL bugs over simple/syntax issues.
 *
 * FUNCTIONAL BUGS (High Priority - What we want):
 * - Logic errors (wrong calculations, incorrect conditions)
 * - Null pointer handling issues
 * - Concurrency/threading bugs
 * - Resource leaks (memory, connections)
 * - Security vulnerabilities
 * - API contract violations
 * - Edge case handling failures
 *
 * NON-FUNCTIONAL BUGS (Low Priority - What we avoid):
 * - Typos in strings/comments
 * - Formatting/style changes
 * - Documentation updates
 * - Simple refactoring
 * - Dependency version bumps
 * - Build configuration changes
 */
public class BugClassifier {

    // Patterns indicating FUNCTIONAL bugs (high value)
    private static final List<Pattern> FUNCTIONAL_PATTERNS = Arrays.asList(
        // Null handling
        Pattern.compile("(?i)(null\\s*pointer|npe|nullpointerexception|null\\s*check|null\\s*safe)"),
        // Logic errors
        Pattern.compile("(?i)(incorrect|wrong|invalid|broken|logic\\s*error|calculation)"),
        // Exception handling
        Pattern.compile("(?i)(exception|throw|catch|error\\s*handling|unhandled)"),
        // Concurrency
        Pattern.compile("(?i)(thread|concurren|synchron|deadlock|race\\s*condition|atomic)"),
        // Resource management
        Pattern.compile("(?i)(memory\\s*leak|resource\\s*leak|connection\\s*leak|close|dispose)"),
        // Security
        Pattern.compile("(?i)(security|vulnerab|injection|xss|csrf|auth|permission)"),
        // Data handling
        Pattern.compile("(?i)(data\\s*loss|corrupt|overflow|underflow|truncat)"),
        // API issues
        Pattern.compile("(?i)(api|contract|interface|backward|compat)"),
        // Edge cases
        Pattern.compile("(?i)(edge\\s*case|boundary|corner\\s*case|empty|zero|negative)"),
        // Performance bugs
        Pattern.compile("(?i)(performance|slow|timeout|infinite\\s*loop|hang)")
    );

    // Patterns indicating NON-FUNCTIONAL issues (low value)
    private static final List<Pattern> NON_FUNCTIONAL_PATTERNS = Arrays.asList(
        // Typos
        Pattern.compile("(?i)(typo|spelling|grammar|wording)"),
        // Documentation
        Pattern.compile("(?i)(doc|readme|comment|javadoc|documentation)"),
        // Formatting
        Pattern.compile("(?i)(format|indent|whitespace|style|lint)"),
        // Refactoring
        Pattern.compile("(?i)(refactor|rename|cleanup|reorganiz|restructur)"),
        // Dependencies
        Pattern.compile("(?i)(bump|upgrade|version|dependency|pom\\.xml|build\\.gradle)"),
        // Build config
        Pattern.compile("(?i)(build\\s*config|ci|travis|jenkins|github\\s*action)"),
        // Simple additions
        Pattern.compile("(?i)(add\\s*test|add\\s*logging|add\\s*comment)")
    );

    // Patterns in code changes indicating functional fix
    private static final List<Pattern> FUNCTIONAL_CODE_PATTERNS = Arrays.asList(
        // Null checks added
        Pattern.compile("\\+.*!=\\s*null"),
        Pattern.compile("\\+.*==\\s*null"),
        Pattern.compile("\\+.*Objects\\.requireNonNull"),
        Pattern.compile("\\+.*Optional"),
        // Condition changes
        Pattern.compile("\\+.*if\\s*\\("),
        Pattern.compile("\\+.*else"),
        Pattern.compile("-.*if\\s*\\(.*\\+.*if\\s*\\("),
        // Exception handling
        Pattern.compile("\\+.*try\\s*\\{"),
        Pattern.compile("\\+.*catch\\s*\\("),
        Pattern.compile("\\+.*throw\\s+new"),
        // Synchronization
        Pattern.compile("\\+.*synchronized"),
        Pattern.compile("\\+.*Lock"),
        Pattern.compile("\\+.*Atomic"),
        // Resource management
        Pattern.compile("\\+.*try\\s*\\("),  // try-with-resources
        Pattern.compile("\\+.*\\.close\\("),
        Pattern.compile("\\+.*finally\\s*\\{")
    );

    /**
     * Classify a bug and return its type
     */
    public BugType classify(TaskInstance task) {
        String problemStatement = task.getProblemStatement() != null ? task.getProblemStatement() : "";
        String patch = task.getPatch() != null ? task.getPatch() : "";

        int functionalScore = 0;
        int nonFunctionalScore = 0;
        List<String> reasons = new ArrayList<>();

        // Check problem statement for functional indicators
        for (Pattern p : FUNCTIONAL_PATTERNS) {
            if (p.matcher(problemStatement).find()) {
                functionalScore += 10;
                reasons.add("Issue mentions: " + getPatternName(p));
            }
        }

        // Check problem statement for non-functional indicators
        for (Pattern p : NON_FUNCTIONAL_PATTERNS) {
            if (p.matcher(problemStatement).find()) {
                nonFunctionalScore += 15;  // Higher penalty
                reasons.add("Issue is about: " + getPatternName(p));
            }
        }

        // Check patch for functional code changes
        for (Pattern p : FUNCTIONAL_CODE_PATTERNS) {
            if (p.matcher(patch).find()) {
                functionalScore += 5;
                reasons.add("Patch contains: " + getPatternName(p));
            }
        }

        // Analyze patch content
        PatchAnalysis patchAnalysis = analyzePatch(patch);
        functionalScore += patchAnalysis.functionalScore;
        nonFunctionalScore += patchAnalysis.nonFunctionalScore;
        reasons.addAll(patchAnalysis.reasons);

        // Determine bug type
        BugType type;
        if (nonFunctionalScore > functionalScore + 10) {
            type = BugType.NON_FUNCTIONAL;
        } else if (functionalScore >= 20) {
            type = BugType.FUNCTIONAL_HIGH;
        } else if (functionalScore >= 10) {
            type = BugType.FUNCTIONAL_MEDIUM;
        } else if (functionalScore > nonFunctionalScore) {
            type = BugType.FUNCTIONAL_LOW;
        } else {
            type = BugType.UNKNOWN;
        }

        // Log classification
        FileLogger.logBugClassification(
            task.getInstanceId(),
            type.name(),
            functionalScore - nonFunctionalScore,
            String.join("; ", reasons)
        );

        return type;
    }

    /**
     * Calculate functional bug score (higher = more functional)
     */
    public int calculateFunctionalScore(TaskInstance task) {
        String problemStatement = task.getProblemStatement() != null ? task.getProblemStatement() : "";
        String patch = task.getPatch() != null ? task.getPatch() : "";

        int score = 0;

        // Positive indicators
        for (Pattern p : FUNCTIONAL_PATTERNS) {
            if (p.matcher(problemStatement).find()) score += 10;
        }
        for (Pattern p : FUNCTIONAL_CODE_PATTERNS) {
            if (p.matcher(patch).find()) score += 5;
        }

        // Negative indicators
        for (Pattern p : NON_FUNCTIONAL_PATTERNS) {
            if (p.matcher(problemStatement).find()) score -= 15;
        }

        // Patch analysis
        PatchAnalysis analysis = analyzePatch(patch);
        score += analysis.functionalScore - analysis.nonFunctionalScore;

        return score;
    }

    /**
     * Check if task is likely a functional bug
     */
    public boolean isFunctionalBug(TaskInstance task) {
        BugType type = classify(task);
        return type == BugType.FUNCTIONAL_HIGH || type == BugType.FUNCTIONAL_MEDIUM;
    }

    /**
     * Analyze patch content for functional vs non-functional changes
     */
    private PatchAnalysis analyzePatch(String patch) {
        PatchAnalysis analysis = new PatchAnalysis();

        if (patch == null || patch.isEmpty()) {
            return analysis;
        }

        String[] lines = patch.split("\n");
        int javaChanges = 0;
        int testChanges = 0;
        int configChanges = 0;
        int docChanges = 0;

        for (String line : lines) {
            if (line.startsWith("+") || line.startsWith("-")) {
                String content = line.substring(1).trim();

                // Skip empty lines
                if (content.isEmpty()) continue;

                // Count by file type (from diff headers)
                if (line.contains(".java") && !line.contains("Test.java")) {
                    javaChanges++;
                } else if (line.contains("Test.java") || line.contains("test/")) {
                    testChanges++;
                } else if (line.contains(".xml") || line.contains(".gradle") || line.contains(".properties")) {
                    configChanges++;
                } else if (line.contains(".md") || line.contains(".txt") || line.contains("README")) {
                    docChanges++;
                }

                // Check for logic changes in Java code
                if (content.contains("if") || content.contains("else") ||
                    content.contains("for") || content.contains("while") ||
                    content.contains("return") || content.contains("throw")) {
                    analysis.functionalScore += 2;
                }

                // Check for comment-only changes
                if (content.startsWith("//") || content.startsWith("*") || content.startsWith("/*")) {
                    analysis.nonFunctionalScore += 1;
                }
            }
        }

        // Score based on change distribution
        if (javaChanges > testChanges && javaChanges > configChanges) {
            analysis.functionalScore += 10;
            analysis.reasons.add("Primarily Java source changes");
        }

        if (docChanges > javaChanges) {
            analysis.nonFunctionalScore += 20;
            analysis.reasons.add("Mostly documentation changes");
        }

        if (configChanges > javaChanges) {
            analysis.nonFunctionalScore += 15;
            analysis.reasons.add("Mostly config changes");
        }

        return analysis;
    }

    private String getPatternName(Pattern p) {
        String pattern = p.pattern();
        // Extract readable name from pattern
        if (pattern.contains("null")) return "null-handling";
        if (pattern.contains("exception")) return "exception-handling";
        if (pattern.contains("thread") || pattern.contains("concurren")) return "concurrency";
        if (pattern.contains("security")) return "security";
        if (pattern.contains("typo")) return "typo-fix";
        if (pattern.contains("doc")) return "documentation";
        if (pattern.contains("refactor")) return "refactoring";
        return "pattern-match";
    }

    /**
     * Bug type classification
     */
    public enum BugType {
        FUNCTIONAL_HIGH,    // Definitely a functional bug (logic, null, concurrency)
        FUNCTIONAL_MEDIUM,  // Likely functional (exception handling, edge cases)
        FUNCTIONAL_LOW,     // Possibly functional
        NON_FUNCTIONAL,     // Typo, docs, formatting, refactoring
        UNKNOWN             // Can't determine
    }

    /**
     * Patch analysis result
     */
    private static class PatchAnalysis {
        int functionalScore = 0;
        int nonFunctionalScore = 0;
        List<String> reasons = new ArrayList<>();
    }
}
