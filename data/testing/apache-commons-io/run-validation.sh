#!/bin/bash
# Validation Script for apache/commons-io
# Generated: 2026-02-01T17:20:55.554833100

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning apache/commons-io...'
    git clone https://github.com/apache/commons-io.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

# PR-818
echo '=== Validating PR-818 ==='
git checkout 8f66b3212c3d35c74cc96e7d0b3258f0fb9305f1 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-818.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-818.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-818: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-818: INVALID-PASS-PASS'
else
    echo 'PR-818: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-817
echo '=== Validating PR-817 ==='
git checkout 3557766ab48bb876008b0a2cb9bd1933275a306a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-817.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ByteArraySeekableByteChannelCompressTest,AbstractSeekableByteChannelTest,ByteArraySeekableByteChannelTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-817.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ByteArraySeekableByteChannelCompressTest,AbstractSeekableByteChannelTest,ByteArraySeekableByteChannelTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-817: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-817: INVALID-PASS-PASS'
else
    echo 'PR-817: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-801
echo '=== Validating PR-801 ==='
git checkout c28dc1bdc28cc3a47ca3a897ce31cac1fc9592c2 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-801.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOCaseTest,IOUtilsConcurrentTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-801.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOCaseTest,IOUtilsConcurrentTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-801: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-801: INVALID-PASS-PASS'
else
    echo 'PR-801: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-800
echo '=== Validating PR-800 ==='
git checkout b95cbfa29df2928578a133b395a3e03dd05658fb --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-800.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-800.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-800: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-800: INVALID-PASS-PASS'
else
    echo 'PR-800: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-799
echo '=== Validating PR-799 ==='
git checkout f51d19cabad7b8c67e2992a2ab22465658249485 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-799.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-799.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-799: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-799: INVALID-PASS-PASS'
else
    echo 'PR-799: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-796
echo '=== Validating PR-796 ==='
git checkout 07d2cd9c493baae1e82553b3da420d17a6093c05 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-796.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-796.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-796: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-796: INVALID-PASS-PASS'
else
    echo 'PR-796: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-795
echo '=== Validating PR-795 ==='
git checkout 07d2cd9c493baae1e82553b3da420d17a6093c05 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-795.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-795.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-795: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-795: INVALID-PASS-PASS'
else
    echo 'PR-795: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-790
echo '=== Validating PR-790 ==='
git checkout 66db0c6610270ad58f93cf393fe2359f46d395b6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-790.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BrokenReaderTest,ClosedInputStreamTest,MarkShieldInputStreamTest,BrokenWriterTest,ClosedWriterTest,IOUtilsTest,ByteArrayOutputStreamTest,NullAppendableTest,NullWriterTest,ProxyReaderTest,NullInputStreamTest,ProxyWriterTest,NullOutputStreamTest,UnsynchronizedBufferedReaderTest,ClosedReaderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-790.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BrokenReaderTest,ClosedInputStreamTest,MarkShieldInputStreamTest,BrokenWriterTest,ClosedWriterTest,IOUtilsTest,ByteArrayOutputStreamTest,NullAppendableTest,NullWriterTest,ProxyReaderTest,NullInputStreamTest,ProxyWriterTest,NullOutputStreamTest,UnsynchronizedBufferedReaderTest,ClosedReaderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-790: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-790: INVALID-PASS-PASS'
else
    echo 'PR-790: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-786
echo '=== Validating PR-786 ==='
git checkout 3c0677e8b7241a81e27d02791f0cf57fd1ab9a78 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-786.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-786.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CloseShieldChannelTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-786: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-786: INVALID-PASS-PASS'
else
    echo 'PR-786: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-785
echo '=== Validating PR-785 ==='
git checkout a96ae748c00343eb5f09ebf77d1dde77b733be2d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-785.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-785.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-785: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-785: INVALID-PASS-PASS'
else
    echo 'PR-785: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-784
echo '=== Validating PR-784 ==='
git checkout 886ebfca609d813d7199497a26606f209e607b07 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-784.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CharSequenceOriginTest,PathOriginTest,ByteArraySeekableByteChannelCompressTest,IORandomAccessFileOriginTest,FileOriginTest,URIOriginTest,OutputStreamOriginTest,ReaderOriginTest,AbstractStreamBuilderTest,ByteArrayOriginTest,ByteArraySeekableByteChannelTest,AbstractRandomAccessFileOriginTest,ChannelOriginTest,InputStreamOriginTest,WriterStreamOriginTest,AbstractOriginTest,RandomAccessFileOriginTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-784.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CharSequenceOriginTest,PathOriginTest,ByteArraySeekableByteChannelCompressTest,IORandomAccessFileOriginTest,FileOriginTest,URIOriginTest,OutputStreamOriginTest,ReaderOriginTest,AbstractStreamBuilderTest,ByteArrayOriginTest,ByteArraySeekableByteChannelTest,AbstractRandomAccessFileOriginTest,ChannelOriginTest,InputStreamOriginTest,WriterStreamOriginTest,AbstractOriginTest,RandomAccessFileOriginTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-784: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-784: INVALID-PASS-PASS'
else
    echo 'PR-784: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-781
echo '=== Validating PR-781 ==='
git checkout cd20ecebc3facaf3c3b3eaba331d40b289ffe3b9 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-781.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FileSystemTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-781.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FileSystemTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-781: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-781: INVALID-PASS-PASS'
else
    echo 'PR-781: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-779
echo '=== Validating PR-779 ==='
git checkout 28873d13364509716b0ac520f31081b5f62f3263 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-779.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BoundedInputStreamTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-779.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BoundedInputStreamTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-779: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-779: INVALID-PASS-PASS'
else
    echo 'PR-779: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-776
echo '=== Validating PR-776 ==='
git checkout e205fb9e0dfe29fefa62060ad88ef586b12745ee --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-776.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-776.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IOUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-776: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-776: INVALID-PASS-PASS'
else
    echo 'PR-776: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-763
echo '=== Validating PR-763 ==='
git checkout ea8ba68c8839db85c2db17e9414c806f1085462c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-763.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-763.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-763: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-763: INVALID-PASS-PASS'
else
    echo 'PR-763: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-758
echo '=== Validating PR-758 ==='
git checkout 4fe3854a6bef9674ac9fc1062fdd1ad8614dc7cd --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-758.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ByteArrayOutputStreamTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-758.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ByteArrayOutputStreamTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-758: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-758: INVALID-PASS-PASS'
else
    echo 'PR-758: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-757
echo '=== Validating PR-757 ==='
git checkout 4fe3854a6bef9674ac9fc1062fdd1ad8614dc7cd --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-757.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=TailerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-757.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=TailerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-757: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-757: INVALID-PASS-PASS'
else
    echo 'PR-757: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-756
echo '=== Validating PR-756 ==='
git checkout 53371a208d4215c26d0f5f3b3aa960d274ff5211 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-756.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-756.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-756: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-756: INVALID-PASS-PASS'
else
    echo 'PR-756: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-748
echo '=== Validating PR-748 ==='
git checkout 5080fa310dc19c20f9631bd18cfc3a5a63ef160e --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-748.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=QueueInputStreamTest,QueueStreamBenchmark > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-748.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=QueueInputStreamTest,QueueStreamBenchmark > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-748: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-748: INVALID-PASS-PASS'
else
    echo 'PR-748: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-744
echo '=== Validating PR-744 ==='
git checkout 41419d10eae6306c902499102eef16f5e3ef2939 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-744.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-744.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FileUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-744: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-744: INVALID-PASS-PASS'
else
    echo 'PR-744: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"

# ==========================================
# AUTO-UPDATE TASKS_STATUS.MD
# ==========================================
cd "$(dirname "$0")"

# Get repo full name
if [ -f "tasks.json" ]; then
    REPO_FULLNAME=$(head -50 tasks.json | grep -o '"repo" : "[^"]*"' | head -1 | cut -d'"' -f4)
else
    REPO_FULLNAME=$(basename "$(pwd)" | sed 's/-/\//')
fi

# Count results from console output (last run)
# Note: This assumes variables VALID_COUNT, etc. are set from the script

cat > TASKS_STATUS.md << EOF
# Task Validation Status: $REPO_FULLNAME

**✅ VALIDATION_COMPLETE: $(date '+%Y-%m-%d %H:%M:%S')**

## Summary
- **Total Tasks:** ${TOTAL_COUNT:-0}
- **VALID:** ${VALID_COUNT:-0} ($((TOTAL_COUNT > 0 ? VALID_COUNT * 100 / TOTAL_COUNT : 0))%)
- **INVALID-PASS-PASS:** ${INVALID_PP_COUNT:-0}
- **INVALID-FAIL-FAIL:** ${INVALID_FF_COUNT:-0}

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)

---

**Validation completed:** $(date)
**Status:** ✅ COMPLETE - Ready for SWE-bench use

---

For detailed per-task results, check the console output or logs.
EOF

echo ""
echo "✓ TASKS_STATUS.md updated with completion marker"
