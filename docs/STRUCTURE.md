# Repository Structure

This document explains the organization of the `my-drive-projects` monorepo.

## Overview

This repository is organized as a **monorepo/workspace** containing multiple independent projects, scripts, and services. It is NOT a single deployable application.

## Directory Structure

```
my-drive-projects/
├── .cursor/                  # Cursor IDE configuration
│   └── rules/               # AI assistant rules and guidelines
│
├── .github/                 # GitHub configuration
│   └── workflows/           # CI/CD workflows (validation, auto-merge)
│
├── scripts/                 # Automation and utility scripts
│   ├── powershell/         # Windows PowerShell scripts (.ps1)
│   ├── bash/               # Linux/Unix shell scripts (.sh)
│   └── batch/              # Windows batch files (.bat)
│
├── docs/                    # All documentation
│   ├── guides/             # User guides and tutorials
│   ├── setup/              # Installation and setup documentation
│   ├── reports/            # Status reports and summaries
│   └── *.md                # General documentation files
│
├── projects/               # Independent development projects
│   ├── google-ai-studio/  # AI Studio related projects
│   └── README.md           # Projects overview
│
├── services/               # Background services
│   └── vps-services/       # VPS 24/7 trading system services
│
├── trading-bridge/         # MQL5 trading bridge system
│   ├── python/            # Python trading components
│   ├── mql5/              # MQL5 Expert Advisors
│   ├── config/            # Configuration files
│   └── data/              # Trading data
│
├── project-scanner/        # Project discovery and execution tool
├── system-setup/           # System configuration scripts
├── storage-management/     # Drive management utilities
├── core/                   # Core libraries and utilities
├── support-portal/         # Support and help resources
│
└── archive/                # Historical or unused files
    ├── techno-pova-6-pro/ # Old device-specific files
    ├── document-assets/    # Archived documents
    └── text-files/         # Archived text files
```

## Key Directories

### `/scripts`

Contains all automation and utility scripts organized by type:

- **powershell/** - Windows-specific automation scripts
- **bash/** - Cross-platform shell scripts
- **batch/** - Windows batch files for easy execution

Common scripts:
- `validate-setup.ps1` - Validate system requirements
- `quick-start.ps1` - Interactive setup wizard
- `auto-start-vps-admin.ps1` - Start VPS services

### `/docs`

All documentation is centralized here to avoid clutter in the root directory.

Subdirectories:
- **guides/** - How-to guides, tutorials, and user documentation
- **setup/** - Installation and configuration instructions
- **reports/** - Status reports, completion summaries

Key documents:
- `DEVICE-SKELETON.md` - Complete device structure
- `PROJECT-BLUEPRINTS.md` - Project architecture
- `SYSTEM-INFO.md` - System specifications

### `/projects`

Independent development projects that can run standalone:

- **google-ai-studio/** - AI Studio experiments and tools
- Each project has its own README and dependencies

### `/services`

Long-running background services:

- **vps-services/** - 24/7 trading system services
  - `exness-service.ps1` - MT5 Terminal management
  - `research-service.ps1` - AI research automation
  - `website-service.ps1` - GitHub Pages hosting
  - `cicd-service.ps1` - CI/CD automation
  - `master-controller.ps1` - Service orchestration

### `/trading-bridge`

Complete trading automation system:

- **python/** - Trading strategies and analysis
- **mql5/** - MetaTrader 5 Expert Advisors
- **config/** - Configuration templates
- **data/** - Trading data and logs

### `/archive`

Historical files kept for reference but not actively used:

- Old device files
- Deprecated documents
- Legacy configurations

## Navigation Tips

### Finding Documentation

1. Check the **root README.md** for overview
2. Look in **docs/** for detailed guides
3. Search **docs/guides/** for specific topics
4. Check **docs/setup/** for installation help

### Finding Scripts

All scripts are in **scripts/** organized by language:

```powershell
# PowerShell
.\scripts\powershell\script-name.ps1

# Bash
./scripts/bash/script-name.sh

# Batch
scripts\batch\script-name.bat
```

### Finding Projects

Individual projects are in **projects/**. Each has its own:
- README.md
- Dependencies
- Build instructions

## Design Principles

1. **Separation of Concerns**: Scripts, docs, and projects are separated
2. **Lowercase Naming**: All directories use lowercase-with-hyphens
3. **Clear Organization**: Easy to find what you need
4. **Git-Friendly**: Structure works well with version control
5. **CI-Safe**: No personal data, clear testing paths

## Excluded from Git

The following are automatically excluded via `.gitignore`:

- Sensitive credentials (`.token`, `.secret`, `*credentials*`)
- Personal files (images, PDFs, documents)
- Build artifacts and dependencies
- Log files and temporary data
- Configuration with sensitive data

See `.gitignore` for complete list.

## Contributing

When adding new content:

1. **Scripts** → Place in appropriate `scripts/` subdirectory
2. **Documentation** → Add to `docs/` with clear categorization
3. **Projects** → Create new folder in `projects/`
4. **Services** → Add to `services/` if it's a background service

Keep the structure clean and organized!

## Migration Notes

This structure was reorganized on 2026-01-04 from a flat structure to improve:

- **Clarity**: Clear separation of concerns
- **Maintainability**: Easier to navigate and update
- **CI/CD**: Better workflow organization
- **Professionalism**: Standard monorepo structure

Old paths:
- Root contained 128+ `.ps1` files → Now in `scripts/powershell/`
- Root contained 88+ `.md` files → Now in `docs/`
- `vps-services/` → Now in `services/vps-services/`
- `Google AI Studio/` → Now `google-ai-studio/`
