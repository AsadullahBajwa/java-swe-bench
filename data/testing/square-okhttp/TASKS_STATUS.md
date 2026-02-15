# Task Validation Status: square/okhttp

Generated: 2026-02-01T17:20:55.437297400

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after
- **INVALID-FAIL-FAIL**: Tests fail both before and after
- **ERROR**: Could not run validation
- **PENDING**: Not yet tested

---

## Tasks

| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |
|------|-------------|----------------|------------------|------------------|--------|-------|
| 9269 | bb420b2... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9268 | 2b1b18d... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9207 | 5b23df7... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9129 | 2f3491c... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9118 | 8eca8a8... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9115 | d4a5be1... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9112 | fa84a6e... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9098 | fa783c3... | EventSourceFactoryTest | PENDING | PENDING | PENDING | |
| 9044 | 8fde16d... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9031 | 929a41c... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9030 | d7851de... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 9010 | 8b74eb4... | EventSourceFactoryTest | PENDING | PENDING | PENDING | |
| 8972 | 7c7d404... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8967 | 88593f8... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8965 | 0984bc3... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8954 | 0ef99d6... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8947 | d51c177... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8943 | add175b... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8939 | 9eb967f... | __ALL_TESTS__ | PENDING | PENDING | PENDING | |
| 8917 | f65e3e2... | AppTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/square/okhttp.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
