#!/usr/bin/env bash
# Run Claude Code CLI against the CURRENT repo via Docker.
# Examples:
#   ./run-claude.sh                        # interactive REPL
#   ./run-claude.sh -p "Summarize this repo"   # one-shot print mode
#   ./run-claude.sh --continue             # continue last session
#   ./run-claude.sh --permission-mode ask  # control permission mode
set -euo pipefail

IMAGE="${CLAUDE_IMAGE:-claude-cli:latest}"
WORKDIR="${WORKDIR:-$PWD}"

# Persist Claude auth/settings
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
mkdir -p "$CLAUDE_HOME"

# Reuse your GitHub CLI auth (optional)
GH_CONFIG="${GH_CONFIG:-$HOME/.config/gh}"
GH_MOUNT=()
[ -d "$GH_CONFIG" ] && GH_MOUNT=(-v "$GH_CONFIG:/home/node/.config/gh")

# Reuse your git identity (optional)
GITCONFIG_MOUNT=()
[ -f "$HOME/.gitconfig" ] && GITCONFIG_MOUNT=(-v "$HOME/.gitconfig:/home/node/.gitconfig:ro")

# SSH auth (preferred for git push). Tries agent first, then keys.
SSH_FLAGS=()
if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "$SSH_AUTH_SOCK" ]; then
  SSH_FLAGS=(-v "$SSH_AUTH_SOCK:/ssh-agent" -e SSH_AUTH_SOCK=/ssh-agent)
elif [ -d "$HOME/.ssh" ]; then
  SSH_FLAGS=(-v "$HOME/.ssh:/home/node/.ssh:ro")
fi

# TTY flags
TTY_FLAGS=()
if [ -t 0 ]; then TTY_FLAGS=(-it); else TTY_FLAGS=(-i); fi

# Make sure C/C++ env vars are visible
ENV_FLAGS=(-e CC=gcc -e CXX=g++)

exec docker run --rm "${TTY_FLAGS[@]}" \
  -v "$WORKDIR:/work" -w /work \
  -v "$CLAUDE_HOME:/home/node/.claude" \
  "${GH_MOUNT[@]}" \
  "${GITCONFIG_MOUNT[@]}" \
  "${SSH_FLAGS[@]}" \
  "${ENV_FLAGS[@]}" \
  "$IMAGE" "$@"