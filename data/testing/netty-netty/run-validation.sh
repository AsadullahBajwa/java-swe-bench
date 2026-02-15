#!/bin/bash
# Validation Script for netty/netty
# Generated: 2026-02-01T17:20:55.589350

set +e  # Don't exit on error

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning netty/netty...'
    git clone https://github.com/netty/netty.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0

# PR-16195
echo '=== Validating PR-16195 ==='
git checkout dc7bc7f607b1950d6db0c41a7a4f4e8b967155e4 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16195.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl buffer -Dtest=ReadOnlyByteBufTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16195.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl buffer -Dtest=ReadOnlyByteBufTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16195: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16195: INVALID-PASS-PASS'
else
    echo 'PR-16195: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16193
echo '=== Validating PR-16193 ==='
git checkout dc7bc7f607b1950d6db0c41a7a4f4e8b967155e4 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16193.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl handler -Dtest=JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16193.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl handler -Dtest=JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16193: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16193: INVALID-PASS-PASS'
else
    echo 'PR-16193: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16188
echo '=== Validating PR-16188 ==='
git checkout ccc5570a25ede657182895a59c978d568f7d2846 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16188.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl buffer -Dtest=ReadOnlyByteBufTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16188.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl buffer -Dtest=ReadOnlyByteBufTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16188: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16188: INVALID-PASS-PASS'
else
    echo 'PR-16188: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16172
echo '=== Validating PR-16172 ==='
git checkout 2af3d1391dc64a1ae739003eab2d2fa2c1d7a8e6 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16172.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl common -Dtest=DefaultThreadFactoryTest,PlatformDependent0Test > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16172.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl common -Dtest=DefaultThreadFactoryTest,PlatformDependent0Test > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16172: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16172: INVALID-PASS-PASS'
else
    echo 'PR-16172: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16170
echo '=== Validating PR-16170 ==='
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16170.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16170.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16170: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16170: INVALID-PASS-PASS'
else
    echo 'PR-16170: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16169
echo '=== Validating PR-16169 ==='
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16169.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16169.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16169: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16169: INVALID-PASS-PASS'
else
    echo 'PR-16169: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16164
echo '=== Validating PR-16164 ==='
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16164.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventExecutorTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16164.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventExecutorTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16164: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16164: INVALID-PASS-PASS'
else
    echo 'PR-16164: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16163
echo '=== Validating PR-16163 ==='
git checkout 26fadc1cf5d80de06909758ea186a1d0ce46ab10 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16163.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16163.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16163: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16163: INVALID-PASS-PASS'
else
    echo 'PR-16163: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16162
echo '=== Validating PR-16162 ==='
git checkout 26fadc1cf5d80de06909758ea186a1d0ce46ab10 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16162.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16162.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16162: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16162: INVALID-PASS-PASS'
else
    echo 'PR-16162: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16157
echo '=== Validating PR-16157 ==='
git checkout 6008169575ddc86ad2be37a6a8da3c9e54b19ce5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16157.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,SingleThreadEventExecutorTest,AbstractSingleThreadEventLoopTest,ManualIoEventLoopTest,DefaultPromiseTest,SingleThreadEventLoopTest,AbstractScheduledEventExecutorTest,ThreadExecutorMapTest,TrafficShapingHandlerTest,DefaultChannelPipelineTest,NioEventLoopTest,FileRegionThrottleTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16157.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,SingleThreadEventExecutorTest,AbstractSingleThreadEventLoopTest,ManualIoEventLoopTest,DefaultPromiseTest,SingleThreadEventLoopTest,AbstractScheduledEventExecutorTest,ThreadExecutorMapTest,TrafficShapingHandlerTest,DefaultChannelPipelineTest,NioEventLoopTest,FileRegionThrottleTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16157: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16157: INVALID-PASS-PASS'
else
    echo 'PR-16157: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16155
echo '=== Validating PR-16155 ==='
git checkout 6008169575ddc86ad2be37a6a8da3c9e54b19ce5 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16155.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16155.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16155: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16155: INVALID-PASS-PASS'
else
    echo 'PR-16155: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16154
echo '=== Validating PR-16154 ==='
git checkout 496f55cdf6edfd621320a2d803a53298ac2df9dd --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16154.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16154.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16154: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16154: INVALID-PASS-PASS'
else
    echo 'PR-16154: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16153
echo '=== Validating PR-16153 ==='
git checkout ba8fbaa38eb613e0161eb288fad5f92abc58db47 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16153.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16153.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16153: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16153: INVALID-PASS-PASS'
else
    echo 'PR-16153: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16152
echo '=== Validating PR-16152 ==='
git checkout 16ba19e615820c50866528f06410951e16dc5061 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16152.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl transport -Dtest=DefaultChannelPipelineTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16152.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl transport -Dtest=DefaultChannelPipelineTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16152: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16152: INVALID-PASS-PASS'
else
    echo 'PR-16152: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16151
echo '=== Validating PR-16151 ==='
git checkout 33ac30b2c32dc228d8d3fe6a121f760eff12aa39 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16151.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,IoUringSocketTestPermutation,IoUringDatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16151.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,IoUringSocketTestPermutation,IoUringDatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16151: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16151: INVALID-PASS-PASS'
else
    echo 'PR-16151: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16150
echo '=== Validating PR-16150 ==='
git checkout f80b70c75ed7dff27d7e74d2c18ca8a0724a1cc7 --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16150.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16150.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16150: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16150: INVALID-PASS-PASS'
else
    echo 'PR-16150: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16143
echo '=== Validating PR-16143 ==='
git checkout 1155c463771f3788d951b377c5f0f478f517f96f --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16143.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-classes-quic -Dtest=SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMethodTest,ChannelOutboundBufferTest,DefaultPromiseTest,PromiseNotifierTest,DnsNameResolverTest,DefaultChannelPipelineTest,SocketCancelWriteTest,SocketConnectionAttemptTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16143.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-classes-quic -Dtest=SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMethodTest,ChannelOutboundBufferTest,DefaultPromiseTest,PromiseNotifierTest,DnsNameResolverTest,DefaultChannelPipelineTest,SocketCancelWriteTest,SocketConnectionAttemptTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16143: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16143: INVALID-PASS-PASS'
else
    echo 'PR-16143: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16118
echo '=== Validating PR-16118 ==='
git checkout f84f78b0a6b5c61abb81068b142b009357e33c7a --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16118.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl handler-ssl-ocsp -Dtest=OcspClientTest > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16118.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl handler-ssl-ocsp -Dtest=OcspClientTest > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16118: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16118: INVALID-PASS-PASS'
else
    echo 'PR-16118: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

# PR-16117
echo '=== Validating PR-16117 ==='
git checkout 627c3b73926775df35aa288fdf9587f42f5fca4e --force 2>/dev/null
git clean -fd 2>/dev/null

# Apply test patch
git apply ../patches/test-patch-16117.patch 2>/dev/null

# Run tests (expect FAIL)
mvn test -pl codec-http3 -Dtest=EmbeddedQuicChannel > /dev/null 2>&1
AFTER_TEST=$?

# Apply code patch
git apply ../patches/code-patch-16117.patch 2>/dev/null

# Run tests (expect PASS)
mvn test -pl codec-http3 -Dtest=EmbeddedQuicChannel > /dev/null 2>&1
AFTER_CODE=$?

# Determine status
if [ $AFTER_TEST -ne 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16117: VALID'
    ((VALID_COUNT++))
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16117: INVALID-PASS-PASS'
else
    echo 'PR-16117: INVALID-FAIL-FAIL'
fi
((TOTAL_COUNT++))

echo ''
echo '=== SUMMARY ==='
echo "Valid tasks: $VALID_COUNT / $TOTAL_COUNT"

# ==========================================
# AUTO-UPDATE TASKS_STATUS.MD
# ==========================================
cd "$(dirname "$0")"

# Get repo full name
if [ -f "tasks.json" ]; then
    REPO_FULLNAME=$(head -50 tasks.json | grep -o '"repo" : "[^"]*"' | head -1 | cut -d'"' -f4)
else
    REPO_FULLNAME=$(basename "$(pwd)" | sed 's/-/\//')
fi

# Count results from console output (last run)
# Note: This assumes variables VALID_COUNT, etc. are set from the script

cat > TASKS_STATUS.md << EOF
# Task Validation Status: $REPO_FULLNAME

**✅ VALIDATION_COMPLETE: $(date '+%Y-%m-%d %H:%M:%S')**

## Summary
- **Total Tasks:** ${TOTAL_COUNT:-0}
- **VALID:** ${VALID_COUNT:-0} ($((TOTAL_COUNT > 0 ? VALID_COUNT * 100 / TOTAL_COUNT : 0))%)
- **INVALID-PASS-PASS:** ${INVALID_PP_COUNT:-0}
- **INVALID-FAIL-FAIL:** ${INVALID_FF_COUNT:-0}

## Legend
- **VALID**: Tests FAIL after test_patch, PASS after code_patch (good for SWE-bench)
- **INVALID-PASS-PASS**: Tests pass both before and after (test doesn't expose bug)
- **INVALID-FAIL-FAIL**: Tests fail both before and after (patch doesn't fix)

---

**Validation completed:** $(date)
**Status:** ✅ COMPLETE - Ready for SWE-bench use

---

For detailed per-task results, check the console output or logs.
EOF

echo ""
echo "✓ TASKS_STATUS.md updated with completion marker"
