# install-nodejs-npm.ps1
# Automated Node.js and npm installation for Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Node.js and npm Installation Script  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if already installed
$NodeInstalled = $false
$NpmInstalled = $false

try {
    $NodeVersion = node --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $NodeInstalled = $true
        Write-Host "[OK] Node.js is already installed: $NodeVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "[INFO] Node.js not found" -ForegroundColor Yellow
}

try {
    $NpmVersion = npm --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $NpmInstalled = $true
        Write-Host "[OK] npm is already installed: v$NpmVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "[INFO] npm not found" -ForegroundColor Yellow
}

if ($NodeInstalled -and $NpmInstalled) {
    Write-Host ""
    Write-Host "[INFO] Node.js and npm are already installed. Installation skipped." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To update to the latest version, download from: https://nodejs.org/" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "[INFO] Installing Node.js and npm..." -ForegroundColor Cyan
Write-Host ""

# Check if winget is available
$WingetAvailable = $false
try {
    $WingetCheck = winget --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $WingetAvailable = $true
        Write-Host "[OK] winget package manager found" -ForegroundColor Green
    }
} catch {
    Write-Host "[WARNING] winget not available" -ForegroundColor Yellow
}

# Install using winget if available
if ($WingetAvailable) {
    Write-Host ""
    Write-Host "[INFO] Installing Node.js LTS using winget..." -ForegroundColor Cyan
    
    try {
        # Install Node.js LTS (includes npm)
        Write-Host "[INFO] This may take a few minutes. Please wait..." -ForegroundColor Yellow
        winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Node.js installation completed" -ForegroundColor Green
            
            # Refresh environment variables
            Write-Host "[INFO] Refreshing environment variables..." -ForegroundColor Yellow
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            
            # Verify installation
            Write-Host ""
            Write-Host "[INFO] Verifying installation..." -ForegroundColor Cyan
            
            Start-Sleep -Seconds 3
            
            try {
                $NodeVersion = node --version 2>$null
                $NpmVersion = npm --version 2>$null
                
                Write-Host "[OK] Node.js version: $NodeVersion" -ForegroundColor Green
                Write-Host "[OK] npm version: v$NpmVersion" -ForegroundColor Green
                
                Write-Host ""
                Write-Host "[INFO] Installation successful!" -ForegroundColor Green
                Write-Host "[INFO] You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
            } catch {
                Write-Host "[WARNING] Verification failed. Please restart your terminal and try again." -ForegroundColor Yellow
            }
        } else {
            Write-Host "[ERROR] Installation failed with exit code: $LASTEXITCODE" -ForegroundColor Red
            Write-Host "[INFO] Please install manually from: https://nodejs.org/" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Installation error: $_" -ForegroundColor Red
        Write-Host "[INFO] Please install manually from: https://nodejs.org/" -ForegroundColor Yellow
    }
} else {
    # Provide manual installation instructions
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  MANUAL INSTALLATION REQUIRED" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "winget package manager is not available on this system." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install Node.js manually:" -ForegroundColor Cyan
    Write-Host "1. Visit: https://nodejs.org/" -ForegroundColor White
    Write-Host "2. Download the LTS (Long Term Support) version" -ForegroundColor White
    Write-Host "3. Run the installer with default settings" -ForegroundColor White
    Write-Host "4. npm is included with Node.js" -ForegroundColor White
    Write-Host ""
    Write-Host "After installation, restart your terminal and run:" -ForegroundColor Cyan
    Write-Host "  node --version" -ForegroundColor White
    Write-Host "  npm --version" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Script Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
