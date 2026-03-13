#!/bin/bash
# Build validated_tasks.json from VALID tasks across all repos in data/testing/

set -e

cd "$(dirname "$0")/.."

echo "=== Java SWE-Bench: Build Validated Dataset ==="
echo ""
echo "Reading data/testing/*/tasks.json + TASKS_STATUS.md ..."
echo ""

mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="dataset"

echo ""
echo "=== Done ==="
echo "Output: data/processed/validated_tasks.json"
