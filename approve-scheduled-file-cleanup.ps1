#Requires -Version 5.1
<#
.SYNOPSIS
    Approve the current scheduled cleanup plan for APPLY.
.DESCRIPTION
    Writes an approval file that:
    - Matches the current plan hash (SHA256 of the plan file bytes)
    - Expires automatically (default: 2 hours)

    This enforces the requirement: Move/Delete actions must be reviewed before execution.
#>

[CmdletBinding()]
param(
    [int]$HoursValid = 2,
    [string]$Reason = "Reviewed and approved",
    [string]$PlanPath = (Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.plan.json"),
    [string]$ApprovalPath = (Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.approval.json")
)

$ErrorActionPreference = "Stop"

function Get-FileSha256 {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path $Path)) { return $null }

    $sha = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead($Path)
    try {
        $hashBytes = $sha.ComputeHash($stream)
        return ([BitConverter]::ToString($hashBytes) -replace "-", "").ToLowerInvariant()
    } finally {
        $stream.Dispose()
        $sha.Dispose()
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Scheduled File Cleanup - Approve Plan" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $PlanPath)) {
    Write-Host "[ERROR] Plan file not found. Generate it first:" -ForegroundColor Red
    Write-Host "       .\\review-scheduled-file-cleanup.ps1" -ForegroundColor Yellow
    exit 1
}

if ($HoursValid -lt 1 -or $HoursValid -gt 72) {
    Write-Host "[ERROR] HoursValid must be between 1 and 72." -ForegroundColor Red
    exit 1
}

$hash = Get-FileSha256 -Path $PlanPath
if (-not $hash) {
    Write-Host "[ERROR] Failed to compute plan hash." -ForegroundColor Red
    exit 1
}

$nowUtc = (Get-Date).ToUniversalTime()
$expiresUtc = $nowUtc.AddHours($HoursValid)

$approval = [PSCustomObject]@{
    approvedAtUtc   = $nowUtc.ToString("o")
    expiresAtUtc    = $expiresUtc.ToString("o")
    planPath        = $PlanPath
    planHashSha256  = $hash
    approvedByUser  = "$env:USERDOMAIN\$env:USERNAME"
    machineName     = $env:COMPUTERNAME
    reason          = $Reason
}

try {
    ($approval | ConvertTo-Json -Depth 5) | Out-File -FilePath $ApprovalPath -Encoding UTF8
} catch {
    Write-Host "[ERROR] Failed to write approval file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Approval file created." -ForegroundColor Green
Write-Host "     Approval: $ApprovalPath" -ForegroundColor Cyan
Write-Host "     Expires:  $($expiresUtc.ToString('u'))" -ForegroundColor Yellow
Write-Host ""
Write-Host "[INFO] To apply the cleanup (destructive), run:" -ForegroundColor Yellow
Write-Host "       .\\scheduled-file-cleanup.ps1 -Mode Apply" -ForegroundColor White

