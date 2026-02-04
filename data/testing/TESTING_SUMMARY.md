# Testing Directory Summary

Generated: 2026-02-01T17:20:55.670166

## Repositories

| Repository | Directory | Tasks | Status |
|------------|-----------|-------|--------|
| FasterXML/jackson-core | `FasterXML-jackson-core/` | 20 | PENDING |
| google/gson | `google-gson/` | 20 | PENDING |
| apache/commons-collections | `apache-commons-collections/` | 20 | PENDING |
| mockito/mockito | `mockito-mockito/` | 14 | PENDING |
| square/okhttp | `square-okhttp/` | 20 | PENDING |
| google/guava | `google-guava/` | 20 | PENDING |
| apache/commons-io | `apache-commons-io/` | 20 | PENDING |
| netty/netty | `netty-netty/` | 19 | PENDING |
| FasterXML/jackson-databind | `FasterXML-jackson-databind/` | 19 | PENDING |
| apache/commons-lang | `apache-commons-lang/` | 20 | PENDING |
| apache/commons-text | `apache-commons-text/` | 8 | PENDING |

**Total: 200 tasks across 11 repositories**

## How to Run

```powershell
# Navigate to a repository directory
cd data/testing/{repo-name}

# Run the validation script
.\run-validation.ps1
```

Or for parallel execution:

```powershell
# Run all repositories in parallel
Get-ChildItem -Directory | ForEach-Object -Parallel {
    Set-Location $_.FullName
    .\run-validation.ps1
} -ThrottleLimit 4
```
