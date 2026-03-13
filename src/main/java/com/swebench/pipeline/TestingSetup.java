// Part of the benchmark validation pipeline
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

            // Generate orchestration scripts (Docker and native)
            generateDockerOrchestrationScript(tasksByRepo);
            generateNativeOrchestrationScript();

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
            writer.println("# Normalize line endings so patches apply cleanly on Linux containers");
            writer.println("# Use --local to avoid ~/.gitconfig lock contention during parallel runs");
            writer.println("git config --local core.autocrlf input");
            writer.println();
            writer.println("# Recreate git-errors.log safely (previous Docker run may have created it as root)");
            writer.println("rm -f \"$SCRIPT_DIR/git-errors.log\" 2>/dev/null || true");
            writer.println("touch \"$SCRIPT_DIR/git-errors.log\" 2>/dev/null || true");
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
                writer.println("git apply \"$PATCHES_DIR/test-patch-" + pr + ".patch\" 2>> \"$SCRIPT_DIR/git-errors.log\"");
                writer.println();
                writer.println("# Run tests (expect FAIL)");
                writer.println(testCommand + " > /dev/null 2>&1");
                writer.println("AFTER_TEST=$?");
                writer.println();
                writer.println("# Apply code patch");
                writer.println("git apply \"$PATCHES_DIR/code-patch-" + pr + ".patch\" 2>> \"$SCRIPT_DIR/git-errors.log\"");
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

    private void generateNativeOrchestrationScript() throws IOException {
        File script = new File(TESTING_DIR, "run-all-parallel.sh");

        try (PrintWriter w = new PrintWriter(new FileWriter(script))) {
            w.println("#!/bin/bash");
            w.println("# Native parallel validation for all repos (no Docker).");
            w.println("# Generated by TestingSetup — do not edit manually.");
            w.println("# Usage:");
            w.println("#   ./run-all-parallel.sh          # 4 parallel jobs, skip already-validated");
            w.println("#   ./run-all-parallel.sh 4        # 4 parallel jobs");
            w.println("#   ./run-all-parallel.sh 4 --force  # re-run everything");
            w.println();
            w.println("SCRIPT_DIR=\"$(cd \"$(dirname \"${BASH_SOURCE[0]}\")\" && pwd)\"");
            w.println("cd \"$SCRIPT_DIR\"");
            w.println();
            w.println("PARALLEL_JOBS=\"${1:-4}\"");
            w.println("FORCE_MODE=false");
            w.println("for arg in \"$@\"; do");
            w.println("    if [ \"$arg\" = \"--force\" ]; then FORCE_MODE=true; fi");
            w.println("done");
            w.println();
            w.println("echo \"=========================================\"");
            w.println("echo \"Java SWE-Bench Parallel Validation (Native)\"");
            w.println("echo \"=========================================\"");
            w.println("echo \"Mode: $([ \"$FORCE_MODE\" = true ] && echo 'FORCE (re-run all)' || echo 'SMART (skip completed)')\"");
            w.println("echo \"Parallel jobs: $PARALLEL_JOBS\"");
            w.println("echo \"\"");
            w.println();
            w.println("mkdir -p logs");
            w.println("LOG_DIR=\"$SCRIPT_DIR/logs\"");
            w.println();
            w.println("is_validated() {");
            w.println("    local repo_dir=$1");
            w.println("    [ \"$FORCE_MODE\" = true ] && return 1");
            w.println("    [ -f \"$repo_dir/TASKS_STATUS.md\" ] && grep -q \"VALIDATION_COMPLETE\" \"$repo_dir/TASKS_STATUS.md\"");
            w.println("}");
            w.println();
            w.println("validate_repo() {");
            w.println("    local repo_dir=$1");
            w.println("    local repo_name=$(basename \"$repo_dir\")");
            w.println("    local log_file=\"$LOG_DIR/${repo_name}.log\"");
            w.println("    echo \"[$(date '+%H:%M:%S')] Starting: $repo_name\"");
            w.println("    if [ -f \"$repo_dir/run-validation.sh\" ]; then");
            w.println("        bash \"$repo_dir/run-validation.sh\" > \"$log_file\" 2>&1");
            w.println("        local exit_code=$?");
            w.println("        if [ $exit_code -eq 0 ]; then");
            w.println("            echo \"[$(date '+%H:%M:%S')] Done: $repo_name\"");
            w.println("        else");
            w.println("            echo \"[$(date '+%H:%M:%S')] Failed: $repo_name (exit: $exit_code)\"");
            w.println("        fi");
            w.println("    else");
            w.println("        echo \"[$(date '+%H:%M:%S')] Skipped: $repo_name (no run-validation.sh)\"");
            w.println("    fi");
            w.println("}");
            w.println();
            w.println("export -f validate_repo");
            w.println("export -f is_validated");
            w.println("export LOG_DIR");
            w.println("export FORCE_MODE");
            w.println();
            w.println("ALL_REPOS=$(find . -maxdepth 1 -type d -name \"*-*\" | sort)");
            w.println("REPOS_TO_RUN=\"\"");
            w.println("SKIPPED=0");
            w.println();
            w.println("echo \"Checking repository status...\"");
            w.println("echo \"\"");
            w.println("for repo_dir in $ALL_REPOS; do");
            w.println("    repo_name=$(basename \"$repo_dir\")");
            w.println("    if is_validated \"$repo_dir\"; then");
            w.println("        echo \"Skipping $repo_name (already validated)\"");
            w.println("        ((SKIPPED++))");
            w.println("    else");
            w.println("        echo \"Queued: $repo_name\"");
            w.println("        REPOS_TO_RUN=\"$REPOS_TO_RUN${SCRIPT_DIR}/${repo_name} \"");
            w.println("    fi");
            w.println("done");
            w.println();
            w.println("echo \"\"");
            w.println("echo \"Skipped: $SKIPPED  |  To run: $(echo \"$REPOS_TO_RUN\" | wc -w)\"");
            w.println("echo \"\"");
            w.println();
            w.println("if [ -z \"$REPOS_TO_RUN\" ]; then");
            w.println("    echo \"All repositories already validated!\"");
            w.println("    echo \"To re-run: $0 $PARALLEL_JOBS --force\"");
            w.println("    exit 0");
            w.println("fi");
            w.println();
            w.println("echo \"Starting parallel validation...\"");
            w.println("echo \"Logs -> $LOG_DIR/\"");
            w.println("echo \"\"");
            w.println();
            w.println("RUN_TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')");
            w.println("START_TIME=$(date +%s)");
            w.println();
            w.println("echo \"$REPOS_TO_RUN\" | tr ' ' '\\n' | grep -v '^$' | \\");
            w.println("    xargs -n 1 -P \"$PARALLEL_JOBS\" -I {} bash -c 'validate_repo \"{}\"'");
            w.println();
            w.println("END_TIME=$(date +%s)");
            w.println("DURATION=$((END_TIME - START_TIME))");
            w.println("echo \"\"");
            w.println("echo \"Total time: $((DURATION/60))m $((DURATION%60))s\"");
            w.println("echo \"\"");
            w.println();
            w.println("# ==========================================");
            w.println("# AGGREGATE RESULTS + WRITE TIMESTAMPED TESTING_SUMMARY.MD");
            w.println("# ==========================================");
            w.println("TOTAL_REPOS=0");
            w.println("COMPLETED_REPOS=0");
            w.println("FAILED_REPOS=0");
            w.println("TOTAL_TASKS=0");
            w.println("TOTAL_VALID=0");
            w.println("TOTAL_INVALID_PP=0");
            w.println("TOTAL_INVALID_FF=0");
            w.println("SUMMARY_ROWS=\"\"");
            w.println();
            w.println("echo \"=========================================\"");
            w.println("echo \"Results\"");
            w.println("echo \"=========================================\"");
            w.println();
            w.println("for repo_dir in $ALL_REPOS; do");
            w.println("    repo_name=$(basename \"$repo_dir\")");
            w.println("    status_file=\"${SCRIPT_DIR}/${repo_name}/TASKS_STATUS.md\"");
            w.println("    ((TOTAL_REPOS++))");
            w.println("    if [ -f \"$status_file\" ] && grep -q \"VALIDATION_COMPLETE\" \"$status_file\"; then");
            w.println("        total=$(grep \"Total Tasks:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        valid=$(grep \"^- \\*\\*VALID\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        pp=$(grep \"INVALID-PASS-PASS:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        ff=$(grep \"INVALID-FAIL-FAIL:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        total=${total:-0}; valid=${valid:-0}; pp=${pp:-0}; ff=${ff:-0}");
            w.println("        rate=0");
            w.println("        [ \"$total\" -gt 0 ] && rate=$((valid * 100 / total))");
            w.println("        printf \"%-40s %s/%s valid (%s%%)\\n\" \"$repo_name\" \"$valid\" \"$total\" \"$rate\"");
            w.println("        TOTAL_TASKS=$((TOTAL_TASKS + total))");
            w.println("        TOTAL_VALID=$((TOTAL_VALID + valid))");
            w.println("        TOTAL_INVALID_PP=$((TOTAL_INVALID_PP + pp))");
            w.println("        TOTAL_INVALID_FF=$((TOTAL_INVALID_FF + ff))");
            w.println("        SUMMARY_ROWS=\"${SUMMARY_ROWS}| $repo_name | $total | $valid | $pp | $ff | ${rate}% | Complete |\\n\"");
            w.println("        ((COMPLETED_REPOS++))");
            w.println("    else");
            w.println("        printf \"%-40s NOT VALIDATED\\n\" \"$repo_name\"");
            w.println("        SUMMARY_ROWS=\"${SUMMARY_ROWS}| $repo_name | - | - | - | - | - | Not validated |\\n\"");
            w.println("        ((FAILED_REPOS++))");
            w.println("    fi");
            w.println("done");
            w.println();
            w.println("SUCCESS_RATE=0");
            w.println("[ \"$TOTAL_TASKS\" -gt 0 ] && SUCCESS_RATE=$((TOTAL_VALID * 100 / TOTAL_TASKS))");
            w.println();
            w.println("TIMESTAMPED_SUMMARY=\"$SCRIPT_DIR/TESTING_SUMMARY_${RUN_TIMESTAMP}.md\"");
            w.println("cat > \"$TIMESTAMPED_SUMMARY\" << SUMMARYEOF");
            w.println("# Testing Directory Summary");
            w.println();
            w.println("**Run:** ${RUN_TIMESTAMP}");
            w.println("**Runner:** Native (run-all-parallel.sh)");
            w.println();
            w.println("## Overall Results");
            w.println();
            w.println("- **Total Repositories:** $TOTAL_REPOS");
            w.println("- **Completed:** $COMPLETED_REPOS");
            w.println("- **Not Validated:** $FAILED_REPOS");
            w.println("- **Total Tasks:** $TOTAL_TASKS");
            w.println("- **VALID (FAIL->PASS):** $TOTAL_VALID (${SUCCESS_RATE}%)");
            w.println("- **INVALID-PASS-PASS:** $TOTAL_INVALID_PP");
            w.println("- **INVALID-FAIL-FAIL:** $TOTAL_INVALID_FF");
            w.println();
            w.println("---");
            w.println();
            w.println("## Repositories");
            w.println();
            w.println("| Repository | Tasks | Valid | Pass-Pass | Fail-Fail | Rate | Status |");
            w.println("|------------|-------|-------|-----------|-----------|------|--------|");
            w.println("$(echo -e \"$SUMMARY_ROWS\")");
            w.println();
            w.println("---");
            w.println();
            w.println("**Total runtime:** ${DURATION}s ($((DURATION/60))m $((DURATION%60))s)");
            w.println("SUMMARYEOF");
            w.println("cp \"$TIMESTAMPED_SUMMARY\" \"$SCRIPT_DIR/TESTING_SUMMARY.md\"");
            w.println();
            w.println("echo \"\"");
            w.println("echo \"TESTING_SUMMARY_${RUN_TIMESTAMP}.md written\"");
            w.println("echo \"TESTING_SUMMARY.md updated in: $SCRIPT_DIR\"");
            w.println("echo \"\"");
            w.println("echo \"Done! Check logs/ for details.\"");
        }

        script.setExecutable(true);
        logger.info("Generated native orchestration script at {}", script.getPath());
    }

    private void generateDockerOrchestrationScript(Map<String, List<TaskInstance>> tasksByRepo) throws IOException {
        File script = new File(TESTING_DIR, "run-all-docker.sh");

        // Build image mapping from task metadata: derive image per repo dir name
        Map<String, String> imageMap = new LinkedHashMap<>();
        for (Map.Entry<String, List<TaskInstance>> entry : tasksByRepo.entrySet()) {
            String dirName = entry.getKey().replace("/", "-");
            TaskInstance sample = entry.getValue().get(0);
            String java = sample.getJavaVersion() != null ? sample.getJavaVersion() : "17";
            String build = sample.getBuildTool() != null ? sample.getBuildTool().toLowerCase() : "maven";
            // Normalize major version (e.g. "17.0.2" -> "17")
            String major = java.contains(".") ? java.split("\\.")[0] : java;
            String image = "swe-bench:java" + major + "-" + build;
            imageMap.put(dirName, image);
        }

        try (PrintWriter w = new PrintWriter(new FileWriter(script))) {
            w.println("#!/bin/bash");
            w.println("# Docker-based parallel validation for all repos.");
            w.println("# Generated by TestingSetup — do not edit manually.");
            w.println("# Usage:");
            w.println("#   ./run-all-docker.sh          # 2 parallel jobs, skip already-validated");
            w.println("#   ./run-all-docker.sh 4        # 4 parallel jobs");
            w.println("#   ./run-all-docker.sh 4 --force  # re-run everything");
            w.println();
            w.println("SCRIPT_DIR=\"$(cd \"$(dirname \"${BASH_SOURCE[0]}\")\" && pwd)\"");
            w.println("cd \"$SCRIPT_DIR\"");
            w.println();
            w.println("PARALLEL_JOBS=\"${1:-2}\"");
            w.println("FORCE_MODE=false");
            w.println("for arg in \"$@\"; do");
            w.println("    if [ \"$arg\" = \"--force\" ]; then FORCE_MODE=true; fi");
            w.println("done");
            w.println();
            w.println("# ---------------------------------------------------------------------------");
            w.println("# Image mapping: repo directory name -> swe-bench Docker image tag");
            w.println("# ---------------------------------------------------------------------------");
            w.println("get_image() {");
            w.println("    local repo_name=$1");
            w.println("    case \"$repo_name\" in");
            for (Map.Entry<String, String> e : imageMap.entrySet()) {
                w.println("        " + e.getKey() + ") echo \"" + e.getValue() + "\" ;;");
            }
            w.println("        *) echo \"swe-bench:java17-maven\" ;;");
            w.println("    esac");
            w.println("}");
            w.println();
            w.println("echo \"=========================================\"");
            w.println("echo \"Java SWE-Bench Docker Parallel Validation\"");
            w.println("echo \"=========================================\"");
            w.println("echo \"Mode: $([ \"$FORCE_MODE\" = true ] && echo 'FORCE (re-run all)' || echo 'SMART (skip completed)')\"");
            w.println("echo \"Parallel jobs: $PARALLEL_JOBS\"");
            w.println("echo \"\"");
            w.println();
            w.println("mkdir -p logs");
            w.println("LOG_DIR=\"$SCRIPT_DIR/logs\"");
            w.println();
            w.println("is_validated() {");
            w.println("    local repo_dir=$1");
            w.println("    [ \"$FORCE_MODE\" = true ] && return 1");
            w.println("    [ -f \"$repo_dir/TASKS_STATUS.md\" ] && grep -q \"VALIDATION_COMPLETE\" \"$repo_dir/TASKS_STATUS.md\"");
            w.println("}");
            w.println();
            w.println("validate_repo_docker() {");
            w.println("    local repo_dir=$1");
            w.println("    local repo_name");
            w.println("    repo_name=$(basename \"$repo_dir\")");
            w.println("    local log_file=\"$LOG_DIR/${repo_name}.log\"");
            w.println("    local image");
            w.println("    image=$(get_image \"$repo_name\")");
            w.println("    echo \"[$(date '+%H:%M:%S')] Starting: $repo_name ($image)\"");
            w.println("    docker run --rm \\");
            w.println("        --user $(id -u):$(id -g) \\");
            w.println("        -v \"${repo_dir}\":/workspace \\");
            w.println("        -v \"$HOME/.m2\":/root/.m2 \\");
            w.println("        \"$image\" \\");
            w.println("        bash /workspace/run-validation.sh > \"$log_file\" 2>&1");
            w.println("    local exit_code=$?");
            w.println("    if [ $exit_code -eq 0 ]; then");
            w.println("        echo \"[$(date '+%H:%M:%S')] Done: $repo_name\"");
            w.println("    else");
            w.println("        echo \"[$(date '+%H:%M:%S')] Failed: $repo_name (exit: $exit_code)\"");
            w.println("    fi");
            w.println("}");
            w.println();
            w.println("export -f validate_repo_docker");
            w.println("export -f get_image");
            w.println("export LOG_DIR");
            w.println("export FORCE_MODE");
            w.println();
            w.println("ALL_REPOS=$(find . -maxdepth 1 -type d -name \"*-*\" | sort)");
            w.println("REPOS_TO_RUN=\"\"");
            w.println("SKIPPED=0");
            w.println();
            w.println("echo \"Checking repository status...\"");
            w.println("echo \"\"");
            w.println("for repo_dir in $ALL_REPOS; do");
            w.println("    repo_name=$(basename \"$repo_dir\")");
            w.println("    if is_validated \"$repo_dir\"; then");
            w.println("        echo \"Skipping $repo_name (already validated)\"");
            w.println("        ((SKIPPED++))");
            w.println("    else");
            w.println("        echo \"Queued: $repo_name  ->  $(get_image \"$repo_name\")\"");
            w.println("        REPOS_TO_RUN=\"$REPOS_TO_RUN${SCRIPT_DIR}/${repo_name} \"");
            w.println("    fi");
            w.println("done");
            w.println();
            w.println("echo \"\"");
            w.println("echo \"Skipped: $SKIPPED  |  To run: $(echo \"$REPOS_TO_RUN\" | wc -w)\"");
            w.println("echo \"\"");
            w.println();
            w.println("if [ -z \"$REPOS_TO_RUN\" ]; then");
            w.println("    echo \"All repositories already validated!\"");
            w.println("    echo \"To re-run: $0 $PARALLEL_JOBS --force\"");
            w.println("    exit 0");
            w.println("fi");
            w.println();
            w.println("echo \"Starting parallel validation...\"");
            w.println("echo \"Logs -> $LOG_DIR/\"");
            w.println("echo \"\"");
            w.println();
            w.println("RUN_TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')");
            w.println("START_TIME=$(date +%s)");
            w.println();
            w.println("echo \"$REPOS_TO_RUN\" | tr ' ' '\\n' | grep -v '^$' | \\");
            w.println("    xargs -n 1 -P \"$PARALLEL_JOBS\" -I {} bash -c 'validate_repo_docker \"{}\"'");
            w.println();
            w.println("END_TIME=$(date +%s)");
            w.println("DURATION=$((END_TIME - START_TIME))");
            w.println("echo \"\"");
            w.println("echo \"Total time: $((DURATION/60))m $((DURATION%60))s\"");
            w.println("echo \"\"");
            w.println();
            w.println("# ==========================================");
            w.println("# AGGREGATE RESULTS + WRITE TIMESTAMPED TESTING_SUMMARY.MD");
            w.println("# ==========================================");
            w.println("TOTAL_REPOS=0");
            w.println("COMPLETED_REPOS=0");
            w.println("FAILED_REPOS=0");
            w.println("TOTAL_TASKS=0");
            w.println("TOTAL_VALID=0");
            w.println("TOTAL_INVALID_PP=0");
            w.println("TOTAL_INVALID_FF=0");
            w.println("SUMMARY_ROWS=\"\"");
            w.println();
            w.println("echo \"=========================================\"");
            w.println("echo \"Results\"");
            w.println("echo \"=========================================\"");
            w.println();
            w.println("for repo_dir in $ALL_REPOS; do");
            w.println("    repo_name=$(basename \"$repo_dir\")");
            w.println("    status_file=\"${SCRIPT_DIR}/${repo_name}/TASKS_STATUS.md\"");
            w.println("    ((TOTAL_REPOS++))");
            w.println("    if [ -f \"$status_file\" ] && grep -q \"VALIDATION_COMPLETE\" \"$status_file\"; then");
            w.println("        total=$(grep \"Total Tasks:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        valid=$(grep \"^- \\*\\*VALID\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        pp=$(grep \"INVALID-PASS-PASS:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        ff=$(grep \"INVALID-FAIL-FAIL:\" \"$status_file\" | grep -o \"[0-9]*\" | head -1)");
            w.println("        total=${total:-0}; valid=${valid:-0}; pp=${pp:-0}; ff=${ff:-0}");
            w.println("        rate=0");
            w.println("        [ \"$total\" -gt 0 ] && rate=$((valid * 100 / total))");
            w.println("        printf \"%-40s %s/%s valid (%s%%)\\n\" \"$repo_name\" \"$valid\" \"$total\" \"$rate\"");
            w.println("        TOTAL_TASKS=$((TOTAL_TASKS + total))");
            w.println("        TOTAL_VALID=$((TOTAL_VALID + valid))");
            w.println("        TOTAL_INVALID_PP=$((TOTAL_INVALID_PP + pp))");
            w.println("        TOTAL_INVALID_FF=$((TOTAL_INVALID_FF + ff))");
            w.println("        SUMMARY_ROWS=\"${SUMMARY_ROWS}| $repo_name | $total | $valid | $pp | $ff | ${rate}% | Complete |\\n\"");
            w.println("        ((COMPLETED_REPOS++))");
            w.println("    else");
            w.println("        printf \"%-40s NOT VALIDATED\\n\" \"$repo_name\"");
            w.println("        SUMMARY_ROWS=\"${SUMMARY_ROWS}| $repo_name | - | - | - | - | - | Not validated |\\n\"");
            w.println("        ((FAILED_REPOS++))");
            w.println("    fi");
            w.println("done");
            w.println();
            w.println("SUCCESS_RATE=0");
            w.println("[ \"$TOTAL_TASKS\" -gt 0 ] && SUCCESS_RATE=$((TOTAL_VALID * 100 / TOTAL_TASKS))");
            w.println();
            w.println("TIMESTAMPED_SUMMARY=\"$SCRIPT_DIR/TESTING_SUMMARY_${RUN_TIMESTAMP}.md\"");
            w.println("cat > \"$TIMESTAMPED_SUMMARY\" << SUMMARYEOF");
            w.println("# Testing Directory Summary");
            w.println();
            w.println("**Run:** ${RUN_TIMESTAMP}");
            w.println("**Runner:** Docker (run-all-docker.sh)");
            w.println();
            w.println("## Overall Results");
            w.println();
            w.println("- **Total Repositories:** $TOTAL_REPOS");
            w.println("- **Completed:** $COMPLETED_REPOS");
            w.println("- **Not Validated:** $FAILED_REPOS");
            w.println("- **Total Tasks:** $TOTAL_TASKS");
            w.println("- **VALID (FAIL->PASS):** $TOTAL_VALID (${SUCCESS_RATE}%)");
            w.println("- **INVALID-PASS-PASS:** $TOTAL_INVALID_PP");
            w.println("- **INVALID-FAIL-FAIL:** $TOTAL_INVALID_FF");
            w.println();
            w.println("---");
            w.println();
            w.println("## Repositories");
            w.println();
            w.println("| Repository | Tasks | Valid | Pass-Pass | Fail-Fail | Rate | Status |");
            w.println("|------------|-------|-------|-----------|-----------|------|--------|");
            w.println("$(echo -e \"$SUMMARY_ROWS\")");
            w.println();
            w.println("---");
            w.println();
            w.println("**Total Docker runtime:** ${DURATION}s ($((DURATION/60))m $((DURATION%60))s)");
            w.println("SUMMARYEOF");
            w.println("cp \"$TIMESTAMPED_SUMMARY\" \"$SCRIPT_DIR/TESTING_SUMMARY.md\"");
            w.println();
            w.println("echo \"\"");
            w.println("echo \"TESTING_SUMMARY_${RUN_TIMESTAMP}.md written\"");
            w.println("echo \"TESTING_SUMMARY.md updated in: $SCRIPT_DIR\"");
            w.println("echo \"\"");
            w.println("echo \"Done! Check logs/ for details.\"");
        }

        // Make executable
        script.setExecutable(true);
        logger.info("Generated Docker orchestration script at {}", script.getPath());
    }

    public static void main(String[] args) {
        new TestingSetup().execute();
    }
}
