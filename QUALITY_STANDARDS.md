# Java SWE-Bench Quality Standards

## 🎯 Overview

This document defines the **strict quality standards** for task inclusion in the Java SWE-Bench benchmark. We only accept **high-quality, real-world tasks** that represent genuine software engineering challenges.

## ✨ Quality Philosophy

### What We Want
✅ **Real bugs** that developers actually encountered
✅ **Meaningful features** that add genuine value
✅ **Production-grade code** with proper tests
✅ **Clear problem statements** with reproduction steps
✅ **Focused fixes** that solve specific issues
✅ **Stable tests** that reliably pass/fail

### What We Reject
❌ **Trivial changes** (typos, formatting, comments)
❌ **Documentation-only** updates
❌ **Build script** tweaks
❌ **Dependency version** bumps
❌ **Style/linting** fixes
❌ **Unclear issues** without proper context
❌ **Flaky tests** that are non-deterministic

---

## 📋 Quality Validation Stages

### Stage 1: Repository Quality (Discovery)

**Criteria:**
- ✅ Java ≥ 75% of codebase (ensure Java-centric)
- ✅ 50+ GitHub stars (popularity indicator)
- ✅ Not forked (original work)
- ✅ Updated within 1-2 years (active maintenance)
- ✅ Has active issues and merged PRs
- ✅ Includes comprehensive test suite
- ✅ Uses Maven or Gradle

**Purpose:** Ensure we're working with high-quality, well-maintained projects

---

### Stage 2: Task Quality (Attribute Filtering)

#### A. Problem Statement Quality

**REQUIRED (Minimum 100 characters):**
```
❌ BAD: "Fix bug"
❌ BAD: "Update method"
✅ GOOD: "Observable.concat fails with NullPointerException when
         called with empty sequence. Expected behavior is to
         return empty observable. Occurs in RxJava 2.x when..."
```

**Quality Checks:**
- Minimum 100 characters (configurable)
- At least 2 sentences
- Contains context words: "when", "expected", "actual", "reproduce", "steps"
- Not just a title, actual description

**Automatic Rejection:**
- One-liner issues
- Title-only problems
- No context provided

#### B. Real-World Issue Detection

**HIGH-QUALITY INDICATORS (at least ONE required):**
```
✅ bug, error, exception, crash, fail
✅ incorrect, wrong, invalid, broken
✅ memory leak, performance issue
✅ deadlock, race condition, concurrent
✅ security vulnerability
✅ data loss, corruption, inconsistent
✅ regression, not working
✅ feature request, enhancement, implement
```

**LOW-QUALITY PATTERNS (AUTO-REJECT):**
```
❌ typo, spelling, grammar, formatting
❌ whitespace, indentation, style
❌ readme, documentation only, doc update
❌ comment, javadoc only
❌ dependency version, upgrade dependency
❌ add license, copyright
❌ gitignore, travis, ci config
```

**Example Validation:**
```java
✅ ACCEPTED: "NullPointerException when processing concurrent requests"
   → Contains: "exception", "concurrent" (real bug)

❌ REJECTED: "Fix typo in README.md"
   → Contains: "typo", "README" (trivial doc change)

❌ REJECTED: "Update Spring dependency from 5.1 to 5.2"
   → Contains: "dependency" (version bump)

✅ ACCEPTED: "Memory leak in connection pool causes OOM after 1000 requests"
   → Contains: "memory leak", real performance bug
```

#### C. Patch Quality

**Size Requirements:**
- Minimum: 5 lines changed (substantive change)
- Maximum: 500 lines changed (focused fix)
- Must modify at least one .java file

**Content Requirements:**
✅ Must include code changes (not just deletions)
✅ Must affect Java source files
✅ Must include test changes
✅ Should have meaningful additions (not just whitespace)

**Automatic Rejections:**
```
❌ Deletion-only patches (just removing code)
❌ No Java file modifications
❌ Only build file changes
❌ Only documentation changes
❌ Only whitespace/formatting
```

**Example:**
```diff
❌ REJECTED (too small):
   - private int count = 0;
   + private int count = 1;

✅ ACCEPTED (substantive):
   +    if (source == null) {
   +        throw new NullPointerException("Source cannot be null");
   +    }
   +
   +    synchronized (lock) {
   +        return doProcess(source);
   +    }

   // Plus corresponding test additions
```

#### D. Test Quality

**REQUIRED:**
- ✅ Modifies at least one test file
- ✅ Adds at least 3 test-related lines
- ✅ Includes assertions/verifications
- ✅ Test method names are meaningful

**Test Change Detection:**
```java
✅ REQUIRED patterns in additions:
   - @Test annotation
   - assert* statements (assertTrue, assertEquals, etc.)
   - verify/expect/should methods
   - Test method names (testXyz, shouldXyz)
```

**Examples:**
```java
❌ REJECTED (no assertions):
   @Test
   public void testFoo() {
       obj.doSomething();
   }

✅ ACCEPTED (proper test):
   @Test
   public void testConcatWithNull_shouldThrowNPE() {
       Observable<String> obs = Observable.concat(null);

       assertThrows(NullPointerException.class, () -> {
           obs.subscribe();
       });
   }
```

#### E. Quality Scoring

**Score Breakdown (0-100):**
- **Problem Statement** (25 points)
  - Has meaningful content: +25
  - > 300 characters: +5
  - Contains "reproduce": +5

- **Real-World Relevance** (25 points)
  - Matches quality patterns: +25

- **Patch Quality** (25 points)
  - Well-formed patch: +25

- **Test Quality** (25 points)
  - Has quality tests: +20
  - Has valid fail-to-pass: +5

**Minimum Scores:**
- **75+**: ACCEPTED (GOOD quality)
- **90+**: EXCELLENT quality
- **<75**: REJECTED

---

### Stage 3: Execution Validation

#### A. Fail-to-Pass Verification (CRITICAL)

**The Gold Standard:**
```
1. Tests MUST fail at base commit
2. Tests MUST pass after patch
3. No other tests should break
4. Tests must be stable (not flaky)
```

**Validation Steps:**

**Step 1: Pre-Patch Test (MUST FAIL)**
```bash
git checkout <base_commit>
mvn test -Dtest=MyTest#testFoo

Expected: ❌ FAILURE
If PASS → ⚠️ FALSE POSITIVE, REJECT TASK
```

**Step 2: Apply Patch**
```bash
git apply patch.diff

Expected: ✅ Success
If fails → ❌ Invalid patch, REJECT
```

**Step 3: Post-Patch Test (MUST PASS)**
```bash
mvn test -Dtest=MyTest#testFoo

Expected: ✅ SUCCESS
If FAIL → ❌ Patch doesn't fix, REJECT
```

**Step 4: Regression Check (MUST STILL PASS)**
```bash
mvn test -Dtest=OtherTests

Expected: ✅ All PASS
If ANY FAIL → ❌ Regression, REJECT
```

**Step 5: Stability Check (MUST BE CONSISTENT)**
```bash
# Run tests again
mvn test -Dtest=MyTest#testFoo

Expected: ✅ SUCCESS (consistent with step 3)
If FAIL → ❌ Flaky test, REJECT
```

#### B. Fail-to-Pass Test Structure

**REQUIRED:**
- Must have 1-10 FAIL_TO_PASS tests
- Test names must be meaningful (>5 characters)
- Tests must be properly formatted

**Examples:**
```
✅ GOOD:
   FAIL_TO_PASS: ["ObservableTest#testConcatWithNull"]

❌ BAD:
   FAIL_TO_PASS: [] (empty)

❌ BAD:
   FAIL_TO_PASS: ["test1", "test2", ..., "test50"] (too many)

❌ BAD:
   FAIL_TO_PASS: ["t"] (not meaningful)
```

#### C. Pass-to-Pass Validation

**Purpose:** Ensure no regressions

**Process:**
```
For each test that PASSED at base commit:
   Run test after patch
   IF test now FAILS → ❌ REGRESSION, REJECT TASK
```

**Why This Matters:**
- Ensures patch doesn't break existing functionality
- Validates fix is focused and targeted
- Prevents "fixing one bug by creating another"

---

## 🎓 Quality Examples

### ✅ EXCELLENT Task Example

**Issue:** "Memory leak in HTTP connection pool"

**Problem Statement:**
```
When making > 1000 HTTP requests, the connection pool fails to
release connections properly, leading to OutOfMemoryError.

Steps to reproduce:
1. Create HttpClient with connection pool
2. Make 1000+ requests
3. Monitor memory usage
4. Observe OOM after ~1500 requests

Expected: Connections released after use
Actual: Connections accumulate, causing OOM

Affects: HttpClient 4.5.x
Environment: Java 11, Linux
```

**Quality Score:** 95/100
- ✅ Detailed problem statement (500+ chars)
- ✅ Real-world bug (memory leak)
- ✅ Reproduction steps provided
- ✅ Clear expected vs actual
- ✅ Environment details

**Patch:** 35 lines
- Adds proper connection release logic
- Includes try-finally block
- Adds defensive null checks
- Updates 2 test files with 5 new test methods

**Tests:**
```java
@Test
public void testConnectionRelease_shouldCloseAfterUse() { ... }

@Test
public void testConnectionPool_shouldNotLeakMemory() { ... }
```

**Validation:**
- ✅ Tests fail at base (OOM occurs)
- ✅ Tests pass after patch (no leak)
- ✅ All other tests still pass
- ✅ Stable across multiple runs

---

### ❌ REJECTED Task Examples

#### Example 1: Trivial Typo
```
Issue: "Fix typo in variable name"
Problem: "Rename 'clas' to 'class'"
Patch: 1 line (renaming)
Reason: ❌ Trivial change, no real bug
```

#### Example 2: Documentation Only
```
Issue: "Update README with new examples"
Patch: Only modifies README.md (no code)
Reason: ❌ Documentation only, no code fix
```

#### Example 3: False Positive
```
Issue: "Tests are failing"
Problem: "Fix failing tests"
Patch: Modifies test expectations

Pre-patch test: ✅ PASS (no actual failure!)
Reason: ❌ False positive, tests already passing
```

#### Example 4: Flaky Tests
```
Issue: "Concurrent test occasionally fails"
Pre-patch: ❌ FAIL
Post-patch: ✅ PASS
Second run post-patch: ❌ FAIL
Reason: ❌ Flaky test, not deterministic
```

#### Example 5: Too Large
```
Issue: "Refactor entire authentication module"
Patch: 2000 lines, 50 files
Reason: ❌ Too large, not focused
```

---

## 📊 Expected Quality Metrics

### Input → Output Funnel

```
Stage 1: Discovery
   Input: ~1000 repositories
   Output: 20-30 qualified repositories
   Pass Rate: ~2-3%

Stage 2: Attribute Filtering
   Input: ~1000 issue-PR pairs
   Output: ~400 candidate tasks
   Pass Rate: ~40%

Stage 3: Execution Validation
   Input: ~400 candidates
   Output: ~200 validated tasks
   Pass Rate: ~50%

Final Dataset:
   200+ high-quality tasks
   From 20-30 repositories
   Quality score: Average 85+/100
```

### Quality Distribution Goals

```
90-100 (EXCELLENT): 30% (60 tasks)
75-89  (GOOD):      60% (120 tasks)
60-74  (ACCEPTABLE): 10% (20 tasks)
<60    (REJECTED):  0%
```

---

## ⚙️ Configuration

### Quality Thresholds (application.properties)

```properties
# Repository Quality
discovery.min.java.percentage=75.0
discovery.min.stars=50

# Task Quality
filter.min.problem.statement.length=100
filter.min.quality.score=75
filter.require.real.world.issue=true
filter.max.files.changed=100

# Test Validation
execution.verify.stability=true
execution.require.pass.to.pass=true
execution.timeout.minutes=10
```

### Adjusting Standards

**To be MORE strict (higher quality):**
```properties
filter.min.quality.score=85
filter.min.problem.statement.length=200
discovery.min.java.percentage=90.0
```

**To be MORE lenient (more tasks):**
```properties
filter.min.quality.score=65
filter.min.problem.statement.length=75
discovery.min.java.percentage=60.0
```

**Recommendation:** Start with defaults (75/100), only adjust if:
- Not reaching 200 task target → Lower to 70
- Too many low-quality tasks → Raise to 80

---

## 🔍 Quality Assurance Process

### Automated Validation

Every task goes through:
1. ✅ QualityValidator.isHighQuality()
2. ✅ QualityValidator.hasValidFailToPassTests()
3. ✅ Execution validation (5-step process)
4. ✅ Stability verification

### Manual Spot-Check (Recommended)

Sample 10% of validated tasks:
```bash
# Select 20 random tasks
for task in $(ls data/tasks/*.json | shuf | head -20); do
    # Review manually
    cat $task | jq '.problem_statement'
    cat $task | jq '.patch' | head -50
done
```

**Check for:**
- Clear problem description?
- Meaningful code change?
- Proper test coverage?
- Real-world relevance?

---

## 📈 Quality Metrics Dashboard

### Per-Repository Metrics

Track for each repository:
- Tasks extracted
- Tasks validated
- Average quality score
- Pass rate
- Common rejection reasons

### Overall Metrics

```
Total Repositories: 25
Total Tasks: 215
Average Quality Score: 87.3/100

Quality Distribution:
  EXCELLENT (90+): 72 tasks (33%)
  GOOD (75-89): 128 tasks (60%)
  ACCEPTABLE (60-74): 15 tasks (7%)

Validation Success Rate: 52%

Top Rejection Reasons:
  1. Low quality score: 35%
  2. False positive (tests pass at base): 25%
  3. Flaky tests: 20%
  4. Trivial changes: 15%
  5. Other: 5%
```

---

## 🎯 Success Criteria

**Phase 2 Complete When:**

✅ 200+ tasks validated
✅ Average quality score ≥ 80/100
✅ 100% pass fail-to-pass criterion
✅ 0% regression (pass-to-pass maintained)
✅ < 5% flaky tests
✅ Tasks from 20+ repositories
✅ Quality distribution matches goals

---

## 🚀 Running with Quality Standards

```bash
# Discovery with quality filters
./scripts/run_discovery.sh

# Attribute filtering with quality validation
./scripts/run_filter.sh

# Execution validation with stability checks
./scripts/run_validate.sh

# Full pipeline
./scripts/run_pipeline.sh
```

**Monitor quality:**
```bash
# Check quality scores
grep "quality:" logs/filter.log

# Check validation results
grep "✅\|❌" logs/validate.log

# Generate quality report
cat data/tasks/validated_tasks.json | jq '[.[].metadata.quality_score] | add/length'
```

---

## 📚 References

- **Python SWE-bench paper**: Quality standards from original
- **Best practices**: Industry-standard bug reporting
- **Test-driven development**: Fail-to-pass methodology

---

## ✨ Conclusion

These quality standards ensure that Java SWE-Bench contains **only high-quality, real-world tasks** that genuinely test a model's software engineering capabilities.

**Remember:**
- Quality > Quantity
- Real bugs > Trivial changes
- Stable tests > Flaky tests
- Clear problems > Vague issues

**Goal:** Create a benchmark that developers respect and trust.
