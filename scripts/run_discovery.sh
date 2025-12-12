#!/bin/bash
# Run Stage 1: Repository Discovery

set -e

echo "=== Java SWE-Bench: Repository Discovery ==="
echo ""

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "WARNING: GITHUB_TOKEN not set. API rate limits will be restrictive."
    echo "Set GITHUB_TOKEN environment variable for better performance."
    echo ""
fi

# Run discovery stage
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="discover"

echo ""
echo "=== Discovery Complete ==="
echo "Results saved to data/raw/discovered_repositories.json"
