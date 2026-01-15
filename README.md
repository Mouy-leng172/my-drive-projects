# my-drive-projects

A personal monorepo containing automation scripts, learning projects, VPS services, and system configuration for the NuNa Windows 11 device.

## 🎯 Latest Updates

### New Features (December 2025)
- 🐳 **Docker Support** - Full containerization with multi-service orchestration
- 📱 **Telegram Notifications** - Real-time trading alerts and system notifications
- 💱 **Bitget Integration** - Cryptocurrency trading via Bitget API
- 🔧 **Enhanced MQL5 Compilation** - Direct MQL5.io integration and automation
- 📚 **Code Consolidation** - Unified repository structure for all projects

### Quick Start Guides
- **Docker Deployment**: [DOCKER-SETUP-GUIDE.md](DOCKER-SETUP-GUIDE.md)
- **Bitget Trading**: [BITGET-INTEGRATION-GUIDE.md](BITGET-INTEGRATION-GUIDE.md)
- **Code Organization**: [CODE-CONSOLIDATION-GUIDE.md](CODE-CONSOLIDATION-GUIDE.md)

## 📁 Project Structure

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
│   ├── mql5-service.ps1             # MQL5 Forge integration
│   └── master-controller.ps1        # Master service controller
├── trading-bridge/                   # Trading Bridge & MQL.io System
│   ├── python/                      # Python trading components
│   │   ├── bridge/                  # MQL5 bridge
│   │   ├── brokers/                 # Broker APIs
│   │   ├── mql_io/                  # MQL.io service (NEW)
│   │   ├── services/                # Background services
│   │   └── trader/                  # Multi-symbol trader
│   ├── mql5/                        # MQL5 Expert Advisors
│   ├── config/                      # Configuration
│   └── MQL-IO-README.md             # MQL.io documentation
├── backend/                          # Backend Services & APIs (NEW)
│   ├── services/                    # Service integrations
│   │   └── openbb_service.py        # OpenBB analytics integration
│   ├── api/                         # REST API endpoints
│   └── workers/                     # Background workers
├── configs/                          # Configuration files (NEW)
│   └── openbb.yaml                  # OpenBB Platform configuration
├── docker/                           # Docker infrastructure (NEW)
│   ├── docker-compose.yml           # Service orchestration
│   └── openbb.Dockerfile            # OpenBB service container
├── scripts/                          # Automation scripts (NEW)
│   └── sync_market_data.py          # Market data synchronization
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

### Docker Container Deployment (New!)

Run the entire system in Docker containers:

```bash
# Copy environment configuration
cp .env.example .env

# Edit .env with your credentials (Telegram, Bitget, etc.)

# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f trading-bridge
```

Services included:
- ✅ Trading Bridge (Python-MQL5 automation)
- ✅ Telegram Notifications
- ✅ Multi-Broker Support (Exness, Bitget)
- ✅ Project Scanner
- ✅ 24/7 Background Services

See [DOCKER-SETUP-GUIDE.md](DOCKER-SETUP-GUIDE.md) for complete documentation.

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

### CI/CD Automation
- ✅ Automated PowerShell script validation
- ✅ Documentation linting and link checking
- ✅ Continuous integration on push and pull requests
- ✅ Automated quality checks and reporting
- ✅ GitHub Actions workflow orchestration

### Security Validation
- ✅ Comprehensive security checks
- ✅ Token security validation
- ✅ Script integrity verification

### OpenBB Analytics Engine Integration (NEW)
- ✅ Financial data retrieval
- ✅ Market analytics
- ✅ Research tools integration
- ✅ Service-based architecture (Option A)
- ✅ Submodule support (Option B)
- ✅ Docker containerization
- ✅ Automated market data synchronization

### VPS 24/7 Trading System
- ✅ Exness MT5 Terminal (24/7 operation)
- ✅ **Bitget Cryptocurrency Exchange** (Spot & Futures)
- ✅ Web Research Automation (Perplexity AI)
- ✅ GitHub Website Hosting (ZOLO-A6-9VxNUNA)
- ✅ CI/CD Automation (Python projects)
- ✅ MQL5 Forge Integration
- ✅ **Telegram Notifications** (Real-time alerts)
- ✅ Automated error handling
- ✅ Auto-restart capabilities
- ✅ **Docker Container Support**

### Multi-Broker Trading Support
- ✅ **Exness** - Forex and CFD trading
- ✅ **Bitget** - Cryptocurrency spot and futures
- ✅ Multi-symbol simultaneous trading
- ✅ Network latency optimization
- ✅ Automatic broker failover
- ✅ Unified API interface
- ✅ Real-time position monitoring
- ✅ Risk management integration

### Notification System
- ✅ **Telegram Integration** - Real-time alerts
- ✅ Trade execution notifications
- ✅ System status updates
- ✅ Error and warning alerts
- ✅ Performance reports
- ✅ Configurable alert levels
- ✅ Multi-channel support ready

### AI Agents & Automation (NEW)
- ✅ Jules Agent (Google AI) - Trading automation, code review, auto-merge
- ✅ Qodo Plugin - Code quality and test generation
- ✅ Cursor Agent - AI-assisted code editing
- ✅ Kombai Agent - Design to code conversion
- ✅ Auto-dependency installation on git pull
- ✅ Node.js and npm automated setup
- ✅ PDF collection and cataloging
- ✅ Git hooks for automatic workflow

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
- `.env` files (Docker environment variables)
- Log files
- Screenshots
- Temporary files
- Personal directories and media files

### Environment Variables (Docker)

For Docker deployments, use environment variables in `.env` file:

```bash
# Copy example file
cp .env.example .env

# Edit with your credentials
nano .env
```

Never commit the `.env` file - it's automatically excluded by `.gitignore`.

### GitHub Secrets Setup

For OAuth credentials and other sensitive configuration, use GitHub Secrets:

```powershell
# Automated setup with your credentials
.\setup-github-secrets.ps1 `
    -ClientId "YOUR_CLIENT_ID" `
    -ClientSecret "YOUR_CLIENT_SECRET"

# Or use environment variables
$env:OAUTH_CLIENT_ID = "YOUR_CLIENT_ID"
$env:OAUTH_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
.\SETUP-GITHUB-SECRETS.bat
```

See **GITHUB-SECRETS-SETUP.md** for complete instructions on setting up GitHub repository secrets for secure credential management in GitHub Actions workflows.

## 📚 Documentation

### New Feature Guides (2025)
- **DOCKER-SETUP-GUIDE.md** - Docker container deployment
- **BITGET-INTEGRATION-GUIDE.md** - Bitget cryptocurrency exchange
- **CODE-CONSOLIDATION-GUIDE.md** - Unified code organization

### Setup Guides
- **DEVICE-SKELETON.md** - Complete device structure blueprint
- **PROJECT-BLUEPRINTS.md** - Detailed project blueprints
- **SYSTEM-INFO.md** - System specifications
- **WORKSPACE-SETUP.md** - Workspace setup guide
- **MANUAL-SETUP-GUIDE.md** - Manual setup instructions

### AI Agents (NEW)
- **.cursor/rules/ai-agents/JULES-AGENT.md** - Jules agent documentation
- **.cursor/rules/ai-agents/QODO-PLUGIN.md** - Qodo plugin guide
- **.cursor/rules/ai-agents/CURSOR-AGENT.md** - Cursor agent reference
- **.cursor/rules/ai-agents/KOMBAI-AGENT.md** - Kombai agent manual

### System Automation
- **VPS-SETUP-GUIDE.md** - VPS 24/7 trading system guide
- **AUTO-MERGE-SETUP-GUIDE.md** - Automatic PR merging setup
- **MANUAL-SETUP-GUIDE.md** - Manual setup instructions

### Configuration Guides
- **AUTOMATION-RULES.md** - Automation patterns
- **GITHUB-DESKTOP-RULES.md** - GitHub Desktop integration
- **GITHUB-SECRETS-SETUP.md** - GitHub secrets and OAuth setup

### Trading System Documentation
- **trading-bridge/README.md** - Trading bridge system overview
- **trading-bridge/CONFIGURATION.md** - Broker and symbol configuration
- **trading-bridge/SECURITY.md** - Security best practices

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

- **Primary (origin)**: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
- **Secondary 1 (bridges3rd)**: https://github.com/A6-9V/I-bride_bridges3rd.git
- **Secondary 2 (drive-projects)**: https://github.com/A6-9V/my-drive-projects.git

### Forked Repositories

The `my-drive-projects/` directory contains forked repositories that are integrated into this project:

1. **ZOLO-A6-9VxNUNA-** (https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git)
   - Trading system website and documentation
   - Used by VPS website service

2. **MQL5-Google-Onedrive** (https://github.com/A6-9V/MQL5-Google-Onedrive.git)
   - MQL5 integration with cloud storage
   - Used by trading bridge for synchronization

See [my-drive-projects/README.md](my-drive-projects/README.md) and [my-drive-projects/FORK-INTEGRATION-GUIDE.md](my-drive-projects/FORK-INTEGRATION-GUIDE.md) for setup instructions.

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
