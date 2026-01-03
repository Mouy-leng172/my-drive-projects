# Update Repository References
# This script updates references to awesome-selfhosted in specified repositories

param(
    [switch]$DryRun = $false,
    [string]$TempDir = "$env:TEMP\repo-update-temp"
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

# Repositories to update
$reposToUpdate = @(
    "mouyleng/GenX_FX",
    "A6-9V/MQL5-Google-Onedrive"
)

# Reference mappings
$referenceReplacements = @{
    "awesome-selfhosted/awesome-selfhosted" = "A6-9V/awesome-selfhosted"
    "https://github.com/awesome-selfhosted/awesome-selfhosted" = "https://github.com/A6-9V/awesome-selfhosted"
}

Write-Info "========================================="
Write-Info "Update Repository References"
Write-Info "========================================="
Write-Info ""

if ($DryRun) {
    Write-Warning "DRY RUN MODE - No actual changes will be made"
    Write-Info ""
}

# Step 1: Check GitHub CLI
Write-Info "Step 1: Checking GitHub CLI authentication..."
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "GitHub CLI is authenticated"
    } else {
        Write-Error "GitHub CLI is not authenticated. Please run: gh auth login"
        exit 1
    }
} catch {
    Write-Error "Failed to check GitHub CLI: $_"
    exit 1
}

Write-Info ""

# Step 2: Create temp directory
Write-Info "Step 2: Setting up temporary directory..."
if (Test-Path $TempDir) {
    Write-Info "Cleaning existing temp directory..."
    Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
Write-Success "Temp directory created: $TempDir"
Write-Info ""

# Function to update references in a repository
function Update-RepositoryReferences {
    param(
        [string]$RepoName,
        [bool]$IsDryRun
    )
    
    Write-Info "----------------------------------------"
    Write-Info "Processing repository: $RepoName"
    Write-Info "----------------------------------------"
    
    $repoPath = Join-Path $TempDir ($RepoName.Split('/')[-1])
    
    try {
        # Check if repository exists
        Write-Info "Checking if repository exists..."
        $repoInfo = gh repo view $RepoName --json name 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Repository $RepoName not found or not accessible"
            return $false
        }
        Write-Success "Repository found: $RepoName"
        
        # Clone repository
        Write-Info "Cloning repository..."
        if (-not $IsDryRun) {
            Set-Location $TempDir
            gh repo clone $RepoName 2>&1 | Out-Null
            
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to clone repository: $RepoName"
                return $false
            }
            Write-Success "Repository cloned"
        } else {
            Write-Info "[DRY RUN] Would clone: $RepoName"
        }
        
        # Search for files containing references
        if (-not $IsDryRun) {
            Set-Location $repoPath
            
            Write-Info "Searching for references to update..."
            $filesWithReferences = @()
            
            # Search in common file types
            $fileTypes = @("*.md", "*.txt", "*.json", "*.yaml", "*.yml", "*.py", "*.js", "*.ts", "*.html", "*.css")
            
            foreach ($fileType in $fileTypes) {
                $files = Get-ChildItem -Path . -Filter $fileType -Recurse -File -ErrorAction SilentlyContinue
                foreach ($file in $files) {
                    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
                    if ($content) {
                        foreach ($oldRef in $referenceReplacements.Keys) {
                            if ($content -match [regex]::Escape($oldRef)) {
                                $filesWithReferences += @{
                                    Path = $file.FullName
                                    RelativePath = $file.FullName.Replace($repoPath, "").TrimStart('\', '/')
                                    OldReference = $oldRef
                                    NewReference = $referenceReplacements[$oldRef]
                                }
                            }
                        }
                    }
                }
            }
            
            if ($filesWithReferences.Count -eq 0) {
                Write-Info "No references found in repository"
                return $true
            }
            
            Write-Success "Found $($filesWithReferences.Count) file(s) with references to update"
            
            # Update references
            $updatedFiles = 0
            foreach ($fileInfo in $filesWithReferences) {
                Write-Info "Updating: $($fileInfo.RelativePath)"
                Write-Info "  Replacing: $($fileInfo.OldReference)"
                Write-Info "  With: $($fileInfo.NewReference)"
                
                try {
                    $content = Get-Content -Path $fileInfo.Path -Raw
                    $newContent = $content -replace [regex]::Escape($fileInfo.OldReference), $fileInfo.NewReference
                    $newContent | Set-Content -Path $fileInfo.Path -NoNewline
                    $updatedFiles++
                    Write-Success "  Updated successfully"
                } catch {
                    Write-Error "  Failed to update: $_"
                }
            }
            
            Write-Success "Updated $updatedFiles file(s)"
            
            # Check if there are any changes
            $gitStatus = git status --porcelain 2>&1
            if ($gitStatus) {
                Write-Info "Changes detected. Creating commit..."
                
                # Configure git if needed
                $gitUserName = git config user.name 2>&1
                if (-not $gitUserName) {
                    # Try to get authenticated GitHub user
                    try {
                        $ghUser = gh api user --jq .login 2>&1
                        if ($LASTEXITCODE -eq 0 -and $ghUser) {
                            git config user.name $ghUser
                            git config user.email "$ghUser@users.noreply.github.com"
                        } else {
                            # Fallback to generic values
                            git config user.name "GitHub Automation"
                            git config user.email "automation@github.com"
                        }
                    } catch {
                        git config user.name "GitHub Automation"
                        git config user.email "automation@github.com"
                    }
                }
                
                # Create a new branch
                $branchName = "update-awesome-selfhosted-references-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                git checkout -b $branchName 2>&1 | Out-Null
                
                # Commit changes
                git add . 2>&1 | Out-Null
                git commit -m "Update awesome-selfhosted references to A6-9V fork" 2>&1 | Out-Null
                Write-Success "Changes committed to branch: $branchName"
                
                # Push changes
                Write-Info "Pushing changes..."
                git push -u origin $branchName 2>&1 | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Changes pushed successfully"
                    
                    # Get default branch name
                    $defaultBranch = gh repo view $RepoName --json defaultBranchRef --jq .defaultBranchRef.name 2>&1
                    if ($LASTEXITCODE -ne 0 -or -not $defaultBranch) {
                        $defaultBranch = "main"
                        Write-Warning "Could not determine default branch, using: $defaultBranch"
                    }
                    
                    # Create pull request
                    Write-Info "Creating pull request against branch: $defaultBranch"
                    $prUrl = gh pr create --title "Update awesome-selfhosted references to A6-9V fork" --body "This PR updates all references from awesome-selfhosted/awesome-selfhosted to A6-9V/awesome-selfhosted." --base $defaultBranch 2>&1
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Success "Pull request created: $prUrl"
                    } else {
                        Write-Warning "Could not create pull request automatically. Please create it manually."
                        Write-Info "Branch: $branchName"
                    }
                } else {
                    Write-Error "Failed to push changes"
                    return $false
                }
            } else {
                Write-Info "No changes needed in this repository"
            }
            
            return $true
        } else {
            Write-Info "[DRY RUN] Would search for and update references"
            Write-Info "[DRY RUN] Would create a PR with changes"
        }
        
        return $true
        
    } catch {
        Write-Error "Error processing repository: $_"
        return $false
    } finally {
        # Return to temp directory
        Set-Location $TempDir
    }
}

# Step 3: Process each repository
Write-Info "Step 3: Processing repositories..."
Write-Info ""

$results = @{}

foreach ($repo in $reposToUpdate) {
    $success = Update-RepositoryReferences -RepoName $repo -IsDryRun $DryRun
    $results[$repo] = $success
    Write-Info ""
}

# Step 4: Generate summary
Write-Info "========================================="
Write-Success "Update Process Complete!"
Write-Info "========================================="
Write-Info ""

Write-Info "Summary:"
foreach ($repo in $results.Keys) {
    $status = if ($results[$repo]) { "✅ Success" } else { "❌ Failed" }
    Write-Info "  $repo : $status"
}

Write-Info ""

# Create summary file
$summaryFile = "update-references-summary-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
$summary = @"
# Update References Summary

**Date**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Mode**: $(if ($DryRun) { "Dry Run" } else { "Live" })

## Repositories Processed

"@

foreach ($repo in $results.Keys) {
    $status = if ($results[$repo]) { "✅ Success" } else { "❌ Failed" }
    $summary += "- **$repo**: $status`n"
}

$summary += @"

## Reference Replacements

"@

foreach ($oldRef in $referenceReplacements.Keys) {
    $newRef = $referenceReplacements[$oldRef]
    $summary += "- ``$oldRef`` -> ``$newRef```n"
}

$summary += @"

## Next Steps

1. Review and merge the pull requests created in each repository
2. Verify that all references are correctly updated
3. Test functionality to ensure nothing is broken
4. Close this issue once all updates are complete

---
*Generated by update-repo-references.ps1*
"@

$summary | Out-File -FilePath $summaryFile -Encoding UTF8
Write-Success "Summary saved to: $summaryFile"
Write-Info ""

# Cleanup
Write-Info "Cleaning up temporary directory..."
if (-not $DryRun) {
    Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Success "Cleanup complete"
}

Write-Info ""
Write-Info "All operations complete!"
