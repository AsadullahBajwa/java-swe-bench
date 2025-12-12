# 🚀 Quick Start Guide

## ⚡ Fast Testing (5-15 Minutes)

Want to verify everything works WITHOUT waiting 20-40 hours? Use the quick test!

### **Run Quick Test**

```bash
cd /Users/tanishjaggi/Desktop/java-swe-bench

# Set your GitHub token (REQUIRED!)
export GITHUB_TOKEN="your_token_here"

# Run quick test (5-15 minutes)
./scripts/quick_test.sh
```

### **What the Quick Test Does:**

✅ **Runs all 10 unit tests** (verifies code quality)
✅ **Tests GitHub API connection** (verifies your token)
✅ **Discovers 3 repositories** (~1-2 minutes)
✅ **Finds 5-10 candidate tasks** (~2-5 minutes)
✅ **Validates 3-5 tasks** (~3-10 minutes)
✅ **Creates all output files** (verifies pipeline)
✅ **Tests all 3 stages** (end-to-end test)

**Total Time: 5-15 minutes** ⏱️

---

## 🎯 Full Production Run (20-40 Hours)

After quick test passes, run the full pipeline:

```bash
# Set GitHub token
export GITHUB_TOKEN="your_token_here"

# Run full pipeline (discovers 20-30 repos, validates 200+ tasks)
./scripts/run_pipeline.sh
```

**Expected Results:**
- 20-30 repositories (90%+ Java)
- 300-500 candidate tasks
- 200+ validated tasks
- Duration: 20-40 hours

---

## 🧹 Clean Up Test Data

After testing, clean up to start fresh:

```bash
# Remove all test data (keeps directory structure)
./scripts/clean_data.sh
```

---

## 📊 Check Results

```bash
# View discovered repositories
cat data/raw/discovered_repositories.json | jq .

# View candidate tasks
cat data/processed/candidate_tasks.json | jq .

# View validated tasks
cat data/tasks/validated_tasks.json | jq .

# Count results
echo "Repos: $(grep -o '"fullName"' data/raw/discovered_repositories.json | wc -l)"
echo "Candidates: $(grep -o '"instanceId"' data/processed/candidate_tasks.json | wc -l)"
echo "Validated: $(grep -o '"instanceId"' data/tasks/validated_tasks.json | wc -l)"
```

---

## 🔧 Troubleshooting

### Error: "GITHUB_TOKEN not set"
```bash
export GITHUB_TOKEN="ghp_your_actual_token_here"
```

### Error: "Java not found"
```bash
# Install Java 17
brew install openjdk@17  # macOS
```

### Error: "Maven not found"
```bash
# Install Maven
brew install maven  # macOS
```

### Tests failing?
```bash
# Run Maven tests directly
mvn clean test

# Check which test failed
mvn test -Dtest=RepositoryTest
```

---

## 📋 Quick Reference

| Script | Duration | Purpose |
|--------|----------|---------|
| `quick_test.sh` | 5-15 min | Fast validation, test mode |
| `run_pipeline.sh` | 20-40 hrs | Full production run |
| `run_discovery.sh` | 30 min | Stage 1 only |
| `run_filter.sh` | 2-3 hrs | Stage 2 only |
| `run_validate.sh` | 15-30 hrs | Stage 3 only |
| `clean_data.sh` | 1 sec | Remove all data |

---

## ✅ Success Indicators

**Quick Test Success:**
```
✅ Build SUCCESS - All 10 tests passed
✅ GitHub API connected
✅ Discovery completed - Found 3 repositories
✅ Filtering completed - Found 5-10 candidate tasks
✅ Validation completed - Validated 3-5 tasks
🎉 ALL TESTS PASSED!
```

**Full Pipeline Success:**
```
✅ 20-30 repositories discovered
✅ 300-500 candidate tasks extracted
✅ 200+ tasks validated
✅ Average quality score: 85+/100
✅ All fail-to-pass tests verified
```

---

## 🎓 Next Steps

1. **Run quick test first**: `./scripts/quick_test.sh`
2. **If it passes**: You're ready for production!
3. **Run full pipeline**: `./scripts/run_pipeline.sh`
4. **Wait 20-40 hours**: Pipeline runs automatically
5. **Check results**: `data/tasks/validated_tasks.json`

---

## 📚 More Documentation

- **START_HERE.md** - Complete documentation index
- **HOW_TO_RUN.md** - Detailed running instructions
- **QUALITY_STANDARDS.md** - What makes a good task
- **ARCHITECTURE.md** - System design details

---

**Ready to test?** 🚀

```bash
export GITHUB_TOKEN="your_token"
./scripts/quick_test.sh
```
