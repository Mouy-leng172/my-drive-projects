@echo off
REM Fork awesome-selfhosted and Update References - Quick Start
REM This batch file provides an easy way to run the fork and update process

echo =========================================
echo Fork awesome-selfhosted Quick Start
echo =========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges
) else (
    echo Note: Not running as administrator
    echo Some operations may require elevated privileges
)

echo.
echo This will:
echo 1. Fork awesome-selfhosted/awesome-selfhosted to A6-9V
echo 2. Update references in mouyleng/GenX_FX
echo 3. Update references in A6-9V/MQL5-Google-Onedrive
echo.

pause

echo.
echo =========================================
echo Step 1: Forking Repository
echo =========================================
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0fork-awesome-selfhosted.ps1"

if %errorLevel% neq 0 (
    echo.
    echo ERROR: Fork failed with exit code %errorLevel%
    echo Please check the error messages above
    pause
    exit /b %errorLevel%
)

echo.
echo =========================================
echo Step 2: Updating References
echo =========================================
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0update-repo-references.ps1"

if %errorLevel% neq 0 (
    echo.
    echo ERROR: Update failed with exit code %errorLevel%
    echo Please check the error messages above
    pause
    exit /b %errorLevel%
)

echo.
echo =========================================
echo Process Complete!
echo =========================================
echo.
echo All operations completed successfully.
echo.
echo Next steps:
echo 1. Review the generated summary files
echo 2. Check pull requests in target repositories
echo 3. Merge pull requests after review
echo.

pause
