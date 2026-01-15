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
$mql5RepoUrl = "https://forge.mql5.io/LengKundee/mql5.git"
$mql5RepoName = "mql5-repo"
$repoUrl = "https://github.com/A6-9V/my-drive-projects.git"
$repoName = "my-drive-projects"
$clonePath = "C:\Users\USER\OneDrive"
$mql5ConfigFile = Join-Path $clonePath "mql5-config.txt"

# Load MQL5 API Token
$mql5ApiToken = $null
if (Test-Path $mql5ConfigFile) {
    $configContent = Get-Content $mql5ConfigFile -ErrorAction SilentlyContinue
    $tokenLine = $configContent | Where-Object { $_ -match "^MQL5_API=" }
    if ($tokenLine) {
        $mql5ApiToken = ($tokenLine -split "=")[1].Trim()
    }
}
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

# Step 1: Clone/Pull MQL5 Forge Repository
Write-Host "[1/5] Setting up MQL5 Forge repository..." -ForegroundColor Yellow
try {
    $mql5RepoFullPath = Join-Path $clonePath $mql5RepoName
    
    if (Test-Path $mql5RepoFullPath) {
        Write-Host "    [INFO] MQL5 repository already exists, pulling latest changes..." -ForegroundColor Cyan
        Set-Location $mql5RepoFullPath
        
        # Configure git with token if available
        if ($mql5ApiToken) {
            $repoUrlWithToken = $mql5RepoUrl -replace "https://", "https://$mql5ApiToken@"
            git remote set-url origin $repoUrlWithToken 2>&1 | Out-Null
        }
        
        git pull origin main 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] MQL5 repository updated successfully" -ForegroundColor Green
        }
        else {
            Write-Host "    [WARNING] Could not pull MQL5 updates, using existing version" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "    [INFO] Cloning MQL5 repository..." -ForegroundColor Cyan
        Set-Location $clonePath
        
        # Clone with token if available
        if ($mql5ApiToken) {
            $repoUrlWithToken = $mql5RepoUrl -replace "https://", "https://$mql5ApiToken@"
            git clone $repoUrlWithToken $mql5RepoName 2>&1 | Out-Null
        }
        else {
            git clone $mql5RepoUrl $mql5RepoName 2>&1 | Out-Null
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] MQL5 repository cloned successfully" -ForegroundColor Green
        }
        else {
            Write-Host "    [ERROR] Failed to clone MQL5 repository" -ForegroundColor Red
            Write-Host "    [INFO] Continuing without MQL5 repository..." -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "    [WARNING] MQL5 repository setup failed: $_" -ForegroundColor Yellow
    Write-Host "    [INFO] Continuing without MQL5 repository..." -ForegroundColor Yellow
}

# Step 1b: Clone/Pull GitHub Repository (optional)
Write-Host "[1b/5] Setting up GitHub repository (optional)..." -ForegroundColor Yellow
try {
    $repoFullPath = Join-Path $clonePath $repoName
    
    if (Test-Path $repoFullPath) {
        Write-Host "    [INFO] GitHub repository already exists, pulling latest changes..." -ForegroundColor Cyan
        Set-Location $repoFullPath
        git pull origin main 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] GitHub repository updated successfully" -ForegroundColor Green
        }
        else {
            Write-Host "    [WARNING] Could not pull GitHub updates, using existing version" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "    [INFO] GitHub repository not found, skipping..." -ForegroundColor Cyan
    }
}
catch {
    Write-Host "    [WARNING] GitHub repository setup failed: $_" -ForegroundColor Yellow
}

# Step 2: Find Exness MT5 Terminal
Write-Host "[2/5] Locating Exness MT5 Terminal..." -ForegroundColor Yellow
$exnessPath = $null

# Check primary installation path first
if (Test-Path $exnessTerminalPath) {
    $exnessPath = $exnessTerminalPath
    Write-Host "    [OK] Found Exness Terminal at primary location: $exnessPath" -ForegroundColor Green
}
else {
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
            }
            else {
                Write-Host "    [WARNING] Terminal process not detected, but launch command executed" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "    [OK] Exness Terminal is already running" -ForegroundColor Green
        }
    }
    else {
        Write-Host "    [ERROR] Exness Terminal executable not found at: $exnessPath" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "    [ERROR] Failed to launch Exness Terminal: $_" -ForegroundColor Red
    exit 1
}

# Step 4: Check MQL5 Files
Write-Host "[4/5] Checking MQL5 files..." -ForegroundColor Yellow
try {
    $mql5RepoFullPath = Join-Path $clonePath $mql5RepoName
    
    if (Test-Path $mql5RepoFullPath) {
        Set-Location $mql5RepoFullPath
        
        # Look for MQL5 files
        $mql5Files = Get-ChildItem -Path $mql5RepoFullPath -Filter "*.mq5" -Recurse -ErrorAction SilentlyContinue
        $mql4Files = Get-ChildItem -Path $mql5RepoFullPath -Filter "*.mq4" -Recurse -ErrorAction SilentlyContinue
        
        if ($mql5Files -or $mql4Files) {
            Write-Host "    [OK] Found MQL5/MQL4 files:" -ForegroundColor Green
            if ($mql5Files) {
                Write-Host "      MQL5 files: $($mql5Files.Count)" -ForegroundColor Cyan
            }
            if ($mql4Files) {
                Write-Host "      MQL4 files: $($mql4Files.Count)" -ForegroundColor Cyan
            }
            Write-Host "    [INFO] MQL5 repository location: $mql5RepoFullPath" -ForegroundColor Cyan
        }
        else {
            Write-Host "    [INFO] No MQL5/MQL4 files found in repository" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "    [WARNING] MQL5 repository path not found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "    [WARNING] Could not check MQL5 files: $_" -ForegroundColor Yellow
}

# Step 5: Navigate to Trading Scripts
Write-Host "[5/5] Setting up trading environment..." -ForegroundColor Yellow
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
        }
        else {
            Write-Host "    [INFO] No trading scripts found in GitHub repository" -ForegroundColor Yellow
            Write-Host "    [INFO] Repository location: $repoFullPath" -ForegroundColor Cyan
        }
        
        Write-Host "    [OK] Trading environment ready" -ForegroundColor Green
    }
    else {
        Write-Host "    [WARNING] GitHub repository path not found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "    [WARNING] Could not set up trading environment: $_" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Launch Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Status:" -ForegroundColor Yellow
if (Test-Path $mql5RepoFullPath) {
    Write-Host "  [OK] MQL5 Repository: $mql5RepoFullPath" -ForegroundColor White
}
if (Test-Path $repoFullPath) {
    Write-Host "  [OK] GitHub Repository: $repoFullPath" -ForegroundColor White
}
Write-Host "  [OK] Exness Terminal: $exnessPath" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Log in to Exness Terminal if not already logged in" -ForegroundColor White
Write-Host "  2. Ensure your trading account is connected" -ForegroundColor White
Write-Host "  3. Check MQL5 files in: $mql5RepoFullPath" -ForegroundColor White
Write-Host "  4. Run your trading scripts from the repositories" -ForegroundColor White
Write-Host "  5. Monitor trading activity in the terminal" -ForegroundColor White
Write-Host ""
if (Test-Path $mql5RepoFullPath) {
    Write-Host "MQL5 Repository location: $mql5RepoFullPath" -ForegroundColor Cyan
}
if (Test-Path $repoFullPath) {
    Write-Host "GitHub Repository location: $repoFullPath" -ForegroundColor Cyan
}
Write-Host ""

# Open repository folders
try {
    if (Test-Path $mql5RepoFullPath) {
        Write-Host "Opening MQL5 repository folder..." -ForegroundColor Cyan
        Start-Process explorer.exe -ArgumentList $mql5RepoFullPath
    }
    if (Test-Path $repoFullPath) {
        Write-Host "Opening GitHub repository folder..." -ForegroundColor Cyan
        Start-Process explorer.exe -ArgumentList $repoFullPath
    }
}
catch {
    Write-Host "[WARNING] Could not open repository folder(s)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
