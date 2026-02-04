#!/bin/bash
# Validation Script for google/guava
# Generated: 2026-02-01T17:20:55.472822200

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning google/guava...'
    git clone https://github.com/google/guava.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

# PR-8188
echo '=== Validating PR-8188 ==='
git checkout 8138afbfa23c04106c045aa9087ad245794fc9a1 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8188.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=UninterruptiblesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8188.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=UninterruptiblesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8188: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8188: INVALID-PASS-PASS'
else
    echo 'PR-8188: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8187
echo '=== Validating PR-8187 ==='
git checkout 175bac9d8dcd8a37512c44b42e9a60ea85bbd0e5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8187.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=PreconditionsTest,MacHashFunctionTest,FluentIterableTest,MessageDigestHashFunctionTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8187.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=PreconditionsTest,MacHashFunctionTest,FluentIterableTest,MessageDigestHashFunctionTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8187: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8187: INVALID-PASS-PASS'
else
    echo 'PR-8187: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8184
echo '=== Validating PR-8184 ==='
git checkout a63e3601d139644e226bcbe9ad901bb3d835da4c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8184.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CacheLoadingTest,FuturesTest,JSR166TestCase,UninterruptiblesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8184.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CacheLoadingTest,FuturesTest,JSR166TestCase,UninterruptiblesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8184: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8184: INVALID-PASS-PASS'
else
    echo 'PR-8184: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8166
echo '=== Validating PR-8166 ==='
git checkout 0bf87046267ce281b6335430679fbd59135a1303 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8166.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OrderingTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8166.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OrderingTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8166: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8166: INVALID-PASS-PASS'
else
    echo 'PR-8166: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8155
echo '=== Validating PR-8155 ==='
git checkout 64d70b9f946bf10658d13946f7975f5b675b5556 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8155.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AbstractImmutableSortedMapMapInterfaceTest,AbstractImmutableBiMapMapInterfaceTest,AbstractImmutableMapMapInterfaceTest,SynchronizedSetTest,GraphsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8155.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AbstractImmutableSortedMapMapInterfaceTest,AbstractImmutableBiMapMapInterfaceTest,AbstractImmutableMapMapInterfaceTest,SynchronizedSetTest,GraphsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8155: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8155: INVALID-PASS-PASS'
else
    echo 'PR-8155: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8153
echo '=== Validating PR-8153 ==='
git checkout cf92c28d8c3a26218b409ed26dd38a28a9088e55 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8153.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ImmutableSortedMapTest,ContiguousSetTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8153.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ImmutableSortedMapTest,ContiguousSetTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8153: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8153: INVALID-PASS-PASS'
else
    echo 'PR-8153: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8150
echo '=== Validating PR-8150 ==='
git checkout 8df92320363fa0934d97167dc9312afbf61aa7f6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8150.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ContiguousSetTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8150.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ContiguousSetTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8150: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8150: INVALID-PASS-PASS'
else
    echo 'PR-8150: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8149
echo '=== Validating PR-8149 ==='
git checkout fb02c3434a7dd62760d0bb3ad2249cf381b56ad3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8149.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ListsTest,CharSequenceReaderTest,SpecialRandom > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8149.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ListsTest,CharSequenceReaderTest,SpecialRandom > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8149: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8149: INVALID-PASS-PASS'
else
    echo 'PR-8149: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8139
echo '=== Validating PR-8139 ==='
git checkout d8aef628854626455b2e6e46cc09d2c1275162e4 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8139.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DoubleUtilsTest,ThreadFactoryBuilderTest,NullPointerTesterTest,FauxveridesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8139.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DoubleUtilsTest,ThreadFactoryBuilderTest,NullPointerTesterTest,FauxveridesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8139: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8139: INVALID-PASS-PASS'
else
    echo 'PR-8139: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8134
echo '=== Validating PR-8134 ==='
git checkout 071ab9f04f868e45d34140eef92888ee3299d8ff --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8134.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=MoreExecutorsTest,AbstractClosingFutureTest,ImmutableEnumMapTest,RateLimiterTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8134.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=MoreExecutorsTest,AbstractClosingFutureTest,ImmutableEnumMapTest,RateLimiterTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8134: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8134: INVALID-PASS-PASS'
else
    echo 'PR-8134: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8128
echo '=== Validating PR-8128 ==='
git checkout 32ee2f60b126bebc91bb091ea4872d24d1acbf8a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8128.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ForwardingNavigableMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8128.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ForwardingNavigableMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8128: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8128: INVALID-PASS-PASS'
else
    echo 'PR-8128: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8125
echo '=== Validating PR-8125 ==='
git checkout 98107f9487596904fbc08fd06b5009d33dd1a387 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8125.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ImmutableDoubleArrayTest,ImmutableLongArrayTest,ImmutableIntArrayTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8125.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ImmutableDoubleArrayTest,ImmutableLongArrayTest,ImmutableIntArrayTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8125: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8125: INVALID-PASS-PASS'
else
    echo 'PR-8125: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8118
echo '=== Validating PR-8118 ==='
git checkout db23a833236c14da9c8de3edf82f5d7f7a19a5b7 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8118.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=UnsignedBytesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8118.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=UnsignedBytesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8118: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8118: INVALID-PASS-PASS'
else
    echo 'PR-8118: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8114
echo '=== Validating PR-8114 ==='
git checkout 0011c01aee70152979b01b28228622b1631f5bbf --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8114.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ConcurrentHashMultisetBasherTest,ConcurrentHashMultisetTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8114.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ConcurrentHashMultisetBasherTest,ConcurrentHashMultisetTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8114: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8114: INVALID-PASS-PASS'
else
    echo 'PR-8114: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8091
echo '=== Validating PR-8091 ==='
git checkout a6110d39346c02118809a5f46b353362384fc0a3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8091.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ImmutableListMultimapTest,CollectSpliteratorsTest,ImmutableEnumMapTest,ImmutableMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8091.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ImmutableListMultimapTest,CollectSpliteratorsTest,ImmutableEnumMapTest,ImmutableMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8091: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8091: INVALID-PASS-PASS'
else
    echo 'PR-8091: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8081
echo '=== Validating PR-8081 ==='
git checkout 12878d70b4c8eff8468681255e7208688ab201e3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8081.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=InternetDomainNameTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8081.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=InternetDomainNameTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8081: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8081: INVALID-PASS-PASS'
else
    echo 'PR-8081: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8080
echo '=== Validating PR-8080 ==='
git checkout 8cfa76f66ffe6ed77c1142da31dca2dc8454040c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8080.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=QueuesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8080.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=QueuesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8080: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8080: INVALID-PASS-PASS'
else
    echo 'PR-8080: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8067
echo '=== Validating PR-8067 ==='
git checkout fb862e573deb5263dd81ed0ef1f07a5ea65e31d6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8067.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FileBackedOutputStreamTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8067.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FileBackedOutputStreamTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8067: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8067: INVALID-PASS-PASS'
else
    echo 'PR-8067: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8052
echo '=== Validating PR-8052 ==='
git checkout 83869af96382246da6ff99cb029ef59ba684f592 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8052.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OrderingTest,LinkedHashMultimapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8052.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OrderingTest,LinkedHashMultimapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8052: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8052: INVALID-PASS-PASS'
else
    echo 'PR-8052: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-8045
echo '=== Validating PR-8045 ==='
git checkout b53231b06e83e23ed1f0a84ad5becd5cf6d120a0 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8045.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AbstractGraphTest,ValueGraphTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8045.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AbstractGraphTest,ValueGraphTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8045: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8045: INVALID-PASS-PASS'
else
    echo 'PR-8045: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"
