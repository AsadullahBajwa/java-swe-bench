# Validation Script for mockito/mockito
# Generated: 2026-02-01T17:20:55.407299100

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning mockito/mockito...'
    git clone https://github.com/mockito/mockito.git repo
}

cd repo

$results = @()

# PR-3760
Write-Host '=== Validating PR-3760 ===' -ForegroundColor Cyan
git checkout 58ba4455209a126d025eecbf18b33a7e04dece3b --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3760.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"StrictJUnitRuleTest\" --tests \"ProductionCode\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3760.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"StrictJUnitRuleTest\" --tests \"ProductionCode\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3760: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3760; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3759
Write-Host '=== Validating PR-3759 ===' -ForegroundColor Cyan
git checkout 966d6009047c7f6617dbf080e68ee38ea049aa54 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3759.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"InlineDelegateByteBuddyMockMakerTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3759.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"InlineDelegateByteBuddyMockMakerTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3759: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3759; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3731
Write-Host '=== Validating PR-3731 ===' -ForegroundColor Cyan
git checkout 1d4b4736fb575857f55b4eb988a1f39d52c20138 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3731.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"MockitoTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3731.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"MockitoTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3731: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3731; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3729
Write-Host '=== Validating PR-3729 ===' -ForegroundColor Cyan
git checkout 3cfbd427182ef7c9ae718873ffb85b5ed4f04758 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3729.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"MockAnnotationProcessorTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3729.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"MockAnnotationProcessorTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3729: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3729; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3727
Write-Host '=== Validating PR-3727 ===' -ForegroundColor Cyan
git checkout e6682a3805b45117a2743f7cd833926ec91406eb --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3727.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"ReturnsEmptyValuesTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3727.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"ReturnsEmptyValuesTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3727: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3727; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3710
Write-Host '=== Validating PR-3710 ===' -ForegroundColor Cyan
git checkout ef2fd6f8e12df2db9b1c3aef067c33f6fe2aba95 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3710.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"DummyObject\" --tests \"GraalVMSubclassMockMakerTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3710.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"DummyObject\" --tests \"GraalVMSubclassMockMakerTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3710: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3710; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3708
Write-Host '=== Validating PR-3708 ===' -ForegroundColor Cyan
git checkout b275c7d289b12787fb955fa75a3b831495905501 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3708.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"ReturnsEmptyValuesTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3708.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"ReturnsEmptyValuesTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3708: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3708; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3695
Write-Host '=== Validating PR-3695 ===' -ForegroundColor Cyan
git checkout f05e44d97c8008ef65e221f77c00b0ce1289d67a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3695.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew test --tests \"MockitoRunnerBreaksWhenNoTestMethodsTest\" --tests \"PartialMockingWithSpiesTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3695.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew test --tests \"MockitoRunnerBreaksWhenNoTestMethodsTest\" --tests \"PartialMockingWithSpiesTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3695: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3695; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3674
Write-Host '=== Validating PR-3674 ===' -ForegroundColor Cyan
git checkout 4817b0f3f406b7626d8d174f6385589a5f9d174a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3674.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :buildSrc:test --tests \"HashCodeAndEqualsSafeSetTest\" --tests \"ReplacingObjectMethodsTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3674.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :buildSrc:test --tests \"HashCodeAndEqualsSafeSetTest\" --tests \"ReplacingObjectMethodsTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3674: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3674; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3628
Write-Host '=== Validating PR-3628 ===' -ForegroundColor Cyan
git checkout 3edab5283552c3c6c393d8c818c8d6a8fa1f94a5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3628.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"MockitoTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3628.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"MockitoTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3628: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3628; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3623
Write-Host '=== Validating PR-3623 ===' -ForegroundColor Cyan
git checkout 1764e62102f525ff9a82b8166b8596edd25f5b7f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3623.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-extensions/mockito-junit-jupiter:test --tests \"JunitJupiterSkippedTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3623.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-extensions/mockito-junit-jupiter:test --tests \"JunitJupiterSkippedTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3623: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3623; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3608
Write-Host '=== Validating PR-3608 ===' -ForegroundColor Cyan
git checkout c81be5deedfd966bd17c9619769a34c74d9779e6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3608.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :mockito-core:test --tests \"ModuleHandlingTest\" --tests \"ModuleUseTest\" --tests \"AcrossClassLoaderSerializationTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3608.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :mockito-core:test --tests \"ModuleHandlingTest\" --tests \"ModuleUseTest\" --tests \"AcrossClassLoaderSerializationTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3608: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3608; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3597
Write-Host '=== Validating PR-3597 ===' -ForegroundColor Cyan
git checkout d01ac9d8222b01d6694b11a9978a91eb9aced5b1 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3597.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :buildSrc:test --tests \"InlineDelegateByteBuddyMockMakerTest\" --tests \"module-info\" --tests \"ModuleUseTest\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3597.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :buildSrc:test --tests \"InlineDelegateByteBuddyMockMakerTest\" --tests \"module-info\" --tests \"ModuleUseTest\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3597: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3597; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-3514
Write-Host '=== Validating PR-3514 ===' -ForegroundColor Cyan
git checkout 2064681d7c4084c3f76cdafbcb2bcb095f2b6c75 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-3514.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "./gradlew :buildSrc:test --tests \"SimplePerRealmReloadingClassLoader\" --tests \"ClassLoaders\"" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-3514.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "./gradlew :buildSrc:test --tests \"SimplePerRealmReloadingClassLoader\" --tests \"ClassLoaders\"" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-3514: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=3514; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
