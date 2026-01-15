# My Drive Projects - Repository Forks

This directory contains forked repositories that are integrated into the main project structure.

## Forked Repositories

### 1. ZOLO-A6-9VxNUNA-
- **Original Repository**: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-
- **Description**: Main trading system website and documentation
- **Purpose**: 24/7 VPS trading system website service
- **Integration**: Used by `vps-services/website-service.ps1`

### 2. MQL5-Google-Onedrive
- **Original Repository**: https://github.com/A6-9V/MQL5-Google-Onedrive
- **Description**: MQL5 integration with Google Drive and OneDrive
- **Purpose**: Cloud synchronization for MQL5 trading files
- **Integration**: Used for trading bridge synchronization

## Setup Instructions

### Option 1: Git Submodules (Recommended)

To add these repositories as Git submodules:

```bash
# Add ZOLO-A6-9VxNUNA- as a submodule
git submodule add https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git my-drive-projects/ZOLO-A6-9VxNUNA

# Add MQL5-Google-Onedrive as a submodule
git submodule add https://github.com/A6-9V/MQL5-Google-Onedrive.git my-drive-projects/MQL5-Google-Onedrive

# Initialize and update submodules
git submodule init
git submodule update
```

### Option 2: Manual Fork and Clone

If you want to work with forks independently:

1. **Fork the repositories on GitHub:**
   - Go to https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-
   - Click "Fork" button
   - Repeat for https://github.com/A6-9V/MQL5-Google-Onedrive

2. **Clone your forks:**
```bash
cd my-drive-projects

# Clone ZOLO fork
git clone https://github.com/YOUR-USERNAME/ZOLO-A6-9VxNUNA-.git ZOLO-A6-9VxNUNA

# Clone MQL5 fork
git clone https://github.com/YOUR-USERNAME/MQL5-Google-Onedrive.git MQL5-Google-Onedrive
```

3. **Set up upstream remotes:**
```bash
cd ZOLO-A6-9VxNUNA
git remote add upstream https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git

cd ../MQL5-Google-Onedrive
git remote add upstream https://github.com/A6-9V/MQL5-Google-Onedrive.git
```

### Option 3: GitHub CLI

Using GitHub CLI (`gh`):

```bash
# Fork repositories using gh CLI
gh repo fork Mouy-leng/ZOLO-A6-9VxNUNA- --clone=true --remote=true
gh repo fork A6-9V/MQL5-Google-Onedrive --clone=true --remote=true

# Move to my-drive-projects directory
mv ZOLO-A6-9VxNUNA- my-drive-projects/ZOLO-A6-9VxNUNA
mv MQL5-Google-Onedrive my-drive-projects/MQL5-Google-Onedrive
```

## Updating Forks

### For Submodules:
```bash
# Update all submodules to latest commits
git submodule update --remote --merge

# Or update specific submodule
git submodule update --remote my-drive-projects/ZOLO-A6-9VxNUNA
```

### For Manual Forks:
```bash
# Sync from upstream
cd my-drive-projects/ZOLO-A6-9VxNUNA
git fetch upstream
git merge upstream/main

# Push updates to your fork
git push origin main
```

## Directory Structure

```
my-drive-projects/
├── README.md                           # This file
├── ZOLO-A6-9VxNUNA/                   # Trading system website (forked)
│   ├── index.html
│   ├── assets/
│   └── ...
└── MQL5-Google-Onedrive/              # MQL5 cloud integration (forked)
    ├── Include/
    ├── Scripts/
    └── ...
```

## Integration with Main Project

These forks are integrated with the main project as follows:

1. **ZOLO-A6-9VxNUNA-**:
   - Served by `vps-services/website-service.ps1`
   - Deployed to `C:\Users\USER\OneDrive\ZOLO-A6-9VxNUNA` on VPS
   - Runs as 24/7 website service

2. **MQL5-Google-Onedrive**:
   - Used by trading bridge for cloud synchronization
   - Integrates with MQL5 terminal
   - Syncs trading files across devices

## Authentication

These repositories may be private and require authentication:

- **HTTPS**: Use Personal Access Token (PAT)
- **SSH**: Set up SSH keys
- **GitHub CLI**: Authenticate with `gh auth login`

## Notes

- If repositories are private, ensure you have appropriate access permissions
- Submodules track specific commits, not branches
- Always commit submodule updates separately
- Keep forks synchronized with upstream repositories

## Troubleshooting

### Authentication Failed
If you encounter authentication errors:
```bash
# For HTTPS, use a Personal Access Token
git config --global credential.helper store

# Or use SSH instead
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### Submodule Not Found
```bash
# Initialize missing submodules
git submodule init
git submodule update --init --recursive
```

## Related Documentation

- [VPS Setup Guide](../VPS-SETUP-GUIDE.md)
- [Trading System Setup](../TRADING-SYSTEM-COMPLETE-SUMMARY.md)
- [GitHub Desktop Rules](../GITHUB-DESKTOP-RULES.md)

## Last Updated

2026-01-03
