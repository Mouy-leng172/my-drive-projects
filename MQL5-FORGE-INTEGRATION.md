# MQL5 Forge Integration Guide

This guide explains how to set up and use the MQL5 Forge repository integration across all repositories in the system.

## 📋 Overview

The MQL5 Forge repository (`https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git`) has been integrated as an additional remote named `mql5-forge` to enable:

- Version control for MQL5 Expert Advisors, Scripts, and Indicators
- Synchronization with the MQL5 Forge community platform
- Backup and recovery of trading code
- Collaboration with other MQL5 developers

## 🚀 Quick Start

### Setup MQL5 Forge Remote (Current Repository)

The easiest way to add the MQL5 Forge remote to the current repository:

**Using Batch File (Windows):**
```cmd
SETUP-MQL5-FORGE-REMOTE.bat
```

**Using PowerShell:**
```powershell
.\setup-mql5-forge-remote.ps1
```

### Setup MQL5 Forge Remote (All Repositories)

To configure the MQL5 Forge remote for all Git repositories on all drives:

```powershell
.\setup-mql5-forge-remote.ps1 -AllDrives
```

This will:
- Scan all drives for Git repositories
- Add or update the `mql5-forge` remote in each repository
- Provide a summary of successful and failed configurations

### Setup MQL5 Forge Remote (Specific Repository)

To configure a specific repository:

```powershell
.\setup-mql5-forge-remote.ps1 -RepoPath "C:\Path\To\Your\Repository"
```

## 🔧 Manual Configuration

If you prefer to manually add the MQL5 Forge remote:

```bash
# Add the remote
git remote add mql5-forge https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git

# Verify it was added
git remote -v
```

## 📦 Working with MQL5 Forge

### Fetch Updates from MQL5 Forge

```bash
git fetch mql5-forge
```

### Pull Changes from MQL5 Forge

```bash
# Pull from main branch
git pull mql5-forge main

# Pull from specific branch
git pull mql5-forge branch-name
```

### Push to MQL5 Forge

```bash
# Push current branch to main on MQL5 Forge
git push mql5-forge main

# Push specific branch
git push mql5-forge branch-name
```

### List All Remotes

```bash
git remote -v
```

Expected output:
```
mql5-forge    https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git (fetch)
mql5-forge    https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git (push)
origin        https://github.com/A6-9V/my-drive-projects (fetch)
origin        https://github.com/A6-9V/my-drive-projects (push)
```

## 🔄 Integration with Existing Scripts

### git-setup.ps1

The `git-setup.ps1` script has been updated to automatically configure the MQL5 Forge remote when setting up a repository. It will:
- Add the `mql5-forge` remote if it doesn't exist
- Update the remote URL if it exists but points to a different location

### push-all-drives-to-same-repo.ps1

The `push-all-drives-to-same-repo.ps1` script has been enhanced to:
- Configure both `drive-projects` and `mql5-forge` remotes
- Ensure all repositories have access to both GitHub and MQL5 Forge

### mql5-service.ps1

The VPS MQL5 service (`vps-services/mql5-service.ps1`) now uses the correct MQL5 Forge repository URL for automated synchronization.

## 🎯 Use Cases

### 1. Trading Code Development

Store and version control your MQL5 Expert Advisors:

```bash
# Work on your EA locally
cd trading-bridge/mql5/

# Commit changes
git add MyExpertAdvisor.mq5
git commit -m "Add new trading strategy"

# Push to GitHub (backup)
git push origin main

# Push to MQL5 Forge (community/collaboration)
git push mql5-forge main
```

### 2. Synchronization Across Devices

Keep your trading code synchronized across multiple devices:

```bash
# On Device 1
git push mql5-forge main

# On Device 2
git pull mql5-forge main
```

### 3. Collaboration with MQL5 Community

Share your code with other MQL5 developers:

```bash
# Push to MQL5 Forge for community access
git push mql5-forge main
```

## 🔐 Security Considerations

### Authentication

MQL5 Forge may require authentication for push operations. Common methods:

1. **HTTPS with Credentials:**
   ```bash
   git config credential.helper store
   git push mql5-forge main
   # You'll be prompted for username and password
   ```

2. **SSH Keys (if supported):**
   ```bash
   git remote set-url mql5-forge git@forge.mql5.io:LengKundee/A6-9V_VL6-N9.git
   ```

### Token Management

For automated scripts, store MQL5 API tokens in:
- `.mql5-config` file (gitignored)
- Windows Credential Manager
- Environment variables

## 📊 Repository Structure

```
my-drive-projects/
├── .git/
│   └── config (contains remote configurations)
├── trading-bridge/
│   └── mql5/              # MQL5 code synchronized with MQL5 Forge
├── mql5-repo/             # Clone of MQL5 Forge repository
├── setup-mql5-forge-remote.ps1
├── SETUP-MQL5-FORGE-REMOTE.bat
└── MQL5-FORGE-INTEGRATION.md (this file)
```

## 🔍 Troubleshooting

### Remote Already Exists

If you see "remote mql5-forge already exists":
```bash
# Update the URL
git remote set-url mql5-forge https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git

# Verify
git remote -v
```

### Authentication Failed

If authentication fails:
1. Check your MQL5 account credentials
2. Ensure you have access to the repository
3. Try HTTPS with personal access token
4. Contact repository administrator for access

### Push Rejected

If push is rejected:
```bash
# Pull latest changes first
git pull mql5-forge main --rebase

# Then push
git push mql5-forge main
```

## 📚 Additional Resources

- **MQL5 Forge Documentation**: https://www.mql5.com/en/forge
- **MQL5 Community**: https://www.mql5.com/en/forum
- **Git Documentation**: https://git-scm.com/doc
- **GitHub Documentation**: https://docs.github.com

## 🎉 Success Indicators

After successful setup, you should be able to:
- ✅ Run `git remote -v` and see `mql5-forge` listed
- ✅ Run `git fetch mql5-forge` without errors
- ✅ Push MQL5 code to MQL5 Forge repository
- ✅ Pull updates from MQL5 Forge repository
- ✅ Collaborate with other MQL5 developers

## 📝 Notes

- The MQL5 Forge remote is configured automatically by setup scripts
- All repositories can be configured in batch using `-AllDrives` parameter
- The integration is backward compatible with existing workflows
- No manual configuration is required for new repositories when using `git-setup.ps1`

## 🔄 Maintenance

To keep the integration working smoothly:

1. **Periodic Verification** (Weekly):
   ```powershell
   .\setup-mql5-forge-remote.ps1 -AllDrives
   ```

2. **Check Remote Status**:
   ```bash
   git remote show mql5-forge
   ```

3. **Update Remote URL** (if changed):
   ```bash
   git remote set-url mql5-forge <new-url>
   ```

## 📞 Support

For issues or questions:
- Check the Troubleshooting section above
- Review the MQL5 Forge documentation
- Contact the repository administrator
- Submit an issue on GitHub

---

**Last Updated**: 2026-01-01  
**Version**: 1.0.0  
**Author**: A6-9V / Lengkundee01
