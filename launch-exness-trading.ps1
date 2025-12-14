#Requires -Version 5.1
<#
.SYNOPSIS
    Launch GitHub Repository for Exness Trading Terminal
.DESCRIPTION
    This script clones/pulls a GitHub repository and launches Exness MT5 terminal
    to start automated trading.
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Exness Trading Launcher" -ForegroundColor Cyan
Write-Host "  GitHub Repository + MT5 Terminal" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$repoUrl = "https://github.com/A6-9V/my-drive-projects.git"
$repoName = "my-drive-projects"
$clonePath = "C:\Users\USER\OneDrive"
$exnessBasePath = "C:\Program Files\MetaTrader 5 EXNESS"
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$exnessPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe",
    "$env:LOCALAPPDATA\Programs\Exness Terminal\terminal64.exe",
    "$env:PROGRAMFILES\Exness Terminal\terminal64.exe",
    "$env:PROGRAMFILES(X86)\Exness Terminal\terminal64.exe",
    "$env:APPDATA\Exness Terminal\terminal64.exe",
    "$env:USERPROFILE\AppData\Local\Programs\Exness Terminal\terminal64.exe",
    "$env:USERPROFILE\AppData\Roaming\Exness Terminal\terminal64.exe"
)

# Step 1: Clone/Pull Repository
Write-Host "[1/4] Setting up GitHub repository..." -ForegroundColor Yellow
try {
    $repoFullPath = Join-Path $clonePath $repoName
    
    if (Test-Path $repoFullPath) {
        Write-Host "    [INFO] Repository already exists, pulling latest changes..." -ForegroundColor Cyan
        Set-Location $repoFullPath
        git pull origin main 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] Repository updated successfully" -ForegroundColor Green
        } else {
            Write-Host "    [WARNING] Could not pull updates, using existing version" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [INFO] Cloning repository..." -ForegroundColor Cyan
        Set-Location $clonePath
        git clone $repoUrl $repoName 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] Repository cloned successfully" -ForegroundColor Green
        } else {
            Write-Host "    [ERROR] Failed to clone repository" -ForegroundColor Red
            Write-Host "    [INFO] Trying alternative method..." -ForegroundColor Yellow
            
            # Try with GitHub CLI if available
            $ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
            if ($ghInstalled) {
                gh repo clone A6-9V/$repoName $repoFullPath 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "    [OK] Repository cloned using GitHub CLI" -ForegroundColor Green
                } else {
                    Write-Host "    [ERROR] Failed to clone repository" -ForegroundColor Red
                    exit 1
                }
            } else {
                Write-Host "    [ERROR] Git clone failed and GitHub CLI not available" -ForegroundColor Red
                exit 1
            }
        }
    }
} catch {
    Write-Host "    [ERROR] Repository setup failed: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Find Exness MT5 Terminal
Write-Host "[2/4] Locating Exness MT5 Terminal..." -ForegroundColor Yellow
$exnessPath = $null

# Check primary installation path first
if (Test-Path $exnessTerminalPath) {
    $exnessPath = $exnessTerminalPath
    Write-Host "    [OK] Found Exness Terminal at primary location: $exnessPath" -ForegroundColor Green
} else {
    # Fallback to other locations
    foreach ($path in $exnessPaths) {
        if (Test-Path $path) {
            $exnessPath = $path
            Write-Host "    [OK] Found Exness Terminal: $path" -ForegroundColor Green
            break
        }
    }
    
    if (-not $exnessPath) {
        Write-Host "    [WARNING] Exness Terminal not found in standard locations" -ForegroundColor Yellow
        Write-Host "    [INFO] Searching for terminal64.exe..." -ForegroundColor Cyan
        
        # Search in common locations
        $searchPaths = @(
            "$env:USERPROFILE",
            "$env:PROGRAMFILES",
            "$env:LOCALAPPDATA"
        )
        
        foreach ($searchPath in $searchPaths) {
            if (Test-Path $searchPath) {
                $found = Get-ChildItem -Path $searchPath -Filter "terminal64.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($found) {
                    $exnessPath = $found.FullName
                    Write-Host "    [OK] Found Exness Terminal: $exnessPath" -ForegroundColor Green
                    break
                }
            }
        }
    }
}

if (-not $exnessPath) {
    Write-Host "    [ERROR] Exness Terminal not found" -ForegroundColor Red
    Write-Host "    [INFO] Expected location: C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe" -ForegroundColor Yellow
    Write-Host "    [INFO] Please install Exness Terminal from: https://www.exness.com/" -ForegroundColor Yellow
    Write-Host "    [ERROR] Cannot proceed without Exness Terminal" -ForegroundColor Red
    exit 1
}

# Step 3: Launch Exness Terminal
Write-Host "[3/4] Launching Exness MT5 Terminal..." -ForegroundColor Yellow
try {
    if (Test-Path $exnessPath) {
        $exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
        
        if (-not $exnessProcess) {
            Write-Host "    [INFO] Starting Exness Terminal..." -ForegroundColor Cyan
            Start-Process -FilePath $exnessPath -ErrorAction Stop
            Start-Sleep -Seconds 3
            
            $exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
            if ($exnessProcess) {
                Write-Host "    [OK] Exness Terminal launched successfully" -ForegroundColor Green
            } else {
                Write-Host "    [WARNING] Terminal process not detected, but launch command executed" -ForegroundColor Yellow
            }
        } else {
            Write-Host "    [OK] Exness Terminal is already running" -ForegroundColor Green
        }
    } else {
        Write-Host "    [ERROR] Exness Terminal executable not found at: $exnessPath" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "    [ERROR] Failed to launch Exness Terminal: $_" -ForegroundColor Red
    exit 1
}

# Step 4: Navigate to Trading Scripts
Write-Host "[4/4] Setting up trading environment..." -ForegroundColor Yellow
try {
    $repoFullPath = Join-Path $clonePath $repoName
    
    if (Test-Path $repoFullPath) {
        Set-Location $repoFullPath
        
        # Look for trading-related scripts
        $tradingScripts = @(
            "start_live_trading.bat",
            "live_trading_system.py",
            "trading_system.py",
            "run_trading.ps1",
            "launch_trading.bat"
        )
        
        $foundScript = $null
        foreach ($script in $tradingScripts) {
            $scriptPath = Get-ChildItem -Path $repoFullPath -Filter $script -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($scriptPath) {
                $foundScript = $scriptPath.FullName
                Write-Host "    [OK] Found trading script: $script" -ForegroundColor Green
                break
            }
        }
        
        if ($foundScript) {
            Write-Host "    [INFO] Trading script location: $foundScript" -ForegroundColor Cyan
            Write-Host "    [INFO] You can run it manually or it may auto-start" -ForegroundColor Cyan
        } else {
            Write-Host "    [INFO] No trading scripts found in repository" -ForegroundColor Yellow
            Write-Host "    [INFO] Repository location: $repoFullPath" -ForegroundColor Cyan
        }
        
        Write-Host "    [OK] Trading environment ready" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] Repository path not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [WARNING] Could not set up trading environment: $_" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Launch Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Status:" -ForegroundColor Yellow
Write-Host "  [OK] Repository: $repoFullPath" -ForegroundColor White
Write-Host "  [OK] Exness Terminal: $exnessPath" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Log in to Exness Terminal if not already logged in" -ForegroundColor White
Write-Host "  2. Ensure your trading account is connected" -ForegroundColor White
Write-Host "  3. Run your trading scripts from the repository" -ForegroundColor White
Write-Host "  4. Monitor trading activity in the terminal" -ForegroundColor White
Write-Host ""
Write-Host "Repository location: $repoFullPath" -ForegroundColor Cyan
Write-Host ""

# Open repository folder
try {
    if (Test-Path $repoFullPath) {
        Write-Host "Opening repository folder..." -ForegroundColor Cyan
        Start-Process explorer.exe -ArgumentList $repoFullPath
    }
} catch {
    Write-Host "[WARNING] Could not open repository folder" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
