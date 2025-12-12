# Java SWE-Bench Setup Guide

## Prerequisites

### Required Software
- **Java Development Kit (JDK) 17** - Primary development version
- **Maven 3.6+** - Build and dependency management
- **Git** - Version control and repository operations
- **SDKMAN** (Recommended) - For managing multiple Java versions

### Optional Tools
- **Java 8, 11** - For testing against different Java versions
- **Gradle** - If working with Gradle-based projects
- **Docker** - For isolated test environments

## Installation

### 1. Install Java 17

#### Using SDKMAN (Recommended)
```bash
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install Java 17
sdk install java 17.0.8-tem
sdk use java 17.0.8-tem

# Verify installation
java -version
```

#### Manual Installation
- Download from [Adoptium](https://adoptium.net/)
- Set `JAVA_HOME` environment variable
- Add Java to your PATH

### 2. Install Maven

#### Using SDKMAN
```bash
sdk install maven 3.9.4
```

#### Manual Installation
```bash
# macOS
brew install maven

# Linux
sudo apt-get install maven

# Windows
# Download from https://maven.apache.org/download.cgi
```

Verify installation:
```bash
mvn -version
```

### 3. Clone/Access Project

The project is located at:
```
/Users/tanishjaggi/Desktop/java-swe-bench
```

Navigate to the project:
```bash
cd /Users/tanishjaggi/Desktop/java-swe-bench
```

## GitHub API Setup

### Get GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `read:org` (Read org and team membership)
4. Generate and copy the token

### Set Environment Variable

#### Bash/Zsh (macOS/Linux)
Add to `~/.bashrc` or `~/.zshrc`:
```bash
export GITHUB_TOKEN="your_token_here"
```

Then reload:
```bash
source ~/.bashrc  # or ~/.zshrc
```

#### Windows
```cmd
setx GITHUB_TOKEN "your_token_here"
```

### Verify Token
```bash
echo $GITHUB_TOKEN
```

**Important**: Without a token, GitHub API rate limits are very restrictive (60 requests/hour vs 5000 with token).

## Building the Project

### Compile Source Code
```bash
mvn clean compile
```

Expected output:
```
[INFO] BUILD SUCCESS
```

### Run Tests
```bash
mvn test
```

Expected output:
```
[INFO] Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### Package JAR
```bash
mvn package
```

This creates `target/java-swe-bench-1.0.0.jar`

## Project Structure

```
java-swe-bench/
├── src/
│   ├── main/java/com/swebench/
│   │   ├── Main.java                    # Entry point
│   │   ├── model/                       # Data models
│   │   │   ├── TaskInstance.java
│   │   │   └── Repository.java
│   │   ├── pipeline/                    # Pipeline stages
│   │   │   ├── RepositoryDiscovery.java
│   │   │   ├── AttributeFilter.java
│   │   │   └── ExecutionFilter.java
│   │   ├── service/                     # Core services
│   │   │   ├── GitHubService.java
│   │   │   ├── PatchExtractor.java
│   │   │   ├── PatchApplier.java
│   │   │   └── TestRunner.java
│   │   └── util/                        # Utilities
│   │       ├── ConfigLoader.java
│   │       └── FileUtils.java
│   └── test/java/com/swebench/         # Test suite
├── scripts/                             # Automation scripts
│   ├── run_discovery.sh
│   ├── run_filter.sh
│   ├── run_validate.sh
│   └── run_pipeline.sh
├── data/                                # Data directories
│   ├── raw/                            # Discovery output
│   ├── processed/                      # Filter output
│   ├── tasks/                          # Validated tasks
│   └── workspaces/                     # Test environments
├── config/
│   └── application.properties          # Configuration
├── pom.xml                             # Maven configuration
└── README.md                           # Project overview
```

## Configuration

Edit `config/application.properties` to customize:

```properties
# GitHub Settings
github.token=${GITHUB_TOKEN}

# Discovery Settings
discovery.target.count=30
discovery.min.stars=50

# Filtering Settings
filter.target.task.count=200
filter.max.files.changed=100

# Execution Settings
execution.timeout.minutes=10
execution.parallel.workers=4
```

## Running the Pipeline

### Stage 1: Repository Discovery
```bash
./scripts/run_discovery.sh
```

Or directly:
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="discover"
```

Output: `data/raw/discovered_repositories.json`

### Stage 2: Attribute Filtering
```bash
./scripts/run_filter.sh
```

Or directly:
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="filter"
```

Output: `data/processed/candidate_tasks.json`

### Stage 3: Execution Filtering
```bash
./scripts/run_validate.sh
```

Or directly:
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="validate"
```

Output: `data/tasks/validated_tasks.json`

### Full Pipeline
```bash
./scripts/run_pipeline.sh
```

Or directly:
```bash
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="pipeline"
```

## Development Workflow

### Adding New Features

1. **Create feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Write code**
   - Add implementation in `src/main/java/com/swebench/`
   - Add tests in `src/test/java/com/swebench/`

3. **Test changes**
   ```bash
   mvn test
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "Add my feature"
   ```

### Code Style

- Follow Java naming conventions
- Use meaningful variable names
- Add JavaDoc comments for public methods
- Keep methods focused and concise
- Maximum line length: 120 characters

### Testing

- Write unit tests for all new code
- Test coverage should be >80%
- Use JUnit 5 for tests
- Use Mockito for mocking external dependencies

## Troubleshooting

### Maven Build Fails

**Problem**: Compilation errors or dependency issues

**Solution**:
```bash
# Clear Maven cache
mvn clean
rm -rf ~/.m2/repository/com/swebench

# Rebuild
mvn clean install
```

### GitHub API Rate Limit

**Problem**: "API rate limit exceeded" error

**Solution**:
- Set `GITHUB_TOKEN` environment variable
- Use authenticated requests (5000 req/hour vs 60)
- Wait for rate limit to reset (1 hour)

### Tests Fail

**Problem**: Unit tests failing

**Solution**:
```bash
# Run specific test
mvn test -Dtest=TaskInstanceTest

# Skip tests temporarily
mvn package -DskipTests

# Get detailed output
mvn test -X
```

### Out of Memory

**Problem**: `OutOfMemoryError` during execution

**Solution**:
```bash
# Increase Maven memory
export MAVEN_OPTS="-Xmx4g -Xms1g"

# Re-run command
mvn clean package
```

### Git Clone Fails

**Problem**: Repository cloning times out or fails

**Solution**:
- Check internet connection
- Increase timeout in `TestRunner.java`
- Use repository mirrors
- Clone manually and point to local path

## Performance Optimization

### Parallel Execution

Modify `config/application.properties`:
```properties
execution.parallel.workers=8  # Increase for more parallelism
```

### Caching

Enable Maven dependency caching:
```bash
# Keep downloaded dependencies
# Don't run with -U flag
mvn clean install  # Good
mvn clean install -U  # Forces re-download
```

### Selective Processing

Process specific repositories:
```bash
# Edit discovery stage to target specific repos
# Modify RepositoryDiscovery.java
```

## Next Steps

After setup:

1. **Phase 1**: Run repository discovery
   - Target: 20-30 high-quality Java repositories
   - Expected duration: ~30 minutes

2. **Phase 2**: Extract and validate task instances
   - Target: 200+ valid task instances
   - Expected duration: 10-20 hours

3. **Analysis**: Review collected data
   - Check task quality
   - Verify test coverage
   - Analyze failure patterns

4. **Documentation**: Record findings
   - Update project documentation
   - Create task catalog
   - Generate statistics

## Support

For issues or questions:

1. Check existing documentation:
   - README.md
   - ARCHITECTURE.md
   - This SETUP.md

2. Review logs:
   - Maven output
   - Application logs
   - Test results

3. Consult project PDFs:
   - Java_SWE_Bench_Project_Documentation 2.pdf
   - Updated_Project_Plan.pdf
   - swe-bench-python paper.pdf
