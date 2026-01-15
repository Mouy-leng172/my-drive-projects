@echo off
REM Setup My Drive Projects Forks
REM Automated fork setup for ZOLO-A6-9VxNUNA- and MQL5-Google-Onedrive

echo ========================================
echo   My Drive Projects - Fork Setup
echo ========================================
echo.

cd /d "%~dp0"

REM Check if PowerShell is available
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PowerShell is not available
    pause
    exit /b 1
)

REM Run the setup script
echo [INFO] Running fork setup script...
powershell -ExecutionPolicy Bypass -File "%~dp0setup-forks.ps1"

echo.
echo ========================================
echo   Setup Complete
echo ========================================
echo.

pause
