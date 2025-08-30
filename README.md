# Claude Code CLI in Docker

A comprehensive dockerized Claude Code CLI with full development toolchain for Python and C++ projects.

## ⚡ Quick Start

### Build once
```bash
./build.sh
```

### Run on the current repo
```bash
./run-claude.sh
```
This opens the Claude REPL in your terminal at /work (your repo).

First run will ask you to auth Claude Code in a browser. Your session persists in ~/.claude.

### One-shot commands
```bash
./run-claude.sh -p "Analyze this codebase"
./run-claude.sh -p "Generate unit tests for main.cpp"
./run-claude.sh -p "Review code for security issues"
```

### Continue last session
```bash
./run-claude.sh --continue
```

### Advanced flags
```bash
--permission-mode [ask|plan|skip]   # Control how Claude handles dangerous operations
--model claude-3-5-sonnet-20240620  # Specify model version
--max-turns 10                      # Limit conversation length
--allowedTools shell,fs,git         # Restrict tool access
```

## 🛠️ Development Features

### Python Development
- **Runtime**: Python 3.11+ with pip, venv
- **Testing**: pytest, pytest-cov, pytest-benchmark
- **Code Quality**: black, isort, flake8, mypy
- **Libraries**: requests, httpx, numpy, pandas
- **Interactive**: jupyter, ipython

### C++ Development  
- **Compiler**: gcc/g++ with full C++20 support
- **Build Systems**: make, cmake, ninja
- **Testing**: GoogleTest, GoogleMock, Catch2
- **Debugging**: gdb, lldb, valgrind
- **Coverage**: gcovr, lcov
- **Memory Analysis**: AddressSanitizer, valgrind

### Debugging & Profiling
- **System**: strace, ltrace, lsof, htop, iotop  
- **Memory**: valgrind for leak detection
- **Network**: tcpdump, netcat, socat
- **Text Processing**: jq, tree, bat, hexdump

## 📋 Usage Examples

### Interactive Development Session
```bash
./run-claude.sh
```
Then in Claude:
- `"Build and test this C++ project"`  
- `"Set up pytest for this Python module"`
- `"Debug this segfault using gdb"`
- `"Optimize this algorithm and benchmark it"`

### Automated Code Analysis
```bash
./run-claude.sh -p "Run static analysis on all Python files and fix issues"
./run-claude.sh -p "Generate comprehensive test suite with coverage report"  
./run-claude.sh -p "Profile this C++ code and suggest optimizations"
```

### Testing Workflows
```bash
# Python testing
./run-claude.sh -p "Run pytest with coverage and generate report"

# C++ testing  
./run-claude.sh -p "Build and run GoogleTest suite, check for memory leaks"

# Performance testing
./run-claude.sh -p "Benchmark this function and compare with baseline"
```

### Debugging Sessions
```bash
# Debug crashes
./run-claude.sh -p "Use gdb to debug this segfault in main.cpp"

# Memory debugging
./run-claude.sh -p "Run valgrind to find memory leaks"

# Profile performance
./run-claude.sh -p "Profile with perf and generate flame graph"
```

## 🔗 Git/GitHub Integration

- **Repository Access**: Repo mounted at /work with full .git history
- **Authentication**: SSH agent forwarding or ~/.ssh mounting
- **GitHub CLI**: `gh pr create`, `gh issue list`, `gh workflow run`
- **Commits**: Write directly to your host repo
- **Branches**: Full git operations supported

Example workflows:
```bash
./run-claude.sh -p "Create feature branch, implement X, write tests, create PR"
./run-claude.sh -p "Review recent commits and suggest improvements"
./run-claude.sh -p "Fix CI failures and update documentation"
```

## 🏗️ Development Workflows

### Complete Feature Development
```bash
./run-claude.sh -p "
1. Analyze requirements in README
2. Design the architecture  
3. Implement core functionality
4. Write comprehensive tests
5. Add documentation
6. Run full test suite
7. Create pull request
"
```

### Code Review & Refactoring
```bash
./run-claude.sh -p "
1. Review all recent changes
2. Identify code smells and technical debt
3. Suggest refactoring opportunities
4. Implement improvements with tests
5. Verify performance hasn't regressed
"
```

### Bug Investigation & Fix
```bash
./run-claude.sh -p "
1. Reproduce the bug described in issue #123
2. Use gdb/valgrind to diagnose root cause
3. Implement fix with regression test
4. Verify fix doesn't break existing functionality
5. Update documentation if needed
"
```

### Performance Optimization
```bash  
./run-claude.sh -p "
1. Profile current performance bottlenecks
2. Benchmark critical code paths
3. Implement optimizations
4. Measure improvements
5. Add performance regression tests
"
```

## 🧪 Testing & Quality Assurance

### Comprehensive Test Coverage
```bash
# Generate and run full test suite
./run-claude.sh -p "Create unit tests for all modules, aim for 95%+ coverage"

# Performance testing
./run-claude.sh -p "Add benchmark tests and establish performance baselines"

# Integration testing  
./run-claude.sh -p "Create integration tests for the main user workflows"
```

### Code Quality Checks
```bash
# Python quality
./run-claude.sh -p "Run black, isort, flake8, mypy and fix all issues"

# C++ quality
./run-claude.sh -p "Check for memory leaks, undefined behavior, and style issues"

# Security analysis
./run-claude.sh -p "Analyze code for common security vulnerabilities"
```

## 🐛 Advanced Debugging

### Memory Issues
```bash
# Detect memory leaks
./run-claude.sh -p "Run valgrind and fix any memory leaks found"

# Buffer overflows
./run-claude.sh -p "Use AddressSanitizer to detect buffer overflows"

# Memory profiling
./run-claude.sh -p "Profile memory usage and optimize allocations"
```

### Performance Debugging  
```bash
# CPU profiling
./run-claude.sh -p "Use perf to identify CPU bottlenecks"

# System call analysis
./run-claude.sh -p "Use strace to analyze system call performance"

# Network debugging
./run-claude.sh -p "Debug network issues using tcpdump and netstat"
```

## 🔧 Environment Configuration

### Custom Environment Variables
```bash
# Set specific compiler flags
CXXFLAGS="-O3 -march=native" ./run-claude.sh

# Use different Claude model
CLAUDE_IMAGE="claude-cli:custom" ./run-claude.sh

# Mount additional directories
WORKDIR="/path/to/project" ./run-claude.sh
```

### Development Containers
```bash
# Skip permission prompts (use carefully)
./run-claude.sh --permission-mode skip

# Limit resource usage
./run-claude.sh --max-turns 5 --allowedTools fs,git
```

## 📦 Standalone Usage

Copy `standalone/claude-docker.sh` into any repo and run it there for a portable solution that automatically builds the image if needed.

```bash
# Copy to any project
cp standalone/claude-docker.sh /path/to/your/project/
cd /path/to/your/project/
./claude-docker.sh -p "Analyze this project and suggest improvements"
```

## 📁 Directory Structure

```
claude-cli-docker/
├─ Dockerfile           # Enhanced development environment
├─ build.sh             # Build with UID/GID handling  
├─ run-claude.sh        # Full-featured runner script
├─ .dockerignore        # Docker build exclusions
├─ README.md            # This comprehensive guide
└─ standalone/
   └─ claude-docker.sh  # Self-contained portable solution
```

## 🔍 Troubleshooting

### Common Issues
- **Permission errors**: Build runs with your UID/GID to avoid file ownership issues
- **SSH not working**: Ensure SSH agent is running or ~/.ssh exists  
- **GitHub auth**: Run `gh auth login` on host before mounting config
- **Large builds**: Increase Docker resource limits if builds fail