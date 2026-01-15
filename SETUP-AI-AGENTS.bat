@echo off
REM SETUP-AI-AGENTS.bat
REM Launcher for AI Agents and Automation Setup

echo ========================================
echo   AI Agents and Automation Setup
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running as Administrator
    echo.
) else (
    echo [WARNING] Not running as Administrator
    echo Some features may require admin privileges.
    echo.
)

REM Run PowerShell setup script
PowerShell -ExecutionPolicy Bypass -File "%~dp0setup-ai-agents-and-automation.ps1"

if %errorLevel% == 0 (
    echo.
    echo [OK] Setup completed successfully!
) else (
    echo.
    echo [ERROR] Setup encountered errors. Check output above.
)

echo.
echo Press any key to exit...
pause >nul
