# Validation Script for FasterXML/jackson-core
# Generated: 2026-02-01T17:20:55.284436600

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning FasterXML/jackson-core...'
    git clone https://github.com/FasterXML/jackson-core.git repo
}

cd repo

$results = @()

# PR-1523
Write-Host '=== Validating PR-1523 ===' -ForegroundColor Cyan
git checkout 5f4e7046dbf4f75dfa96b0608ca6c2fc5ed8eff8 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1523.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=NumberInputTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1523.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=NumberInputTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1523: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1523; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1520
Write-Host '=== Validating PR-1520 ===' -ForegroundColor Cyan
git checkout 74bc600bdf336d219d411a79a2839617b73beeef --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1520.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=LongName1516Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1520.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=LongName1516Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1520: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1520; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1509
Write-Host '=== Validating PR-1509 ===' -ForegroundColor Cyan
git checkout 20e09976fb1a28ce2b46eb2ff890001bb7178a1a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1509.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ParserFilterEmpty1418Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1509.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ParserFilterEmpty1418Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1509: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1509; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1508
Write-Host '=== Validating PR-1508 ===' -ForegroundColor Cyan
git checkout d09a49dedb78f2dda46913d6e1704d8346ade75d --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1508.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=NonStandardLeadingPlusSign784Test,NonStandardNumberParsingTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1508.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=NonStandardLeadingPlusSign784Test,NonStandardNumberParsingTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1508: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1508; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1507
Write-Host '=== Validating PR-1507 ===' -ForegroundColor Cyan
git checkout 1da649709a55315d6073c3b005dcd0d0f1c64f5c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1507.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,AsyncParserRootToken1506Test,module-info,AsyncTokenRootErrorTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1507.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,AsyncParserRootToken1506Test,module-info,AsyncTokenRootErrorTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1507: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1507; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1505
Write-Host '=== Validating PR-1505 ===' -ForegroundColor Cyan
git checkout 8fa89c628c79f15e4fa6d6240e67e8d1bdef2f88 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1505.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTesting,AsyncPropertyNamesTest,AsyncNonStandardNumberParsingTest,AsyncCommentParsingTest,AsyncInvalidCharsTest,JacksonTestFailureExpected,AsyncRootNumbersTest,AsyncReaderWrapperForByteArray,ThrottledReader,ParserFilterEmpty1418Test,AsyncRootValuesTest,MockDataInput,JsonParserClosedCaseTest,AsyncConcurrencyByteBufferTest,GeneratorCloseTest,AsyncNaNHandlingTest,JacksonCoreTestBase,ParserErrorHandling679Test,AsyncNumberDeferredReadTest,AsyncPointerFromContext563Test,JacksonTestFailureExpectedInterceptor,AsyncParserNamesTest,AsyncSimpleObjectTest,LargeDocReadTest,Base64GenerationTest,AsyncCharEscapingTest,AsyncStringObjectTest,AsyncBinaryParseTest,ByteOutputStreamForTesting,Fuzz32208UTF32ParseTest,AsyncTokenRootErrorTest,AsyncScopeMatchingTest,ExpectedPassingTestCasePredicate,AsyncUnicodeHandlingTest,Fuzz52688ParseTest,AsyncReaderWrapperForByteBuffer,AsyncNonStdNumberHandlingTest,AsyncNonStdParsingTest,SimpleParserTest,JacksonTestShouldFailException,AsyncStringArrayTest,AsyncTestBase,AsyncScalarArrayTest,AsyncNumberCoercionTest,ParserErrorHandling105Test,AsyncMissingValuesInObjectTest,AsyncTokenNonRootErrorTest,AsyncMissingValuesInArrayTest,JacksonTestUtilBase,module-info,AsyncSimpleNestedTest,ConfigTest,ThrottledInputStream" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1505.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTesting,AsyncPropertyNamesTest,AsyncNonStandardNumberParsingTest,AsyncCommentParsingTest,AsyncInvalidCharsTest,JacksonTestFailureExpected,AsyncRootNumbersTest,AsyncReaderWrapperForByteArray,ThrottledReader,ParserFilterEmpty1418Test,AsyncRootValuesTest,MockDataInput,JsonParserClosedCaseTest,AsyncConcurrencyByteBufferTest,GeneratorCloseTest,AsyncNaNHandlingTest,JacksonCoreTestBase,ParserErrorHandling679Test,AsyncNumberDeferredReadTest,AsyncPointerFromContext563Test,JacksonTestFailureExpectedInterceptor,AsyncParserNamesTest,AsyncSimpleObjectTest,LargeDocReadTest,Base64GenerationTest,AsyncCharEscapingTest,AsyncStringObjectTest,AsyncBinaryParseTest,ByteOutputStreamForTesting,Fuzz32208UTF32ParseTest,AsyncTokenRootErrorTest,AsyncScopeMatchingTest,ExpectedPassingTestCasePredicate,AsyncUnicodeHandlingTest,Fuzz52688ParseTest,AsyncReaderWrapperForByteBuffer,AsyncNonStdNumberHandlingTest,AsyncNonStdParsingTest,SimpleParserTest,JacksonTestShouldFailException,AsyncStringArrayTest,AsyncTestBase,AsyncScalarArrayTest,AsyncNumberCoercionTest,ParserErrorHandling105Test,AsyncMissingValuesInObjectTest,AsyncTokenNonRootErrorTest,AsyncMissingValuesInArrayTest,JacksonTestUtilBase,module-info,AsyncSimpleNestedTest,ConfigTest,ThrottledInputStream" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1505: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1505; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1503
Write-Host '=== Validating PR-1503 ===' -ForegroundColor Cyan
git checkout 262d9e58f458961c212e7d5bb9d71dc85685ccff --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1503.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FastDoubleParserShadingIT,module-info" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1503.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FastDoubleParserShadingIT,module-info" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1503: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1503; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1495
Write-Host '=== Validating PR-1495 ===' -ForegroundColor Cyan
git checkout 1c1914c48634f0301195f280c789c5419d871f15 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1495.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ParserFilterEmpty708Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1495.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ParserFilterEmpty708Test" 2>&1 | Out-Null
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
git checkout 873d4109cbef914f3ed450719c2ebe6b15df9250 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1494.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=UTF8SurrogateValidation363Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1494.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=UTF8SurrogateValidation363Test" 2>&1 | Out-Null
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
git checkout bac78c0f1d6c48f7aef7858951e0a65676fe4a32 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1492.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BinaryNameMatcherTest,PropertyNameMatcher1491Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1492.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BinaryNameMatcherTest,PropertyNameMatcher1491Test" 2>&1 | Out-Null
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
git checkout c1a2db99ffd539a6a1ce645c3714ed234767c925 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1490.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ExceptionsTest,LocationOfError1180Test,ErrorReportConfigurationTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1490.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ExceptionsTest,LocationOfError1180Test,ErrorReportConfigurationTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1490: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1490; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1486
Write-Host '=== Validating PR-1486 ===' -ForegroundColor Cyan
git checkout 4f23c31d363f491cab277d18a04d457b6bfbd472 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1486.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TextBufferTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1486.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TextBufferTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1486: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1486; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1481
Write-Host '=== Validating PR-1481 ===' -ForegroundColor Cyan
git checkout c2e2fcead1d3d1ddb119c1ad769161675e9036b2 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1481.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=PrettyPrinterTest,DefaultIndenterTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1481.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=PrettyPrinterTest,DefaultIndenterTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1481: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1481; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1478
Write-Host '=== Validating PR-1478 ===' -ForegroundColor Cyan
git checkout 2629fb05e4f9d9a31a696681465341e1683f7cd6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1478.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=GeneratorMiscTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1478.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=GeneratorMiscTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1478: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1478; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1474
Write-Host '=== Validating PR-1474 ===' -ForegroundColor Cyan
git checkout 4975a1e7a2057520e2a995848a6f91f5f7939588 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1474.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=SurrogateWrite223Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1474.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=SurrogateWrite223Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1474: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1474; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1470
Write-Host '=== Validating PR-1470 ===' -ForegroundColor Cyan
git checkout 367777c00d73dfa718ae4763b7333c501ff0117a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1470.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=GeneratorCopyTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1470.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=GeneratorCopyTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1470: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1470; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1466
Write-Host '=== Validating PR-1466 ===' -ForegroundColor Cyan
git checkout 2f6a1af4f722156bc15c0345561a19a7300d47b3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1466.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=SimpleParserTest,InputStreamInitTest,JsonFactoryTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1466.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=SimpleParserTest,InputStreamInitTest,JsonFactoryTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1466: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1466; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1460
Write-Host '=== Validating PR-1460 ===' -ForegroundColor Cyan
git checkout d61c80a6c0afea7d4e273d0603021189ecca1cf4 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1460.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1460.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1460: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1460; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1442
Write-Host '=== Validating PR-1442 ===' -ForegroundColor Cyan
git checkout c20ac86571ef9665ece2bad49ec37ae910ec95e9 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1442.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonParserClosedCaseTest,JsonFactoryTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1442.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonParserClosedCaseTest,JsonFactoryTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1442: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1442; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-1437
Write-Host '=== Validating PR-1437 ===' -ForegroundColor Cyan
git checkout 57f851672e159936f19764b840e5635474466dbc --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-1437.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=NumberParsingGetType1433Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-1437.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=NumberParsingGetType1433Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-1437: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=1437; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
