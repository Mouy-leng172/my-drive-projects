#Requires -Version 5.1
<#
.SYNOPSIS
    Test Bitget network connectivity and latency
.DESCRIPTION
    Tests connection to Bitget API endpoints and measures latency
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bitget Network Connectivity Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Bitget API endpoints
$networks = @{
    "Network-1" = "https://api.bitget.com"
    "Network-2" = "https://api.bitget.com"
    "Automatic" = "https://api.bitget.com"
}

Write-Host "[INFO] Testing Bitget API endpoints..." -ForegroundColor Yellow
Write-Host ""

$results = @()

foreach ($network in $networks.GetEnumerator()) {
    $networkName = $network.Key
    $endpoint = $network.Value
    
    Write-Host "Testing $networkName ($endpoint)..." -ForegroundColor Cyan
    
    try {
        # Test endpoint with server time API
        $testUrl = "$endpoint/api/v2/public/time"
        $startTime = Get-Date
        
        $response = Invoke-WebRequest -Uri $testUrl -Method Get -TimeoutSec 10 -ErrorAction Stop
        
        $endTime = Get-Date
        $latency = ($endTime - $startTime).TotalMilliseconds
        
        if ($response.StatusCode -eq 200) {
            $data = $response.Content | ConvertFrom-Json
            
            if ($data.code -eq "00000") {
                Write-Host "  [OK] Connected successfully" -ForegroundColor Green
                Write-Host "  [INFO] Latency: $([math]::Round($latency, 2)) ms" -ForegroundColor White
                
                $results += [PSCustomObject]@{
                    Network = $networkName
                    Endpoint = $endpoint
                    Status = "OK"
                    Latency = [math]::Round($latency, 2)
                    ServerTime = $data.data
                }
            } else {
                Write-Host "  [WARNING] API returned error code: $($data.code)" -ForegroundColor Yellow
                Write-Host "  [INFO] Message: $($data.msg)" -ForegroundColor Yellow
                
                $results += [PSCustomObject]@{
                    Network = $networkName
                    Endpoint = $endpoint
                    Status = "ERROR"
                    Latency = $null
                    ServerTime = $null
                }
            }
        } else {
            Write-Host "  [WARNING] HTTP Status: $($response.StatusCode)" -ForegroundColor Yellow
            
            $results += [PSCustomObject]@{
                Network = $networkName
                Endpoint = $endpoint
                Status = "HTTP_ERROR"
                Latency = $null
                ServerTime = $null
            }
        }
    } catch {
        Write-Host "  [ERROR] Connection failed: $_" -ForegroundColor Red
        
        $results += [PSCustomObject]@{
            Network = $networkName
            Endpoint = $endpoint
            Status = "FAILED"
            Latency = $null
            ServerTime = $null
        }
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Network Test Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Display results table
$results | Format-Table -AutoSize

# Find best network
$workingNetworks = $results | Where-Object { $_.Status -eq "OK" -and $_.Latency -ne $null }

if ($workingNetworks.Count -gt 0) {
    $bestNetwork = $workingNetworks | Sort-Object Latency | Select-Object -First 1
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Recommended Network" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Network: $($bestNetwork.Network)" -ForegroundColor White
    Write-Host "  Endpoint: $($bestNetwork.Endpoint)" -ForegroundColor White
    Write-Host "  Latency: $($bestNetwork.Latency) ms" -ForegroundColor White
    Write-Host ""
    Write-Host "[TIP] Use this network in your configuration for best performance" -ForegroundColor Yellow
} else {
    Write-Host "[ERROR] No working networks found!" -ForegroundColor Red
    Write-Host "[INFO] Please check your internet connection and firewall settings" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
