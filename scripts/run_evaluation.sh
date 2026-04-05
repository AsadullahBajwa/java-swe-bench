#!/bin/bash
# =============================================================================
# run_evaluation.sh — Issue #16: Run tests on patched repos
# =============================================================================
#
# USAGE
#   ./scripts/run_evaluation.sh <model-name>
#
# WHAT IT DOES
#   For every task where patch_status=APPLIED (from run_patch_application.sh),
#   this script:
#     1. Checks out the repo at base_commit inside Docker
#     2. Applies the test_patch (adds test files)
#     3. Applies the prediction patch
#     4. Runs FAIL_TO_PASS tests  — must now pass
#     5. Runs PASS_TO_PASS tests  — must still pass (no regressions)
#
# OUTPUT
#   data/results/<model-name>/<instance_id>.json
#   status values: resolved | not_resolved | regression | patch_apply_failed | build_failed | no_prediction
#
# PREREQUISITES
#   - data/processed/validated_tasks.json  (run dataset command first)
#   - data/patch_results/<model>/          (run run_patch_application.sh first)
#   - Docker images built (bash docker/build-images.sh)
# =============================================================================

set -e

MODEL_NAME="${1:-}"

if [ -z "$MODEL_NAME" ]; then
    echo "ERROR: model name is required."
    echo "Usage: ./scripts/run_evaluation.sh <model-name>"
    echo "Example: ./scripts/run_evaluation.sh gpt-4o"
    exit 1
fi

echo "=== Java SWE-Bench: Evaluation Harness (Issue #16) ==="
echo "Model: $MODEL_NAME"
echo ""

if [ ! -f "data/processed/validated_tasks.json" ]; then
    echo "ERROR: data/processed/validated_tasks.json not found."
    echo "Run the dataset command first."
    exit 1
fi

if [ ! -d "data/patch_results/$MODEL_NAME" ]; then
    echo "ERROR: data/patch_results/$MODEL_NAME not found."
    echo "Run patch application first: ./scripts/run_patch_application.sh $MODEL_NAME"
    exit 1
fi

echo "Building project..."
mvn -q package -DskipTests

echo "Running evaluation..."
mvn -q exec:java \
    -Dexec.mainClass="com.swebench.Main" \
    -Dexec.args="evaluate $MODEL_NAME"

echo ""
echo "=== Evaluation Complete ==="
echo "Results written to data/results/$MODEL_NAME/"
echo ""
echo "Generate the report:"
echo "  ./scripts/run_report.sh $MODEL_NAME"
