#!/bin/bash
# Docker-based parallel validation for all repos.
# Usage:
#   ./run-all-docker.sh          # 2 parallel jobs, skip already-validated
#   ./run-all-docker.sh 4        # 4 parallel jobs
#   ./run-all-docker.sh 4 --force  # re-run everything

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Parse arguments
PARALLEL_JOBS="${1:-2}"
FORCE_MODE=false
for arg in "$@"; do
    if [ "$arg" = "--force" ]; then FORCE_MODE=true; fi
done

# ---------------------------------------------------------------------------
# Image mapping: repo directory name → swe-bench Docker image tag
# ---------------------------------------------------------------------------
get_image() {
    local repo_name=$1
    case "$repo_name" in
        netty-netty)                  echo "swe-bench:java23-maven" ;;
        checkstyle-checkstyle)        echo "swe-bench:java21-maven" ;;
        mockito-mockito|square-okhttp|junit-team-junit5) echo "swe-bench:java17-gradle" ;;
        *)                            echo "swe-bench:java17-maven"  ;;
    esac
}

# ---------------------------------------------------------------------------

echo "========================================="
echo "Java SWE-Bench Docker Parallel Validation"
echo "========================================="
echo "Mode: $([ "$FORCE_MODE" = true ] && echo "FORCE (re-run all)" || echo "SMART (skip completed)")"
echo "Parallel jobs: $PARALLEL_JOBS"
echo ""

mkdir -p logs
LOG_DIR="$SCRIPT_DIR/logs"

is_validated() {
    local repo_dir=$1
    [ "$FORCE_MODE" = true ] && return 1
    [ -f "$repo_dir/TASKS_STATUS.md" ] && grep -q "VALIDATION_COMPLETE" "$repo_dir/TASKS_STATUS.md"
}

validate_repo_docker() {
    local repo_dir=$1
    local repo_name
    repo_name=$(basename "$repo_dir")
    local log_file="$LOG_DIR/${repo_name}.log"
    local image
    image=$(get_image "$repo_name")

    echo "[$(date '+%H:%M:%S')] Starting: $repo_name ($image)"

    docker run --rm \
        -v "${repo_dir}":/workspace \
        "$image" \
        bash /workspace/run-validation.sh > "$log_file" 2>&1
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "[$(date '+%H:%M:%S')] ✓ Done: $repo_name"
    else
        echo "[$(date '+%H:%M:%S')] ✗ Failed: $repo_name (exit: $exit_code)"
    fi
}

export -f validate_repo_docker
export -f get_image
export LOG_DIR
export FORCE_MODE

# Collect repos to run
ALL_REPOS=$(find . -maxdepth 1 -type d -name "*-*" | sort)
REPOS_TO_RUN=""
SKIPPED=0

echo "Checking repository status..."
echo ""
for repo_dir in $ALL_REPOS; do
    repo_name=$(basename "$repo_dir")
    if is_validated "$repo_dir"; then
        echo "⏭  Skipping $repo_name (already validated)"
        ((SKIPPED++))
    else
        echo "📋 Queued: $repo_name  →  $(get_image "$repo_name")"
        REPOS_TO_RUN="$REPOS_TO_RUN${SCRIPT_DIR}/${repo_name} "
    fi
done

echo ""
echo "Skipped: $SKIPPED  |  To run: $(echo "$REPOS_TO_RUN" | wc -w)"
echo ""

if [ -z "$REPOS_TO_RUN" ]; then
    echo "✓ All repositories already validated!"
    echo "To re-run: $0 $PARALLEL_JOBS --force"
    exit 0
fi

echo "Starting parallel validation..."
echo "Logs → $LOG_DIR/"
echo ""

START_TIME=$(date +%s)

echo "$REPOS_TO_RUN" | tr ' ' '\n' | grep -v '^$' | \
    xargs -n 1 -P "$PARALLEL_JOBS" -I {} bash -c 'validate_repo_docker "{}"'

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
echo ""
echo "Total time: $((DURATION/60))m $((DURATION%60))s"
echo ""

# Print per-repo summary
echo "========================================="
echo "Results"
echo "========================================="
for repo_dir in $ALL_REPOS; do
    repo_name=$(basename "$repo_dir")
    status_file="${SCRIPT_DIR}/${repo_name}/TASKS_STATUS.md"
    if [ -f "$status_file" ] && grep -q "VALIDATION_COMPLETE" "$status_file"; then
        total=$(grep "Total Tasks:" "$status_file" | grep -o "[0-9]*" | head -1)
        valid=$(grep "^\- \*\*VALID" "$status_file" | grep -o "[0-9]*" | head -1)
        printf "%-40s %s/%s valid\n" "$repo_name" "${valid:-?}" "${total:-?}"
    fi
done
echo ""
echo "Done! Check logs/ for details."
