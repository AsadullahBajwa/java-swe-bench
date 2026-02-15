# Validation Script for netty/netty
# Generated: 2026-02-01T17:20:55.588353200

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning netty/netty...'
    git clone https://github.com/netty/netty.git repo
}

cd repo

$results = @()

# PR-16195
Write-Host '=== Validating PR-16195 ===' -ForegroundColor Cyan
git checkout dc7bc7f607b1950d6db0c41a7a4f4e8b967155e4 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16195.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl buffer -Dtest=ReadOnlyByteBufTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16195.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl buffer -Dtest=ReadOnlyByteBufTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16195: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16195; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16193
Write-Host '=== Validating PR-16193 ===' -ForegroundColor Cyan
git checkout dc7bc7f607b1950d6db0c41a7a4f4e8b967155e4 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16193.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl handler -Dtest=JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16193.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl handler -Dtest=JdkSslEngineTest,OpenSslErrorStackAssertSSLEngine" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16193: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16193; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16188
Write-Host '=== Validating PR-16188 ===' -ForegroundColor Cyan
git checkout ccc5570a25ede657182895a59c978d568f7d2846 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16188.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl buffer -Dtest=ReadOnlyByteBufTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16188.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl buffer -Dtest=ReadOnlyByteBufTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16188: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16188; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16172
Write-Host '=== Validating PR-16172 ===' -ForegroundColor Cyan
git checkout 2af3d1391dc64a1ae739003eab2d2fa2c1d7a8e6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16172.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl common -Dtest=DefaultThreadFactoryTest,PlatformDependent0Test" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16172.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl common -Dtest=DefaultThreadFactoryTest,PlatformDependent0Test" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16172: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16172; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16170
Write-Host '=== Validating PR-16170 ===' -ForegroundColor Cyan
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16170.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16170.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16170: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16170; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16169
Write-Host '=== Validating PR-16169 ===' -ForegroundColor Cyan
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16169.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16169.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16169: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16169; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16164
Write-Host '=== Validating PR-16164 ===' -ForegroundColor Cyan
git checkout c9b74c3eb7bc84e623db0381d9e987f2503cb2e3 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16164.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventExecutorTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16164.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,UnorderedThreadPoolEventExecutorTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16164: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16164; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16163
Write-Host '=== Validating PR-16163 ===' -ForegroundColor Cyan
git checkout 26fadc1cf5d80de06909758ea186a1d0ce46ab10 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16163.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16163.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=QuicChannelConnectTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16163: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16163; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16162
Write-Host '=== Validating PR-16162 ===' -ForegroundColor Cyan
git checkout 26fadc1cf5d80de06909758ea186a1d0ce46ab10 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16162.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16162.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-native-quic -Dtest=QuicTransportParametersTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16162: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16162; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16157
Write-Host '=== Validating PR-16157 ===' -ForegroundColor Cyan
git checkout 6008169575ddc86ad2be37a6a8da3c9e54b19ce5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16157.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,SingleThreadEventExecutorTest,AbstractSingleThreadEventLoopTest,ManualIoEventLoopTest,DefaultPromiseTest,SingleThreadEventLoopTest,AbstractScheduledEventExecutorTest,ThreadExecutorMapTest,TrafficShapingHandlerTest,DefaultChannelPipelineTest,NioEventLoopTest,FileRegionThrottleTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16157.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl common -Dtest=NonStickyEventExecutorGroupTest,SingleThreadEventExecutorTest,AbstractSingleThreadEventLoopTest,ManualIoEventLoopTest,DefaultPromiseTest,SingleThreadEventLoopTest,AbstractScheduledEventExecutorTest,ThreadExecutorMapTest,TrafficShapingHandlerTest,DefaultChannelPipelineTest,NioEventLoopTest,FileRegionThrottleTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16157: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16157; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16155
Write-Host '=== Validating PR-16155 ===' -ForegroundColor Cyan
git checkout 6008169575ddc86ad2be37a6a8da3c9e54b19ce5 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16155.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16155.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16155: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16155; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16154
Write-Host '=== Validating PR-16154 ===' -ForegroundColor Cyan
git checkout 496f55cdf6edfd621320a2d803a53298ac2df9dd --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16154.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16154.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16154: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16154; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16153
Write-Host '=== Validating PR-16153 ===' -ForegroundColor Cyan
git checkout ba8fbaa38eb613e0161eb288fad5f92abc58db47 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16153.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16153.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-http2 -Dtest=Http2ConnectionHandlerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16153: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16153; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16152
Write-Host '=== Validating PR-16152 ===' -ForegroundColor Cyan
git checkout 16ba19e615820c50866528f06410951e16dc5061 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16152.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl transport -Dtest=DefaultChannelPipelineTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16152.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl transport -Dtest=DefaultChannelPipelineTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16152: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16152; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16151
Write-Host '=== Validating PR-16151 ===' -ForegroundColor Cyan
git checkout 33ac30b2c32dc228d8d3fe6a121f760eff12aa39 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16151.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,IoUringSocketTestPermutation,IoUringDatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16151.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,IoUringSocketTestPermutation,IoUringDatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16151: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16151; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16150
Write-Host '=== Validating PR-16150 ===' -ForegroundColor Cyan
git checkout f80b70c75ed7dff27d7e74d2c18ca8a0724a1cc7 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16150.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16150.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl transport-classes-epoll -Dtest=DatagramConnectedWriteExceptionTest,KQueueDatagramConnectedWriteExceptionTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16150: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16150; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16143
Write-Host '=== Validating PR-16143 ===' -ForegroundColor Cyan
git checkout 1155c463771f3788d951b377c5f0f478f517f96f --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16143.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMethodTest,ChannelOutboundBufferTest,DefaultPromiseTest,PromiseNotifierTest,DnsNameResolverTest,DefaultChannelPipelineTest,SocketCancelWriteTest,SocketConnectionAttemptTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16143.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-classes-quic -Dtest=SniHandlerTest,CipherSuiteCanaryTest,OpenSslPrivateKeyMethodTest,ChannelOutboundBufferTest,DefaultPromiseTest,PromiseNotifierTest,DnsNameResolverTest,DefaultChannelPipelineTest,SocketCancelWriteTest,SocketConnectionAttemptTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16143: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16143; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16118
Write-Host '=== Validating PR-16118 ===' -ForegroundColor Cyan
git checkout f84f78b0a6b5c61abb81068b142b009357e33c7a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16118.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl handler-ssl-ocsp -Dtest=OcspClientTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16118.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl handler-ssl-ocsp -Dtest=OcspClientTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16118: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16118; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-16117
Write-Host '=== Validating PR-16117 ===' -ForegroundColor Cyan
git checkout 627c3b73926775df35aa288fdf9587f42f5fca4e --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-16117.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -pl codec-http3 -Dtest=EmbeddedQuicChannel" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-16117.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -pl codec-http3 -Dtest=EmbeddedQuicChannel" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-16117: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=16117; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
