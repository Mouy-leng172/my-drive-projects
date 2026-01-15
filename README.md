# my-drive-projects

A personal monorepo containing automation scripts, learning projects, VPS services, and system configuration for the NuNa Windows 11 device.

> **Important**: This repo is NOT a single application. It's a workspace/monorepo that organizes multiple independent projects and scripts.

## Structure

```
.
├── .cursor/                          # Cursor IDE Configuration
│   └── rules/                        # AI Assistant Rules
├── Scripts/                          # PowerShell Automation Scripts
│   ├── Setup Scripts/
│   ├── Git Scripts/
│   ├── Security Scripts/
│   ├── GitHub Desktop Scripts/
│   └── Utility Scripts/
├── Documentation/                    # Project Documentation
│   ├── DEVICE-SKELETON.md           # Complete device structure
│   ├── PROJECT-BLUEPRINTS.md         # Project blueprints
│   ├── SYSTEM-INFO.md               # System specifications
│   ├── WORKSPACE-SETUP.md           # Workspace setup guide
│   └── SET-REPOS-PRIVATE.md         # Instructions for private repos
├── vps-services/                     # VPS 24/7 Trading System Services
│   ├── exness-service.ps1           # Exness MT5 Terminal service
│   ├── research-service.ps1         # Perplexity AI research service
│   ├── website-service.ps1          # GitHub website service
│   ├── cicd-service.ps1             # CI/CD automation service
│   ├── mql5-service.ps1              # MQL5 Forge integration
│   └── master-controller.ps1       # Master service controller
├── projects/                         # Active development projects
│   ├── Google AI Studio/            # AI Studio related projects
│   └── LiteWriter/                  # LiteWriter application
├── project-scanner/                  # Project Discovery & Execution System
├── system-setup/                     # System Configuration & Optimization
├── storage-management/               # Storage and drive management tools
├── Document,sheed,PDF, PICTURE/     # Documentation and media
├── Secrets/                          # Protected credentials (not tracked in git)
└── TECHNO POVA 6 PRO/                # Device-specific files
```

## How to Use

This repository contains multiple tools and projects. Pick what you need:

### 🚀 Quick Start Scripts

Run automation scripts from the `scripts/` directory:

```powershell
# Validate system setup
.\scripts\powershell\validate-setup.ps1

# Quick start wizard
.\scripts\powershell\quick-start.ps1

# Complete device setup
.\scripts\powershell\complete-device-setup.ps1
```

### 📦 Projects

Each project in `projects/` can be used independently:

- **google-ai-studio/** - AI Studio related projects
- See individual project READMEs for details

### 🔧 VPS Services

24/7 trading system services in `services/vps-services/`:

```powershell
# Start all VPS services
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

### Windows Setup Automation

```powershell
# Run as Administrator
.\auto-setup.ps1
# or
.\complete-windows-setup.ps1
```

### Workspace Verification

```powershell
.\setup-workspace.ps1
```

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

### Security Validation
- ✅ Comprehensive security checks
- ✅ Token security validation
- ✅ Script integrity verification

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

## 📚 Documentation

- **DEVICE-SKELETON.md** - Complete device structure blueprint
- **PROJECT-BLUEPRINTS.md** - Detailed project blueprints
- **SYSTEM-INFO.md** - System specifications
- **WORKSPACE-SETUP.md** - Workspace setup guide
- **VPS-SETUP-GUIDE.md** - VPS 24/7 trading system guide
- **AUTOMATION-RULES.md** - Automation patterns
- **GITHUB-DESKTOP-RULES.md** - GitHub Desktop integration
- **MANUAL-SETUP-GUIDE.md** - Manual setup instructions

- **[docs/DEVICE-SKELETON.md](docs/DEVICE-SKELETON.md)** - Complete device structure
- **[docs/PROJECT-BLUEPRINTS.md](docs/PROJECT-BLUEPRINTS.md)** - Project blueprints
- **[docs/SYSTEM-INFO.md](docs/SYSTEM-INFO.md)** - System specifications
- **[docs/guides/](docs/guides/)** - Setup guides and tutorials
- **[docs/setup/](docs/setup/)** - Installation and configuration docs

## 🎯 Key Features

### Windows Automation
- System configuration and optimization
- Cloud sync services (OneDrive, Google Drive, Dropbox)
- Git automation and multi-remote management
- Security validation and token management

### Trading System
- 24/7 VPS services for automated trading
- MQL5 bridge for MT5 Terminal
- Multi-symbol trading strategies
- Exness broker integration

### Development Tools
- Google Gemini CLI for AI-powered code analysis
- Project scanner for discovering and executing projects
- Cursor IDE configuration with custom rules

## 🔒 Security

- Sensitive files are excluded via `.gitignore`
- Credentials stored in Windows Credential Manager
- GitHub secrets for CI/CD workflows
- See [SECURITY.md](SECURITY.md) for details

## 💻 System Information

- **Device**: NuNa
- **OS**: Windows 11 Home Single Language 25H2
- **Processor**: Intel Core i3-N305 (1.80 GHz)
- **RAM**: 8.00 GB

## 📝 Maintenance

This is a workspace repository. Individual projects may have their own:
- Build processes
- Dependencies
- Documentation

Refer to project-specific READMEs for details.

## 🔐 Making Repositories Private

See **SET-REPOS-PRIVATE.md** for instructions on making repositories private.

## 📝 Notes

- This workspace is synchronized with OneDrive and Google Drive
- Duplicate files are excluded from version control
- All sensitive data is gitignored for security
- Complete device skeleton structure and blueprints included
- VPS 24/7 trading system fully automated

## License

This project is for personal use.

## Author

Lengkundee01 / A6-9V
