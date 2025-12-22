@echo off
REM Setup GitHub Secrets - Windows Batch Wrapper
REM This script runs the PowerShell setup script with administrator privileges

echo ========================================
echo GitHub Secrets Setup
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with administrator privileges
    echo.
) else (
    echo [INFO] Requesting administrator privileges...
    echo.
    REM Re-run with administrator privileges
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Run the PowerShell script
echo [INFO] Starting GitHub Secrets setup...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0setup-github-secrets.ps1"

REM Check result
if %errorLevel% == 0 (
    echo.
    echo ========================================
    echo [SUCCESS] Setup completed successfully!
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [ERROR] Setup encountered errors
    echo ========================================
)

echo.
echo Press any key to exit...
pause >nul
