#!/bin/bash
# Validation Script for FasterXML/jackson-databind
# Generated: 2026-02-01T17:20:55.621945600

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning FasterXML/jackson-databind...'
    git clone https://github.com/FasterXML/jackson-databind.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-5622
echo '=== Validating PR-5622 ==='
git checkout 3db1dbbdde8f9340af62d2feaf63e44ab9c7f0f6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5622.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=DefaultTypingOverride1391Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5622.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=DefaultTypingOverride1391Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5622: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5622 | 3db1dbb... | DefaultTypingOverride1391Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5622: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5622 | 3db1dbb... | DefaultTypingOverride1391Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5622: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5622 | 3db1dbb... | DefaultTypingOverride1391Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5621
echo '=== Validating PR-5621 ==='
git checkout 3db1dbbdde8f9340af62d2feaf63e44ab9c7f0f6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5621.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JacksonInject1381Test,JacksonInject3072Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5621.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JacksonInject1381Test,JacksonInject3072Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5621: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5621 | 3db1dbb... | JacksonInject1381Test,JacksonInject3072Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5621: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5621 | 3db1dbb... | JacksonInject1381Test,JacksonInject3072Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5621: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5621 | 3db1dbb... | JacksonInject1381Test,JacksonInject3072Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5620
echo '=== Validating PR-5620 ==='
git checkout 8c8bd3dbc0ade33ed96b7432acdcdd150c793086 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5620.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AtomicTypeSerializationTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5620.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AtomicTypeSerializationTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5620: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5620 | 8c8bd3d... | AtomicTypeSerializationTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5620: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5620 | 8c8bd3d... | AtomicTypeSerializationTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5620: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5620 | 8c8bd3d... | AtomicTypeSerializationTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5619
echo '=== Validating PR-5619 ==='
git checkout e7d051a5cbfde7b59e235f2ceaa38f098137f1a3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5619.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OptionalSubtypeSerializationTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5619.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OptionalSubtypeSerializationTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5619: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5619 | e7d051a... | OptionalSubtypeSerializationTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5619: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5619 | e7d051a... | OptionalSubtypeSerializationTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5619: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5619 | e7d051a... | OptionalSubtypeSerializationTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5614
echo '=== Validating PR-5614 ==='
git checkout 0c4c8f9ba6138025791e2105b9fd0f18af8cc8e9 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5614.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FunctionalScalarDeserializer4004Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5614.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FunctionalScalarDeserializer4004Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5614: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5614 | 0c4c8f9... | FunctionalScalarDeserializer4004Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5614: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5614 | 0c4c8f9... | FunctionalScalarDeserializer4004Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5614: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5614 | 0c4c8f9... | FunctionalScalarDeserializer4004Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5613
echo '=== Validating PR-5613 ==='
git checkout 19c42ead6449f7e23e0a05692925d6b30c1378ce --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5613.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JavaUtilDateSerializationTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5613.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JavaUtilDateSerializationTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5613: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5613 | 19c42ea... | JavaUtilDateSerializationTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5613: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5613 | 19c42ea... | JavaUtilDateSerializationTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5613: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5613 | 19c42ea... | JavaUtilDateSerializationTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5612
echo '=== Validating PR-5612 ==='
git checkout fe73c27e3a76bb14265ab4c558ab81ff4d22f074 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5612.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=OffsetTimeDeserTest,MonthDeserializerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5612.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=OffsetTimeDeserTest,MonthDeserializerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5612: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5612 | fe73c27... | OffsetTimeDeserTest,MonthDeserializerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5612: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5612 | fe73c27... | OffsetTimeDeserTest,MonthDeserializerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5612: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5612 | fe73c27... | OffsetTimeDeserTest,MonthDeserializerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5611
echo '=== Validating PR-5611 ==='
git checkout 540722065dabad138b41eeb4804bc896f31178d3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5611.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonNodeAsContainerTest,JsonNodeConversionsTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5611.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonNodeAsContainerTest,JsonNodeConversionsTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5611: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5611 | 5407220... | JsonNodeAsContainerTest,JsonNodeConversionsTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5611: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5611 | 5407220... | JsonNodeAsContainerTest,JsonNodeConversionsTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5611: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5611 | 5407220... | JsonNodeAsContainerTest,JsonNodeConversionsTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5606
echo '=== Validating PR-5606 ==='
git checkout e5dfb2e8e6c2eeb0e083409d5cd91c84740e2efc --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5606.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ObjectNodeTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5606.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ObjectNodeTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5606: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5606 | e5dfb2e... | ObjectNodeTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5606: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5606 | e5dfb2e... | ObjectNodeTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5606: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5606 | e5dfb2e... | ObjectNodeTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5604
echo '=== Validating PR-5604 ==='
git checkout a2aa480528b6e426dce19c72737202ab93edb8ca --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5604.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AccessorNamingForBuilderTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5604.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AccessorNamingForBuilderTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5604: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5604 | a2aa480... | AccessorNamingForBuilderTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5604: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5604 | a2aa480... | AccessorNamingForBuilderTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5604: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5604 | a2aa480... | AccessorNamingForBuilderTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5603
echo '=== Validating PR-5603 ==='
git checkout ddc955d41ceb8f1f365590b49a1b0607d55b5557 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5603.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ConverterFromInterface2617Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5603.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ConverterFromInterface2617Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5603: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5603 | ddc955d... | ConverterFromInterface2617Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5603: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5603 | ddc955d... | ConverterFromInterface2617Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5603: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5603 | ddc955d... | ConverterFromInterface2617Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5600
echo '=== Validating PR-5600 ==='
git checkout b2463a27be81da52cfdb12f9f595d69bf1f28a13 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5600.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5600.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5600: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5600 | b2463a2... | FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5600: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5600 | b2463a2... | FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5600: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5600 | b2463a2... | FormatVisitor5393Test,NewSchemaTest,ViewsWithSchemaTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5595
echo '=== Validating PR-5595 ==='
git checkout bd24fa564538bbda6ea4ba162c7e1a6739599f07 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5595.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FunctionalScalarDeserializer4004Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5595.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FunctionalScalarDeserializer4004Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5595: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5595 | bd24fa5... | FunctionalScalarDeserializer4004Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5595: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5595 | bd24fa5... | FunctionalScalarDeserializer4004Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5595: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5595 | bd24fa5... | FunctionalScalarDeserializer4004Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5591
echo '=== Validating PR-5591 ==='
git checkout 96679ae8546db09ead6c70b43e6c1793eb65f793 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5591.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectIdReordering1388Test,AbstractWithObjectIdTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5591.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectIdReordering1388Test,AbstractWithObjectIdTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5591: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5591 | 96679ae... | ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectId... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5591: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5591 | 96679ae... | ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectId... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5591: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5591 | 96679ae... | ObjectIdInObjectArray5413Test,Base64DecodingTest,ObjectId... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5587
echo '=== Validating PR-5587 ==='
git checkout 182b3bda37223b0cd0f2ac144cbfa16c82d4b561 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5587.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ArrayNodeTest,TreeTraversingParserTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5587.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ArrayNodeTest,TreeTraversingParserTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5587: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5587 | 182b3bd... | ArrayNodeTest,TreeTraversingParserTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5587: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5587 | 182b3bd... | ArrayNodeTest,TreeTraversingParserTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5587: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5587 | 182b3bd... | ArrayNodeTest,TreeTraversingParserTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5584
echo '=== Validating PR-5584 ==='
git checkout 5708c4d10a7be71a8a83780f4da53d1f7d1bd6cb --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5584.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,MissingNodeTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,JsonNodeBigIntegerValueTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5584.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,MissingNodeTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,JsonNodeBigIntegerValueTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5584: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5584 | 5708c4d... | JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTe... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5584: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5584 | 5708c4d... | JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTe... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5584: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5584 | 5708c4d... | JsonNodeLongValueTest,POJONodeTest,JsonNodeDecimalValueTe... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5582
echo '=== Validating PR-5582 ==='
git checkout 6144f64acc4e9f478c2a24c4524cdd31a030cf3e --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5582.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonNodeMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5582.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonNodeMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5582: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5582 | 6144f64... | JsonNodeMapTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5582: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5582 | 6144f64... | JsonNodeMapTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5582: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5582 | 6144f64... | JsonNodeMapTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5580
echo '=== Validating PR-5580 ==='
git checkout 52aeb0aca9e4256dd85bfd880bdb84d5d9f53a66 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5580.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonNodeMapTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5580.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonNodeMapTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5580: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5580 | 52aeb0a... | JsonNodeMapTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5580: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5580 | 52aeb0a... | JsonNodeMapTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5580: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5580 | 52aeb0a... | JsonNodeMapTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-5577
echo '=== Validating PR-5577 ==='
git checkout 6eb4224c756a6479091ffeb4c6a01ec688ed4c02 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-5577.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,JsonNodeNumberValueTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,TreeTraversingParserTest,JsonNodeBigIntegerValueTest,Base64DecodingTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-5577.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFloatValueTest,JsonNodeIntValueTest,JsonNodeNumberValueTest,JsonNodeStringValueTest,JsonNodeDoubleValueTest,TreeTraversingParserTest,JsonNodeBigIntegerValueTest,Base64DecodingTest,JsonNodeShortValueTest,JsonNodeBooleanValueTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5577: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5577 | 6eb4224... | JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFl... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-5577: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5577 | 6eb4224... | JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFl... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-5577: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 5577 | 6eb4224... | JsonNodeLongValueTest,JsonNodeDecimalValueTest,JsonNodeFl... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
