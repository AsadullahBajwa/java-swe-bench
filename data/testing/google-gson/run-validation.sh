#!/bin/bash
# Validation Script for google/gson
# Generated: 2026-02-01T17:20:55.331773300

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning google/gson...'
    git clone https://github.com/google/gson.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

# PR-2967
echo '=== Validating PR-2967 ==='
git checkout c47db7bc13875db690bcfb76e02b1e1bbb3a3353 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2967.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DefaultTypeAdaptersTest,ConstructorConstructorTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2967.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DefaultTypeAdaptersTest,ConstructorConstructorTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2967: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2967: INVALID-PASS-PASS'
else
    echo 'PR-2967: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2965
echo '=== Validating PR-2965 ==='
git checkout d437954171858e0efd53f7720acf480f11176535 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2965.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OSGiManifestIT > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2965.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OSGiManifestIT > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2965: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2965: INVALID-PASS-PASS'
else
    echo 'PR-2965: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2951
echo '=== Validating PR-2951 ==='
git checkout ae9604c201b3ba44babc48e982e012b1d23b69c8 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2951.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=SqlTypesSupportTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2951.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=SqlTypesSupportTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2951: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2951: INVALID-PASS-PASS'
else
    echo 'PR-2951: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2948
echo '=== Validating PR-2948 ==='
git checkout d437954171858e0efd53f7720acf480f11176535 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2948.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=OSGiManifestIT,DefaultTypeAdaptersTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2948.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=OSGiManifestIT,DefaultTypeAdaptersTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2948: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2948: INVALID-PASS-PASS'
else
    echo 'PR-2948: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2946
echo '=== Validating PR-2946 ==='
git checkout 50a93686df9e49dd20fecff222bb9ca169a29754 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2946.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=JsonObjectTest,JsonParserParameterizedTest,SubsetTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2946.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=JsonObjectTest,JsonParserParameterizedTest,SubsetTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2946: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2946: INVALID-PASS-PASS'
else
    echo 'PR-2946: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2925
echo '=== Validating PR-2925 ==='
git checkout 569279fada1f623732ca4836404954d8cf8ca89c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2925.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=StreamsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2925.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=StreamsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2925: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2925: INVALID-PASS-PASS'
else
    echo 'PR-2925: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2918
echo '=== Validating PR-2918 ==='
git checkout 72d3702919e11e6e6a9bb529dd842bec510ca2d9 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2918.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=Java17RecordTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2918.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=Java17RecordTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2918: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2918: INVALID-PASS-PASS'
else
    echo 'PR-2918: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2887
echo '=== Validating PR-2887 ==='
git checkout 5eab3eda9fff9db77b82eae621c26f1d7263386f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2887.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=LinkedTreeMapSuiteTest,CustomTypeAdaptersTest,InterceptorTest,CustomDeserializerTest,FieldExclusionTest,NamingPolicyTest,GsonBuilderTest,GsonTypesTest,ExposeAnnotationExclusionStrategyTest,InheritanceTest,RecursiveTypesResolveTest,TypeAdapterRuntimeTypeWrapperTest,FieldAttributesTest,PerformanceTest,RuntimeTypeAdapterFactoryFunctionalTest,TreeTypeAdaptersTest,ParameterizedTypesTest,ReflectionAccessFilterTest,GsonTest,ExposeFieldsTest,OSGiManifestIT,Java17ReflectiveTypeAdapterFactoryTest,ConcurrencyTest,ConstructorConstructorTest,JsonAdapterSerializerDeserializerTest,JsonAdapterAnnotationOnFieldsTest,ReusedTypeVariablesFullyResolveTest,DelegateTypeAdapterTest,ExclusionStrategyFunctionalTest,JsonTreeTest,MapTest,ObjectTest,JsonAdapterAnnotationOnClassesTest,EnumTest,CollectionTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2887.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=LinkedTreeMapSuiteTest,CustomTypeAdaptersTest,InterceptorTest,CustomDeserializerTest,FieldExclusionTest,NamingPolicyTest,GsonBuilderTest,GsonTypesTest,ExposeAnnotationExclusionStrategyTest,InheritanceTest,RecursiveTypesResolveTest,TypeAdapterRuntimeTypeWrapperTest,FieldAttributesTest,PerformanceTest,RuntimeTypeAdapterFactoryFunctionalTest,TreeTypeAdaptersTest,ParameterizedTypesTest,ReflectionAccessFilterTest,GsonTest,ExposeFieldsTest,OSGiManifestIT,Java17ReflectiveTypeAdapterFactoryTest,ConcurrencyTest,ConstructorConstructorTest,JsonAdapterSerializerDeserializerTest,JsonAdapterAnnotationOnFieldsTest,ReusedTypeVariablesFullyResolveTest,DelegateTypeAdapterTest,ExclusionStrategyFunctionalTest,JsonTreeTest,MapTest,ObjectTest,JsonAdapterAnnotationOnClassesTest,EnumTest,CollectionTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2887: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2887: INVALID-PASS-PASS'
else
    echo 'PR-2887: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2879
echo '=== Validating PR-2879 ==='
git checkout 164ac9dfe1e9b056faf5e37ec1a2baaf4681dc4f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2879.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=GsonBuilderTest,GsonTypesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2879.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=GsonBuilderTest,GsonTypesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2879: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2879: INVALID-PASS-PASS'
else
    echo 'PR-2879: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2874
echo '=== Validating PR-2874 ==='
git checkout 9a492d7b55080b60f8aa26ace0c91362ea65b962 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2874.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=CustomTypeAdaptersTest,MapTest,JsonReaderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2874.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=CustomTypeAdaptersTest,MapTest,JsonReaderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2874: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2874: INVALID-PASS-PASS'
else
    echo 'PR-2874: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2864
echo '=== Validating PR-2864 ==='
git checkout 286843d4a90a4690e5e1f438c944569b3fbfb1d2 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2864.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=GsonTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2864.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=GsonTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2864: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2864: INVALID-PASS-PASS'
else
    echo 'PR-2864: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2845
echo '=== Validating PR-2845 ==='
git checkout 00ae39775708147e115512be5d4f92bee02e9b89 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2845.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl test-shrinker -Dtest=ShrinkingIT > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2845.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl test-shrinker -Dtest=ShrinkingIT > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2845: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2845: INVALID-PASS-PASS'
else
    echo 'PR-2845: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2842
echo '=== Validating PR-2842 ==='
git checkout e0dadb55f8bff55ffb232f1c6e3b8b0d83e9ecf8 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2842.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=MapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2842.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=MapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2842: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2842: INVALID-PASS-PASS'
else
    echo 'PR-2842: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2838
echo '=== Validating PR-2838 ==='
git checkout c6d44259b53a9b2756b5767b843d15e8acacaa31 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2838.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=ParameterizedTypeTest,ParameterizedTypeFixtures,RecursiveTypesResolveTest,MapTest,GenericArrayTypeTest,GsonTypesTest,TypeTokenTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2838.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=ParameterizedTypeTest,ParameterizedTypeFixtures,RecursiveTypesResolveTest,MapTest,GenericArrayTypeTest,GsonTypesTest,TypeTokenTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2838: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2838: INVALID-PASS-PASS'
else
    echo 'PR-2838: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2834
echo '=== Validating PR-2834 ==='
git checkout de190d7ef5feb4950d5daca819a625b39f3fd2f5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2834.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=Java17RecordTest,ExportedPackagesTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2834.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=Java17RecordTest,ExportedPackagesTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2834: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2834: INVALID-PASS-PASS'
else
    echo 'PR-2834: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2811
echo '=== Validating PR-2811 ==='
git checkout 87d30c0686822426ad2711a85bced1b5bc582572 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2811.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl extras -Dtest=GraphAdapterBuilderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2811.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl extras -Dtest=GraphAdapterBuilderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2811: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2811: INVALID-PASS-PASS'
else
    echo 'PR-2811: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2795
echo '=== Validating PR-2795 ==='
git checkout b2e26fa97b7ccba080a082a9bf9741e24d5c523d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2795.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OSGiManifestIT > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2795.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OSGiManifestIT > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2795: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2795: INVALID-PASS-PASS'
else
    echo 'PR-2795: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2789
echo '=== Validating PR-2789 ==='
git checkout e5dce841f73382cb7acdfe32250767ddb2c86b49 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2789.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=GsonBuilderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2789.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=GsonBuilderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2789: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2789: INVALID-PASS-PASS'
else
    echo 'PR-2789: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2784
echo '=== Validating PR-2784 ==='
git checkout 84e5f16acafaa7c55d80a3621a37c7884ca928b6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2784.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=LinkedTreeMapSuiteTest,JsonArrayAsListSuiteTest,JsonObjectAsMapSuiteTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2784.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=LinkedTreeMapSuiteTest,JsonArrayAsListSuiteTest,JsonObjectAsMapSuiteTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2784: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2784: INVALID-PASS-PASS'
else
    echo 'PR-2784: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-2776
echo '=== Validating PR-2776 ==='
git checkout 78caa5e69ec1c914bd0edbe888d0c10681cb8e91 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-2776.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl gson -Dtest=NamingPolicyTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-2776.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl gson -Dtest=NamingPolicyTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2776: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-2776: INVALID-PASS-PASS'
else
    echo 'PR-2776: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"
