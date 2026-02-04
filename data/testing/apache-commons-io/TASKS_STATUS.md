# Task Validation Status: apache/commons-io

Generated: 2026-02-01T17:20:55.551832900

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
| 818 | 8f66b32... | IOUtilsTest | PENDING | PENDING | PENDING | |
| 817 | 3557766... | ByteArraySeekableByteChannelCompressTest, AbstractSeekableByteChannelTest, ByteArraySeekableByteChannelTest | PENDING | PENDING | PENDING | |
| 801 | c28dc1b... | IOCaseTest, IOUtilsConcurrentTest | PENDING | PENDING | PENDING | |
| 800 | b95cbfa... | CloseShieldChannelTest | PENDING | PENDING | PENDING | |
| 799 | f51d19c... | CloseShieldChannelTest | PENDING | PENDING | PENDING | |
| 796 | 07d2cd9... | IOUtilsTest | PENDING | PENDING | PENDING | |
| 795 | 07d2cd9... | IOUtilsTest | PENDING | PENDING | PENDING | |
| 790 | 66db0c6... | BrokenReaderTest, ClosedInputStreamTest, MarkShieldInputStreamTest, BrokenWriterTest, ClosedWriterTest, IOUtilsTest, ByteArrayOutputStreamTest, NullAppendableTest, NullWriterTest, ProxyReaderTest, NullInputStreamTest, ProxyWriterTest, NullOutputStreamTest, UnsynchronizedBufferedReaderTest, ClosedReaderTest | PENDING | PENDING | PENDING | |
| 786 | 3c0677e... | CloseShieldChannelTest | PENDING | PENDING | PENDING | |
| 785 | a96ae74... | IOUtilsTest | PENDING | PENDING | PENDING | |
| 784 | 886ebfc... | CharSequenceOriginTest, PathOriginTest, ByteArraySeekableByteChannelCompressTest, IORandomAccessFileOriginTest, FileOriginTest, URIOriginTest, OutputStreamOriginTest, ReaderOriginTest, AbstractStreamBuilderTest, ByteArrayOriginTest, ByteArraySeekableByteChannelTest, AbstractRandomAccessFileOriginTest, ChannelOriginTest, InputStreamOriginTest, WriterStreamOriginTest, AbstractOriginTest, RandomAccessFileOriginTest | PENDING | PENDING | PENDING | |
| 781 | cd20ece... | FileSystemTest | PENDING | PENDING | PENDING | |
| 779 | 28873d1... | BoundedInputStreamTest | PENDING | PENDING | PENDING | |
| 776 | e205fb9... | IOUtilsTest | PENDING | PENDING | PENDING | |
| 763 | ea8ba68... | FileUtilsTest | PENDING | PENDING | PENDING | |
| 758 | 4fe3854... | ByteArrayOutputStreamTest | PENDING | PENDING | PENDING | |
| 757 | 4fe3854... | TailerTest | PENDING | PENDING | PENDING | |
| 756 | 53371a2... | FileUtilsTest | PENDING | PENDING | PENDING | |
| 748 | 5080fa3... | QueueInputStreamTest, QueueStreamBenchmark | PENDING | PENDING | PENDING | |
| 744 | 41419d1... | FileUtilsTest | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/apache/commons-io.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
