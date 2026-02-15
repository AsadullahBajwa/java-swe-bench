# Task Validation Status: netty/netty

Generated: 2026-02-01T17:20:55.587352200

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
| 16195 | dc7bc7f... | ReadOnlyByteBufTest | PENDING | PENDING | PENDING | |
| 16193 | dc7bc7f... | JdkSslEngineTest, OpenSslErrorStackAssertSSLEngine | PENDING | PENDING | PENDING | |
| 16188 | ccc5570... | ReadOnlyByteBufTest | PENDING | PENDING | PENDING | |
| 16172 | 2af3d13... | DefaultThreadFactoryTest, PlatformDependent0Test | PENDING | PENDING | PENDING | |
| 16170 | c9b74c3... | QuicChannelConnectTest | PENDING | PENDING | PENDING | |
| 16169 | c9b74c3... | QuicTransportParametersTest | PENDING | PENDING | PENDING | |
| 16164 | c9b74c3... | NonStickyEventExecutorGroupTest, UnorderedThreadPoolEventExecutorTest | PENDING | PENDING | PENDING | |
| 16163 | 26fadc1... | QuicChannelConnectTest | PENDING | PENDING | PENDING | |
| 16162 | 26fadc1... | QuicTransportParametersTest | PENDING | PENDING | PENDING | |
| 16157 | 6008169... | NonStickyEventExecutorGroupTest, SingleThreadEventExecutorTest, AbstractSingleThreadEventLoopTest, ManualIoEventLoopTest, DefaultPromiseTest, SingleThreadEventLoopTest, AbstractScheduledEventExecutorTest, ThreadExecutorMapTest, TrafficShapingHandlerTest, DefaultChannelPipelineTest, NioEventLoopTest, FileRegionThrottleTest | PENDING | PENDING | PENDING | |
| 16155 | 6008169... | Http2ConnectionHandlerTest | PENDING | PENDING | PENDING | |
| 16154 | 496f55c... | Http2ConnectionHandlerTest | PENDING | PENDING | PENDING | |
| 16153 | ba8fbaa... | Http2ConnectionHandlerTest | PENDING | PENDING | PENDING | |
| 16152 | 16ba19e... | DefaultChannelPipelineTest | PENDING | PENDING | PENDING | |
| 16151 | 33ac30b... | DatagramConnectedWriteExceptionTest, IoUringSocketTestPermutation, IoUringDatagramConnectedWriteExceptionTest, KQueueDatagramConnectedWriteExceptionTest | PENDING | PENDING | PENDING | |
| 16150 | f80b70c... | DatagramConnectedWriteExceptionTest, KQueueDatagramConnectedWriteExceptionTest | PENDING | PENDING | PENDING | |
| 16143 | 1155c46... | SniHandlerTest, CipherSuiteCanaryTest, OpenSslPrivateKeyMethodTest, ChannelOutboundBufferTest, DefaultPromiseTest, PromiseNotifierTest, DnsNameResolverTest, DefaultChannelPipelineTest, SocketCancelWriteTest, SocketConnectionAttemptTest | PENDING | PENDING | PENDING | |
| 16118 | f84f78b... | OcspClientTest | PENDING | PENDING | PENDING | |
| 16117 | 627c3b7... | EmbeddedQuicChannel | PENDING | PENDING | PENDING | |

---

## Validation Commands

```bash
# 1. Clone repository (if not already cloned)
git clone https://github.com/netty/netty.git repo

# 2. For each PR, run validation:
# Example for PR-XXXX:
cd repo
git checkout {base_commit}
git apply ../patches/test-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should FAIL
git apply ../patches/code-patch-XXXX.patch
mvn test -Dtest=TestClassName  # Should PASS
```
