# A6-9V Project Repository - Complete Device Setup

This repository contains the complete device skeleton structure, project blueprints, and setup scripts for the NuNa Windows 11 automation system, including the ZOLO-A6-9VxNUNA trading system.

## 🚀 Getting Started

**New to this project?** Follow these steps:

1. **Check Prerequisites** - Ensure your system meets the requirements
   ```powershell
   .\scripts\powershell\validate-setup.ps1
   ```

2. **Run Quick Start** - Interactive setup wizard (recommended for first-time users)
   ```powershell
   .\scripts\powershell\quick-start.ps1
   ```

3. **Read the Documentation**
   - **[HOW-TO-RUN.md](HOW-TO-RUN.md)** - Complete step-by-step setup guide
   - **[PREREQUISITES.md](PREREQUISITES.md)** - System requirements and dependencies
   - **[README.md](README.md)** - This file, project overview

**Already set up?** Jump to [Quick Start](#quick-start-1) below for common commands.

## 📁 Project Structure

```
.
├── .cursor/                          # Cursor IDE Configuration
│   └── rules/                        # AI Assistant Rules
├── scripts/                          # Automation Scripts
│   ├── powershell/                   # PowerShell Scripts
│   ├── bash/                         # Bash Scripts
│   └── python/                       # Python Scripts
├── docs/                             # Project Documentation
│   ├── documents/                    # General documents
│   ├── google-documents/             # Google Documents files
│   └── media-files/                  # Documentation media
├── services/                         # Background Services
│   └── vps-services/                 # VPS 24/7 Trading System Services
├── projects/                         # Active development projects
│   └── google-ai-studio/             # AI Studio related projects
├── trading-bridge/                   # Trading Bridge & MQL.io System
│   ├── python/                       # Python trading components
│   │   ├── bridge/                   # MQL5 bridge
│   │   ├── brokers/                  # Broker APIs
│   │   ├── mql_io/                   # MQL.io service
│   │   ├── services/                 # Background services
│   │   └── trader/                   # Multi-symbol trader
│   ├── mql5/                         # MQL5 Expert Advisors
│   ├── config/                       # Configuration
│   └── MQL-IO-README.md              # MQL.io documentation
├── assets/                           # Project assets
├── archive/                          # Archived files
│   └── techno-pova-6-pro/            # Archived device files
├── project-scanner/                  # Project Discovery & Execution System
├── system-setup/                     # System Configuration & Optimization
├── storage-management/               # Storage and drive management tools
├── .github/                          # GitHub configuration
├── README.md                         # This file
└── .gitmodules                       # Git submodules
```

## 🚀 Quick Start

> **Note**: For detailed setup instructions, see **[HOW-TO-RUN.md](HOW-TO-RUN.md)**

### First-Time Setup

1. **Validate your system**:
   ```powershell
   .\scripts\powershell\validate-setup.ps1
   ```

2. **Run interactive setup**:
   ```powershell
   # Run as Administrator
   .\scripts\powershell\quick-start.ps1
   ```

### Complete Device Setup

Run the comprehensive device setup script:

```powershell
# Run as Administrator
.\scripts\powershell\complete-device-setup.ps1
```

This will set up:
- ✅ Workspace structure
- ✅ Windows configuration
- ✅ Cloud sync services
- ✅ Git repositories
- ✅ Security settings
- ✅ Cursor rules
- ✅ All automation projects

### VPS 24/7 Trading System

Start the complete 24/7 automated trading system:

```powershell
# Run as Administrator (fully automated, no user interaction)
.\scripts\powershell\auto-start-vps-admin.ps1
```

Or double-click: `AUTO-START-VPS.bat`

This will:
- ✅ Deploy all VPS services
- ✅ Start Exness MT5 Terminal
- ✅ Start Web Research Service (Perplexity AI)
- ✅ Start GitHub Website Service (ZOLO-A6-9VxNUNA)
- ✅ Start CI/CD Automation Service
- ✅ Start MQL5 Forge Integration
- ✅ Handle all errors automatically

### MQL.io Service (NEW)

Start the MQL5 operations management service:

```powershell
.\scripts\powershell\start-mql-io-service.ps1
```

Or double-click: `START-MQL-IO-SERVICE.bat`

MQL.io provides:
- ✅ Expert Advisor monitoring and management
- ✅ Script execution tracking
- ✅ Indicator monitoring
- ✅ Operations logging
- ✅ API interface for programmatic access
- ✅ Auto-recovery (optional)

See `trading-bridge/MQL-IO-README.md` for complete documentation.

### Google Gemini CLI (NEW)

Install AI-powered command-line assistant for code analysis, automation, and development:

```bash
# Linux/macOS
./scripts/bash/install-gemini-cli.sh

# Windows (Run as Administrator)
INSTALL-GEMINI-CLI.bat
```

Or use PowerShell directly:
```powershell
.\scripts\powershell\install-gemini-cli.ps1
```

Gemini CLI provides:
- ✅ AI-powered code review and analysis
- ✅ Automated documentation generation
- ✅ Git workflow integration
- ✅ DevOps automation assistance
- ✅ Multi-modal capabilities (code, images, PDFs)
- ✅ Interactive and scriptable modes

See `GEMINI-CLI-SETUP-GUIDE.md` for complete documentation and `GEMINI-CLI-QUICK-START.md` for quick reference.

### Windows Setup Automation

```powershell
# Run as Administrator
.\scripts\powershell\auto-setup.ps1
# or
.\scripts\powershell\complete-windows-setup.ps1
```

### Workspace Verification

```powershell
.\scripts\powershell\setup-workspace.ps1
```

### Web Development Learning (NEW)

Set up Microsoft's Web-Dev-For-Beginners curriculum:

```powershell
# Run as Administrator
.\scripts\powershell\setup-web-dev-fork.ps1
# or
.\SETUP-WEB-DEV-FORK.bat
```

**Fork Chain**: Microsoft → mouyleng/GenX_FX → A6-9V

This provides:
- ✅ 24 Lessons covering HTML, CSS, JavaScript
- ✅ 12 Weeks of structured learning
- ✅ Hands-on projects and exercises
- ✅ Integration with A6-9V project ecosystem
- ✅ Complete fork documentation and tracking

See **WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md** for detailed instructions.

## 📋 Features

### Windows Setup Scripts
- ✅ Configure Windows Account Sync
- ✅ Set up File Explorer preferences
- ✅ Configure default browser and apps
- ✅ Windows Defender exclusions for cloud folders
- ✅ Windows Firewall rules for cloud services
- ✅ Windows Security (Controlled Folder Access) configuration
- ✅ Cloud sync service verification (OneDrive, Google Drive, Dropbox)

### Git Automation
- ✅ Multi-remote repository support
- ✅ Automated git operations
- ✅ Secure credential management
- ✅ Auto-merge for pull requests
- ✅ GitHub Actions workflows

### Security Validation
- ✅ Comprehensive security checks
- ✅ Token security validation
- ✅ Script integrity verification

### AI Development Tools
- ✅ Google Gemini CLI v0.22.5
- ✅ AI-powered code analysis and review
- ✅ Automated documentation generation
- ✅ Git workflow AI integration
- ✅ Multi-modal AI capabilities (code, images, PDFs)
- ✅ Interactive and scriptable AI assistance

### VPS 24/7 Trading System
- ✅ Exness MT5 Terminal (24/7 operation)
- ✅ Web Research Automation (Perplexity AI)
- ✅ GitHub Website Hosting (ZOLO-A6-9VxNUNA)
- ✅ CI/CD Automation (Python projects)
- ✅ MQL5 Forge Integration
- ✅ Automated error handling
- ✅ Auto-restart capabilities

### Project Scanner
- ✅ Scan all local drives for development projects
- ✅ Discover scripts, applications, and code projects
- ✅ Execute projects in the background
- ✅ Generate comprehensive reports

### System Setup & Optimization
- ✅ Drive cleanup and optimization
- ✅ Drive role assignment and permissions
- ✅ Registry optimizations
- ✅ Cursor IDE configuration
- ✅ MCP (Model Context Protocol) setup

## 🔒 Security

Sensitive files including credentials, API keys, certificates, and logs are automatically excluded from version control via `.gitignore`.

**Protected file types:**
- `.pem` files (certificates and keys)
- `.json` credential files
- `.csv` data exports
- Log files
- Screenshots
- Temporary files
- Personal directories and media files

### GitHub Secrets Setup

For OAuth credentials and other sensitive configuration, use GitHub Secrets:

```powershell
# Automated setup with your credentials
.\scripts\powershell\setup-github-secrets.ps1 `
    -ClientId "YOUR_CLIENT_ID" `
    -ClientSecret "YOUR_CLIENT_SECRET"

# Or use environment variables
$env:OAUTH_CLIENT_ID = "YOUR_CLIENT_ID"
$env:OAUTH_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
.\SETUP-GITHUB-SECRETS.bat
```

See **GITHUB-SECRETS-SETUP.md** for complete instructions on setting up GitHub repository secrets for secure credential management in GitHub Actions workflows.

## 📚 Documentation

### Setup Guides
- **DEVICE-SKELETON.md** - Complete device structure blueprint
- **PROJECT-BLUEPRINTS.md** - Detailed project blueprints
- **SYSTEM-INFO.md** - System specifications
- **WORKSPACE-SETUP.md** - Workspace setup guide
- **VPS-SETUP-GUIDE.md** - VPS 24/7 trading system guide
- **MQL5-FORGE-INTEGRATION.md** - MQL5 Forge repository integration guide
- **AUTO-MERGE-SETUP-GUIDE.md** - Automatic PR merging setup
- **AUTOMATION-RULES.md** - Automation patterns
- **GITHUB-DESKTOP-RULES.md** - GitHub Desktop integration
- **GITHUB-SECRETS-SETUP.md** - GitHub secrets and OAuth setup
- **WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md** - Web development learning fork setup
- **MANUAL-SETUP-GUIDE.md** - Manual setup instructions

### AI Tools Documentation
- **GEMINI-CLI-SETUP-GUIDE.md** - Complete Gemini CLI installation and configuration guide
- **GEMINI-CLI-QUICK-START.md** - Quick reference for Gemini CLI commands and workflows

## 🏢 Organization

Managed by **A6-9V** organization for better control and collaboration.

## 📝 Accounts

- **Primary Email**: keamouyleng@proton.me
- **GitHub**: Mouy-leng / A6-9V

## 🔧 System Information

- **Device**: NuNa
- **OS**: Windows 11 Home Single Language 25H2 (Build 26220.7344)
- **Processor**: Intel(R) Core(TM) i3-N305 (1.80 GHz)
- **RAM**: 8.00 GB (7.63 GB usable)
- **Architecture**: 64-bit x64-based processor

## 📦 Git Repositories

This workspace is connected to multiple repositories:

- **Primary (origin)**: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
- **Secondary 1 (bridges3rd)**: https://github.com/A6-9V/I-bride_bridges3rd.git
- **Secondary 2 (drive-projects)**: https://github.com/A6-9V/my-drive-projects.git
- **MQL5 Forge (mql5-forge)**: https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git

### MQL5 Forge Integration

The MQL5 Forge repository is automatically configured as an additional remote for MQL5 trading code management:

```powershell
# Setup MQL5 Forge remote for current repository
.\scripts\powershell\setup-mql5-forge-remote.ps1

# Setup MQL5 Forge remote for all repositories on all drives
.\scripts\powershell\setup-mql5-forge-remote.ps1 -AllDrives

# Setup MQL5 Forge remote for specific repository
.\scripts\powershell\setup-mql5-forge-remote.ps1 -RepoPath "C:\Users\USER\OneDrive"
```

The MQL5 Forge remote allows:
- ✅ Version control for MQL5 Expert Advisors, Scripts, and Indicators
- ✅ Synchronization with MQL5 Forge community platform
- ✅ Backup and recovery of trading code
- ✅ Collaboration with other MQL5 developers

## 🗄️ Graph Database Architecture & Connection Diagram

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         COMPLETE SYSTEM ARCHITECTURE                     │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────────┐         ┌──────────────────────┐
│   LAPTOP (NuNa)      │         │   VPS (Remote)      │
│   Windows 11         │◄───────►│   24/7 Trading      │
│                      │  Git    │                     │
│  ┌────────────────┐  │  Sync   │  ┌────────────────┐ │
│  │ Python Engine  │  │         │  │ MT5 Terminal   │ │
│  │ - Strategies   │  │         │  │ - Execution    │ │
│  │ - Analysis     │  │         │  │ - Uptime       │ │
│  └────────────────┘  │         │  └────────────────┘ │
│         │            │         │         │            │
│  ┌──────▼──────────┐ │         │  ┌──────▼──────────┐ │
│  │ Trading Bridge  │ │         │  │ MQL5 EA        │ │
│  │ Python ↔ MQL5   │ │         │  │ PythonBridgeEA │ │
│  │ Port 5500       │ │         │  │ ZeroMQ Client  │ │
│  └─────────────────┘ │         │  └────────────────┘ │
└──────────────────────┘         └──────────────────────┘
         │                                   │
         └───────────────┬───────────────────┘
                         │
              ┌──────────▼──────────┐
              │   Graph Database     │
              │   (Relationship Map) │
              └──────────────────────┘
```

### Graph Database Structure

The system uses a graph-based relationship model to track connections between components:

```
                    ┌─────────────────┐
                    │  Main Controller │
                    │  (Orchestrator)  │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ VPS Services  │   │ Trading Bridge│   │ Cloud Sync    │
│               │   │               │   │               │
│ • Exness      │──►│ • Python      │──►│ • OneDrive   │
│ • Research    │   │ • MQL5        │   │ • Google     │
│ • Website     │   │ • ZeroMQ      │   │ • GitHub     │
│ • CI/CD       │   │ • Port 5500   │   │ • Dropbox    │
│ • MQL5 Forge  │   └───────────────┘   └───────────────┘
└───────────────┘
        │
        ▼
┌───────────────┐
│ Broker APIs   │
│               │
│ • Exness API  │
│ • Multi-Symbol│
│ • Risk Mgmt   │
└───────────────┘
```

### Connection Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONNECTION FLOW                              │
└─────────────────────────────────────────────────────────────────┘

[Python Strategy] 
      │
      │ Generate Signal
      ▼
[Signal Manager] ──► Queue & Validate
      │
      │ ZeroMQ (Port 5500)
      ▼
[MQL5 Bridge] ──► Receive & Process
      │
      │ Execute Trade
      ▼
[MT5 Terminal] ──► Order Execution
      │
      │ API Call
      ▼
[Broker API] ──► Exness/Other
      │
      │ Update Status
      ▼
[Graph DB] ──► Store Relationship
      │
      │ Log & Monitor
      ▼
[Background Service] ──► 24/7 Monitoring
```

### Component Relationships (Graph DB Model)

```
Nodes:
├── System
│   ├── Laptop (NuNa)
│   ├── VPS (Remote)
│   └── Cloud Services
│
├── Services
│   ├── Exness Service
│   ├── Research Service
│   ├── Website Service
│   ├── CI/CD Service
│   └── MQL5 Service
│
├── Trading Components
│   ├── Python Engine
│   ├── MQL5 Bridge
│   ├── Signal Manager
│   ├── Multi-Symbol Trader
│   └── Broker APIs
│
└── Data Stores
    ├── Configuration (JSON)
    ├── Logs (Files)
    ├── Trading Data (CSV/DB)
    └── Credentials (Windows Credential Manager)

Relationships:
├── Laptop ─[syncs]──► VPS
├── Python Engine ─[communicates]──► MQL5 Bridge
├── MQL5 Bridge ─[connects]──► MT5 Terminal
├── MT5 Terminal ─[executes]──► Broker API
├── Services ─[monitors]──► Trading Components
└── Graph DB ─[tracks]──► All Relationships
```

### Network Ports & Connections

| Component | Port | Protocol | Direction |
|-----------|------|----------|-----------|
| Trading Bridge | 5500 | TCP (ZeroMQ) | Bidirectional |
| Remote Desktop | 3389 | TCP (RDP) | Inbound |
| GitHub Sync | 443 | HTTPS | Outbound |
| Broker APIs | 443 | HTTPS | Outbound |
| OneDrive Sync | 443 | HTTPS | Outbound |

### Data Flow Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Strategy  │────►│   Signal    │────►│   Bridge   │
│  Analysis   │     │   Manager   │     │   Python   │
└─────────────┘     └─────────────┘     └─────────────┘
                                              │
                                              │ ZeroMQ
                                              ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Broker    │◄────│   MT5       │◄────│   Bridge   │
│   API       │     │   Terminal  │     │   MQL5     │
└─────────────┘     └─────────────┘     └─────────────┘
      │
      │ Store Results
      ▼
┌─────────────┐
│  Graph DB   │
│  (Relations)│
└─────────────┘
```

## 🔐 Making Repositories Private

See **SET-REPOS-PRIVATE.md** for instructions on making repositories private.

**Note**: This repository should be set to private for security. Use GitHub Settings → General → Danger Zone → Change visibility.

## 📝 Notes

- This workspace is synchronized with OneDrive and Google Drive
- Duplicate files are excluded from version control
- All sensitive data is gitignored for security
- Complete device skeleton structure and blueprints included
- VPS 24/7 trading system fully automated

## License

This project is for personal use.

## Author

A6-9V (keamouyleng@proton.me)

## Last Updated

**Last Repository Update**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
