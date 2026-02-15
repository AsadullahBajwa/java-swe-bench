# Task Validation Status: google/gson

Generated: 2026-02-01T17:20:55.328773300

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after
- **INVALID-FAIL-FAIL**: Tests fail both before and after
- **ERROR**: Could not run validation
- **PENDING**: Not yet tested

---

## Tasks

| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |
|------|-------------|----------------|------------------|------------------|--------|-------|
| 2967 | c47db7b... | DefaultTypeAdaptersTest, ConstructorConstructorTest | PENDING | PENDING | PENDING | |
| 2965 | d437954... | OSGiManifestIT | PENDING | PENDING | PENDING | |
| 2951 | ae9604c... | SqlTypesSupportTest | PENDING | PENDING | PENDING | |
| 2948 | d437954... | OSGiManifestIT, DefaultTypeAdaptersTest | PENDING | PENDING | PENDING | |
| 2946 | 50a9368... | JsonObjectTest, JsonParserParameterizedTest, SubsetTest | PENDING | PENDING | PENDING | |
| 2925 | 569279f... | StreamsTest | PENDING | PENDING | PENDING | |
| 2918 | 72d3702... | Java17RecordTest | PENDING | PENDING | PENDING | |
| 2887 | 5eab3ed... | LinkedTreeMapSuiteTest, CustomTypeAdaptersTest, InterceptorTest, CustomDeserializerTest, FieldExclusionTest, NamingPolicyTest, GsonBuilderTest, GsonTypesTest, ExposeAnnotationExclusionStrategyTest, InheritanceTest, RecursiveTypesResolveTest, TypeAdapterRuntimeTypeWrapperTest, FieldAttributesTest, PerformanceTest, RuntimeTypeAdapterFactoryFunctionalTest, TreeTypeAdaptersTest, ParameterizedTypesTest, ReflectionAccessFilterTest, GsonTest, ExposeFieldsTest, OSGiManifestIT, Java17ReflectiveTypeAdapterFactoryTest, ConcurrencyTest, ConstructorConstructorTest, JsonAdapterSerializerDeserializerTest, JsonAdapterAnnotationOnFieldsTest, ReusedTypeVariablesFullyResolveTest, DelegateTypeAdapterTest, ExclusionStrategyFunctionalTest, JsonTreeTest, MapTest, ObjectTest, JsonAdapterAnnotationOnClassesTest, EnumTest, CollectionTest | PENDING | PENDING | PENDING | |
| 2879 | 164ac9d... | GsonBuilderTest, GsonTypesTest | PENDING | PENDING | PENDING | |
| 2874 | 9a492d7... | CustomTypeAdaptersTest, MapTest, JsonReaderTest | PENDING | PENDING | PENDING | |
| 2864 | 286843d... | GsonTest | PENDING | PENDING | PENDING | |
| 2845 | 00ae397... | ShrinkingIT | PENDING | PENDING | PENDING | |
| 2842 | e0dadb5... | MapTest | PENDING | PENDING | PENDING | |
| 2838 | c6d4425... | ParameterizedTypeTest, ParameterizedTypeFixtures, RecursiveTypesResolveTest, MapTest, GenericArrayTypeTest, GsonTypesTest, TypeTokenTest | PENDING | PENDING | PENDING | |
| 2834 | de190d7... | Java17RecordTest, ExportedPackagesTest | PENDING | PENDING | PENDING | |
| 2811 | 87d30c0... | GraphAdapterBuilderTest | PENDING | PENDING | PENDING | |
| 2795 | b2e26fa... | OSGiManifestIT | PENDING | PENDING | PENDING | |
| 2789 | e5dce84... | GsonBuilderTest | PENDING | PENDING | PENDING | |
| 2784 | 84e5f16... | LinkedTreeMapSuiteTest, JsonArrayAsListSuiteTest, JsonObjectAsMapSuiteTest | PENDING | PENDING | PENDING | |
| 2776 | 78caa5e... | NamingPolicyTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/google/gson.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
