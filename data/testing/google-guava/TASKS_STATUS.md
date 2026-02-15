# Task Validation Status: google/guava

Generated: 2026-02-01T17:20:55.469823800

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
| 8188 | 8138afb... | UninterruptiblesTest | PENDING | PENDING | PENDING | |
| 8187 | 175bac9... | PreconditionsTest, MacHashFunctionTest, FluentIterableTest, MessageDigestHashFunctionTest | PENDING | PENDING | PENDING | |
| 8184 | a63e360... | CacheLoadingTest, FuturesTest, JSR166TestCase, UninterruptiblesTest | PENDING | PENDING | PENDING | |
| 8166 | 0bf8704... | OrderingTest | PENDING | PENDING | PENDING | |
| 8155 | 64d70b9... | AbstractImmutableSortedMapMapInterfaceTest, AbstractImmutableBiMapMapInterfaceTest, AbstractImmutableMapMapInterfaceTest, SynchronizedSetTest, GraphsTest | PENDING | PENDING | PENDING | |
| 8153 | cf92c28... | ImmutableSortedMapTest, ContiguousSetTest | PENDING | PENDING | PENDING | |
| 8150 | 8df9232... | ContiguousSetTest | PENDING | PENDING | PENDING | |
| 8149 | fb02c34... | ListsTest, CharSequenceReaderTest, SpecialRandom | PENDING | PENDING | PENDING | |
| 8139 | d8aef62... | DoubleUtilsTest, ThreadFactoryBuilderTest, NullPointerTesterTest, FauxveridesTest | PENDING | PENDING | PENDING | |
| 8134 | 071ab9f... | MoreExecutorsTest, AbstractClosingFutureTest, ImmutableEnumMapTest, RateLimiterTest | PENDING | PENDING | PENDING | |
| 8128 | 32ee2f6... | ForwardingNavigableMapTest | PENDING | PENDING | PENDING | |
| 8125 | 98107f9... | ImmutableDoubleArrayTest, ImmutableLongArrayTest, ImmutableIntArrayTest | PENDING | PENDING | PENDING | |
| 8118 | db23a83... | UnsignedBytesTest | PENDING | PENDING | PENDING | |
| 8114 | 0011c01... | ConcurrentHashMultisetBasherTest, ConcurrentHashMultisetTest | PENDING | PENDING | PENDING | |
| 8091 | a6110d3... | ImmutableListMultimapTest, CollectSpliteratorsTest, ImmutableEnumMapTest, ImmutableMapTest | PENDING | PENDING | PENDING | |
| 8081 | 12878d7... | InternetDomainNameTest | PENDING | PENDING | PENDING | |
| 8080 | 8cfa76f... | QueuesTest | PENDING | PENDING | PENDING | |
| 8067 | fb862e5... | FileBackedOutputStreamTest | PENDING | PENDING | PENDING | |
| 8052 | 83869af... | OrderingTest, LinkedHashMultimapTest | PENDING | PENDING | PENDING | |
| 8045 | b53231b... | AbstractGraphTest, ValueGraphTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/google/guava.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
