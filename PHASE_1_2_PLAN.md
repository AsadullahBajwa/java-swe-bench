# Phase 1 & 2 Implementation Plan

## Overview

This document outlines the complete implementation plan for Phases 1 and 2 of the Java SWE-Bench project, targeting completion by November 20, 2025 as per the project timeline.

## Phase 1: Planning & Research (Completed Foundation)

### Status: ✅ Infrastructure Complete

The foundational infrastructure has been established:

- [x] Project structure created
- [x] Maven build system configured
- [x] Core models defined (TaskInstance, Repository)
- [x] Three-stage pipeline architecture implemented
- [x] GitHub API integration
- [x] Git/JGit operations
- [x] Test execution framework
- [x] Configuration management

### Completed Deliverables

1. **Project Setup**
   - Maven POM with all dependencies
   - Directory structure for data processing
   - Configuration files
   - Build and test scripts

2. **Core Architecture**
   - Three-stage pipeline (Discovery → Attribute Filter → Execution Filter)
   - Service layer (GitHub, Patch, Test Runner)
   - Model layer (TaskInstance, Repository)
   - Utility layer (Config, File operations)

3. **Documentation**
   - README.md - Project overview
   - ARCHITECTURE.md - System design
   - SETUP.md - Installation and configuration
   - This document - Implementation plan

## Phase 2: Data Extraction & Benchmark Design

### Timeline: Now → November 20, 2025

### Target Metrics

Based on project plan and previous documentation:

- **Repositories**: 20-30 high-quality Java projects
- **Task Instances**: 200+ validated issue-PR-test triplets
- **Success Rate**: All tasks must pass fail-to-pass criteria
- **Quality**: Clear problem statements, reproducible tests, clean patches

### Stage 1: Repository Discovery (Week 1-2)

#### Objectives
- Discover 20-30 qualifying Java repositories
- Validate build systems and test infrastructure
- Ensure repository diversity

#### Selection Criteria (from project plan)
```
✓ Language: Java (primary)
✓ Not forked
✓ Stars: 50+
✓ Updated: Last 1-2 years
✓ Has active issues
✓ Has pull requests
✓ Includes test files
✓ Build tool: Maven or Gradle
```

#### Implementation Steps

1. **Configure GitHub API**
   ```bash
   export GITHUB_TOKEN="your_token"
   ```

2. **Run Discovery**
   ```bash
   ./scripts/run_discovery.sh
   ```

3. **Review Results**
   - Check `data/raw/discovered_repositories.json`
   - Verify repository diversity
   - Ensure build tool coverage (Maven/Gradle)

4. **Quality Checks**
   - Repository size (avoid extremely large repos like Elasticsearch)
   - Active maintenance (recent commits)
   - Test coverage (has test directory)
   - Build configuration validity

#### Expected Repositories (examples from previous work)

- **RxJava** - Reactive programming library
- **Nacos** - Service discovery platform
- **DBeaver** - Database management tool
- **Elasticsearch** - Search engine (use cautiously due to size)
- **Spring Framework** modules
- **Apache Commons** projects
- **Google Guava**
- **JUnit** itself

#### Success Criteria
- [ ] 20-30 repositories discovered
- [ ] All meet selection criteria
- [ ] Mix of Maven (60%) and Gradle (40%)
- [ ] Variety of domain areas
- [ ] All repositories accessible and cloneable

### Stage 2: Attribute Filtering (Week 3-6)

#### Objectives
- Extract 400+ candidate task instances (2x target for filtering)
- Validate issue-PR linkage
- Check patch quality
- Verify test presence

#### Extraction Criteria

**Issue Quality:**
- Problem statement length > 50 characters
- Clear description of bug or feature
- Not a duplicate or spam issue
- Closed status with linked PR

**Pull Request Quality:**
- Merged status
- References an issue (via #number, closes, fixes, resolves)
- Contains code changes (not just docs)
- Has associated tests
- Files changed < 100

**Patch Quality:**
- Valid unified diff format
- Applies cleanly to base commit
- Contains both code and test changes
- Reasonable size (< 100 files)

#### Implementation Steps

1. **Run Attribute Filter**
   ```bash
   ./scripts/run_filter.sh
   ```

2. **Extract Task Instances**
   - For each repository:
     - Get merged PRs (last 2 years)
     - Find linked issues
     - Extract patches
     - Identify test files
     - Create TaskInstance objects

3. **Apply Filters**
   ```java
   // Pseudocode of filtering logic
   if (hasValidProblemStatement(issue) &&
       prIsMerged(pr) &&
       patchSize < MAX_FILES &&
       hasTestChanges(patch) &&
       patchAppliesCleanly(patch)) {
       acceptTask();
   }
   ```

4. **Review Candidates**
   - Check `data/processed/candidate_tasks.json`
   - Verify diversity across repositories
   - Inspect sample tasks manually
   - Check for edge cases

#### Enhancements for Quality

Based on previous implementation lessons:

1. **BM25 Context Selection** (Optional)
   - Select relevant code context for each issue
   - Improves task clarity
   - Helps with patch understanding

2. **Test Classification**
   - Identify FAIL_TO_PASS tests
   - Identify PASS_TO_PASS tests
   - Mark test types (unit, integration)

3. **Metadata Collection**
   - Java version required
   - Build tool and version
   - Module information (for multi-module projects)
   - Test command patterns

4. **Patch Validation**
   - Auto-repair common patch issues
   - Validate diff format
   - Check for binary files
   - Ensure no credentials leaked

#### Expected Output

```json
{
  "instance_id": "ReactiveX-RxJava-1234",
  "repo": "ReactiveX/RxJava",
  "issue_number": 1234,
  "pull_number": 5678,
  "base_commit": "abc123...",
  "patch": "diff --git a/...",
  "problem_statement": "Observable.concat fails with...",
  "test_command": "mvn test -Dtest=ObservableTest#testConcat",
  "build_tool": "maven",
  "java_version": "8",
  "created_at": "2024-01-15T10:30:00Z"
}
```

#### Success Criteria
- [ ] 400+ candidate tasks extracted
- [ ] All have valid patches
- [ ] All have clear problem statements
- [ ] All include test changes
- [ ] Distributed across 20+ repositories

### Stage 3: Execution Filtering (Week 7-10)

#### Objectives
- Validate 200+ tasks through execution
- Verify fail-to-pass criterion
- Ensure no regression (pass-to-pass)
- Generate final validated dataset

#### Validation Process

For each candidate task:

1. **Setup**
   ```bash
   git clone <repository>
   cd <repository>
   git checkout <base_commit>
   ```

2. **Pre-Patch Test (Must Fail)**
   ```bash
   # Run FAIL_TO_PASS tests
   mvn test -Dtest=<fail_to_pass_tests>
   # Expected: FAILURE
   ```

3. **Apply Patch**
   ```bash
   git apply <patch_file>
   ```

4. **Post-Patch Test (Must Pass)**
   ```bash
   # Run FAIL_TO_PASS tests
   mvn test -Dtest=<fail_to_pass_tests>
   # Expected: SUCCESS
   ```

5. **Regression Check (Must Still Pass)**
   ```bash
   # Run PASS_TO_PASS tests
   mvn test -Dtest=<pass_to_pass_tests>
   # Expected: SUCCESS
   ```

6. **Accept or Reject**
   - Accept if all criteria met
   - Reject if any step fails
   - Log reason for rejection

#### Implementation Steps

1. **Run Execution Filter**
   ```bash
   ./scripts/run_validate.sh
   ```

2. **Monitor Progress**
   - Track completion rate
   - Log failures with reasons
   - Estimate time remaining

3. **Handle Failures**
   - Timeout: Increase limit or skip
   - Build failure: Check dependencies
   - Test flakiness: Retry 2-3 times
   - Patch doesn't apply: Try git apply with different flags

4. **Optimize Execution**
   - Run in parallel (4-8 workers)
   - Use repository mirrors
   - Cache Maven/Gradle downloads
   - Clean up workspaces aggressively

#### Validation Challenges & Solutions

Based on previous implementation:

**Challenge 1: Java Version Mismatch**
```bash
# Solution: Use SDKMAN to switch versions
sdk use java 8.0.312-tem
mvn test
```

**Challenge 2: Multi-Module Projects**
```bash
# Solution: Target specific modules
mvn test -pl :module-name -Dtest=TestClass
```

**Challenge 3: Flaky Tests**
```python
# Solution: Retry logic
max_retries = 3
for attempt in range(max_retries):
    result = run_tests()
    if result.consistent:
        break
```

**Challenge 4: Large Repositories**
```bash
# Solution: Shallow clone
git clone --depth=1 --branch=<commit> <repo>
```

#### Expected Results

Final validated tasks saved to: `data/tasks/validated_tasks.json`

**Statistics:**
- Total validated: 200+
- Pass rate: ~50% of candidates (400 candidates → 200 validated)
- Average validation time: 5-10 minutes per task
- Total execution time: 15-30 hours

**Distribution:**
- RxJava: 25-30 tasks
- Nacos: 20-25 tasks
- DBeaver: 15-20 tasks
- Elasticsearch: 10-15 tasks
- Others: 130+ tasks

#### Success Criteria
- [ ] 200+ tasks validated
- [ ] All pass fail-to-pass criterion
- [ ] No pass-to-pass regressions
- [ ] Coverage of 20+ repositories
- [ ] Mix of bug fixes and features

### Data Quality Assurance

#### Manual Review Sample

Randomly select 20 tasks (10%) for manual review:

1. Read problem statement
2. Review patch diff
3. Understand test changes
4. Verify fix correctness
5. Check for edge cases

#### Quality Metrics

- **Problem Clarity**: Can a developer understand the issue?
- **Patch Quality**: Is the fix appropriate and minimal?
- **Test Coverage**: Do tests adequately cover the change?
- **Reproducibility**: Can the bug be reproduced at base commit?
- **Fix Verification**: Does the patch actually fix the issue?

#### Rejection Reasons (Track These)

Common reasons for task rejection:

1. Tests fail for wrong reasons (environment, dependencies)
2. Patch doesn't apply cleanly
3. Tests pass even without patch (false positive)
4. Patch breaks other tests (regression)
5. Issue is not reproducible
6. Patch is too large or complex
7. Timeout during validation

## Deliverables Checklist

### Code Deliverables
- [x] Repository discovery implementation
- [x] Attribute filtering implementation
- [x] Execution validation implementation
- [x] Test runner with Maven/Gradle support
- [x] GitHub API integration
- [x] Patch extraction and application
- [x] Configuration management

### Data Deliverables
- [ ] `data/raw/discovered_repositories.json` (20-30 repos)
- [ ] `data/processed/candidate_tasks.json` (400+ candidates)
- [ ] `data/tasks/validated_tasks.json` (200+ validated)
- [ ] Individual task files: `data/tasks/<instance_id>.json`

### Documentation Deliverables
- [x] README.md - Project overview
- [x] ARCHITECTURE.md - System design
- [x] SETUP.md - Installation guide
- [x] This plan document
- [ ] RESULTS.md - Phase 2 results and analysis
- [ ] Task catalog with statistics

### Testing Deliverables
- [x] Unit tests for models
- [x] Unit tests for utilities
- [ ] Integration tests for pipeline stages
- [ ] End-to-end pipeline test
- [ ] Performance benchmarks

## Timeline

### Week 1-2: Discovery (Complete by Week 2)
- Set up GitHub token
- Run repository discovery
- Review and validate discovered repos
- Document repository list

### Week 3-4: Initial Extraction (Complete by Week 4)
- Run attribute filter on first 10 repositories
- Review candidate quality
- Tune filtering parameters
- Address any issues

### Week 5-6: Full Extraction (Complete by Week 6)
- Complete extraction for all 20-30 repositories
- Achieve 400+ candidates
- Generate extraction report
- Prepare for validation

### Week 7-8: Validation Phase 1 (Complete by Week 8)
- Set up test execution environment
- Validate first 100 candidates
- Monitor success rate
- Optimize validation process

### Week 9-10: Validation Phase 2 (Complete by Week 10)
- Complete validation of remaining candidates
- Achieve 200+ validated tasks
- Generate final dataset
- Perform quality assurance

### Week 11: Analysis & Documentation (Complete by Nov 20)
- Analyze results
- Generate statistics
- Write RESULTS.md
- Create task catalog
- Final review

## Risk Mitigation

### Risk 1: Insufficient Valid Tasks
**Impact**: May not reach 200+ target
**Mitigation**:
- Start with 30 repositories instead of 20
- Extract 500+ candidates instead of 400
- Lower success threshold if quality maintained

### Risk 2: Execution Timeout
**Impact**: Validation takes too long
**Mitigation**:
- Increase parallel workers
- Optimize test commands
- Skip extremely slow tests
- Use faster build tools

### Risk 3: Test Flakiness
**Impact**: Valid tasks rejected
**Mitigation**:
- Implement retry logic (3 attempts)
- Run tests multiple times for consistency
- Document flaky tests separately
- Consider deterministic tests only

### Risk 4: Repository Access Issues
**Impact**: Cannot clone or test repos
**Mitigation**:
- Use repository mirrors
- Shallow clones where possible
- Cache cloned repositories
- Have backup repository list

## Success Metrics

### Quantitative Metrics
- 20-30 repositories discovered ✓
- 200+ validated task instances ✓
- 50%+ validation success rate ✓
- < 5% flaky tests ✓
- < 10 minute average validation time ✓

### Qualitative Metrics
- Tasks represent real bugs/features ✓
- Problem statements are clear ✓
- Patches are minimal and correct ✓
- Tests adequately cover changes ✓
- Dataset is diverse (multiple projects) ✓

## Next Steps After Phase 2

Once Phase 2 is complete:

1. **Phase 3 Preparation** (Nov 21 - Jan 15)
   - Design patch evaluation framework
   - Integrate with language models
   - Set up evaluation pipeline
   - Define evaluation metrics

2. **Model Evaluation**
   - Test Claude, GPT-4, and other models
   - Measure pass@k rates
   - Analyze failure patterns
   - Compare with Python SWE-bench results

3. **Publication & Submission**
   - Write research paper
   - Create benchmark website
   - Submit to conferences
   - Open source dataset

## References

- **Java_SWE_Bench_Project_Documentation 2.pdf**: Previous implementation
- **Updated_Project_Plan.pdf**: Project timeline and phases
- **swe-bench-python paper.pdf**: Original SWE-bench methodology

## Appendix: Command Reference

```bash
# Complete Phase 2 pipeline
./scripts/run_pipeline.sh

# Or run stages individually:
./scripts/run_discovery.sh   # Stage 1
./scripts/run_filter.sh       # Stage 2
./scripts/run_validate.sh     # Stage 3

# Monitor progress
tail -f logs/pipeline.log

# Check results
cat data/raw/discovered_repositories.json
cat data/processed/candidate_tasks.json
cat data/tasks/validated_tasks.json
```

## Conclusion

With the foundation complete, Phase 2 execution is ready to begin. The focus now shifts from infrastructure to data collection and validation. Following this plan will result in a high-quality Java SWE-Bench dataset suitable for evaluating language models on real-world software engineering tasks.

**Target Completion**: November 20, 2025
**Current Status**: Ready to execute Phase 2
**Next Action**: Run repository discovery
