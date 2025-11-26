# A6-9V Project Repository

This repository contains projects and resources managed by the A6-9V organization.

## 📁 Project Structure

```
.
├── projects/               # Active development projects
│   ├── Google AI Studio/   # AI Studio related projects
│   └── LiteWriter/         # LiteWriter application
├── project-scanner/        # Project Discovery & Execution System
│   ├── project-scanner.ps1    # Main discovery script
│   ├── project-executor.ps1   # Background execution manager
│   ├── project-logger.ps1      # Logging system
│   ├── run-all-projects.ps1   # Main orchestrator
│   ├── scanner-config.json    # Configuration
│   └── README.md              # Scanner documentation
├── storage-management/    # Storage and drive management tools
├── Document,sheed,PDF, PICTURE/  # Documentation and media
├── Secrets/                # Protected credentials (not tracked in git)
├── TECHNO POVA 6 PRO/     # Device-specific files
└── README.md               # This file
```

## 🔒 Security

Sensitive files including credentials, API keys, certificates, and logs are automatically excluded from version control via `.gitignore`.

**Protected file types:**
- `.pem` files (certificates and keys)
- `.json` credential files
- `.csv` data exports
- Log files
- Screenshots
- Temporary files

## 🚀 Getting Started

### Quick Start with Project Scanner

The repository includes a comprehensive project discovery and execution system:

```powershell
cd D:\my-drive-projects\project-scanner
.\run-all-projects.ps1
```

This will:
1. Scan all local drives for development projects
2. Discover scripts, applications, and code projects
3. Execute them in the background
4. Generate comprehensive reports

See [project-scanner/README.md](project-scanner/README.md) for detailed documentation.

### Git Workflow

This repository uses Git for version control. To contribute:

1. Clone the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📝 Notes

- This workspace is synchronized with Google Drive
- Duplicate files are excluded from version control
- All sensitive data is gitignored for security

## 🏢 Organization

Managed by **A6-9V** organization for better control and collaboration.
