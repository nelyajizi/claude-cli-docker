#!/usr/bin/env bash
set -euo pipefail

IMAGE="${CLAUDE_IMAGE:-claude-cli:latest}"

# Avoid root-owned files on Linux by building with your uid/gid
UID_ARG="--build-arg UID=${UID:-1000}"
GID_ARG="--build-arg GID=${GID:-1000}"

echo "Building image: $IMAGE"
docker build $UID_ARG $GID_ARG -t "$IMAGE" .
echo "Done."