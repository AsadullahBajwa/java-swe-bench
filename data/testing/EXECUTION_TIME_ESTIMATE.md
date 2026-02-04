# Pipeline Execution Time Estimates

**Generated: 2026-02-01**
**Based on: apache-commons-lang validation run**

---

## Observed Timing (apache-commons-lang)

| Phase | Duration |
|-------|----------|
| Repository clone | ~1-2 min |
| Per task validation | ~1-1.5 min |
| **Total for 20 tasks** | **~25-30 min** |

### Per-Task Breakdown:
- `git checkout` + `git clean`: ~5 sec
- Apply test patch: ~1 sec
- Run tests (Maven): ~30-60 sec
- Apply code patch: ~1 sec
- Run tests (Maven): ~30-60 sec
- **Average per task: ~1.2 min**

---

## Estimated Time for All Repositories

| Repository | Tasks | Clone Time | Validation Time | Total Estimate |
|------------|-------|------------|-----------------|----------------|
| apache-commons-lang | 20 | 2 min | 24 min | **26 min** |
| apache-commons-io | 20 | 2 min | 24 min | **26 min** |
| apache-commons-collections | 20 | 2 min | 24 min | **26 min** |
| apache-commons-text | 8 | 2 min | 10 min | **12 min** |
| google-guava | 20 | 3 min | 30 min | **33 min** |
| google-gson | 20 | 2 min | 24 min | **26 min** |
| FasterXML-jackson-core | 20 | 2 min | 24 min | **26 min** |
| FasterXML-jackson-databind | 19 | 2 min | 23 min | **25 min** |
| mockito-mockito | 14 | 2 min | 17 min | **19 min** |
| netty-netty | 19 | 3 min | 28 min | **31 min** |
| square-okhttp | 20 | 2 min | 24 min | **26 min** |

---

## Summary

| Metric | Value |
|--------|-------|
| **Total Repositories** | 11 |
| **Total Tasks** | 200 |
| **Average per Task** | ~1.2 min |
| **Average per Repo** | ~25 min |

---

## Execution Scenarios

### Sequential Execution (1 repo at a time)
```
Total Time = 11 repos × ~25 min = ~275 min (~4.5 hours)
```

### Parallel Execution (4 repos at a time)
```
Total Time = ceil(11/4) × ~30 min = 3 batches × ~30 min = ~90 min (~1.5 hours)
```

### Parallel Execution (8 repos at a time)
```
Total Time = ceil(11/8) × ~30 min = 2 batches × ~30 min = ~60 min (~1 hour)
```

---

## Factors Affecting Execution Time

1. **Test Suite Size**: Larger test suites take longer (e.g., guava, netty)
2. **Build System**: Maven vs Gradle (similar performance)
3. **Network Speed**: Initial clone time depends on repo size and network
4. **Disk I/O**: SSD recommended for faster git operations
5. **CPU Cores**: More cores = better parallel execution
6. **Memory**: Some projects require more memory for tests

---

## Recommendations

1. **For Quick Testing**: Run 1-2 repos first to verify setup
2. **For Full Validation**: Use parallel execution with 4 workers
3. **For CI/CD**: Consider running repos in parallel across multiple machines
4. **Disk Space**: Ensure ~5GB free for all repo clones

---

## Commands

### Sequential (one repo at a time):
```powershell
cd data/testing
Get-ChildItem -Directory | ForEach-Object {
    Write-Host "Processing $($_.Name)..."
    Set-Location $_.FullName
    .\run-validation.ps1
    Set-Location ..
}
```

### Parallel (4 repos at a time):
```powershell
cd data/testing
Get-ChildItem -Directory | ForEach-Object -Parallel {
    Set-Location $_.FullName
    .\run-validation.ps1
} -ThrottleLimit 4
```

---

## Actual Results (Completed)

| Repository | Tasks | Valid | Invalid | Success Rate | Actual Time |
|------------|-------|-------|---------|--------------|-------------|
| apache-commons-lang | 20 | 16 | 4 | 80% | ~28 min |
| apache-commons-io | 20 | - | - | - | pending |
| apache-commons-collections | 20 | - | - | - | pending |
| apache-commons-text | 8 | - | - | - | pending |
| google-guava | 20 | - | - | - | pending |
| google-gson | 20 | - | - | - | pending |
| FasterXML-jackson-core | 20 | - | - | - | pending |
| FasterXML-jackson-databind | 19 | - | - | - | pending |
| mockito-mockito | 14 | - | - | - | pending |
| netty-netty | 19 | - | - | - | pending |
| square-okhttp | 20 | - | - | - | pending |
