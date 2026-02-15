#!/bin/bash
# Validation Script for apache/commons-text
# Generated: 2026-02-01T17:20:55.669164600

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning apache/commons-text...'
    git clone https://github.com/apache/commons-text.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-735: INVALID-PASS-PASS'
else
    echo 'PR-735: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-731: INVALID-PASS-PASS'
else
    echo 'PR-731: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-729: INVALID-PASS-PASS'
else
    echo 'PR-729: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-725: INVALID-PASS-PASS'
else
    echo 'PR-725: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-687: INVALID-PASS-PASS'
else
    echo 'PR-687: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-467: INVALID-PASS-PASS'
else
    echo 'PR-467: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-452: INVALID-PASS-PASS'
else
    echo 'PR-452: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-449: INVALID-PASS-PASS'
else
    echo 'PR-449: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"
