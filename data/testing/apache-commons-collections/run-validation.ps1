# Validation Script for apache/commons-collections
# Generated: 2026-02-01T17:20:55.379300200

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning apache/commons-collections...'
    git clone https://github.com/apache/commons-collections.git repo
}

cd repo

$results = @()

# PR-665
Write-Host '=== Validating PR-665 ===' -ForegroundColor Cyan
git checkout a60ee0c714939816cbb44833b11ea263a1defa23 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-665.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest,ArrayListValuedHashMapTest,TransformedMultiValuedMapTest,MultiMapUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-665.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayListValuedLinkedHashMapTest,LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest,ArrayListValuedHashMapTest,TransformedMultiValuedMapTest,MultiMapUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-665: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=665; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-633
Write-Host '=== Validating PR-633 ===' -ForegroundColor Cyan
git checkout d8c59cdbc79d41b1309720d745a39735b334ae86 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-633.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=SetUtilsTest,IteratorChainTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-633.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=SetUtilsTest,IteratorChainTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-633: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=633; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-628
Write-Host '=== Validating PR-628 ===' -ForegroundColor Cyan
git checkout ec38f6fa7f867000eed81791c3078b327a451d89 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-628.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IteratorChainTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-628.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IteratorChainTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-628: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=628; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-565
Write-Host '=== Validating PR-565 ===' -ForegroundColor Cyan
git checkout 96763c2612a022266f102f4daca055370e22a47d --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-565.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-565.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=LinkedHashSetValuedLinkedHashMapTest,HashSetValuedHashMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-565: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=565; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-564
Write-Host '=== Validating PR-564 ===' -ForegroundColor Cyan
git checkout 63d30d55bfbc7203621c0443086a59b874611c0b --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-564.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ExtendedIteratorTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-564.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ExtendedIteratorTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-564: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=564; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-560
Write-Host '=== Validating PR-560 ===' -ForegroundColor Cyan
git checkout 45603c08d9c4561b34990440b2ca5631d5d90ec3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-560.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-560.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayListValuedLinkedHashMapTest,ArrayListValuedHashMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-560: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=560; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-501
Write-Host '=== Validating PR-501 ===' -ForegroundColor Cyan
git checkout f59075822be96094129521ff831271b23ae67b64 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-501.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=EnhancedDoubleHasherTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-501.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=EnhancedDoubleHasherTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-501: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=501; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-492
Write-Host '=== Validating PR-492 ===' -ForegroundColor Cyan
git checkout 94c4c7c6678e8540e277166c65759b6d16a514cc --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-492.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CountingPredicateTest,AbstractHasherTest,BitMapExtractorFromWrappedBloomFilterTest,BloomFilterExtractorFromBloomFilterArrayTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,DefaultIndexProducerTest,IndexExtractorFromUniqueHasherTest,BitMapProducerFromSimpleBloomFilterTest,CellExtractorFromArrayCountingBloomFilterTest,IndexExtractorFromBitmapExtractorTest,IndexExtractorFromHasherTest,CellProducerFromLayeredBloomFilterTest,CellExtractorFromDefaultIndexExtractorTest,AbstractCellExtractorTest,IndexExtractorFromSparseBloomFilterTest,ArrayHasher,BloomFilteExtractorFromLayeredBloomFilterTest,CellExtractorFromLayeredBloomFilterTest,IndexExtractorFromIntArrayTest,DefaultCellExtractorTest,AbstractBloomFilterExtractorTest,BitMapProducerFromLongArrayTest,BloomFilterProducerFromLayeredBloomFilterTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,BitMapExtractorFromLayeredBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,BitMapExtractorFromLongArrayTest,BitMapExtractorFromArrayCountingBloomFilterTest,AbstractBitMapExtractorTest,DefaultBitMapExtractorTest,AbstractCellProducerTest,IncrementingHasher,LayeredBloomFilterTest,AbstractBloomFilterTest,BitMapProducerFromSparseBloomFilterTest,BitMapExtractorFromSparseBloomFilterTest,IndexExtractorFromArrayCountingBloomFilterTest,LayerManagerTest,DefaultBloomFilterExtractorTest,BitMapTest,IndexProducerFromBitmapProducerTest,IndexProducerFromSimpleBloomFilterTest,BitMapExtractorFromSimpleBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapExtractorFromIndexExtractorTest,DefaultBloomFilterProducerTest,AbstractIndexExtractorTest,DefaultIndexExtractorTest,BitMapProducerFromIndexProducerTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,TestingHashers,AbstractBitMapProducerTest,DefaultBitMapProducerTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,IndexProducerFromIntArrayTest,IndexProducerTest,NullHasher,SparseBloomFilterTest,IndexExtractorFromSimpleBloomFilterTest,SetOperationsTest,IndexExtractorTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,CellProducerFromArrayCountingBloomFilterTest,SimpleBloomFilterTest,BitMapsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-492.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CountingPredicateTest,AbstractHasherTest,BitMapExtractorFromWrappedBloomFilterTest,BloomFilterExtractorFromBloomFilterArrayTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,DefaultIndexProducerTest,IndexExtractorFromUniqueHasherTest,BitMapProducerFromSimpleBloomFilterTest,CellExtractorFromArrayCountingBloomFilterTest,IndexExtractorFromBitmapExtractorTest,IndexExtractorFromHasherTest,CellProducerFromLayeredBloomFilterTest,CellExtractorFromDefaultIndexExtractorTest,AbstractCellExtractorTest,IndexExtractorFromSparseBloomFilterTest,ArrayHasher,BloomFilteExtractorFromLayeredBloomFilterTest,CellExtractorFromLayeredBloomFilterTest,IndexExtractorFromIntArrayTest,DefaultCellExtractorTest,AbstractBloomFilterExtractorTest,BitMapProducerFromLongArrayTest,BloomFilterProducerFromLayeredBloomFilterTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,BitMapExtractorFromLayeredBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,BitMapExtractorFromLongArrayTest,BitMapExtractorFromArrayCountingBloomFilterTest,AbstractBitMapExtractorTest,DefaultBitMapExtractorTest,AbstractCellProducerTest,IncrementingHasher,LayeredBloomFilterTest,AbstractBloomFilterTest,BitMapProducerFromSparseBloomFilterTest,BitMapExtractorFromSparseBloomFilterTest,IndexExtractorFromArrayCountingBloomFilterTest,LayerManagerTest,DefaultBloomFilterExtractorTest,BitMapTest,IndexProducerFromBitmapProducerTest,IndexProducerFromSimpleBloomFilterTest,BitMapExtractorFromSimpleBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapExtractorFromIndexExtractorTest,DefaultBloomFilterProducerTest,AbstractIndexExtractorTest,DefaultIndexExtractorTest,BitMapProducerFromIndexProducerTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,TestingHashers,AbstractBitMapProducerTest,DefaultBitMapProducerTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,IndexProducerFromIntArrayTest,IndexProducerTest,NullHasher,SparseBloomFilterTest,IndexExtractorFromSimpleBloomFilterTest,SetOperationsTest,IndexExtractorTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,CellProducerFromArrayCountingBloomFilterTest,SimpleBloomFilterTest,BitMapsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-492: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=492; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-485
Write-Host '=== Validating PR-485 ===' -ForegroundColor Cyan
git checkout 1dc530e6fa2e0c87e9bf1f377834312169a5fc3f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-485.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DefaultAbstractLinkedListForJava21Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-485.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DefaultAbstractLinkedListForJava21Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-485: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=485; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-481
Write-Host '=== Validating PR-481 ===' -ForegroundColor Cyan
git checkout 4d40c035ab25cf97cf2604688c5c72f706292a29 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-481.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapProducerFromLayeredBloomFilterTest,LayerManagerTest,CellProducerFromLayeredBloomFilterTest,WrappedBloomFilterTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-481.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=LayeredBloomFilterTest,BitMapProducerFromWrappedBloomFilterTest,BitMapProducerFromLayeredBloomFilterTest,LayerManagerTest,CellProducerFromLayeredBloomFilterTest,WrappedBloomFilterTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-481: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=481; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-476
Write-Host '=== Validating PR-476 ===' -ForegroundColor Cyan
git checkout de7c51e3093fad1a56318f7612952b9c2d1fa3f2 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-476.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=LayeredBloomFilterTest,LayerManagerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-476.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=LayeredBloomFilterTest,LayerManagerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-476: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=476; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-406
Write-Host '=== Validating PR-406 ===' -ForegroundColor Cyan
git checkout 14215e5bdd1aeea699da63ff2b2a6b7d2c663bef --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-406.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,DefaultIndexProducerTest,BitCountProducerFromSimpleBloomFilterTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,ArrayHasher,IndexProducerFromSparseBloomFilterTest,DefaultBitCountProducerTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,IndexProducerFromIntArrayTest,AbstractCellProducerTest,AbstractBitCountProducerTest,IndexProducerTest,BitCountProducerFromDefaultIndexProducerTest,NullHasher,AbstractBloomFilterTest,BitCountProducerFromHasherTest,CellProducerFromArrayCountingBloomFilterTest,BitCountProducerFromIntArrayTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-406.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,CellProducerFromDefaultIndexProducerTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,DefaultIndexProducerTest,BitCountProducerFromSimpleBloomFilterTest,DefaultCellProducerTest,IndexProducerFromHasherTest,IndexProducerFromUniqueHasherTest,ArrayHasher,IndexProducerFromSparseBloomFilterTest,DefaultBitCountProducerTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,IndexProducerFromArrayCountingBloomFilterTest,AbstractCountingBloomFilterTest,IndexProducerFromIntArrayTest,AbstractCellProducerTest,AbstractBitCountProducerTest,IndexProducerTest,BitCountProducerFromDefaultIndexProducerTest,NullHasher,AbstractBloomFilterTest,BitCountProducerFromHasherTest,CellProducerFromArrayCountingBloomFilterTest,BitCountProducerFromIntArrayTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-406: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=406; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-402
Write-Host '=== Validating PR-402 ===' -ForegroundColor Cyan
git checkout 1df5606b821047e9cda52b728027d7ddb8e6fb4c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-402.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CountingPredicateTest,BloomFilterProducerFromLayeredBloomFilterTest,AbstractIndexProducerTest,BitMapProducerFromWrappedBloomFilterTest,CellProducerFromLayeredBloomFilterTest,DefaultBloomFilterProducerTest,LayeredBloomFilterTest,AbstractBloomFilterTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,TestingHashers,DefaultBloomFilterTest,LayerManagerTest,WrappedBloomFilterTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-402.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CountingPredicateTest,BloomFilterProducerFromLayeredBloomFilterTest,AbstractIndexProducerTest,BitMapProducerFromWrappedBloomFilterTest,CellProducerFromLayeredBloomFilterTest,DefaultBloomFilterProducerTest,LayeredBloomFilterTest,AbstractBloomFilterTest,BloomFilterProducerFromBloomFilterArrayTest,AbstractBloomFilterProducerTest,BitMapProducerFromLayeredBloomFilterTest,TestingHashers,DefaultBloomFilterTest,LayerManagerTest,WrappedBloomFilterTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-402: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=402; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-398
Write-Host '=== Validating PR-398 ===' -ForegroundColor Cyan
git checkout 5b668d23c6a980290f35a848fcac05191bc23488 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-398.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IncrementingHasher,AbstractBloomFilterTest,DefaultIndexProducerTest,ArrayHasher,TestingHashers" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-398.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IncrementingHasher,AbstractBloomFilterTest,DefaultIndexProducerTest,ArrayHasher,TestingHashers" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-398: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=398; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-396
Write-Host '=== Validating PR-396 ===' -ForegroundColor Cyan
git checkout 1d07ca40667849742d8712bf55770c559cd6203d --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-396.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-396.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitMapTest,IncrementingHasher,EnhancedDoubleHasherTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-396: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=396; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-361
Write-Host '=== Validating PR-361 ===' -ForegroundColor Cyan
git checkout 69cad46a9249d7f0308547e2a0bfd5c959872feb --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-361.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitCountProducerFromHasherCollectionTest,SparseBloomFilterTest,HasherCollectionTest,SetOperationsTest,AbstractBloomFilterTest,AbstractCountingBloomFilterTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,TestingHashers,BitCountProducerFromUniqueHasherCollectionTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-361.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitCountProducerFromHasherCollectionTest,SparseBloomFilterTest,HasherCollectionTest,SetOperationsTest,AbstractBloomFilterTest,AbstractCountingBloomFilterTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,TestingHashers,BitCountProducerFromUniqueHasherCollectionTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-361: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=361; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-335
Write-Host '=== Validating PR-335 ===' -ForegroundColor Cyan
git checkout dca05e593e4fe6c5546f37994f818ab8a15d1380 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-335.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,IndexProducerFromBitmapProducerTest,DefaultIndexProducerTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,BitCountProducerFromSimpleBloomFilterTest,IndexProducerFromHasherTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,DefaultBitCountProducerTest,IndexProducerFromHasherCollectionTest,IndexProducerFromArrayCountingBloomFilterTest,HasherCollectionTest,UniqueIndexProducerFromHasherCollectionTest,IndexProducerFromIntArrayTest,AbstractBitCountProducerTest,BitCountProducerFromUniqueHasherCollectionTest,EnhancedDoubleHasherTest,BitCountProducerFromDefaultIndexProducerTest,BitCountProducerFromHasherCollectionTest,BitCountProducerFromHasherTest,BitCountProducerFromIndexProducerTest,BitCountProducerFromIntArrayTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-335.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,AbstractIndexProducerTest,IndexProducerFromSimpleBloomFilterTest,IndexProducerFromBitmapProducerTest,DefaultIndexProducerTest,BitCountProducerFromAbsoluteUniqueHasherCollectionTest,BitCountProducerFromSimpleBloomFilterTest,IndexProducerFromHasherTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest,BitCountProducerFromSparseBloomFilterTest,BitCountProducerFromUniqueHasherTest,DefaultBitCountProducerTest,IndexProducerFromHasherCollectionTest,IndexProducerFromArrayCountingBloomFilterTest,HasherCollectionTest,UniqueIndexProducerFromHasherCollectionTest,IndexProducerFromIntArrayTest,AbstractBitCountProducerTest,BitCountProducerFromUniqueHasherCollectionTest,EnhancedDoubleHasherTest,BitCountProducerFromDefaultIndexProducerTest,BitCountProducerFromHasherCollectionTest,BitCountProducerFromHasherTest,BitCountProducerFromIndexProducerTest,BitCountProducerFromIntArrayTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-335: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=335; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-329
Write-Host '=== Validating PR-329 ===' -ForegroundColor Cyan
git checkout df091173cdfabd5ecc852f47c978ee9bcb2b7059 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-329.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DefaultBloomFilterTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-329.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DefaultBloomFilterTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-329: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=329; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-323
Write-Host '=== Validating PR-323 ===' -ForegroundColor Cyan
git checkout 304a1bf3f37abb1740e5a1a378b69aa8bd70acfe --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-323.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FilterIteratorTest,MultiValueMapTest,TreeListTest,AbstractSortedSetTest,SingletonMapTest,AbstractSortedBagTest,ReverseComparatorTest,CursorableLinkedListTest,AbstractNavigableSetTest,PredicatedBagTest,ListIteratorWrapper2Test,ListIteratorWrapperTest,AbstractCollectionTest,ComparatorChainTest,AbstractListTest,AbstractMapTest,ListUtilsTest,BulkTest,AbstractObjectTest,SplitMapUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-323.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FilterIteratorTest,MultiValueMapTest,TreeListTest,AbstractSortedSetTest,SingletonMapTest,AbstractSortedBagTest,ReverseComparatorTest,CursorableLinkedListTest,AbstractNavigableSetTest,PredicatedBagTest,ListIteratorWrapper2Test,ListIteratorWrapperTest,AbstractCollectionTest,ComparatorChainTest,AbstractListTest,AbstractMapTest,ListUtilsTest,BulkTest,AbstractObjectTest,SplitMapUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-323: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=323; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-320
Write-Host '=== Validating PR-320 ===' -ForegroundColor Cyan
git checkout a43e0245ba6f3f39f51aaac41df4a4e547f4372f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-320.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,IndexProducerFromArrayCountingBloomFilterTest,IndexProducerFromHasherCollectionTest,HasherCollectionTest,IndexProducerFromSimpleBloomFilterTest,AbstractCountingBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,UniqueIndexProducerFromHasherCollectionTest,BitMapProducerFromSimpleBloomFilterTest,EnhancedDoubleHasherTest,IncrementingHasher,SetOperationsTest,AbstractBloomFilterTest,IndexProducerFromHasherTest,BitMapProducerFromSparseBloomFilterTest,SimpleHasherTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-320.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitCountProducerFromArrayCountingBloomFilterTest,AbstractHasherTest,IndexProducerFromArrayCountingBloomFilterTest,IndexProducerFromHasherCollectionTest,HasherCollectionTest,IndexProducerFromSimpleBloomFilterTest,AbstractCountingBloomFilterTest,BitMapProducerFromArrayCountingBloomFilterTest,UniqueIndexProducerFromHasherCollectionTest,BitMapProducerFromSimpleBloomFilterTest,EnhancedDoubleHasherTest,IncrementingHasher,SetOperationsTest,AbstractBloomFilterTest,IndexProducerFromHasherTest,BitMapProducerFromSparseBloomFilterTest,SimpleHasherTest,DefaultBloomFilterTest,IndexProducerFromSparseBloomFilterTest,UniqueIndexProducerFromHasherTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-320: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=320; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
