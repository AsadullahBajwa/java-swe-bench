#!/bin/bash
# Validation Script for mockito/mockito
# Generated: 2026-02-01T17:20:55.408298200

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning mockito/mockito...'
    git clone https://github.com/mockito/mockito.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-3760
echo '=== Validating PR-3760 ==='
git checkout 58ba4455209a126d025eecbf18b33a7e04dece3b --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3760.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "StrictJUnitRuleTest" --tests "ProductionCode" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3760.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "StrictJUnitRuleTest" --tests "ProductionCode" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3760: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3760 | 58ba445... | StrictJUnitRuleTest, ProductionCode | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3760: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3760 | 58ba445... | StrictJUnitRuleTest, ProductionCode | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3760: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3760 | 58ba445... | StrictJUnitRuleTest, ProductionCode | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3759
echo '=== Validating PR-3759 ==='
git checkout 966d6009047c7f6617dbf080e68ee38ea049aa54 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3759.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "InlineDelegateByteBuddyMockMakerTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3759.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "InlineDelegateByteBuddyMockMakerTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3759: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3759 | 966d600... | InlineDelegateByteBuddyMockMakerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3759: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3759 | 966d600... | InlineDelegateByteBuddyMockMakerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3759: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3759 | 966d600... | InlineDelegateByteBuddyMockMakerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3731
echo '=== Validating PR-3731 ==='
git checkout 1d4b4736fb575857f55b4eb988a1f39d52c20138 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3731.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "MockitoTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3731.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "MockitoTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3731: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3731 | 1d4b473... | MockitoTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3731: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3731 | 1d4b473... | MockitoTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3731: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3731 | 1d4b473... | MockitoTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3729
echo '=== Validating PR-3729 ==='
git checkout 3cfbd427182ef7c9ae718873ffb85b5ed4f04758 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3729.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "MockAnnotationProcessorTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3729.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "MockAnnotationProcessorTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3729: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3729 | 3cfbd42... | MockAnnotationProcessorTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3729: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3729 | 3cfbd42... | MockAnnotationProcessorTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3729: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3729 | 3cfbd42... | MockAnnotationProcessorTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3727
echo '=== Validating PR-3727 ==='
git checkout e6682a3805b45117a2743f7cd833926ec91406eb --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3727.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "ReturnsEmptyValuesTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3727.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "ReturnsEmptyValuesTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3727: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3727 | e6682a3... | ReturnsEmptyValuesTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3727: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3727 | e6682a3... | ReturnsEmptyValuesTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3727: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3727 | e6682a3... | ReturnsEmptyValuesTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3710
echo '=== Validating PR-3710 ==='
git checkout ef2fd6f8e12df2db9b1c3aef067c33f6fe2aba95 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3710.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "DummyObject" --tests "GraalVMSubclassMockMakerTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3710.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "DummyObject" --tests "GraalVMSubclassMockMakerTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3710: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3710 | ef2fd6f... | DummyObject, GraalVMSubclassMockMakerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3710: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3710 | ef2fd6f... | DummyObject, GraalVMSubclassMockMakerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3710: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3710 | ef2fd6f... | DummyObject, GraalVMSubclassMockMakerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3708
echo '=== Validating PR-3708 ==='
git checkout b275c7d289b12787fb955fa75a3b831495905501 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3708.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "ReturnsEmptyValuesTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3708.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "ReturnsEmptyValuesTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3708: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3708 | b275c7d... | ReturnsEmptyValuesTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3708: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3708 | b275c7d... | ReturnsEmptyValuesTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3708: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3708 | b275c7d... | ReturnsEmptyValuesTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3695
echo '=== Validating PR-3695 ==='
git checkout f05e44d97c8008ef65e221f77c00b0ce1289d67a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3695.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test --tests "MockitoRunnerBreaksWhenNoTestMethodsTest" --tests "PartialMockingWithSpiesTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3695.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test --tests "MockitoRunnerBreaksWhenNoTestMethodsTest" --tests "PartialMockingWithSpiesTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3695: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3695 | f05e44d... | MockitoRunnerBreaksWhenNoTestMethodsTest, PartialMockingW... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3695: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3695 | f05e44d... | MockitoRunnerBreaksWhenNoTestMethodsTest, PartialMockingW... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3695: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3695 | f05e44d... | MockitoRunnerBreaksWhenNoTestMethodsTest, PartialMockingW... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3674
echo '=== Validating PR-3674 ==='
git checkout 4817b0f3f406b7626d8d174f6385589a5f9d174a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3674.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :buildSrc:test --tests "HashCodeAndEqualsSafeSetTest" --tests "ReplacingObjectMethodsTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3674.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :buildSrc:test --tests "HashCodeAndEqualsSafeSetTest" --tests "ReplacingObjectMethodsTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3674: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3674 | 4817b0f... | HashCodeAndEqualsSafeSetTest, ReplacingObjectMethodsTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3674: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3674 | 4817b0f... | HashCodeAndEqualsSafeSetTest, ReplacingObjectMethodsTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3674: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3674 | 4817b0f... | HashCodeAndEqualsSafeSetTest, ReplacingObjectMethodsTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3628
echo '=== Validating PR-3628 ==='
git checkout 3edab5283552c3c6c393d8c818c8d6a8fa1f94a5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3628.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "MockitoTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3628.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "MockitoTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3628: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3628 | 3edab52... | MockitoTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3628: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3628 | 3edab52... | MockitoTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3628: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3628 | 3edab52... | MockitoTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3623
echo '=== Validating PR-3623 ==='
git checkout 1764e62102f525ff9a82b8166b8596edd25f5b7f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3623.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-extensions/mockito-junit-jupiter:test --tests "JunitJupiterSkippedTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3623.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-extensions/mockito-junit-jupiter:test --tests "JunitJupiterSkippedTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3623: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3623 | 1764e62... | JunitJupiterSkippedTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3623: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3623 | 1764e62... | JunitJupiterSkippedTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3623: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3623 | 1764e62... | JunitJupiterSkippedTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3608
echo '=== Validating PR-3608 ==='
git checkout c81be5deedfd966bd17c9619769a34c74d9779e6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3608.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :mockito-core:test --tests "ModuleHandlingTest" --tests "ModuleUseTest" --tests "AcrossClassLoaderSerializationTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3608.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :mockito-core:test --tests "ModuleHandlingTest" --tests "ModuleUseTest" --tests "AcrossClassLoaderSerializationTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3608: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3608 | c81be5d... | ModuleHandlingTest, ModuleUseTest, AcrossClassLoaderSeria... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3608: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3608 | c81be5d... | ModuleHandlingTest, ModuleUseTest, AcrossClassLoaderSeria... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3608: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3608 | c81be5d... | ModuleHandlingTest, ModuleUseTest, AcrossClassLoaderSeria... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3597
echo '=== Validating PR-3597 ==='
git checkout d01ac9d8222b01d6694b11a9978a91eb9aced5b1 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3597.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :buildSrc:test --tests "InlineDelegateByteBuddyMockMakerTest" --tests "module-info" --tests "ModuleUseTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3597.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :buildSrc:test --tests "InlineDelegateByteBuddyMockMakerTest" --tests "module-info" --tests "ModuleUseTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3597: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3597 | d01ac9d... | InlineDelegateByteBuddyMockMakerTest, module-info, Module... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3597: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3597 | d01ac9d... | InlineDelegateByteBuddyMockMakerTest, module-info, Module... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3597: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3597 | d01ac9d... | InlineDelegateByteBuddyMockMakerTest, module-info, Module... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-3514
echo '=== Validating PR-3514 ==='
git checkout 2064681d7c4084c3f76cdafbcb2bcb095f2b6c75 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-3514.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :buildSrc:test --tests "SimplePerRealmReloadingClassLoader" --tests "ClassLoaders" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-3514.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :buildSrc:test --tests "SimplePerRealmReloadingClassLoader" --tests "ClassLoaders" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3514: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3514 | 2064681... | SimplePerRealmReloadingClassLoader, ClassLoaders | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-3514: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3514 | 2064681... | SimplePerRealmReloadingClassLoader, ClassLoaders | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-3514: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 3514 | 2064681... | SimplePerRealmReloadingClassLoader, ClassLoaders | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"

# ==========================================
# AUTO-UPDATE TASKS_STATUS.MD
# ==========================================
cd "$SCRIPT_DIR"

# Get repo full name
if [ -f "tasks.json" ]; then
    REPO_FULLNAME=$(head -50 tasks.json | grep -o '"repo" : "[^"]*"' | head -1 | cut -d'"' -f4)
else
    REPO_FULLNAME=$(basename "$(pwd)" | sed 's/-/\//')
fi

# Calculate percentage
if [ $TOTAL_COUNT -gt 0 ]; then
    VALID_PCT=$((VALID_COUNT * 100 / TOTAL_COUNT))
    PP_PCT=$((INVALID_PP_COUNT * 100 / TOTAL_COUNT))
    FF_PCT=$((INVALID_FF_COUNT * 100 / TOTAL_COUNT))
else
    VALID_PCT=0
    PP_PCT=0
    FF_PCT=0
fi

cat > "$SCRIPT_DIR/TASKS_STATUS.md" << STATUSEOF
# Task Validation Status: $REPO_FULLNAME

**VALIDATION_COMPLETE: $(date '+%Y-%m-%d %H:%M:%S')**

## Summary
- **Total Tasks:** $TOTAL_COUNT
- **VALID:** $VALID_COUNT (${VALID_PCT}%)
- **INVALID-PASS-PASS:** $INVALID_PP_COUNT (${PP_PCT}%)
- **INVALID-FAIL-FAIL:** $INVALID_FF_COUNT (${FF_PCT}%)

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)
- **ERROR**: Could not run validation

---

## Tasks

| PR # | Base Commit | Test Class(es) | After test_patch | After code_patch | Status | Notes |
|------|-------------|----------------|------------------|------------------|--------|-------|
$(echo -e "$TASK_ROWS")

---

**Validation completed:** $(date)
**Status:** COMPLETE - Ready for SWE-bench use

---

## Reproduction

\`\`\`bash
cd $(basename "$SCRIPT_DIR")
bash run-validation.sh
\`\`\`
STATUSEOF

echo ""
echo "TASKS_STATUS.md updated with completion marker in: $SCRIPT_DIR"
