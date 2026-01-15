# Prerequisites Validation Script
# Checks all prerequisites and provides detailed feedback

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Prerequisites Validation Check" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$script:issueCount = 0
$script:warningCount = 0

function Test-Prerequisite {
    param(
        [string]$Name,
        [scriptblock]$Test,
        [string]$SuccessMessage,
        [string]$FailureMessage,
        [string]$RecommendedAction,
        [bool]$Required = $true
    )
    
    try {
        $result = & $Test
        if ($result) {
            Write-Host "[OK] " -ForegroundColor Green -NoNewline
            Write-Host "$Name - $SuccessMessage"
            return $true
        } else {
            if ($Required) {
                Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
                Write-Host "$Name - $FailureMessage"
                Write-Host "  → Action: $RecommendedAction" -ForegroundColor Yellow
                $script:issueCount++
            } else {
                Write-Host "[WARNING] " -ForegroundColor Yellow -NoNewline
                Write-Host "$Name - $FailureMessage"
                Write-Host "  → Recommendation: $RecommendedAction" -ForegroundColor Gray
                $script:warningCount++
            }
            return $false
        }
    } catch {
        if ($Required) {
            Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
            Write-Host "$Name - Check failed: $_"
            $script:issueCount++
        } else {
            Write-Host "[WARNING] " -ForegroundColor Yellow -NoNewline
            Write-Host "$Name - Check failed: $_"
            $script:warningCount++
        }
        return $false
    }
}

# Check Windows Version
Write-Host "`n--- Operating System ---" -ForegroundColor Cyan
Test-Prerequisite -Name "Windows Version" -Test {
    $os = Get-CimInstance Win32_OperatingSystem
    $version = [System.Version]$os.Version
    return ($os.Caption -like "*Windows 11*" -or $os.Caption -like "*Windows 10*") -and $version.Build -ge 19041
} -SuccessMessage "Windows 11/10 detected (Build: $((Get-CimInstance Win32_OperatingSystem).BuildNumber))" `
  -FailureMessage "Windows 11 or Windows 10 (Build 19041+) required" `
  -RecommendedAction "Upgrade to Windows 11 or Windows 10 version 2004 or later"

Test-Prerequisite -Name "System Architecture" -Test {
    return (Get-CimInstance Win32_OperatingSystem).OSArchitecture -eq "64-bit"
} -SuccessMessage "64-bit architecture confirmed" `
  -FailureMessage "32-bit system detected" `
  -RecommendedAction "This project requires a 64-bit system"

# Check PowerShell
Write-Host "`n--- PowerShell ---" -ForegroundColor Cyan
Test-Prerequisite -Name "PowerShell Version" -Test {
    return $PSVersionTable.PSVersion.Major -ge 5
} -SuccessMessage "PowerShell $($PSVersionTable.PSVersion) detected" `
  -FailureMessage "PowerShell 5.1 or later required" `
  -RecommendedAction "Update PowerShell from Microsoft"

Test-Prerequisite -Name "Execution Policy" -Test {
    $policy = Get-ExecutionPolicy -Scope CurrentUser
    return $policy -in @("RemoteSigned", "Unrestricted", "Bypass")
} -SuccessMessage "Execution policy allows script execution ($(Get-ExecutionPolicy -Scope CurrentUser))" `
  -FailureMessage "Execution policy blocks scripts" `
  -RecommendedAction "Run: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"

# Check Git
Write-Host "`n--- Git ---" -ForegroundColor Cyan
Test-Prerequisite -Name "Git Installation" -Test {
    $git = Get-Command git -ErrorAction SilentlyContinue
    return $null -ne $git
} -SuccessMessage "Git $(git --version)" `
  -FailureMessage "Git not found in PATH" `
  -RecommendedAction "Install Git from https://git-scm.com/download/win"

Test-Prerequisite -Name "Git Configuration" -Test {
    $userName = git config user.name 2>$null
    $userEmail = git config user.email 2>$null
    return (-not [string]::IsNullOrWhiteSpace($userName)) -and (-not [string]::IsNullOrWhiteSpace($userEmail))
} -SuccessMessage "Git configured ($(git config user.name))" `
  -FailureMessage "Git user not configured" `
  -RecommendedAction "Run: git config --global user.name 'Your Name'; git config --global user.email 'your@email.com'"

# Check GitHub CLI (optional)
Test-Prerequisite -Name "GitHub CLI" -Test {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($null -ne $gh) {
        $authStatus = gh auth status 2>&1
        return $authStatus -like "*Logged in*"
    }
    return $false
} -SuccessMessage "GitHub CLI installed and authenticated" `
  -FailureMessage "GitHub CLI not installed or not authenticated" `
  -RecommendedAction "Install: winget install --id GitHub.cli, then run: gh auth login" `
  -Required $false

# Check Python
Write-Host "`n--- Python ---" -ForegroundColor Cyan
Test-Prerequisite -Name "Python Installation" -Test {
    $python = Get-Command python -ErrorAction SilentlyContinue
    return $null -ne $python
} -SuccessMessage "Python $(python --version 2>&1)" `
  -FailureMessage "Python not found in PATH" `
  -RecommendedAction "Install Python 3.8+ from https://www.python.org/downloads/"

Test-Prerequisite -Name "Python Version" -Test {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($null -ne $python) {
        $versionString = python --version 2>&1 | Out-String
        if ($versionString -match "Python (\d+)\.(\d+)\.(\d+)") {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            return ($major -eq 3 -and $minor -ge 8) -or $major -gt 3
        }
    }
    return $false
} -SuccessMessage "Python 3.8+ confirmed" `
  -FailureMessage "Python 3.8 or later required" `
  -RecommendedAction "Upgrade Python from https://www.python.org/downloads/"

Test-Prerequisite -Name "pip Installation" -Test {
    $pip = Get-Command pip -ErrorAction SilentlyContinue
    return $null -ne $pip
} -SuccessMessage "pip $(pip --version 2>&1 | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value })" `
  -FailureMessage "pip not found" `
  -RecommendedAction "Install pip: python -m ensurepip --upgrade"

# Check Python Virtual Environment
Test-Prerequisite -Name "Virtual Environment Support" -Test {
    $result = python -m venv --help 2>&1
    return $LASTEXITCODE -eq 0
} -SuccessMessage "venv module available" `
  -FailureMessage "venv module not available" `
  -RecommendedAction "Reinstall Python with venv support" `
  -Required $false

# Check Python Dependencies
Write-Host "`n--- Python Dependencies ---" -ForegroundColor Cyan
$requirementsFile = Join-Path $PSScriptRoot "trading-bridge\requirements.txt"
if (Test-Path $requirementsFile) {
    $dependencies = @("zmq", "requests", "dotenv", "cryptography", "schedule")
    foreach ($dep in $dependencies) {
        $packageName = if ($dep -eq "zmq") { "pyzmq" } elseif ($dep -eq "dotenv") { "python-dotenv" } else { $dep }
        $currentDep = $dep  # Create a local copy for use in scriptblock
        Test-Prerequisite -Name "Python package: $packageName" -Test {
            $result = python -c "import $currentDep" 2>&1
            return $LASTEXITCODE -eq 0
        } -SuccessMessage "$packageName installed" `
          -FailureMessage "$packageName not installed" `
          -RecommendedAction "Run: pip install -r trading-bridge\requirements.txt" `
          -Required $false
    }
} else {
    Write-Host "[INFO] Requirements file not found at: $requirementsFile" -ForegroundColor Gray
}

# Check Network Connectivity
Write-Host "`n--- Network ---" -ForegroundColor Cyan
Test-Prerequisite -Name "Internet Connectivity" -Test {
    try {
        $result = Test-NetConnection -ComputerName github.com -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
        return $result
    } catch {
        return $false
    }
} -SuccessMessage "Internet connection active" `
  -FailureMessage "Cannot reach github.com:443" `
  -RecommendedAction "Check internet connection and firewall settings"

Test-Prerequisite -Name "Port 5500 Availability" -Test {
    try {
        $connections = Get-NetTCPConnection -LocalPort 5500 -ErrorAction SilentlyContinue
        return $null -eq $connections
    } catch {
        return $true  # Port is available if no connections found
    }
} -SuccessMessage "Port 5500 available for Trading Bridge" `
  -FailureMessage "Port 5500 is in use" `
  -RecommendedAction "Stop the process using port 5500: netstat -ano | findstr :5500" `
  -Required $false

# Check Cloud Services (optional)
Write-Host "`n--- Cloud Services (Optional) ---" -ForegroundColor Cyan

Test-Prerequisite -Name "OneDrive" -Test {
    $oneDrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
    if (Test-Path $oneDrivePath) {
        $process = Get-Process OneDrive -ErrorAction SilentlyContinue
        return $null -ne $process
    }
    return $false
} -SuccessMessage "OneDrive installed and running" `
  -FailureMessage "OneDrive not running" `
  -RecommendedAction "Start OneDrive from Start menu" `
  -Required $false

Test-Prerequisite -Name "Google Drive" -Test {
    $paths = @(
        "$env:LOCALAPPDATA\Google\Drive File Stream\GoogleDriveFS.exe",
        "$env:PROGRAMFILES\Google\Drive File Stream\GoogleDriveFS.exe"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            $process = Get-Process GoogleDriveFS -ErrorAction SilentlyContinue
            return $null -ne $process
        }
    }
    return $false
} -SuccessMessage "Google Drive installed and running" `
  -FailureMessage "Google Drive not running" `
  -RecommendedAction "Install from https://www.google.com/drive/download/" `
  -Required $false

Test-Prerequisite -Name "Dropbox" -Test {
    $dropboxPath = "$env:LOCALAPPDATA\Dropbox\Dropbox.exe"
    if (Test-Path $dropboxPath) {
        $process = Get-Process Dropbox -ErrorAction SilentlyContinue
        return $null -ne $process
    }
    return $false
} -SuccessMessage "Dropbox installed and running" `
  -FailureMessage "Dropbox not running" `
  -RecommendedAction "Install from https://www.dropbox.com/install" `
  -Required $false

# Check Hardware
Write-Host "`n--- Hardware ---" -ForegroundColor Cyan
$computerSystem = Get-CimInstance Win32_ComputerSystem
$totalRAM = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)

Test-Prerequisite -Name "RAM" -Test {
    return $totalRAM -ge 8
} -SuccessMessage "${totalRAM}GB RAM detected" `
  -FailureMessage "${totalRAM}GB RAM (8GB minimum required)" `
  -RecommendedAction "Upgrade RAM to at least 8GB"

$freeSpace = Get-PSDrive C | Select-Object -ExpandProperty Free
$freeSpaceGB = [math]::Round($freeSpace / 1GB, 2)

Test-Prerequisite -Name "Disk Space" -Test {
    return $freeSpaceGB -ge 50
} -SuccessMessage "${freeSpaceGB}GB free space on C:" `
  -FailureMessage "${freeSpaceGB}GB free space (50GB recommended)" `
  -RecommendedAction "Free up disk space or use external drive" `
  -Required $false

# Check Trading Software (optional)
Write-Host "`n--- Trading Software (Optional) ---" -ForegroundColor Cyan
Test-Prerequisite -Name "MetaTrader 5" -Test {
    $mt5Paths = @(
        "$env:PROGRAMFILES\MetaTrader 5\terminal64.exe",
        "${env:PROGRAMFILES(X86)}\MetaTrader 5\terminal.exe",
        "$env:APPDATA\MetaQuotes\Terminal\*\terminal64.exe"
    )
    foreach ($path in $mt5Paths) {
        if (Test-Path $path) {
            return $true
        }
    }
    return $false
} -SuccessMessage "MetaTrader 5 detected" `
  -FailureMessage "MetaTrader 5 not found" `
  -RecommendedAction "Install from https://www.metatrader5.com/en/download" `
  -Required $false

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Validation Summary" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($script:issueCount -eq 0 -and $script:warningCount -eq 0) {
    Write-Host "✓ All checks passed!" -ForegroundColor Green
    Write-Host "`nYour system meets all requirements." -ForegroundColor Green
    Write-Host "Next step: Run .\complete-device-setup.ps1" -ForegroundColor Cyan
} elseif ($script:issueCount -eq 0) {
    Write-Host "✓ All required checks passed" -ForegroundColor Green
    Write-Host "⚠ $script:warningCount optional feature(s) not available" -ForegroundColor Yellow
    Write-Host "`nYour system meets minimum requirements." -ForegroundColor Green
    Write-Host "Next step: Run .\complete-device-setup.ps1" -ForegroundColor Cyan
} else {
    Write-Host "✗ $script:issueCount critical issue(s) found" -ForegroundColor Red
    if ($script:warningCount -gt 0) {
        Write-Host "⚠ $script:warningCount warning(s)" -ForegroundColor Yellow
    }
    Write-Host "`nPlease resolve the issues above before proceeding." -ForegroundColor Red
    Write-Host "See PREREQUISITES.md for detailed requirements." -ForegroundColor Yellow
}

Write-Host "`nFor more information, see:" -ForegroundColor Gray
Write-Host "  - PREREQUISITES.md" -ForegroundColor Gray
Write-Host "  - HOW-TO-RUN.md" -ForegroundColor Gray
Write-Host "  - README.md" -ForegroundColor Gray

Write-Host ""
