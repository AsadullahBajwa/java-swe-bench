#!/bin/bash
# stop-validation.sh — Closes #12
#
# Immediately stops all running SWE-Bench validation processes.
# Useful when Ctrl+C leaves orphan mvn/gradle/git processes behind.
#
# Usage:
#   bash stop-validation.sh           # show what will be killed, ask confirmation
#   bash stop-validation.sh --force   # kill immediately, no prompt

FORCE=false
for arg in "$@"; do
    [ "$arg" = "--force" ] && FORCE=true
done

echo "========================================="
echo " SWE-Bench Validation Stopper"
echo "========================================="
echo ""

# Collect PIDs for: orchestrator, per-repo scripts, xargs workers
VALIDATION_PATTERNS=(
    "run-all-parallel.sh"
    "run-validation.sh"
    "xargs.*validate_repo"
)

# Collect PIDs for: build tool processes spawned by the scripts
TOOL_PATTERNS=(
    "mvn.*test"
    "mvn.*surefire"
    "./gradlew.*test"
    "gradlew.*test"
)

ALL_PIDS=""

collect_pids() {
    local pattern=$1
    local pids
    pids=$(pgrep -f "$pattern" 2>/dev/null)
    for pid in $pids; do
        # Never kill this script itself or its parent shell
        [ "$pid" = "$$" ]   && continue
        [ "$pid" = "$PPID" ] && continue
        # Deduplicate
        echo "$ALL_PIDS" | grep -qw "$pid" && continue
        local cmd
        cmd=$(ps -p "$pid" -o args= 2>/dev/null | cut -c1-70)
        printf "  PID %-7s %s\n" "$pid" "$cmd"
        ALL_PIDS="$ALL_PIDS $pid"
    done
}

echo "Scanning for validation processes..."
echo ""
for p in "${VALIDATION_PATTERNS[@]}"; do collect_pids "$p"; done
for p in "${TOOL_PATTERNS[@]}";       do collect_pids "$p"; done

if [ -z "$(echo "$ALL_PIDS" | tr -d ' ')" ]; then
    echo "No validation processes found. Nothing to stop."
    exit 0
fi

COUNT=$(echo "$ALL_PIDS" | wc -w)
echo ""
echo "Found $COUNT process(es)."
echo ""

# Prompt unless --force
if [ "$FORCE" = false ]; then
    read -r -p "Kill all of the above? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""
echo "Sending SIGTERM to processes and their groups..."

for pid in $ALL_PIDS; do
    # Kill the whole process group (catches JVM children, child shells, etc.)
    pgid=$(ps -o pgid= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$pgid" ] && [ "$pgid" != "$$" ] && [ "$pgid" != "0" ]; then
        kill -TERM -- "-$pgid" 2>/dev/null
    fi
    kill -TERM "$pid" 2>/dev/null
done

# Belt-and-suspenders: also kill by name pattern directly
pkill -TERM -f "run-all-parallel.sh"  2>/dev/null
pkill -TERM -f "run-validation.sh"    2>/dev/null
pkill -TERM -f "mvn.*test"            2>/dev/null
pkill -TERM -f "gradlew.*test"        2>/dev/null

echo "Waiting 2 seconds for graceful shutdown..."
sleep 2

# SIGKILL anything still alive
SURVIVORS=""
for pid in $ALL_PIDS; do
    kill -0 "$pid" 2>/dev/null && SURVIVORS="$SURVIVORS $pid"
done

if [ -n "$(echo "$SURVIVORS" | tr -d ' ')" ]; then
    echo "Some processes still alive — sending SIGKILL..."
    for pid in $SURVIVORS; do
        pgid=$(ps -o pgid= -p "$pid" 2>/dev/null | tr -d ' ')
        if [ -n "$pgid" ] && [ "$pgid" != "$$" ] && [ "$pgid" != "0" ]; then
            kill -KILL -- "-$pgid" 2>/dev/null
        fi
        kill -KILL "$pid" 2>/dev/null
    done
    pkill -KILL -f "run-validation.sh" 2>/dev/null
    pkill -KILL -f "mvn.*test"         2>/dev/null
    pkill -KILL -f "gradlew.*test"     2>/dev/null
fi

echo ""
echo "Done. All validation processes stopped."
echo ""
echo "To restart:"
echo "  cd $(dirname "$0")"
echo "  bash run-all-parallel.sh 4"
