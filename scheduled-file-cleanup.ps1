#Requires -Version 5.1
<#
.SYNOPSIS
    Scheduled file/folder cleanup (safe-by-default).
.DESCRIPTION
    - Generates a cleanup PLAN from a JSON config (no changes made in Plan mode)
    - APPLY mode requires an approval file (explicit review gate)
    - Designed for use via Task Scheduler (run PLAN daily), and manual APPLY only after review/approval

    NOTE: Per project policy, any Move/Delete must require review. This script enforces that:
    APPLY will not run unless an approval file exists and matches the current plan hash.
.PARAMETER Mode
    Plan (default) or Apply.
.PARAMETER ConfigPath
    Path to JSON config. Defaults to cleanup-config\scheduled-file-cleanup.json in repo root.
.PARAMETER PlanPath
    Path to write the generated plan JSON.
.PARAMETER ApprovalPath
    Path to the approval file JSON produced by approve-scheduled-file-cleanup.ps1
.PARAMETER Quiet
    Reduce console output (still writes logs and plan file).
#>

[CmdletBinding()]
param(
    [ValidateSet("Plan", "Apply")]
    [string]$Mode = "Plan",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.json"),
    [string]$PlanPath = (Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.plan.json"),
    [string]$ApprovalPath = (Join-Path $PSScriptRoot "cleanup-config\scheduled-file-cleanup.approval.json"),

    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

function Write-Log {
    param(
        [ValidateSet("INFO", "OK", "WARNING", "ERROR")]
        [string]$Level,
        [string]$Message,
        [ConsoleColor]$Color = [ConsoleColor]::White
    )

    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] [$Level] $Message"
    try { $line | Out-File -FilePath $script:LogFilePath -Append -Encoding UTF8 } catch { }
    if (-not $Quiet) {
        Write-Host $line -ForegroundColor $Color
    }
}

function Resolve-CleanupPath {
    param([string]$PathValue)

    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        return $null
    }

    # Support %ENVVAR% expansion inside config values
    $expanded = [Environment]::ExpandEnvironmentVariables($PathValue)

    # If relative, resolve from repo root ($PSScriptRoot)
    if (-not [System.IO.Path]::IsPathRooted($expanded)) {
        return (Join-Path $PSScriptRoot $expanded)
    }

    return $expanded
}

function Get-FileSha256 {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path $Path)) { return $null }

    try {
        $sha = [System.Security.Cryptography.SHA256]::Create()
        $stream = [System.IO.File]::OpenRead($Path)
        try {
            $hashBytes = $sha.ComputeHash($stream)
            return ([BitConverter]::ToString($hashBytes) -replace "-", "").ToLowerInvariant()
        } finally {
            $stream.Dispose()
            $sha.Dispose()
        }
    } catch {
        return $null
    }
}

function Test-GlobMatch {
    param(
        [string]$PathText,
        [string[]]$Globs
    )

    if (-not $Globs -or $Globs.Count -eq 0) { return $false }

    foreach ($g in $Globs) {
        if ([string]::IsNullOrWhiteSpace($g)) { continue }

        # Very small glob support:
        # - If pattern contains a path separator or drive marker, match against full normalized path
        # - Else match against leaf name only
        $normPath = $PathText.Replace("/", "\")
        $pattern = $g.Replace("/", "\")

        $isPathPattern = ($pattern.Contains("\") -or $pattern.Contains(":"))
        if ($isPathPattern) {
            if ($normPath -like $pattern) { return $true }
        } else {
            $name = Split-Path $normPath -Leaf
            if ($name -like $pattern) { return $true }
        }
    }

    return $false
}

function New-PlanItem {
    param(
        [string]$RuleName,
        [string]$Action,
        [string]$SourcePath,
        [string]$DestinationPath,
        [bool]$ReviewRequired,
        [string]$Reason
    )

    $size = $null
    $lastWrite = $null
    try {
        $item = Get-Item -LiteralPath $SourcePath -ErrorAction Stop
        $lastWrite = $item.LastWriteTimeUtc.ToString("o")
        if ($item.PSIsContainer -eq $false) {
            $size = $item.Length
        }
    } catch { }

    return [PSCustomObject]@{
        ruleName        = $RuleName
        action          = $Action
        source          = $SourcePath
        destination     = $DestinationPath
        reviewRequired  = $ReviewRequired
        reason          = $Reason
        lastWriteTimeUtc = $lastWrite
        sizeBytes       = $size
    }
}

# Prepare log file
$logsDir = Join-Path $PSScriptRoot "cleanup-logs"
if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
}
$script:LogFilePath = Join-Path $logsDir ("scheduled-file-cleanup_{0}.log" -f (Get-Date -Format "yyyyMMdd"))

Write-Log -Level INFO -Message "Starting scheduled cleanup (Mode=$Mode)" -Color Cyan
Write-Log -Level INFO -Message "ConfigPath: $ConfigPath" -Color Cyan
Write-Log -Level INFO -Message "PlanPath:   $PlanPath" -Color Cyan

$planItems = $null

if ($Mode -eq "Plan") {
    if (-not (Test-Path $ConfigPath)) {
        Write-Log -Level ERROR -Message "Config file not found: $ConfigPath" -Color Red
        exit 1
    }

    try {
        $configRaw = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8
        $config = $configRaw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Log -Level ERROR -Message "Failed to parse config JSON: $($_.Exception.Message)" -Color Red
        exit 1
    }

    $planItems = New-Object System.Collections.Generic.List[object]
    $rules = @($config.rules)
    $rulesEvaluated = 0

    $nowUtc = (Get-Date).ToUniversalTime()

    foreach ($rule in $rules) {
        if (-not $rule) { continue }
        if ($rule.enabled -ne $true) { continue }

        $rulesEvaluated++
        $ruleName = [string]$rule.name
        $action = [string]$rule.action
        $targetType = [string]$rule.targetType
        $basePath = Resolve-CleanupPath -PathValue ([string]$rule.basePath)
        $recurse = [bool]$rule.recurse
        $includeGlobs = @($rule.includeGlobs)
        $excludeGlobs = @($rule.excludeGlobs)
        $olderThanDays = $null
        if ($null -ne $rule.olderThanDays) { $olderThanDays = [int]$rule.olderThanDays }
        $maxItems = 5000
        if ($null -ne $rule.maxItems) { $maxItems = [int]$rule.maxItems }
        $reviewRequired = $true
        if ($null -ne $rule.reviewRequired) { $reviewRequired = [bool]$rule.reviewRequired }
        $deleteOnlyIfEmpty = $true
        if ($null -ne $rule.deleteOnlyIfEmpty) { $deleteOnlyIfEmpty = [bool]$rule.deleteOnlyIfEmpty }

        if ([string]::IsNullOrWhiteSpace($ruleName)) { $ruleName = "(unnamed rule)" }

        if ([string]::IsNullOrWhiteSpace($basePath) -or -not (Test-Path $basePath)) {
            Write-Log -Level WARNING -Message "Rule '$ruleName' skipped (base path not found): $basePath" -Color Yellow
            continue
        }

        if ($action -notin @("Delete", "MoveTo")) {
            Write-Log -Level WARNING -Message "Rule '$ruleName' skipped (unsupported action): $action" -Color Yellow
            continue
        }

        if ($targetType -notin @("File", "Directory")) {
            Write-Log -Level WARNING -Message "Rule '$ruleName' skipped (unsupported targetType): $targetType" -Color Yellow
            continue
        }

        $cutoffUtc = $null
        if ($olderThanDays -ne $null) {
            $cutoffUtc = $nowUtc.AddDays(-1 * $olderThanDays)
        }

        Write-Log -Level INFO -Message "Evaluating rule '$ruleName' (Action=$action, TargetType=$targetType, Base=$basePath)" -Color Cyan

        $gciParams = @{
            LiteralPath = $basePath
            Force       = $true
            ErrorAction = "SilentlyContinue"
        }
        if ($recurse) { $gciParams.Recurse = $true }
        if ($targetType -eq "File") { $gciParams.File = $true } else { $gciParams.Directory = $true }

        $candidates = @(Get-ChildItem @gciParams)
        if ($candidates.Count -eq 0) {
            Write-Log -Level OK -Message "Rule '$ruleName': no candidates found" -Color Green
            continue
        }

        # Filter includes/excludes
        $filtered = New-Object System.Collections.Generic.List[object]
        foreach ($c in $candidates) {
            if (-not $c) { continue }
            $full = [string]$c.FullName

            if ($excludeGlobs.Count -gt 0 -and (Test-GlobMatch -PathText $full -Globs $excludeGlobs)) { continue }
            if ($includeGlobs.Count -gt 0 -and -not (Test-GlobMatch -PathText $full -Globs $includeGlobs)) { continue }

            if ($cutoffUtc -ne $null) {
                if ($c.LastWriteTimeUtc -ge $cutoffUtc) { continue }
            }

            if ($action -eq "Delete" -and $targetType -eq "Directory" -and $deleteOnlyIfEmpty) {
                # Safety default: only plan deletion for empty directories unless explicitly disabled
                $hasChildren = $false
                try {
                    $firstChild = Get-ChildItem -LiteralPath $full -Force -ErrorAction SilentlyContinue | Select-Object -First 1
                    if ($null -ne $firstChild) { $hasChildren = $true }
                } catch { }
                if ($hasChildren) { continue }
            }

            $filtered.Add($c)
            if ($filtered.Count -ge $maxItems) { break }
        }

        if ($filtered.Count -eq 0) {
            Write-Log -Level OK -Message "Rule '$ruleName': no matches after filters" -Color Green
            continue
        }

        if ($action -eq "Delete") {
            foreach ($f in $filtered) {
                $reason = if ($olderThanDays -ne $null) { "Older than $olderThanDays days" } else { "Matched include patterns" }
                $planItems.Add((New-PlanItem -RuleName $ruleName -Action "Delete" -SourcePath $f.FullName -DestinationPath $null -ReviewRequired $reviewRequired -Reason $reason))
            }
        } elseif ($action -eq "MoveTo") {
            $destBase = Resolve-CleanupPath -PathValue ([string]$rule.destinationPath)
            if ([string]::IsNullOrWhiteSpace($destBase)) {
                Write-Log -Level WARNING -Message "Rule '$ruleName' skipped (destinationPath missing)" -Color Yellow
                continue
            }

            foreach ($f in $filtered) {
                $destination = Join-Path $destBase $f.Name
                $reason = if ($olderThanDays -ne $null) { "Older than $olderThanDays days" } else { "Matched include patterns" }
                $planItems.Add((New-PlanItem -RuleName $ruleName -Action "MoveTo" -SourcePath $f.FullName -DestinationPath $destination -ReviewRequired $reviewRequired -Reason $reason))
            }
        }
    }

    $plan = [PSCustomObject]@{
        generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
        configPath     = $ConfigPath
        rulesEvaluated = $rulesEvaluated
        itemCount      = $planItems.Count
        items          = $planItems
    }

    try {
        $planJson = $plan | ConvertTo-Json -Depth 10
        $planJson | Out-File -FilePath $PlanPath -Encoding UTF8
        Write-Log -Level OK -Message "Plan written: $PlanPath (items=$($planItems.Count))" -Color Green
    } catch {
        Write-Log -Level ERROR -Message "Failed to write plan file: $($_.Exception.Message)" -Color Red
        exit 1
    }

    Write-Log -Level OK -Message "Plan mode complete (no changes made)." -Color Green
    exit 0
}

# APPLY mode uses the existing plan file (so we apply exactly what was reviewed/approved)
if (-not (Test-Path $PlanPath)) {
    Write-Log -Level ERROR -Message "Plan file missing. Generate and review it first: $PlanPath" -Color Red
    exit 1
}

try {
    $planObj = (Get-Content -LiteralPath $PlanPath -Raw -Encoding UTF8) | ConvertFrom-Json -ErrorAction Stop
    $planItems = @($planObj.items)
} catch {
    Write-Log -Level ERROR -Message "Failed to read plan JSON: $($_.Exception.Message)" -Color Red
    exit 1
}

if (-not $planItems -or $planItems.Count -eq 0) {
    Write-Log -Level OK -Message "Plan contains no items. Nothing to apply." -Color Green
    exit 0
}

$nowUtc = (Get-Date).ToUniversalTime()

# APPLY mode (requires approval)
Write-Log -Level INFO -Message "Apply requested. Validating approval file..." -Color Yellow

if (-not (Test-Path $ApprovalPath)) {
    Write-Log -Level ERROR -Message "Approval file missing. Refusing to apply changes: $ApprovalPath" -Color Red
    exit 2
}

try {
    $approvalRaw = Get-Content -LiteralPath $ApprovalPath -Raw -Encoding UTF8
    $approval = $approvalRaw | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-Log -Level ERROR -Message "Failed to read approval file JSON: $($_.Exception.Message)" -Color Red
    exit 2
}

$currentPlanHash = Get-FileSha256 -Path $PlanPath
if (-not $currentPlanHash) {
    Write-Log -Level ERROR -Message "Unable to compute plan hash (plan file unreadable?). Refusing to apply." -Color Red
    exit 2
}

$approvedHash = [string]$approval.planHashSha256
if ([string]::IsNullOrWhiteSpace($approvedHash) -or ($approvedHash.ToLowerInvariant() -ne $currentPlanHash)) {
    Write-Log -Level ERROR -Message "Approval does not match current plan hash. Refusing to apply." -Color Red
    Write-Log -Level INFO -Message "CurrentPlanHash: $currentPlanHash" -Color Cyan
    Write-Log -Level INFO -Message "ApprovedPlanHash: $approvedHash" -Color Cyan
    exit 2
}

try {
    $expiresAtUtc = [DateTime]::Parse([string]$approval.expiresAtUtc).ToUniversalTime()
    if ($nowUtc -ge $expiresAtUtc) {
        Write-Log -Level ERROR -Message "Approval is expired (ExpiresAtUtc=$($expiresAtUtc.ToString('o'))). Refusing to apply." -Color Red
        exit 2
    }
} catch {
    Write-Log -Level ERROR -Message "Invalid expiresAtUtc in approval file. Refusing to apply." -Color Red
    exit 2
}

Write-Log -Level OK -Message "Approval validated. Applying plan items..." -Color Green

$applied = 0
$failed = 0

foreach ($item in $planItems) {
    try {
        if ($item.action -eq "Delete") {
            Remove-Item -LiteralPath $item.source -Force -Recurse -ErrorAction Stop
            $applied++
            Write-Log -Level OK -Message "Deleted: $($item.source)" -Color Green
        } elseif ($item.action -eq "MoveTo") {
            $destDir = Split-Path $item.destination -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            Move-Item -LiteralPath $item.source -Destination $item.destination -Force -ErrorAction Stop
            $applied++
            Write-Log -Level OK -Message "Moved: $($item.source) -> $($item.destination)" -Color Green
        } else {
            Write-Log -Level WARNING -Message "Skipping unknown action: $($item.action) ($($item.source))" -Color Yellow
        }
    } catch {
        $failed++
        Write-Log -Level WARNING -Message "Failed: $($item.action) $($item.source) - $($_.Exception.Message)" -Color Yellow
    }
}

Write-Log -Level INFO -Message "Apply complete. Applied=$applied Failed=$failed" -Color Cyan
if ($failed -gt 0) { exit 3 }
exit 0

