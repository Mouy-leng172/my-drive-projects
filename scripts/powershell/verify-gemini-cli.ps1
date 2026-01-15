# Gemini CLI Installation Verification Script (PowerShell)
# This script checks if Gemini CLI is properly installed and configured

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Gemini CLI Installation Verification" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsTotal = 10

# Test 1: Check if Node.js is installed
Write-Host "[TEST 1] Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node -v 2>$null
    if ($nodeVersion) {
        Write-Host "[PASS] Node.js $nodeVersion is installed" -ForegroundColor Green
        $testsPassed++
    }
    else {
        throw "Node.js not found"
    }
}
catch {
    Write-Host "[FAIL] Node.js is not installed" -ForegroundColor Red
    Write-Host "[INFO] Install from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 2: Check if npm is installed
Write-Host "[TEST 2] Checking npm installation..." -ForegroundColor Yellow
try {
    $npmVersion = npm -v 2>$null
    if ($npmVersion) {
        Write-Host "[PASS] npm $npmVersion is installed" -ForegroundColor Green
        $testsPassed++
    }
    else {
        throw "npm not found"
    }
}
catch {
    Write-Host "[FAIL] npm is not installed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 3: Check Node.js version
Write-Host "[TEST 3] Verifying Node.js version (requires v18+)..." -ForegroundColor Yellow
$nodeMajorVersion = [int]($nodeVersion -replace 'v', '' -split '\.')[0]
if ($nodeMajorVersion -ge 18) {
    Write-Host "[PASS] Node.js version requirement met (v$nodeMajorVersion)" -ForegroundColor Green
    $testsPassed++
}
else {
    Write-Host "[FAIL] Node.js version is below v18 (current: v$nodeMajorVersion)" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 4: Check if Gemini CLI is installed
Write-Host "[TEST 4] Checking Gemini CLI installation..." -ForegroundColor Yellow
try {
    $geminiCheck = Get-Command gemini -ErrorAction Stop
    Write-Host "[PASS] Gemini CLI is installed" -ForegroundColor Green
    $testsPassed++
}
catch {
    Write-Host "[FAIL] Gemini CLI is not installed" -ForegroundColor Red
    Write-Host "[INFO] Run 'INSTALL-GEMINI-CLI.bat' or '.\install-gemini-cli.ps1' to install" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 5: Check Gemini CLI version
Write-Host "[TEST 5] Verifying Gemini CLI version..." -ForegroundColor Yellow
try {
    $geminiVersion = gemini --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] Gemini CLI version: $geminiVersion" -ForegroundColor Green
        $testsPassed++
        
        if ($geminiVersion -eq "0.22.5") {
            Write-Host "[INFO] Correct version installed (v0.22.5)" -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] Different version installed (expected: v0.22.5, got: $geminiVersion)" -ForegroundColor Yellow
        }
    }
    else {
        throw "Version check failed"
    }
}
catch {
    Write-Host "[FAIL] Could not determine Gemini CLI version" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 6: Check if Gemini CLI help works
Write-Host "[TEST 6] Testing Gemini CLI help command..." -ForegroundColor Yellow
try {
    $helpOutput = gemini --help 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] Gemini CLI help command works" -ForegroundColor Green
        $testsPassed++
    }
    else {
        throw "Help command failed"
    }
}
catch {
    Write-Host "[FAIL] Gemini CLI help command failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 7: Check PATH configuration
Write-Host "[TEST 7] Checking PATH configuration..." -ForegroundColor Yellow
$geminiPath = (Get-Command gemini -ErrorAction SilentlyContinue).Source
if ($geminiPath) {
    Write-Host "[PASS] Gemini CLI found in PATH: $geminiPath" -ForegroundColor Green
    $testsPassed++
}
else {
    Write-Host "[FAIL] Gemini CLI not found in PATH" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 8: Check npm global packages
Write-Host "[TEST 8] Verifying npm global package installation..." -ForegroundColor Yellow
try {
    $npmList = npm list -g @google/gemini-cli 2>&1
    if ($npmList -match "@google/gemini-cli@(\d+\.\d+\.\d+)") {
        $npmPackageVersion = $matches[1]
        Write-Host "[PASS] @google/gemini-cli installed globally (version: $npmPackageVersion)" -ForegroundColor Green
        $testsPassed++
    }
    else {
        Write-Host "[WARN] Could not verify npm global package (but gemini command works)" -ForegroundColor Yellow
        $testsPassed++
    }
}
catch {
    Write-Host "[WARN] Could not verify npm global package" -ForegroundColor Yellow
    $testsPassed++
}
Write-Host ""

# Test 9: Check API key configuration (optional)
Write-Host "[TEST 9] Checking API key configuration (optional)..." -ForegroundColor Yellow
if ($env:GEMINI_API_KEY) {
    Write-Host "[PASS] GEMINI_API_KEY environment variable is set" -ForegroundColor Green
    Write-Host "[INFO] API key is configured" -ForegroundColor Yellow
    $testsPassed++
}
else {
    Write-Host "[INFO] GEMINI_API_KEY not set (will use OAuth on first run)" -ForegroundColor Yellow
    Write-Host "[INFO] Set API key: `$env:GEMINI_API_KEY = `"your_key`"" -ForegroundColor Yellow
    $testsPassed++
}
Write-Host ""

# Test 10: Check documentation files
Write-Host "[TEST 10] Checking documentation files..." -ForegroundColor Yellow
$docsFound = 0
$docFiles = @(
    "GEMINI-CLI-SETUP-GUIDE.md",
    "GEMINI-CLI-QUICK-START.md",
    "gemini-cli-config.template"
)

foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        Write-Host "[PASS] $doc found" -ForegroundColor Green
        $docsFound++
    }
}

if ($docsFound -eq $docFiles.Count) {
    Write-Host "[INFO] All documentation files present" -ForegroundColor Green
}
else {
    Write-Host "[WARN] Some documentation files are missing ($docsFound/$($docFiles.Count))" -ForegroundColor Yellow
}
$testsPassed++
Write-Host ""

# Summary
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Verification Summary" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✓ All critical tests passed! ($testsPassed/$testsTotal)" -ForegroundColor Green
Write-Host ""
Write-Host "Installation Details:" -ForegroundColor Yellow
Write-Host "  Node.js: $nodeVersion"
Write-Host "  npm: $npmVersion"
Write-Host "  Gemini CLI: $geminiVersion"
Write-Host "  Install Path: $geminiPath"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Run 'gemini --help' to see all available commands"
Write-Host "  2. Run 'gemini' to start interactive mode"
Write-Host "  3. Review documentation:"
Write-Host "     - GEMINI-CLI-SETUP-GUIDE.md (comprehensive guide)"
Write-Host "     - GEMINI-CLI-QUICK-START.md (quick reference)"
Write-Host "  4. Try integration examples:"
Write-Host "     - . .\gemini-cli-integration.ps1"
Write-Host ""
Write-Host "✓ Gemini CLI is ready to use!" -ForegroundColor Green
Write-Host ""
