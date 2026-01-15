#Requires -Version 5.1
<#
.SYNOPSIS
    "Auto boots" runner: installs startup + scheduled cleanup automation.
.DESCRIPTION
    - Runs existing auto-startup setup (restart-only)
    - Installs scheduled cleanup plan task (non-destructive)
#>

[CmdletBinding()]
param(
    [ValidatePattern("^\d{2}:\d{2}$")]
    [string]$CleanupDailyAt = "03:30"
)

$ErrorActionPreference = "Continue"

function Test-IsAdministrator {
    try {
        $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

if (-not (Test-IsAdministrator)) {
    Write-Host "[INFO] Elevating to Administrator..." -ForegroundColor Yellow
    $scriptPath = $PSCommandPath
    if (-not $scriptPath) { $scriptPath = $MyInvocation.MyCommand.Path }
    if (-not $scriptPath) {
        Write-Host "[ERROR] Unable to determine script path for elevation." -ForegroundColor Red
        exit 1
    }
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`" -CleanupDailyAt $CleanupDailyAt"
    exit 0
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Auto Boots - Setup Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1) Auto-start on restart only
$autoStartup = Join-Path $PSScriptRoot "setup-auto-startup-restart-only.ps1"
if (Test-Path $autoStartup) {
    Write-Host "[INFO] Configuring auto-start (restart only)..." -ForegroundColor Yellow
    & powershell.exe -ExecutionPolicy Bypass -NoProfile -File $autoStartup
} else {
    Write-Host "[WARNING] Missing: $autoStartup" -ForegroundColor Yellow
}

Write-Host ""

# 2) Scheduled cleanup (Plan only)
$cleanupSetup = Join-Path $PSScriptRoot "setup-scheduled-file-cleanup.ps1"
if (Test-Path $cleanupSetup) {
    Write-Host "[INFO] Installing scheduled cleanup plan task..." -ForegroundColor Yellow
    & powershell.exe -ExecutionPolicy Bypass -NoProfile -File $cleanupSetup -Install -DailyAt $CleanupDailyAt
} else {
    Write-Host "[WARNING] Missing: $cleanupSetup" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[OK] Auto boots setup complete." -ForegroundColor Green

