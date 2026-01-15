# Trading System Heartbeat Service - Runs 24/7
# Writes a small heartbeat file + log entry on an interval so you can verify the system is alive.

$ErrorActionPreference = "Continue"

function Resolve-WorkspaceRoot {
    # Prefer OneDrive workspace used by the rest of this repo, but fall back safely.
    try {
        if ($env:OneDrive -and (Test-Path $env:OneDrive)) { return $env:OneDrive }
    } catch { }

    try {
        if ($env:USERPROFILE) {
            $oneDriveCandidate = Join-Path $env:USERPROFILE "OneDrive"
            if (Test-Path $oneDriveCandidate) { return $oneDriveCandidate }
            if (Test-Path $env:USERPROFILE) { return $env:USERPROFILE }
        }
    } catch { }

    return $PSScriptRoot
}

$workspaceRoot = Resolve-WorkspaceRoot
$logsPath = Join-Path $workspaceRoot "vps-logs"

try {
    if (-not (Test-Path $logsPath)) {
        New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
    }
} catch { }

$heartbeatFile = Join-Path $logsPath "trading-system-heartbeat.json"
$heartbeatLog = Join-Path $logsPath "trading-heartbeat.log"

function Write-Heartbeat {
    param([string]$Status = "RUNNING")

    $payload = [ordered]@{
        timestamp = (Get-Date).ToString("o")
        status    = $Status
        pid       = $PID
        hostname  = $env:COMPUTERNAME
        user      = $env:USERNAME
    }

    try {
        ($payload | ConvertTo-Json -Depth 3) | Out-File -FilePath $heartbeatFile -Encoding UTF8 -Force
        Write-Host "[$(Get-Date)] Heartbeat: $Status" | Out-File -Append $heartbeatLog
    } catch {
        # Avoid crashing the service if the disk is temporarily unavailable.
        try {
            Write-Host "[$(Get-Date)] WARNING: Heartbeat write failed: $_" | Out-File -Append $heartbeatLog
        } catch { }
    }
}

# Initial heartbeat
Write-Heartbeat -Status "STARTED"

# Keep service running
while ($true) {
    Write-Heartbeat -Status "RUNNING"
    Start-Sleep -Seconds 30
}

