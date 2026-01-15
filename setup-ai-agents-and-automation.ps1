# setup-ai-agents-and-automation.ps1
# Master setup script for AI agents, automation, and dependencies

param(
    [switch]$SkipNodeJS = $false,
    [switch]$SkipGitHooks = $false,
    [switch]$SkipDependencies = $false,
    [switch]$CollectPDFs = $true
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AI Agents & Automation Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Get-Location
}

$SetupLog = @()
$Errors = @()

# Function to run script and log result
function Invoke-SetupScript {
    param(
        [string]$ScriptPath,
        [string]$Description,
        [array]$Arguments = @()
    )
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  $Description" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    
    try {
        if (Test-Path $ScriptPath) {
            & $ScriptPath @Arguments
            if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
                Write-Host ""
                Write-Host "[OK] $Description completed successfully" -ForegroundColor Green
                $script:SetupLog += "✓ $Description"
            } else {
                Write-Host ""
                Write-Host "[WARNING] $Description completed with warnings" -ForegroundColor Yellow
                $script:SetupLog += "⚠ $Description (exit code: $LASTEXITCODE)"
            }
        } else {
            Write-Host "[ERROR] Script not found: $ScriptPath" -ForegroundColor Red
            $script:Errors += "✗ $Description (script not found)"
        }
    } catch {
        Write-Host "[ERROR] Failed to run $Description : $_" -ForegroundColor Red
        $script:Errors += "✗ $Description ($_)"
    }
}

# Start setup process
Write-Host "Starting comprehensive setup..." -ForegroundColor Cyan
Write-Host "Repository: $RepoRoot" -ForegroundColor White
Write-Host ""

# Step 1: Install Node.js and npm
if (-not $SkipNodeJS) {
    Invoke-SetupScript -ScriptPath (Join-Path $RepoRoot "install-nodejs-npm.ps1") `
                       -Description "Node.js and npm Installation"
} else {
    Write-Host "[INFO] Skipping Node.js installation (--SkipNodeJS)" -ForegroundColor Yellow
    $SetupLog += "→ Node.js installation skipped"
}

# Step 2: Setup Git hooks
if (-not $SkipGitHooks) {
    Invoke-SetupScript -ScriptPath (Join-Path $RepoRoot "setup-git-hooks.ps1") `
                       -Description "Git Hooks Setup"
} else {
    Write-Host "[INFO] Skipping Git hooks setup (--SkipGitHooks)" -ForegroundColor Yellow
    $SetupLog += "→ Git hooks setup skipped"
}

# Step 3: Install dependencies
if (-not $SkipDependencies) {
    Invoke-SetupScript -ScriptPath (Join-Path $RepoRoot "auto-install-dependencies.ps1") `
                       -Description "Auto-Install Dependencies"
} else {
    Write-Host "[INFO] Skipping dependency installation (--SkipDependencies)" -ForegroundColor Yellow
    $SetupLog += "→ Dependency installation skipped"
}

# Step 4: Collect PDFs (optional)
if ($CollectPDFs) {
    Invoke-SetupScript -ScriptPath (Join-Path $RepoRoot "collect-pdfs.ps1") `
                       -Description "PDF Collection"
} else {
    Write-Host "[INFO] Skipping PDF collection" -ForegroundColor Yellow
    $SetupLog += "→ PDF collection skipped"
}

# Display setup summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($SetupLog.Count -gt 0) {
    foreach ($Entry in $SetupLog) {
        if ($Entry.StartsWith("✓")) {
            Write-Host $Entry -ForegroundColor Green
        } elseif ($Entry.StartsWith("⚠")) {
            Write-Host $Entry -ForegroundColor Yellow
        } else {
            Write-Host $Entry -ForegroundColor Gray
        }
    }
}

if ($Errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Errors encountered:" -ForegroundColor Red
    foreach ($Error in $Errors) {
        Write-Host $Error -ForegroundColor Red
    }
}

# Next steps information
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Next Steps - AI Agent Configuration" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Setup scripts have been run. Now configure AI agents:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Jules Agent (Google AI)" -ForegroundColor Yellow
Write-Host "   - Get API key: https://makersuite.google.com/app/apikey" -ForegroundColor White
Write-Host "   - Set environment variable:" -ForegroundColor White
Write-Host "     [System.Environment]::SetEnvironmentVariable('GOOGLE_AI_API_KEY', 'YOUR_KEY', 'User')" -ForegroundColor Gray
Write-Host ""

Write-Host "2. Qodo Plugin" -ForegroundColor Yellow
Write-Host "   - Install in VS Code/Cursor: Search 'Qodo' in Extensions" -ForegroundColor White
Write-Host "   - API key (optional): https://www.qodo.ai/" -ForegroundColor White
Write-Host ""

Write-Host "3. Cursor Agent" -ForegroundColor Yellow
Write-Host "   - Download: https://cursor.sh/" -ForegroundColor White
Write-Host "   - Project rules already configured in .cursor/rules/" -ForegroundColor White
Write-Host ""

Write-Host "4. Kombai Agent" -ForegroundColor Yellow
Write-Host "   - Create account: https://kombai.com/" -ForegroundColor White
Write-Host "   - Install Figma plugin" -ForegroundColor White
Write-Host "   - Set API key (optional):" -ForegroundColor White
Write-Host "     [System.Environment]::SetEnvironmentVariable('KOMBAI_API_KEY', 'YOUR_KEY', 'User')" -ForegroundColor Gray
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  - Complete guide: AI-AGENTS-SETUP-GUIDE.md" -ForegroundColor White
Write-Host "  - Jules agent: .cursor/rules/ai-agents/JULES-AGENT.md" -ForegroundColor White
Write-Host "  - Qodo plugin: .cursor/rules/ai-agents/QODO-PLUGIN.md" -ForegroundColor White
Write-Host "  - Cursor agent: .cursor/rules/ai-agents/CURSOR-AGENT.md" -ForegroundColor White
Write-Host "  - Kombai agent: .cursor/rules/ai-agents/KOMBAI-AGENT.md" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[INFO] Setup complete! Review the documentation and configure your API keys." -ForegroundColor Green
Write-Host ""

# Exit with appropriate code
if ($Errors.Count -gt 0) {
    exit 1
} else {
    exit 0
}
