# Prerequisites and System Requirements

This document outlines all prerequisites and system requirements needed to run the A6-9V/my-drive-projects automation system.

## Operating System Requirements

### Windows 11
- **Minimum Version**: Windows 11 Home (any edition)
- **Recommended**: Windows 11 Pro or Enterprise for advanced features
- **Build**: 22000 or later
- **Tested On**: Windows 11 Home Single Language 25H2 (Build 26220.7344)

### Architecture
- **Required**: 64-bit x64-based processor
- **Not Supported**: 32-bit systems, ARM processors (not tested)

## Hardware Requirements

### Minimum Requirements
- **Processor**: Intel Core i3 or AMD Ryzen 3 (or equivalent)
- **RAM**: 8GB
- **Storage**: 50GB free space on system drive
- **Network**: Stable internet connection (5 Mbps minimum)

### Recommended for Trading
- **Processor**: Intel Core i5 or AMD Ryzen 5 (or better)
- **RAM**: 16GB
- **Storage**: 100GB+ free space (SSD recommended)
- **Network**: High-speed internet (20 Mbps or better, low latency)

### Storage Breakdown
- **Windows & Programs**: ~30GB
- **Project Files**: ~5GB
- **Python Environment**: ~2GB
- **MetaTrader 5**: ~500MB
- **Cloud Sync Cache**: ~10GB (varies)
- **Working Space**: ~20GB (logs, temporary files, data)

## Software Prerequisites

### Essential Software

#### 1. PowerShell
- **Version**: 5.1 or later (included with Windows 11)
- **Verification**:
  ```powershell
  $PSVersionTable.PSVersion
  ```
- **Execution Policy**: Must allow script execution
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

#### 2. Git for Windows
- **Version**: 2.30 or later
- **Download**: https://git-scm.com/download/win
- **Required Features**:
  - Git Bash
  - Git GUI
  - Git Credential Manager
- **Verification**:
  ```powershell
  git --version
  ```

#### 3. Python
- **Version**: 3.8 or later (3.10+ recommended)
- **Download**: https://www.python.org/downloads/
- **Installation Notes**:
  - ✅ Add Python to PATH
  - ✅ Install pip
  - ✅ Install tkinter (usually included)
- **Verification**:
  ```powershell
  python --version
  pip --version
  ```

### Recommended Software

#### 1. GitHub CLI (`gh`)
- **Purpose**: OAuth authentication, repository management
- **Installation**:
  ```powershell
  winget install --id GitHub.cli
  ```
- **Verification**:
  ```powershell
  gh --version
  ```

#### 2. GitHub Desktop
- **Purpose**: GUI-based Git operations
- **Download**: https://desktop.github.com/
- **Installation Path**: `%LOCALAPPDATA%\GitHubDesktop\`

#### 3. Visual Studio Code or Cursor
- **Purpose**: Code editing and development
- **Download**: 
  - VS Code: https://code.visualstudio.com/
  - Cursor: https://cursor.sh/
- **Recommended Extensions**:
  - PowerShell
  - Python
  - GitLens
  - GitHub Copilot (if available)

### Trading-Specific Software

#### 1. MetaTrader 5
- **Required For**: Trading functionality
- **Download**: https://www.metatrader5.com/en/download
- **Minimum Version**: Build 3000 or later
- **Platform**: Windows 64-bit

#### 2. Visual C++ Redistributables
- **Required For**: MetaTrader 5 and some Python packages
- **Usually included**: With Windows updates
- **Manual Download**: https://aka.ms/vs/17/release/vc_redist.x64.exe

## Python Dependencies

### Core Dependencies
All listed in `trading-bridge/requirements.txt`:

```
pyzmq>=25.1.0          # ZeroMQ for MQL5 communication
requests>=2.31.0       # HTTP requests for broker APIs
python-dotenv>=1.0.0   # Environment variable management
cryptography>=41.0.0   # Secure credential handling
schedule>=1.2.0        # Task scheduling
pywin32>=306           # Windows-specific functionality
```

### Installation
```powershell
# Using virtual environment (recommended)
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r trading-bridge\requirements.txt

# Or global installation
pip install -r trading-bridge\requirements.txt
```

### Optional Dependencies
For development:
```powershell
pip install pytest pytest-cov black pylint mypy
```

## Cloud Sync Services (Optional)

### Microsoft OneDrive
- **Included**: Built into Windows 11
- **Storage**: 5GB free (with Microsoft account)
- **Status**: Active by default

### Google Drive
- **Download**: https://www.google.com/drive/download/
- **Storage**: 15GB free (with Google account)
- **Installation**: Desktop app recommended

### Dropbox
- **Download**: https://www.dropbox.com/install
- **Storage**: 2GB free
- **Installation**: Desktop client

## Network Requirements

### Ports
The following ports must be available:

| Port  | Purpose                    | Direction | Protocol |
|-------|----------------------------|-----------|----------|
| 443   | HTTPS (GitHub, APIs)       | Outbound  | TCP      |
| 5500  | Trading Bridge (ZeroMQ)    | Both      | TCP      |
| 3389  | Remote Desktop (optional)  | Inbound   | TCP      |
| 22    | SSH (optional)             | Outbound  | TCP      |

### Firewall Configuration
Windows Firewall rules will be created automatically by setup scripts for:
- Cloud sync services (OneDrive, Google Drive, Dropbox)
- Trading Bridge (port 5500)
- MetaTrader 5

### Internet Requirements
- **Latency**: <100ms (for trading)
- **Speed**: 5 Mbps minimum, 20 Mbps recommended
- **Reliability**: Stable connection required for 24/7 operation

## GitHub Requirements

### Account Setup
1. **GitHub Account**: Free account sufficient
2. **Authentication**: 
   - **Recommended**: GitHub CLI with OAuth
   - **Alternative**: Personal Access Token (PAT)

### Personal Access Token (PAT)
If not using GitHub CLI:
1. Go to: https://github.com/settings/tokens
2. Generate new token (classic)
3. Required scopes:
   - `repo` - Full control of private repositories
   - `workflow` - Update GitHub Action workflows (if using CI/CD)
   - `read:org` - Read org and team membership (if in org)

### Repository Access
- **Read Access**: Required to clone
- **Write Access**: Required to push changes
- **Admin Access**: Required for some automation features

## Broker Requirements (For Trading)

### Exness (Primary)
- **Account Type**: Real or Demo
- **API Access**: Must be enabled
- **Minimum Deposit**: As per broker requirements
- **Verification**: Account must be verified for API access

### API Credentials
Required credentials (stored securely, never committed):
- **API Key**: From broker dashboard
- **API Secret**: From broker dashboard
- **Account Number**: MT5 account number
- **Server**: MT5 server address

## Security Requirements

### Windows Security
- **Windows Defender**: Should be enabled
- **Controlled Folder Access**: Will be configured by scripts
- **Firewall**: Windows Firewall should be enabled

### Credential Storage
- **Windows Credential Manager**: Used for secure token storage
- **Never commit**: 
  - API keys
  - Passwords
  - Tokens
  - Certificates (`.pem` files)
  - Configuration files with secrets

### Exclusions
The following are automatically added to `.gitignore`:
- `*.token`, `*.secret`
- `*credentials*`
- `*.pem`, `*.key`
- `config.local.*`
- `git-credentials.txt`

## Optional VPS Requirements

For 24/7 trading on a Virtual Private Server:

### VPS Specifications
- **OS**: Windows Server 2019/2022
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 50GB SSD
- **Network**: 100 Mbps, low latency
- **Uptime**: 99.9%+ guaranteed

### VPS Providers (Recommended)
- **Contabo**: Budget-friendly, good performance
- **DigitalOcean**: Reliable, easy to use
- **AWS EC2**: Enterprise-grade, scalable
- **Azure**: Good Windows integration
- **Google Cloud**: High performance

### Remote Access
- **RDP**: Enabled for remote desktop access
- **SSH**: Optional for advanced management
- **VPN**: Recommended for secure access

## Verification Checklist

Before running the project, verify:

### System Verification
```powershell
# Check PowerShell version (should be 5.1+)
$PSVersionTable.PSVersion

# Check execution policy (should be RemoteSigned or RemoteSigned)
Get-ExecutionPolicy

# Check Windows version
winver

# Check system info
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Type"
```

### Software Verification
```powershell
# Git
git --version

# Python
python --version

# Pip
pip --version

# GitHub CLI (optional)
gh --version
```

### Network Verification
```powershell
# Test internet connectivity
Test-NetConnection -ComputerName github.com -Port 443

# Test if port 5500 is available
Test-NetConnection -ComputerName localhost -Port 5500
```

### Python Environment Verification
```powershell
# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r trading-bridge\requirements.txt

# Verify key packages
python -c "import zmq; print('ZeroMQ:', zmq.zmq_version())"
python -c "import requests; print('Requests:', requests.__version__)"
```

## Automated Prerequisites Check

The repository includes a validation script:

```powershell
# Run prerequisites check
.\validate-setup.ps1
```

This will check:
- ✅ Operating system version
- ✅ PowerShell version
- ✅ Git installation
- ✅ Python installation
- ✅ Required Python packages
- ✅ Network connectivity
- ✅ Port availability
- ✅ Cloud services status

## Troubleshooting Prerequisites

### Issue: Python not found
**Solution**:
1. Install Python from python.org
2. Ensure "Add Python to PATH" is checked during installation
3. Restart PowerShell after installation

### Issue: Git not found
**Solution**:
1. Install Git from git-scm.com
2. Choose "Git from the command line and also from 3rd-party software"
3. Restart PowerShell after installation

### Issue: PowerShell script execution blocked
**Solution**:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: Port 5500 already in use
**Solution**:
```powershell
# Find process using port 5500
netstat -ano | findstr :5500

# Stop the process (replace PID with actual process ID)
Stop-Process -Id PID -Force
```

### Issue: Python package installation fails
**Solution**:
```powershell
# Upgrade pip
python -m pip install --upgrade pip

# Install with admin rights
Start-Process powershell -Verb RunAs -ArgumentList "-Command pip install -r trading-bridge\requirements.txt"
```

## Getting Help

If you encounter issues with prerequisites:

1. **Check Documentation**:
   - `HOW-TO-RUN.md` - Setup guide
   - `TROUBLESHOOTING.md` - Common issues
   - `README.md` - Project overview

2. **Run Diagnostics**:
   ```powershell
   .\validate-setup.ps1
   .\system-status-report.ps1
   ```

3. **Check Logs**:
   - Review `*.log` files
   - Check Windows Event Viewer
   - Review PowerShell transcripts

4. **Community Support**:
   - GitHub Issues
   - Project documentation
   - README guides

---

**Last Updated**: 2026-01-02  
**Target System**: Windows 11 (Build 22000+)  
**Maintained by**: A6-9V Organization
