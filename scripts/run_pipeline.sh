#!/bin/bash
# Run complete pipeline: Discovery -> Attribute Filter -> Execution Filter

set -e

echo "=== Java SWE-Bench: Full Pipeline ==="
echo ""

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "WARNING: GITHUB_TOKEN not set. API rate limits will be restrictive."
    echo ""
fi

echo "Starting full pipeline execution..."
echo "This may take several hours to complete."
echo ""

# Run full pipeline
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="pipeline"

echo ""
echo "=== Pipeline Complete ==="
echo "Final results saved to data/tasks/validated_tasks.json"
