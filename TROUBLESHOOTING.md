# Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the A6-9V/my-drive-projects automation system.

## Table of Contents

1. [Quick Diagnostics](#quick-diagnostics)
2. [Installation Issues](#installation-issues)
3. [Git and GitHub Issues](#git-and-github-issues)
4. [Python and Dependencies](#python-and-dependencies)
5. [Trading System Issues](#trading-system-issues)
6. [Cloud Sync Issues](#cloud-sync-issues)
7. [Windows Configuration Issues](#windows-configuration-issues)
8. [Performance Issues](#performance-issues)
9. [Network and Connectivity](#network-and-connectivity)
10. [Getting Additional Help](#getting-additional-help)

## Quick Diagnostics

### Run Automated Diagnostics

```powershell
# Comprehensive system check
.\validate-setup.ps1

# System status report
.\system-status-report.ps1

# Trading system verification
.\verify-trading-system.ps1

# Security validation
.\security-check.ps1
```

### Check Logs

Most scripts create log files. Check these locations:
```powershell
# Current directory logs
Get-ChildItem *.log | Sort-Object LastWriteTime -Descending | Select-Object -First 5

# Trading bridge logs
Get-ChildItem trading-bridge\logs\*.log

# Check Windows Event Viewer
eventvwr.msc
```

## Installation Issues

### Issue: PowerShell Script Execution Blocked

**Symptoms:**
- Error: "cannot be loaded because running scripts is disabled"
- Scripts won't run even when double-clicked

**Solution:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set to allow scripts (run as Administrator)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Verify
Get-ExecutionPolicy
```

**Alternative (for a single script):**
```powershell
PowerShell -ExecutionPolicy Bypass -File .\script.ps1
```

### Issue: "Access Denied" Errors

**Symptoms:**
- Permission errors when running scripts
- Cannot create files or directories
- Registry access denied

**Solution:**
```powershell
# Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"

# Or use the elevation script
.\launch-admin.ps1

# Or use the batch file
.\run-as-admin.bat
```

### Issue: Git Not Found

**Symptoms:**
- "git: command not found"
- Git scripts fail immediately

**Solution:**
```powershell
# 1. Install Git
# Download from: https://git-scm.com/download/win

# 2. Verify installation
git --version

# 3. If still not found, add to PATH
$env:Path += ";C:\Program Files\Git\cmd"

# 4. Restart PowerShell
```

### Issue: Python Not Found

**Symptoms:**
- "python: command not found"
- Python scripts fail to run

**Solution:**
```powershell
# 1. Install Python from python.org
# Make sure to check "Add Python to PATH" during installation

# 2. Verify installation
python --version
pip --version

# 3. If installed but not in PATH
$env:Path += ";C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python310"

# 4. Restart PowerShell
```

## Git and GitHub Issues

### Issue: Git Authentication Failed

**Symptoms:**
- "Authentication failed" when pushing
- "fatal: could not read Password"
- 403 or 401 errors

**Solution A: Use GitHub CLI (Recommended):**
```powershell
# Install GitHub CLI
winget install --id GitHub.cli

# Login with OAuth
gh auth login

# Configure Git to use gh
gh auth setup-git

# Test
gh auth status
```

**Solution B: Use Personal Access Token:**
```powershell
# 1. Generate PAT at: https://github.com/settings/tokens
# 2. Required scopes: repo, workflow

# 3. Create git-credentials.txt (gitignored)
@"
GITHUB_TOKEN=ghp_your_token_here
"@ | Out-File git-credentials.txt -Encoding ASCII

# 4. Test
.\auto-git-push.ps1
```

### Issue: Git Push Rejected (Non-Fast-Forward)

**Symptoms:**
- "Updates were rejected because the tip of your current branch is behind"

**Solution:**
```powershell
# Option 1: Pull and merge
git pull origin main
git push origin main

# Option 2: Rebase (if you know what you're doing)
git pull --rebase origin main
git push origin main

# Option 3: If local changes are correct (DANGEROUS)
# git push --force origin main  # Use with extreme caution!
```

### Issue: Merge Conflicts

**Symptoms:**
- "Automatic merge failed; fix conflicts"
- Files marked with conflict markers (<<<<<<<, =======, >>>>>>>)

**Solution:**
```powershell
# 1. Check conflicted files
git status

# 2. Open files in editor and resolve conflicts
code conflicted-file.ps1

# 3. Mark as resolved
git add conflicted-file.ps1

# 4. Complete merge
git commit -m "Resolve merge conflicts"

# 5. Push
git push origin main
```

### Issue: Large Files Rejected

**Symptoms:**
- "file is 1XX.XX MB; this exceeds GitHub's file size limit"

**Solution:**
```powershell
# 1. Check file size
Get-ChildItem -Recurse | Where-Object { $_.Length -gt 100MB }

# 2. Remove from staging
git reset HEAD large-file.exe

# 3. Add to .gitignore
"large-file.exe" | Add-Content .gitignore

# 4. If already committed
git rm --cached large-file.exe
git commit -m "Remove large file"
```

## Python and Dependencies

### Issue: Module Not Found

**Symptoms:**
- `ModuleNotFoundError: No module named 'zmq'`
- Import errors in Python scripts

**Solution:**
```powershell
# 1. Activate virtual environment (if using)
.\venv\Scripts\Activate.ps1

# 2. Install dependencies
pip install -r trading-bridge\requirements.txt

# 3. Verify installation
pip list

# 4. If specific module missing
pip install pyzmq requests python-dotenv
```

### Issue: Virtual Environment Activation Fails

**Symptoms:**
- "Activate.ps1 cannot be loaded because running scripts is disabled"

**Solution:**
```powershell
# Set execution policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Try activation again
.\venv\Scripts\Activate.ps1

# Verify activation (should show (venv) in prompt)
```

### Issue: pip Install Fails

**Symptoms:**
- Permission errors during pip install
- "Could not install packages due to an EnvironmentError"

**Solution:**
```powershell
# Option 1: Upgrade pip
python -m pip install --upgrade pip

# Option 2: Install with user flag
pip install --user -r trading-bridge\requirements.txt

# Option 3: Run as Administrator
Start-Process powershell -Verb RunAs -ArgumentList "-Command pip install -r trading-bridge\requirements.txt"
```

### Issue: Python Version Conflict

**Symptoms:**
- Multiple Python versions installed
- Wrong Python version being used

**Solution:**
```powershell
# Check Python version
python --version

# List all Python installations
Get-Command python -All

# Use specific version
py -3.10 --version
py -3.10 -m pip install -r requirements.txt

# Or specify path
C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python310\python.exe
```

## Trading System Issues

### Issue: Port 5500 Already in Use

**Symptoms:**
- "Address already in use"
- Trading bridge fails to start

**Solution:**
```powershell
# 1. Find process using port 5500
netstat -ano | findstr :5500

# 2. Note the PID (Process ID) from last column

# 3. Stop the process (replace PID with actual number)
Stop-Process -Id PID -Force

# 4. Or use Task Manager
# Ctrl+Shift+Esc → Find process by PID → End Task

# 5. Start trading bridge
.\start-trading-system-admin.ps1
```

### Issue: MetaTrader 5 Not Found

**Symptoms:**
- Scripts can't locate MT5 installation
- "MetaTrader 5 not installed" warning

**Solution:**
```powershell
# 1. Verify MT5 installation
Test-Path "C:\Program Files\MetaTrader 5\terminal64.exe"

# 2. If installed elsewhere, set environment variable
$env:MT5_PATH = "D:\MetaTrader 5\terminal64.exe"

# 3. Or add to .env file
@"
MT5_PATH=D:\MetaTrader 5\terminal64.exe
"@ | Add-Content .env
```

### Issue: Broker API Authentication Failed

**Symptoms:**
- "Invalid API key" or "Authentication failed"
- API calls return 401/403 errors

**Solution:**
```powershell
# 1. Verify credentials in config
code trading-bridge\config\brokers.json

# 2. Test API key at broker website

# 3. Regenerate API key if necessary

# 4. Update brokers.json with new credentials

# 5. Run security check
.\security-check-trading.ps1

# 6. Test connection
python -c "from trading_bridge.python.brokers.exness_api import ExnessAPI; print(ExnessAPI().test_connection())"
```

### Issue: Trading Bridge Connection Timeout

**Symptoms:**
- Connection timeouts
- "Failed to connect to trading bridge"

**Solution:**
```powershell
# 1. Check if bridge is running
Get-Process | Where-Object { $_.ProcessName -like "*python*" }

# 2. Check firewall rules
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Trading*" }

# 3. Configure firewall
.\trading-bridge\setup-firewall-port-5500.ps1

# 4. Test connectivity
Test-NetConnection -ComputerName localhost -Port 5500
```

## Cloud Sync Issues

### Issue: OneDrive Not Syncing

**Symptoms:**
- Files not uploading to OneDrive
- Sync status shows errors

**Solution:**
```powershell
# 1. Check OneDrive status
Get-Process OneDrive

# 2. Restart OneDrive
Stop-Process -Name OneDrive -Force
Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

# 3. Reset OneDrive (if persistent issues)
# Run as Administrator:
%localappdata%\Microsoft\OneDrive\OneDrive.exe /reset

# 4. Check sync settings
# OneDrive icon → Settings → Sync and backup
```

### Issue: Google Drive Not Starting

**Symptoms:**
- Google Drive process not found
- Files not syncing

**Solution:**
```powershell
# 1. Check installation
Test-Path "$env:LOCALAPPDATA\Google\Drive File Stream\GoogleDriveFS.exe"

# 2. Start Google Drive
Start-Process "$env:LOCALAPPDATA\Google\Drive File Stream\GoogleDriveFS.exe"

# 3. If not installed
# Download from: https://www.google.com/drive/download/

# 4. Configure sync folders
# Google Drive icon → Settings → Add folder
```

### Issue: Dropbox Conflicts

**Symptoms:**
- "Dropbox conflicted copy" files appearing
- Sync errors

**Solution:**
```powershell
# 1. Resolve conflicts manually
# Review conflicted files and choose correct version

# 2. Restart Dropbox
Stop-Process -Name Dropbox -Force
Start-Process "$env:LOCALAPPDATA\Dropbox\Dropbox.exe"

# 3. Check selective sync settings
# Dropbox icon → Preferences → Sync → Selective Sync
```

## Windows Configuration Issues

### Issue: Windows Defender Blocking Scripts

**Symptoms:**
- Scripts deleted or quarantined
- "Trojan" or "PUA" warnings

**Solution:**
```powershell
# 1. Add exclusions (run as Administrator)
Add-MpPreference -ExclusionPath "C:\Path\To\Project"

# 2. Or use setup script
.\complete-windows-setup.ps1

# 3. Restore quarantined files
# Windows Security → Virus & threat protection → Protection history → Restore
```

### Issue: Firewall Blocking Connections

**Symptoms:**
- Network connections fail
- Services can't communicate

**Solution:**
```powershell
# 1. Check firewall rules
Get-NetFirewallRule | Where-Object { $_.Enabled -eq $true }

# 2. Add rules for trading bridge
.\setup-network-firewall.ps1

# 3. Or manually add rule
New-NetFirewallRule -DisplayName "Trading Bridge" -Direction Inbound -LocalPort 5500 -Protocol TCP -Action Allow
```

### Issue: Task Scheduler Jobs Not Running

**Symptoms:**
- Auto-startup not working
- Scheduled tasks fail

**Solution:**
```powershell
# 1. Check scheduled tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like "*Trading*" }

# 2. View task details
Get-ScheduledTask -TaskName "TaskName" | Get-ScheduledTaskInfo

# 3. Re-create task
.\setup-auto-startup-admin.ps1

# 4. Run task manually for testing
Start-ScheduledTask -TaskName "TaskName"
```

## Performance Issues

### Issue: High CPU Usage

**Symptoms:**
- System slow or unresponsive
- Fan running constantly

**Solution:**
```powershell
# 1. Identify CPU-intensive processes
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# 2. Check trading system processes
Get-Process | Where-Object { $_.ProcessName -in @("python", "terminal64") }

# 3. Limit trading operations
# Edit trading-bridge\config\symbols.json
# Reduce number of active symbols or max_trades

# 4. Close unnecessary programs
```

### Issue: High Memory Usage

**Symptoms:**
- System running out of RAM
- "Out of memory" errors

**Solution:**
```powershell
# 1. Check memory usage
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10

# 2. Close memory-intensive applications

# 3. Increase virtual memory (pagefile)
# System Properties → Advanced → Performance Settings → Advanced → Virtual memory

# 4. Consider RAM upgrade (8GB minimum, 16GB recommended)
```

### Issue: Disk Space Running Low

**Symptoms:**
- "Low disk space" warnings
- Programs can't write files

**Solution:**
```powershell
# 1. Check disk space
Get-PSDrive C | Select-Object Used, Free

# 2. Run disk cleanup
.\maintain-and-cleanup.ps1

# 3. Clean Windows temp files
cleanmgr.exe

# 4. Remove old logs
Remove-Item *.log -Force
Remove-Item trading-bridge\logs\*.log -Force

# 5. Move large files to external drive
```

## Network and Connectivity

### Issue: Internet Connection Test Fails

**Symptoms:**
- Cannot reach github.com
- API calls timeout

**Solution:**
```powershell
# 1. Test connectivity
Test-NetConnection -ComputerName github.com -Port 443

# 2. Check DNS
nslookup github.com

# 3. Flush DNS cache
ipconfig /flushdns

# 4. Check proxy settings
netsh winhttp show proxy

# 5. Reset network stack (if needed)
netsh winsock reset
netsh int ip reset
# Restart computer
```

### Issue: VPN Conflicts

**Symptoms:**
- Connection issues when VPN is active
- Services can't reach APIs

**Solution:**
```powershell
# 1. Check VPN status
Get-VpnConnection

# 2. Add split tunneling rules (if supported by VPN)
# Allow local network and trading APIs outside VPN

# 3. Or disconnect VPN for local testing

# 4. Configure VPN to allow required ports
```

## Getting Additional Help

### Self-Service Resources

1. **Run Diagnostics:**
   ```powershell
   .\validate-setup.ps1
   .\system-status-report.ps1
   ```

2. **Check Documentation:**
   - `HOW-TO-RUN.md` - Setup guide
   - `PREREQUISITES.md` - Requirements
   - `README.md` - Overview
   - `SECURITY.md` - Security guidelines

3. **Review Logs:**
   ```powershell
   # View recent logs
   Get-ChildItem *.log | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | ForEach-Object { Get-Content $_.FullName -Tail 20 }
   ```

4. **Check System Status:**
   ```powershell
   # Windows version
   winver
   
   # System info
   systeminfo
   
   # PowerShell version
   $PSVersionTable
   ```

### Community Support

1. **GitHub Issues:**
   - Search existing issues
   - Create new issue with:
     - Problem description
     - Steps to reproduce
     - Error messages
     - System information

2. **GitHub Discussions:**
   - Ask questions
   - Share solutions
   - Get community feedback

### Escalation

For critical issues:

1. **Trading Issues:**
   - Stop trading immediately
   - Document the problem
   - Contact repository maintainer

2. **Security Issues:**
   - Follow SECURITY.md guidelines
   - Report privately to maintainer
   - Do not disclose publicly

3. **Data Loss:**
   - Stop all operations
   - Do not modify files
   - Restore from backup
   - Document what happened

## FAQ

### Q: Why do scripts keep asking for credentials?

**A:** Use GitHub CLI for persistent authentication:
```powershell
gh auth login
gh auth setup-git
```

### Q: Can I run this on Windows 10?

**A:** Yes, but Windows 11 is recommended. Some features may require updates.

### Q: Do I need all cloud services?

**A:** No, cloud sync is optional. The core system works without it.

### Q: Is Python 3.7 supported?

**A:** No, Python 3.8+ is required. Some dependencies need newer Python features.

### Q: Can I use a different port for trading bridge?

**A:** Yes, edit `.env`:
```
TRADING_BRIDGE_PORT=5501
```

### Q: How do I completely uninstall?

**A:**
```powershell
# 1. Stop all services
.\stop-all-services.ps1  # If exists

# 2. Remove scheduled tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like "*Trading*" } | Unregister-ScheduledTask

# 3. Remove firewall rules
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*Trading*" } | Remove-NetFirewallRule

# 4. Delete directory
Remove-Item -Recurse -Force C:\Path\To\my-drive-projects
```

---

**Last Updated**: 2026-01-02  
**Maintained by**: A6-9V Organization

**Still having issues?** Check `HOW-TO-RUN.md` or create a GitHub issue.
