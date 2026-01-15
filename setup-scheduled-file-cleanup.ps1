#Requires -Version 5.1
<#
.SYNOPSIS
    Install/remove/check the Scheduled File Cleanup task.
.DESCRIPTION
    Creates a Windows Task Scheduler task that runs the cleanup in PLAN mode (non-destructive).
    APPLY is intentionally not scheduled; it requires manual review + approval.
.PARAMETER Install
    Install/update the scheduled task.
.PARAMETER Remove
    Remove the scheduled task.
.PARAMETER Check
    Show current task status.
.PARAMETER RunNow
    Trigger the task once (or run Plan directly if task not present).
.PARAMETER TaskName
    Name of the scheduled task.
.PARAMETER DailyAt
    Daily time (HH:mm) for the plan run.
#>

[CmdletBinding()]
param(
    [switch]$Install,
    [switch]$Remove,
    [switch]$Check,
    [switch]$RunNow,

    [string]$TaskName = "Scheduled-File-Cleanup-Plan",
    [ValidatePattern("^\d{2}:\d{2}$")]
    [string]$DailyAt = "03:30"
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
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`""
    exit 0
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Scheduled File Cleanup - Task Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$runner = Join-Path $PSScriptRoot "scheduled-file-cleanup.ps1"
if (-not (Test-Path $runner)) {
    Write-Host "[ERROR] Missing runner script: $runner" -ForegroundColor Red
    exit 1
}

if ($Check) {
    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Host "[OK] Task exists: $TaskName" -ForegroundColor Green
        Write-Host "     State: $($task.State)" -ForegroundColor Yellow
    } else {
        Write-Host "[WARNING] Task not found: $TaskName" -ForegroundColor Yellow
    }
    exit 0
}

if ($Remove) {
    Write-Host "[INFO] Removing task: $TaskName" -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop
        Write-Host "    [OK] Removed" -ForegroundColor Green
    } catch {
        Write-Host "    [WARNING] Could not remove (may not exist): $($_.Exception.Message)" -ForegroundColor Yellow
    }
    exit 0
}

if ($Install) {
    Write-Host "[INFO] Installing/updating task: $TaskName" -ForegroundColor Yellow

    try { Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue } catch { }

    $args = "-ExecutionPolicy Bypass -NoProfile -File `"$runner`" -Mode Plan -Quiet"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $args -WorkingDirectory $PSScriptRoot

    $hh = [int]$DailyAt.Split(":")[0]
    $mm = [int]$DailyAt.Split(":")[1]
    $startTime = (Get-Date).Date.AddHours($hh).AddMinutes($mm)
    $trigger = New-ScheduledTaskTrigger -Daily -At $startTime

    $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    try {
        Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings `
            -Description "Generates scheduled cleanup plan (non-destructive). APPLY requires manual approval." -Force | Out-Null

        Write-Host "    [OK] Task installed" -ForegroundColor Green
        Write-Host "    Trigger: Daily at $DailyAt" -ForegroundColor Cyan
        Write-Host "    Mode:    Plan (non-destructive)" -ForegroundColor Cyan
    } catch {
        Write-Host "    [ERROR] Failed to install task: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

if ($RunNow) {
    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Host "[INFO] Starting task now: $TaskName" -ForegroundColor Yellow
        try {
            Start-ScheduledTask -TaskName $TaskName
            Write-Host "    [OK] Started" -ForegroundColor Green
        } catch {
            Write-Host "    [WARNING] Could not start task: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[INFO] Task not found; running Plan directly..." -ForegroundColor Yellow
        & powershell.exe -ExecutionPolicy Bypass -NoProfile -File $runner -Mode Plan
    }
}

if (-not ($Install -or $Remove -or $Check -or $RunNow)) {
    Write-Host "[INFO] No action specified. Use one of: -Install | -Remove | -Check | -RunNow" -ForegroundColor Yellow
}

