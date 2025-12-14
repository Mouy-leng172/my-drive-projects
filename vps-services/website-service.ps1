# GitHub Website Service - ZOLO-A6-9VxNUNA
$ErrorActionPreference = "Continue"
$workspaceRoot = "C:\Users\USER\OneDrive"
$websitePath = "$workspaceRoot\ZOLO-A6-9VxNUNA"
$logsPath = "C:\Users\USER\OneDrive\vps-logs"

# Clone or update repository
if (-not (Test-Path $websitePath)) {
    Write-Host "[$(Get-Date)] Cloning ZOLO-A6-9VxNUNA repository..." | Out-File -Append "$logsPath\website-service.log"
    Set-Location $workspaceRoot
    # Use HTTPS (works without SSH keys)
    git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git $websitePath 2>&1 | Out-File -Append "$logsPath\website-service.log"
} else {
    Write-Host "[$(Get-Date)] Updating ZOLO-A6-9VxNUNA repository..." | Out-File -Append "$logsPath\website-service.log"
    Set-Location $websitePath
    # Update remote to HTTPS if needed
    $remoteUrl = git remote get-url origin 2>&1
    if ($remoteUrl -like "*git@github.com*") {
        git remote set-url origin https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git 2>&1 | Out-Null
    }
    # Try pull, if fails due to unrelated histories, use allow-unrelated-histories
    git pull origin main --allow-unrelated-histories 2>&1 | Out-File -Append "$logsPath\website-service.log"
    if ($LASTEXITCODE -ne 0) {
        git pull origin main 2>&1 | Out-File -Append "$logsPath\website-service.log"
    }
}

# Launch website in Firefox
$firefoxPath = Get-Command firefox -ErrorAction SilentlyContinue
if (-not $firefoxPath) {
    $firefoxPaths = @(
        "C:\Program Files\Mozilla Firefox\firefox.exe",
        "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
    )
    foreach ($path in $firefoxPaths) {
        if (Test-Path $path) {
            $firefoxPath = $path
            break
        }
    }
} else {
    $firefoxPath = $firefoxPath.Source
}

if ($firefoxPath) {
    # Check if local server is running, if not start it
    $pythonPath = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonPath) {
        Set-Location $websitePath
        # Try to start Python web server
        Start-Process python -ArgumentList "-m", "http.server", "8000" -WindowStyle Hidden
        Start-Sleep -Seconds 2
        Start-Process -FilePath $firefoxPath -ArgumentList "http://localhost:8000"
        Write-Host "[$(Get-Date)] Website launched in Firefox" | Out-File -Append "$logsPath\website-service.log"
    }
}

# Keep service running
while ($true) {
    Start-Sleep -Seconds 3600  # Check every hour
    Set-Location $websitePath
    git pull origin main 2>&1 | Out-File -Append "$logsPath\website-service.log"
}
