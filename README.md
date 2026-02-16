# Java SWE-Bench

A Java adaptation of the [SWE-bench](https://www.swebench.com/) benchmark for evaluating language models on real-world software engineering tasks extracted from GitHub.

## Overview

This project builds a benchmark dataset of real-world Java bug-fixing tasks. Each task consists of a failing test, a code patch that fixes the bug, and the repository context -- enabling evaluation of how well language models can resolve actual software issues.

The pipeline discovers repositories, extracts bug-fixing pull requests, splits them into separate test and code patches, and validates that they follow the **fail-to-pass** pattern required by SWE-bench.

## Pipeline

```
Discovery  -->  Attribute Filter  -->  Testing Setup  -->  Execution Filter
(find repos)    (extract PRs,         (generate patch     (validate fail-
                 split patches)        files & scripts)     to-pass)
```

Each PR is split into:
- **test_patch**: Test file changes only (exposes the bug)
- **code_patch**: Source file changes only (fixes the bug)

A task is valid when: apply `test_patch` -> tests FAIL, then apply `code_patch` -> tests PASS.

## Project Structure

```
java-swe-bench/
├── src/main/java/com/swebench/
│   ├── Main.java                          # Entry point (CLI)
│   ├── model/                             # Data models
│   ├── pipeline/                          # Pipeline stages
│   │   ├── RepositoryDiscovery.java
│   │   ├── AttributeFilter.java
│   │   ├── TestingSetup.java
│   │   └── ExecutionFilter.java
│   ├── service/                           # Core services
│   │   ├── GitHubService.java
│   │   ├── PatchExtractor.java
│   │   ├── PatchApplier.java
│   │   ├── TestRunner.java
│   │   └── QualityValidator.java
│   └── util/                              # Utilities
├── config/
│   ├── application.properties             # Pipeline configuration
│   └── curated_repos.json                 # Curated repository list
├── data/
│   ├── processed/                         # Collected candidate tasks
│   ├── testing/                           # Validation workspace
│   │   └── {repo-name}/
│   │       ├── patches/                   # test-patch and code-patch files
│   │       ├── tasks.json
│   │       ├── run-validation.sh
│   │       └── run-validation.ps1
│   ├── tasks/                             # Final validated tasks
│   └── raw/                               # Discovered repositories
└── pom.xml
```

## Prerequisites

- Java 17+
- Maven 3.8+
- Git
- GitHub Personal Access Token

## Usage

```bash
# Set your GitHub token
export GITHUB_TOKEN=<your-token>

# Build
mvn clean compile

# Run individual stages
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="discover"
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="filter"
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="setup-testing"
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="validate"

# Or run the full pipeline
mvn exec:java -Dexec.mainClass="com.swebench.Main" -Dexec.args="pipeline"
```

After `setup-testing`, run validation per repository:

```bash
cd data/testing/apache-commons-lang
bash run-validation.sh
```

## Technologies

- Java 17, Maven, JUnit 5
- JGit for Git operations
- GitHub API (`org.kohsuke:github-api`)
- Jackson for JSON processing

## License

Developed as part of the Integrated Project course at the University of Hildesheim (SoSe 2025).
