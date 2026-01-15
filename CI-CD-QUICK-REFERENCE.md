# CI/CD Quick Reference

## Overview

This repository now has automated CI/CD workflows using GitHub Actions. The workflows automatically validate code quality and documentation when changes are pushed.

## Active Workflows

### 1. PowerShell CI (`powershell-ci.yml`)

**Purpose:** Automatically validates PowerShell scripts for quality and syntax errors.

**Triggers:**
- Push to `main` branch affecting `.ps1` files
- Pull requests to `main` branch affecting `.ps1` files

**What it checks:**
- ✅ PSScriptAnalyzer linting (errors only, warnings are informational)
- ✅ PowerShell syntax validation
- ✅ Script structure recommendations

**How to test locally:**
```powershell
# Install PSScriptAnalyzer
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser

# Run analysis on a script
Invoke-ScriptAnalyzer -Path .\your-script.ps1 -Settings PSGallery

# Run on all scripts
Get-ChildItem -Filter *.ps1 -Recurse | ForEach-Object {
    Invoke-ScriptAnalyzer -Path $_.FullName -Settings PSGallery
}
```

### 2. Documentation CI (`docs-ci.yml`)

**Purpose:** Automatically validates markdown documentation for quality and broken links.

**Triggers:**
- Push to `main` branch affecting `.md` files
- Pull requests to `main` branch affecting `.md` files

**What it checks:**
- ✅ Markdown linting (style and formatting)
- ✅ Broken link detection
- ✅ Required documentation presence
- ✅ README structure validation
- ✅ Spelling check (informational)

**How to test locally:**
```bash
# Install markdownlint
npm install -g markdownlint-cli

# Check markdown files
markdownlint '**/*.md' --ignore node_modules

# Install markdown-link-check
npm install -g markdown-link-check

# Check for broken links
markdown-link-check README.md
```

### 3. Auto-Merge (`auto-merge.yml`)

**Purpose:** Automatically merges pull requests when all checks pass.

**Triggers:**
- Pull request events (opened, synchronized, reopened)
- Pull request reviews submitted
- Check suite completed
- Status changes

**Requirements for auto-merge:**
- ✅ PR is not a draft
- ✅ PR is in mergeable state
- ✅ No changes requested in reviews
- ✅ All status checks pass
- ✅ All check runs pass

### 4. Enable Auto-Merge (`enable-auto-merge.yml`)

**Purpose:** Automatically enables auto-merge feature for new PRs.

**Triggers:**
- Pull request opened
- Pull request ready for review

## Viewing Workflow Results

1. Go to your repository on GitHub
2. Click the **Actions** tab
3. Select a workflow from the left sidebar
4. Click on a specific run to see details
5. View logs for each step

## Workflow Status Badges

Add badges to your README to show workflow status:

```markdown
![PowerShell CI](https://github.com/A6-9V/my-drive-projects/workflows/PowerShell%20CI/badge.svg)
![Documentation CI](https://github.com/A6-9V/my-drive-projects/workflows/Documentation%20CI/badge.svg)
```

## Common Issues and Solutions

### Issue: Workflow not running
**Solution:** 
- Check that workflow file is in `.github/workflows/`
- Verify trigger conditions match your changes
- Check repository Actions settings (Settings → Actions)

### Issue: PowerShell CI fails
**Solution:**
- Run PSScriptAnalyzer locally first
- Fix reported errors (warnings are informational)
- Check syntax with `powershell -NoProfile -SyntaxCheck your-script.ps1`

### Issue: Documentation CI fails
**Solution:**
- Run markdownlint locally
- Check for broken links
- Ensure required documentation files exist

### Issue: Auto-merge not working
**Solution:**
- Verify all checks have passed
- Check there are no changes requested in reviews
- Ensure PR is not a draft
- Check repository permissions

## Disabling Workflows

If you need to temporarily disable a workflow:

1. Go to repository **Settings**
2. Click **Actions** in the left sidebar
3. Select **General**
4. Choose workflow permissions as needed

Or rename the workflow file to add `.disabled` extension:
```bash
mv .github/workflows/powershell-ci.yml .github/workflows/powershell-ci.yml.disabled
```

## Best Practices

1. **Always run checks locally before pushing** to catch issues early
2. **Keep workflows fast** by only running on relevant file changes
3. **Monitor workflow runs** to catch failures quickly
4. **Update workflow dependencies** regularly
5. **Test workflow changes** on feature branches first

## Extending Workflows

You can add more workflows for:
- **Security scanning** (CodeQL, dependency checking)
- **Deployment** (auto-deploy to servers)
- **Release automation** (create releases on tag push)
- **Notification** (send alerts on failures)
- **Code coverage** (track test coverage)

See `CI-CD-BASICS.md` for detailed examples and tutorials.

## Workflow Maintenance

### Monthly Tasks
- [ ] Review workflow run history
- [ ] Update action versions to latest
- [ ] Check for deprecated actions
- [ ] Review and optimize workflow performance

### When Adding New Files
- [ ] Ensure PowerShell scripts follow PSScriptAnalyzer guidelines
- [ ] Run linting locally before committing
- [ ] Update documentation as needed
- [ ] Test on feature branch first

## Support

For questions or issues:
1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Review the detailed guide in `CI-CD-BASICS.md`
3. Open an issue in this repository
4. Check workflow logs for specific error messages

## Files Modified

This CI/CD implementation includes:
- `.github/workflows/powershell-ci.yml` - PowerShell validation
- `.github/workflows/docs-ci.yml` - Documentation validation
- `.github/workflows/auto-merge.yml` - Auto-merge (existing)
- `.github/workflows/enable-auto-merge.yml` - Enable auto-merge (existing)
- `CI-CD-BASICS.md` - Comprehensive CI/CD guide
- `CI-CD-QUICK-REFERENCE.md` - This quick reference
- `README.md` - Updated with CI/CD documentation links

---

**Last Updated:** 2026-01-02
