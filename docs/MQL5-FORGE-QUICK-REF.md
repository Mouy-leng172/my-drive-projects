# MQL5 Forge Quick Reference

## 🚀 Quick Setup

### Windows (Double-Click)
```
SETUP-MQL5-FORGE-REMOTE.bat
```

### PowerShell (Current Repo)
```powershell
.\setup-mql5-forge-remote.ps1
```

### PowerShell (All Repos)
```powershell
.\setup-mql5-forge-remote.ps1 -AllDrives
```

## 📋 Common Commands

### Check Remotes
```bash
git remote -v
```

### Fetch from MQL5 Forge
```bash
git fetch mql5-forge
```

### Pull from MQL5 Forge
```bash
git pull mql5-forge main
```

### Push to MQL5 Forge
```bash
git push mql5-forge main
```

### Push to Both (GitHub + MQL5 Forge)
```bash
git push origin main
git push mql5-forge main
```

## 🔧 Troubleshooting

### Remote Already Exists
```bash
git remote set-url mql5-forge https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git
```

### Remove Remote
```bash
git remote remove mql5-forge
```

### Show Remote Info
```bash
git remote show mql5-forge
```

## 📚 Full Documentation
See **MQL5-FORGE-INTEGRATION.md** for complete guide.

## ✅ Expected Result
```
mql5-forge    https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git (fetch)
mql5-forge    https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git (push)
origin        https://github.com/A6-9V/my-drive-projects (fetch)
origin        https://github.com/A6-9V/my-drive-projects (push)
```
