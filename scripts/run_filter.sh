#!/bin/bash
# Run Stage 2: Attribute Filtering

set -e

echo "=== Java SWE-Bench: Attribute Filtering ==="
echo ""

# Check for input file
if [ ! -f "data/raw/discovered_repositories.json" ]; then
    echo "ERROR: Repository list not found."
    echo "Run discovery stage first: ./scripts/run_discovery.sh"
    exit 1
fi

# Run attribute filter stage
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="filter"

echo ""
echo "=== Attribute Filtering Complete ==="
echo "Results saved to data/processed/candidate_tasks.json"
