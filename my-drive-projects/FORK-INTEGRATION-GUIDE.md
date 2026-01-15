# Fork Integration Guide

## Overview

This document provides a comprehensive guide for integrating the following repositories into the `my-drive-projects` directory:

1. **ZOLO-A6-9VxNUNA-** - Trading system website and documentation
2. **MQL5-Google-Onedrive** - MQL5 integration with cloud storage

## Why Fork These Repositories?

Forking these repositories allows:
- **Version Control**: Track specific versions used in your setup
- **Customization**: Make project-specific modifications without affecting the originals
- **Synchronization**: Keep your local environment in sync with upstream changes
- **Backup**: Maintain copies under your GitHub account
- **Integration**: Seamlessly integrate with the main project workflow

## Integration Methods

### Method 1: Git Submodules (Recommended for Developers)

**Pros:**
- ✅ Tracks specific commits
- ✅ Easy to update
- ✅ Minimal repository size
- ✅ Clear versioning

**Cons:**
- ❌ Requires git knowledge
- ❌ Extra commands to update

**Setup:**
```bash
# Navigate to repository root
cd /path/to/my-drive-projects

# Add submodules
git submodule add https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git my-drive-projects/ZOLO-A6-9VxNUNA
git submodule add https://github.com/A6-9V/MQL5-Google-Onedrive.git my-drive-projects/MQL5-Google-Onedrive

# Initialize and update
git submodule init
git submodule update --recursive

# Commit the changes
git add .gitmodules my-drive-projects/
git commit -m "Add forked repositories as submodules"
git push
```

**Updating:**
```bash
# Update all submodules to latest
git submodule update --remote --merge

# Update specific submodule
cd my-drive-projects/ZOLO-A6-9VxNUNA
git pull origin main
cd ../..
git add my-drive-projects/ZOLO-A6-9VxNUNA
git commit -m "Update ZOLO submodule"
```

### Method 2: Direct Clone (Simple but Manual)

**Pros:**
- ✅ Simple to understand
- ✅ Works like normal git repos
- ✅ Easy to modify locally

**Cons:**
- ❌ Not tracked by main repository
- ❌ Manual synchronization
- ❌ May cause merge conflicts

**Setup:**
```bash
cd my-drive-projects

# Clone repositories
git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git ZOLO-A6-9VxNUNA
git clone https://github.com/A6-9V/MQL5-Google-Onedrive.git MQL5-Google-Onedrive

# Set up upstream remotes
cd ZOLO-A6-9VxNUNA
git remote add upstream https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
cd ..

cd MQL5-Google-Onedrive
git remote add upstream https://github.com/A6-9V/MQL5-Google-Onedrive.git
cd ..
```

**Note:** Add these directories to `.gitignore` if using this method:
```gitignore
my-drive-projects/ZOLO-A6-9VxNUNA/
my-drive-projects/MQL5-Google-Onedrive/
```

### Method 3: GitHub CLI (Automated Forking)

**Pros:**
- ✅ Automatic forking
- ✅ Configures remotes automatically
- ✅ Easy to use

**Cons:**
- ❌ Requires GitHub CLI
- ❌ Requires authentication

**Setup:**
```bash
# Authenticate first
gh auth login

# Fork and clone
cd my-drive-projects
gh repo fork Mouy-leng/ZOLO-A6-9VxNUNA- --clone=true --remote=true
gh repo fork A6-9V/MQL5-Google-Onedrive --clone=true --remote=true

# Rename if needed
mv ZOLO-A6-9VxNUNA- ZOLO-A6-9VxNUNA
```

### Method 4: Automated Script (Easiest)

**Use the provided setup script:**

**Windows:**
```cmd
cd my-drive-projects
SETUP-FORKS.bat
```

**PowerShell:**
```powershell
cd my-drive-projects
.\setup-forks.ps1
```

**Linux/Mac:**
```bash
cd my-drive-projects
pwsh setup-forks.ps1
```

## Authentication

### Private Repositories

If the repositories are private, you need authentication:

#### Option 1: Personal Access Token (PAT)

1. Generate a PAT at: https://github.com/settings/tokens
2. Permissions needed: `repo` (full control)
3. Use PAT as password when cloning via HTTPS

#### Option 2: SSH Keys

1. Generate SSH key: `ssh-keygen -t ed25519 -C "your_email@example.com"`
2. Add to GitHub: https://github.com/settings/keys
3. Clone using SSH URLs:
   ```bash
   git clone git@github.com:Mouy-leng/ZOLO-A6-9VxNUNA-.git
   git clone git@github.com:A6-9V/MQL5-Google-Onedrive.git
   ```

#### Option 3: GitHub CLI

```bash
gh auth login
# Follow the prompts to authenticate
```

## Directory Structure

After setup, the structure should be:

```
my-drive-projects/
├── README.md                              # Documentation
├── FORK-INTEGRATION-GUIDE.md             # This file
├── setup-forks.ps1                       # Setup script
├── SETUP-FORKS.bat                       # Windows launcher
├── .gitmodules.template                  # Submodule template
│
├── ZOLO-A6-9VxNUNA/                      # Trading website (forked)
│   ├── .git/
│   ├── index.html
│   ├── assets/
│   ├── js/
│   └── css/
│
└── MQL5-Google-Onedrive/                 # Cloud integration (forked)
    ├── .git/
    ├── Include/
    ├── Scripts/
    └── Experts/
```

## Integration with Main Project

### ZOLO-A6-9VxNUNA Integration

This repository is used by:
- `vps-services/website-service.ps1` - Runs the website as a 24/7 service
- VPS deployment scripts - Deploys to production environment

**Expected location on VPS:**
```
C:\Users\USER\OneDrive\ZOLO-A6-9VxNUNA\
```

### MQL5-Google-Onedrive Integration

This repository provides:
- MQL5 Expert Advisors with cloud sync capabilities
- Scripts for synchronizing trading data
- Integration with Google Drive and OneDrive APIs

**Expected location:**
```
C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\<Terminal-ID>\MQL5\
```

## Maintenance

### Keeping Forks Updated

**For Submodules:**
```bash
# Update to latest commits from upstream
git submodule update --remote --merge

# Commit the updates
git add my-drive-projects/
git commit -m "Update forked repositories"
git push
```

**For Direct Clones:**
```bash
cd my-drive-projects/ZOLO-A6-9VxNUNA
git fetch upstream
git merge upstream/main
git push origin main

cd ../MQL5-Google-Onedrive
git fetch upstream
git merge upstream/main
git push origin main
```

### Syncing Your Changes to Upstream

If you make improvements that should be shared:

```bash
# Make your changes
git add .
git commit -m "Description of changes"
git push origin main

# Create a pull request on GitHub
gh pr create --title "Your improvement" --body "Description"
```

## Troubleshooting

### Authentication Failed
```bash
# Check credentials
git config --global credential.helper
# If not set:
git config --global credential.helper store

# Or use SSH instead
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### Submodule Not Initialized
```bash
# Initialize all submodules
git submodule init
git submodule update --init --recursive
```

### Detached HEAD in Submodule
```bash
cd my-drive-projects/ZOLO-A6-9VxNUNA
git checkout main
cd ../..
git add my-drive-projects/ZOLO-A6-9VxNUNA
git commit -m "Fix submodule branch"
```

### Repository Not Found
- Verify you have access to the repositories
- Check repository names are correct
- Ensure you're authenticated (for private repos)

### Permission Denied
- Set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Or use HTTPS with PAT

## Best Practices

1. **Always commit submodule updates separately** from other changes
2. **Document your changes** in commit messages
3. **Keep forks synchronized** with upstream regularly
4. **Test locally** before pushing to production
5. **Use branches** for experimental changes
6. **Create pull requests** for improvements to upstream

## Security Considerations

- Never commit sensitive data (API keys, passwords, tokens)
- Use `.gitignore` for sensitive files
- Store credentials in Windows Credential Manager or environment variables
- Use GitHub Secrets for CI/CD workflows

## References

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Forking Guide](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Main Project README](../README.md)
- [VPS Setup Guide](../VPS-SETUP-GUIDE.md)

## Support

For issues or questions:
1. Check this documentation
2. Review the main README.md
3. Check repository issues on GitHub
4. Contact: Lengkundee01@outlook.com

## Last Updated

2026-01-03
