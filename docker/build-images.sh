#!/usr/bin/env bash
# Build all swe-bench Docker images.
# Run from the project root: bash docker/build-images.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "Building swe-bench Docker images..."
echo "Working directory: $PROJECT_ROOT"
echo

build_image() {
    local dockerfile=$1
    local tag=$2
    echo "==> Building $tag from $dockerfile"
    docker build -f "$dockerfile" -t "$tag" .
    echo "    Done: $tag"
    echo
}

build_image docker/Dockerfile.java17-maven  swe-bench:java17-maven
build_image docker/Dockerfile.java17-gradle swe-bench:java17-gradle
build_image docker/Dockerfile.java21-maven  swe-bench:java21-maven
build_image docker/Dockerfile.java23-maven  swe-bench:java23-maven

echo "All images built successfully."
echo
docker images --filter "reference=swe-bench:*" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
