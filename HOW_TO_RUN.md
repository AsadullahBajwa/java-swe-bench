# How to Run Java SWE-Bench - Complete Guide for Beginners

## 🎯 What Is This Project?

This project collects **real software bugs** from popular Java projects on GitHub and creates a **benchmark dataset** to test how well AI models can fix bugs.

Think of it like this:
- **Step 1**: Find good Java projects (like RxJava, Apache Commons)
- **Step 2**: Find real bugs that were reported and fixed
- **Step 3**: Test that the bug really existed and the fix really worked
- **Step 4**: Save all this data so AI models can be tested on it

---

## 📋 Before You Start - Prerequisites

### 1. **Check if Java is Installed**

Open your terminal and type:
```bash
java -version
```

You should see something like:
```
java version "17.0.8"
```

**If you don't have Java 17:**
- Download from: https://adoptium.net/
- Install it and restart your terminal

### 2. **Check if Maven is Installed**

Type:
```bash
mvn -version
```

You should see:
```
Apache Maven 3.9.x
```

**If you don't have Maven:**
- Mac: `brew install maven`
- Linux: `sudo apt-get install maven`
- Windows: Download from https://maven.apache.org/download.cgi

### 3. **Get a GitHub Token** (IMPORTANT!)

Without this, you can only make 60 requests per hour to GitHub. With a token, you get 5,000!

**How to get one:**
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name like "Java SWE-Bench"
4. Check the box: `repo` (Full control of private repositories)
5. Click "Generate token"
6. **COPY THE TOKEN** (you won't see it again!)

**Set it in your terminal:**
```bash
export GITHUB_TOKEN="paste_your_token_here"
```

To make it permanent, add this line to your `~/.bashrc` or `~/.zshrc` file.

---

## 🗂️ Understanding the Project Structure

### **Main Folders**

```
java-swe-bench/
│
├── src/                          ← All the Java code
│   ├── main/java/                ← The actual program
│   └── test/java/                ← Tests to verify it works
│
├── scripts/                      ← Easy-to-run commands
│   ├── run_discovery.sh          ← Step 1: Find repositories
│   ├── run_filter.sh             ← Step 2: Find good tasks
│   ├── run_validate.sh           ← Step 3: Verify tasks work
│   └── run_pipeline.sh           ← Runs all 3 steps
│
├── data/                         ← Where results are saved
│   ├── raw/                      ← Step 1 results
│   ├── processed/                ← Step 2 results
│   └── tasks/                    ← Step 3 final results
│
├── config/                       ← Settings/configuration
│   └── application.properties    ← Change settings here
│
├── pom.xml                       ← Maven configuration (dependencies)
│
└── *.md files                    ← Documentation (what you're reading!)
```

---

## 📚 What Does Each File/Folder Do?

### **Java Code Files** (`src/main/java/com/swebench/`)

#### **Main.java**
- **What it does**: The starting point of the program
- **In simple terms**: Like the "Run" button - decides which part of the program to execute
- **Example**: When you run `mvn exec:java -Dexec.args="discover"`, this file starts the discovery process

#### **model/Repository.java**
- **What it does**: Stores information about a GitHub repository
- **In simple terms**: Like a form with blanks for: name, stars, Java percentage, etc.
- **Example**: `Repository("apache/commons-lang", stars=2800, javaPercentage=98.7)`

#### **model/TaskInstance.java**
- **What it does**: Stores information about a single bug/task
- **In simple terms**: Contains: the bug description, the code fix, the tests, etc.
- **Example**: One task = "Bug in RxJava that crashes when you pass null"

#### **pipeline/RepositoryDiscovery.java**
- **What it does**: STEP 1 - Searches GitHub for good Java repositories
- **In simple terms**: Goes to GitHub and finds popular Java projects
- **Output**: `data/raw/discovered_repositories.json` (list of 20-30 repos)

#### **pipeline/AttributeFilter.java**
- **What it does**: STEP 2 - Looks through repositories for good bugs/fixes
- **In simple terms**: Reads issues and pull requests, finds real bugs with fixes
- **Output**: `data/processed/candidate_tasks.json` (list of 400+ potential tasks)

#### **pipeline/ExecutionFilter.java**
- **What it does**: STEP 3 - Tests that each bug/fix actually works
- **In simple terms**: Downloads the code, runs tests to verify the bug and fix are real
- **Output**: `data/tasks/validated_tasks.json` (final 200+ verified tasks)

#### **service/GitHubService.java**
- **What it does**: Talks to GitHub's API to get repository data
- **In simple terms**: Like a translator between our program and GitHub
- **Example**: "Get me all merged pull requests from RxJava"

#### **service/QualityValidator.java**
- **What it does**: Checks if a task is high quality
- **In simple terms**: Rejects trivial bugs (like typos), only keeps real bugs
- **Example**: Rejects "fix typo in README", accepts "NullPointerException crash"

#### **service/PatchExtractor.java**
- **What it does**: Extracts the actual code changes (the "diff")
- **In simple terms**: Gets the "before" and "after" code for a bug fix
- **Example**: Shows what lines were added/removed to fix the bug

#### **service/PatchApplier.java**
- **What it does**: Applies a code fix to a repository
- **In simple terms**: Takes the "after" code and puts it in the project
- **Example**: Like hitting "paste" after copying a fix

#### **service/TestRunner.java**
- **What it does**: Runs tests to verify bugs and fixes
- **In simple terms**: Runs `mvn test` or `gradle test` automatically
- **Example**: "Do the tests fail before the fix?" "Do they pass after?"

#### **util/ConfigLoader.java**
- **What it does**: Reads settings from `application.properties`
- **In simple terms**: Loads configuration like "minimum 90% Java"

#### **util/FileUtils.java**
- **What it does**: Helper functions for working with files
- **In simple terms**: Reading files, writing files, deleting folders, etc.

---

### **Script Files** (`scripts/`)

#### **run_discovery.sh**
- **What it does**: Runs Step 1 (Repository Discovery)
- **Time**: ~30 minutes
- **Output**: 20-30 repositories saved to `data/raw/discovered_repositories.json`

#### **run_filter.sh**
- **What it does**: Runs Step 2 (Attribute Filtering)
- **Time**: 2-3 hours
- **Output**: 400+ tasks saved to `data/processed/candidate_tasks.json`

#### **run_validate.sh**
- **What it does**: Runs Step 3 (Execution Validation)
- **Time**: 15-30 hours
- **Output**: 200+ validated tasks saved to `data/tasks/validated_tasks.json`

#### **run_pipeline.sh**
- **What it does**: Runs all 3 steps automatically
- **Time**: 20-40 hours total
- **Output**: Final dataset in `data/tasks/`

---

### **Configuration Files**

#### **pom.xml**
- **What it does**: Tells Maven what libraries (dependencies) to download
- **In simple terms**: Like a shopping list of tools the program needs
- **Example**: GitHub API library, JUnit for testing, etc.

#### **config/application.properties**
- **What it does**: All the settings for the project
- **In simple terms**: Like preferences - you can change thresholds, timeouts, etc.
- **Key settings**:
  - `discovery.min.java.percentage=90.0` - Only 90%+ Java repos
  - `filter.min.quality.score=75` - Minimum quality score for tasks
  - `execution.timeout.minutes=10` - How long to wait for tests

---

### **Documentation Files** (*.md)

#### **README.md**
- Quick overview of the project

#### **SETUP.md**
- Detailed installation instructions

#### **HOW_TO_RUN.md** (This file!)
- Step-by-step guide for beginners

#### **ARCHITECTURE.md**
- Technical details about how the system is designed

#### **QUALITY_STANDARDS.md**
- Explains what makes a "good" task

#### **PHASE_1_2_PLAN.md**
- The project timeline and plan

#### **JAVA_PERCENTAGE_FEATURE.md**
- Explains the 90% Java requirement

#### **QUALITY_IMPROVEMENTS_SUMMARY.md**
- Summary of all quality features

#### **UPDATED_90_PERCENT_THRESHOLD.md**
- Details about the 90% Java change

---

## 🚀 How to Run - Step by Step

### **Step 0: Setup (One-time)**

1. **Navigate to the project:**
```bash
cd /Users/tanishjaggi/Desktop/java-swe-bench
```

2. **Set your GitHub token:**
```bash
export GITHUB_TOKEN="your_token_here"
```

3. **Verify everything works:**
```bash
mvn clean test
```

You should see:
```
[INFO] BUILD SUCCESS
[INFO] Tests run: 10, Failures: 0
```

---

### **Step 1: Repository Discovery (Find Good Projects)**

**What this does:**
- Searches GitHub for Java repositories
- Filters for: 90%+ Java, 50+ stars, active, has tests
- Saves list of 20-30 qualifying repositories

**How to run:**
```bash
./scripts/run_discovery.sh
```

**OR manually:**
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="discover"
```

**Expected output:**
```
[INFO] Starting repository discovery stage
[INFO] Target: 30 repositories
[INFO] Searching GitHub for Java repositories...
[INFO] Found 1000 candidate repositories
[INFO] Applying repository filters...
[INFO] Repository qualified: ReactiveX/RxJava
[INFO] Repository qualified: apache/commons-lang
...
[INFO] === Repository Discovery Report ===
[INFO] Total qualified repositories: 25
[INFO] Maven projects: 15
[INFO] Gradle projects: 10
[INFO] Average stars: 3,456
[INFO] Average Java percentage: 94.8%
[INFO] Saved 25 repositories to data/raw/discovered_repositories.json
```

**Check the results:**
```bash
cat data/raw/discovered_repositories.json | jq '.[].full_name'
```

You should see repository names like:
```
"ReactiveX/RxJava"
"apache/commons-lang"
"google/guava"
```

**Time:** ~30 minutes

---

### **Step 2: Attribute Filtering (Find Good Bugs)**

**What this does:**
- Looks through each repository for issues and pull requests
- Finds bugs that were reported and fixed
- Checks quality: real bugs, good descriptions, includes tests
- Saves 400+ candidate tasks

**How to run:**
```bash
./scripts/run_filter.sh
```

**OR manually:**
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="filter"
```

**Expected output:**
```
[INFO] Starting attribute filtering stage
[INFO] Target: 200 task instances
[INFO] Loaded 25 repositories from data/raw/discovered_repositories.json
[INFO] Extracting task instances from repositories...
[INFO] Processing repository: ReactiveX/RxJava
[INFO] Extracted 45 task candidates from ReactiveX/RxJava
[INFO] Task RxJava-1234 quality: GOOD (score: 87)
[INFO] Task RxJava-5678 quality: EXCELLENT (score: 92)
[INFO] Task RxJava-9999 rejected by quality validator
...
[INFO] === Attribute Filtering Report ===
[INFO] Total qualified tasks: 412
[INFO] Maven tasks: 245
[INFO] Gradle tasks: 167
[INFO] Tasks from 24 unique repositories
[INFO] Saved 412 task instances to data/processed/candidate_tasks.json
```

**Check the results:**
```bash
cat data/processed/candidate_tasks.json | jq 'length'
```

Should show: `412` (or similar number of tasks)

**Time:** 2-3 hours

---

### **Step 3: Execution Validation (Verify Bugs Are Real)**

**What this does:**
- Downloads each repository
- Checks: Do tests FAIL before the fix?
- Applies the fix
- Checks: Do tests PASS after the fix?
- Checks: Did any other tests break?
- Saves 200+ validated tasks

**How to run:**
```bash
./scripts/run_validate.sh
```

**OR manually:**
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="validate"
```

**Expected output:**
```
[INFO] Starting execution filtering stage
[INFO] Loaded 412 candidate tasks from data/processed/candidate_tasks.json
[INFO] Validating 412 task instances through execution...
[INFO] Validating task 1/412: RxJava-1234
[INFO] Running FAIL_TO_PASS tests at base commit for RxJava-1234
[INFO] ✓ Tests correctly fail at base commit
[INFO] Applying patch for RxJava-1234
[INFO] ✓ Patch applied successfully
[INFO] Running FAIL_TO_PASS tests after patch for RxJava-1234
[INFO] ✓ Tests pass after patch (FAIL → PASS verified)
[INFO] Running PASS_TO_PASS tests for RxJava-1234
[INFO] ✓ No regression (PASS → PASS maintained)
[INFO] Re-running FAIL_TO_PASS tests to verify stability for RxJava-1234
[INFO] ✓ Tests are stable
[INFO] ✅ Task RxJava-1234 VALIDATED: All checks passed
...
[INFO] Validating task 2/412: RxJava-5678
[INFO] ❌ Task RxJava-5678 REJECTED: Tests did NOT fail at base commit (false positive)
...
[INFO] === Execution Filtering Report ===
[INFO] Total validated tasks: 218
[INFO] ReactiveX/RxJava: 28 tasks
[INFO] apache/commons-lang: 31 tasks
[INFO] google/guava: 24 tasks
...
[INFO] Saved 218 validated tasks to data/tasks/validated_tasks.json
```

**Check the results:**
```bash
cat data/tasks/validated_tasks.json | jq 'length'
```

Should show: `218` (or similar - target is 200+)

**Time:** 15-30 hours (this is the slow part!)

---

### **Alternative: Run Everything at Once**

If you want to run all 3 steps automatically:

```bash
./scripts/run_pipeline.sh
```

This will:
1. Run discovery
2. Run attribute filtering
3. Run execution validation
4. Save final results

**Total time:** 20-40 hours

**Tip:** Run this overnight or over a weekend!

---

## 📊 Understanding the Output

### **After Discovery** (`data/raw/discovered_repositories.json`)

This is a list of repositories. Each one looks like:
```json
{
  "full_name": "ReactiveX/RxJava",
  "stars": 47500,
  "language": "Java",
  "java_percentage": 95.2,
  "build_tool": "gradle",
  "has_tests": true
}
```

**What this means:**
- Found RxJava repository
- It has 47,500 stars (very popular!)
- 95.2% of the code is Java
- Uses Gradle for building
- Has tests

---

### **After Filtering** (`data/processed/candidate_tasks.json`)

This is a list of potential tasks. Each one looks like:
```json
{
  "instance_id": "ReactiveX-RxJava-1234",
  "repo": "ReactiveX/RxJava",
  "issue_number": 1234,
  "pull_number": 5678,
  "problem_statement": "Observable.concat throws NullPointerException when...",
  "patch": "diff --git a/src/main/java/...",
  "test_command": "gradle test --tests ObservableTest",
  "build_tool": "gradle",
  "java_version": "8"
}
```

**What this means:**
- Found a bug report (issue #1234) that was fixed (pull request #5678)
- Has a description of the problem
- Has the code fix (patch)
- Knows how to run the tests

---

### **After Validation** (`data/tasks/validated_tasks.json`)

This is the final dataset! Same format as above, but each task has been verified:
- ✅ Tests failed before the fix
- ✅ Tests pass after the fix
- ✅ No other tests broke
- ✅ Tests are stable (not random/flaky)

---

## 🔍 Monitoring Progress

### **Check What's Happening:**
```bash
# See what the program is doing
tail -f logs/*.log

# Count how many repos found
cat data/raw/discovered_repositories.json | jq 'length'

# Count how many tasks found
cat data/processed/candidate_tasks.json | jq 'length'

# Count validated tasks
cat data/tasks/validated_tasks.json | jq 'length'
```

### **See Quality Scores:**
```bash
# During filtering
grep "quality:" logs/*.log

# See which tasks passed/failed
grep "✅\|❌" logs/*.log
```

---

## ⚙️ Changing Settings

Edit `config/application.properties`:

### **Want more/fewer repositories?**
```properties
discovery.target.count=30    # Change to 40 for more, 20 for fewer
```

### **Want to allow less Java code?**
```properties
discovery.min.java.percentage=90.0    # Change to 85.0 or 80.0
```

### **Want more/fewer tasks?**
```properties
filter.target.task.count=200    # Change to 300 for more
```

### **Tests taking too long?**
```properties
execution.timeout.minutes=10    # Change to 15 for longer timeout
```

---

## ❓ Troubleshooting

### **Problem: "BUILD FAILURE"**

**Solution:**
```bash
mvn clean install
```

### **Problem: "API rate limit exceeded"**

**Solution:** You forgot to set your GitHub token!
```bash
export GITHUB_TOKEN="your_token_here"
```

### **Problem: "No repositories found"**

**Solution:** The 90% threshold might be too strict. Lower it:
```properties
# In config/application.properties
discovery.min.java.percentage=85.0
```

### **Problem: Tests are timing out**

**Solution:** Increase the timeout:
```properties
# In config/application.properties
execution.timeout.minutes=15
```

### **Problem: Out of disk space**

**Solution:** The workspace folders can get big. Clean them:
```bash
rm -rf data/workspaces/*
```

---

## 📈 What to Expect

### **Normal Results:**

- **Discovery**: 20-30 repositories (90%+ Java, popular)
- **Filtering**: 300-500 candidate tasks
- **Validation**: 200-250 final tasks (50-60% pass rate)

### **Quality Distribution:**

- **Excellent** (90+ score): ~30% of tasks
- **Good** (75-89 score): ~60% of tasks
- **Acceptable** (60-74 score): ~10% of tasks

### **Common Rejection Reasons:**

1. **False positives** (25%): Tests didn't actually fail
2. **Flaky tests** (20%): Tests are random/inconsistent
3. **Low quality** (35%): Trivial changes, typos, docs
4. **Patch issues** (15%): Patch doesn't apply or doesn't work
5. **Other** (5%): Timeout, build errors, etc.

---

## 🎯 Quick Reference

### **Most Common Commands:**

```bash
# Go to project
cd /Users/tanishjaggi/Desktop/java-swe-bench

# Set token (do this every time you open a new terminal)
export GITHUB_TOKEN="your_token"

# Run complete pipeline
./scripts/run_pipeline.sh

# Run individual stages
./scripts/run_discovery.sh
./scripts/run_filter.sh
./scripts/run_validate.sh

# Check results
cat data/raw/discovered_repositories.json | jq
cat data/processed/candidate_tasks.json | jq
cat data/tasks/validated_tasks.json | jq

# Build and test
mvn clean test
mvn clean compile
mvn clean install
```

---

## ✅ Success Checklist

Before you start, make sure:
- [ ] Java 17 is installed (`java -version`)
- [ ] Maven is installed (`mvn -version`)
- [ ] GitHub token is set (`echo $GITHUB_TOKEN`)
- [ ] You're in the project directory
- [ ] Tests pass (`mvn clean test`)

After running:
- [ ] `data/raw/discovered_repositories.json` exists (20-30 repos)
- [ ] `data/processed/candidate_tasks.json` exists (300-500 tasks)
- [ ] `data/tasks/validated_tasks.json` exists (200+ tasks)
- [ ] No error messages in logs
- [ ] Quality scores look good (75+)

---

## 🎓 Summary

**In the simplest terms:**

1. **Discovery** = Find good Java projects on GitHub
2. **Filtering** = Find real bugs that were fixed in those projects
3. **Validation** = Make sure the bugs and fixes are real by running tests

**The output** = A dataset of 200+ real bugs with verified fixes that can be used to test AI models

**How long it takes** = About 1-2 days total (but most of it is automated)

**What you need** = Java, Maven, GitHub token, and patience!

---

## 🚀 You're Ready!

Now you know:
- ✅ What every file does
- ✅ How to run the project
- ✅ What the output means
- ✅ How to check progress
- ✅ How to fix problems

**Good luck collecting your high-quality Java bug dataset!** 🎯

If you get stuck, check the other documentation files:
- **SETUP.md** - Detailed setup instructions
- **QUALITY_STANDARDS.md** - What makes a good task
- **TROUBLESHOOTING** section above

Happy benchmarking! 🚀
