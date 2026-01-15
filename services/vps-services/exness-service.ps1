# Exness Trading Service - Runs 24/7 with MQL5 Forge Integration and USB Support
$ErrorActionPreference = "Continue"
$workspaceRoot = "C:\Users\USER\OneDrive"
$logsPath = "C:\Users\USER\OneDrive\vps-logs"
$usbSupportScript = Join-Path $workspaceRoot "vps-services\usb-support.ps1"
Set-Location $workspaceRoot

# MQL5 Forge Configuration
$mql5RepoUrl = "https://forge.mql5.io/LengKundee/mql5.git"
$mql5RepoPath = Join-Path $workspaceRoot "mql5-repo"
$mql5ConfigFile = Join-Path $workspaceRoot "mql5-config.txt"

# USB Support Configuration
$useUSBForMQL5 = $true  # Enable USB support for MQL5 repository
$usbMQL5Path = $null

# Load MQL5 API Token
$mql5ApiToken = $null
if (Test-Path $mql5ConfigFile) {
    $configContent = Get-Content $mql5ConfigFile -ErrorAction SilentlyContinue
    $tokenLine = $configContent | Where-Object { $_ -match "^MQL5_API=" }
    if ($tokenLine) {
        $mql5ApiToken = ($tokenLine -split "=")[1].Trim()
    }
}

# Initialize USB Support
if ($useUSBForMQL5 -and (Test-Path $usbSupportScript)) {
    try {
        . $usbSupportScript
        $usbDrive = Get-PreferredUSBDrive -MinFreeSpaceGB 5
        if ($usbDrive) {
            $usbMQL5Path = Join-Path $usbDrive.Path "MQL5-Support\mql5-repo"
            Initialize-USBForMQL5 -USBDrivePath $usbDrive.Path | Out-Null
            Write-Host "[$(Get-Date)] USB support initialized: $($usbDrive.DriveLetter)" | Out-File -Append "$logsPath\exness-service.log"
        } else {
            Write-Host "[$(Get-Date)] WARNING: No suitable USB drive found for MQL5 support" | Out-File -Append "$logsPath\exness-service.log"
        }
    } catch {
        Write-Host "[$(Get-Date)] WARNING: USB support initialization failed: $_" | Out-File -Append "$logsPath\exness-service.log"
    }
}

# Function to sync MQL5 Forge repository
function Sync-MQL5Repository {
    try {
        if (Test-Path $mql5RepoPath) {
            Write-Host "[$(Get-Date)] Pulling MQL5 repository updates..." | Out-File -Append "$logsPath\exness-service.log"
            Set-Location $mql5RepoPath
            
            # Configure git with token if available
            if ($mql5ApiToken) {
                $repoUrlWithToken = $mql5RepoUrl -replace "https://", "https://$mql5ApiToken@"
                git remote set-url origin $repoUrlWithToken 2>&1 | Out-Null
            }
            
            git pull origin main 2>&1 | Out-File -Append "$logsPath\exness-service.log"
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$(Get-Date)] MQL5 repository updated successfully" | Out-File -Append "$logsPath\exness-service.log"
                
                # Sync to USB if available
                if ($useUSBForMQL5 -and $usbMQL5Path -and (Test-Path $mql5RepoPath)) {
                    try {
                        Sync-MQL5ToUSB -SourceRepoPath $mql5RepoPath -USBDestinationPath $usbMQL5Path | Out-Null
                        Write-Host "[$(Get-Date)] MQL5 repository synced to USB" | Out-File -Append "$logsPath\exness-service.log"
                    } catch {
                        Write-Host "[$(Get-Date)] WARNING: USB sync failed: $_" | Out-File -Append "$logsPath\exness-service.log"
                    }
                }
            }
            else {
                Write-Host "[$(Get-Date)] WARNING: Could not pull MQL5 updates" | Out-File -Append "$logsPath\exness-service.log"
            }
        }
        else {
            Write-Host "[$(Get-Date)] Cloning MQL5 repository..." | Out-File -Append "$logsPath\exness-service.log"
            Set-Location $workspaceRoot
            
            # Clone with token if available
            if ($mql5ApiToken) {
                $repoUrlWithToken = $mql5RepoUrl -replace "https://", "https://$mql5ApiToken@"
                git clone $repoUrlWithToken $mql5RepoPath 2>&1 | Out-File -Append "$logsPath\exness-service.log"
            }
            else {
                git clone $mql5RepoUrl $mql5RepoPath 2>&1 | Out-File -Append "$logsPath\exness-service.log"
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[$(Get-Date)] MQL5 repository cloned successfully" | Out-File -Append "$logsPath\exness-service.log"
                
                # Sync to USB if available
                if ($useUSBForMQL5 -and $usbMQL5Path -and (Test-Path $mql5RepoPath)) {
                    try {
                        Sync-MQL5ToUSB -SourceRepoPath $mql5RepoPath -USBDestinationPath $usbMQL5Path | Out-Null
                        Write-Host "[$(Get-Date)] MQL5 repository synced to USB" | Out-File -Append "$logsPath\exness-service.log"
                    } catch {
                        Write-Host "[$(Get-Date)] WARNING: USB sync failed: $_" | Out-File -Append "$logsPath\exness-service.log"
                    }
                }
            }
            else {
                Write-Host "[$(Get-Date)] ERROR: Failed to clone MQL5 repository" | Out-File -Append "$logsPath\exness-service.log"
            }
        }
    }
    catch {
        Write-Host "[$(Get-Date)] ERROR: MQL5 repository sync failed: $_" | Out-File -Append "$logsPath\exness-service.log"
    }
}

# Initial MQL5 repository sync
Sync-MQL5Repository

# Launch Exness Terminal
$exnessPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
if (Test-Path $exnessPath) {
    $process = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
    if (-not $process) {
        Start-Process -FilePath $exnessPath
        Start-Sleep -Seconds 5
        Write-Host "[$(Get-Date)] Exness Terminal started" | Out-File -Append "$logsPath\exness-service.log"
    }
}
else {
    Write-Host "[$(Get-Date)] ERROR: Exness Terminal not found" | Out-File -Append "$logsPath\exness-service.log"
}

# Keep service running
$syncCounter = 0
while ($true) {
    $process = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
    if (-not $process) {
        Start-Process -FilePath $exnessPath
        Write-Host "[$(Get-Date)] Restarted Exness Terminal" | Out-File -Append "$logsPath\exness-service.log"
    }
    
    # Sync MQL5 repository every hour (12 times per 5-minute cycle)
    $syncCounter++
    if ($syncCounter -ge 12) {
        Sync-MQL5Repository
        $syncCounter = 0
    }
    
    Start-Sleep -Seconds 300  # Check every 5 minutes
}
