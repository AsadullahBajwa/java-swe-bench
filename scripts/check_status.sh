#!/bin/bash
# Check pipeline status
echo "=== Pipeline Status ==="
echo ""
echo "Stage 1 - Discovery:"
if [ -f data/raw/discovered_repositories.json ]; then
    COUNT=$(cat data/raw/discovered_repositories.json | jq 'length' 2>/dev/null || echo "0")
    echo "  ✅ $COUNT repositories discovered"
else
    echo "  ❌ Not started"
fi
echo ""
echo "Stage 2 - Filtering:"
if [ -f data/processed/candidate_tasks.json ]; then
    COUNT=$(cat data/processed/candidate_tasks.json | jq 'length' 2>/dev/null || echo "0")
    echo "  ✅ $COUNT candidate tasks found"
else
    echo "  ❌ Not started"
fi
echo ""
echo "Stage 3 - Validation:"
if [ -f data/tasks/validated_tasks.json ]; then
    COUNT=$(cat data/tasks/validated_tasks.json | jq 'length' 2>/dev/null || echo "0")
    echo "  ✅ $COUNT tasks validated"
else
    echo "  ❌ Not started"
fi
