#Requires -Version 5.1
<#
.SYNOPSIS
    Generate and display the scheduled cleanup plan (no changes made).
#>

[CmdletBinding()]
param(
    [int]$ShowFirst = 50
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Scheduled File Cleanup - Review Plan" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$runner = Join-Path $PSScriptRoot "scheduled-file-cleanup.ps1"
if (-not (Test-Path $runner)) {
    Write-Host "[ERROR] Missing runner script: $runner" -ForegroundColor Red
    exit 1
}

& powershell.exe -ExecutionPolicy Bypass -NoProfile -File $runner -Mode Plan
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Plan generation failed (exit=$LASTEXITCODE)" -ForegroundColor Red
    exit $LASTEXITCODE
}

$planPath = Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.plan.json"
if (-not (Test-Path $planPath)) {
    Write-Host "[ERROR] Plan file not found: $planPath" -ForegroundColor Red
    exit 1
}

try {
    $plan = (Get-Content -LiteralPath $planPath -Raw -Encoding UTF8) | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-Host "[ERROR] Failed to parse plan JSON: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[INFO] Plan generated at: $($plan.generatedAtUtc)" -ForegroundColor Yellow
Write-Host "[INFO] Items: $($plan.itemCount)" -ForegroundColor Yellow
Write-Host "[INFO] Plan file: $planPath" -ForegroundColor Cyan
Write-Host ""

if ($plan.itemCount -eq 0) {
    Write-Host "[OK] Nothing to clean." -ForegroundColor Green
    exit 0
}

$items = @($plan.items)
$toShow = $items | Select-Object -First $ShowFirst

Write-Host "Showing first $($toShow.Count) item(s):" -ForegroundColor Cyan
foreach ($i in $toShow) {
    $dest = if ($i.destination) { " -> $($i.destination)" } else { "" }
    Write-Host " - [$($i.action)] $($i.source)$dest (rule: $($i.ruleName))" -ForegroundColor White
}

if ($plan.itemCount -gt $ShowFirst) {
    Write-Host ""
    Write-Host "[INFO] $($plan.itemCount - $ShowFirst) more item(s) not shown. Open the plan JSON for full list." -ForegroundColor Yellow
}

