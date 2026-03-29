#!/bin/bash
# =============================================================================
# run_patch_application.sh — Issue #15: Apply AI patches and record outcomes
# =============================================================================
#
# USAGE
#   ./scripts/run_patch_application.sh [model-name]
#
# MODEL NAME
#   The model name is the sub-directory under data/predictions/ that holds the
#   .patch files.  It also becomes the sub-directory under data/patch_results/.
#
#   Examples:
#     ./scripts/run_patch_application.sh gpt-4o
#     ./scripts/run_patch_application.sh claude-3-5-sonnet
#     ./scripts/run_patch_application.sh gemini-1.5-pro
#
#   If omitted the runner picks the first available directory it finds under
#   data/predictions/, or uses the model configured in application.properties
#   when ai.enabled=true.
#
# MANUAL MODE (default, ai.enabled=false)
#   1. Create a directory:  data/predictions/<model-name>/
#   2. Place each patch as: data/predictions/<model-name>/<instance_id>.patch
#      The instance_id must exactly match the one in validated_tasks.json
#      (e.g. "apache-commons-lang-PR-1234").
#   3. Run:  ./scripts/run_patch_application.sh <model-name>
#
# COMPARING MULTIPLE MODELS
#   Paste patches for each model into its own sub-directory and run the script
#   once per model.  Results land in data/patch_results/<model-name>/ so you
#   can diff the directories directly.
#
# AI-GENERATED MODE (ai.enabled=true in config/application.properties)
#   Set ai.enabled=true and provide ai.api.key (or export AI_API_KEY) before
#   running.  The script will call the configured AI provider to generate
#   patches, save them to data/predictions/<model-name>/, and then apply them.
#
# OUTPUT
#   data/patch_results/<model-name>/<instance_id>.json
#   Each file contains: instance_id, repo, model, base_commit, patch_status,
#   error, applied_at.
#
#   patch_status values:
#     APPLIED      — patch applied cleanly
#     APPLY_FAILED — git apply rejected the patch
#     NO_PATCH     — no .patch file found for the task
#
# PREREQUISITES
#   - data/processed/validated_tasks.json must exist (run dataset command first)
#   - Docker images must be built (bash docker/build-images.sh) for Docker mode
# =============================================================================

set -e

MODEL_NAME="${1:-}"

echo "=== Java SWE-Bench: Patch Application (Issue #15) ==="
if [ -n "$MODEL_NAME" ]; then
    echo "Model: $MODEL_NAME"
else
    echo "Model: <auto-detected>"
fi
echo ""

# Ensure validated_tasks.json exists
if [ ! -f "data/processed/validated_tasks.json" ]; then
    echo "ERROR: data/processed/validated_tasks.json not found."
    echo "Run the dataset command first:"
    echo "  mvn exec:java -Dexec.mainClass=\"com.swebench.Main\" -Dexec.args=\"dataset\""
    exit 1
fi

# Build the project
echo "Building project..."
mvn -q package -DskipTests

# Run the patch application runner
if [ -n "$MODEL_NAME" ]; then
    mvn -q exec:java \
        -Dexec.mainClass="com.swebench.Main" \
        -Dexec.args="patch-apply $MODEL_NAME"
else
    mvn -q exec:java \
        -Dexec.mainClass="com.swebench.Main" \
        -Dexec.args="patch-apply"
fi

echo ""
echo "=== Patch Application Complete ==="
if [ -n "$MODEL_NAME" ]; then
    echo "Results written to data/patch_results/$MODEL_NAME/"
else
    echo "Results written to data/patch_results/"
fi
