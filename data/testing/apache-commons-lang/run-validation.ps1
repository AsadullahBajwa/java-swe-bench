# Validation Script for apache/commons-lang
# Generated: 2026-02-01T17:20:55.654019600

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning apache/commons-lang...'
    git clone https://github.com/apache/commons-lang.git repo
}

cd repo

$results = @()

# PR-1591
Write-Host '=== Validating PR-1591 ===' -ForegroundColor Cyan
git checkout 7bcb03a49923bc12f7e3f2c04912d0925f178978 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1591.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ClassUtilsShortClassNameTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1591.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ClassUtilsShortClassNameTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1591: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1591; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1589
Write-Host '=== Validating PR-1589 ===' -ForegroundColor Cyan
git checkout cebde0312d37eb5b9f8efb1974ef322bdb25142c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1589.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1589.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1589: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1589; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1585
Write-Host '=== Validating PR-1585 ===' -ForegroundColor Cyan
git checkout 87538ebd4de1d3f81aa8cec8af0ace1da1b23f60 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1585.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1585.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1585: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1585; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1584
Write-Host '=== Validating PR-1584 ===' -ForegroundColor Cyan
git checkout 3f803b8bf78602c9464b2d01023634e32df1c388 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1584.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=RecursiveToStringStyleTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1584.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=RecursiveToStringStyleTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1584: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1584; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1577
Write-Host '=== Validating PR-1577 ===' -ForegroundColor Cyan
git checkout ac91ddd6ad1c09e0fadf0c6422bf04ba4aed37a9 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1577.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1577.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1577: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1577; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1571
Write-Host '=== Validating PR-1571 ===' -ForegroundColor Cyan
git checkout 67f50236bf337e20c6daa987d4d42c4fedb482ce --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1571.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=StringUtilsAbbreviateTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1571.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=StringUtilsAbbreviateTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1571: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1571; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1561
Write-Host '=== Validating PR-1561 ===' -ForegroundColor Cyan
git checkout 037880852770c3124f8d61c2dbf2b31f34a75508 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1561.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BitFieldTest,BitFieldLongTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1561.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BitFieldTest,BitFieldLongTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1561: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1561; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1560
Write-Host '=== Validating PR-1560 ===' -ForegroundColor Cyan
git checkout ba6cf8e2390f18db484da766db19285255ac3e82 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1560.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=NumberUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1560.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=NumberUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1560: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1560; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1559
Write-Host '=== Validating PR-1559 ===' -ForegroundColor Cyan
git checkout 037880852770c3124f8d61c2dbf2b31f34a75508 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1559.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1559.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1559: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1559; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1549
Write-Host '=== Validating PR-1549 ===' -ForegroundColor Cyan
git checkout 71d4f3d17f029c16e0783f39d1fbf1ad88bedacf --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1549.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TypeUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1549.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TypeUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1549: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1549; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1548
Write-Host '=== Validating PR-1548 ===' -ForegroundColor Cyan
git checkout 5e9736adf2b27f0a65cfa3fff9180cb34fac30c0 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1548.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TypeUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1548.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TypeUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1548: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1548; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1531
Write-Host '=== Validating PR-1531 ===' -ForegroundColor Cyan
git checkout ddf1ce9704cb94bd76fe9cb3dae280e2f2645dbc --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1531.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=NumberUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1531.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=NumberUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1531: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1531; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1530
Write-Host '=== Validating PR-1530 ===' -ForegroundColor Cyan
git checkout 2595926918d8783b1507fded8a65ee3439048839 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1530.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CharSetTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1530.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CharSetTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1530: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1530; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1528
Write-Host '=== Validating PR-1528 ===' -ForegroundColor Cyan
git checkout 3bd1625859000571b99b4193df1360ab18a33910 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1528.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ObjectUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1528.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ObjectUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1528: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1528; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1519
Write-Host '=== Validating PR-1519 ===' -ForegroundColor Cyan
git checkout 91b536e4f502f940c6c64399737a1f129c2e0374 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1519.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayUtilsConcatTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1519.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayUtilsConcatTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1519: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1519; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1495
Write-Host '=== Validating PR-1495 ===' -ForegroundColor Cyan
git checkout f8a6bf9500f655c0f772313e8d0098984420299b --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1495.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1495.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1495: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1495; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1494
Write-Host '=== Validating PR-1494 ===' -ForegroundColor Cyan
git checkout 162575cc6727316621b3761ade5e51fac0f497dd --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1494.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1494.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1494: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1494; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1492
Write-Host '=== Validating PR-1492 ===' -ForegroundColor Cyan
git checkout a33e37af920fa084919134d20035bd807848dd3b --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1492.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1492.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ClassUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1492: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1492; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1490
Write-Host '=== Validating PR-1490 ===' -ForegroundColor Cyan
git checkout 09b30e3c293d28ac42f927bdf76996d9ea8b167f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1490.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=StringUtilsAbbreviateTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1490.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=StringUtilsAbbreviateTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1490: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1490; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1483
Write-Host '=== Validating PR-1483 ===' -ForegroundColor Cyan
git checkout ba85f5e5b3e98234fa0cf22f2155bf41466c10f5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1483.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CalendarUtilsTest,FastDateParser_MoreOrLessTest,DateFormatUtilsTest,FastDatePrinterTest,FastDateParser_TimeZoneStrategyTest,FastDateFormatTest,FastDatePrinterTimeZonesTest,DateUtilsTest,FastTimeZoneTest,FastDateParserTest,DurationFormatUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1483.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CalendarUtilsTest,FastDateParser_MoreOrLessTest,DateFormatUtilsTest,FastDatePrinterTest,FastDateParser_TimeZoneStrategyTest,FastDateFormatTest,FastDatePrinterTimeZonesTest,DateUtilsTest,FastTimeZoneTest,FastDateParserTest,DurationFormatUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1483: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1483; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
