# Validation Script for FasterXML/jackson-databind
# Generated: 2026-02-01T17:20:55.620943100

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning FasterXML/jackson-databind...'
    git clone https://github.com/FasterXML/jackson-databind.git repo
}

cd repo

$results = @()

# PR-5622
Write-Host '=== Validating PR-5622 ===' -ForegroundColor Cyan
git checkout 3db1dbbdde8f9340af62d2feaf63e44ab9c7f0f6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5622.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DefaultTypingOverride1391Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5622.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DefaultTypingOverride1391Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5622: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5622; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5621
Write-Host '=== Validating PR-5621 ===' -ForegroundColor Cyan
git checkout 3db1dbbdde8f9340af62d2feaf63e44ab9c7f0f6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5621.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JacksonInject1381Test,JacksonInject3072Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5621.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JacksonInject1381Test,JacksonInject3072Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5621: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5621; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5620
Write-Host '=== Validating PR-5620 ===' -ForegroundColor Cyan
git checkout 8c8bd3dbc0ade33ed96b7432acdcdd150c793086 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5620.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AtomicTypeSerializationTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5620.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AtomicTypeSerializationTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5620: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5620; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5619
Write-Host '=== Validating PR-5619 ===' -ForegroundColor Cyan
git checkout e7d051a5cbfde7b59e235f2ceaa38f098137f1a3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5619.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OptionalSubtypeSerializationTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5619.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OptionalSubtypeSerializationTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5619: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5619; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5614
Write-Host '=== Validating PR-5614 ===' -ForegroundColor Cyan
git checkout 0c4c8f9ba6138025791e2105b9fd0f18af8cc8e9 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5614.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FunctionalScalarDeserializer4004Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5614.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FunctionalScalarDeserializer4004Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5614: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5614; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5613
Write-Host '=== Validating PR-5613 ===' -ForegroundColor Cyan
git checkout 19c42ead6449f7e23e0a05692925d6b30c1378ce --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5613.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JavaUtilDateSerializationTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5613.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JavaUtilDateSerializationTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5613: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5613; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5612
Write-Host '=== Validating PR-5612 ===' -ForegroundColor Cyan
git checkout fe73c27e3a76bb14265ab4c558ab81ff4d22f074 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5612.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OffsetTimeDeserTest,MonthDeserializerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5612.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OffsetTimeDeserTest,MonthDeserializerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5612: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5612; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5611
Write-Host '=== Validating PR-5611 ===' -ForegroundColor Cyan
git checkout 540722065dabad138b41eeb4804bc896f31178d3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5611.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonNodeAsContainerTest,JsonNodeConversionsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5611.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonNodeAsContainerTest,JsonNodeConversionsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5611: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5611; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5606
Write-Host '=== Validating PR-5606 ===' -ForegroundColor Cyan
git checkout e5dfb2e8e6c2eeb0e083409d5cd91c84740e2efc --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5606.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ObjectNodeTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5606.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ObjectNodeTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5606: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5606; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5604
Write-Host '=== Validating PR-5604 ===' -ForegroundColor Cyan
git checkout a2aa480528b6e426dce19c72737202ab93edb8ca --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5604.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=AccessorNamingForBuilderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5604.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=AccessorNamingForBuilderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5604: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5604; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5603
Write-Host '=== Validating PR-5603 ===' -ForegroundColor Cyan
git checkout ddc955d41ceb8f1f365590b49a1b0607d55b5557 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5603.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ConverterFromInterface2617Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5603.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ConverterFromInterface2617Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5603: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5603; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5600
Write-Host '=== Validating PR-5600 ===' -ForegroundColor Cyan
git checkout b2463a27be81da52cfdb12f9f595d69bf1f28a13 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5600.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5600.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5600: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5600; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5595
Write-Host '=== Validating PR-5595 ===' -ForegroundColor Cyan
git checkout bd24fa564538bbda6ea4ba162c7e1a6739599f07 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5595.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FunctionalScalarDeserializer4004Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5595.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FunctionalScalarDeserializer4004Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5595: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5595; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5591
Write-Host '=== Validating PR-5591 ===' -ForegroundColor Cyan
git checkout 96679ae8546db09ead6c70b43e6c1793eb65f793 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5591.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectIdReordering1388Test,AbstractWithObjectIdTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5591.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectIdReordering1388Test,AbstractWithObjectIdTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5591: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5591; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5587
Write-Host '=== Validating PR-5587 ===' -ForegroundColor Cyan
git checkout 182b3bda37223b0cd0f2ac144cbfa16c82d4b561 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5587.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ArrayNodeTest,TreeTraversingParserTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5587.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ArrayNodeTest,TreeTraversingParserTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5587: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5587; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5584
Write-Host '=== Validating PR-5584 ===' -ForegroundColor Cyan
git checkout 5708c4d10a7be71a8a83780f4da53d1f7d1bd6cb --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5584.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,MissingNodeTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,JsonNodeBigIntegerValueTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5584.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,MissingNodeTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,JsonNodeBigIntegerValueTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5584: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5584; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5582
Write-Host '=== Validating PR-5582 ===' -ForegroundColor Cyan
git checkout 6144f64acc4e9f478c2a24c4524cdd31a030cf3e --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5582.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonNodeMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5582.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonNodeMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5582: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5582; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5580
Write-Host '=== Validating PR-5580 ===' -ForegroundColor Cyan
git checkout 52aeb0aca9e4256dd85bfd880bdb84d5d9f53a66 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5580.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonNodeMapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5580.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonNodeMapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5580: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5580; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-5577
Write-Host '=== Validating PR-5577 ===' -ForegroundColor Cyan
git checkout 6eb4224c756a6479091ffeb4c6a01ec688ed4c02 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-5577.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,JsonNodeNumberValueTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,TreeTraversingParserTest,JsonNodeBigIntegerValueTest,Base64DecodingTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-5577.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,JsonNodeNumberValueTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,TreeTraversingParserTest,JsonNodeBigIntegerValueTest,Base64DecodingTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-5577: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=5577; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
