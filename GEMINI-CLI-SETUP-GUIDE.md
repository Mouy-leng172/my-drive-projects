# Google Gemini CLI v0.22.5 - Setup Guide

This guide provides instructions for installing and configuring the Google Gemini CLI v0.22.5 on your system.

## 📋 Overview

Google Gemini CLI is an open-source AI command-line interface that provides direct access to Google's Gemini AI models from your terminal. It enables developers to:

- Run text and code prompts directly from the command line
- Automate workflows with AI integration
- Analyze code, images, and PDFs
- Integrate AI capabilities into scripts and DevOps tasks
- Prototype multimodal applications

## 🔧 System Requirements

### Prerequisites
- **Node.js**: Version 18 or higher (v20+ recommended)
- **npm**: Comes with Node.js installation
- **Operating System**: 
  - Windows 11 (or Windows 10)
  - Linux (Ubuntu, Debian, Fedora, etc.)
  - macOS

### Verify Prerequisites

Check your Node.js version:
```bash
node -v
```

Check your npm version:
```bash
npm -v
```

If Node.js is not installed or the version is below 18, install or upgrade:

**Ubuntu/Debian:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Windows:**
- Download from [nodejs.org](https://nodejs.org/)
- Or use Chocolatey: `choco install nodejs`

**macOS:**
```bash
brew install node
```

## 🚀 Installation

### Automated Installation

We provide automated installation scripts for your convenience:

#### Windows

**Option 1: Using the Batch File**
```batch
# Double-click on:
INSTALL-GEMINI-CLI.bat
```

**Option 2: Using PowerShell**
```powershell
# Run as Administrator
.\install-gemini-cli.ps1
```

#### Linux/macOS

```bash
# Make the script executable (if not already)
chmod +x install-gemini-cli.sh

# Run the installation script
./install-gemini-cli.sh

# Or with sudo if needed for global installation
sudo ./install-gemini-cli.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# Install globally using npm
npm install -g @google/gemini-cli@0.22.5

# Verify installation
gemini --version
```

### Installation Verification

After installation, verify that the Gemini CLI is accessible:

```bash
# Check version
gemini --version

# View help
gemini --help
```

## ⚙️ Configuration and Setup

### First-Time Setup

When you run Gemini CLI for the first time, it will prompt you to:

1. **Choose a theme** (light/dark)
2. **Login** using one of these methods:
   - Google Account (OAuth)
   - API Key (for higher rate limits)

### Authentication Options

#### Option 1: Google Account Login

Simply run:
```bash
gemini
```

This will open a browser window for Google OAuth authentication.

#### Option 2: API Key

For higher rate limits and automation, use an API key:

**Windows:**
```powershell
$env:GEMINI_API_KEY = "your_api_key_here"
```

**Linux/macOS:**
```bash
export GEMINI_API_KEY="your_api_key_here"
```

To make it permanent, add to your shell configuration:

**Bash (~/.bashrc or ~/.bash_profile):**
```bash
echo 'export GEMINI_API_KEY="your_api_key_here"' >> ~/.bashrc
source ~/.bashrc
```

**PowerShell (Profile):**
```powershell
# Edit your PowerShell profile
notepad $PROFILE

# Add this line:
$env:GEMINI_API_KEY = "your_api_key_here"
```

### Getting an API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google Account
3. Create a new API key
4. Copy the key and set it as an environment variable

## 📚 Usage Examples

### Basic Usage

**Interactive Mode:**
```bash
gemini
```

**Single Prompt:**
```bash
gemini "Explain how async/await works in JavaScript"
```

**Analyze a File:**
```bash
gemini "Review this code for bugs" --file script.js
```

**Process an Image:**
```bash
gemini "Describe this image" --file image.png
```

### Advanced Features

**Code Analysis:**
```bash
gemini "Find potential security issues" --file app.py
```

**Git Integration:**
```bash
gemini git "Generate a commit message for staged changes"
```

**DevOps Tasks:**
```bash
gemini "Create a Dockerfile for a Node.js application"
```

**Multiline Prompts:**
```bash
gemini "
What are the differences between:
1. Promise.all()
2. Promise.race()
3. Promise.allSettled()
"
```

## 🔒 Security Best Practices

1. **Never commit API keys** to version control
   - API keys are sensitive credentials
   - Use environment variables or secure key management

2. **Use `.gitignore`** to exclude:
   ```
   # Gemini CLI configuration
   .gemini/
   gemini-config.json
   *.gemini-key
   ```

3. **Rotate API keys** regularly for security

4. **Use Google Account OAuth** for personal use when possible

## 🛠️ Troubleshooting

### Command Not Found

If `gemini` command is not found after installation:

**Windows:**
- Restart your terminal/PowerShell
- Check npm global path: `npm config get prefix`
- Ensure the npm global directory is in your PATH

**Linux/macOS:**
```bash
# Add npm global bin to PATH
export PATH="$(npm config get prefix)/bin:$PATH"

# Or for user-level installations
export PATH="$HOME/.local/bin:$PATH"
```

### Permission Errors

**Windows:**
- Run PowerShell as Administrator
- Or configure npm for user-level global installs

**Linux:**
```bash
# Use nvm (Node Version Manager) for better permission management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
```

### Node.js Version Issues

If you get version errors:
```bash
# Check current version
node -v

# Upgrade Node.js using your package manager or download from nodejs.org
```

## 📖 Additional Resources

- **Official Documentation**: [Gemini CLI Docs](https://google-gemini.github.io/gemini-cli/)
- **GitHub Repository**: [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli)
- **Release Notes**: [v0.22.5 Release](https://github.com/google-gemini/gemini-cli/releases/tag/v0.22.5)
- **Google AI Studio**: [makersuite.google.com](https://makersuite.google.com/)

## 🔗 Integration with This Project

The Gemini CLI can be integrated into this project's automation workflows:

### PowerShell Integration

```powershell
# Example: Use Gemini CLI in automation scripts
$response = gemini "Generate a Python function to validate email addresses"
Write-Host $response
```

### Git Workflow Integration

```bash
# Generate commit messages
gemini git "Generate commit message" | git commit -F -

# Code review assistance
gemini "Review changes" --file $(git diff)
```

### CI/CD Integration

Add to your GitHub Actions or automation scripts:
```yaml
- name: AI Code Review
  run: |
    gemini "Review this pull request" --file $(git diff)
```

## 📝 Notes

- This installation is compatible with the NuNa Windows 11 system
- Node.js v20 is the recommended version for optimal performance
- For 24/7 trading automation systems, consider using API keys for reliability
- Gemini CLI respects rate limits; use API keys for higher limits

## 🆘 Support

If you encounter issues:

1. Check the [Troubleshooting](#-troubleshooting) section above
2. Review the [official documentation](https://google-gemini.github.io/gemini-cli/)
3. Check for updates: `npm update -g @google/gemini-cli`
4. File issues at: [GitHub Issues](https://github.com/google-gemini/gemini-cli/issues)

## 📄 License

Google Gemini CLI is released under the Apache 2.0 License.

---

**Last Updated**: 2026-01-02  
**System**: NuNa (Windows 11 Home Single Language 25H2)  
**Gemini CLI Version**: v0.22.5
