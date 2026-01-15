@echo off
REM Batch file to install Google Gemini CLI v0.22.5
REM This will run the PowerShell installation script with elevated privileges

echo =====================================================
echo   Google Gemini CLI v0.22.5 Installation
echo =====================================================
echo.

echo Running PowerShell installation script...
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-gemini-cli.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installation completed successfully!
) else (
    echo.
    echo Installation failed. Please check the error messages above.
)

echo.
pause
