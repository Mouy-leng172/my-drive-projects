#Requires -RunAsAdministrator
# Master Service Controller - Manages all 24/7 services
$ErrorActionPreference = "Continue"
$workspaceRoot = "C:\Users\USER\OneDrive"
$vpsServicesPath = "C:\Users\USER\OneDrive\vps-services"
$logsPath = "C:\Users\USER\OneDrive\vps-logs"

function Start-VPSService {
    param([string]$ServiceName, [string]$ScriptPath)
    
    $process = Get-Process -Name "powershell" -ErrorAction SilentlyContinue | 
        Where-Object { $_.CommandLine -like "*$ServiceName*" }
    
    if (-not $process) {
        Start-Process powershell.exe -ArgumentList @(
            "-ExecutionPolicy", "Bypass",
            "-WindowStyle", "Hidden",
            "-File", $ScriptPath
        ) -WindowStyle Hidden
        Write-Host "[$(Get-Date)] Started service: $ServiceName" | Out-File -Append "$logsPath\master-controller.log"
    }
}

# Start all services
Start-VPSService -ServiceName "exness-service" -ScriptPath "$vpsServicesPath\exness-service.ps1"
Start-Sleep -Seconds 2

Start-VPSService -ServiceName "research-service" -ScriptPath "$vpsServicesPath\research-service.ps1"
Start-Sleep -Seconds 2

Start-VPSService -ServiceName "website-service" -ScriptPath "$vpsServicesPath\website-service.ps1"
Start-Sleep -Seconds 2

Start-VPSService -ServiceName "cicd-service" -ScriptPath "$vpsServicesPath\cicd-service.ps1"
Start-Sleep -Seconds 2

Start-VPSService -ServiceName "mql5-service" -ScriptPath "$vpsServicesPath\mql5-service.ps1"

Write-Host "[$(Get-Date)] All services started" | Out-File -Append "$logsPath\master-controller.log"

# Monitor services
while ($true) {
    Start-Sleep -Seconds 300  # Check every 5 minutes
    # Restart any stopped services
    Start-VPSService -ServiceName "exness-service" -ScriptPath "$vpsServicesPath\exness-service.ps1"
    Start-VPSService -ServiceName "research-service" -ScriptPath "$vpsServicesPath\research-service.ps1"
    Start-VPSService -ServiceName "website-service" -ScriptPath "$vpsServicesPath\website-service.ps1"
    Start-VPSService -ServiceName "cicd-service" -ScriptPath "$vpsServicesPath\cicd-service.ps1"
    Start-VPSService -ServiceName "mql5-service" -ScriptPath "$vpsServicesPath\mql5-service.ps1"
}
