# Gemini CLI - Quick Start Guide

Quick reference for using Google Gemini CLI v0.22.5 in your projects.

## 🚀 Installation

### Quick Install
```bash
# Linux/macOS
./install-gemini-cli.sh

# Windows (Run as Administrator)
INSTALL-GEMINI-CLI.bat
```

## 🎯 Common Commands

### Basic Usage

```bash
# Interactive mode
gemini

# One-shot prompt
gemini "Explain what this code does" < script.py

# With files
gemini "Review this code for bugs" --file main.js
```

### Code Analysis

```bash
# Analyze code
gemini "Find potential bugs in this code" --file app.py

# Security review
gemini "Check for security vulnerabilities" --file server.js

# Code optimization
gemini "Suggest optimizations for this function" --file utils.py
```

### Git Integration

```bash
# Generate commit message
git diff | gemini "Generate a concise commit message"

# Code review
git diff main..feature | gemini "Review these changes"

# Explain git history
git log --oneline -10 | gemini "Summarize these commits"
```

### Documentation

```bash
# Generate documentation
gemini "Write comprehensive documentation" --file module.py

# Create README
gemini "Generate a README for this project" --file package.json

# API documentation
gemini "Document this API endpoint" --file routes.js
```

### DevOps & Automation

```bash
# Create Dockerfile
gemini "Create a production-ready Dockerfile for a Node.js app"

# CI/CD configuration
gemini "Generate a GitHub Actions workflow for testing and deployment"

# Infrastructure as Code
gemini "Create Terraform configuration for AWS Lambda"
```

## ⚙️ Configuration

### Set API Key

```bash
# Linux/macOS
export GEMINI_API_KEY="your_api_key_here"

# Windows PowerShell
$env:GEMINI_API_KEY = "your_api_key_here"
```

### Model Selection

```bash
# Use specific model
gemini --model gemini-pro "Your prompt here"

# Available models
gemini --help
```

## 🔧 Automation Examples

### PowerShell Script

```powershell
# Auto-generate commit messages
function ai-commit {
    $diff = git diff --staged
    if ($diff) {
        $message = $diff | gemini "Generate a concise commit message"
        git commit -m $message
    }
}
```

### Bash Script

```bash
#!/bin/bash
# AI-powered code review
ai_review() {
    git diff "$1" | gemini "Review these changes and suggest improvements"
}

# Usage: ai_review main..feature
```

### Batch Processing

```bash
# Review all Python files
find . -name "*.py" -exec gemini "Quick code review" --file {} \;

# Generate documentation for all JS files
for file in src/*.js; do
    gemini "Generate JSDoc comments" --file "$file" > "${file}.doc.md"
done
```

## 💡 Tips & Tricks

### 1. Context-Rich Prompts

```bash
# Provide context for better results
gemini "This is a trading bot. Review for potential issues:" --file bot.py
```

### 2. Chain Commands

```bash
# Combine with other tools
eslint src/ | gemini "Explain these lint errors and suggest fixes"
```

### 3. Interactive Development

```bash
# Start interactive session with context
gemini --prompt-interactive "I'm working on a React component"
```

### 4. JSON Output

```bash
# Get structured output
gemini --output-format json "List 5 best practices for Python"
```

## 🔍 Debugging

```bash
# Debug mode for troubleshooting
gemini --debug "Your prompt here"

# View available extensions
gemini --list-extensions

# Resume previous session
gemini --resume latest
```

## 📋 Integration with Project Tools

### Trading System

```bash
# Analyze trading strategy
gemini "Review this trading strategy for risks" --file strategy.py

# Optimize performance
gemini "Optimize this MQL5 EA code" --file ExpertAdvisor.mq5
```

### Security Checks

```bash
# Security scan
gemini "Perform security audit" --file auth.js

# Check for secrets
gemini "Find hardcoded credentials" --file config.py
```

### Documentation Generation

```bash
# Auto-document PowerShell scripts
gemini "Generate comprehensive documentation" --file script.ps1 > DOCS.md
```

## 🛠️ Common Workflows

### Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit
echo "Running AI code review..."
git diff --staged | gemini "Quick review of changes for obvious issues"
```

### Pull Request Review

```bash
# Review PR changes
gh pr diff 123 | gemini "Comprehensive code review with suggestions"
```

### Refactoring Assistant

```bash
# Get refactoring suggestions
gemini "Suggest modern JavaScript refactoring" --file legacy-code.js
```

## 📚 Resources

- Full documentation: [GEMINI-CLI-SETUP-GUIDE.md](./GEMINI-CLI-SETUP-GUIDE.md)
- Official docs: https://google-gemini.github.io/gemini-cli/
- GitHub: https://github.com/google-gemini/gemini-cli
- Get API key: https://makersuite.google.com/app/apikey

## 🔐 Security Notes

- Never commit API keys
- Use environment variables for credentials
- Review AI-generated code before use
- Keep Gemini CLI updated: `npm update -g @google/gemini-cli`

## 🆘 Quick Troubleshooting

```bash
# Command not found
which gemini
npm config get prefix

# Update to latest
npm update -g @google/gemini-cli

# Check version
gemini --version

# Reinstall
npm uninstall -g @google/gemini-cli
npm install -g @google/gemini-cli@0.22.5
```

---

**Version**: 0.22.5  
**Last Updated**: 2025-01-02
