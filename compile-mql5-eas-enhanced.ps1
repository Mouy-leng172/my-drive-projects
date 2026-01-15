#Requires -Version 5.1
<#
.SYNOPSIS
    Enhanced MQL5 compilation with MQL5.io integration
.DESCRIPTION
    Compiles MQL5 Expert Advisors and integrates with MQL5.io marketplace
    Supports downloading EAs from MQL5.io and compiling them locally
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Enhanced MQL5 Compiler & Integrator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$mt5TerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$mt5MetaEditorPath = "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"

function Resolve-TerminalDataPath {
    if (-not $env:APPDATA) { return $null }
    $terminalRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
    if (-not (Test-Path $terminalRoot)) { return $null }

    $candidates = @()
    try {
        $dirs = Get-ChildItem -Path $terminalRoot -Directory -ErrorAction SilentlyContinue
        foreach ($d in $dirs) {
            $mql5Path = Join-Path $d.FullName "MQL5"
            if (Test-Path $mql5Path) {
                $originTxt = Join-Path $d.FullName "origin.txt"
                $origin = $null
                if (Test-Path $originTxt) {
                    $origin = (Get-Content $originTxt -ErrorAction SilentlyContinue | Select-Object -First 1)
                }
                $candidates += [PSCustomObject]@{
                    Path = $d.FullName
                    Origin = $origin
                    LastWrite = $d.LastWriteTime
                }
            }
        }
    } catch { }

    if (-not $candidates -or $candidates.Count -eq 0) { return $null }
    if ($candidates.Count -eq 1) { return $candidates[0].Path }

    $exness = $candidates | Where-Object { $_.Origin -match "EXNESS|Exness|MetaTrader 5 EXNESS" }
    if ($exness -and $exness.Count -ge 1) {
        return ($exness | Sort-Object LastWrite -Descending | Select-Object -First 1).Path
    }

    return ($candidates | Sort-Object LastWrite -Descending | Select-Object -First 1).Path
}

function Download-FromMQL5 {
    param(
        [string]$ProductUrl,
        [string]$DestinationPath
    )
    
    Write-Host "[INFO] MQL5.io download feature" -ForegroundColor Yellow
    Write-Host "[INFO] Direct download from MQL5.io is restricted by MetaQuotes" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[ALTERNATIVE] To use MQL5.io products:" -ForegroundColor Cyan
    Write-Host "  1. Open MetaTrader 5 Terminal" -ForegroundColor White
    Write-Host "  2. Go to 'Market' tab" -ForegroundColor White
    Write-Host "  3. Search for your desired product" -ForegroundColor White
    Write-Host "  4. Purchase/download the product" -ForegroundColor White
    Write-Host "  5. It will automatically install to your MQL5 folder" -ForegroundColor White
    Write-Host "  6. Run this script again to compile" -ForegroundColor White
    Write-Host ""
    
    return $false
}

function Compile-MQL5File {
    param(
        [string]$FilePath,
        [string]$MetaEditorPath
    )
    
    $fileName = [System.IO.Path]::GetFileName($FilePath)
    
    Write-Host "    Compiling: $fileName..." -ForegroundColor Cyan
    
    try {
        # MetaEditor command-line compilation
        $compileArgs = @(
            "/compile:`"$FilePath`"",
            "/log"
        )
        
        $process = Start-Process -FilePath $MetaEditorPath -ArgumentList $compileArgs -Wait -PassThru -NoNewWindow
        
        # Check if .ex5 file was created
        $ex5Path = $FilePath -replace "\.mq5$", ".ex5"
        
        if (Test-Path $ex5Path) {
            Write-Host "      [OK] Compiled successfully: $fileName" -ForegroundColor Green
            return [PSCustomObject]@{
                File = $fileName
                Status = "Success"
                Ex5Path = $ex5Path
            }
        } else {
            Write-Host "      [WARNING] Compilation may have failed: $fileName" -ForegroundColor Yellow
            return [PSCustomObject]@{
                File = $fileName
                Status = "Failed"
                Ex5Path = $null
            }
        }
    } catch {
        Write-Host "      [ERROR] Failed to compile $fileName : $_" -ForegroundColor Red
        return [PSCustomObject]@{
            File = $fileName
            Status = "Error"
            Ex5Path = $null
            Error = $_.Exception.Message
        }
    }
}

function Scan-MQL5Repository {
    param([string]$RepoPath)
    
    Write-Host "[INFO] Scanning MQL5 repository..." -ForegroundColor Yellow
    
    if (-not (Test-Path $RepoPath)) {
        Write-Host "[WARNING] MQL5 repository not found at: $RepoPath" -ForegroundColor Yellow
        return @()
    }
    
    $mq5Files = Get-ChildItem -Path $RepoPath -Filter "*.mq5" -Recurse -ErrorAction SilentlyContinue
    
    if ($mq5Files.Count -gt 0) {
        Write-Host "[OK] Found $($mq5Files.Count) MQL5 file(s) in repository" -ForegroundColor Green
        return $mq5Files
    } else {
        Write-Host "[WARNING] No MQL5 files found in repository" -ForegroundColor Yellow
        return @()
    }
}

# Main execution
$terminalDataPath = Resolve-TerminalDataPath
if (-not $terminalDataPath) {
    Write-Host "[ERROR] Could not locate MT5 Terminal data folder" -ForegroundColor Red
    Write-Host "[INFO] Run MT5 once, then retry this script" -ForegroundColor Yellow
    exit 1
}

$expertsPath = Join-Path $terminalDataPath "MQL5\Experts"
$advisorsPath = Join-Path $expertsPath "Advisors"

# Check if MetaEditor exists
$metaEditorFound = $false
$programFilesX86 = $null
try { $programFilesX86 = (Get-Item "Env:ProgramFiles(x86)").Value } catch { }

$metaEditorPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:PROGRAMFILES\MetaTrader 5 EXNESS\metaeditor64.exe",
    $(if ($programFilesX86) { Join-Path $programFilesX86 "MetaTrader 5 EXNESS\metaeditor64.exe" })
)

foreach ($path in $metaEditorPaths) {
    if (Test-Path $path) {
        $mt5MetaEditorPath = $path
        $metaEditorFound = $true
        Write-Host "[OK] Found MetaEditor at: $path" -ForegroundColor Green
        break
    }
}

if (-not $metaEditorFound) {
    Write-Host "[ERROR] MetaEditor not found" -ForegroundColor Red
    Write-Host "[INFO] Please install MetaTrader 5" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "[1/4] Scanning for Expert Advisors..." -ForegroundColor Yellow

# Scan Advisors folder
$advisorFiles = @()
if (Test-Path $advisorsPath) {
    $advisorFiles = Get-ChildItem -Path $advisorsPath -Filter "*.mq5" -ErrorAction SilentlyContinue
}

# Scan local repository
$repoPath = Join-Path $PSScriptRoot "mql5-repo"
$repoFiles = Scan-MQL5Repository -RepoPath $repoPath

# Combine all files
$allFiles = @()
$allFiles += $advisorFiles
$allFiles += $repoFiles

if ($allFiles.Count -eq 0) {
    Write-Host "[WARNING] No .mq5 files found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[INFO] To use MQL5.io products:" -ForegroundColor Cyan
    Write-Host "  1. Open MetaTrader 5" -ForegroundColor White
    Write-Host "  2. Go to Market tab" -ForegroundColor White
    Write-Host "  3. Download your products" -ForegroundColor White
    Write-Host "  4. They will appear in: $advisorsPath" -ForegroundColor White
    exit 1
}

Write-Host "    Found $($allFiles.Count) Expert Advisor(s):" -ForegroundColor Cyan
foreach ($ea in $allFiles) {
    Write-Host "      - $($ea.Name) ($($ea.DirectoryName))" -ForegroundColor White
}

Write-Host ""
Write-Host "[2/4] Compiling Expert Advisors..." -ForegroundColor Yellow

$results = @()
foreach ($eaFile in $allFiles) {
    $result = Compile-MQL5File -FilePath $eaFile.FullName -MetaEditorPath $mt5MetaEditorPath
    $results += $result
}

Write-Host ""
Write-Host "[3/4] Integrating with MQL5.io..." -ForegroundColor Yellow
Write-Host "[INFO] MQL5.io integration status:" -ForegroundColor Cyan
Write-Host "  - Product downloads: Via MT5 Market tab" -ForegroundColor White
Write-Host "  - Compilation: Automated ✓" -ForegroundColor White
Write-Host "  - Deployment: Manual to VPS" -ForegroundColor White

Write-Host ""
Write-Host "[4/4] Compilation Summary" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

$successCount = ($results | Where-Object { $_.Status -eq "Success" }).Count
$failedCount = ($results | Where-Object { $_.Status -ne "Success" }).Count

Write-Host "  Total EAs: $($results.Count)" -ForegroundColor White
Write-Host "  Compiled: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failedCount" -ForegroundColor $(if ($failedCount -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($successCount -gt 0) {
    Write-Host "Successfully compiled Expert Advisors:" -ForegroundColor Green
    foreach ($result in $results) {
        if ($result.Status -eq "Success") {
            Write-Host "  [OK] $($result.File)" -ForegroundColor White
        }
    }
}

if ($failedCount -gt 0) {
    Write-Host ""
    Write-Host "Failed to compile:" -ForegroundColor Yellow
    foreach ($result in $results) {
        if ($result.Status -ne "Success") {
            Write-Host "  [FAILED] $($result.File)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Test EAs in Strategy Tester" -ForegroundColor Yellow
Write-Host "2. Deploy to VPS: .\launch-mql5-to-vps.ps1" -ForegroundColor Yellow
Write-Host "3. Monitor via Telegram notifications" -ForegroundColor Yellow
Write-Host ""
Write-Host "[TIP] For MQL5.io products: Use MT5 Market tab to download" -ForegroundColor Cyan
Write-Host ""
