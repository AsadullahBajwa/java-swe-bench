# Validation Script for apache/commons-text
# Generated: 2026-02-01T17:20:55.668164300

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning apache/commons-text...'
    git clone https://github.com/apache/commons-text.git repo
}

cd repo

$results = @()

# PR-735
Write-Host '=== Validating PR-735 ===' -ForegroundColor Cyan
git checkout a0b89c079b3af0da7bd6bdc3a8a3421182e14aa4 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-735.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TextStringBuilderTest,StrBuilderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-735.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TextStringBuilderTest,StrBuilderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-735: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=735; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-731
Write-Host '=== Validating PR-731 ===' -ForegroundColor Cyan
git checkout b5052c97e84e1c174ec8bfbbb749e33f22917a07 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-731.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=XmlStringLookupTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-731.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=XmlStringLookupTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-731: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=731; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-729
Write-Host '=== Validating PR-729 ===' -ForegroundColor Cyan
git checkout 685da724c45e74d30df08215bb96bbafdeac4ed6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-729.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=StringLookupFactoryTest,XmlStringLookupTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-729.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=StringLookupFactoryTest,XmlStringLookupTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-729: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=729; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-725
Write-Host '=== Validating PR-725 ===' -ForegroundColor Cyan
git checkout 66bafadc42c722ce8e8f99f318408ba5baca13b8 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-725.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CharSequenceTranslatorTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-725.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CharSequenceTranslatorTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-725: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=725; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-687
Write-Host '=== Validating PR-687 ===' -ForegroundColor Cyan
git checkout 5d356fd01d231dd27dd7c38cb98761343d364075 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-687.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DamerauLevenshteinDistanceTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-687.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DamerauLevenshteinDistanceTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-687: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=687; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-467
Write-Host '=== Validating PR-467 ===' -ForegroundColor Cyan
git checkout fb476ec5f1d64575f09b3187aeee02681e726a3e --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-467.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DoubleFormatTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-467.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DoubleFormatTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-467: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=467; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-452
Write-Host '=== Validating PR-452 ===' -ForegroundColor Cyan
git checkout efa7475c3da2153a0d3a769dac8f5fe606c2b9fb --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-452.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TextStringBuilderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-452.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TextStringBuilderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-452: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=452; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-449
Write-Host '=== Validating PR-449 ===' -ForegroundColor Cyan
git checkout 28b6e1d38a47cab1b6beaadd8585780b49a178ef --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-449.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,StringLookupFactoryTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-449.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=XmlEncoderStringLookupTest,XmlDecoderStringLookupTest,StringLookupFactoryTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-449: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=449; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
