@echo off
REM Setup Web-Dev-For-Beginners Fork Integration
REM This batch file runs the PowerShell setup script with administrator privileges

echo.
echo === Web-Dev-For-Beginners Fork Setup ===
echo.
echo This will set up the Microsoft Web-Dev-For-Beginners fork integration.
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
    echo.
    
    REM Run the PowerShell script
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-web-dev-fork.ps1" -Method reference-only
    
    echo.
    echo Setup complete! Check the output above for details.
    echo.
    pause
) else (
    echo This script requires administrator privileges.
    echo Right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)
