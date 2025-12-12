#!/bin/bash
# Clean all generated data
rm -f data/raw/*.json 2>/dev/null || true
rm -f data/processed/*.json 2>/dev/null || true
rm -f data/tasks/*.json 2>/dev/null || true
rm -rf data/workspaces/* 2>/dev/null || true
echo "✅ Data cleaned"
