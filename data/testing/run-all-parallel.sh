#!/bin/bash
# Run validation for all repositories in parallel
# Generated: 2026-02-15

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================="
echo "Java SWE-Bench Parallel Validation"
echo "========================================="
echo ""

# Count repositories
REPO_COUNT=$(find . -maxdepth 1 -type d ! -name "." ! -name ".." | wc -l)
echo "Found $REPO_COUNT repositories to validate"
echo ""

# Configuration
PARALLEL_JOBS=${1:-4}  # Default to 4 parallel jobs, or use first argument
echo "Running with $PARALLEL_JOBS parallel jobs"
echo ""

# Create log directory
mkdir -p logs
LOG_DIR="$SCRIPT_DIR/logs"

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
export SCRIPT_DIR
export LOG_DIR

# Get list of repository directories
REPOS=$(find . -maxdepth 1 -type d ! -name "." ! -name ".." ! -name "logs" | sort)

# Run validations in parallel
echo "Starting parallel validation..."
echo "Logs will be saved to: $LOG_DIR/"
echo ""

START_TIME=$(date +%s)

# Use xargs for parallel execution
echo "$REPOS" | xargs -n 1 -P "$PARALLEL_JOBS" -I {} bash -c 'validate_repo "{}"'

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

for repo_dir in $REPOS; do
    repo_name=$(basename "$repo_dir")
    status_file="$repo_dir/TASKS_STATUS.md"

    if [ -f "$status_file" ]; then
        valid=$(grep -c "| VALID |" "$status_file" || echo "0")
        invalid_pp=$(grep -c "INVALID-PASS-PASS" "$status_file" || echo "0")
        invalid_ff=$(grep -c "INVALID-FAIL-FAIL" "$status_file" || echo "0")
        total=$((valid + invalid_pp + invalid_ff))

        TOTAL_VALID=$((TOTAL_VALID + valid))
        TOTAL_INVALID_PP=$((TOTAL_INVALID_PP + invalid_pp))
        TOTAL_INVALID_FF=$((TOTAL_INVALID_FF + invalid_ff))
        TOTAL_TASKS=$((TOTAL_TASKS + total))

        if [ $total -gt 0 ]; then
            percentage=$((valid * 100 / total))
            printf "%-35s: %2d/%2d valid (%3d%%)\n" "$repo_name" "$valid" "$total" "$percentage"
        fi
    fi
done

echo ""
echo "========================================="
echo "Overall Summary"
echo "========================================="
echo "Total Tasks:           $TOTAL_TASKS"
echo "Valid (FAIL→PASS):     $TOTAL_VALID"
echo "Invalid (PASS→PASS):   $TOTAL_INVALID_PP"
echo "Invalid (FAIL→FAIL):   $TOTAL_INVALID_FF"

if [ $TOTAL_TASKS -gt 0 ]; then
    SUCCESS_RATE=$((TOTAL_VALID * 100 / TOTAL_TASKS))
    echo "Success Rate:          ${SUCCESS_RATE}%"
fi

echo ""
echo "Logs saved to: $LOG_DIR/"
echo "Status files: data/testing/*/TASKS_STATUS.md"
echo ""
echo "Done! 🎉"
