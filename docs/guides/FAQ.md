# Frequently Asked Questions (FAQ)

Common questions and answers about the A6-9V/my-drive-projects automation system.

## Table of Contents

- [General Questions](#general-questions)
- [Installation and Setup](#installation-and-setup)
- [Git and GitHub](#git-and-github)
- [Trading System](#trading-system)
- [Cloud Sync](#cloud-sync)
- [Security](#security)
- [Performance](#performance)
- [Advanced Topics](#advanced-topics)

## General Questions

### What is this project?

This is a comprehensive Windows automation and trading system that includes:
- Windows setup automation
- Git repository management
- Python-based trading bridge for MetaTrader 5
- MQL5 integration
- Cloud sync automation
- VPS deployment tools
- Project discovery and management

### Who is this project for?

This project is designed for:
- Personal automation enthusiasts
- Algorithmic traders using MetaTrader 5
- Developers managing multiple projects
- Windows power users seeking automation
- Anyone wanting to streamline their Windows workflow

### Do I need to use all features?

No! The system is modular. You can use:
- Just Windows automation
- Just Git automation
- Just the trading system
- Any combination you need

### Is this free?

Yes, this is a personal project and free to use. However:
- Some features require third-party services (GitHub, cloud storage)
- Trading requires a broker account (which may have costs)
- VPS hosting (if used) has associated costs

## Installation and Setup

### What are the minimum requirements?

- **OS**: Windows 11 or Windows 10 (Build 19041+)
- **RAM**: 8GB minimum (16GB for trading)
- **Storage**: 50GB free space
- **Software**: PowerShell 5.1+, Git, Python 3.8+

See [PREREQUISITES.md](PREREQUISITES.md) for complete requirements.

### How long does setup take?

- **Quick setup**: 15-30 minutes (using `quick-start.ps1`)
- **Complete setup**: 1-2 hours (including trading system)
- **Manual setup**: 2-4 hours (following documentation)

### Do I need to run as Administrator?

Most setup scripts require Administrator privileges for:
- Creating scheduled tasks
- Configuring Windows settings
- Adding firewall rules
- Installing system-level components

Regular operation typically doesn't require admin rights.

### Can I use this on Windows 10?

Yes, but:
- Windows 11 is recommended and fully tested
- Some features may require Windows 10 version 2004 or later
- Cloud sync integration works best on Windows 11

### Do I need to install everything at once?

No! You can:
1. Start with basic setup
2. Add components as needed
3. Skip optional features
4. Customize to your needs

Use `quick-start.ps1` for an interactive setup that lets you choose components.

## Git and GitHub

### Do I need a GitHub account?

Yes, if you want to:
- Push code to GitHub
- Use Git automation features
- Sync repositories

No, if you only want:
- Local Windows automation
- Local scripts without version control

### What's the difference between GitHub CLI and PAT?

**GitHub CLI (`gh`)**: (Recommended)
- OAuth-based authentication
- More secure (tokens stored securely)
- Easier to use
- Automatic token refresh

**Personal Access Token (PAT)**:
- Manual token management
- Need to regenerate periodically
- Good for automation scripts
- Used as fallback

### How do I authenticate with GitHub?

**Option 1 - GitHub CLI (Recommended):**
```powershell
gh auth login
gh auth setup-git
```

**Option 2 - Personal Access Token:**
1. Create PAT at github.com/settings/tokens
2. Create `git-credentials.txt` (gitignored):
   ```
   GITHUB_TOKEN=your_token_here
   ```

### Can I use this with private repositories?

Yes! The system works with both public and private repositories. Make sure your authentication (GitHub CLI or PAT) has the correct permissions.

### What if I have multiple GitHub accounts?

You can:
1. Use different PATs for each account
2. Switch GitHub CLI profiles: `gh auth switch`
3. Configure per-repository credentials

## Trading System

### Do I need MetaTrader 5?

Only if you want to use the trading features. The rest of the system works without MT5.

### Which brokers are supported?

Primary support:
- **Exness** (fully integrated)

Can be adapted for:
- Any broker with MetaTrader 5
- Any broker with API access

### Is this safe for real money trading?

**Important**: 
- This is a personal project, use at your own risk
- Start with demo accounts
- Test thoroughly before using real money
- Never trade with money you can't afford to lose
- Understand the code before running it

### Can I trade multiple symbols simultaneously?

Yes! The system supports:
- Multi-symbol trading (18-symbol strategy included)
- Custom symbol configurations
- Capital allocation across symbols
- Independent risk management per symbol

### What if my internet connection drops?

The system includes:
- Auto-reconnection logic
- Trade recovery mechanisms
- Logging for troubleshooting
- VPS deployment option for 24/7 uptime

For critical trading, use a VPS with reliable internet.

### How do I stop the trading system?

```powershell
# Stop trading processes
Get-Process python | Where-Object { $_.MainWindowTitle -like "*trading*" } | Stop-Process

# Or find and stop by port
netstat -ano | findstr :5500
Stop-Process -Id <PID>
```

Always close MT5 properly to ensure all trades are handled correctly.

## Cloud Sync

### Do I need OneDrive/Google Drive/Dropbox?

No, cloud sync is optional. Benefits include:
- Automatic backup of your work
- Access from multiple devices
- File versioning and recovery

### Can I use just one cloud service?

Yes! Choose the one you prefer:
- **OneDrive**: Built into Windows 11
- **Google Drive**: 15GB free
- **Dropbox**: Popular but smaller free tier

### Will this sync my entire drive?

No. The system:
- Only syncs designated folders
- Respects your cloud service settings
- Won't change existing sync configurations
- You control what syncs

### What about sync conflicts?

The system:
- Tries to avoid conflicts through proper Git usage
- Logs conflicts when they occur
- Provides tools to resolve issues
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for resolution steps

## Security

### Are my credentials safe?

Yes, if you follow best practices:
- ✅ Never commit credentials to Git (gitignore configured)
- ✅ Use Windows Credential Manager for storage
- ✅ Use OAuth when possible (GitHub CLI)
- ✅ Keep .env files local only

See [SECURITY.md](SECURITY.md) for complete guidelines.

### What if I accidentally commit a credential?

1. **Immediately** revoke the credential
2. Remove from Git history:
   ```powershell
   git filter-branch --force --index-filter "git rm --cached --ignore-unmatch path/to/file" --prune-empty --tag-name-filter cat -- --all
   ```
3. Generate new credentials
4. Update configuration

### Is Windows Defender okay with these scripts?

Yes, but:
- Scripts may trigger SmartScreen initially
- Setup scripts add exclusions for project folders
- Some automation may seem "suspicious" to antivirus
- All scripts are open source for your review

### Should I make my repository private?

**Recommended**: Yes, especially if you:
- Use the trading system
- Store any configuration
- Have custom strategies

**Public is okay**: If you only use generic automation and don't store anything sensitive.

## Performance

### Will this slow down my computer?

During active use:
- **Trading**: Low to moderate CPU usage
- **Cloud sync**: Depends on sync activity
- **Automation**: Minimal impact

The system is designed to be efficient, but:
- Trading with many symbols uses more resources
- Large file syncs can be bandwidth-intensive
- 8GB RAM is minimum; 16GB recommended for trading

### Can I run this 24/7?

Yes! That's what the VPS deployment is for:
- Rent a Windows VPS
- Deploy the system
- Run trading 24/7 without your personal computer

For home use:
- Schedule tasks for specific times
- Use power settings to prevent sleep during trading
- Monitor system health regularly

### How much bandwidth does it use?

- **Git sync**: Minimal (KB to MB per push)
- **Cloud sync**: Varies (depends on files)
- **Trading API**: Minimal (KB per minute)
- **MT5 updates**: Low (streaming quotes)

Typical usage: <100MB per day excluding large file uploads

### What about disk space?

The system uses approximately:
- **Project files**: ~5GB
- **Python environment**: ~2GB
- **Logs**: 100MB-1GB (grows over time)
- **MT5**: ~500MB
- **Cloud sync cache**: Varies

Regular cleanup scripts help manage disk usage.

## Advanced Topics

### Can I customize the scripts?

Absolutely! The code is:
- Open source
- Well-commented
- Modular design
- Easy to modify

Just be careful not to:
- Break security features
- Remove error handling
- Commit credentials after customization

### How do I add a new broker?

1. Create broker implementation in `trading-bridge/python/brokers/`
2. Extend `base_broker.py`
3. Add configuration to `brokers.json.example`
4. Update documentation

See existing `exness_api.py` as a template.

### Can I use this with other programming languages?

The core is PowerShell and Python, but:
- PowerShell can call other programs
- Python can integrate with many languages
- MQL5 bridge works with any ZeroMQ client
- Adapt as needed for your use case

### How do I contribute?

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See contribution guidelines (if available) or create an issue first to discuss.

### Can I use this commercially?

This is a personal project. For commercial use:
- Review the license
- Consider security implications
- Test extensively
- May need additional features for production
- Consider liability and risk management

### How do I backup my configuration?

```powershell
# Backup script
.\backup-to-usb.ps1

# Manual backup
$backupDir = "E:\Backup\$(Get-Date -Format 'yyyy-MM-dd')"
New-Item -ItemType Directory -Path $backupDir
Copy-Item .env, trading-bridge\config\* $backupDir
```

**Never** backup to cloud sync folders if they contain credentials!

### What's the difference between VPS and local setup?

**Local Setup**:
- Runs on your personal computer
- Requires computer to be on
- Good for development and testing
- Can be interrupted by restarts/sleep

**VPS Setup**:
- Runs on remote server 24/7
- Professional uptime
- Good for production trading
- Costs $5-50/month depending on specs

### How do I update to the latest version?

```powershell
# Pull latest changes
git pull origin main

# Update Python dependencies
pip install --upgrade -r trading-bridge\requirements.txt

# Re-run setup if needed
.\validate-setup.ps1
```

Always backup before updating!

### Can I run multiple trading strategies?

Yes! You can:
1. Run multiple Python scripts
2. Use different symbol configurations
3. Deploy multiple MQL5 EAs
4. Manage through MQL.io service

Just ensure adequate resources and risk management.

## Still Have Questions?

### Documentation

- [HOW-TO-RUN.md](HOW-TO-RUN.md) - Setup guide
- [PREREQUISITES.md](PREREQUISITES.md) - Requirements
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues
- [SECURITY.md](SECURITY.md) - Security guidelines

### Support

- Check existing [GitHub Issues](https://github.com/A6-9V/my-drive-projects/issues)
- Review [Discussions](https://github.com/A6-9V/my-drive-projects/discussions)
- Run diagnostics: `.\validate-setup.ps1`

### Community

- Share your experience
- Report bugs
- Suggest improvements
- Help others with similar questions

---

**Last Updated**: 2026-01-02  
**Maintained by**: A6-9V Organization

**Don't see your question?** Create an issue or discussion on GitHub!
