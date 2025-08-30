#!/usr/bin/env bash
# Standalone Claude Code CLI Docker runner
# Copy this file into ANY repo and run it to get Claude Code CLI with gh + C++20 + gdb
# 
# Usage:
#   ./claude-docker.sh                        # interactive REPL
#   ./claude-docker.sh -p "Summarize this repo"   # one-shot print mode
#   ./claude-docker.sh --continue             # continue last session
#
set -euo pipefail

IMAGE="${CLAUDE_IMAGE:-claude-cli:latest}"
WORKDIR="${WORKDIR:-$PWD}"

# Check if image exists, if not build it inline
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Building Claude CLI Docker image..."
    
    # Create temporary Dockerfile
    DOCKERFILE=$(mktemp)
    cat > "$DOCKERFILE" << 'EOF'
# Claude Code CLI with gh + gcc/g++(C++20) + gdb
FROM node:20-slim

# Base tools Claude may use
RUN apt-get update && apt-get install -y --no-install-recommends \
    git openssh-client ca-certificates curl bash make pkg-config ripgrep gnupg \
    build-essential gdb \
  && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (official apt repo)
RUN mkdir -p -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update && apt-get install -y --no-install-recommends gh \
 && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Non-root user (avoid root-owned files on mounted volumes)
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} dev && useradd -m -u ${UID} -g ${GID} -s /bin/bash dev
USER dev

ENV HOME=/home/dev
WORKDIR /work

# Run Claude Code CLI by default
ENTRYPOINT ["claude"]
EOF

    # Build image with current user's UID/GID
    docker build \
        --build-arg UID="${UID:-1000}" \
        --build-arg GID="${GID:-1000}" \
        -t "$IMAGE" \
        -f "$DOCKERFILE" \
        .
    
    # Clean up
    rm "$DOCKERFILE"
    echo "Image built successfully."
fi

# Persist Claude auth/settings
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
mkdir -p "$CLAUDE_HOME"

# Reuse your GitHub CLI auth (optional)
GH_CONFIG="${GH_CONFIG:-$HOME/.config/gh}"
GH_MOUNT=()
[ -d "$GH_CONFIG" ] && GH_MOUNT=(-v "$GH_CONFIG:/home/dev/.config/gh")

# Reuse your git identity (optional)
GITCONFIG_MOUNT=()
[ -f "$HOME/.gitconfig" ] && GITCONFIG_MOUNT=(-v "$HOME/.gitconfig:/home/dev/.gitconfig:ro")

# SSH auth (preferred for git push). Tries agent first, then keys.
SSH_FLAGS=()
if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "$SSH_AUTH_SOCK" ]; then
  SSH_FLAGS=(-v "$SSH_AUTH_SOCK:/ssh-agent" -e SSH_AUTH_SOCK=/ssh-agent)
elif [ -d "$HOME/.ssh" ]; then
  SSH_FLAGS=(-v "$HOME/.ssh:/home/dev/.ssh:ro")
fi

# TTY flags
TTY_FLAGS=()
if [ -t 0 ]; then TTY_FLAGS=(-it); else TTY_FLAGS=(-i); fi

# Make sure C/C++ env vars are visible
ENV_FLAGS=(-e CC=gcc -e CXX=g++)

exec docker run --rm "${TTY_FLAGS[@]}" \
  -v "$WORKDIR:/work" -w /work \
  -v "$CLAUDE_HOME:/home/dev/.claude" \
  "${GH_MOUNT[@]}" \
  "${GITCONFIG_MOUNT[@]}" \
  "${SSH_FLAGS[@]}" \
  "${ENV_FLAGS[@]}" \
  "$IMAGE" "$@"