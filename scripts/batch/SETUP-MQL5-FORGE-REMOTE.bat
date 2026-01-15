@echo off
REM Setup MQL5 Forge Remote for Current Repository
REM This batch file launches the PowerShell script to configure MQL5 Forge remote

echo ========================================
echo   Setup MQL5 Forge Remote
echo ========================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] PowerShell is not installed or not in PATH
    pause
    exit /b 1
)

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0setup-mql5-forge-remote.ps1"

echo.
echo Press any key to exit...
pause >nul
