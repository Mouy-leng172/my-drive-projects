@echo off
REM Start OpenBB Analytics Service
REM Double-click this file to start the OpenBB Platform service

echo Starting OpenBB Analytics Service...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0start-openbb-service.ps1"
pause
