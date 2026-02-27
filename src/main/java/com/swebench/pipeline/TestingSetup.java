package com.swebench.pipeline;

import com.swebench.model.TaskInstance;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Sets up the testing directory structure for parallel repository validation.
 *
 * Creates:
 * - data/testing/{repo-name}/
 *   - patches/
 *     - test-patch-{PRNumber}.patch
 *     - code-patch-{PRNumber}.patch
 *   - tasks.json (all tasks for this repo)
 *   - TASKS_STATUS.md (results template)
 */
public class TestingSetup {
    private static final Logger logger = LoggerFactory.getLogger(TestingSetup.class);
    private static final String INPUT_FILE = "data/processed/candidate_tasks.json";
    private static final String TESTING_DIR = "data/testing";

    private final ObjectMapper objectMapper;

    public TestingSetup() {
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }

    public void execute() {
        logger.info("Setting up testing directory structure");

        try {
            // Load candidate tasks
            List<TaskInstance> tasks = loadCandidateTasks();
            logger.info("Loaded {} tasks", tasks.size());

            // Group tasks by repository
            Map<String, List<TaskInstance>> tasksByRepo = tasks.stream()
                .collect(Collectors.groupingBy(TaskInstance::getRepo));

            logger.info("Tasks grouped into {} repositories", tasksByRepo.size());

            // Create testing directory structure for each repo
            for (Map.Entry<String, List<TaskInstance>> entry : tasksByRepo.entrySet()) {
                String repo = entry.getKey();
                List<TaskInstance> repoTasks = entry.getValue();

                setupRepoDirectory(repo, repoTasks);
            }

            // Generate summary
            generateSummary(tasksByRepo);

            logger.info("Testing setup complete!");

        } catch (Exception e) {
            logger.error("Testing setup failed", e);
            throw new RuntimeException("Testing setup failed", e);
        }
    }

    private List<TaskInstance> loadCandidateTasks() throws IOException {
        File inputFile = new File(INPUT_FILE);
        if (!inputFile.exists()) {
            throw new IOException("Candidate tasks not found: " + INPUT_FILE);
        }

        TaskInstance[] tasks = objectMapper.readValue(inputFile, TaskInstance[].class);
        return Arrays.asList(tasks);
    }

    private void setupRepoDirectory(String repo, List<TaskInstance> tasks) throws IOException {
        // Create directory name from repo (e.g., "apache/commons-lang" -> "apache-commons-lang")
        String dirName = repo.replace("/", "-");
        File repoDir = new File(TESTING_DIR, dirName);
        File patchesDir = new File(repoDir, "patches");

        // Create directories
        repoDir.mkdirs();
        patchesDir.mkdirs();

        logger.info("Setting up {} with {} tasks", dirName, tasks.size());

        // Generate patch files for each task
        for (TaskInstance task : tasks) {
            generatePatchFiles(patchesDir, task);
        }

        // Save tasks.json for this repo
        File tasksFile = new File(repoDir, "tasks.json");
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(tasksFile, tasks);

        // Generate TASKS_STATUS.md template
        generateStatusTemplate(repoDir, repo, tasks);

        // Generate run script
        generateRunScript(repoDir, repo, tasks);

        logger.info("Created {} patch files for {}", tasks.size() * 2, dirName);
    }

    private void generatePatchFiles(File patchesDir, TaskInstance task) throws IOException {
        int prNumber = task.getPullNumber();

        // Test patch file
        if (task.getTestPatch() != null && !task.getTestPatch().isEmpty()) {
            File testPatchFile = new File(patchesDir, "test-patch-" + prNumber + ".patch");
            Files.writeString(testPatchFile.toPath(), task.getTestPatch());
        }

        // Code patch file
        if (task.getPatch() != null && !task.getPatch().isEmpty()) {
            File codePatchFile = new File(patchesDir, "code-patch-" + prNumber + ".patch");
            Files.writeString(codePatchFile.toPath(), task.getPatch());
        }
    }

    private void generateStatusTemplate(File repoDir, String repo, List<TaskInstance> tasks) throws IOException {
        File statusFile = new File(repoDir, "TASKS_STATUS.md");

        try (PrintWriter writer = new PrintWriter(new FileWriter(statusFile))) {
            writer.println("# Task Validation Status: " + repo);
            writer.println();
            writer.println("Generated: " + java.time.LocalDateTime.now());
            writer.println();
            writer.println("## Legend");
            writer.println("- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)");
            writer.println("- **INVALID-PASS-PASS**: Tests pass both before and after");
            writer.println("- **INVALID-FAIL-FAIL**: Tests fail both before and after");
            writer.println("- **ERROR**: Could not run validation");
            writer.println("- **PENDING**: Not yet tested");
            writer.println();
            writer.println("---");
            writer.println();
            writer.println("## Tasks");
            writer.println();
            writer.println("| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |");
            writer.println("|------|-------------|----------------|------------------|------------------|--------|-------|");

            for (TaskInstance task : tasks) {
                String testClasses = task.getFailToPass() != null ?
                    String.join(", ", task.getFailToPass()) : "N/A";
                String baseCommit = task.getBaseCommit();
                if (baseCommit != null && baseCommit.length() > 7) {
                    baseCommit = baseCommit.substring(0, 7) + "...";
                }

                writer.printf("| %d | %s | %s | PENDING | PENDING | PENDING | |%n",
                    task.getPullNumber(),
                    baseCommit,
                    testClasses);
            }

            writer.println();
            writer.println("---");
            writer.println();
            writer.println("## Validation Commands");
            writer.println();
            writer.println("```bash");
            writer.println("# 1. Clone repository (if not already cloned)");
            writer.println("git clone https://github.com/" + repo + ".git repo");
            writer.println();
            writer.println("# 2. For each PR, run validation:");
            writer.println("# Example for PR-XXXX:");
            writer.println("cd repo");
            writer.println("git checkout {base_commit}");
            writer.println("git apply ../patches/test-patch-XXXX.patch");
            writer.println("mvn test -Dtest=TestClassName  # Should FAIL");
            writer.println("git apply ../patches/code-patch-XXXX.patch");
            writer.println("mvn test -Dtest=TestClassName  # Should PASS");
            writer.println("```");
        }
    }

    private void generateRunScript(File repoDir, String repo, List<TaskInstance> tasks) throws IOException {
        // Generate PowerShell script for Windows
        File scriptFile = new File(repoDir, "run-validation.ps1");

        try (PrintWriter writer = new PrintWriter(new FileWriter(scriptFile))) {
            writer.println("# Validation Script for " + repo);
            writer.println("# Generated: " + java.time.LocalDateTime.now());
            writer.println();
            writer.println("$ErrorActionPreference = 'Continue'");
            writer.println();
            writer.println("# Get script directory for proper relative paths");
            writer.println("$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path");
            writer.println("$REPO_DIR = Join-Path $SCRIPT_DIR 'repo'");
            writer.println("$PATCHES_DIR = Join-Path $SCRIPT_DIR 'patches'");
            writer.println();
            writer.println("# Clone repository if not exists");
            writer.println("if (-not (Test-Path $REPO_DIR)) {");
            writer.println("    Write-Host 'Cloning " + repo + "...'");
            writer.println("    git clone https://github.com/" + repo + ".git $REPO_DIR");
            writer.println("}");
            writer.println();
            writer.println("Push-Location $REPO_DIR");
            writer.println();
            writer.println("$results = @()");
            writer.println("$validCount = 0");
            writer.println("$invalidPPCount = 0");
            writer.println("$invalidFFCount = 0");
            writer.println();

            for (TaskInstance task : tasks) {
                int pr = task.getPullNumber();
                String baseCommit = task.getBaseCommit();
                String buildTool = task.getBuildTool() != null ? task.getBuildTool().toLowerCase() : "maven";
                String testCommand = task.getTestCommand();

                // Use build-tool-aware default if testCommand is null
                if (testCommand == null) {
                    testCommand = buildTool.equals("gradle") ? ".\\gradlew.bat test" : "mvn test";
                }
                // Escape quotes for PowerShell cmd /c wrapper
                String escapedTestCommand = testCommand.replace("\"", "\\\"");

                writer.println("# PR-" + pr);
                writer.println("Write-Host '=== Validating PR-" + pr + " ===' -ForegroundColor Cyan");
                writer.println("git checkout " + baseCommit + " --force 2>$null");
                writer.println("git clean -fd 2>$null");
                writer.println();
                writer.println("# Apply test patch");
                writer.println("git apply '$PATCHES_DIR/test-patch-" + pr + ".patch' 2>$null");
                writer.println();
                writer.println("# Run tests (expect FAIL)");
                writer.println("& cmd /c \"" + escapedTestCommand + "\" 2>&1 | Out-Null");
                writer.println("$afterTestPatch = $LASTEXITCODE");
                writer.println();
                writer.println("# Apply code patch");
                writer.println("git apply '$PATCHES_DIR/code-patch-" + pr + ".patch' 2>$null");
                writer.println();
                writer.println("# Run tests (expect PASS)");
                writer.println("& cmd /c \"" + escapedTestCommand + "\" 2>&1 | Out-Null");
                writer.println("$afterCodePatch = $LASTEXITCODE");
                writer.println();
                writer.println("# Determine status");
                writer.println("$status = 'UNKNOWN'");
                writer.println("if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) {");
                writer.println("    $status = 'VALID'");
                writer.println("    $validCount++");
                writer.println("    Write-Host \"PR-" + pr + ": ✓ $status\" -ForegroundColor Green");
                writer.println("} elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) {");
                writer.println("    $status = 'INVALID-PASS-PASS'");
                writer.println("    $invalidPPCount++");
                writer.println("    Write-Host \"PR-" + pr + ": ✗ $status\" -ForegroundColor Yellow");
                writer.println("} else {");
                writer.println("    $status = 'INVALID-FAIL-FAIL'");
                writer.println("    $invalidFFCount++");
                writer.println("    Write-Host \"PR-" + pr + ": ✗ $status\" -ForegroundColor Red");
                writer.println("}");
                writer.println("$results += [PSCustomObject]@{ PR=" + pr + "; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }");
                writer.println();
            }

            writer.println("# Summary");
            writer.println("Write-Host ''");
            writer.println("Write-Host '=========================================' -ForegroundColor Green");
            writer.println("Write-Host 'VALIDATION COMPLETE' -ForegroundColor Green");
            writer.println("Write-Host '=========================================' -ForegroundColor Green");
            writer.println("$totalCount = $results.Count");
            writer.println("Write-Host \"Total Tasks:           $totalCount\"");
            writer.println("Write-Host \"VALID (FAIL→PASS):     $validCount\"");
            writer.println("Write-Host \"INVALID (PASS-PASS):   $invalidPPCount\"");
            writer.println("Write-Host \"INVALID (FAIL-FAIL):   $invalidFFCount\"");
            writer.println();
            writer.println("if ($totalCount -gt 0) {");
            writer.println("    $successRate = [math]::Round(($validCount / $totalCount) * 100)");
            writer.println("    Write-Host \"Success Rate:          $successRate%\"");
            writer.println("}");
            writer.println();
            writer.println("# Update TASKS_STATUS.md with results");
            writer.println("Pop-Location");
            writer.println("$statusFile = Join-Path $SCRIPT_DIR 'TASKS_STATUS.md'");
            writer.println();
            writer.println("$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'");
            writer.println("$resultsText = \"");
            writer.println("\\\");");
            writer.println("## Validation Results");
            writer.println();
            writer.println("- **Timestamp:** $timestamp");
            writer.println("- **Total Tasks:** $totalCount");
            writer.println("- **VALID:** $validCount");
            writer.println("- **INVALID-PASS-PASS:** $invalidPPCount");
            writer.println("- **INVALID-FAIL-FAIL:** $invalidFFCount");
            writer.println();
            writer.println("if ($totalCount -gt 0) {");
            writer.println("    \\$resultsText += \\\"- **Success Rate:** $successRate%`n`n\\\"");
            writer.println("}");
            writer.println();
            writer.println("### Detailed Results");
            writer.println();
            writer.println("| PR # | Status | After test_patch | After code_patch |`n\\");
            writer.println("|------|--------|------------------|------------------|`n\\");
            writer.println();
            writer.println("foreach (\\$result in \\$results) {");
            writer.println("    \\$resultsText += \\\"| \\$(\\$result.PR) | \\$(\\$result.Status) | \\$(\\$result.AfterTest) | \\$(\\$result.AfterCode) |`n\\\"");
            writer.println("}");
            writer.println();
            writer.println("\\$resultsText += \\\"`nVALIDATION_COMPLETE`n\\\"");
            writer.println();
            writer.println("Add-Content -Path \\$statusFile -Value \\$resultsText");
            writer.println();
            writer.println("Write-Host 'Results saved to TASKS_STATUS.md' -ForegroundColor Green");
        }

        // Also generate bash script for Linux/Mac
        File bashScript = new File(repoDir, "run-validation.sh");
        try (PrintWriter writer = new PrintWriter(new FileWriter(bashScript))) {
            writer.println("#!/bin/bash");
            writer.println("# Validation Script for " + repo);
            writer.println("# Generated: " + java.time.LocalDateTime.now());
            writer.println();
            writer.println("set +e  # Don't exit on error");
            writer.println();
            writer.println("# Get script directory for proper relative paths");
            writer.println("SCRIPT_DIR=\"$(cd \"$(dirname \"${BASH_SOURCE[0]}\")\" && pwd)\"");
            writer.println("REPO_DIR=\"$SCRIPT_DIR/repo\"");
            writer.println("PATCHES_DIR=\"$SCRIPT_DIR/patches\"");
            writer.println();
            writer.println("# Clone repository if not exists");
            writer.println("if [ ! -d \"$REPO_DIR\" ]; then");
            writer.println("    echo 'Cloning " + repo + "...'");
            writer.println("    git clone https://github.com/" + repo + ".git \"$REPO_DIR\"");
            writer.println("fi");
            writer.println();
            writer.println("cd \"$REPO_DIR\"");
            writer.println();
            writer.println("# Result tracking");
            writer.println("VALID_COUNT=0");
            writer.println("INVALID_PP_COUNT=0");
            writer.println("INVALID_FF_COUNT=0");
            writer.println("TOTAL_COUNT=0");
            writer.println();
            writer.println("# Detailed results for markdown");
            writer.println("RESULTS_TABLE=\"\"");
            writer.println();

            for (TaskInstance task : tasks) {
                int pr = task.getPullNumber();
                String baseCommit = task.getBaseCommit();
                String buildTool = task.getBuildTool() != null ? task.getBuildTool().toLowerCase() : "maven";
                String testCommand = task.getTestCommand();

                // Use build-tool-aware default if testCommand is null
                if (testCommand == null) {
                    testCommand = buildTool.equals("gradle") ? "./gradlew test" : "mvn test";
                }

                writer.println("# PR-" + pr);
                writer.println("echo '=== Validating PR-" + pr + " ==='");
                writer.println("git checkout " + baseCommit + " --force 2>/dev/null");
                writer.println("git clean -fd 2>/dev/null");
                writer.println();
                writer.println("# Apply test patch");
                writer.println("git apply \"$PATCHES_DIR/test-patch-" + pr + ".patch\" 2>/dev/null");
                writer.println();
                writer.println("# Run tests (expect FAIL)");
                writer.println(testCommand + " > /dev/null 2>&1");
                writer.println("AFTER_TEST=$?");
                writer.println();
                writer.println("# Apply code patch");
                writer.println("git apply \"$PATCHES_DIR/code-patch-" + pr + ".patch\" 2>/dev/null");
                writer.println();
                writer.println("# Run tests (expect PASS)");
                writer.println(testCommand + " > /dev/null 2>&1");
                writer.println("AFTER_CODE=$?");
                writer.println();
                writer.println("# Determine status");
                writer.println("if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then");
                writer.println("    STATUS=\"VALID\"");
                writer.println("    ((VALID_COUNT++))");
                writer.println("    echo 'PR-" + pr + ": ✓ VALID'");
                writer.println("elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then");
                writer.println("    STATUS=\"INVALID-PASS-PASS\"");
                writer.println("    ((INVALID_PP_COUNT++))");
                writer.println("    echo 'PR-" + pr + ": ✗ INVALID-PASS-PASS'");
                writer.println("else");
                writer.println("    STATUS=\"INVALID-FAIL-FAIL\"");
                writer.println("    ((INVALID_FF_COUNT++))");
                writer.println("    echo 'PR-" + pr + ": ✗ INVALID-FAIL-FAIL'");
                writer.println("fi");
                writer.println("RESULTS_TABLE=\"${RESULTS_TABLE}| " + pr + " | ${STATUS} | ${AFTER_TEST} | ${AFTER_CODE} |\\n\"");
                writer.println("((TOTAL_COUNT++))");
                writer.println();
            }

            writer.println("# Generate summary");
            writer.println("echo ''");
            writer.println("echo '========================================='");
            writer.println("echo 'VALIDATION COMPLETE'");
            writer.println("echo '========================================='");
            writer.println("echo \"Total Tasks:           $TOTAL_COUNT\"");
            writer.println("echo \"VALID (FAIL→PASS):     $VALID_COUNT\"");
            writer.println("echo \"INVALID (PASS-PASS):   $INVALID_PP_COUNT\"");
            writer.println("echo \"INVALID (FAIL-FAIL):   $INVALID_FF_COUNT\"");
            writer.println();
            writer.println("if [ $TOTAL_COUNT -gt 0 ]; then");
            writer.println("    SUCCESS_RATE=$((VALID_COUNT * 100 / TOTAL_COUNT))");
            writer.println("    echo \"Success Rate:          ${SUCCESS_RATE}%\"");
            writer.println("fi");
            writer.println();
            // Calculate percentages BEFORE the heredoc — they are bash vars inside heredoc,
            // and the if/fi logic cannot run inside a heredoc body (it would be literal text).
            writer.println("# Calculate summary percentages");
            writer.println("if [ $TOTAL_COUNT -gt 0 ]; then");
            writer.println("    VALID_PCT=$((VALID_COUNT * 100 / TOTAL_COUNT))");
            writer.println("    PP_PCT=$((INVALID_PP_COUNT * 100 / TOTAL_COUNT))");
            writer.println("    FF_PCT=$((INVALID_FF_COUNT * 100 / TOTAL_COUNT))");
            writer.println("else");
            writer.println("    VALID_PCT=0; PP_PCT=0; FF_PCT=0");
            writer.println("fi");
            writer.println();
            // Overwrite the whole file (cat >) so results are self-contained.
            // Unquoted delimiter STATUSEOF so $VAR references expand to real values.
            // printf '%b' converts the literal \n in RESULTS_TABLE into real newlines.
            writer.println("# Write complete results to TASKS_STATUS.md");
            writer.println("cd \"$SCRIPT_DIR\"");
            writer.println("cat > TASKS_STATUS.md << STATUSEOF");
            writer.println("# Task Validation Status: " + repo);
            writer.println();
            writer.println("**VALIDATION_COMPLETE: $(date '+%Y-%m-%d %H:%M:%S')**");
            writer.println();
            writer.println("## Summary");
            writer.println();
            writer.println("- **Total Tasks:** $TOTAL_COUNT");
            writer.println("- **VALID:** $VALID_COUNT (${VALID_PCT}%)");
            writer.println("- **INVALID-PASS-PASS:** $INVALID_PP_COUNT (${PP_PCT}%)");
            writer.println("- **INVALID-FAIL-FAIL:** $INVALID_FF_COUNT (${FF_PCT}%)");
            writer.println();
            writer.println("## Legend");
            writer.println();
            writer.println("- **VALID**: Tests FAIL after test_patch, PASS after code_patch");
            writer.println("- **INVALID-PASS-PASS**: Tests pass both before and after");
            writer.println("- **INVALID-FAIL-FAIL**: Tests fail both before and after");
            writer.println();
            writer.println("---");
            writer.println();
            writer.println("## Tasks");
            writer.println();
            writer.println("| PR # | Status | After test_patch | After code_patch |");
            writer.println("|------|--------|------------------|------------------|");
            writer.println("$(printf '%b' \"$RESULTS_TABLE\")");
            writer.println();
            writer.println("---");
            writer.println();
            writer.println("**Validation completed:** $(date)");
            writer.println("STATUSEOF");
            writer.println();
            writer.println("echo \"TASKS_STATUS.md updated: $SCRIPT_DIR/TASKS_STATUS.md\"");
        }
    }

    private void generateSummary(Map<String, List<TaskInstance>> tasksByRepo) throws IOException {
        File summaryFile = new File(TESTING_DIR, "TESTING_SUMMARY.md");

        try (PrintWriter writer = new PrintWriter(new FileWriter(summaryFile))) {
            writer.println("# Testing Directory Summary");
            writer.println();
            writer.println("Generated: " + java.time.LocalDateTime.now());
            writer.println();
            writer.println("## Repositories");
            writer.println();
            writer.println("| Repository | Directory | Tasks | Status |");
            writer.println("|------------|-----------|-------|--------|");

            int totalTasks = 0;
            for (Map.Entry<String, List<TaskInstance>> entry : tasksByRepo.entrySet()) {
                String repo = entry.getKey();
                String dirName = repo.replace("/", "-");
                int taskCount = entry.getValue().size();
                totalTasks += taskCount;

                writer.printf("| %s | `%s/` | %d | PENDING |%n", repo, dirName, taskCount);
            }

            writer.println();
            writer.println("**Total: " + totalTasks + " tasks across " + tasksByRepo.size() + " repositories**");
            writer.println();
            writer.println("## How to Run");
            writer.println();
            writer.println("```powershell");
            writer.println("# Navigate to a repository directory");
            writer.println("cd data/testing/{repo-name}");
            writer.println();
            writer.println("# Run the validation script");
            writer.println(".\\run-validation.ps1");
            writer.println("```");
            writer.println();
            writer.println("Or for parallel execution:");
            writer.println();
            writer.println("```powershell");
            writer.println("# Run all repositories in parallel");
            writer.println("Get-ChildItem -Directory | ForEach-Object -Parallel {");
            writer.println("    Set-Location $_.FullName");
            writer.println("    .\\run-validation.ps1");
            writer.println("} -ThrottleLimit 4");
            writer.println("```");
        }

        logger.info("Generated testing summary at {}", summaryFile.getPath());
    }

    public static void main(String[] args) {
        new TestingSetup().execute();
    }
}
