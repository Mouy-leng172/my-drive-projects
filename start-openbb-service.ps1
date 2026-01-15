# Start OpenBB Analytics Service
#
# This script starts the OpenBB Platform service using Docker Compose
# Part of the my-drive-projects OpenBB integration
#

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OpenBB Analytics Service Starter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Docker is not installed or not in PATH" -ForegroundColor Red
        Write-Host "Please install Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "[OK] Docker found: $dockerVersion" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed to check Docker: $_" -ForegroundColor Red
    exit 1
}

# Check if Docker is running
try {
    docker ps 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Docker is not running" -ForegroundColor Red
        Write-Host "Please start Docker Desktop" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "[OK] Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Docker is not running: $_" -ForegroundColor Red
    exit 1
}

# Navigate to docker directory
$dockerDir = Join-Path $PSScriptRoot "docker"
if (-not (Test-Path $dockerDir)) {
    Write-Host "[ERROR] Docker directory not found: $dockerDir" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Navigating to docker directory..." -ForegroundColor Cyan
Set-Location $dockerDir

# Check if docker-compose.yml exists
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "[ERROR] docker-compose.yml not found" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Starting OpenBB service with Docker Compose..." -ForegroundColor Cyan

try {
    # Start only the OpenBB service
    docker-compose up -d openbb
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] OpenBB service started successfully" -ForegroundColor Green
        Write-Host ""
        Write-Host "Waiting for service to be ready..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        
        # Check service health
        Write-Host ""
        Write-Host "Checking service health..." -ForegroundColor Cyan
        $healthCheck = curl -s http://localhost:8000/health 2>&1
        
        if ($?) {
            Write-Host "[OK] OpenBB service is healthy!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Service Details:" -ForegroundColor Cyan
            Write-Host "  - API URL: http://localhost:8000" -ForegroundColor White
            Write-Host "  - Health: http://localhost:8000/health" -ForegroundColor White
            Write-Host "  - Docs: http://localhost:8000/docs" -ForegroundColor White
            Write-Host ""
            Write-Host "View logs with: docker logs openbb-service" -ForegroundColor Yellow
            Write-Host "Stop service with: docker-compose down" -ForegroundColor Yellow
        }
        else {
            Write-Host "[WARNING] Service started but health check failed" -ForegroundColor Yellow
            Write-Host "The service may still be starting up. Check logs with:" -ForegroundColor Yellow
            Write-Host "  docker logs openbb-service" -ForegroundColor White
        }
    }
    else {
        Write-Host "[ERROR] Failed to start OpenBB service" -ForegroundColor Red
        Write-Host "Check logs with: docker-compose logs openbb" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "[ERROR] Failed to start service: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OpenBB Service Started Successfully" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
