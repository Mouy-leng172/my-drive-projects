# Fork awesome-selfhosted and Update References

This guide provides complete instructions and automation scripts for forking the `awesome-selfhosted/awesome-selfhosted` repository to the A6-9V organization and updating all references in related repositories.

## 📋 Overview

### What This Does

1. **Fork Repository**: Forks `awesome-selfhosted/awesome-selfhosted` to the `A6-9V` organization
2. **Update References**: Updates all references in:
   - `mouyleng/GenX_FX`
   - `A6-9V/MQL5-Google-Onedrive`

### Why Fork?

Forking allows the A6-9V organization to:
- Maintain a controlled version of awesome-selfhosted
- Track custom changes or additions
- Ensure availability even if the upstream repository changes
- Contribute back to the original project when desired

## 🚀 Quick Start

### Prerequisites

1. **GitHub CLI**: Must be installed and authenticated
   ```powershell
   # Install GitHub CLI
   winget install --id GitHub.cli
   
   # Authenticate
   gh auth login
   ```

2. **Git**: Must be installed
3. **Permissions**: You must have permission to:
   - Create repositories in the A6-9V organization
   - Push to mouyleng/GenX_FX (if updating)
   - Push to A6-9V/MQL5-Google-Onedrive

### Step 1: Fork Repository

Run the fork script:

```powershell
# Preview what will happen (recommended first)
.\fork-awesome-selfhosted.ps1 -DryRun

# Execute the fork
.\fork-awesome-selfhosted.ps1
```

This will:
- ✅ Verify GitHub CLI is authenticated
- ✅ Check that the source repository exists
- ✅ Fork the repository to A6-9V organization
- ✅ Generate a summary report

**Result**: New repository at `https://github.com/A6-9V/awesome-selfhosted`

### Step 2: Update References

Run the update script:

```powershell
# Preview what will happen (recommended first)
.\update-repo-references.ps1 -DryRun

# Execute the updates
.\update-repo-references.ps1
```

This will:
- ✅ Clone each target repository
- ✅ Search for references to `awesome-selfhosted/awesome-selfhosted`
- ✅ Replace with `A6-9V/awesome-selfhosted`
- ✅ Create a new branch with changes
- ✅ Push the branch
- ✅ Create a pull request
- ✅ Generate a summary report

## 📁 Files Included

### 1. `fork-awesome-selfhosted.ps1`

Main script to fork the awesome-selfhosted repository.

**Features:**
- Validates GitHub CLI authentication
- Checks if source repository exists
- Checks if fork already exists
- Creates fork in A6-9V organization
- Provides sync option for existing forks
- Generates summary report

**Usage:**
```powershell
# Dry run (preview only)
.\fork-awesome-selfhosted.ps1 -DryRun

# Execute fork
.\fork-awesome-selfhosted.ps1
```

### 2. `update-repo-references.ps1`

Script to update references in target repositories.

**Features:**
- Clones target repositories
- Searches multiple file types for references
- Replaces old references with new ones
- Creates branches and commits
- Opens pull requests automatically
- Generates summary report

**Usage:**
```powershell
# Dry run (preview only)
.\update-repo-references.ps1 -DryRun

# Execute updates
.\update-repo-references.ps1

# Use custom temp directory
.\update-repo-references.ps1 -TempDir "C:\Temp\repo-updates"
```

**Supported File Types:**
- Markdown (*.md)
- Text files (*.txt)
- JSON (*.json)
- YAML (*.yaml, *.yml)
- Python (*.py)
- JavaScript/TypeScript (*.js, *.ts)
- HTML/CSS (*.html, *.css)

### 3. `FORK-AWESOME-SELFHOSTED-GUIDE.md`

This comprehensive guide document.

## 🔍 Detailed Process

### Phase 1: Repository Fork

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  awesome-selfhosted/awesome-selfhosted                  │
│  (Original Repository)                                  │
│                                                         │
└──────────────────┬──────────────────────────────────────┘
                   │
                   │ Fork using GitHub API
                   │ (gh repo fork)
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  A6-9V/awesome-selfhosted                              │
│  (Forked Repository)                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Phase 2: Reference Updates

```
┌──────────────────────┐       ┌──────────────────────┐
│                      │       │                      │
│  mouyleng/GenX_FX    │       │  A6-9V/MQL5-Google- │
│                      │       │  Onedrive            │
└──────────┬───────────┘       └──────────┬───────────┘
           │                              │
           │ Clone & Search               │
           │                              │
           ▼                              ▼
┌──────────────────────────────────────────────────────┐
│  Find: awesome-selfhosted/awesome-selfhosted         │
│  Replace: A6-9V/awesome-selfhosted                   │
└──────────────────────────────────────────────────────┘
           │                              │
           │ Create PR                    │
           │                              │
           ▼                              ▼
┌──────────────────────┐       ┌──────────────────────┐
│  PR: Update refs     │       │  PR: Update refs     │
│  in GenX_FX          │       │  in MQL5-Google-...  │
└──────────────────────┘       └──────────────────────┘
```

## 📊 Reference Replacement Table

| Old Reference | New Reference |
|---------------|---------------|
| `awesome-selfhosted/awesome-selfhosted` | `A6-9V/awesome-selfhosted` |
| `https://github.com/awesome-selfhosted/awesome-selfhosted` | `https://github.com/A6-9V/awesome-selfhosted` |

## 🔄 Keeping Fork Updated

After forking, you should periodically sync with the upstream repository:

### Manual Sync

```powershell
# Sync fork with upstream
gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
```

### Automated Sync

You can set up a GitHub Actions workflow to automatically sync:

```yaml
name: Sync Fork
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Sync fork
        run: |
          gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 🛠️ Troubleshooting

### Issue: "GitHub CLI is not authenticated"

**Solution:**
```powershell
gh auth login
```

Follow the prompts to authenticate.

### Issue: "Permission denied to create repository"

**Solution:**
Ensure you have admin or owner permissions in the A6-9V organization.

1. Go to: https://github.com/orgs/A6-9V/people
2. Verify your role
3. Contact organization owner if needed

### Issue: "Fork already exists"

**Solution:**
The script will detect this and offer to sync instead:
```powershell
gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
```

### Issue: "No references found"

**Possible causes:**
1. The repositories might not have any references to awesome-selfhosted
2. The references might be in file types not searched

**Solution:**
Check manually or add more file types to the search in `update-repo-references.ps1`.

### Issue: "Failed to create pull request"

**Possible causes:**
1. No default branch named "main" (might be "master")
2. No changes detected
3. PR already exists for this branch

**Solution:**
```powershell
# Check default branch
gh repo view mouyleng/GenX_FX --json defaultBranchRef

# Manually create PR if needed
gh pr create --repo mouyleng/GenX_FX --base main --head update-awesome-selfhosted-references-YYYYMMDD-HHMMSS
```

## 📝 Manual Steps (If Scripts Fail)

### Manual Fork

1. Visit: https://github.com/awesome-selfhosted/awesome-selfhosted
2. Click "Fork" button
3. Select "A6-9V" as the owner
4. Click "Create fork"

### Manual Reference Update

For each repository:

1. Clone the repository:
   ```bash
   gh repo clone mouyleng/GenX_FX
   cd GenX_FX
   ```

2. Create a new branch:
   ```bash
   git checkout -b update-awesome-selfhosted-refs
   ```

3. Find and replace references:
   ```bash
   # On Linux/Mac
   find . -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -exec sed -i 's/awesome-selfhosted\/awesome-selfhosted/A6-9V\/awesome-selfhosted/g' {} +
   
   # On Windows (PowerShell)
   Get-ChildItem -Recurse -Include *.md,*.txt,*.json | ForEach-Object {
       (Get-Content $_.FullName) -replace 'awesome-selfhosted/awesome-selfhosted', 'A6-9V/awesome-selfhosted' | Set-Content $_.FullName
   }
   ```

4. Commit and push:
   ```bash
   git add .
   git commit -m "Update awesome-selfhosted references to A6-9V fork"
   git push -u origin update-awesome-selfhosted-refs
   ```

5. Create pull request:
   ```bash
   gh pr create --title "Update awesome-selfhosted references" --body "Updates references to use A6-9V fork"
   ```

## ✅ Verification Checklist

After running the scripts:

- [ ] Fork exists at `https://github.com/A6-9V/awesome-selfhosted`
- [ ] Fork is public or has appropriate visibility
- [ ] Pull request created in `mouyleng/GenX_FX` (if references found)
- [ ] Pull request created in `A6-9V/MQL5-Google-Onedrive` (if references found)
- [ ] Summary reports generated:
  - [ ] `fork-summary-YYYYMMDD-HHMMSS.md`
  - [ ] `update-references-summary-YYYYMMDD-HHMMSS.md`
- [ ] All pull requests reviewed
- [ ] All pull requests merged or closed appropriately

## 📈 Expected Outcomes

### Successful Fork

```
✅ Fork created: A6-9V/awesome-selfhosted
✅ Fork is up-to-date with upstream
✅ Fork is accessible to organization members
```

### Successful Updates

```
✅ mouyleng/GenX_FX: PR #XX opened
✅ A6-9V/MQL5-Google-Onedrive: PR #XX opened
✅ All references updated
✅ No broken links
```

## 🔒 Security Considerations

1. **Credentials**: Scripts use GitHub CLI authentication (OAuth)
2. **Permissions**: Only users with appropriate org permissions can fork
3. **Branches**: Changes are made on new branches, not directly on main
4. **Review**: Pull requests allow for code review before merging
5. **Audit**: All actions are logged in summary reports

## 📚 Additional Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Forking a Repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- [Syncing a Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)
- [awesome-selfhosted Project](https://github.com/awesome-selfhosted/awesome-selfhosted)

## 🤝 Contributing

If you find issues with these scripts or have improvements:

1. Create an issue in the repository
2. Submit a pull request with fixes
3. Update documentation as needed

## 📅 Maintenance

### Regular Tasks

- **Weekly**: Sync fork with upstream
- **Monthly**: Review dependencies and updates
- **Quarterly**: Audit references in all repositories

### Sync Command

```powershell
gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
```

## 📞 Support

For questions or issues:

1. Check this guide's troubleshooting section
2. Review generated summary reports
3. Check GitHub CLI logs
4. Contact A6-9V organization administrators

---

**Last Updated**: $(Get-Date -Format 'yyyy-MM-dd')
**Version**: 1.0.0
**Author**: GitHub Copilot
**Organization**: A6-9V
