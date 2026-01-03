#Requires -Version 5.1
<#
.SYNOPSIS
    Setup MQL5 Forge Remote for Git Repositories
.DESCRIPTION
    Adds or updates the MQL5 Forge repository (https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git) 
    as a remote named 'mql5-forge' to git repositories.
    
    This script can operate on:
    - Current directory (default)
    - All repositories found on all drives (with -AllDrives switch)
    - Specific repository path (with -RepoPath parameter)
.PARAMETER RepoPath
    Path to a specific git repository to configure (optional)
.PARAMETER AllDrives
    Switch to configure all git repositories found on all drives
.PARAMETER RemoteName
    Name for the MQL5 Forge remote (default: 'mql5-forge')
.EXAMPLE
    .\setup-mql5-forge-remote.ps1
    # Adds mql5-forge remote to current repository
.EXAMPLE
    .\setup-mql5-forge-remote.ps1 -AllDrives
    # Adds mql5-forge remote to all repositories on all drives
.EXAMPLE
    .\setup-mql5-forge-remote.ps1 -RepoPath "C:\Users\USER\OneDrive"
    # Adds mql5-forge remote to specified repository
#>

param(
    [string]$RepoPath = "",
    [switch]$AllDrives = $false,
    [string]$RemoteName = "mql5-forge"
)

$ErrorActionPreference = "Continue"

# MQL5 Forge repository URL
$mql5ForgeUrl = "https://forge.mql5.io/LengKundee/A6-9V_VL6-N9.git"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MQL5 Forge Remote Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Remote Name: $RemoteName" -ForegroundColor Cyan
Write-Host "Remote URL: $mql5ForgeUrl" -ForegroundColor Cyan
Write-Host ""

# Function to setup MQL5 Forge remote for a single repository
function Setup-MQL5ForgeRemote {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    try {
        if (-not (Test-Path (Join-Path $Path ".git"))) {
            Write-Host "  [SKIP] Not a git repository: $Path" -ForegroundColor Yellow
            return $false
        }
        
        Push-Location $Path
        
        Write-Host "[INFO] Processing: $Path" -ForegroundColor Cyan
        
        # Check if remote already exists
        $existingRemotes = git remote 2>&1
        
        if ($existingRemotes -contains $RemoteName) {
            # Update existing remote URL
            $currentUrl = git remote get-url $RemoteName 2>&1
            
            if ($currentUrl -eq $mql5ForgeUrl) {
                Write-Host "  [OK] Remote '$RemoteName' already configured correctly" -ForegroundColor Green
                Pop-Location
                return $true
            } else {
                Write-Host "  [INFO] Updating remote '$RemoteName' URL..." -ForegroundColor Yellow
                git remote set-url $RemoteName $mql5ForgeUrl 2>&1 | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  [OK] Remote '$RemoteName' URL updated successfully" -ForegroundColor Green
                    Pop-Location
                    return $true
                } else {
                    Write-Host "  [ERROR] Failed to update remote URL" -ForegroundColor Red
                    Pop-Location
                    return $false
                }
            }
        } else {
            # Add new remote
            Write-Host "  [INFO] Adding remote '$RemoteName'..." -ForegroundColor Yellow
            git remote add $RemoteName $mql5ForgeUrl 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [OK] Remote '$RemoteName' added successfully" -ForegroundColor Green
                
                # Verify the remote was added
                $verifyUrl = git remote get-url $RemoteName 2>&1
                Write-Host "  [VERIFY] Remote URL: $verifyUrl" -ForegroundColor Gray
                
                return $true
            } else {
                Write-Host "  [ERROR] Failed to add remote" -ForegroundColor Red
                return $false
            }
        }
    } catch {
        Write-Host "  [ERROR] Exception: $_" -ForegroundColor Red
        return $false
    } finally {
        Pop-Location
    }
}

# Function to find all git repositories on all drives
function Find-AllGitRepositories {
    Write-Host "[INFO] Scanning all drives for git repositories..." -ForegroundColor Yellow
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[A-Z]$' }
    Write-Host "  Found $($drives.Count) drive(s): $($drives.Name -join ', ')" -ForegroundColor Cyan
    Write-Host ""
    
    $repositories = @()
    
    # Check current directory
    $currentDir = Get-Location
    if (Test-Path (Join-Path $currentDir ".git")) {
        $repositories += $currentDir.Path
        Write-Host "  [FOUND] Current directory: $currentDir" -ForegroundColor Green
    }
    
    foreach ($drive in $drives) {
        $drivePath = $drive.Root
        Write-Host "  Scanning $drivePath..." -ForegroundColor Gray
        
        # Check drive root
        if (Test-Path (Join-Path $drivePath ".git")) {
            if ($drivePath -notin $repositories) {
                $repositories += $drivePath
                Write-Host "    [FOUND] $drivePath" -ForegroundColor Green
            }
        }
        
        # Search common locations
        $commonPaths = @(
            "$drivePath\OneDrive",
            "$drivePath\Documents",
            "$drivePath\Projects",
            "$drivePath\.vscode",
            "$drivePath\Users\$env:USERNAME\OneDrive",
            "$drivePath\Users\$env:USERNAME\Documents"
        )
        
        foreach ($commonPath in $commonPaths) {
            if (Test-Path $commonPath) {
                try {
                    # Check the path itself
                    if (Test-Path (Join-Path $commonPath ".git")) {
                        if ($commonPath -notin $repositories) {
                            $repositories += $commonPath
                            Write-Host "    [FOUND] $commonPath" -ForegroundColor Green
                        }
                    }
                    
                    # Check subdirectories (limited depth)
                    $gitDirs = Get-ChildItem -Path $commonPath -Directory -Filter ".git" -Recurse -Depth 1 -ErrorAction SilentlyContinue
                    foreach ($gitDir in $gitDirs) {
                        $repoPath = $gitDir.Parent.FullName
                        if ($repoPath -notin $repositories) {
                            $repositories += $repoPath
                            Write-Host "    [FOUND] $repoPath" -ForegroundColor Green
                        }
                    }
                } catch {
                    # Skip if can't access
                }
            }
        }
    }
    
    Write-Host ""
    Write-Host "  [OK] Found $($repositories.Count) git repository(ies)" -ForegroundColor Green
    Write-Host ""
    
    return $repositories
}

# Main execution logic
if ($AllDrives) {
    # Setup remote for all repositories on all drives
    $repositories = Find-AllGitRepositories
    
    if ($repositories.Count -eq 0) {
        Write-Host "[ERROR] No git repositories found" -ForegroundColor Red
        exit 1
    }
    
    $successCount = 0
    $failureCount = 0
    
    foreach ($repo in $repositories) {
        $result = Setup-MQL5ForgeRemote -Path $repo
        if ($result) {
            $successCount++
        } else {
            $failureCount++
        }
        Write-Host ""
    }
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Total Repositories: $($repositories.Count)" -ForegroundColor Cyan
    Write-Host "  ✅ Successfully Configured: $successCount" -ForegroundColor Green
    Write-Host "  ❌ Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })
    Write-Host ""
    
} elseif ($RepoPath) {
    # Setup remote for specific repository
    if (-not (Test-Path $RepoPath)) {
        Write-Host "[ERROR] Repository path not found: $RepoPath" -ForegroundColor Red
        exit 1
    }
    
    $result = Setup-MQL5ForgeRemote -Path $RepoPath
    
    if ($result) {
        Write-Host ""
        Write-Host "[OK] MQL5 Forge remote setup complete!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[ERROR] Failed to setup MQL5 Forge remote" -ForegroundColor Red
        exit 1
    }
} else {
    # Setup remote for current directory
    $currentPath = Get-Location
    
    $result = Setup-MQL5ForgeRemote -Path $currentPath
    
    if ($result) {
        Write-Host ""
        Write-Host "[OK] MQL5 Forge remote setup complete!" -ForegroundColor Green
        Write-Host ""
        Write-Host "You can now:" -ForegroundColor Cyan
        Write-Host "  - Fetch from MQL5 Forge: git fetch $RemoteName" -ForegroundColor White
        Write-Host "  - Pull from MQL5 Forge: git pull $RemoteName main" -ForegroundColor White
        Write-Host "  - Push to MQL5 Forge: git push $RemoteName main" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "[ERROR] Failed to setup MQL5 Forge remote" -ForegroundColor Red
        exit 1
    }
}
