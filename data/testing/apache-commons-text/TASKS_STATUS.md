# Task Validation Status: apache/commons-text

Generated: 2026-02-01T17:20:55.668164300

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
| 735 | a0b89c0... | TextStringBuilderTest, StrBuilderTest | PENDING | PENDING | PENDING | |
| 731 | b5052c9... | XmlStringLookupTest | PENDING | PENDING | PENDING | |
| 729 | 685da72... | StringLookupFactoryTest, XmlStringLookupTest | PENDING | PENDING | PENDING | |
| 725 | 66bafad... | CharSequenceTranslatorTest | PENDING | PENDING | PENDING | |
| 687 | 5d356fd... | DamerauLevenshteinDistanceTest | PENDING | PENDING | PENDING | |
| 467 | fb476ec... | DoubleFormatTest | PENDING | PENDING | PENDING | |
| 452 | efa7475... | TextStringBuilderTest | PENDING | PENDING | PENDING | |
| 449 | 28b6e1d... | XmlEncoderStringLookupTest, XmlDecoderStringLookupTest, StringLookupFactoryTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/apache/commons-text.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
