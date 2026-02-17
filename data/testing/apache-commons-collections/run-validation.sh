#!/bin/bash
# Validation Script for apache/commons-collections
# Generated: 2026-02-01T17:20:55.381299500

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning apache/commons-collections...'
    git clone https://github.com/apache/commons-collections.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-665
echo '=== Validating PR-665 ==='
git checkout a60ee0c714939816cbb44833b11ea263a1defa23 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-665.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest,ArrayListValuedHashMapTest,TransformedMultiValuedMapTest,MultiMapUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-665.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest,ArrayListValuedHashMapTest,TransformedMultiValuedMapTest,MultiMapUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-665: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 665 | a60ee0c... | ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinke... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-665: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 665 | a60ee0c... | ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinke... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-665: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 665 | a60ee0c... | ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinke... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-633
echo '=== Validating PR-633 ==='
git checkout d8c59cdbc79d41b1309720d745a39735b334ae86 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-633.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=SetUtilsTest,IteratorChainTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-633.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=SetUtilsTest,IteratorChainTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-633: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 633 | d8c59cd... | SetUtilsTest,IteratorChainTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-633: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 633 | d8c59cd... | SetUtilsTest,IteratorChainTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-633: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 633 | d8c59cd... | SetUtilsTest,IteratorChainTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-628
echo '=== Validating PR-628 ==='
git checkout ec38f6fa7f867000eed81791c3078b327a451d89 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-628.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IteratorChainTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-628.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IteratorChainTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-628: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 628 | ec38f6f... | IteratorChainTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-628: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 628 | ec38f6f... | IteratorChainTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-628: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 628 | ec38f6f... | IteratorChainTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-565
echo '=== Validating PR-565 ==='
git checkout 96763c2612a022266f102f4daca055370e22a47d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-565.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-565.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-565: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 565 | 96763c2... | LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMap... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-565: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 565 | 96763c2... | LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMap... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-565: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 565 | 96763c2... | LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMap... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-564
echo '=== Validating PR-564 ==='
git checkout 63d30d55bfbc7203621c0443086a59b874611c0b --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-564.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ExtendedIteratorTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-564.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ExtendedIteratorTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-564: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 564 | 63d30d5... | ExtendedIteratorTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-564: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 564 | 63d30d5... | ExtendedIteratorTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-564: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 564 | 63d30d5... | ExtendedIteratorTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-560
echo '=== Validating PR-560 ==='
git checkout 45603c08d9c4561b34990440b2ca5631d5d90ec3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-560.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-560.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-560: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 560 | 45603c0... | ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-560: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 560 | 45603c0... | ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-560: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 560 | 45603c0... | ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-501
echo '=== Validating PR-501 ==='
git checkout f59075822be96094129521ff831271b23ae67b64 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-501.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=EnhancedDoubleHasherTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-501.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=EnhancedDoubleHasherTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-501: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 501 | f590758... | EnhancedDoubleHasherTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-501: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 501 | f590758... | EnhancedDoubleHasherTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-501: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 501 | f590758... | EnhancedDoubleHasherTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-492
echo '=== Validating PR-492 ==='
git checkout 94c4c7c6678e8540e277166c65759b6d16a514cc --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-492.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CountingPredicateTest,AbstractHasherTest,BitMapExtractorFromWrappedBloomFilterTest,BloomFilterExtractorFromBloomFilterArrayTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,DefaultIndexProducerTest,IndexExtractorFromUniqueHasherTest,BitMapProducerFromSimpleBloomFilterTest,CellExtractorFromArrayCountingBloomFilterTest,IndexExtractorFromBitmapExtractorTest,IndexExtractorFromHasherTest,CellProducerFromLayeredBloomFilterTest,CellExtractorFromDefaultIndexExtractorTest,AbstractCellExtractorTest,IndexExtractorFromSparseBloomFilterTest,ArrayHasher,BloomFilteExtractorFromLayeredBloomFilterTest,CellExtractorFromLayeredBloomFilterTest,IndexExtractorFromIntArrayTest,DefaultCellExtractorTest,AbstractBloomFilterExtractorTest,BitMapProducerFromLongArrayTest,BloomFilterProducerFromLayeredBloomFilterTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,BitMapExtractorFromLayeredBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,BitMapExtractorFromLongArrayTest,BitMapExtractorFromArrayCountingBloomFilterTest,AbstractBitMapExtractorTest,DefaultBitMapExtractorTest,AbstractCellProducerTest,IncrementingHasher,LayeredBloomFilterTest,AbstractBloomFilterTest,BitMapProducerFromSparseBloomFilterTest,BitMapExtractorFromSparseBloomFilterTest,IndexExtractorFromArrayCountingBloomFilterTest,LayerManagerTest,DefaultBloomFilterExtractorTest,BitMapTest,IndexProducerFromBitmapProducerTest,IndexProducerFromSimpleBloomFilterTest,BitMapExtractorFromSimpleBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapExtractorFromIndexExtractorTest,DefaultBloomFilterProducerTest,AbstractIndexExtractorTest,DefaultIndexExtractorTest,BitMapProducerFromIndexProducerTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,TestingHashers,AbstractBitMapProducerTest,DefaultBitMapProducerTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,IndexProducerFromIntArrayTest,IndexProducerTest,NullHasher,SparseBloomFilterTest,IndexExtractorFromSimpleBloomFilterTest,SetOperationsTest,IndexExtractorTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,CellProducerFromArrayCountingBloomFilterTest,SimpleBloomFilterTest,BitMapsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-492.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CountingPredicateTest,AbstractHasherTest,BitMapExtractorFromWrappedBloomFilterTest,BloomFilterExtractorFromBloomFilterArrayTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,DefaultIndexProducerTest,IndexExtractorFromUniqueHasherTest,BitMapProducerFromSimpleBloomFilterTest,CellExtractorFromArrayCountingBloomFilterTest,IndexExtractorFromBitmapExtractorTest,IndexExtractorFromHasherTest,CellProducerFromLayeredBloomFilterTest,CellExtractorFromDefaultIndexExtractorTest,AbstractCellExtractorTest,IndexExtractorFromSparseBloomFilterTest,ArrayHasher,BloomFilteExtractorFromLayeredBloomFilterTest,CellExtractorFromLayeredBloomFilterTest,IndexExtractorFromIntArrayTest,DefaultCellExtractorTest,AbstractBloomFilterExtractorTest,BitMapProducerFromLongArrayTest,BloomFilterProducerFromLayeredBloomFilterTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,BitMapExtractorFromLayeredBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,BitMapExtractorFromLongArrayTest,BitMapExtractorFromArrayCountingBloomFilterTest,AbstractBitMapExtractorTest,DefaultBitMapExtractorTest,AbstractCellProducerTest,IncrementingHasher,LayeredBloomFilterTest,AbstractBloomFilterTest,BitMapProducerFromSparseBloomFilterTest,BitMapExtractorFromSparseBloomFilterTest,IndexExtractorFromArrayCountingBloomFilterTest,LayerManagerTest,DefaultBloomFilterExtractorTest,BitMapTest,IndexProducerFromBitmapProducerTest,IndexProducerFromSimpleBloomFilterTest,BitMapExtractorFromSimpleBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapExtractorFromIndexExtractorTest,DefaultBloomFilterProducerTest,AbstractIndexExtractorTest,DefaultIndexExtractorTest,BitMapProducerFromIndexProducerTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,TestingHashers,AbstractBitMapProducerTest,DefaultBitMapProducerTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,IndexProducerFromIntArrayTest,IndexProducerTest,NullHasher,SparseBloomFilterTest,IndexExtractorFromSimpleBloomFilterTest,SetOperationsTest,IndexExtractorTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,CellProducerFromArrayCountingBloomFilterTest,SimpleBloomFilterTest,BitMapsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-492: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 492 | 94c4c7c... | CountingPredicateTest,AbstractHasherTest,BitMapExtractorF... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-492: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 492 | 94c4c7c... | CountingPredicateTest,AbstractHasherTest,BitMapExtractorF... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-492: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 492 | 94c4c7c... | CountingPredicateTest,AbstractHasherTest,BitMapExtractorF... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-485
echo '=== Validating PR-485 ==='
git checkout 1dc530e6fa2e0c87e9bf1f377834312169a5fc3f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-485.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DefaultAbstractLinkedListForJava21Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-485.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DefaultAbstractLinkedListForJava21Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-485: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 485 | 1dc530e... | DefaultAbstractLinkedListForJava21Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-485: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 485 | 1dc530e... | DefaultAbstractLinkedListForJava21Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-485: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 485 | 1dc530e... | DefaultAbstractLinkedListForJava21Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-481
echo '=== Validating PR-481 ==='
git checkout 4d40c035ab25cf97cf2604688c5c72f706292a29 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-481.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapProducerFromLayeredBloomFilterTest,LayerManagerTest,CellProducerFromLayeredBloomFilterTest,WrappedBloomFilterTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-481.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapProducerFromLayeredBloomFilterTest,LayerManagerTest,CellProducerFromLayeredBloomFilterTest,WrappedBloomFilterTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-481: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 481 | 4d40c03... | LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilt... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-481: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 481 | 4d40c03... | LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilt... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-481: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 481 | 4d40c03... | LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilt... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-476
echo '=== Validating PR-476 ==='
git checkout de7c51e3093fad1a56318f7612952b9c2d1fa3f2 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-476.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=LayeredBloomFilterTest,LayerManagerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-476.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=LayeredBloomFilterTest,LayerManagerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-476: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 476 | de7c51e... | LayeredBloomFilterTest,LayerManagerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-476: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 476 | de7c51e... | LayeredBloomFilterTest,LayerManagerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-476: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 476 | de7c51e... | LayeredBloomFilterTest,LayerManagerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-406
echo '=== Validating PR-406 ==='
git checkout 14215e5bdd1aeea699da63ff2b2a6b7d2c663bef --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-406.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,DefaultIndexProducerTest,BitCountProducerFromSimpleBloomFilterTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,ArrayHasher,IndexProducerFromSparseBloomFilterTest,DefaultBitCountProducerTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,IndexProducerFromIntArrayTest,AbstractCellProducerTest,AbstractBitCountProducerTest,IndexProducerTest,BitCountProducerFromDefaultIndexProducerTest,NullHasher,AbstractBloomFilterTest,BitCountProducerFromHasherTest,CellProducerFromArrayCountingBloomFilterTest,BitCountProducerFromIntArrayTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-406.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,DefaultIndexProducerTest,BitCountProducerFromSimpleBloomFilterTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,ArrayHasher,IndexProducerFromSparseBloomFilterTest,DefaultBitCountProducerTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,IndexProducerFromIntArrayTest,AbstractCellProducerTest,AbstractBitCountProducerTest,IndexProducerTest,BitCountProducerFromDefaultIndexProducerTest,NullHasher,AbstractBloomFilterTest,BitCountProducerFromHasherTest,CellProducerFromArrayCountingBloomFilterTest,BitCountProducerFromIntArrayTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-406: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 406 | 14215e5... | BitCountProducerFromArrayCountingBloomFilterTest,CellProd... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-406: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 406 | 14215e5... | BitCountProducerFromArrayCountingBloomFilterTest,CellProd... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-406: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 406 | 14215e5... | BitCountProducerFromArrayCountingBloomFilterTest,CellProd... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-402
echo '=== Validating PR-402 ==='
git checkout 1df5606b821047e9cda52b728027d7ddb8e6fb4c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-402.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CountingPredicateTest,BloomFilterProducerFromLayeredBloomFilterTest,AbstractIndexProducerTest,BitMapProducerFromWrappedBloomFilterTest,CellProducerFromLayeredBloomFilterTest,DefaultBloomFilterProducerTest,LayeredBloomFilterTest,AbstractBloomFilterTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,TestingHashers,DefaultBloomFilterTest,LayerManagerTest,WrappedBloomFilterTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-402.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CountingPredicateTest,BloomFilterProducerFromLayeredBloomFilterTest,AbstractIndexProducerTest,BitMapProducerFromWrappedBloomFilterTest,CellProducerFromLayeredBloomFilterTest,DefaultBloomFilterProducerTest,LayeredBloomFilterTest,AbstractBloomFilterTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,TestingHashers,DefaultBloomFilterTest,LayerManagerTest,WrappedBloomFilterTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-402: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 402 | 1df5606... | CountingPredicateTest,BloomFilterProducerFromLayeredBloom... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-402: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 402 | 1df5606... | CountingPredicateTest,BloomFilterProducerFromLayeredBloom... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-402: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 402 | 1df5606... | CountingPredicateTest,BloomFilterProducerFromLayeredBloom... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-398
echo '=== Validating PR-398 ==='
git checkout 5b668d23c6a980290f35a848fcac05191bc23488 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-398.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=IncrementingHasher,AbstractBloomFilterTest,DefaultIndexProducerTest,ArrayHasher,TestingHashers > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-398.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=IncrementingHasher,AbstractBloomFilterTest,DefaultIndexProducerTest,ArrayHasher,TestingHashers > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-398: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 398 | 5b668d2... | IncrementingHasher,AbstractBloomFilterTest,DefaultIndexPr... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-398: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 398 | 5b668d2... | IncrementingHasher,AbstractBloomFilterTest,DefaultIndexPr... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-398: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 398 | 5b668d2... | IncrementingHasher,AbstractBloomFilterTest,DefaultIndexPr... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-396
echo '=== Validating PR-396 ==='
git checkout 1d07ca40667849742d8712bf55770c559cd6203d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-396.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-396.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-396: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 396 | 1d07ca4... | BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-396: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 396 | 1d07ca4... | BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-396: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 396 | 1d07ca4... | BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-361
echo '=== Validating PR-361 ==='
git checkout 69cad46a9249d7f0308547e2a0bfd5c959872feb --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-361.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BitCountProducerFromHasherCollectionTest,SparseBloomFilterTest,HasherCollectionTest,SetOperationsTest,AbstractBloomFilterTest,AbstractCountingBloomFilterTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,TestingHashers,BitCountProducerFromUniqueHasherCollectionTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-361.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BitCountProducerFromHasherCollectionTest,SparseBloomFilterTest,HasherCollectionTest,SetOperationsTest,AbstractBloomFilterTest,AbstractCountingBloomFilterTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,TestingHashers,BitCountProducerFromUniqueHasherCollectionTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-361: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 361 | 69cad46... | BitCountProducerFromHasherCollectionTest,SparseBloomFilte... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-361: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 361 | 69cad46... | BitCountProducerFromHasherCollectionTest,SparseBloomFilte... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-361: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 361 | 69cad46... | BitCountProducerFromHasherCollectionTest,SparseBloomFilte... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-335
echo '=== Validating PR-335 ==='
git checkout dca05e593e4fe6c5546f37994f818ab8a15d1380 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-335.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,IndexProducerFromBitmapProducerTest,DefaultIndexProducerTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,BitCountProducerFromSimpleBloomFilterTest,IndexProducerFromHasherTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,DefaultBitCountProducerTest,IndexProducerFromHasherCollectionTest,IndexProducerFromArrayCountingBloomFilterTest,HasherCollectionTest,UniqueIndexProducerFromHasherCollectionTest,IndexProducerFromIntArrayTest,AbstractBitCountProducerTest,BitCountProducerFromUniqueHasherCollectionTest,EnhancedDoubleHasherTest,BitCountProducerFromDefaultIndexProducerTest,BitCountProducerFromHasherCollectionTest,BitCountProducerFromHasherTest,BitCountProducerFromIndexProducerTest,BitCountProducerFromIntArrayTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-335.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,IndexProducerFromBitmapProducerTest,DefaultIndexProducerTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,BitCountProducerFromSimpleBloomFilterTest,IndexProducerFromHasherTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,DefaultBitCountProducerTest,IndexProducerFromHasherCollectionTest,IndexProducerFromArrayCountingBloomFilterTest,HasherCollectionTest,UniqueIndexProducerFromHasherCollectionTest,IndexProducerFromIntArrayTest,AbstractBitCountProducerTest,BitCountProducerFromUniqueHasherCollectionTest,EnhancedDoubleHasherTest,BitCountProducerFromDefaultIndexProducerTest,BitCountProducerFromHasherCollectionTest,BitCountProducerFromHasherTest,BitCountProducerFromIndexProducerTest,BitCountProducerFromIntArrayTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-335: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 335 | dca05e5... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-335: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 335 | dca05e5... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-335: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 335 | dca05e5... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-329
echo '=== Validating PR-329 ==='
git checkout df091173cdfabd5ecc852f47c978ee9bcb2b7059 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-329.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DefaultBloomFilterTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-329.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DefaultBloomFilterTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-329: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 329 | df09117... | DefaultBloomFilterTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-329: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 329 | df09117... | DefaultBloomFilterTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-329: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 329 | df09117... | DefaultBloomFilterTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-323
echo '=== Validating PR-323 ==='
git checkout 304a1bf3f37abb1740e5a1a378b69aa8bd70acfe --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-323.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FilterIteratorTest,MultiValueMapTest,TreeListTest,AbstractSortedSetTest,SingletonMapTest,AbstractSortedBagTest,ReverseComparatorTest,CursorableLinkedListTest,AbstractNavigableSetTest,PredicatedBagTest,ListIteratorWrapper2Test,ListIteratorWrapperTest,AbstractCollectionTest,ComparatorChainTest,AbstractListTest,AbstractMapTest,ListUtilsTest,BulkTest,AbstractObjectTest,SplitMapUtilsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-323.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FilterIteratorTest,MultiValueMapTest,TreeListTest,AbstractSortedSetTest,SingletonMapTest,AbstractSortedBagTest,ReverseComparatorTest,CursorableLinkedListTest,AbstractNavigableSetTest,PredicatedBagTest,ListIteratorWrapper2Test,ListIteratorWrapperTest,AbstractCollectionTest,ComparatorChainTest,AbstractListTest,AbstractMapTest,ListUtilsTest,BulkTest,AbstractObjectTest,SplitMapUtilsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-323: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 323 | 304a1bf... | FilterIteratorTest,MultiValueMapTest,TreeListTest,Abstrac... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-323: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 323 | 304a1bf... | FilterIteratorTest,MultiValueMapTest,TreeListTest,Abstrac... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-323: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 323 | 304a1bf... | FilterIteratorTest,MultiValueMapTest,TreeListTest,Abstrac... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-320
echo '=== Validating PR-320 ==='
git checkout a43e0245ba6f3f39f51aaac41df4a4e547f4372f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-320.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,IndexProducerFromArrayCountingBloomFilterTest,IndexProducerFromHasherCollectionTest,HasherCollectionTest,IndexProducerFromSimpleBloomFilterTest,AbstractCountingBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,UniqueIndexProducerFromHasherCollectionTest,BitMapProducerFromSimpleBloomFilterTest,EnhancedDoubleHasherTest,IncrementingHasher,SetOperationsTest,AbstractBloomFilterTest,IndexProducerFromHasherTest,BitMapProducerFromSparseBloomFilterTest,SimpleHasherTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-320.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,IndexProducerFromArrayCountingBloomFilterTest,IndexProducerFromHasherCollectionTest,HasherCollectionTest,IndexProducerFromSimpleBloomFilterTest,AbstractCountingBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,UniqueIndexProducerFromHasherCollectionTest,BitMapProducerFromSimpleBloomFilterTest,EnhancedDoubleHasherTest,IncrementingHasher,SetOperationsTest,AbstractBloomFilterTest,IndexProducerFromHasherTest,BitMapProducerFromSparseBloomFilterTest,SimpleHasherTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-320: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 320 | a43e024... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-320: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 320 | a43e024... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-320: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 320 | a43e024... | BitCountProducerFromArrayCountingBloomFilterTest,Abstract... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
