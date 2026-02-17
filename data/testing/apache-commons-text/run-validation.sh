#!/bin/bash
# Validation Script for apache/commons-text
# Generated: 2026-02-01T17:20:55.669164600

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning apache/commons-text...'
    git clone https://github.com/apache/commons-text.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-735
echo '=== Validating PR-735 ==='
git checkout a0b89c079b3af0da7bd6bdc3a8a3421182e14aa4 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-735.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=TextStringBuilderTest,StrBuilderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-735.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=TextStringBuilderTest,StrBuilderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-735: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 735 | a0b89c0... | TextStringBuilderTest,StrBuilderTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-735: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 735 | a0b89c0... | TextStringBuilderTest,StrBuilderTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-735: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 735 | a0b89c0... | TextStringBuilderTest,StrBuilderTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-731
echo '=== Validating PR-731 ==='
git checkout b5052c97e84e1c174ec8bfbbb749e33f22917a07 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-731.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=XmlStringLookupTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-731.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=XmlStringLookupTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-731: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 731 | b5052c9... | XmlStringLookupTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-731: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 731 | b5052c9... | XmlStringLookupTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-731: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 731 | b5052c9... | XmlStringLookupTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-729
echo '=== Validating PR-729 ==='
git checkout 685da724c45e74d30df08215bb96bbafdeac4ed6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-729.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=StringLookupFactoryTest,XmlStringLookupTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-729.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=StringLookupFactoryTest,XmlStringLookupTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-729: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 729 | 685da72... | StringLookupFactoryTest,XmlStringLookupTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-729: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 729 | 685da72... | StringLookupFactoryTest,XmlStringLookupTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-729: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 729 | 685da72... | StringLookupFactoryTest,XmlStringLookupTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-725
echo '=== Validating PR-725 ==='
git checkout 66bafadc42c722ce8e8f99f318408ba5baca13b8 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-725.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CharSequenceTranslatorTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-725.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CharSequenceTranslatorTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-725: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 725 | 66bafad... | CharSequenceTranslatorTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-725: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 725 | 66bafad... | CharSequenceTranslatorTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-725: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 725 | 66bafad... | CharSequenceTranslatorTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-687
echo '=== Validating PR-687 ==='
git checkout 5d356fd01d231dd27dd7c38cb98761343d364075 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-687.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DamerauLevenshteinDistanceTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-687.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DamerauLevenshteinDistanceTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-687: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 687 | 5d356fd... | DamerauLevenshteinDistanceTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-687: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 687 | 5d356fd... | DamerauLevenshteinDistanceTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-687: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 687 | 5d356fd... | DamerauLevenshteinDistanceTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-467
echo '=== Validating PR-467 ==='
git checkout fb476ec5f1d64575f09b3187aeee02681e726a3e --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-467.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DoubleFormatTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-467.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DoubleFormatTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-467: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 467 | fb476ec... | DoubleFormatTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-467: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 467 | fb476ec... | DoubleFormatTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-467: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 467 | fb476ec... | DoubleFormatTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-452
echo '=== Validating PR-452 ==='
git checkout efa7475c3da2153a0d3a769dac8f5fe606c2b9fb --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-452.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=TextStringBuilderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-452.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=TextStringBuilderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-452: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 452 | efa7475... | TextStringBuilderTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-452: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 452 | efa7475... | TextStringBuilderTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-452: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 452 | efa7475... | TextStringBuilderTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-449
echo '=== Validating PR-449 ==='
git checkout 28b6e1d38a47cab1b6beaadd8585780b49a178ef --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-449.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,StringLookupFactoryTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-449.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,StringLookupFactoryTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-449: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 449 | 28b6e1d... | XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,Str... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-449: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 449 | 28b6e1d... | XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,Str... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-449: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 449 | 28b6e1d... | XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,Str... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"

# ==========================================
# AUTO-UPDATE TASKS_STATUS.MD
# ==========================================
cd "$SCRIPT_DIR"

# Get repo full name
if [ -f "tasks.json" ]; then
    REPO_FULLNAME=$(head -50 tasks.json | grep -o '"repo" : "[^"]*"' | head -1 | cut -d'"' -f4)
else
    REPO_FULLNAME=$(basename "$(pwd)" | sed 's/-/\//')
fi

# Calculate percentage
if [ $TOTAL_COUNT -gt 0 ]; then
    VALID_PCT=$((VALID_COUNT * 100 / TOTAL_COUNT))
    PP_PCT=$((INVALID_PP_COUNT * 100 / TOTAL_COUNT))
    FF_PCT=$((INVALID_FF_COUNT * 100 / TOTAL_COUNT))
else
    VALID_PCT=0
    PP_PCT=0
    FF_PCT=0
fi

cat > "$SCRIPT_DIR/TASKS_STATUS.md" << STATUSEOF
# Task Validation Status: $REPO_FULLNAME

**VALIDATION_COMPLETE: $(date '+%Y-%m-%d %H:%M:%S')**

## Summary
- **Total Tasks:** $TOTAL_COUNT
- **VALID:** $VALID_COUNT (${VALID_PCT}%)
- **INVALID-PASS-PASS:** $INVALID_PP_COUNT (${PP_PCT}%)
- **INVALID-FAIL-FAIL:** $INVALID_FF_COUNT (${FF_PCT}%)

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)
- **ERROR**: Could not run validation

---

## Tasks

| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |
|------|-------------|----------------|------------------|------------------|--------|-------|
$(echo -e "$TASK_ROWS")

---

**Validation completed:** $(date)
**Status:** COMPLETE - Ready for SWE-bench use

---

## Reproduction

\`\`\`bash
cd $(basename "$SCRIPT_DIR")
bash run-validation.sh
\`\`\`
STATUSEOF

echo ""
echo "TASKS_STATUS.md updated with completion marker in: $SCRIPT_DIR"
