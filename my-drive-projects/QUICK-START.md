# Quick Start - Fork Setup

This guide helps you quickly set up the forked repositories for the my-drive-projects integration.

## Prerequisites

- Git installed
- GitHub account with access to the repositories
- GitHub CLI (optional, but recommended)

## Fast Setup (Recommended)

### Windows Users

1. Open PowerShell as Administrator
2. Navigate to the my-drive-projects directory:
   ```powershell
   cd path\to\my-drive-projects\my-drive-projects
   ```
3. Run the setup script:
   ```cmd
   SETUP-FORKS.bat
   ```

### Using PowerShell Directly

```powershell
cd my-drive-projects
.\setup-forks.ps1
```

### Linux/Mac Users

```bash
cd my-drive-projects
pwsh setup-forks.ps1
```

## Manual Setup

If the automated script doesn't work:

### Option A: Using GitHub CLI (Easiest)

```bash
# Authenticate
gh auth login

# Fork and clone
cd my-drive-projects
gh repo fork Mouy-leng/ZOLO-A6-9VxNUNA- --clone=true
gh repo fork A6-9V/MQL5-Google-Onedrive --clone=true

# Rename directories if needed
mv ZOLO-A6-9VxNUNA- ZOLO-A6-9VxNUNA
```

### Option B: Using Git Submodules

```bash
# From repository root
git submodule add https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git my-drive-projects/ZOLO-A6-9VxNUNA
git submodule add https://github.com/A6-9V/MQL5-Google-Onedrive.git my-drive-projects/MQL5-Google-Onedrive

# Initialize
git submodule init
git submodule update

# Commit
git add .gitmodules my-drive-projects/
git commit -m "Add forked repositories as submodules"
```

### Option C: Direct Git Clone

```bash
cd my-drive-projects

# Clone repos
git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git ZOLO-A6-9VxNUNA
git clone https://github.com/A6-9V/MQL5-Google-Onedrive.git MQL5-Google-Onedrive

# Important: Add to .gitignore if using this method
echo "my-drive-projects/ZOLO-A6-9VxNUNA/" >> ../.gitignore
echo "my-drive-projects/MQL5-Google-Onedrive/" >> ../.gitignore
```

## Verify Setup

Check that repositories are properly set up:

```bash
cd my-drive-projects
ls -la ZOLO-A6-9VxNUNA/
ls -la MQL5-Google-Onedrive/
```

You should see the repository contents in each directory.

## Authentication Issues?

If you encounter authentication errors:

### For Private Repositories

1. **Generate Personal Access Token (PAT)**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `repo` (full control)
   - Copy the token

2. **Use PAT as password**:
   ```bash
   git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
   # Username: your-github-username
   # Password: paste-your-PAT-here
   ```

### Or Use SSH

1. **Generate SSH key**:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Add to GitHub**:
   - Copy public key: `cat ~/.ssh/id_ed25519.pub`
   - Go to: https://github.com/settings/keys
   - Add new SSH key

3. **Clone with SSH**:
   ```bash
   git clone git@github.com:Mouy-leng/ZOLO-A6-9VxNUNA-.git
   git clone git@github.com:A6-9V/MQL5-Google-Onedrive.git
   ```

## Next Steps

After successful setup:

1. **Review the repositories**:
   - Check ZOLO-A6-9VxNUNA for website files
   - Check MQL5-Google-Onedrive for MQL5 scripts

2. **Test integration**:
   - Run VPS services to ensure they can access the repositories
   - Test cloud synchronization features

3. **Keep updated**:
   - Regularly pull updates from upstream
   - See FORK-INTEGRATION-GUIDE.md for maintenance instructions

## Troubleshooting

### "Repository not found"
- Verify repository names are correct
- Check you have access to the repositories
- Ensure authentication is set up

### "Permission denied"
- Set up SSH keys or use HTTPS with PAT
- Check your GitHub account has necessary permissions

### "Already exists"
- Repositories are already set up
- Use `git pull` to update instead

## Need More Help?

- Read full documentation: [FORK-INTEGRATION-GUIDE.md](FORK-INTEGRATION-GUIDE.md)
- Check main project README: [../README.md](../README.md)
- Review VPS setup: [../VPS-SETUP-GUIDE.md](../VPS-SETUP-GUIDE.md)

## Contact

For support: Lengkundee01@outlook.com

---

**Last Updated**: 2026-01-03
