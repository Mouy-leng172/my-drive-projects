# setup-git-hooks.ps1
# Set up Git hooks for automatic dependency installation

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Git Hooks Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Get-Location
}

$GitHooksDir = Join-Path -Path $RepoRoot -ChildPath ".git\hooks"

# Check if .git directory exists
if (-not (Test-Path (Join-Path -Path $RepoRoot -ChildPath ".git"))) {
    Write-Host "[ERROR] Not a git repository. .git directory not found." -ForegroundColor Red
    exit 1
}

# Create hooks directory if it doesn't exist
if (-not (Test-Path $GitHooksDir)) {
    Write-Host "[INFO] Creating hooks directory..." -ForegroundColor Yellow
    New-Item -Path $GitHooksDir -ItemType Directory -Force | Out-Null
}

Write-Host "[INFO] Setting up Git hooks..." -ForegroundColor Cyan
Write-Host ""

# Create post-merge hook
$PostMergeHook = Join-Path -Path $GitHooksDir -ChildPath "post-merge"
$PostMergeContent = @'
#!/bin/sh
# Git post-merge hook
# Automatically install dependencies after git pull/merge

echo "[INFO] Running post-merge hook: checking for dependency changes..."

# Check if package.json, requirements.txt, or Gemfile changed
if git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep -E "(package\.json|requirements\.txt|Gemfile)" > /dev/null; then
    echo "[INFO] Dependency files changed. Running auto-install..."
    
    # Run PowerShell script for dependency installation
    if command -v pwsh > /dev/null 2>&1; then
        pwsh -ExecutionPolicy Bypass -File "./auto-install-dependencies.ps1"
    elif command -v powershell > /dev/null 2>&1; then
        powershell -ExecutionPolicy Bypass -File "./auto-install-dependencies.ps1"
    else
        echo "[WARNING] PowerShell not found. Please run auto-install-dependencies.ps1 manually."
    fi
else
    echo "[OK] No dependency changes detected."
fi

exit 0
'@

try {
    $PostMergeContent | Out-File -FilePath $PostMergeHook -Encoding UTF8 -NoNewline
    Write-Host "[OK] Created post-merge hook" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to create post-merge hook: $_" -ForegroundColor Red
}

# Create post-checkout hook
$PostCheckoutHook = Join-Path -Path $GitHooksDir -ChildPath "post-checkout"
$PostCheckoutContent = @'
#!/bin/sh
# Git post-checkout hook
# Automatically install dependencies after branch checkout

# Only run on branch checkout (not file checkout)
if [ "$3" = "1" ]; then
    echo "[INFO] Running post-checkout hook: checking for dependency changes..."
    
    # Check if package.json, requirements.txt, or Gemfile exist
    if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "Gemfile" ]; then
        echo "[INFO] Found dependency files. Running auto-install..."
        
        # Run PowerShell script for dependency installation
        if command -v pwsh > /dev/null 2>&1; then
            pwsh -ExecutionPolicy Bypass -File "./auto-install-dependencies.ps1"
        elif command -v powershell > /dev/null 2>&1; then
            powershell -ExecutionPolicy Bypass -File "./auto-install-dependencies.ps1"
        else
            echo "[WARNING] PowerShell not found. Please run auto-install-dependencies.ps1 manually."
        fi
    fi
fi

exit 0
'@

try {
    $PostCheckoutContent | Out-File -FilePath $PostCheckoutHook -Encoding UTF8 -NoNewline
    Write-Host "[OK] Created post-checkout hook" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to create post-checkout hook: $_" -ForegroundColor Red
}

# Make hooks executable (on Unix-like systems)
if ($IsLinux -or $IsMacOS) {
    Write-Host "[INFO] Making hooks executable..." -ForegroundColor Yellow
    chmod +x "$PostMergeHook"
    chmod +x "$PostCheckoutHook"
    Write-Host "[OK] Hooks are now executable" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Git Hooks Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installed hooks:" -ForegroundColor Cyan
Write-Host "  • post-merge   - Runs after git pull/merge" -ForegroundColor White
Write-Host "  • post-checkout - Runs after branch checkout" -ForegroundColor White
Write-Host ""
Write-Host "These hooks will automatically run auto-install-dependencies.ps1" -ForegroundColor Yellow
Write-Host "when dependency files (package.json, requirements.txt, Gemfile) change." -ForegroundColor Yellow
Write-Host ""
