# Java SWE-Bench

A Java adaptation of SWE-bench benchmark for evaluating language models on real-world software engineering tasks from GitHub.

## Project Overview

This project implements a benchmark suite for testing language models' ability to solve real-world Java software engineering issues. It follows a three-stage pipeline:

1. **Repository Discovery**: Identify high-quality Java repositories
2. **Attribute Filtering**: Extract and validate issue-PR-test triplets
3. **Execution Filtering**: Verify patches through test execution

## Project Structure

```
java-swe-bench/
├── src/main/java/com/swebench/     # Core implementation
├── src/test/java/com/swebench/     # Test suite
├── scripts/                         # Pipeline automation scripts
├── data/
│   ├── tasks/                      # Task instance specifications
│   ├── workspaces/                 # Evaluation results
│   ├── raw/                        # Raw collection artifacts
│   └── processed/                  # Processed data
├── config/                         # Configuration files
└── pom.xml                         # Maven build configuration
```

## Target Metrics (Phase 2)

- **Target repositories**: 20-30 high-quality Java projects
- **Task instances**: 200+ valid issue-PR-test triplets
- **Validation**: All tasks must pass fail-to-pass test criteria
- **Quality**: Issues with clear problem statements and reproducible tests

## Technologies

- Java 17 (primary development)
- Maven for build management
- JUnit 5 for testing framework
- JGit for Git operations
- GitHub API for repository interaction
- SDKMAN for Java version management (Java 8, 11, 17)

## Repository Selection Criteria

- **Primary Language**: Java (at least 90% of codebase - VERY STRICT)
- **Not Forked**: Original repositories only
- **Popularity**: More than 50 stars
- **Active**: Updated within the last 1-2 years
- **Has Issues & PRs**: Active issue tracking and pull requests
- **Test Coverage**: Includes comprehensive test files
- **Build System**: Uses Maven or Gradle
- **Quality**: Well-maintained with clean commit history

## Development Status

Currently implementing Phase 2: Data Extraction & Benchmark Design

See project plan for detailed timeline and milestones.
