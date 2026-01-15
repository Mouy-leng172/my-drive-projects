@echo off
REM Quick Start - First Time Setup
REM This batch file provides an easy entry point for new users

echo.
echo ========================================
echo    A6-9V Project Quick Start
echo ========================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Not running as Administrator
    echo Some features may not work properly.
    echo.
    echo Right-click this file and select "Run as Administrator"
    echo Or press any key to continue anyway...
    pause >nul
    echo.
)

REM Navigate to script directory
cd /d "%~dp0"

echo [INFO] Starting Quick Start Setup...
echo.

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell is available' -ForegroundColor Green" >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] PowerShell not found!
    echo Please ensure PowerShell is installed.
    pause
    exit /b 1
)

REM Run the PowerShell quick start script
echo [INFO] Launching interactive setup wizard...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0quick-start.ps1"

if %errorLevel% equ 0 (
    echo.
    echo ========================================
    echo    Setup Complete!
    echo ========================================
    echo.
    echo Next steps:
    echo 1. Review the setup results above
    echo 2. Read HOW-TO-RUN.md for detailed instructions
    echo 3. Run validate-setup.ps1 to verify everything works
    echo.
) else (
    echo.
    echo ========================================
    echo    Setup encountered issues
    echo ========================================
    echo.
    echo Please check the messages above for details.
    echo See TROUBLESHOOTING.md for help.
    echo.
)

echo Press any key to exit...
pause >nul
