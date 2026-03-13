#!/bin/bash
# Enhanced parallel validation with smart skip and force options
# Usage:
#   ./run-all-parallel.sh 4          # Skip already-validated repos
#   ./run-all-parallel.sh 4 --force  # Re-run everything

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Parse arguments
PARALLEL_JOBS="${1:-4}"
FORCE_MODE=false

for arg in "$@"; do
    if [ "$arg" = "--force" ]; then
        FORCE_MODE=true
    fi
done

echo "========================================="
echo "Java SWE-Bench Parallel Validation"
echo "========================================="
echo "Mode: $([ "$FORCE_MODE" = true ] && echo "FORCE (re-run all)" || echo "SMART (skip completed)")"
echo "Parallel jobs: $PARALLEL_JOBS"
echo ""

# Create log directory
mkdir -p logs
LOG_DIR="$SCRIPT_DIR/logs"

# Function to check if repo is already validated
is_validated() {
    local repo_dir=$1
    local status_file="$repo_dir/TASKS_STATUS.md"

    # If force mode, always return false
    if [ "$FORCE_MODE" = true ]; then
        return 1
    fi

    # Check for completion marker
    if [ -f "$status_file" ]; then
        if grep -q "VALIDATION_COMPLETE" "$status_file"; then
            return 0  # Already validated
        fi
    fi
    return 1
}

# Function to run validation for a single repo
validate_repo() {
    local repo_dir=$1
    local repo_name=$(basename "$repo_dir")
    local log_file="$LOG_DIR/${repo_name}.log"

    echo "[$(date '+%H:%M:%S')] Starting: $repo_name"

    cd "$repo_dir"
    if [ -f "run-validation.sh" ]; then
        bash run-validation.sh > "$log_file" 2>&1
        local exit_code=$?

        if [ $exit_code -eq 0 ]; then
            echo "[$(date '+%H:%M:%S')] ✓ Completed: $repo_name"
        else
            echo "[$(date '+%H:%M:%S')] ✗ Failed: $repo_name (exit code: $exit_code)"
        fi
    else
        echo "[$(date '+%H:%M:%S')] ✗ Skipped: $repo_name (no validation script)"
    fi
    cd "$SCRIPT_DIR"
}

export -f validate_repo
export -f is_validated
export SCRIPT_DIR
export LOG_DIR
export FORCE_MODE

# Get all repositories
ALL_REPOS=$(find . -maxdepth 1 -type d ! -name "." ! -name ".." ! -name "logs" | sort)

# Separate into validated and to-run
REPOS_TO_RUN=""
REPOS_SKIPPED=0
TOTAL_REPOS=0

echo "Checking repository status..."
echo ""

for repo_dir in $ALL_REPOS; do
    repo_name=$(basename "$repo_dir")
    ((TOTAL_REPOS++))

    if is_validated "$repo_dir"; then
        echo "⏭  Skipping $repo_name (already validated)"
        ((REPOS_SKIPPED++))
    else
        echo "📋 Queued: $repo_name"
        REPOS_TO_RUN="$REPOS_TO_RUN$repo_dir "
    fi
done

echo ""
echo "Summary: $REPOS_SKIPPED already validated, $((TOTAL_REPOS - REPOS_SKIPPED)) to run"
echo ""

if [ -z "$REPOS_TO_RUN" ]; then
    echo "✓ All repositories already validated!"
    echo ""
    echo "To re-run everything: $0 $PARALLEL_JOBS --force"
    exit 0
fi

# Run validations in parallel
echo "Starting parallel validation..."
echo "Logs will be saved to: $LOG_DIR/"
echo ""

START_TIME=$(date +%s)

echo "$REPOS_TO_RUN" | tr ' ' '\n' | xargs -n 1 -P "$PARALLEL_JOBS" -I {} bash -c 'validate_repo "{}"'

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo "========================================="
echo "Validation Complete!"
echo "========================================="
echo "Total time: ${MINUTES}m ${SECONDS}s"
echo ""

# Generate summary
echo "Generating summary..."
echo ""

TOTAL_VALID=0
TOTAL_INVALID_PP=0
TOTAL_INVALID_FF=0
TOTAL_TASKS=0
COMPLETED_REPOS=0
FAILED_REPOS=0
SUMMARY_ROWS=""

for repo_dir in $ALL_REPOS; do
    repo_name=$(basename "$repo_dir")
    status_file="$repo_dir/TASKS_STATUS.md"

    if [ -f "$status_file" ] && grep -q "VALIDATION_COMPLETE" "$status_file"; then
        total=$(grep "Total Tasks:" "$status_file" | grep -o "[0-9]*" | head -1 || echo "0")
        valid=$(grep "VALID:" "$status_file" | head -1 | grep -o "[0-9]*" | head -1 || echo "0")
        invalid_pp=$(grep "INVALID-PASS-PASS:" "$status_file" | grep -o "[0-9]*" | head -1 || echo "0")
        invalid_ff=$(grep "INVALID-FAIL-FAIL:" "$status_file" | grep -o "[0-9]*" | head -1 || echo "0")

        TOTAL_VALID=$((TOTAL_VALID + valid))
        TOTAL_INVALID_PP=$((TOTAL_INVALID_PP + invalid_pp))
        TOTAL_INVALID_FF=$((TOTAL_INVALID_FF + invalid_ff))
        TOTAL_TASKS=$((TOTAL_TASKS + total))
        ((COMPLETED_REPOS++))

        if [ $total -gt 0 ]; then
            percentage=$((valid * 100 / total))
            printf "%-35s: %2d/%2d valid (%3d%%)\n" "$repo_name" "$valid" "$total" "$percentage"
            SUMMARY_ROWS="${SUMMARY_ROWS}| ${repo_name} | ${total} | ${valid} | ${invalid_pp} | ${invalid_ff} | ${percentage}% | COMPLETE |\n"
        fi
    else
        ((FAILED_REPOS++))
        # Get task count from tasks.json if available
        task_count="-"
        if [ -f "$repo_dir/tasks.json" ]; then
            task_count=$(grep -c '"pr_number"' "$repo_dir/tasks.json" 2>/dev/null || echo "-")
        fi
        SUMMARY_ROWS="${SUMMARY_ROWS}| ${repo_name} | ${task_count} | - | - | - | - | PENDING |\n"
    fi
done

echo ""
echo "========================================="
echo "Overall Summary"
echo "========================================="
echo "Total Tasks:           $TOTAL_TASKS"
echo "Valid (FAIL->PASS):    $TOTAL_VALID"
echo "Invalid (PASS-PASS):   $TOTAL_INVALID_PP"
echo "Invalid (FAIL-FAIL):   $TOTAL_INVALID_FF"

if [ $TOTAL_TASKS -gt 0 ]; then
    SUCCESS_RATE=$((TOTAL_VALID * 100 / TOTAL_TASKS))
    echo "Success Rate:          ${SUCCESS_RATE}%"
fi

echo ""
echo "Repos completed:       $COMPLETED_REPOS"
echo "Repos not validated:   $FAILED_REPOS"

# ==========================================
# UPDATE TESTING_SUMMARY.MD
# ==========================================
if [ $TOTAL_TASKS -gt 0 ]; then
    SUCCESS_RATE=$((TOTAL_VALID * 100 / TOTAL_TASKS))
else
    SUCCESS_RATE=0
fi

cat > "$SCRIPT_DIR/TESTING_SUMMARY.md" << SUMMARYEOF
# Testing Directory Summary

**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')

## Overall Results

- **Total Repositories:** $TOTAL_REPOS
- **Completed:** $COMPLETED_REPOS
- **Not Validated:** $FAILED_REPOS
- **Total Tasks:** $TOTAL_TASKS
- **VALID (FAIL->PASS):** $TOTAL_VALID (${SUCCESS_RATE}%)
- **INVALID-PASS-PASS:** $TOTAL_INVALID_PP
- **INVALID-FAIL-FAIL:** $TOTAL_INVALID_FF

---

## Repositories

| Repository | Tasks | Valid | Pass-Pass | Fail-Fail | Rate | Status |
|------------|-------|-------|-----------|-----------|------|--------|
$(echo -e "$SUMMARY_ROWS")

---

## Legend

- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)

---

## How to Run

\`\`\`bash
# Run all validations (skip already completed)
./run-all-parallel.sh 2

# Force re-run everything
./run-all-parallel.sh 2 --force

# Check individual repo status
cat <repo-name>/TASKS_STATUS.md
\`\`\`

---

**Total time:** ${MINUTES}m ${SECONDS}s
SUMMARYEOF

echo ""
echo "TESTING_SUMMARY.md updated in: $SCRIPT_DIR"
echo ""
echo "Logs saved to: $LOG_DIR/"
echo "Status files: */TASKS_STATUS.md"
echo ""
echo "Done!"
