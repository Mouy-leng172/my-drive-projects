# Code Consolidation Guide

This guide explains the unified code structure for the My Drive Projects repository, consolidating all automation scripts and projects into a single, well-organized location.

## Repository Structure Overview

The repository is now organized into clear functional areas:

```
my-drive-projects/
├── .cursor/                    # Cursor IDE configuration and rules
├── .github/                    # GitHub Actions workflows and configs
├── trading-bridge/            # Trading automation system
│   ├── python/               # Python trading engine
│   ├── mql5/                 # MQL5 Expert Advisors
│   ├── config/               # Broker and symbol configs
│   ├── logs/                 # Service logs
│   └── data/                 # Trading data
├── project-scanner/           # Multi-project discovery and execution
├── system-setup/              # Windows setup and configuration
├── storage-management/        # Drive and storage management
├── vps-services/              # VPS 24/7 services
├── support-portal/            # Support and troubleshooting tools
├── mql5-repo/                # MQL5 source code repository
├── Secrets/                   # Protected credentials (gitignored)
├── *.ps1                      # PowerShell automation scripts
├── *.md                       # Documentation files
├── Dockerfile                 # Docker container configuration
└── docker-compose.yml         # Multi-service orchestration
```

## Key Components

### 1. Trading Bridge (`/trading-bridge`)
**Purpose**: Complete trading automation system with Python-MQL5 bridge

**Contents**:
- Python trading engine
- Broker API implementations (Exness, Bitget)
- MQL5 Expert Advisors
- Notification services (Telegram)
- Background services for 24/7 operation

**Key Files**:
- `python/brokers/bitget_api.py` - Bitget cryptocurrency exchange API
- `python/brokers/exness_api.py` - Exness forex broker API
- `python/notifications/telegram_notifier.py` - Telegram notifications
- `python/services/background_service.py` - Main service daemon

### 2. Project Scanner (`/project-scanner`)
**Purpose**: Discover and manage development projects across all drives

**Features**:
- Scan all connected drives for projects
- Execute scripts in background
- Generate comprehensive reports
- Support for multiple project types

### 3. System Setup (`/system-setup`)
**Purpose**: Windows system configuration and optimization

**Features**:
- Drive cleanup and optimization
- Registry modifications
- Cursor IDE setup
- MCP (Model Context Protocol) configuration

### 4. VPS Services (`/vps-services`)
**Purpose**: 24/7 automated services for VPS deployment

**Services**:
- Exness MT5 Terminal service
- Research automation (Perplexity AI)
- GitHub website hosting
- CI/CD automation
- MQL5 Forge integration

### 5. Storage Management (`/storage-management`)
**Purpose**: Drive and storage management tools

**Features**:
- Drive health monitoring
- Backup automation
- Drive role assignment
- Space optimization

## PowerShell Scripts Organization

All PowerShell scripts are organized by function in the root directory:

### Setup Scripts
- `auto-setup.ps1` - Automated system setup
- `complete-windows-setup.ps1` - Complete Windows configuration
- `setup-workspace.ps1` - Workspace initialization
- `setup-trading-system.ps1` - Trading system setup

### Trading Scripts
- `launch-exness-trading.ps1` - Launch Exness trading
- `start-trading-system-admin.ps1` - Start trading with admin
- `compile-mql5-eas.ps1` - Compile MQL5 EAs
- `compile-mql5-eas-enhanced.ps1` - Enhanced MQL5 compilation

### VPS Scripts
- `auto-start-vps-admin.ps1` - Auto-start VPS services
- `start-vps-system.ps1` - Start VPS system
- `vps-deployment.ps1` - Deploy to VPS
- `vps-verification.ps1` - Verify VPS deployment

### Git/GitHub Scripts
- `git-setup.ps1` - Git configuration
- `github-desktop-setup.ps1` - GitHub Desktop setup
- `review-and-merge-prs.ps1` - PR review automation
- `push-all-drives-to-same-repo.ps1` - Multi-drive sync

### Security Scripts
- `security-check.ps1` - General security check
- `security-check-trading.ps1` - Trading security
- `security-check-vps.ps1` - VPS security
- `setup-github-secrets.ps1` - GitHub secrets setup

### Monitoring Scripts
- `disk-health-monitor.ps1` - Disk health monitoring
- `system-status-report.ps1` - System status
- `check-trading-status.ps1` - Trading status
- `monitor-disk-performance.ps1` - Disk performance

### Utility Scripts
- `backup-to-usb.ps1` - USB backup
- `cleanup-code.ps1` - Code cleanup
- `export-browser-data.ps1` - Browser data export
- `test-bitget-network.ps1` - Bitget network test

## Configuration Files

### Docker Configuration
- `Dockerfile` - Container definition
- `docker-compose.yml` - Multi-service orchestration
- `.env.example` - Environment variable template

### Trading Configuration
- `trading-bridge/config/brokers.json` - Broker settings
- `trading-bridge/config/symbols.json` - Trading symbols
- Configuration managed via Windows Credential Manager

### IDE Configuration
- `.cursor/` - Cursor IDE rules and settings
- `.vscode/` - VS Code settings (if applicable)

## Documentation Files

### Setup Guides
- `README.md` - Main project documentation
- `DOCKER-SETUP-GUIDE.md` - Docker deployment guide
- `BITGET-INTEGRATION-GUIDE.md` - Bitget API integration
- `VPS-SETUP-GUIDE.md` - VPS deployment
- `WORKSPACE-SETUP.md` - Workspace configuration

### Implementation Guides
- `AUTO-MERGE-SETUP-GUIDE.md` - Auto-merge configuration
- `GITHUB-SECRETS-SETUP.md` - GitHub secrets
- `TRADING-SYSTEM-QUICK-START.md` - Trading quick start
- `MANUAL-SETUP-GUIDE.md` - Manual setup instructions

### Reference Documentation
- `AUTOMATION-RULES.md` - Automation patterns
- `GITHUB-DESKTOP-RULES.md` - GitHub Desktop integration
- `SYSTEM-INFO.md` - System specifications
- `PROJECT-BLUEPRINTS.md` - Project architecture

## Gitignore Strategy

The `.gitignore` file ensures sensitive data is never committed:

**Protected Files**:
- `.env`, `.env.local` - Environment variables
- `*.token`, `*.secret` - Authentication tokens
- `*credentials*` - Credential files
- `*.pem` - Certificates and keys
- `config.local*` - Local configurations
- `*.log` - Log files

**Protected Directories**:
- `Secrets/` - Credential storage
- `logs/` - Application logs
- `__pycache__/` - Python cache
- `node_modules/` - Node.js dependencies

## Best Practices

### 1. Code Location
- **PowerShell scripts**: Root directory for easy access
- **Python code**: `trading-bridge/python/` for modularity
- **MQL5 code**: `trading-bridge/mql5/` or `mql5-repo/`
- **Documentation**: Root directory for visibility

### 2. Configuration Management
- Use environment variables for secrets
- Store configs in `config/` directories
- Use `.example` files for templates
- Never commit actual credentials

### 3. Service Organization
- Each major service has its own directory
- Shared utilities in root scripts
- Clear separation of concerns
- Modular architecture

### 4. Documentation
- README in each major directory
- Setup guides for complex features
- Code comments for complex logic
- Architecture diagrams for systems

## Migration from Multiple Repositories

If you have code spread across multiple drives or repositories:

### Step 1: Identify Code Locations
```powershell
# Run project scanner
.\project-scanner\run-all-projects.ps1
```

### Step 2: Consolidate Code
```powershell
# Use the consolidation script
.\push-all-drives-to-same-repo.ps1
```

### Step 3: Verify Organization
```powershell
# Check structure
Get-ChildItem -Recurse -Directory | Select-Object FullName
```

### Step 4: Update Git Remotes
```powershell
# Set primary remote
git remote add origin https://github.com/A6-9V/my-drive-projects.git
git push -u origin main
```

## Recommended Drive Organization

For optimal performance, organize your code across drives:

### C: Drive (System)
- Operating system
- Program Files
- Temp files

### D: Drive (Development)
- **This repository** (`D:\Projects\my-drive-projects\`)
- Active development
- Frequent access

### USB Drives (Backup)
- Repository backups
- Configuration backups
- Data exports

### Cloud Sync (OneDrive/Google Drive)
- Documentation
- Non-code assets
- Shared files

## Maintenance

### Regular Tasks
1. **Weekly**: Review and merge PRs
2. **Weekly**: Update dependencies
3. **Monthly**: Clean up old logs
4. **Monthly**: Update documentation
5. **Quarterly**: Security audit

### Automation
```powershell
# Run all maintenance tasks
.\maintain-and-cleanup.ps1
```

## Future Organization

Planned improvements:
- [ ] Migrate to monorepo structure
- [ ] Add CI/CD pipelines
- [ ] Implement automated testing
- [ ] Create package structure
- [ ] Add versioning system

## Support

For organization questions:
1. Review this guide
2. Check README.md in specific directories
3. Use project scanner for discovery
4. Review architecture in PROJECT-BLUEPRINTS.md

## Summary

This consolidated structure:
✅ Organizes all code in one repository
✅ Clear separation by function
✅ Easy to navigate and maintain
✅ Supports Docker deployment
✅ Documented and version-controlled
✅ Secure credential management
✅ Automated workflows enabled
