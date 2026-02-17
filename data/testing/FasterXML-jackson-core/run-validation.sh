#!/bin/bash
# Validation Script for FasterXML/jackson-core
# Generated: 2026-02-01T17:20:55.288438800

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning FasterXML/jackson-core...'
    git clone https://github.com/FasterXML/jackson-core.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

# PR-1523
echo '=== Validating PR-1523 ==='
git checkout 5f4e7046dbf4f75dfa96b0608ca6c2fc5ed8eff8 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1523.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=NumberInputTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1523.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=NumberInputTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1523: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1523 | 5f4e704... | NumberInputTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1523: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1523 | 5f4e704... | NumberInputTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1523: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1523 | 5f4e704... | NumberInputTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1520
echo '=== Validating PR-1520 ==='
git checkout 74bc600bdf336d219d411a79a2839617b73beeef --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1520.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=LongName1516Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1520.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=LongName1516Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1520: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1520 | 74bc600... | LongName1516Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1520: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1520 | 74bc600... | LongName1516Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1520: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1520 | 74bc600... | LongName1516Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1509
echo '=== Validating PR-1509 ==='
git checkout 20e09976fb1a28ce2b46eb2ff890001bb7178a1a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1509.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ParserFilterEmpty1418Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1509.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ParserFilterEmpty1418Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1509: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1509 | 20e0997... | ParserFilterEmpty1418Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1509: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1509 | 20e0997... | ParserFilterEmpty1418Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1509: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1509 | 20e0997... | ParserFilterEmpty1418Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1508
echo '=== Validating PR-1508 ==='
git checkout d09a49dedb78f2dda46913d6e1704d8346ade75d --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1508.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=NonStandardLeadingPlusSign784Test,NonStandardNumberParsingTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1508.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=NonStandardLeadingPlusSign784Test,NonStandardNumberParsingTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1508: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1508 | d09a49d... | NonStandardLeadingPlusSign784Test,NonStandardNumberParsin... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1508: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1508 | d09a49d... | NonStandardLeadingPlusSign784Test,NonStandardNumberParsin... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1508: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1508 | d09a49d... | NonStandardLeadingPlusSign784Test,NonStandardNumberParsin... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1507
echo '=== Validating PR-1507 ==='
git checkout 1da649709a55315d6073c3b005dcd0d0f1c64f5c --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1507.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,AsyncParserRootToken1506Test,module-info,AsyncTokenRootErrorTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1507.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,AsyncParserRootToken1506Test,module-info,AsyncTokenRootErrorTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1507: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1507 | 1da6497... | AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,As... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1507: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1507 | 1da6497... | AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,As... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1507: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1507 | 1da6497... | AsyncTokenNonRootErrorTest,AsyncParserNonRootTokenTest,As... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1505
echo '=== Validating PR-1505 ==='
git checkout 8fa89c628c79f15e4fa6d6240e67e8d1bdef2f88 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1505.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTesting,AsyncPropertyNamesTest,AsyncNonStandardNumberParsingTest,AsyncCommentParsingTest,AsyncInvalidCharsTest,JacksonTestFailureExpected,AsyncRootNumbersTest,AsyncReaderWrapperForByteArray,ThrottledReader,ParserFilterEmpty1418Test,AsyncRootValuesTest,MockDataInput,JsonParserClosedCaseTest,AsyncConcurrencyByteBufferTest,GeneratorCloseTest,AsyncNaNHandlingTest,JacksonCoreTestBase,ParserErrorHandling679Test,AsyncNumberDeferredReadTest,AsyncPointerFromContext563Test,JacksonTestFailureExpectedInterceptor,AsyncParserNamesTest,AsyncSimpleObjectTest,LargeDocReadTest,Base64GenerationTest,AsyncCharEscapingTest,AsyncStringObjectTest,AsyncBinaryParseTest,ByteOutputStreamForTesting,Fuzz32208UTF32ParseTest,AsyncTokenRootErrorTest,AsyncScopeMatchingTest,ExpectedPassingTestCasePredicate,AsyncUnicodeHandlingTest,Fuzz52688ParseTest,AsyncReaderWrapperForByteBuffer,AsyncNonStdNumberHandlingTest,AsyncNonStdParsingTest,SimpleParserTest,JacksonTestShouldFailException,AsyncStringArrayTest,AsyncTestBase,AsyncScalarArrayTest,AsyncNumberCoercionTest,ParserErrorHandling105Test,AsyncMissingValuesInObjectTest,AsyncTokenNonRootErrorTest,AsyncMissingValuesInArrayTest,JacksonTestUtilBase,module-info,AsyncSimpleNestedTest,ConfigTest,ThrottledInputStream > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1505.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTesting,AsyncPropertyNamesTest,AsyncNonStandardNumberParsingTest,AsyncCommentParsingTest,AsyncInvalidCharsTest,JacksonTestFailureExpected,AsyncRootNumbersTest,AsyncReaderWrapperForByteArray,ThrottledReader,ParserFilterEmpty1418Test,AsyncRootValuesTest,MockDataInput,JsonParserClosedCaseTest,AsyncConcurrencyByteBufferTest,GeneratorCloseTest,AsyncNaNHandlingTest,JacksonCoreTestBase,ParserErrorHandling679Test,AsyncNumberDeferredReadTest,AsyncPointerFromContext563Test,JacksonTestFailureExpectedInterceptor,AsyncParserNamesTest,AsyncSimpleObjectTest,LargeDocReadTest,Base64GenerationTest,AsyncCharEscapingTest,AsyncStringObjectTest,AsyncBinaryParseTest,ByteOutputStreamForTesting,Fuzz32208UTF32ParseTest,AsyncTokenRootErrorTest,AsyncScopeMatchingTest,ExpectedPassingTestCasePredicate,AsyncUnicodeHandlingTest,Fuzz52688ParseTest,AsyncReaderWrapperForByteBuffer,AsyncNonStdNumberHandlingTest,AsyncNonStdParsingTest,SimpleParserTest,JacksonTestShouldFailException,AsyncStringArrayTest,AsyncTestBase,AsyncScalarArrayTest,AsyncNumberCoercionTest,ParserErrorHandling105Test,AsyncMissingValuesInObjectTest,AsyncTokenNonRootErrorTest,AsyncMissingValuesInArrayTest,JacksonTestUtilBase,module-info,AsyncSimpleNestedTest,ConfigTest,ThrottledInputStream > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1505: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1505 | 8fa89c6... | AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTe... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1505: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1505 | 8fa89c6... | AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTe... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1505: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1505 | 8fa89c6... | AsyncReaderWrapper,AsyncConcurrencyTest,StringWriterForTe... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1503
echo '=== Validating PR-1503 ==='
git checkout 262d9e58f458961c212e7d5bb9d71dc85685ccff --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1503.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=FastDoubleParserShadingIT,module-info > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1503.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=FastDoubleParserShadingIT,module-info > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1503: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1503 | 262d9e5... | FastDoubleParserShadingIT,module-info | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1503: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1503 | 262d9e5... | FastDoubleParserShadingIT,module-info | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1503: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1503 | 262d9e5... | FastDoubleParserShadingIT,module-info | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1495
echo '=== Validating PR-1495 ==='
git checkout 1c1914c48634f0301195f280c789c5419d871f15 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1495.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ParserFilterEmpty708Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1495.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ParserFilterEmpty708Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1495: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1495 | 1c1914c... | ParserFilterEmpty708Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1495: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1495 | 1c1914c... | ParserFilterEmpty708Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1495: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1495 | 1c1914c... | ParserFilterEmpty708Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1494
echo '=== Validating PR-1494 ==='
git checkout 873d4109cbef914f3ed450719c2ebe6b15df9250 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1494.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=UTF8SurrogateValidation363Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1494.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=UTF8SurrogateValidation363Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1494: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1494 | 873d410... | UTF8SurrogateValidation363Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1494: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1494 | 873d410... | UTF8SurrogateValidation363Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1494: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1494 | 873d410... | UTF8SurrogateValidation363Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1492
echo '=== Validating PR-1492 ==='
git checkout bac78c0f1d6c48f7aef7858951e0a65676fe4a32 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1492.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=BinaryNameMatcherTest,PropertyNameMatcher1491Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1492.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=BinaryNameMatcherTest,PropertyNameMatcher1491Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1492: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1492 | bac78c0... | BinaryNameMatcherTest,PropertyNameMatcher1491Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1492: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1492 | bac78c0... | BinaryNameMatcherTest,PropertyNameMatcher1491Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1492: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1492 | bac78c0... | BinaryNameMatcherTest,PropertyNameMatcher1491Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1490
echo '=== Validating PR-1490 ==='
git checkout c1a2db99ffd539a6a1ce645c3714ed234767c925 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1490.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=ExceptionsTest,LocationOfError1180Test,ErrorReportConfigurationTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1490.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=ExceptionsTest,LocationOfError1180Test,ErrorReportConfigurationTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1490: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1490 | c1a2db9... | ExceptionsTest,LocationOfError1180Test,ErrorReportConfigu... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1490: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1490 | c1a2db9... | ExceptionsTest,LocationOfError1180Test,ErrorReportConfigu... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1490: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1490 | c1a2db9... | ExceptionsTest,LocationOfError1180Test,ErrorReportConfigu... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1486
echo '=== Validating PR-1486 ==='
git checkout 4f23c31d363f491cab277d18a04d457b6bfbd472 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1486.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=TextBufferTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1486.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=TextBufferTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1486: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1486 | 4f23c31... | TextBufferTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1486: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1486 | 4f23c31... | TextBufferTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1486: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1486 | 4f23c31... | TextBufferTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1481
echo '=== Validating PR-1481 ==='
git checkout c2e2fcead1d3d1ddb119c1ad769161675e9036b2 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1481.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=PrettyPrinterTest,DefaultIndenterTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1481.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=PrettyPrinterTest,DefaultIndenterTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1481: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1481 | c2e2fce... | PrettyPrinterTest,DefaultIndenterTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1481: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1481 | c2e2fce... | PrettyPrinterTest,DefaultIndenterTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1481: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1481 | c2e2fce... | PrettyPrinterTest,DefaultIndenterTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1478
echo '=== Validating PR-1478 ==='
git checkout 2629fb05e4f9d9a31a696681465341e1683f7cd6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1478.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=GeneratorMiscTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1478.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=GeneratorMiscTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1478: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1478 | 2629fb0... | GeneratorMiscTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1478: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1478 | 2629fb0... | GeneratorMiscTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1478: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1478 | 2629fb0... | GeneratorMiscTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1474
echo '=== Validating PR-1474 ==='
git checkout 4975a1e7a2057520e2a995848a6f91f5f7939588 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1474.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=SurrogateWrite223Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1474.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=SurrogateWrite223Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1474: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1474 | 4975a1e... | SurrogateWrite223Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1474: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1474 | 4975a1e... | SurrogateWrite223Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1474: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1474 | 4975a1e... | SurrogateWrite223Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1470
echo '=== Validating PR-1470 ==='
git checkout 367777c00d73dfa718ae4763b7333c501ff0117a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1470.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=GeneratorCopyTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1470.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=GeneratorCopyTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1470: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1470 | 367777c... | GeneratorCopyTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1470: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1470 | 367777c... | GeneratorCopyTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1470: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1470 | 367777c... | GeneratorCopyTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1466
echo '=== Validating PR-1466 ==='
git checkout 2f6a1af4f722156bc15c0345561a19a7300d47b3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1466.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=SimpleParserTest,InputStreamInitTest,JsonFactoryTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1466.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=SimpleParserTest,InputStreamInitTest,JsonFactoryTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1466: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1466 | 2f6a1af... | SimpleParserTest,InputStreamInitTest,JsonFactoryTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1466: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1466 | 2f6a1af... | SimpleParserTest,InputStreamInitTest,JsonFactoryTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1466: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1466 | 2f6a1af... | SimpleParserTest,InputStreamInitTest,JsonFactoryTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1460
echo '=== Validating PR-1460 ==='
git checkout d61c80a6c0afea7d4e273d0603021189ecca1cf4 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1460.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1460.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1460: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1460 | d61c80a... | JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1460: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1460 | d61c80a... | JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1460: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1460 | d61c80a... | JsonWriteFeatureEscapeForwardSlashTest,TestJsonStringEncoder | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1442
echo '=== Validating PR-1442 ==='
git checkout c20ac86571ef9665ece2bad49ec37ae910ec95e9 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1442.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=JsonParserClosedCaseTest,JsonFactoryTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1442.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=JsonParserClosedCaseTest,JsonFactoryTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1442: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1442 | c20ac86... | JsonParserClosedCaseTest,JsonFactoryTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1442: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1442 | c20ac86... | JsonParserClosedCaseTest,JsonFactoryTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1442: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1442 | c20ac86... | JsonParserClosedCaseTest,JsonFactoryTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
fi
((TOTAL_COUNT++))

# PR-1437
echo '=== Validating PR-1437 ==='
git checkout 57f851672e159936f19764b840e5635474466dbc --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-1437.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -Dtest=NumberParsingGetType1433Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-1437.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -Dtest=NumberParsingGetType1433Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1437: VALID'
    ((VALID_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1437 | 57f8516... | NumberParsingGetType1433Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1437: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1437 | 57f8516... | NumberParsingGetType1433Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-1437: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 1437 | 57f8516... | NumberParsingGetType1433Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
