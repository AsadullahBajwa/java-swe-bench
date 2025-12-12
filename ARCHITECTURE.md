# Java SWE-Bench Architecture

## System Overview

Java SWE-Bench implements a three-stage pipeline for collecting and validating software engineering benchmark tasks from Java projects on GitHub.

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Stage 1: Discovery                     │
│  ┌──────────────┐    ┌──────────────┐                   │
│  │ GitHub API   │───▶│ Repository   │───▶ Raw Data      │
│  │ Search       │    │ Filtering    │                   │
│  └──────────────┘    └──────────────┘                   │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                Stage 2: Attribute Filter                 │
│  ┌──────────────┐    ┌──────────────┐                   │
│  │ Issue-PR     │───▶│ Patch        │───▶ Candidate     │
│  │ Extraction   │    │ Validation   │     Tasks         │
│  └──────────────┘    └──────────────┘                   │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│               Stage 3: Execution Filter                  │
│  ┌──────────────┐    ┌──────────────┐                   │
│  │ Test         │───▶│ Validation   │───▶ Final         │
│  │ Execution    │    │ Results      │     Tasks         │
│  └──────────────┘    └──────────────┘                   │
└─────────────────────────────────────────────────────────┘
```

## Component Design

### Core Components

#### 1. Pipeline Stages (`com.swebench.pipeline`)

**RepositoryDiscovery**
- Searches GitHub for qualifying Java repositories
- Applies initial filters (stars, language, activity)
- Detects build system (Maven/Gradle)
- Outputs: `data/raw/discovered_repositories.json`

**AttributeFilter**
- Extracts issue-PR pairs from repositories
- Validates problem statements and patches
- Checks for test-related changes
- Outputs: `data/processed/candidate_tasks.json`

**ExecutionFilter**
- Clones repositories and runs validation tests
- Verifies fail-to-pass test criteria
- Ensures no regression (pass-to-pass)
- Outputs: `data/tasks/validated_tasks.json`

#### 2. Services (`com.swebench.service`)

**GitHubService**
- Interface to GitHub API (using github-api library)
- Repository search and metadata extraction
- Issue and PR data collection
- Rate limit management

**PatchExtractor**
- Extracts diffs using JGit
- Validates patch format
- Calculates patch statistics
- Handles multi-file changes

**PatchApplier**
- Applies patches to repositories
- Fallback to git command-line
- Patch reversal for cleanup

**TestRunner**
- Manages test execution for Maven and Gradle
- Handles Java version switching (via SDKMAN)
- Parses test results
- Manages workspace isolation

#### 3. Models (`com.swebench.model`)

**TaskInstance**
- Complete specification of a benchmark task
- Includes: problem statement, patch, tests, metadata
- Serializable to JSON for storage

**Repository**
- GitHub repository metadata
- Build system information
- Qualification criteria checking

#### 4. Utilities (`com.swebench.util`)

**ConfigLoader**
- Loads configuration from properties file
- Environment variable substitution
- Type-safe property access

**FileUtils**
- File system operations
- Directory management
- Java/test file detection

## Data Flow

### Stage 1: Repository Discovery
```
GitHub API Search
    ↓
Filter by criteria (stars, language, activity)
    ↓
Detect build system (pom.xml, build.gradle)
    ↓
Save to data/raw/discovered_repositories.json
```

### Stage 2: Attribute Filtering
```
Load discovered repositories
    ↓
For each repository:
    Get merged PRs
    Find linked issues
    Extract patches
    Validate attributes
    ↓
Save to data/processed/candidate_tasks.json
```

### Stage 3: Execution Filtering
```
Load candidate tasks
    ↓
For each task:
    Clone repository
    Checkout base commit
    Run FAIL_TO_PASS tests → should fail
    Apply patch
    Run FAIL_TO_PASS tests → should pass
    Run PASS_TO_PASS tests → should still pass
    ↓
Save to data/tasks/validated_tasks.json
```

## Key Design Decisions

### 1. Three-Stage Pipeline
Separates concerns and allows resuming from any stage. Each stage produces intermediate artifacts for debugging and analysis.

### 2. Execution-Based Validation
Unlike attribute-only filtering, we actually run tests to ensure quality. This catches:
- Flaky tests
- Missing dependencies
- Environment issues
- Invalid patches

### 3. Build Tool Abstraction
Support for both Maven and Gradle through detection and command abstraction. Future expansion to other build tools is straightforward.

### 4. Workspace Isolation
Each task validation runs in isolated directory to prevent cross-contamination and allow parallel execution.

### 5. Fail-to-Pass Criterion
Tests must fail at base commit and pass after patch. This ensures:
- Bug is reproducible
- Patch actually fixes the issue
- Not a false positive

## Scalability Considerations

### Parallel Processing
- Repository discovery can be parallelized
- Task validation can run concurrently
- Configurable worker pool size

### Rate Limiting
- GitHub API rate limits respected
- Token authentication recommended
- Caching of API responses

### Storage
- Repositories cloned to temporary workspaces
- Cleanup after validation
- Incremental processing supported

### Fault Tolerance
- Each stage can be rerun independently
- Failed tasks logged and skipped
- Retry logic for transient failures

## Configuration

Configuration is loaded from `config/application.properties` with environment variable substitution.

Key settings:
- `github.token`: GitHub API token for authentication
- `discovery.target.count`: Number of repositories to discover
- `filter.target.task.count`: Target number of validated tasks
- `execution.timeout.minutes`: Test execution timeout
- `execution.parallel.workers`: Number of parallel validation workers

## Extension Points

### Adding New Build Systems
1. Implement build tool detection in `GitHubService.detectBuildTool()`
2. Add test command pattern in `TestRunner.detectTestCommand()`
3. Update configuration with build tool specific settings

### Custom Filters
1. Add filter logic to `AttributeFilter.passesAttributeFilters()`
2. Configure thresholds in `application.properties`
3. Update reporting in stage classes

### Additional Metadata
1. Extend `TaskInstance` or `Repository` models
2. Update extraction logic in services
3. Enhance validation criteria if needed

## Testing Strategy

### Unit Tests
- Model serialization/deserialization
- Filter criteria logic
- Utility functions

### Integration Tests
- Pipeline stage execution
- Service interactions
- File I/O operations

### End-to-End Tests
- Full pipeline execution on sample repositories
- Validation of output format
- Performance benchmarks

## Error Handling

### Recovery Strategies
- Transient failures: Retry with exponential backoff
- Invalid data: Log and skip, continue processing
- System errors: Fail fast with detailed error message

### Logging
- DEBUG: Detailed execution trace
- INFO: Progress and summary statistics
- WARN: Recoverable issues
- ERROR: Fatal problems requiring attention

## Performance Characteristics

### Time Complexity
- Discovery: O(n) where n = number of repositories searched
- Attribute Filter: O(m * p) where m = repos, p = PRs per repo
- Execution Filter: O(t * e) where t = tasks, e = test execution time

### Expected Duration (Phase 2 Target)
- Discovery: ~30 minutes (30 repositories)
- Attribute Filter: ~2-3 hours (200+ candidates)
- Execution Filter: ~10-20 hours (200 tasks, 10 min each)

### Resource Requirements
- Memory: 2-4 GB for parallel execution
- Disk: ~10 GB for repository clones and workspaces
- Network: ~1-2 GB for repository data transfer
