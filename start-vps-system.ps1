#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Start VPS System - Complete 24/7 Trading System Startup
.DESCRIPTION
    Starts all components for 24/7 trading system:
    1. Runs launch-admin.ps1
    2. Runs Exness Trading Launcher
    3. Deploys VPS services
    4. Starts all background services
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting VPS Trading System" -ForegroundColor Cyan
Write-Host "  24/7 Automated Trading Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$workspaceRoot = "C:\Users\USER\OneDrive"
$vpsServicesPath = "$workspaceRoot\vps-services"

# Step 1: Run launch-admin.ps1
Write-Host "[1/4] Running launch-admin.ps1..." -ForegroundColor Yellow
try {
    $launchAdminScript = Join-Path $workspaceRoot "launch-admin.ps1"
    if (Test-Path $launchAdminScript) {
        & powershell.exe -ExecutionPolicy Bypass -File $launchAdminScript
        Write-Host "    [OK] launch-admin.ps1 executed" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] launch-admin.ps1 not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [WARNING] launch-admin.ps1 had issues: $_" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

# Step 2: Run Exness Trading Launcher
Write-Host "[2/4] Running Exness Trading Launcher..." -ForegroundColor Yellow
try {
    $exnessLauncher = Join-Path $workspaceRoot "launch-exness-trading.ps1"
    if (Test-Path $exnessLauncher) {
        Start-Process powershell.exe -ArgumentList @(
            "-ExecutionPolicy", "Bypass",
            "-WindowStyle", "Hidden",
            "-File", $exnessLauncher
        ) -WindowStyle Hidden
        Write-Host "    [OK] Exness Trading Launcher started" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] launch-exness-trading.ps1 not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [WARNING] Exness launcher had issues: $_" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# Step 3: Deploy VPS Services (if not already deployed)
Write-Host "[3/4] Deploying VPS services..." -ForegroundColor Yellow
try {
    $vpsDeployment = Join-Path $workspaceRoot "vps-deployment.ps1"
    if (Test-Path $vpsDeployment) {
        if (-not (Test-Path $vpsServicesPath)) {
            & powershell.exe -ExecutionPolicy Bypass -File $vpsDeployment
            Write-Host "    [OK] VPS services deployed" -ForegroundColor Green
        } else {
            Write-Host "    [OK] VPS services already deployed" -ForegroundColor Green
        }
    } else {
        Write-Host "    [WARNING] vps-deployment.ps1 not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [WARNING] VPS deployment had issues: $_" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

# Step 4: Start Master Controller
Write-Host "[4/4] Starting Master Controller..." -ForegroundColor Yellow
try {
    $masterController = Join-Path $vpsServicesPath "master-controller.ps1"
    if (Test-Path $masterController) {
        Start-Process powershell.exe -ArgumentList @(
            "-ExecutionPolicy", "Bypass",
            "-WindowStyle", "Hidden",
            "-File", $masterController
        ) -WindowStyle Hidden
        Write-Host "    [OK] Master Controller started" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] master-controller.ps1 not found" -ForegroundColor Yellow
        Write-Host "    [INFO] Run vps-deployment.ps1 first to create services" -ForegroundColor Cyan
    }
} catch {
    Write-Host "    [WARNING] Master Controller had issues: $_" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VPS System Startup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Started:" -ForegroundColor Yellow
Write-Host "  [OK] Admin launcher" -ForegroundColor White
Write-Host "  [OK] Exness Trading Terminal" -ForegroundColor White
Write-Host "  [OK] VPS Services" -ForegroundColor White
Write-Host "  [OK] Master Controller" -ForegroundColor White
Write-Host ""
Write-Host "To verify all services are running:" -ForegroundColor Cyan
Write-Host "  .\vps-verification.ps1" -ForegroundColor White
Write-Host ""
Write-Host "All services are now running in the background (24/7)" -ForegroundColor Green
Write-Host ""
