# AI Agents and Automation Setup Guide

This guide provides complete instructions for setting up all AI agents, automation tools, and dependencies for this project.

## Table of Contents

1. [Node.js and npm Installation](#nodejs-and-npm-installation)
2. [Auto-Dependency Installation](#auto-dependency-installation)
3. [Git Hooks Setup](#git-hooks-setup)
4. [Jules Agent (Google AI)](#jules-agent-google-ai)
5. [Qodo Plugin](#qodo-plugin)
6. [Cursor Agent](#cursor-agent)
7. [Kombai Agent](#kombai-agent)
8. [PDF Collection](#pdf-collection)
9. [Complete Setup Process](#complete-setup-process)

---

## Node.js and npm Installation

### Automatic Installation

Run the automated installation script:

```powershell
# Run as Administrator
.\install-nodejs-npm.ps1
```

This script will:
- ✅ Check if Node.js and npm are already installed
- ✅ Install Node.js LTS using winget (if available)
- ✅ Verify installation
- ✅ Update PATH environment variable

### Manual Installation

If automatic installation fails:

1. Visit [https://nodejs.org/](https://nodejs.org/)
2. Download the LTS (Long Term Support) version for Windows
3. Run the installer with default settings
4. Restart your terminal
5. Verify installation:
   ```powershell
   node --version
   npm --version
   ```

### What Gets Installed

- **Node.js**: JavaScript runtime (v18.x or v20.x LTS)
- **npm**: Node package manager (comes with Node.js)
- **npx**: Package runner (comes with npm)

---

## Auto-Dependency Installation

### Overview

Automatically detect and install dependencies for all projects in the repository.

### Supported Project Types

- **Node.js**: `package.json` → `npm install`
- **Python**: `requirements.txt` → `pip install`
- **Ruby**: `Gemfile` → `bundle install`

### Manual Run

```powershell
# Run dependency installation
.\auto-install-dependencies.ps1

# Force reinstall (even if already installed)
.\auto-install-dependencies.ps1 -Force
```

### What It Does

1. Scans repository for project files
2. Detects project type (Node.js, Python, Ruby)
3. Checks if dependencies are already installed
4. Installs missing dependencies
5. Provides detailed summary

---

## Git Hooks Setup

### Overview

Automatically install dependencies when pulling changes from Git.

### Setup

```powershell
# Run setup script
.\setup-git-hooks.ps1
```

This creates two Git hooks:

1. **post-merge**: Runs after `git pull` or `git merge`
2. **post-checkout**: Runs after branch checkout

### How It Works

When you pull changes:
1. Git detects if dependency files changed
2. Automatically runs `auto-install-dependencies.ps1`
3. Installs any new dependencies
4. Reports installation status

### Manual Trigger

If hooks don't run automatically:
```powershell
.\auto-install-dependencies.ps1
```

---

## Jules Agent (Google AI)

### Overview

AI agent powered by Google's Gemini for trading automation, code review, and PR management.

### Setup Steps

#### 1. Get API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with: `Lengkundee01@gmail.com`
3. Create new API key
4. Copy the key (shown only once)

#### 2. Configure API Key

**Option A: Environment Variable (Recommended)**
```powershell
[System.Environment]::SetEnvironmentVariable('GOOGLE_AI_API_KEY', 'YOUR_API_KEY', 'User')
```

**Option B: Windows Credential Manager**
```powershell
# Store securely in Windows Credential Manager
cmdkey /generic:GoogleAI /user:GOOGLE_AI_API_KEY /pass:YOUR_API_KEY
```

#### 3. Configuration File

Copy example config and customize:
```powershell
Copy-Item .cursor/rules/ai-agents/jules-agent-config.example.json .cursor/rules/ai-agents/jules-agent-config.json

# Edit the config file with your settings
notepad .cursor/rules/ai-agents/jules-agent-config.json
```

#### 4. Install Dependencies

**For Python Integration:**
```powershell
pip install google-generativeai
```

**For Node.js Integration:**
```powershell
npm install @google/generative-ai
```

#### 5. Test Configuration

```powershell
# Test API key and configuration
python -c "import google.generativeai as genai; genai.configure(api_key='YOUR_KEY'); print('✓ Jules agent configured')"
```

### Features

- **Auto Review**: Automatically review PRs for quality, security, and style
- **Auto Merge**: Merge approved PRs automatically
- **Auto Commit**: Generate intelligent commit messages
- **Trading Schedule**: Automate trading based on market sessions

### Documentation

See [JULES-AGENT.md](.cursor/rules/ai-agents/JULES-AGENT.md) for complete documentation.

---

## Qodo Plugin

### Overview

AI-powered code quality and test generation plugin.

### Setup Steps

#### 1. Install Plugin

**For VS Code/Cursor:**
1. Open Extensions (Ctrl+Shift+X)
2. Search for "Qodo" or "Codium AI"
3. Click Install

**For JetBrains IDEs:**
1. File → Settings → Plugins
2. Search for "Qodo"
3. Install and restart

#### 2. Get API Key (Optional)

1. Visit [qodo.ai](https://www.qodo.ai/)
2. Sign up/login
3. Settings → API Keys → Generate new key

#### 3. Configure API Key

**Option A: Extension Settings**
- Open Qodo extension settings
- Enter API key in "Qodo: API Key" field

**Option B: Environment Variable**
```powershell
[System.Environment]::SetEnvironmentVariable('QODO_API_KEY', 'YOUR_API_KEY', 'User')
```

#### 4. Configuration File

```powershell
Copy-Item .cursor/rules/ai-agents/qodo-config.example.json .cursor/rules/ai-agents/qodo-config.json

notepad .cursor/rules/ai-agents/qodo-config.json
```

### Features

- **Test Generation**: Generate unit tests for any function
- **Code Analysis**: Deep code quality analysis
- **Bug Detection**: Identify potential bugs and edge cases
- **Code Review**: Automated code review feedback
- **Documentation**: Generate code documentation

### Documentation

See [QODO-PLUGIN.md](.cursor/rules/ai-agents/QODO-PLUGIN.md) for complete documentation.

---

## Cursor Agent

### Overview

AI-powered code editor with intelligent code completion and generation.

### Setup Steps

#### 1. Install Cursor

1. Download from [cursor.sh](https://cursor.sh/)
2. Install for Windows
3. Launch and sign in

#### 2. Configure Project Rules

The project already has Cursor rules in `.cursor/rules/`:
- ✅ PowerShell standards
- ✅ Security patterns
- ✅ Automation rules
- ✅ Trading system rules
- ✅ AI agents integration

#### 3. Optional: OpenAI Integration

```powershell
# For enhanced features (optional)
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'YOUR_KEY', 'User')
```

#### 4. Keyboard Shortcuts

Learn these shortcuts:
- `Ctrl+K`: AI command palette
- `Ctrl+L`: AI chat
- `Ctrl+Shift+L`: Edit with AI
- `Ctrl+.`: Quick fix

### Features

- **AI Completion**: Context-aware code suggestions
- **Code Generation**: Generate from natural language
- **Multi-file Editing**: Edit multiple files at once
- **Chat Interface**: Conversational coding assistance
- **Custom Rules**: Project-specific AI behavior

### Documentation

See [CURSOR-AGENT.md](.cursor/rules/ai-agents/CURSOR-AGENT.md) for complete documentation.

---

## Kombai Agent

### Overview

Convert Figma designs and screenshots into production-ready code.

### Setup Steps

#### 1. Create Account

1. Visit [kombai.com](https://kombai.com/)
2. Sign up with: `Lengkundee01@gmail.com`
3. Choose plan (free tier available)

#### 2. Get API Key

1. Login to Kombai dashboard
2. Settings → API Keys
3. Generate new key
4. Copy and store securely

#### 3. Configure API Key

```powershell
[System.Environment]::SetEnvironmentVariable('KOMBAI_API_KEY', 'YOUR_API_KEY', 'User')
```

#### 4. Install Figma Plugin

1. Open Figma
2. Plugins → Browse Plugins
3. Search "Kombai"
4. Install and connect account

#### 5. Configuration File

```powershell
Copy-Item .cursor/rules/ai-agents/kombai-config.example.json .cursor/rules/ai-agents/kombai-config.json

notepad .cursor/rules/ai-agents/kombai-config.json
```

### Features

- **Figma to Code**: Convert designs to React/HTML/Vue
- **Screenshot to Code**: Generate code from images
- **Component Extraction**: Identify reusable components
- **Responsive Design**: Auto-generate responsive layouts

### Documentation

See [KOMBAI-AGENT.md](.cursor/rules/ai-agents/KOMBAI-AGENT.md) for complete documentation.

---

## PDF Collection

### Overview

Collect and catalog all PDF files in the repository.

### Usage

```powershell
# Collect PDFs and create notebook
.\collect-pdfs.ps1

# Also copy to clipboard
.\collect-pdfs.ps1 -ClipToClipboard

# Custom output file
.\collect-pdfs.ps1 -OutputNotebook "MyPDFs.md"
```

### What It Does

1. Scans repository for PDF files
2. Excludes gitignored directories
3. Creates markdown notebook with:
   - File paths
   - File sizes
   - Modification dates
   - Summary statistics

### Output

Creates `PDF-Collection-Notebook.md` with:
- Complete PDF inventory
- File metadata
- Summary statistics

**Note**: PDFs are excluded from git by default (see `.gitignore`)

---

## Complete Setup Process

### Quick Start (Recommended)

Run all setup scripts in order:

```powershell
# 1. Install Node.js and npm
.\install-nodejs-npm.ps1

# 2. Set up Git hooks
.\setup-git-hooks.ps1

# 3. Install dependencies
.\auto-install-dependencies.ps1

# 4. Collect PDFs (optional)
.\collect-pdfs.ps1
```

### Full Setup with All Agents

```powershell
# 1. System Prerequisites
.\install-nodejs-npm.ps1

# 2. Git Automation
.\setup-git-hooks.ps1
.\auto-install-dependencies.ps1

# 3. Configure Jules Agent
# - Get Google AI API key
# - Set environment variable
[System.Environment]::SetEnvironmentVariable('GOOGLE_AI_API_KEY', 'YOUR_KEY', 'User')
pip install google-generativeai

# 4. Install Qodo Plugin
# - Install in VS Code/Cursor
# - Configure API key (optional)

# 5. Setup Cursor
# - Install Cursor IDE
# - Project rules already configured

# 6. Setup Kombai
# - Create account
# - Install Figma plugin
# - Configure API key

# 7. Collect PDFs
.\collect-pdfs.ps1

# 8. Verify Everything
node --version
npm --version
git hook --list
```

### Verification Checklist

After setup, verify:

- [ ] Node.js and npm installed (`node --version`)
- [ ] Git hooks created (check `.git/hooks/`)
- [ ] Dependencies installed (check `node_modules/`)
- [ ] Jules agent configured (API key set)
- [ ] Qodo plugin installed (in IDE)
- [ ] Cursor IDE configured
- [ ] Kombai account created
- [ ] PDF collection notebook generated

---

## Environment Variables Summary

Set these environment variables for full functionality:

```powershell
# Required for Jules Agent
[System.Environment]::SetEnvironmentVariable('GOOGLE_AI_API_KEY', 'YOUR_KEY', 'User')

# Optional for Qodo enhanced features
[System.Environment]::SetEnvironmentVariable('QODO_API_KEY', 'YOUR_KEY', 'User')

# Optional for Cursor enhanced features
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'YOUR_KEY', 'User')

# Required for Kombai API access
[System.Environment]::SetEnvironmentVariable('KOMBAI_API_KEY', 'YOUR_KEY', 'User')
```

---

## Security Notes

### API Keys

- **Never commit API keys** to git
- Use environment variables or Windows Credential Manager
- Config files with keys are gitignored
- Rotate keys every 90 days

### Protected Files

The following are automatically excluded from git:
- `*-config.json` (actual config files)
- `node_modules/`
- `generated-components/`
- API keys and secrets
- PDFs and sensitive documents

### Safe Configuration

Use `.example.json` files as templates:
1. Copy example: `jules-agent-config.example.json`
2. Rename to: `jules-agent-config.json`
3. Add your API keys
4. File is gitignored automatically

---

## Troubleshooting

### Node.js Installation Failed

**Problem**: winget not available or installation failed

**Solution**: Download manually from [nodejs.org](https://nodejs.org/)

### Dependencies Not Installing

**Problem**: `npm install` fails

**Solution**:
```powershell
# Clear cache and retry
npm cache clean --force
npm install
```

### Git Hooks Not Running

**Problem**: Hooks don't trigger after pull

**Solution**:
```powershell
# Make hooks executable (Git Bash)
chmod +x .git/hooks/post-merge
chmod +x .git/hooks/post-checkout

# Or run manually
.\auto-install-dependencies.ps1
```

### API Keys Not Working

**Problem**: "API key not found" error

**Solution**:
```powershell
# Verify environment variable
$env:GOOGLE_AI_API_KEY
$env:QODO_API_KEY
$env:KOMBAI_API_KEY

# Set if missing
[System.Environment]::SetEnvironmentVariable('VARIABLE_NAME', 'YOUR_KEY', 'User')

# Restart terminal for changes to take effect
```

---

## Support and Documentation

### Documentation Files

- **This Guide**: `AI-AGENTS-SETUP-GUIDE.md`
- **Jules Agent**: `.cursor/rules/ai-agents/JULES-AGENT.md`
- **Qodo Plugin**: `.cursor/rules/ai-agents/QODO-PLUGIN.md`
- **Cursor Agent**: `.cursor/rules/ai-agents/CURSOR-AGENT.md`
- **Kombai Agent**: `.cursor/rules/ai-agents/KOMBAI-AGENT.md`
- **AI Agents README**: `.cursor/rules/ai-agents/README.md`

### Example Configurations

- `jules-agent-config.example.json`
- `qodo-config.example.json`
- `kombai-config.example.json`

### Project Resources

- **System Info**: `SYSTEM-INFO.md`
- **Automation Rules**: `AUTOMATION-RULES.md`
- **Project README**: `README.md`
- **Agent Instructions**: `AGENTS.md`

---

## Integration with Existing Systems

### VPS Trading System

Jules agent integrates with:
- `auto-start-vps-admin.ps1` - VPS automation
- `master-trading-orchestrator.ps1` - Trading schedule
- `launch-exness-trading.ps1` - Trading operations

### Code Review Automation

AI agents enhance:
- `review-and-merge-prs.ps1` - PR automation
- `github-review-and-decide.ps1` - Intelligent decisions
- `auto-review-merge-inject-repos.ps1` - Multi-repo automation

### Development Workflow

Improved workflows:
1. Design in Figma → Kombai → Code
2. Write code → Qodo → Tests
3. Commit → Jules → Review
4. PR → Jules → Auto-merge
5. Pull → Git hooks → Dependencies

---

## Next Steps

After completing setup:

1. **Test Each Agent**: Verify all agents work individually
2. **Create First PR**: Test Jules auto-review
3. **Generate Tests**: Use Qodo for test generation
4. **Convert Design**: Try Kombai with a simple design
5. **Automate Workflow**: Enable auto-merge and auto-commit
6. **Monitor Usage**: Check API usage and limits
7. **Document Custom Rules**: Add project-specific patterns

---

## License

This setup is for personal use in the A6-9V organization.

## Author

Lengkundee01 / A6-9V

## Last Updated

2025-01-02
