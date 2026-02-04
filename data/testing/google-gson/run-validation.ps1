# Validation Script for google/gson
# Generated: 2026-02-01T17:20:55.329773900

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning google/gson...'
    git clone https://github.com/google/gson.git repo
}

cd repo

$results = @()

# PR-2967
Write-Host '=== Validating PR-2967 ===' -ForegroundColor Cyan
git checkout c47db7bc13875db690bcfb76e02b1e1bbb3a3353 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2967.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=DefaultTypeAdaptersTest,ConstructorConstructorTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2967.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=DefaultTypeAdaptersTest,ConstructorConstructorTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2967: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2967; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2965
Write-Host '=== Validating PR-2965 ===' -ForegroundColor Cyan
git checkout d437954171858e0efd53f7720acf480f11176535 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2965.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OSGiManifestIT" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2965.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OSGiManifestIT" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2965: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2965; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2951
Write-Host '=== Validating PR-2951 ===' -ForegroundColor Cyan
git checkout ae9604c201b3ba44babc48e982e012b1d23b69c8 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2951.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=SqlTypesSupportTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2951.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=SqlTypesSupportTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2951: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2951; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2948
Write-Host '=== Validating PR-2948 ===' -ForegroundColor Cyan
git checkout d437954171858e0efd53f7720acf480f11176535 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2948.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=OSGiManifestIT,DefaultTypeAdaptersTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2948.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=OSGiManifestIT,DefaultTypeAdaptersTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2948: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2948; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2946
Write-Host '=== Validating PR-2946 ===' -ForegroundColor Cyan
git checkout 50a93686df9e49dd20fecff222bb9ca169a29754 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2946.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=JsonObjectTest,JsonParserParameterizedTest,SubsetTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2946.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=JsonObjectTest,JsonParserParameterizedTest,SubsetTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2946: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2946; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2925
Write-Host '=== Validating PR-2925 ===' -ForegroundColor Cyan
git checkout 569279fada1f623732ca4836404954d8cf8ca89c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2925.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=StreamsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2925.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=StreamsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2925: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2925; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2918
Write-Host '=== Validating PR-2918 ===' -ForegroundColor Cyan
git checkout 72d3702919e11e6e6a9bb529dd842bec510ca2d9 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2918.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=Java17RecordTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2918.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=Java17RecordTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2918: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2918; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2887
Write-Host '=== Validating PR-2887 ===' -ForegroundColor Cyan
git checkout 5eab3eda9fff9db77b82eae621c26f1d7263386f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2887.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=LinkedTreeMapSuiteTest,CustomTypeAdaptersTest,InterceptorTest,CustomDeserializerTest,FieldExclusionTest,NamingPolicyTest,GsonBuilderTest,GsonTypesTest,ExposeAnnotationExclusionStrategyTest,InheritanceTest,RecursiveTypesResolveTest,TypeAdapterRuntimeTypeWrapperTest,FieldAttributesTest,PerformanceTest,RuntimeTypeAdapterFactoryFunctionalTest,TreeTypeAdaptersTest,ParameterizedTypesTest,ReflectionAccessFilterTest,GsonTest,ExposeFieldsTest,OSGiManifestIT,Java17ReflectiveTypeAdapterFactoryTest,ConcurrencyTest,ConstructorConstructorTest,JsonAdapterSerializerDeserializerTest,JsonAdapterAnnotationOnFieldsTest,ReusedTypeVariablesFullyResolveTest,DelegateTypeAdapterTest,ExclusionStrategyFunctionalTest,JsonTreeTest,MapTest,ObjectTest,JsonAdapterAnnotationOnClassesTest,EnumTest,CollectionTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2887.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=LinkedTreeMapSuiteTest,CustomTypeAdaptersTest,InterceptorTest,CustomDeserializerTest,FieldExclusionTest,NamingPolicyTest,GsonBuilderTest,GsonTypesTest,ExposeAnnotationExclusionStrategyTest,InheritanceTest,RecursiveTypesResolveTest,TypeAdapterRuntimeTypeWrapperTest,FieldAttributesTest,PerformanceTest,RuntimeTypeAdapterFactoryFunctionalTest,TreeTypeAdaptersTest,ParameterizedTypesTest,ReflectionAccessFilterTest,GsonTest,ExposeFieldsTest,OSGiManifestIT,Java17ReflectiveTypeAdapterFactoryTest,ConcurrencyTest,ConstructorConstructorTest,JsonAdapterSerializerDeserializerTest,JsonAdapterAnnotationOnFieldsTest,ReusedTypeVariablesFullyResolveTest,DelegateTypeAdapterTest,ExclusionStrategyFunctionalTest,JsonTreeTest,MapTest,ObjectTest,JsonAdapterAnnotationOnClassesTest,EnumTest,CollectionTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2887: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2887; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2879
Write-Host '=== Validating PR-2879 ===' -ForegroundColor Cyan
git checkout 164ac9dfe1e9b056faf5e37ec1a2baaf4681dc4f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2879.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=GsonBuilderTest,GsonTypesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2879.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=GsonBuilderTest,GsonTypesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2879: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2879; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2874
Write-Host '=== Validating PR-2874 ===' -ForegroundColor Cyan
git checkout 9a492d7b55080b60f8aa26ace0c91362ea65b962 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2874.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CustomTypeAdaptersTest,MapTest,JsonReaderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2874.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CustomTypeAdaptersTest,MapTest,JsonReaderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2874: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2874; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2864
Write-Host '=== Validating PR-2864 ===' -ForegroundColor Cyan
git checkout 286843d4a90a4690e5e1f438c944569b3fbfb1d2 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2864.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=GsonTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2864.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=GsonTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2864: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2864; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2845
Write-Host '=== Validating PR-2845 ===' -ForegroundColor Cyan
git checkout 00ae39775708147e115512be5d4f92bee02e9b89 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2845.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl test-shrinker -Dtest=ShrinkingIT" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2845.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl test-shrinker -Dtest=ShrinkingIT" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2845: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2845; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2842
Write-Host '=== Validating PR-2842 ===' -ForegroundColor Cyan
git checkout e0dadb55f8bff55ffb232f1c6e3b8b0d83e9ecf8 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2842.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=MapTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2842.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=MapTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2842: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2842; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2838
Write-Host '=== Validating PR-2838 ===' -ForegroundColor Cyan
git checkout c6d44259b53a9b2756b5767b843d15e8acacaa31 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2838.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=ParameterizedTypeTest,ParameterizedTypeFixtures,RecursiveTypesResolveTest,MapTest,GenericArrayTypeTest,GsonTypesTest,TypeTokenTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2838.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=ParameterizedTypeTest,ParameterizedTypeFixtures,RecursiveTypesResolveTest,MapTest,GenericArrayTypeTest,GsonTypesTest,TypeTokenTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2838: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2838; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2834
Write-Host '=== Validating PR-2834 ===' -ForegroundColor Cyan
git checkout de190d7ef5feb4950d5daca819a625b39f3fd2f5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2834.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=Java17RecordTest,ExportedPackagesTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2834.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=Java17RecordTest,ExportedPackagesTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2834: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2834; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2811
Write-Host '=== Validating PR-2811 ===' -ForegroundColor Cyan
git checkout 87d30c0686822426ad2711a85bced1b5bc582572 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2811.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl extras -Dtest=GraphAdapterBuilderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2811.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl extras -Dtest=GraphAdapterBuilderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2811: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2811; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2795
Write-Host '=== Validating PR-2795 ===' -ForegroundColor Cyan
git checkout b2e26fa97b7ccba080a082a9bf9741e24d5c523d --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2795.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=OSGiManifestIT" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2795.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=OSGiManifestIT" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2795: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2795; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2789
Write-Host '=== Validating PR-2789 ===' -ForegroundColor Cyan
git checkout e5dce841f73382cb7acdfe32250767ddb2c86b49 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2789.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=GsonBuilderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2789.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=GsonBuilderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2789: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2789; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2784
Write-Host '=== Validating PR-2784 ===' -ForegroundColor Cyan
git checkout 84e5f16acafaa7c55d80a3621a37c7884ca928b6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2784.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=LinkedTreeMapSuiteTest,JsonArrayAsListSuiteTest,JsonObjectAsMapSuiteTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2784.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=LinkedTreeMapSuiteTest,JsonArrayAsListSuiteTest,JsonObjectAsMapSuiteTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2784: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2784; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-2776
Write-Host '=== Validating PR-2776 ===' -ForegroundColor Cyan
git checkout 78caa5e69ec1c914bd0edbe888d0c10681cb8e91 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-2776.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl gson -Dtest=NamingPolicyTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-2776.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl gson -Dtest=NamingPolicyTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-2776: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=2776; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
