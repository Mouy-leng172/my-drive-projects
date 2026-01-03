# Quick Start: Fork awesome-selfhosted

This task requires forking the `awesome-selfhosted/awesome-selfhosted` repository to the A6-9V organization and updating references in related repositories.

## ⚡ Quick Execution

### Option 1: One-Click Execution (Windows)

Double-click: **`FORK-AWESOME-SELFHOSTED.bat`**

This will automatically:
1. Fork the repository
2. Update all references
3. Create pull requests

### Option 2: Manual Step-by-Step

#### Step 1: Fork Repository

```powershell
# Preview first (recommended)
.\fork-awesome-selfhosted.ps1 -DryRun

# Execute the fork
.\fork-awesome-selfhosted.ps1
```

#### Step 2: Update References

```powershell
# Preview first (recommended)
.\update-repo-references.ps1 -DryRun

# Execute the updates
.\update-repo-references.ps1
```

## 📋 Prerequisites Checklist

Before running, ensure you have:

- [ ] **GitHub CLI installed**: `winget install --id GitHub.cli`
- [ ] **GitHub CLI authenticated**: `gh auth login`
- [ ] **Permissions in A6-9V organization**: Admin or Owner role
- [ ] **Access to target repositories**: 
  - [ ] mouyleng/GenX_FX
  - [ ] A6-9V/MQL5-Google-Onedrive

## ✅ What Will Happen

### Phase 1: Fork Repository
1. Script checks GitHub CLI authentication
2. Verifies source repository exists
3. Creates fork: `A6-9V/awesome-selfhosted`
4. Generates summary report

**Result**: New repository at https://github.com/A6-9V/awesome-selfhosted

### Phase 2: Update References
1. Clones mouyleng/GenX_FX and A6-9V/MQL5-Google-Onedrive
2. Searches for references to `awesome-selfhosted/awesome-selfhosted`
3. Replaces with `A6-9V/awesome-selfhosted`
4. Creates new branch with changes
5. Pushes branch
6. Creates pull request

**Result**: PRs in both repositories with updated references

## 📝 Expected Output

After successful execution:

1. **Fork Summary**: `fork-summary-YYYYMMDD-HHMMSS.md`
   - Details about the fork creation
   
2. **Update Summary**: `update-references-summary-YYYYMMDD-HHMMSS.md`
   - Lists files updated in each repository
   - PR links for review

3. **Pull Requests**:
   - PR in mouyleng/GenX_FX (if references found)
   - PR in A6-9V/MQL5-Google-Onedrive (if references found)

## 🔍 Verification

After running the scripts:

1. **Check Fork**:
   ```powershell
   gh repo view A6-9V/awesome-selfhosted
   ```

2. **Check Pull Requests**:
   ```powershell
   gh pr list --repo mouyleng/GenX_FX
   gh pr list --repo A6-9V/MQL5-Google-Onedrive
   ```

3. **Review Changes**:
   - Visit each PR link
   - Review file changes
   - Merge if everything looks correct

## ⚠️ Troubleshooting

### "GitHub CLI is not authenticated"
```powershell
gh auth login
```

### "Permission denied"
- Verify you have admin access to A6-9V organization
- Check: https://github.com/orgs/A6-9V/people

### "Fork already exists"
- The script will offer to sync instead
- Or manually sync: `gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted`

### "No references found"
- This is okay! It means the repositories don't reference awesome-selfhosted yet
- The fork is still created and available for future use

## 📚 Full Documentation

For complete details, see: **`FORK-AWESOME-SELFHOSTED-GUIDE.md`**

## 🚀 Ready to Start?

1. Ensure prerequisites are met
2. Run: `.\FORK-AWESOME-SELFHOSTED.bat`
3. Wait for completion (5-15 minutes)
4. Review generated summary reports
5. Merge pull requests

---

**Need Help?** Review the full guide in FORK-AWESOME-SELFHOSTED-GUIDE.md
