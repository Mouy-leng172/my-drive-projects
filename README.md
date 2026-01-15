# my-drive-projects

A personal monorepo containing automation scripts, learning projects, VPS services, and system configuration for the NuNa Windows 11 device.

> **Important**: This repo is NOT a single application. It's a workspace/monorepo that organizes multiple independent projects and scripts.

## Structure

```
my-drive-projects/
├── scripts/              → Automation and utility scripts
│   ├── powershell/      → Windows PowerShell scripts
│   ├── bash/            → Linux/Unix shell scripts
│   └── batch/           → Windows batch files
├── projects/            → Independent development projects
│   ├── google-ai-studio/
│   └── (other projects)
├── services/            → VPS background services
│   └── vps-services/    → 24/7 trading system services
├── docs/                → All documentation
├── trading-bridge/      → MQL5 trading bridge system
├── project-scanner/     → Project discovery tool
├── system-setup/        → System configuration
├── storage-management/  → Drive management utilities
└── archive/             → Historical/unused files
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

## 📚 Documentation

All documentation is organized in the `docs/` directory:

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

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

Personal use project.

## 👤 Author

A6-9V (keamouyleng@proton.me)

---

**Note**: This repository is organized as a monorepo for easier maintenance and collaboration. Each component is independent and can be used separately.
└─────────────┘
```

---

**Note**: This repository is organized as a monorepo for easier maintenance and collaboration. Each component is independent and can be used separately.
