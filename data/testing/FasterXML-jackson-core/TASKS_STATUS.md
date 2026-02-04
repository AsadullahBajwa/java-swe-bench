# Task Validation Status: FasterXML/jackson-core

Generated: 2026-02-01T17:20:55.280438

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
| 1523 | 5f4e704... | NumberInputTest | PENDING | PENDING | PENDING | |
| 1520 | 74bc600... | LongName1516Test | PENDING | PENDING | PENDING | |
| 1509 | 20e0997... | ParserFilterEmpty1418Test | PENDING | PENDING | PENDING | |
| 1508 | d09a49d... | NonStandardLeadingPlusSign784Test, NonStandardNumberParsingTest | PENDING | PENDING | PENDING | |
| 1507 | 1da6497... | AsyncTokenNonRootErrorTest, AsyncParserNonRootTokenTest, AsyncParserRootToken1506Test, module-info, AsyncTokenRootErrorTest | PENDING | PENDING | PENDING | |
| 1505 | 8fa89c6... | AsyncReaderWrapper, AsyncConcurrencyTest, StringWriterForTesting, AsyncPropertyNamesTest, AsyncNonStandardNumberParsingTest, AsyncCommentParsingTest, AsyncInvalidCharsTest, JacksonTestFailureExpected, AsyncRootNumbersTest, AsyncReaderWrapperForByteArray, ThrottledReader, ParserFilterEmpty1418Test, AsyncRootValuesTest, MockDataInput, JsonParserClosedCaseTest, AsyncConcurrencyByteBufferTest, GeneratorCloseTest, AsyncNaNHandlingTest, JacksonCoreTestBase, ParserErrorHandling679Test, AsyncNumberDeferredReadTest, AsyncPointerFromContext563Test, JacksonTestFailureExpectedInterceptor, AsyncParserNamesTest, AsyncSimpleObjectTest, LargeDocReadTest, Base64GenerationTest, AsyncCharEscapingTest, AsyncStringObjectTest, AsyncBinaryParseTest, ByteOutputStreamForTesting, Fuzz32208UTF32ParseTest, AsyncTokenRootErrorTest, AsyncScopeMatchingTest, ExpectedPassingTestCasePredicate, AsyncUnicodeHandlingTest, Fuzz52688ParseTest, AsyncReaderWrapperForByteBuffer, AsyncNonStdNumberHandlingTest, AsyncNonStdParsingTest, SimpleParserTest, JacksonTestShouldFailException, AsyncStringArrayTest, AsyncTestBase, AsyncScalarArrayTest, AsyncNumberCoercionTest, ParserErrorHandling105Test, AsyncMissingValuesInObjectTest, AsyncTokenNonRootErrorTest, AsyncMissingValuesInArrayTest, JacksonTestUtilBase, module-info, AsyncSimpleNestedTest, ConfigTest, ThrottledInputStream | PENDING | PENDING | PENDING | |
| 1503 | 262d9e5... | FastDoubleParserShadingIT, module-info | PENDING | PENDING | PENDING | |
| 1495 | 1c1914c... | ParserFilterEmpty708Test | PENDING | PENDING | PENDING | |
| 1494 | 873d410... | UTF8SurrogateValidation363Test | PENDING | PENDING | PENDING | |
| 1492 | bac78c0... | BinaryNameMatcherTest, PropertyNameMatcher1491Test | PENDING | PENDING | PENDING | |
| 1490 | c1a2db9... | ExceptionsTest, LocationOfError1180Test, ErrorReportConfigurationTest | PENDING | PENDING | PENDING | |
| 1486 | 4f23c31... | TextBufferTest | PENDING | PENDING | PENDING | |
| 1481 | c2e2fce... | PrettyPrinterTest, DefaultIndenterTest | PENDING | PENDING | PENDING | |
| 1478 | 2629fb0... | GeneratorMiscTest | PENDING | PENDING | PENDING | |
| 1474 | 4975a1e... | SurrogateWrite223Test | PENDING | PENDING | PENDING | |
| 1470 | 367777c... | GeneratorCopyTest | PENDING | PENDING | PENDING | |
| 1466 | 2f6a1af... | SimpleParserTest, InputStreamInitTest, JsonFactoryTest | PENDING | PENDING | PENDING | |
| 1460 | d61c80a... | JsonWriteFeatureEscapeForwardSlashTest, TestJsonStringEncoder | PENDING | PENDING | PENDING | |
| 1442 | c20ac86... | JsonParserClosedCaseTest, JsonFactoryTest | PENDING | PENDING | PENDING | |
| 1437 | 57f8516... | NumberParsingGetType1433Test | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/FasterXML/jackson-core.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
