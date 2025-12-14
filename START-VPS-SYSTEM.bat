@echo off
echo ========================================
echo   Starting VPS Trading System
echo   24/7 Automated Trading Setup
echo ========================================
echo.
echo Requesting administrator privileges...
echo.

cd /d "C:\Users\USER\OneDrive"
powershell.exe -ExecutionPolicy Bypass -File "start-vps-system.ps1"

pause
