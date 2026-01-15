# Setup Forks for my-drive-projects
# This script helps set up the forked repositories

$ErrorActionPreference = "Continue"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  My Drive Projects - Fork Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Configuration
$repos = @(
    @{
        Name = "ZOLO-A6-9VxNUNA"
        Url = "https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git"
        Owner = "Mouy-leng"
        RepoName = "ZOLO-A6-9VxNUNA-"
        Description = "Trading system website and documentation"
    },
    @{
        Name = "MQL5-Google-Onedrive"
        Url = "https://github.com/A6-9V/MQL5-Google-Onedrive.git"
        Owner = "A6-9V"
        RepoName = "MQL5-Google-Onedrive"
        Description = "MQL5 integration with Google Drive and OneDrive"
    }
)

$currentDir = $PSScriptRoot
$myDriveProjectsDir = $currentDir

# Check if Git is installed
Write-Host "[INFO] Checking Git installation..." -ForegroundColor Yellow
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-Host "[ERROR] Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Git is installed" -ForegroundColor Green

# Check if GitHub CLI is installed
Write-Host "`n[INFO] Checking GitHub CLI installation..." -ForegroundColor Yellow
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
$useGhCli = $false
if ($ghInstalled) {
    Write-Host "[OK] GitHub CLI is installed" -ForegroundColor Green
    
    # Check if authenticated
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] GitHub CLI is authenticated" -ForegroundColor Green
        $useGhCli = $true
    } else {
        Write-Host "[WARNING] GitHub CLI is not authenticated" -ForegroundColor Yellow
        Write-Host "[INFO] Run 'gh auth login' to authenticate" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] GitHub CLI not installed - will use git clone method" -ForegroundColor Yellow
}

# Function to setup a repository
function Setup-Repository {
    param(
        [hashtable]$Repo,
        [bool]$UseGitHubCli
    )
    
    Write-Host "`n----------------------------------------" -ForegroundColor Cyan
    Write-Host "Setting up: $($Repo.Name)" -ForegroundColor Cyan
    Write-Host "Description: $($Repo.Description)" -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    
    $targetDir = Join-Path $myDriveProjectsDir $Repo.Name
    
    # Check if directory already exists
    if (Test-Path $targetDir) {
        Write-Host "[INFO] Repository already exists at: $targetDir" -ForegroundColor Yellow
        Write-Host "[INFO] Updating repository..." -ForegroundColor Yellow
        
        try {
            Set-Location $targetDir
            git pull origin main 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Repository updated successfully" -ForegroundColor Green
            } else {
                # Try 'master' branch if 'main' doesn't exist
                git pull origin master 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "[OK] Repository updated successfully" -ForegroundColor Green
                } else {
                    Write-Host "[WARNING] Could not update repository" -ForegroundColor Yellow
                }
            }
        } catch {
            Write-Host "[WARNING] Error updating repository: $_" -ForegroundColor Yellow
        }
        return
    }
    
    # Try to fork and clone using GitHub CLI
    if ($UseGitHubCli) {
        Write-Host "[INFO] Attempting to fork using GitHub CLI..." -ForegroundColor Yellow
        try {
            Set-Location $myDriveProjectsDir
            $forkCmd = "gh repo fork $($Repo.Owner)/$($Repo.RepoName) --clone=true --remote=true"
            Write-Host "[INFO] Running: $forkCmd" -ForegroundColor Gray
            Invoke-Expression $forkCmd
            
            if ($LASTEXITCODE -eq 0) {
                # Rename directory if needed
                $clonedDir = Join-Path $myDriveProjectsDir $Repo.RepoName
                if ((Test-Path $clonedDir) -and ($clonedDir -ne $targetDir)) {
                    Move-Item -Path $clonedDir -Destination $targetDir -Force
                }
                Write-Host "[OK] Repository forked and cloned successfully" -ForegroundColor Green
                return
            }
        } catch {
            Write-Host "[WARNING] GitHub CLI fork failed: $_" -ForegroundColor Yellow
        }
    }
    
    # Fallback to git clone
    Write-Host "[INFO] Attempting to clone repository..." -ForegroundColor Yellow
    try {
        Set-Location $myDriveProjectsDir
        git clone $Repo.Url $targetDir 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Repository cloned successfully" -ForegroundColor Green
            
            # Set up upstream remote
            Set-Location $targetDir
            git remote add upstream $Repo.Url 2>&1 | Out-Null
            Write-Host "[OK] Upstream remote configured" -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Failed to clone repository" -ForegroundColor Red
            Write-Host "[INFO] You may need to authenticate or have access to this repository" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Error cloning repository: $_" -ForegroundColor Red
    }
}

# Main setup process
Write-Host "`n[INFO] Starting fork setup process..." -ForegroundColor Yellow
Write-Host "[INFO] Target directory: $myDriveProjectsDir" -ForegroundColor Gray

foreach ($repo in $repos) {
    Setup-Repository -Repo $repo -UseGitHubCli $useGhCli
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Setup Summary" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

foreach ($repo in $repos) {
    $targetDir = Join-Path $myDriveProjectsDir $repo.Name
    if (Test-Path $targetDir) {
        Write-Host "[OK] $($repo.Name) - Ready" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] $($repo.Name) - Not set up" -ForegroundColor Red
    }
}

Write-Host "`n[INFO] Fork setup process complete!" -ForegroundColor Green
Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. If authentication failed, set up GitHub credentials" -ForegroundColor Gray
Write-Host "2. Run 'gh auth login' for GitHub CLI authentication" -ForegroundColor Gray
Write-Host "3. Or configure Git credentials with Personal Access Token" -ForegroundColor Gray
Write-Host "4. Check README.md in my-drive-projects/ for more details`n" -ForegroundColor Gray

# Return to original directory
Set-Location $PSScriptRoot
