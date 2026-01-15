@echo off
REM Quick Start Script for Trading Bridge Docker Container
REM Run as Administrator: docker-quick-start.bat

echo ============================================
echo Trading Bridge Docker Quick Start
echo ============================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo [OK] Docker is installed

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo [OK] Docker is running

REM Check if .env exists
if not exist .env (
    echo.
    echo [INFO] Creating .env file from .env.example...
    copy .env.example .env
    
    REM Generate a secure random API key using PowerShell
    powershell -Command "$bytes = New-Object byte[] 32; (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes); $apiKey = [Convert]::ToBase64String($bytes); (Get-Content .env) -replace 'dev-key-change-me', $apiKey | Set-Content .env"
    echo [OK] Generated secure API key
)

echo [OK] Environment file configured

REM Check if config files exist
if not exist trading-bridge\config\brokers.json (
    echo.
    echo [INFO] Creating default broker configuration...
    copy trading-bridge\config\brokers.json.example trading-bridge\config\brokers.json
    echo [WARNING] Please edit trading-bridge\config\brokers.json with your broker credentials
)

if not exist trading-bridge\config\symbols.json (
    echo.
    echo [INFO] Creating default symbols configuration...
    copy trading-bridge\config\symbols.json.example trading-bridge\config\symbols.json
)

echo [OK] Configuration files ready

REM Build and start containers
echo.
echo [INFO] Building and starting Docker containers...
docker-compose up -d --build

REM Wait for container to be healthy
echo.
echo [INFO] Waiting for container to be ready...
timeout /t 5 /nobreak >nul

REM Check health
set RETRY_COUNT=0
:health_check
if %RETRY_COUNT% GEQ 12 goto health_timeout

curl -s http://localhost:8000/health >nul 2>&1
if errorlevel 1 (
    set /a RETRY_COUNT+=1
    echo    Waiting... (%RETRY_COUNT%/12)
    timeout /t 5 /nobreak >nul
    goto health_check
)

echo [OK] Container is healthy!
goto show_status

:health_timeout
echo [WARNING] Container may not be fully ready yet. Check logs with: docker-compose logs

:show_status
REM Show status
echo.
echo ============================================
echo     Trading Bridge is running!
echo ============================================
echo.
echo API Dashboard:  http://localhost:8000/docs
echo Health Check:   http://localhost:8000/health
echo Documentation:  http://localhost:8000/redoc
echo.
echo Your API Key is in: .env
echo    (TRADING_BRIDGE_API_KEY)
echo.
echo Useful Commands:
echo    View logs:      docker-compose logs -f
echo    Stop:           docker-compose down
echo    Restart:        docker-compose restart
echo    Status:         docker-compose ps
echo.
echo Full guide: DOCKER-DEPLOYMENT-GUIDE.md
echo.

REM Test API
echo [INFO] Testing API...
curl -s http://localhost:8000/health
echo.
echo.

REM Display API key
echo Your API Key:
findstr "TRADING_BRIDGE_API_KEY=" .env
echo.

echo [OK] Setup complete! Visit http://localhost:8000/docs to explore the API
echo.
pause
