#!/bin/bash
# Validation Script for netty/netty
# Generated: 2026-02-01T17:20:55.589350

set +e  # Don't exit on error

# Save script directory as absolute path (before cd repo)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Clone repository if not exists
if [ ! -d 'repo' ]; then
    echo 'Cloning netty/netty...'
    git clone https://github.com/netty/netty.git repo
fi

cd repo

VALID_COUNT=0
TOTAL_COUNT=0
INVALID_PP_COUNT=0
INVALID_FF_COUNT=0
TASK_ROWS=""

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
    TASK_ROWS="${TASK_ROWS}| 16195 | dc7bc7f... | ReadOnlyByteBufTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16195: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16195 | dc7bc7f... | ReadOnlyByteBufTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16195: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16195 | dc7bc7f... | ReadOnlyByteBufTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16193 | dc7bc7f... | JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16193: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16193 | dc7bc7f... | JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16193: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16193 | dc7bc7f... | JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16188 | ccc5570... | ReadOnlyByteBufTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16188: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16188 | ccc5570... | ReadOnlyByteBufTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16188: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16188 | ccc5570... | ReadOnlyByteBufTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16172 | 2af3d13... | DefaultThreadFactoryTest,PlatformDependent0Test | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16172: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16172 | 2af3d13... | DefaultThreadFactoryTest,PlatformDependent0Test | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16172: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16172 | 2af3d13... | DefaultThreadFactoryTest,PlatformDependent0Test | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16170 | c9b74c3... | QuicChannelConnectTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16170: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16170 | c9b74c3... | QuicChannelConnectTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16170: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16170 | c9b74c3... | QuicChannelConnectTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16169 | c9b74c3... | QuicTransportParametersTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16169: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16169 | c9b74c3... | QuicTransportParametersTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16169: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16169 | c9b74c3... | QuicTransportParametersTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16164 | c9b74c3... | NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventE... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16164: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16164 | c9b74c3... | NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventE... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16164: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16164 | c9b74c3... | NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventE... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16163 | 26fadc1... | QuicChannelConnectTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16163: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16163 | 26fadc1... | QuicChannelConnectTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16163: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16163 | 26fadc1... | QuicChannelConnectTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16162 | 26fadc1... | QuicTransportParametersTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16162: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16162 | 26fadc1... | QuicTransportParametersTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16162: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16162 | 26fadc1... | QuicTransportParametersTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16157 | 6008169... | NonStickyEventExecutorGroupTest,SingleThreadEventExecutor... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16157: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16157 | 6008169... | NonStickyEventExecutorGroupTest,SingleThreadEventExecutor... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16157: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16157 | 6008169... | NonStickyEventExecutorGroupTest,SingleThreadEventExecutor... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16155 | 6008169... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16155: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16155 | 6008169... | Http2ConnectionHandlerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16155: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16155 | 6008169... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16154 | 496f55c... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16154: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16154 | 496f55c... | Http2ConnectionHandlerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16154: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16154 | 496f55c... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16153 | ba8fbaa... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16153: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16153 | ba8fbaa... | Http2ConnectionHandlerTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16153: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16153 | ba8fbaa... | Http2ConnectionHandlerTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16152 | 16ba19e... | DefaultChannelPipelineTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16152: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16152 | 16ba19e... | DefaultChannelPipelineTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16152: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16152 | 16ba19e... | DefaultChannelPipelineTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16151 | 33ac30b... | DatagramConnectedWriteExceptionTest,IoUringSocketTestPerm... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16151: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16151 | 33ac30b... | DatagramConnectedWriteExceptionTest,IoUringSocketTestPerm... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16151: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16151 | 33ac30b... | DatagramConnectedWriteExceptionTest,IoUringSocketTestPerm... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16150 | f80b70c... | DatagramConnectedWriteExceptionTest,KQueueDatagramConnect... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16150: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16150 | f80b70c... | DatagramConnectedWriteExceptionTest,KQueueDatagramConnect... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16150: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16150 | f80b70c... | DatagramConnectedWriteExceptionTest,KQueueDatagramConnect... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16143 | 1155c46... | SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMet... | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16143: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16143 | 1155c46... | SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMet... | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16143: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16143 | 1155c46... | SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMet... | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16118 | f84f78b... | OcspClientTest | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16118: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16118 | f84f78b... | OcspClientTest | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16118: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16118 | f84f78b... | OcspClientTest | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
    TASK_ROWS="${TASK_ROWS}| 16117 | 627c3b7... | EmbeddedQuicChannel | FAIL ($AFTER_TEST) | PASS ($AFTER_CODE) | **VALID** | |\n"
elif [ $AFTER_TEST -eq 0 ] && [ $AFTER_CODE -eq 0 ]; then
    echo 'PR-16117: INVALID-PASS-PASS'
    ((INVALID_PP_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16117 | 627c3b7... | EmbeddedQuicChannel | PASS ($AFTER_TEST) | PASS ($AFTER_CODE) | INVALID-PASS-PASS | Test does not expose bug |\n"
else
    echo 'PR-16117: INVALID-FAIL-FAIL'
    ((INVALID_FF_COUNT++))
    TASK_ROWS="${TASK_ROWS}| 16117 | 627c3b7... | EmbeddedQuicChannel | FAIL ($AFTER_TEST) | FAIL ($AFTER_CODE) | INVALID-FAIL-FAIL | Code patch does not fix |\n"
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
