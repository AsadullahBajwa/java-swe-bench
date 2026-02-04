#!/bin/bash
# Validation Script for FasterXML/jackson-core
# Generated: 2026-02-01T17:20:55.288438800

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning FasterXML/jackson-core...'
    git clone https://github.com/FasterXML/jackson-core.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1523: INVALID-PASS-PASS'
else
    echo 'PR-1523: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1520: INVALID-PASS-PASS'
else
    echo 'PR-1520: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1509: INVALID-PASS-PASS'
else
    echo 'PR-1509: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1508: INVALID-PASS-PASS'
else
    echo 'PR-1508: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1507: INVALID-PASS-PASS'
else
    echo 'PR-1507: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1505: INVALID-PASS-PASS'
else
    echo 'PR-1505: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1503: INVALID-PASS-PASS'
else
    echo 'PR-1503: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1495: INVALID-PASS-PASS'
else
    echo 'PR-1495: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1494: INVALID-PASS-PASS'
else
    echo 'PR-1494: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1492: INVALID-PASS-PASS'
else
    echo 'PR-1492: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1490: INVALID-PASS-PASS'
else
    echo 'PR-1490: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1486: INVALID-PASS-PASS'
else
    echo 'PR-1486: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1481: INVALID-PASS-PASS'
else
    echo 'PR-1481: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1478: INVALID-PASS-PASS'
else
    echo 'PR-1478: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1474: INVALID-PASS-PASS'
else
    echo 'PR-1474: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1470: INVALID-PASS-PASS'
else
    echo 'PR-1470: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1466: INVALID-PASS-PASS'
else
    echo 'PR-1466: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1460: INVALID-PASS-PASS'
else
    echo 'PR-1460: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1442: INVALID-PASS-PASS'
else
    echo 'PR-1442: INVALID-FAIL-FAIL'
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
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-1437: INVALID-PASS-PASS'
else
    echo 'PR-1437: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"
