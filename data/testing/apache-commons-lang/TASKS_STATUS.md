# Task Validation Status: apache/commons-lang

**Validation Complete: 2026-02-01**

## Summary
- **Total Tasks:** 20
- **VALID:** 16 (80%)
- **INVALID-PASS-PASS:** 1 (5%)
- **INVALID-FAIL-FAIL:** 3 (15%)

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)
- **ERROR**: Could not run validation
- **PENDING**: Not yet tested

---

## Tasks

| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |
|------|-------------|----------------|------------------|------------------|--------|-------|
| 1591 | 7bcb03a... | ClassUtilsShortClassNameTest | FAIL (1) | PASS (0) | **VALID** | |
| 1589 | cebde03... | ArrayUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1585 | 87538eb... | ArrayUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1584 | 3f803b8... | RecursiveToStringStyleTest | FAIL (1) | PASS (0) | **VALID** | |
| 1577 | ac91ddd... | ClassUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1571 | 67f5023... | StringUtilsAbbreviateTest | FAIL (1) | PASS (0) | **VALID** | |
| 1561 | 0378808... | BitFieldTest, BitFieldLongTest | FAIL (1) | PASS (0) | **VALID** | |
| 1560 | ba6cf8e... | NumberUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1559 | 0378808... | ArrayUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1549 | 71d4f3d... | TypeUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1548 | 5e9736a... | TypeUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1531 | ddf1ce9... | NumberUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1530 | 2595926... | CharSetTest | FAIL (1) | PASS (0) | **VALID** | |
| 1528 | 3bd1625... | ObjectUtilsTest | PASS (0) | PASS (0) | INVALID-PASS-PASS | Test doesn't expose bug |
| 1519 | 91b536e... | ArrayUtilsConcatTest | FAIL (1) | PASS (0) | **VALID** | |
| 1495 | f8a6bf9... | ClassUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1494 | 162575c... | ClassUtilsTest | FAIL (1) | PASS (0) | **VALID** | |
| 1492 | a33e37a... | ClassUtilsTest | FAIL (1) | FAIL (1) | INVALID-FAIL-FAIL | Code patch doesn't fix |
| 1490 | 09b30e3... | StringUtilsAbbreviateTest | FAIL (1) | FAIL (1) | INVALID-FAIL-FAIL | Code patch doesn't fix |
| 1483 | ba85f5e... | CalendarUtilsTest, etc. | FAIL (1) | FAIL (1) | INVALID-FAIL-FAIL | Code patch doesn't fix |

---

## Valid Tasks for SWE-bench (16 tasks)

The following tasks are suitable for use in SWE-bench benchmarks:

| PR # | Description |
|------|-------------|
| 1591 | ClassUtils.getShortClassName(Class) $ handling |
| 1589 | ArrayUtils NaN handling with tolerance |
| 1585 | ArrayUtils.subarray overflow fix |
| 1584 | RecursiveToStringStyle BigDecimal handling |
| 1577 | ClassUtils improvements |
| 1571 | StringUtils.abbreviate null marker handling |
| 1561 | BitField long support |
| 1560 | NumberUtils.isParsable float handling |
| 1559 | ArrayUtils improvements |
| 1549 | TypeUtils parameterized types |
| 1548 | TypeUtils strict type checks |
| 1531 | NumberUtils improvements |
| 1530 | CharSet improvements |
| 1519 | ArrayUtils.concat improvements |
| 1495 | ClassUtils improvements |
| 1494 | ClassUtils improvements |

---

## Reproduction

To reproduce these results:

```powershell
cd data/testing/apache-commons-lang
.\run-validation.ps1
```

---

## Validation Commands (Manual)

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/apache/commons-lang.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
