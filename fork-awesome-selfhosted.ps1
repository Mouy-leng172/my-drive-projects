# Fork awesome-selfhosted Repository to A6-9V Organization
# This script automates the forking process using GitHub CLI

param(
    [switch]$DryRun = $false,
    [switch]$AutoSync = $false
)

$ErrorActionPreference = "Continue"

# Color functions
function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Main script
Write-Info "========================================="
Write-Info "Fork awesome-selfhosted Repository"
Write-Info "========================================="
Write-Info ""

if ($DryRun) {
    Write-Warning "DRY RUN MODE - No actual changes will be made"
    Write-Info ""
}

# Step 1: Check if gh CLI is installed and authenticated
Write-Info "Step 1: Checking GitHub CLI..."
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "GitHub CLI is installed"
        
        # Check authentication
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "GitHub CLI is authenticated"
        } else {
            Write-Error "GitHub CLI is not authenticated"
            Write-Info "Please run: gh auth login"
            exit 1
        }
    } else {
        Write-Error "GitHub CLI is not installed"
        Write-Info "Please install from: https://cli.github.com/"
        exit 1
    }
} catch {
    Write-Error "Failed to check GitHub CLI: $_"
    exit 1
}

Write-Info ""

# Step 2: Check if the source repository exists
Write-Info "Step 2: Checking source repository..."
try {
    $repoInfo = gh repo view awesome-selfhosted/awesome-selfhosted --json name,description,url 2>&1
    if ($LASTEXITCODE -eq 0) {
        $repo = $repoInfo | ConvertFrom-Json
        Write-Success "Source repository found: $($repo.name)"
        Write-Info "Description: $($repo.description)"
        Write-Info "URL: $($repo.url)"
    } else {
        Write-Error "Source repository not found"
        exit 1
    }
} catch {
    Write-Error "Failed to check source repository: $_"
    exit 1
}

Write-Info ""

# Step 3: Check if fork already exists
Write-Info "Step 3: Checking if fork already exists in A6-9V organization..."
try {
    $existingFork = gh repo view A6-9V/awesome-selfhosted --json name 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Warning "Fork already exists in A6-9V organization"
        Write-Info "Repository: https://github.com/A6-9V/awesome-selfhosted"
        Write-Info "To update the fork, use: gh repo sync A6-9V/awesome-selfhosted"
        
        # Handle sync based on parameters
        if (-not $DryRun) {
            if ($AutoSync) {
                Write-Info "Auto-sync enabled. Syncing fork with upstream..."
                gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Fork synced successfully"
                } else {
                    Write-Error "Failed to sync fork"
                }
            } else {
                $response = Read-Host "Do you want to sync the existing fork? (y/n)"
                if ($response -eq 'y' -or $response -eq 'Y') {
                    Write-Info "Syncing fork with upstream..."
                    gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
                    if ($LASTEXITCODE -eq 0) {
                        Write-Success "Fork synced successfully"
                    } else {
                        Write-Error "Failed to sync fork"
                    }
                }
            }
        }
        exit 0
    }
} catch {
    Write-Info "Fork does not exist yet, proceeding with fork creation..."
}

Write-Info ""

# Step 4: Fork the repository
Write-Info "Step 4: Forking repository to A6-9V organization..."
if ($DryRun) {
    Write-Info "[DRY RUN] Would execute: gh repo fork awesome-selfhosted/awesome-selfhosted --org A6-9V --clone=false"
    Write-Success "[DRY RUN] Fork would be created successfully"
} else {
    try {
        Write-Info "Executing: gh repo fork awesome-selfhosted/awesome-selfhosted --org A6-9V --clone=false"
        gh repo fork awesome-selfhosted/awesome-selfhosted --org A6-9V --clone=false
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Repository forked successfully to A6-9V/awesome-selfhosted"
            Write-Info "Fork URL: https://github.com/A6-9V/awesome-selfhosted"
        } else {
            Write-Error "Failed to fork repository"
            exit 1
        }
    } catch {
        Write-Error "Failed to fork repository: $_"
        exit 1
    }
}

Write-Info ""

# Step 5: Summary
Write-Info "========================================="
Write-Success "Fork Process Complete!"
Write-Info "========================================="
Write-Info ""
Write-Info "Next Steps:"
Write-Info "1. Visit: https://github.com/A6-9V/awesome-selfhosted"
Write-Info "2. Review the forked repository"
Write-Info "3. Update references in mouyleng/GenX_FX"
Write-Info "4. Update references in A6-9V/MQL5-Google-Onedrive"
Write-Info ""
Write-Info "To update references, run:"
Write-Info "  .\update-repo-references.ps1"
Write-Info ""

# Create a summary file
$summaryFile = "fork-summary-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
$summary = @"
# Fork Summary

**Date**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Source Repository**: awesome-selfhosted/awesome-selfhosted
**Target Organization**: A6-9V
**Fork URL**: https://github.com/A6-9V/awesome-selfhosted

## Actions Completed

- ✅ Verified GitHub CLI installation and authentication
- ✅ Verified source repository exists
- ✅ Forked repository to A6-9V organization

## Next Steps

1. **Review Fork**: Visit https://github.com/A6-9V/awesome-selfhosted
2. **Update mouyleng/GenX_FX**: Update any references to awesome-selfhosted
3. **Update A6-9V/MQL5-Google-Onedrive**: Update any references to awesome-selfhosted
4. **Sync Fork**: Periodically sync with upstream using:
   ```powershell
   gh repo sync A6-9V/awesome-selfhosted --source awesome-selfhosted/awesome-selfhosted
   ```

## Repositories to Update

- mouyleng/GenX_FX
- A6-9V/MQL5-Google-Onedrive

Use the `update-repo-references.ps1` script to automate reference updates.

---
*Generated by fork-awesome-selfhosted.ps1*
"@

$summary | Out-File -FilePath $summaryFile -Encoding UTF8
Write-Success "Summary saved to: $summaryFile"
