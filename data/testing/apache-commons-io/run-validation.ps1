# Validation Script for apache/commons-io
# Generated: 2026-02-01T17:20:55.552833200

$ErrorActionPreference = 'Continue'

# Clone repository if not exists
if (-not (Test-Path 'repo')) {
    Write-Host 'Cloning apache/commons-io...'
    git clone https://github.com/apache/commons-io.git repo
}

cd repo

$results = @()

# PR-818
Write-Host '=== Validating PR-818 ===' -ForegroundColor Cyan
git checkout 8f66b3212c3d35c74cc96e7d0b3258f0fb9305f1 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-818.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-818.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-818: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=818; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-817
Write-Host '=== Validating PR-817 ===' -ForegroundColor Cyan
git checkout 3557766ab48bb876008b0a2cb9bd1933275a306a --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-817.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ByteArraySeekableByteChannelCompressTest,AbstractSeekableByteChannelTest,ByteArraySeekableByteChannelTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-817.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ByteArraySeekableByteChannelCompressTest,AbstractSeekableByteChannelTest,ByteArraySeekableByteChannelTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-817: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=817; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-801
Write-Host '=== Validating PR-801 ===' -ForegroundColor Cyan
git checkout c28dc1bdc28cc3a47ca3a897ce31cac1fc9592c2 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-801.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOCaseTest,IOUtilsConcurrentTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-801.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOCaseTest,IOUtilsConcurrentTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-801: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=801; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-800
Write-Host '=== Validating PR-800 ===' -ForegroundColor Cyan
git checkout b95cbfa29df2928578a133b395a3e03dd05658fb --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-800.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-800.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-800: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=800; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-799
Write-Host '=== Validating PR-799 ===' -ForegroundColor Cyan
git checkout f51d19cabad7b8c67e2992a2ab22465658249485 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-799.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-799.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-799: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=799; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-796
Write-Host '=== Validating PR-796 ===' -ForegroundColor Cyan
git checkout 07d2cd9c493baae1e82553b3da420d17a6093c05 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-796.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-796.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-796: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=796; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-795
Write-Host '=== Validating PR-795 ===' -ForegroundColor Cyan
git checkout 07d2cd9c493baae1e82553b3da420d17a6093c05 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-795.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-795.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-795: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=795; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-790
Write-Host '=== Validating PR-790 ===' -ForegroundColor Cyan
git checkout 66db0c6610270ad58f93cf393fe2359f46d395b6 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-790.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BrokenReaderTest,ClosedInputStreamTest,MarkShieldInputStreamTest,BrokenWriterTest,ClosedWriterTest,IOUtilsTest,ByteArrayOutputStreamTest,NullAppendableTest,NullWriterTest,ProxyReaderTest,NullInputStreamTest,ProxyWriterTest,NullOutputStreamTest,UnsynchronizedBufferedReaderTest,ClosedReaderTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-790.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BrokenReaderTest,ClosedInputStreamTest,MarkShieldInputStreamTest,BrokenWriterTest,ClosedWriterTest,IOUtilsTest,ByteArrayOutputStreamTest,NullAppendableTest,NullWriterTest,ProxyReaderTest,NullInputStreamTest,ProxyWriterTest,NullOutputStreamTest,UnsynchronizedBufferedReaderTest,ClosedReaderTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-790: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=790; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-786
Write-Host '=== Validating PR-786 ===' -ForegroundColor Cyan
git checkout 3c0677e8b7241a81e27d02791f0cf57fd1ab9a78 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-786.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-786.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CloseShieldChannelTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-786: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=786; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-785
Write-Host '=== Validating PR-785 ===' -ForegroundColor Cyan
git checkout a96ae748c00343eb5f09ebf77d1dde77b733be2d --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-785.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-785.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-785: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=785; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-784
Write-Host '=== Validating PR-784 ===' -ForegroundColor Cyan
git checkout 886ebfca609d813d7199497a26606f209e607b07 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-784.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=CharSequenceOriginTest,PathOriginTest,ByteArraySeekableByteChannelCompressTest,IORandomAccessFileOriginTest,FileOriginTest,URIOriginTest,OutputStreamOriginTest,ReaderOriginTest,AbstractStreamBuilderTest,ByteArrayOriginTest,ByteArraySeekableByteChannelTest,AbstractRandomAccessFileOriginTest,ChannelOriginTest,InputStreamOriginTest,WriterStreamOriginTest,AbstractOriginTest,RandomAccessFileOriginTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-784.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=CharSequenceOriginTest,PathOriginTest,ByteArraySeekableByteChannelCompressTest,IORandomAccessFileOriginTest,FileOriginTest,URIOriginTest,OutputStreamOriginTest,ReaderOriginTest,AbstractStreamBuilderTest,ByteArrayOriginTest,ByteArraySeekableByteChannelTest,AbstractRandomAccessFileOriginTest,ChannelOriginTest,InputStreamOriginTest,WriterStreamOriginTest,AbstractOriginTest,RandomAccessFileOriginTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-784: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=784; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-781
Write-Host '=== Validating PR-781 ===' -ForegroundColor Cyan
git checkout cd20ecebc3facaf3c3b3eaba331d40b289ffe3b9 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-781.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FileSystemTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-781.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FileSystemTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-781: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=781; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-779
Write-Host '=== Validating PR-779 ===' -ForegroundColor Cyan
git checkout 28873d13364509716b0ac520f31081b5f62f3263 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-779.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=BoundedInputStreamTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-779.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=BoundedInputStreamTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-779: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=779; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-776
Write-Host '=== Validating PR-776 ===' -ForegroundColor Cyan
git checkout e205fb9e0dfe29fefa62060ad88ef586b12745ee --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-776.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-776.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=IOUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-776: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=776; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-763
Write-Host '=== Validating PR-763 ===' -ForegroundColor Cyan
git checkout ea8ba68c8839db85c2db17e9414c806f1085462c --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-763.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-763.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-763: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=763; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-758
Write-Host '=== Validating PR-758 ===' -ForegroundColor Cyan
git checkout 4fe3854a6bef9674ac9fc1062fdd1ad8614dc7cd --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-758.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=ByteArrayOutputStreamTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-758.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=ByteArrayOutputStreamTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-758: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=758; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-757
Write-Host '=== Validating PR-757 ===' -ForegroundColor Cyan
git checkout 4fe3854a6bef9674ac9fc1062fdd1ad8614dc7cd --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-757.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=TailerTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-757.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=TailerTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-757: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=757; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-756
Write-Host '=== Validating PR-756 ===' -ForegroundColor Cyan
git checkout 53371a208d4215c26d0f5f3b3aa960d274ff5211 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-756.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-756.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-756: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=756; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-748
Write-Host '=== Validating PR-748 ===' -ForegroundColor Cyan
git checkout 5080fa310dc19c20f9631bd18cfc3a5a63ef160e --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-748.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=QueueInputStreamTest,QueueStreamBenchmark" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-748.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=QueueInputStreamTest,QueueStreamBenchmark" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-748: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=748; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# PR-744
Write-Host '=== Validating PR-744 ===' -ForegroundColor Cyan
git checkout 41419d10eae6306c902499102eef16f5e3ef2939 --force 2>$null
git clean -fd 2>$null

# Apply test patch
git apply ../patches/test-patch-744.patch 2>$null
$testPatchResult = $LASTEXITCODE

# Run tests (expect FAIL)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterTestPatch = $LASTEXITCODE

# Apply code patch
git apply ../patches/code-patch-744.patch 2>$null
$codePatchResult = $LASTEXITCODE

# Run tests (expect PASS)
& cmd /c "mvn test -Dtest=FileUtilsTest" 2>&1 | Out-Null
$afterCodePatch = $LASTEXITCODE

# Determine status
$status = 'UNKNOWN'
if ($afterTestPatch -ne 0 -and $afterCodePatch -eq 0) { $status = 'VALID' }
elseif ($afterTestPatch -eq 0 -and $afterCodePatch -eq 0) { $status = 'INVALID-PASS-PASS' }
elseif ($afterTestPatch -ne 0 -and $afterCodePatch -ne 0) { $status = 'INVALID-FAIL-FAIL' }

Write-Host "PR-744: $status (test_patch: $afterTestPatch, code_patch: $afterCodePatch)"
$results += [PSCustomObject]@{ PR=744; Status=$status; AfterTest=$afterTestPatch; AfterCode=$afterCodePatch }

# Summary
Write-Host ''
Write-Host '=== SUMMARY ===' -ForegroundColor Green
$results | Format-Table -AutoSize

$valid = ($results | Where-Object { $_.Status -eq 'VALID' }).Count
Write-Host "Valid tasks: $valid / " + $results.Count
