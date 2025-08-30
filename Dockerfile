# Claude Code CLI with gh + gcc/g++(C++20) + gdb
FROM node:20-slim

# Base system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git openssh-client ca-certificates curl bash make pkg-config ripgrep gnupg \
    build-essential gdb cmake ninja-build \
    # Python support
    python3 python3-pip python3-venv python3-dev \
    # Text processing & utilities  
    jq tree fd-find bat xxd \
    # Debugging & profiling tools
    lldb valgrind strace ltrace lsof \
    # Network debugging
    tcpdump netcat-openbsd socat \
    # System monitoring
    htop iotop procps \
    # Testing utilities
    apache2-utils \
    # Additional dev tools
    vim nano less zip unzip \
  && rm -rf /var/lib/apt/lists/*

# Install Python development tools
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    pytest pytest-cov pytest-benchmark \
    black isort flake8 mypy \
    requests httpx \
    jupyter ipython \
    numpy pandas

# Install C++ testing frameworks
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtest-dev libgmock-dev \
    catch2 \
    # Coverage tools for C++
    gcovr lcov \
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
USER node

ENV HOME=/home/node
WORKDIR /work

# Run Claude Code CLI by default
ENTRYPOINT ["claude"]