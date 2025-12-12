#!/bin/bash
# Run Stage 3: Execution Filtering

set -e

echo "=== Java SWE-Bench: Execution Filtering ==="
echo ""

# Check for input file
if [ ! -f "data/processed/candidate_tasks.json" ]; then
    echo "ERROR: Candidate tasks not found."
    echo "Run attribute filter stage first: ./scripts/run_filter.sh"
    exit 1
fi

# Run execution filter stage
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="validate"

echo ""
echo "=== Execution Filtering Complete ==="
echo "Results saved to data/tasks/validated_tasks.json"
