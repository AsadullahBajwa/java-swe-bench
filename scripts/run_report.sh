#!/bin/bash
# =============================================================================
# run_report.sh — Issue #17: Generate evaluation results report
# =============================================================================
#
# USAGE
#   ./scripts/run_report.sh <model-name>
#
# WHAT IT DOES
#   Reads all per-task result JSON files from data/results/<model-name>/,
#   computes scores, and writes:
#     - data/EVALUATION_RESULTS_<model-name>.md   (human-readable markdown)
#     - data/results/<model-name>/summary.json     (machine-readable summary)
#
# COMPARING MODELS
#   Run once per model then compare the markdown files:
#     ./scripts/run_report.sh gpt-4o
#     ./scripts/run_report.sh claude-sonnet-4-6
#
#   Then open:
#     data/EVALUATION_RESULTS_gpt-4o.md
#     data/EVALUATION_RESULTS_claude-sonnet-4-6.md
#
# PREREQUISITES
#   - data/results/<model-name>/  (run run_evaluation.sh first)
# =============================================================================

set -e

MODEL_NAME="${1:-}"

if [ -z "$MODEL_NAME" ]; then
    echo "ERROR: model name is required."
    echo "Usage: ./scripts/run_report.sh <model-name>"
    echo "Example: ./scripts/run_report.sh gpt-4o"
    exit 1
fi

echo "=== Java SWE-Bench: Results Report (Issue #17) ==="
echo "Model: $MODEL_NAME"
echo ""

if [ ! -d "data/results/$MODEL_NAME" ]; then
    echo "ERROR: data/results/$MODEL_NAME not found."
    echo "Run evaluation first: ./scripts/run_evaluation.sh $MODEL_NAME"
    exit 1
fi

echo "Building project..."
mvn -q package -DskipTests

echo "Generating report..."
mvn -q exec:java \
    -Dexec.mainClass="com.swebench.Main" \
    -Dexec.args="report $MODEL_NAME"

echo ""
echo "=== Report Complete ==="
echo "Markdown report: data/EVALUATION_RESULTS_$MODEL_NAME.md"
echo "JSON summary:    data/results/$MODEL_NAME/summary.json"
