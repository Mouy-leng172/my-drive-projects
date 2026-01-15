# My Drive Projects - Index

## 📁 Directory Contents

This directory contains documentation and tools for integrating forked repositories into the main project.

### Documentation Files

| File | Description |
|------|-------------|
| `README.md` | Overview of forked repositories and integration methods |
| `FORK-INTEGRATION-GUIDE.md` | Comprehensive guide for fork setup and maintenance |
| `QUICK-START.md` | Quick setup instructions for getting started |
| `INDEX.md` | This file - directory index and navigation |

### Setup Tools

| File | Description |
|------|-------------|
| `setup-forks.ps1` | PowerShell script for automated fork setup |
| `SETUP-FORKS.bat` | Windows batch file launcher for setup script |
| `.gitmodules.template` | Template for Git submodules configuration |

### Forked Repositories (After Setup)

| Directory | Repository | Purpose |
|-----------|------------|---------|
| `ZOLO-A6-9VxNUNA/` | Mouy-leng/ZOLO-A6-9VxNUNA- | Trading system website |
| `MQL5-Google-Onedrive/` | A6-9V/MQL5-Google-Onedrive | MQL5 cloud integration |

## 🚀 Getting Started

1. **First Time Setup**:
   - Read [QUICK-START.md](QUICK-START.md) for fast setup
   - Or read [README.md](README.md) for overview

2. **Detailed Setup**:
   - Follow [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md) for complete instructions
   - Choose your preferred integration method

3. **Run Setup Script**:
   ```cmd
   SETUP-FORKS.bat
   ```
   Or:
   ```powershell
   .\setup-forks.ps1
   ```

## 📖 Documentation Flow

```
START HERE
    ↓
README.md (Overview)
    ↓
QUICK-START.md (Fast Setup)
    ↓
FORK-INTEGRATION-GUIDE.md (Detailed Guide)
    ↓
Use setup-forks.ps1 or SETUP-FORKS.bat
    ↓
Repositories Integrated ✓
```

## 🔧 Integration Methods

Choose the method that best fits your workflow:

### 1. Automated Script (Easiest)
- **File**: `setup-forks.ps1` or `SETUP-FORKS.bat`
- **Best for**: Quick setup, beginners
- **Guide**: [QUICK-START.md](QUICK-START.md)

### 2. Git Submodules (Recommended)
- **Best for**: Version tracking, developers
- **Guide**: [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md#method-1-git-submodules-recommended-for-developers)

### 3. Direct Clone
- **Best for**: Simple, manual control
- **Guide**: [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md#method-2-direct-clone-simple-but-manual)

### 4. GitHub CLI
- **Best for**: Automated forking
- **Guide**: [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md#method-3-github-cli-automated-forking)

## 🔗 Related Documentation

- [Main Project README](../README.md)
- [VPS Setup Guide](../VPS-SETUP-GUIDE.md)
- [Trading System Setup](../TRADING-SYSTEM-COMPLETE-SUMMARY.md)
- [Automation Rules](../AUTOMATION-RULES.md)

## 🛠️ Troubleshooting

Common issues and solutions:

1. **Authentication Failed**: See [FORK-INTEGRATION-GUIDE.md - Authentication](FORK-INTEGRATION-GUIDE.md#authentication)
2. **Repository Not Found**: Check access permissions
3. **Submodule Issues**: See troubleshooting section in guide

## 📋 Checklist

Before you start:
- [ ] Git is installed
- [ ] GitHub account has access to repositories
- [ ] Authentication is set up (SSH or PAT)
- [ ] Read QUICK-START.md or README.md

After setup:
- [ ] Verify repositories are cloned/forked
- [ ] Test repository access
- [ ] Update as needed
- [ ] Integrate with main project

## 🔐 Security Notes

- Never commit sensitive data
- Use `.gitignore` for credentials
- Keep tokens secure
- Use environment variables for secrets

## 📊 Project Structure

```
my-drive-projects/
│
├── Documentation (You are here)
│   ├── README.md
│   ├── FORK-INTEGRATION-GUIDE.md
│   ├── QUICK-START.md
│   └── INDEX.md
│
├── Setup Tools
│   ├── setup-forks.ps1
│   ├── SETUP-FORKS.bat
│   └── .gitmodules.template
│
└── Forked Repositories (After setup)
    ├── ZOLO-A6-9VxNUNA/
    └── MQL5-Google-Onedrive/
```

## 🎯 Quick Navigation

- **Need quick setup?** → [QUICK-START.md](QUICK-START.md)
- **Want detailed info?** → [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md)
- **Just an overview?** → [README.md](README.md)
- **Having issues?** → Check troubleshooting in [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md#troubleshooting)

## 📞 Support

- Email: Lengkundee01@outlook.com
- GitHub: @A6-9V / @Mouy-leng

---

**Last Updated**: 2026-01-03
**Version**: 1.0
