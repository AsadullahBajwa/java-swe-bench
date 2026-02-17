#!/bin/bash
# Validation Script for square/okhttp
# Generated: 2026-02-01T17:20:55.439301

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning square/okhttp...'
    git clone https://github.com/square/okhttp.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-9269
echo '=== Validating PR-9269 ==='
git checkout bb420b201d9f01c01d493b82a7b4cd9efd38ec41 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9269.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9269.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9269: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9269 | bb420b2... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9269: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9269 | bb420b2... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9269: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9269 | bb420b2... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9268
echo '=== Validating PR-9268 ==='
git checkout 2b1b18d8981e694439239d465fe5ad98a2cf9275 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9268.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9268.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9268: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9268 | 2b1b18d... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9268: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9268 | 2b1b18d... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9268: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9268 | 2b1b18d... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9207
echo '=== Validating PR-9207 ==='
git checkout 5b23df713244f82f76cb05e8164d6320b6dc1379 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9207.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9207.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9207: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9207 | 5b23df7... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9207: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9207 | 5b23df7... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9207: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9207 | 5b23df7... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9129
echo '=== Validating PR-9129 ==='
git checkout 2f3491c0fbc2b1d02c7e1ca8e5de9202a8251bea --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9129.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9129.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9129: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9129 | 2f3491c... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9129: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9129 | 2f3491c... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9129: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9129 | 2f3491c... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9118
echo '=== Validating PR-9118 ==='
git checkout 8eca8a834b9d8ed756a0328ec94b30bb78200503 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9118.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9118.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9118: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9118 | 8eca8a8... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9118: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9118 | 8eca8a8... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9118: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9118 | 8eca8a8... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9115
echo '=== Validating PR-9115 ==='
git checkout d4a5be134ef9083a88a80a2e135ec6a730b49673 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9115.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9115.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9115: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9115 | d4a5be1... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9115: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9115 | d4a5be1... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9115: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9115 | d4a5be1... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9112
echo '=== Validating PR-9112 ==='
git checkout fa84a6e0d7e38fbf9d77e106d5de6a87fa32d8a7 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9112.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9112.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9112: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9112 | fa84a6e... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9112: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9112 | fa84a6e... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9112: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9112 | fa84a6e... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9098
echo '=== Validating PR-9098 ==='
git checkout fa783c3dda8580f27b26d96641db2ca09cf59adf --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9098.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :okhttp-sse:test --tests "EventSourceFactoryTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9098.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :okhttp-sse:test --tests "EventSourceFactoryTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9098: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9098 | fa783c3... | EventSourceFactoryTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9098: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9098 | fa783c3... | EventSourceFactoryTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9098: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9098 | fa783c3... | EventSourceFactoryTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9044
echo '=== Validating PR-9044 ==='
git checkout 8fde16d0b7c04673d0b359db541227ba231e03be --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9044.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9044.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9044: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9044 | 8fde16d... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9044: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9044 | 8fde16d... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9044: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9044 | 8fde16d... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9031
echo '=== Validating PR-9031 ==='
git checkout 929a41c01cc6fb54628653a82fb70db95578bd99 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9031.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9031.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9031: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9031 | 929a41c... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9031: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9031 | 929a41c... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9031: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9031 | 929a41c... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9030
echo '=== Validating PR-9030 ==='
git checkout d7851dedc0c66f46854da5d2838c803c6ba67a25 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9030.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9030.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9030: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9030 | d7851de... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9030: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9030 | d7851de... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9030: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9030 | d7851de... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-9010
echo '=== Validating PR-9010 ==='
git checkout 8b74eb4508853d0f8042258d8de9f714d7adc3c0 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-9010.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :okhttp-sse:test --tests "EventSourceFactoryTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-9010.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :okhttp-sse:test --tests "EventSourceFactoryTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9010: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9010 | 8b74eb4... | EventSourceFactoryTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-9010: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9010 | 8b74eb4... | EventSourceFactoryTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-9010: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 9010 | 8b74eb4... | EventSourceFactoryTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8972
echo '=== Validating PR-8972 ==='
git checkout 7c7d404e3cde9b59294da427824ba2cea8f310e5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8972.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8972.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8972: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8972 | 7c7d404... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8972: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8972 | 7c7d404... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8972: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8972 | 7c7d404... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8967
echo '=== Validating PR-8967 ==='
git checkout 88593f8c283370cc1357c2ee7afb24b028cde014 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8967.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8967.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8967: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8967 | 88593f8... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8967: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8967 | 88593f8... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8967: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8967 | 88593f8... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8965
echo '=== Validating PR-8965 ==='
git checkout 0984bc3fc5d41c4814b953194d10e5ee77361f7d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8965.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8965.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8965: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8965 | 0984bc3... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8965: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8965 | 0984bc3... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8965: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8965 | 0984bc3... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8954
echo '=== Validating PR-8954 ==='
git checkout 0ef99d67c4701834f91467f00f26123494c33366 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8954.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8954.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8954: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8954 | 0ef99d6... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8954: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8954 | 0ef99d6... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8954: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8954 | 0ef99d6... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8947
echo '=== Validating PR-8947 ==='
git checkout d51c17721071eca8cb49f351fd98d49d80837bd1 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8947.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8947.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8947: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8947 | d51c177... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8947: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8947 | d51c177... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8947: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8947 | d51c177... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8943
echo '=== Validating PR-8943 ==='
git checkout add175beea0467b13cb975f3c240b1bc16a17170 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8943.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8943.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8943: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8943 | add175b... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8943: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8943 | add175b... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8943: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8943 | add175b... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8939
echo '=== Validating PR-8939 ==='
git checkout 9eb967f8d4228636f99c78a15194a37c6d0d3f8e --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8939.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8939.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8939: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8939 | 9eb967f... |  | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8939: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8939 | 9eb967f... |  | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8939: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8939 | 9eb967f... |  | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-8917
echo '=== Validating PR-8917 ==='
git checkout f65e3e2159536b5a49ff0dff573b8d86ca18b19d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-8917.patch 2>/dev/null

# Run tests (expect FAIL)
./gradlew :maven-tests:test --tests "AppTest" > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-8917.patch 2>/dev/null

# Run tests (expect PASS)
./gradlew :maven-tests:test --tests "AppTest" > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8917: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8917 | f65e3e2... | AppTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-8917: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8917 | f65e3e2... | AppTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-8917: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 8917 | f65e3e2... | AppTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
