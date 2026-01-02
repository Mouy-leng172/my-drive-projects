# Quick Start Script for First-Time Users
# Provides an interactive setup experience

# Requires Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[ERROR] This script requires Administrator privileges" -ForegroundColor Red
    Write-Host "Please right-click and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host @"

============================================================
                                                            
       Welcome to A6-9V/my-drive-projects Setup            
                                                            
       This script will guide you through the               
       initial setup process.                               
                                                            
============================================================

"@ -ForegroundColor Cyan

Write-Host "Starting quick setup process...`n" -ForegroundColor Green

# Function to display status
function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    $color = switch ($Type) {
        "Success" { "Green" }
        "Error" { "Red" }
        "Warning" { "Yellow" }
        "Info" { "Cyan" }
        default { "White" }
    }
    
    $prefix = switch ($Type) {
        "Success" { "[✓]" }
        "Error" { "[✗]" }
        "Warning" { "[!]" }
        "Info" { "[i]" }
        default { "[ ]" }
    }
    
    Write-Host "$prefix $Message" -ForegroundColor $color
}

# Step 1: Run prerequisites check
Write-Host "`n═══ Step 1: Checking Prerequisites ═══`n" -ForegroundColor Cyan

if (Test-Path "$PSScriptRoot\validate-setup.ps1") {
    Write-Status "Running prerequisites validation..." "Info"
    & "$PSScriptRoot\validate-setup.ps1"
    
    Write-Host "`nDo you want to continue with setup? (Y/N): " -ForegroundColor Yellow -NoNewline
    $continue = Read-Host
    
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-Status "Setup cancelled by user" "Warning"
        exit 0
    }
} else {
    Write-Status "Validation script not found, proceeding with setup..." "Warning"
}

# Step 2: Choose setup type
Write-Host "`n═══ Step 2: Choose Setup Type ═══`n" -ForegroundColor Cyan

Write-Host "What would you like to set up?`n"
Write-Host "1. Complete Setup (Windows + Git + Trading) - Recommended for first-time users"
Write-Host "2. Windows Automation Only (Cloud sync, security, automation)"
Write-Host "3. Development Environment Only (Git, Python, workspace)"
Write-Host "4. Trading System Only (Requires existing development setup)"
Write-Host "5. Custom Setup (Choose specific components)"
Write-Host "6. Exit"
Write-Host ""

$choice = Read-Host "Enter your choice (1-6)"

switch ($choice) {
    "1" {
        Write-Host "`n[Selected] Complete Setup" -ForegroundColor Green
        
        # Run complete device setup
        Write-Host "`n═══ Step 3: Running Complete Setup ═══`n" -ForegroundColor Cyan
        
        if (Test-Path "$PSScriptRoot\complete-device-setup.ps1") {
            Write-Status "Starting complete device setup..." "Info"
            & "$PSScriptRoot\complete-device-setup.ps1"
        } else {
            Write-Status "Complete setup script not found!" "Error"
            Write-Status "Running alternative setup..." "Warning"
            
            # Run individual components
            if (Test-Path "$PSScriptRoot\complete-windows-setup.ps1") {
                Write-Status "Setting up Windows..." "Info"
                & "$PSScriptRoot\complete-windows-setup.ps1"
            }
            
            if (Test-Path "$PSScriptRoot\git-setup.ps1") {
                Write-Status "Setting up Git..." "Info"
                & "$PSScriptRoot\git-setup.ps1"
            }
        }
    }
    
    "2" {
        Write-Host "`n[Selected] Windows Automation Only" -ForegroundColor Green
        
        Write-Host "`n═══ Step 3: Setting Up Windows Automation ═══`n" -ForegroundColor Cyan
        
        if (Test-Path "$PSScriptRoot\complete-windows-setup.ps1") {
            Write-Status "Starting Windows setup..." "Info"
            & "$PSScriptRoot\complete-windows-setup.ps1"
        } else {
            Write-Status "Windows setup script not found!" "Error"
        }
        
        if (Test-Path "$PSScriptRoot\setup-cloud-sync.ps1") {
            Write-Status "Setting up cloud sync..." "Info"
            & "$PSScriptRoot\setup-cloud-sync.ps1"
        }
    }
    
    "3" {
        Write-Host "`n[Selected] Development Environment Only" -ForegroundColor Green
        
        Write-Host "`n═══ Step 3: Setting Up Development Environment ═══`n" -ForegroundColor Cyan
        
        # Set up Git
        if (Test-Path "$PSScriptRoot\git-setup.ps1") {
            Write-Status "Setting up Git..." "Info"
            & "$PSScriptRoot\git-setup.ps1"
        }
        
        # Set up workspace
        if (Test-Path "$PSScriptRoot\setup-workspace.ps1") {
            Write-Status "Setting up workspace..." "Info"
            & "$PSScriptRoot\setup-workspace.ps1"
        }
        
        # Set up Python environment
        Write-Status "Setting up Python virtual environment..." "Info"
        try {
            python -m venv venv
            Write-Status "Virtual environment created" "Success"
            
            Write-Host "`nInstall Python dependencies now? (Y/N): " -ForegroundColor Yellow -NoNewline
            $installDeps = Read-Host
            
            if ($installDeps -eq "Y" -or $installDeps -eq "y") {
                if (Test-Path "$PSScriptRoot\trading-bridge\requirements.txt") {
                    & "$PSScriptRoot\venv\Scripts\Activate.ps1"
                    pip install -r "$PSScriptRoot\trading-bridge\requirements.txt"
                    Write-Status "Python dependencies installed" "Success"
                }
            }
        } catch {
            Write-Status "Failed to create virtual environment: $_" "Error"
        }
    }
    
    "4" {
        Write-Host "`n[Selected] Trading System Only" -ForegroundColor Green
        
        Write-Host "`n═══ Step 3: Setting Up Trading System ═══`n" -ForegroundColor Cyan
        
        # Check if Python dependencies are installed
        $pythonCheck = python -c "import zmq, requests" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Status "Python dependencies not installed!" "Warning"
            Write-Host "Installing trading-bridge dependencies..." -ForegroundColor Yellow
            
            if (Test-Path "$PSScriptRoot\trading-bridge\requirements.txt") {
                pip install -r "$PSScriptRoot\trading-bridge\requirements.txt"
            }
        }
        
        # Set up trading system
        if (Test-Path "$PSScriptRoot\setup-trading-system.ps1") {
            Write-Status "Setting up trading system..." "Info"
            & "$PSScriptRoot\setup-trading-system.ps1"
        } else {
            Write-Status "Trading setup script not found!" "Error"
        }
        
        Write-Host "`n[IMPORTANT] Don't forget to configure:" -ForegroundColor Yellow
        Write-Host "  1. trading-bridge\config\brokers.json (API keys)" -ForegroundColor Gray
        Write-Host "  2. trading-bridge\config\symbols.json (trading symbols)" -ForegroundColor Gray
    }
    
    "5" {
        Write-Host "`n[Selected] Custom Setup" -ForegroundColor Green
        
        Write-Host "`n═══ Step 3: Custom Component Setup ═══`n" -ForegroundColor Cyan
        
        Write-Host "Select components to set up (Y/N for each):`n"
        
        # Windows Setup
        Write-Host "Windows automation and configuration? (Y/N): " -ForegroundColor Cyan -NoNewline
        if ((Read-Host) -match "^[Yy]") {
            if (Test-Path "$PSScriptRoot\complete-windows-setup.ps1") {
                & "$PSScriptRoot\complete-windows-setup.ps1"
            }
        }
        
        # Cloud Sync
        Write-Host "Cloud sync services? (Y/N): " -ForegroundColor Cyan -NoNewline
        if ((Read-Host) -match "^[Yy]") {
            if (Test-Path "$PSScriptRoot\setup-cloud-sync.ps1") {
                & "$PSScriptRoot\setup-cloud-sync.ps1"
            }
        }
        
        # Git Setup
        Write-Host "Git and repository setup? (Y/N): " -ForegroundColor Cyan -NoNewline
        if ((Read-Host) -match "^[Yy]") {
            if (Test-Path "$PSScriptRoot\git-setup.ps1") {
                & "$PSScriptRoot\git-setup.ps1"
            }
        }
        
        # Auto-startup
        Write-Host "Auto-startup configuration? (Y/N): " -ForegroundColor Cyan -NoNewline
        if ((Read-Host) -match "^[Yy]") {
            if (Test-Path "$PSScriptRoot\setup-auto-startup-admin.ps1") {
                & "$PSScriptRoot\setup-auto-startup-admin.ps1"
            }
        }
        
        # Trading System
        Write-Host "Trading system? (Y/N): " -ForegroundColor Cyan -NoNewline
        if ((Read-Host) -match "^[Yy]") {
            if (Test-Path "$PSScriptRoot\setup-trading-system.ps1") {
                & "$PSScriptRoot\setup-trading-system.ps1"
            }
        }
    }
    
    "6" {
        Write-Status "Setup cancelled" "Warning"
        exit 0
    }
    
    default {
        Write-Status "Invalid choice" "Error"
        exit 1
    }
}

# Step 4: Post-setup tasks
Write-Host "`n═══ Step 4: Post-Setup Configuration ═══`n" -ForegroundColor Cyan

Write-Host "Would you like to:" -ForegroundColor Cyan
Write-Host "1. Run security check"
Write-Host "2. Set up auto-merge (GitHub PR automation)"
Write-Host "3. Create backup configuration"
Write-Host "4. Skip post-setup tasks"
Write-Host ""

$postChoice = Read-Host "Enter your choice (1-4)"

switch ($postChoice) {
    "1" {
        if (Test-Path "$PSScriptRoot\security-check.ps1") {
            Write-Status "Running security check..." "Info"
            & "$PSScriptRoot\security-check.ps1"
        }
    }
    "2" {
        if (Test-Path "$PSScriptRoot\setup-auto-merge.ps1") {
            Write-Status "Setting up auto-merge..." "Info"
            & "$PSScriptRoot\setup-auto-merge.ps1"
        }
    }
    "3" {
        if (Test-Path "$PSScriptRoot\backup-to-usb.ps1") {
            Write-Status "Configuring backup..." "Info"
            & "$PSScriptRoot\backup-to-usb.ps1"
        }
    }
    "4" {
        Write-Status "Skipping post-setup tasks" "Info"
    }
}

# Step 5: Summary and Next Steps
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "||                                    ||" -ForegroundColor Green
Write-Host "||          Setup Complete!           ||" -ForegroundColor Green
Write-Host "||                                    ||" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Review the setup by running:" -ForegroundColor White
Write-Host "   .\setup-workspace.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "2. For detailed documentation, see:" -ForegroundColor White
Write-Host "   - HOW-TO-RUN.md (comprehensive guide)" -ForegroundColor Gray
Write-Host "   - README.md (project overview)" -ForegroundColor Gray
Write-Host "   - PREREQUISITES.md (system requirements)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. To start specific systems:" -ForegroundColor White
Write-Host "   - Trading: .\start-trading-system-admin.ps1" -ForegroundColor Gray
Write-Host "   - VPS: .\auto-start-vps-admin.ps1" -ForegroundColor Gray
Write-Host "   - MQL.io: .\start-mql-io-service.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "4. For troubleshooting:" -ForegroundColor White
Write-Host "   - Run: .\validate-setup.ps1" -ForegroundColor Gray
Write-Host "   - Check: .\system-status-report.ps1" -ForegroundColor Gray
Write-Host ""

Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Press Enter to exit..." -ForegroundColor Gray
Read-Host
