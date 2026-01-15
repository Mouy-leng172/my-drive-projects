# Automated Git Push - Uses saved tokens automatically
# This script automatically commits and pushes changes without prompts

$defaultRepoPath = $null
if ($env:USERPROFILE) {
    $defaultRepoPath = Join-Path $env:USERPROFILE "OneDrive"
}

$repoPath = if ($defaultRepoPath -and (Test-Path $defaultRepoPath)) { $defaultRepoPath } else { "C:\Users\USER\OneDrive" }
Set-Location $repoPath

Write-Host "Automated Git Push" -ForegroundColor Cyan
Write-Host "Using saved credentials..." -ForegroundColor Yellow
Write-Host ""

# Load credentials from file
$credFile = Join-Path $PSScriptRoot "git-credentials.txt"
$githubToken = $null
$githubUser = $null

if (Test-Path $credFile) {
    $credRaw = Get-Content $credFile -Raw -ErrorAction SilentlyContinue
    foreach ($line in ($credRaw -split "(\r?\n)")) {
        if ($line -match "^GITHUB_TOKEN=(.+)$") {
            $githubToken = $Matches[1].Trim()
        }
        if ($line -match "^GITHUB_USER=(.+)$") {
            $githubUser = $Matches[1].Trim()
        }
    }
}

if (-not $githubToken) {
    Write-Host "[ERROR] GitHub token not found in credentials file" -ForegroundColor Red
    exit 1
}

if (-not $githubUser) {
    $githubUser = "Mouy-leng"
}

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "[1] Initializing git repository..." -ForegroundColor Yellow
    git init | Out-Null
    Write-Host "    [OK] Git initialized" -ForegroundColor Green
}

# Check and set remote
$remotes = git remote -v 2>&1
if (-not ($remotes -match "origin")) {
    Write-Host "[2] Adding remote repository..." -ForegroundColor Yellow
    git remote add origin "https://github.com/Mouy-leng/Window-setup.git" 2>&1 | Out-Null
    Write-Host "    [OK] Remote added" -ForegroundColor Green
} else {
    # Update remote to use HTTPS
    git remote set-url origin "https://github.com/Mouy-leng/Window-setup.git" 2>&1 | Out-Null
    Write-Host "[2] Remote configured" -ForegroundColor Green
}

# Set branch to main
Write-Host "[3] Setting branch to main..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null
Write-Host "    [OK] Branch set to main" -ForegroundColor Green

# Add all files
Write-Host "[4] Adding files..." -ForegroundColor Yellow
git add . 2>&1 | Out-Null
Write-Host "    [OK] Files staged" -ForegroundColor Green

# Check if there are changes
$status = git status --porcelain
if ($status) {
    # Generate intelligent commit message based on changes
    $commitMessage = "Auto-commit: Update Windows setup scripts and configuration"
    
    Write-Host "[5] Committing changes..." -ForegroundColor Yellow
    git commit -m $commitMessage 2>&1 | Out-Null
    Write-Host "    [OK] Changes committed" -ForegroundColor Green
    
    # Configure git credential helper for this push
    Write-Host "[6] Configuring credentials..." -ForegroundColor Yellow

    # Keep remote URL clean (never embed tokens in git config).
    $cleanRemoteUrl = "https://github.com/Mouy-leng/Window-setup.git"
    git remote set-url origin $cleanRemoteUrl 2>&1 | Out-Null

    # Store credentials in Windows Credential Manager (preferred) if available.
    $cmdkeyCmd = Get-Command cmdkey -ErrorAction SilentlyContinue
    if ($cmdkeyCmd) {
        cmdkey /generic:git:https://github.com /user:$githubUser /pass:$githubToken 2>&1 | Out-Null
        Write-Host "    [OK] Credentials saved securely" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] cmdkey not available; git may prompt for credentials" -ForegroundColor Yellow
    }
    
    # Push to repository
    Write-Host "[7] Pushing to GitHub..." -ForegroundColor Yellow
    
    $pushResult = git push -u origin main 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    [OK] Successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "    [ERROR] Failed to push" -ForegroundColor Red
        # Sanitize any accidental token echoes in git output.
        $pushText = ($pushResult | Out-String)
        if ($githubToken) {
            $pushText = $pushText -replace [regex]::Escape($githubToken), "***"
        }
        $preview = ($pushText -split "`r?`n" | Select-Object -First 15) -join "`n"
        Write-Host "    Output (first lines):`n$preview" -ForegroundColor Yellow
    }
} else {
    Write-Host "[5] No changes to commit" -ForegroundColor Yellow
    Write-Host "    [OK] Repository is up to date" -ForegroundColor Green
}

Write-Host ""
Write-Host "Automated Git Push Complete!" -ForegroundColor Cyan

# Best-effort cleanup
$githubToken = $null
