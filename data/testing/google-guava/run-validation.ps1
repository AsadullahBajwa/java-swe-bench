# Validation Script for google/guava
# Generated: 2026-02-01T17:20:55.470821900

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning google/guava...'
    git clone https://github.com/google/guava.git repo
}

cd repo

$results = @()

# PR-8188
Write-Host '=== Validating PR-8188 ===' -ForegroundColor Cyan
git checkout 8138afbfa23c04106c045aa9087ad245794fc9a1 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8188.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=UninterruptiblesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8188.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=UninterruptiblesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8188: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8188; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8187
Write-Host '=== Validating PR-8187 ===' -ForegroundColor Cyan
git checkout 175bac9d8dcd8a37512c44b42e9a60ea85bbd0e5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8187.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=PreconditionsTest,MacHashFunctionTest,FluentIterableTest,MessageDigestHashFunctionTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8187.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=PreconditionsTest,MacHashFunctionTest,FluentIterableTest,MessageDigestHashFunctionTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8187: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8187; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8184
Write-Host '=== Validating PR-8184 ===' -ForegroundColor Cyan
git checkout a63e3601d139644e226bcbe9ad901bb3d835da4c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8184.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CacheLoadingTest,FuturesTest,JSR166TestCase,UninterruptiblesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8184.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CacheLoadingTest,FuturesTest,JSR166TestCase,UninterruptiblesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8184: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8184; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8166
Write-Host '=== Validating PR-8166 ===' -ForegroundColor Cyan
git checkout 0bf87046267ce281b6335430679fbd59135a1303 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8166.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OrderingTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8166.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OrderingTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8166: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8166; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8155
Write-Host '=== Validating PR-8155 ===' -ForegroundColor Cyan
git checkout 64d70b9f946bf10658d13946f7975f5b675b5556 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8155.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AbstractImmutableSortedMapMapInterfaceTest,AbstractImmutableBiMapMapInterfaceTest,AbstractImmutableMapMapInterfaceTest,SynchronizedSetTest,GraphsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8155.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AbstractImmutableSortedMapMapInterfaceTest,AbstractImmutableBiMapMapInterfaceTest,AbstractImmutableMapMapInterfaceTest,SynchronizedSetTest,GraphsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8155: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8155; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8153
Write-Host '=== Validating PR-8153 ===' -ForegroundColor Cyan
git checkout cf92c28d8c3a26218b409ed26dd38a28a9088e55 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8153.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ImmutableSortedMapTest,ContiguousSetTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8153.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ImmutableSortedMapTest,ContiguousSetTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8153: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8153; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8150
Write-Host '=== Validating PR-8150 ===' -ForegroundColor Cyan
git checkout 8df92320363fa0934d97167dc9312afbf61aa7f6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8150.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ContiguousSetTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8150.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ContiguousSetTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8150: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8150; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8149
Write-Host '=== Validating PR-8149 ===' -ForegroundColor Cyan
git checkout fb02c3434a7dd62760d0bb3ad2249cf381b56ad3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8149.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ListsTest,CharSequenceReaderTest,SpecialRandom" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8149.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ListsTest,CharSequenceReaderTest,SpecialRandom" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8149: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8149; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8139
Write-Host '=== Validating PR-8139 ===' -ForegroundColor Cyan
git checkout d8aef628854626455b2e6e46cc09d2c1275162e4 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8139.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DoubleUtilsTest,ThreadFactoryBuilderTest,NullPointerTesterTest,FauxveridesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8139.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DoubleUtilsTest,ThreadFactoryBuilderTest,NullPointerTesterTest,FauxveridesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8139: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8139; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8134
Write-Host '=== Validating PR-8134 ===' -ForegroundColor Cyan
git checkout 071ab9f04f868e45d34140eef92888ee3299d8ff --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8134.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=MoreExecutorsTest,AbstractClosingFutureTest,ImmutableEnumMapTest,RateLimiterTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8134.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=MoreExecutorsTest,AbstractClosingFutureTest,ImmutableEnumMapTest,RateLimiterTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8134: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8134; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8128
Write-Host '=== Validating PR-8128 ===' -ForegroundColor Cyan
git checkout 32ee2f60b126bebc91bb091ea4872d24d1acbf8a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8128.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ForwardingNavigableMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8128.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ForwardingNavigableMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8128: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8128; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8125
Write-Host '=== Validating PR-8125 ===' -ForegroundColor Cyan
git checkout 98107f9487596904fbc08fd06b5009d33dd1a387 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8125.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ImmutableDoubleArrayTest,ImmutableLongArrayTest,ImmutableIntArrayTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8125.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ImmutableDoubleArrayTest,ImmutableLongArrayTest,ImmutableIntArrayTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8125: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8125; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8118
Write-Host '=== Validating PR-8118 ===' -ForegroundColor Cyan
git checkout db23a833236c14da9c8de3edf82f5d7f7a19a5b7 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8118.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=UnsignedBytesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8118.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=UnsignedBytesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8118: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8118; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8114
Write-Host '=== Validating PR-8114 ===' -ForegroundColor Cyan
git checkout 0011c01aee70152979b01b28228622b1631f5bbf --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8114.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ConcurrentHashMultisetBasherTest,ConcurrentHashMultisetTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8114.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ConcurrentHashMultisetBasherTest,ConcurrentHashMultisetTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8114: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8114; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8091
Write-Host '=== Validating PR-8091 ===' -ForegroundColor Cyan
git checkout a6110d39346c02118809a5f46b353362384fc0a3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8091.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ImmutableListMultimapTest,CollectSpliteratorsTest,ImmutableEnumMapTest,ImmutableMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8091.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ImmutableListMultimapTest,CollectSpliteratorsTest,ImmutableEnumMapTest,ImmutableMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8091: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8091; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8081
Write-Host '=== Validating PR-8081 ===' -ForegroundColor Cyan
git checkout 12878d70b4c8eff8468681255e7208688ab201e3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8081.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=InternetDomainNameTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8081.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=InternetDomainNameTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8081: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8081; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8080
Write-Host '=== Validating PR-8080 ===' -ForegroundColor Cyan
git checkout 8cfa76f66ffe6ed77c1142da31dca2dc8454040c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8080.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=QueuesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8080.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=QueuesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8080: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8080; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8067
Write-Host '=== Validating PR-8067 ===' -ForegroundColor Cyan
git checkout fb862e573deb5263dd81ed0ef1f07a5ea65e31d6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8067.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FileBackedOutputStreamTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8067.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FileBackedOutputStreamTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8067: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8067; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8052
Write-Host '=== Validating PR-8052 ===' -ForegroundColor Cyan
git checkout 83869af96382246da6ff99cb029ef59ba684f592 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8052.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OrderingTest,LinkedHashMultimapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8052.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OrderingTest,LinkedHashMultimapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8052: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8052; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-8045
Write-Host '=== Validating PR-8045 ===' -ForegroundColor Cyan
git checkout b53231b06e83e23ed1f0a84ad5becd5cf6d120a0 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-8045.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AbstractGraphTest,ValueGraphTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-8045.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AbstractGraphTest,ValueGraphTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-8045: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=8045; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
