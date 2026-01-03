# Installation script for Google Gemini CLI v0.22.5
# This script installs the Gemini CLI on Windows systems
# Run as Administrator for global installation

param(
    [switch]$SkipElevation
)

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Google Gemini CLI v0.22.5 Installation Script" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Function to print colored messages
function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Yellow
}

function Write-Error-Message {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -and -not $SkipElevation) {
    Write-Info "This script should be run as Administrator for global installation."
    Write-Info "Attempting to elevate..."
    
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -SkipElevation" -Verb RunAs
        exit
    }
    catch {
        Write-Error-Message "Failed to elevate. Please run as Administrator manually."
        exit 1
    }
}

# Check if Node.js is installed
Write-Info "Checking Node.js installation..."
try {
    $nodeVersion = node -v 2>$null
    if ($nodeVersion) {
        Write-Success "Node.js $nodeVersion is installed"
    }
    else {
        throw "Node.js not found"
    }
}
catch {
    Write-Error-Message "Node.js is not installed."
    Write-Info "Please install Node.js 18+ from https://nodejs.org/"
    Write-Info "Or use Chocolatey: choco install nodejs"
    exit 1
}

# Check if npm is installed
Write-Info "Checking npm installation..."
try {
    $npmVersion = npm -v 2>$null
    if ($npmVersion) {
        Write-Success "npm $npmVersion is installed"
    }
    else {
        throw "npm not found"
    }
}
catch {
    Write-Error-Message "npm is not installed."
    Write-Info "npm should come with Node.js. Please reinstall Node.js."
    exit 1
}

# Extract major version number from Node.js version
$nodeMajorVersion = [int]($nodeVersion -replace 'v', '' -split '\.')[0]

# Check if Node.js version is 18 or higher
if ($nodeMajorVersion -lt 18) {
    Write-Error-Message "Node.js version 18+ is required. Current version: $nodeVersion"
    Write-Info "Please upgrade Node.js to version 18 or higher"
    exit 1
}

Write-Success "Node.js version requirement met (v18+)"

# Install Gemini CLI
Write-Info "Installing Google Gemini CLI v0.22.5..."
Write-Host ""

try {
    # Try global installation
    $installOutput = npm install -g @google/gemini-cli@0.22.5 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Gemini CLI v0.22.5 installed successfully!"
    }
    else {
        throw "Installation failed with exit code $LASTEXITCODE"
    }
}
catch {
    Write-Error-Message "Failed to install Gemini CLI globally."
    Write-Error-Message $_.Exception.Message
    Write-Info "Please check npm permissions or try running as Administrator."
    exit 1
}

Write-Host ""
Write-Info "Verifying installation..."

# Check if gemini command is available
try {
    $geminiVersion = gemini --version 2>&1
    Write-Success "Gemini CLI is installed: $geminiVersion"
}
catch {
    Write-Error-Message "Gemini CLI command not found in PATH"
    Write-Info "You may need to restart your terminal or add npm global bin directory to PATH"
    Write-Info "Try: npm config get prefix"
    exit 1
}

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Write-Info "Next steps:"
Write-Host "  1. Run 'gemini --help' to see available commands" -ForegroundColor White
Write-Host "  2. Run 'gemini' to start interactive mode" -ForegroundColor White
Write-Host "  3. On first run, you'll be prompted to:" -ForegroundColor White
Write-Host "     - Choose a theme" -ForegroundColor White
Write-Host "     - Login (Google Account or API key)" -ForegroundColor White
Write-Host ""

Write-Info "To set up API key (optional, for higher rate limits):"
Write-Host "  `$env:GEMINI_API_KEY = 'your_api_key_here'" -ForegroundColor White
Write-Host ""

Write-Info "For more information, visit:"
Write-Host "  https://github.com/google-gemini/gemini-cli" -ForegroundColor White
Write-Host "  https://google-gemini.github.io/gemini-cli/" -ForegroundColor White
Write-Host ""

Write-Success "Happy coding with Gemini CLI! 🚀"
Write-Host ""

# Pause if running in elevated mode
if ($isAdmin) {
    Write-Host "Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
