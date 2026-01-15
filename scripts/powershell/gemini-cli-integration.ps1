# Gemini CLI Integration Examples for Windows Automation
# This script demonstrates how to integrate Gemini CLI with existing PowerShell automation

# Ensure Gemini CLI is installed
if (-not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Gemini CLI is not installed." -ForegroundColor Red
    Write-Host "[INFO] Run 'INSTALL-GEMINI-CLI.bat' or '.\install-gemini-cli.ps1' to install." -ForegroundColor Yellow
    exit 1
}

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Gemini CLI Integration Examples" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Example 1: Auto-generate commit messages
function AI-Commit {
    Write-Host "[INFO] Generating AI commit message..." -ForegroundColor Yellow
    
    $gitStatus = git status --short
    if (-not $gitStatus) {
        Write-Host "[INFO] No changes to commit." -ForegroundColor Yellow
        return
    }
    
    $diff = git diff --staged
    if (-not $diff) {
        Write-Host "[INFO] No staged changes. Staging all changes..." -ForegroundColor Yellow
        git add .
        $diff = git diff --staged
    }
    
    if ($diff) {
        Write-Host "[INFO] Asking Gemini CLI to generate commit message..." -ForegroundColor Yellow
        $commitMessage = $diff | gemini "Generate a concise, professional git commit message that follows conventional commits format. Output only the commit message, no explanation."
        
        Write-Host ""
        Write-Host "Suggested commit message:" -ForegroundColor Green
        Write-Host $commitMessage -ForegroundColor White
        Write-Host ""
        
        $confirm = Read-Host "Use this message? (Y/n)"
        if ($confirm -eq '' -or $confirm -eq 'Y' -or $confirm -eq 'y') {
            git commit -m $commitMessage
            Write-Host "[OK] Committed successfully!" -ForegroundColor Green
        } else {
            Write-Host "[INFO] Commit cancelled." -ForegroundColor Yellow
        }
    }
}

# Example 2: Code review for PowerShell scripts
function AI-Review {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "[ERROR] File not found: $FilePath" -ForegroundColor Red
        return
    }
    
    Write-Host "[INFO] Reviewing $FilePath with Gemini CLI..." -ForegroundColor Yellow
    Write-Host ""
    
    $review = gemini "Review this PowerShell script for best practices, security issues, and potential improvements. Provide specific, actionable feedback." --file $FilePath
    
    Write-Host $review
}

# Example 3: Generate documentation for scripts
function AI-Document {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [string]$OutputPath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "[ERROR] File not found: $FilePath" -ForegroundColor Red
        return
    }
    
    Write-Host "[INFO] Generating documentation for $FilePath..." -ForegroundColor Yellow
    
    $docs = gemini "Generate comprehensive documentation for this script including: purpose, parameters, usage examples, and notes. Use markdown format." --file $FilePath
    
    if ($OutputPath) {
        $docs | Out-File -FilePath $OutputPath -Encoding UTF8
        Write-Host "[OK] Documentation saved to: $OutputPath" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host $docs
    }
}

# Example 4: Explain git history
function AI-Explain-History {
    param(
        [int]$Count = 10
    )
    
    Write-Host "[INFO] Analyzing recent git history..." -ForegroundColor Yellow
    
    $history = git log --oneline -$Count
    $explanation = $history | gemini "Summarize these git commits in a concise paragraph, highlighting the main themes and changes."
    
    Write-Host ""
    Write-Host $explanation
}

# Example 5: Security audit for a script
function AI-Security-Audit {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "[ERROR] File not found: $FilePath" -ForegroundColor Red
        return
    }
    
    Write-Host "[INFO] Running security audit on $FilePath..." -ForegroundColor Yellow
    Write-Host ""
    
    $audit = gemini "Perform a security audit of this script. Identify any potential vulnerabilities, hardcoded credentials, insecure practices, or security concerns. Provide specific recommendations." --file $FilePath
    
    Write-Host $audit
}

# Example 6: Optimize code
function AI-Optimize {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "[ERROR] File not found: $FilePath" -ForegroundColor Red
        return
    }
    
    Write-Host "[INFO] Getting optimization suggestions for $FilePath..." -ForegroundColor Yellow
    Write-Host ""
    
    $suggestions = gemini "Analyze this code and suggest performance optimizations, better practices, and code improvements. Focus on PowerShell-specific optimizations." --file $FilePath
    
    Write-Host $suggestions
}

# Example 7: Batch documentation for all scripts
function AI-Document-All-Scripts {
    param(
        [string]$Directory = ".",
        [string]$OutputDirectory = ".\docs"
    )
    
    Write-Host "[INFO] Generating documentation for all PowerShell scripts in $Directory..." -ForegroundColor Yellow
    
    if (-not (Test-Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
        Write-Host "[OK] Created output directory: $OutputDirectory" -ForegroundColor Green
    }
    
    $scripts = Get-ChildItem -Path $Directory -Filter "*.ps1" -File
    $count = 0
    
    foreach ($script in $scripts) {
        Write-Host "[INFO] Documenting: $($script.Name)..." -ForegroundColor Yellow
        
        $outputFile = Join-Path $OutputDirectory "$($script.BaseName)-docs.md"
        AI-Document -FilePath $script.FullName -OutputPath $outputFile
        $count++
    }
    
    Write-Host ""
    Write-Host "[OK] Generated documentation for $count scripts in $OutputDirectory" -ForegroundColor Green
}

# Example 8: Interactive AI assistant for debugging
function AI-Debug-Help {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ErrorMessage
    )
    
    Write-Host "[INFO] Getting debugging help from Gemini CLI..." -ForegroundColor Yellow
    Write-Host ""
    
    $help = gemini "I encountered this error in PowerShell: '$ErrorMessage'. Explain what might be causing it and provide specific solutions with code examples."
    
    Write-Host $help
}

# Display usage information
Write-Host "Available Functions:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  AI-Commit" -ForegroundColor White
Write-Host "    - Auto-generate git commit messages based on staged changes" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Review -FilePath <path>" -ForegroundColor White
Write-Host "    - Get AI code review for a PowerShell script" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Document -FilePath <path> [-OutputPath <path>]" -ForegroundColor White
Write-Host "    - Generate documentation for a script" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Explain-History [-Count <number>]" -ForegroundColor White
Write-Host "    - Get AI summary of recent git commits" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Security-Audit -FilePath <path>" -ForegroundColor White
Write-Host "    - Run security audit on a script" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Optimize -FilePath <path>" -ForegroundColor White
Write-Host "    - Get optimization suggestions for code" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Document-All-Scripts [-Directory <path>] [-OutputDirectory <path>]" -ForegroundColor White
Write-Host "    - Generate docs for all scripts in a directory" -ForegroundColor Gray
Write-Host ""
Write-Host "  AI-Debug-Help -ErrorMessage <message>" -ForegroundColor White
Write-Host "    - Get help debugging an error message" -ForegroundColor Gray
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "To use these functions, dot-source this script:" -ForegroundColor Yellow
Write-Host ". .\gemini-cli-integration.ps1" -ForegroundColor White
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
