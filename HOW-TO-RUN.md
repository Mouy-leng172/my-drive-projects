# How to Run This Project

This guide will help you set up and run the A6-9V/my-drive-projects automation system on your Windows device.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Setup](#detailed-setup)
4. [Running Individual Components](#running-individual-components)
5. [Troubleshooting](#troubleshooting)
6. [Common Use Cases](#common-use-cases)

## Prerequisites

Before you begin, ensure you have:

### Required Software
- **Windows 11** (tested on version 25H2, Build 26220.7344)
- **PowerShell 5.1+** (included with Windows 11)
- **Git** - Download from [git-scm.com](https://git-scm.com/)
- **Python 3.8+** - Download from [python.org](https://www.python.org/)

### Optional Software
- **GitHub CLI** (`gh`) - For OAuth authentication (recommended)
- **GitHub Desktop** - For GUI-based Git operations
- **MetaTrader 5** - For trading functionality
- **Cloud Sync Services** - OneDrive, Google Drive, or Dropbox

### System Requirements
- **Processor**: Intel Core i3 or better
- **RAM**: 8GB minimum (16GB recommended for trading)
- **Storage**: 50GB free space recommended
- **Internet**: Stable connection required for sync and trading

## Quick Start

The fastest way to get started:

### Step 1: Clone the Repository

```powershell
# Open PowerShell as Administrator
cd C:\Users\YOUR_USERNAME\OneDrive
git clone https://github.com/A6-9V/my-drive-projects.git
cd my-drive-projects
```

### Step 2: Run Initial Setup

```powershell
# Option A: Complete automated setup (recommended for first-time users)
.\RUN-COMPLETE-SETUP.bat

# Option B: Manual PowerShell execution
.\complete-device-setup.ps1
```

This will:
- ✅ Set up workspace structure
- ✅ Configure Windows settings
- ✅ Install necessary components
- ✅ Set up cloud sync services
- ✅ Configure Git repositories
- ✅ Apply security settings

### Step 3: Verify Installation

```powershell
.\setup-workspace.ps1
```

You should see green checkmarks indicating successful setup.

## Detailed Setup

### 1. Clone and Navigate

```powershell
# Create a workspace directory
mkdir C:\Workspace
cd C:\Workspace

# Clone the repository
git clone https://github.com/A6-9V/my-drive-projects.git
cd my-drive-projects
```

### 2. Install Python Dependencies

For the trading bridge system:

```powershell
# Create a virtual environment (recommended)
python -m venv venv

# Activate the virtual environment
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r trading-bridge\requirements.txt
```

### 3. Configure Git Authentication

#### Option A: Using GitHub CLI (Recommended)

```powershell
# Install GitHub CLI if not already installed
winget install --id GitHub.cli

# Login with OAuth (most secure)
gh auth login

# Configure git to use gh for authentication
gh auth setup-git
```

#### Option B: Using Personal Access Token

1. Go to [GitHub Settings > Developer Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Generate a new token with `repo` scope
3. Create `git-credentials.txt` (will be gitignored automatically):
   ```
   GITHUB_TOKEN=your_token_here
   ```

### 4. Configure Windows Settings

```powershell
# Run as Administrator
.\complete-windows-setup.ps1
```

This configures:
- File Explorer settings
- Default browser
- Windows Defender exclusions
- Firewall rules
- Cloud service integration

### 5. Set Up Cloud Sync (Optional)

```powershell
.\setup-cloud-sync.ps1
```

Supported services:
- Microsoft OneDrive
- Google Drive
- Dropbox

## Running Individual Components

### Windows Automation

```powershell
# Complete Windows setup
.\complete-windows-setup.ps1

# Set up workspace
.\setup-workspace.ps1

# Configure cloud sync
.\setup-cloud-sync.ps1

# Set up auto-startup
.\setup-auto-startup-admin.ps1
```

### Git Automation

```powershell
# Push all changes automatically
.\auto-git-push.ps1

# Review and merge PRs
.\review-and-merge-prs.ps1

# Clean up stale branches
.\cleanup-stale-branches.ps1
```

### Trading System

#### Prerequisites for Trading
1. Install MetaTrader 5
2. Configure broker credentials in `trading-bridge/config/brokers.json`
3. Set up firewall rules for port 5500

#### Start Trading System

```powershell
# Complete trading system setup
.\setup-trading-system.ps1

# Start trading bridge
.\start-trading-system-admin.ps1

# Start MQL.io service (operations management)
.\start-mql-io-service.ps1

# Or use batch files:
START-TRADING-SYSTEM.bat
START-MQL-IO-SERVICE.bat
```

### VPS 24/7 System

For running the system on a VPS:

```powershell
# Auto-start all VPS services
.\auto-start-vps-admin.ps1

# Or use the batch file:
AUTO-START-VPS.bat
```

This starts:
- Exness MT5 Terminal (24/7 trading)
- Web Research Service (Perplexity AI)
- GitHub Website Service
- CI/CD Automation Service
- MQL5 Forge Integration

### Project Scanner

```powershell
# Scan all drives for development projects
cd project-scanner
.\scan-all-drives.ps1

# Execute discovered projects
.\execute-projects.ps1
```

### Backup and Storage Management

```powershell
# Backup to USB drives
.\backup-to-usb.ps1

# Backup MQL5 files
.\backup-mql5-to-usb.ps1

# Check all drives
.\check-all-drives.ps1

# Monitor disk health
.\disk-health-monitor.ps1
```

## Troubleshooting

### Common Issues

#### 1. PowerShell Execution Policy Error

**Problem**: "cannot be loaded because running scripts is disabled"

**Solution**:
```powershell
# Run as Administrator
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 2. Git Authentication Fails

**Problem**: Git push/pull fails with authentication error

**Solution**:
```powershell
# Use GitHub CLI (recommended)
gh auth login
gh auth setup-git

# Or update your PAT in git-credentials.txt
```

#### 3. Python Module Not Found

**Problem**: `ModuleNotFoundError` when running Python scripts

**Solution**:
```powershell
# Ensure virtual environment is activated
.\venv\Scripts\Activate.ps1

# Reinstall dependencies
pip install -r trading-bridge\requirements.txt
```

#### 4. Cloud Sync Service Not Found

**Problem**: Script reports cloud service not installed

**Solution**:
- The script will skip missing services automatically
- Install desired cloud sync services manually:
  - OneDrive: Built into Windows 11
  - Google Drive: [Download here](https://www.google.com/drive/download/)
  - Dropbox: [Download here](https://www.dropbox.com/install)

#### 5. Permission Denied Errors

**Problem**: Access denied when running scripts

**Solution**:
```powershell
# Right-click PowerShell and select "Run as Administrator"
# Or use the elevation script:
.\launch-admin.ps1
```

#### 6. Trading Bridge Port 5500 Blocked

**Problem**: ZeroMQ connection fails

**Solution**:
```powershell
# Configure firewall for port 5500
.\trading-bridge\setup-firewall-port-5500.ps1

# Or use the batch file:
.\trading-bridge\SETUP-FIREWALL-5500.bat
```

### Getting Help

1. Check existing documentation:
   - `README.md` - Project overview
   - `AUTOMATION-RULES.md` - Automation principles
   - `SYSTEM-INFO.md` - System specifications
   - `TRADING-SYSTEM-QUICK-START.md` - Trading setup

2. Review specific guides:
   - `VPS-SETUP-GUIDE.md` - VPS deployment
   - `AUTO-MERGE-SETUP-GUIDE.md` - PR automation
   - `GITHUB-SECRETS-SETUP.md` - Secure credentials

3. Check logs:
   - Most scripts create log files in their directory
   - Check `*.log` and `*-report.txt` files

## Common Use Cases

### Use Case 1: Personal Automation Workstation

Setup Windows automation for daily tasks:

```powershell
# Initial setup
.\complete-windows-setup.ps1

# Set up auto-startup
.\setup-auto-startup-admin.ps1

# Configure cloud sync
.\setup-cloud-sync.ps1
```

### Use Case 2: Development Environment

Set up for software development:

```powershell
# Complete device setup
.\complete-device-setup.ps1

# Set up Git automation
.\git-setup.ps1

# Install Python environment
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r trading-bridge\requirements.txt
```

### Use Case 3: Trading System

Set up automated trading:

```powershell
# 1. Complete system setup
.\complete-device-setup.ps1

# 2. Set up trading system
.\setup-trading-system.ps1

# 3. Configure brokers (manual step - edit config files)
# Edit: trading-bridge\config\brokers.json
# Edit: trading-bridge\config\symbols.json

# 4. Start trading
.\start-trading-system-admin.ps1

# 5. Set up auto-start (optional)
.\setup-trading-auto-start.ps1
```

### Use Case 4: VPS Deployment

Deploy to a remote VPS:

```powershell
# 1. Push all code to GitHub
.\auto-git-push.ps1

# 2. On VPS: Clone and setup
git clone https://github.com/A6-9V/my-drive-projects.git
cd my-drive-projects

# 3. Deploy VPS services
.\vps-deployment.ps1

# 4. Start 24/7 system
.\auto-start-vps-admin.ps1
```

### Use Case 5: Multi-Drive Project Management

Manage projects across multiple drives:

```powershell
# Scan all drives for projects
cd project-scanner
.\scan-all-drives.ps1

# Push all discovered projects to GitHub
cd ..
.\push-all-drives-to-same-repo.ps1

# Review and merge all PRs
.\review-and-merge-prs.ps1
```

## Next Steps

After completing the setup:

1. **Review Security Settings**
   ```powershell
   .\security-check.ps1
   ```

2. **Configure GitHub Secrets** (for CI/CD)
   ```powershell
   .\setup-github-secrets.ps1
   ```

3. **Set Up Auto-Merge** (optional)
   ```powershell
   .\setup-auto-merge.ps1
   ```

4. **Create Backups**
   ```powershell
   .\backup-to-usb.ps1
   ```

5. **Monitor System Health**
   ```powershell
   .\system-status-report.ps1
   ```

## Documentation

For more detailed information, see:

- **DEVICE-SKELETON.md** - Complete device structure blueprint
- **PROJECT-BLUEPRINTS.md** - Detailed project blueprints
- **WORKSPACE-SETUP.md** - Workspace configuration guide
- **AUTOMATION-RULES.md** - Automation principles and rules
- **GITHUB-DESKTOP-RULES.md** - GitHub Desktop integration
- **MANUAL-SETUP-GUIDE.md** - Step-by-step manual setup

## Support

For issues, questions, or contributions:
- Check documentation in the repository
- Review existing issues on GitHub
- Create a new issue with detailed information

---

**Last Updated**: 2026-01-02  
**Repository**: A6-9V/my-drive-projects  
**Maintained by**: Lengkundee01 / A6-9V
