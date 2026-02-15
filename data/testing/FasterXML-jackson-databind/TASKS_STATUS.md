# Task Validation Status: FasterXML/jackson-databind

Generated: 2026-02-01T17:20:55.619943100

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
| 5622 | 3db1dbb... | DefaultTypingOverride1391Test | PENDING | PENDING | PENDING | |
| 5621 | 3db1dbb... | JacksonInject1381Test, JacksonInject3072Test | PENDING | PENDING | PENDING | |
| 5620 | 8c8bd3d... | AtomicTypeSerializationTest | PENDING | PENDING | PENDING | |
| 5619 | e7d051a... | OptionalSubtypeSerializationTest | PENDING | PENDING | PENDING | |
| 5614 | 0c4c8f9... | FunctionalScalarDeserializer4004Test | PENDING | PENDING | PENDING | |
| 5613 | 19c42ea... | JavaUtilDateSerializationTest | PENDING | PENDING | PENDING | |
| 5612 | fe73c27... | OffsetTimeDeserTest, MonthDeserializerTest | PENDING | PENDING | PENDING | |
| 5611 | 5407220... | JsonNodeAsContainerTest, JsonNodeConversionsTest | PENDING | PENDING | PENDING | |
| 5606 | e5dfb2e... | ObjectNodeTest | PENDING | PENDING | PENDING | |
| 5604 | a2aa480... | AccessorNamingForBuilderTest | PENDING | PENDING | PENDING | |
| 5603 | ddc955d... | ConverterFromInterface2617Test | PENDING | PENDING | PENDING | |
| 5600 | b2463a2... | FormatVisitor5393Test, NewSchemaTest, ViewsWithSchemaTest | PENDING | PENDING | PENDING | |
| 5595 | bd24fa5... | FunctionalScalarDeserializer4004Test | PENDING | PENDING | PENDING | |
| 5591 | 96679ae... | ObjectIdInObjectArray5413Test, Base64DecodingTest, ObjectIdReordering1388Test, AbstractWithObjectIdTest | PENDING | PENDING | PENDING | |
| 5587 | 182b3bd... | ArrayNodeTest, TreeTraversingParserTest | PENDING | PENDING | PENDING | |
| 5584 | 5708c4d... | JsonNodeLongValueTest, POJONodeTest, JsonNodeDecimalValueTest, JsonNodeFloatValueTest, JsonNodeIntValueTest, MissingNodeTest, JsonNodeStringValueTest, JsonNodeDoubleValueTest, JsonNodeBigIntegerValueTest, JsonNodeShortValueTest, JsonNodeBooleanValueTest | PENDING | PENDING | PENDING | |
| 5582 | 6144f64... | JsonNodeMapTest | PENDING | PENDING | PENDING | |
| 5580 | 52aeb0a... | JsonNodeMapTest | PENDING | PENDING | PENDING | |
| 5577 | 6eb4224... | JsonNodeLongValueTest, JsonNodeDecimalValueTest, JsonNodeFloatValueTest, JsonNodeIntValueTest, JsonNodeNumberValueTest, JsonNodeStringValueTest, JsonNodeDoubleValueTest, TreeTraversingParserTest, JsonNodeBigIntegerValueTest, Base64DecodingTest, JsonNodeShortValueTest, JsonNodeBooleanValueTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/FasterXML/jackson-databind.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
