# Setup Web-Dev-For-Beginners Fork Integration
# This script helps set up the Microsoft Web-Dev-For-Beginners repository fork chain

<#
.SYNOPSIS
    Sets up and integrates the Microsoft Web-Dev-For-Beginners fork into the my-drive-projects repository.

.DESCRIPTION
    This script automates the process of integrating Microsoft's Web-Dev-For-Beginners repository
    through the fork chain: Microsoft → mouyleng/GenX_FX → A6-9V/my-drive-projects

.PARAMETER Method
    The integration method: "submodule", "clone", or "reference-only"
    Default: "reference-only" (just creates documentation)

.PARAMETER TargetPath
    The path where the Web-Dev-For-Beginners project should be placed
    Default: "projects/Web-Dev-For-Beginners"

.EXAMPLE
    .\setup-web-dev-fork.ps1
    Creates reference documentation only

.EXAMPLE
    .\setup-web-dev-fork.ps1 -Method clone
    Clones the mouyleng/GenX_FX repository into projects directory

.EXAMPLE
    .\setup-web-dev-fork.ps1 -Method submodule
    Adds mouyleng/GenX_FX as a Git submodule
#>

param(
    [ValidateSet("submodule", "clone", "reference-only")]
    [string]$Method = "reference-only",
    
    [string]$TargetPath = "projects/Web-Dev-For-Beginners"
)

# Configuration
$OriginalRepo = "https://github.com/microsoft/Web-Dev-For-Beginners"
$GenXFXRepo = "https://github.com/mouyleng/GenX_FX"
$ProjectRoot = $PSScriptRoot
$TargetFullPath = Join-Path $ProjectRoot $TargetPath

Write-Host "`n=== Web-Dev-For-Beginners Fork Setup ===" -ForegroundColor Cyan
Write-Host "Integration Method: $Method" -ForegroundColor Yellow

# Function to display fork chain
function Show-ForkChain {
    Write-Host "`nFork Chain:" -ForegroundColor Cyan
    Write-Host "  Original: $OriginalRepo" -ForegroundColor White
    Write-Host "     ↓" -ForegroundColor DarkGray
    Write-Host "  GenX_FX:  $GenXFXRepo" -ForegroundColor White
    Write-Host "     ↓" -ForegroundColor DarkGray
    Write-Host "  A6-9V:    This repository (my-drive-projects)" -ForegroundColor White
    Write-Host ""
}

# Function to check if Git is available
function Test-GitAvailable {
    try {
        $null = git --version
        return $true
    }
    catch {
        Write-Host "[ERROR] Git is not installed or not in PATH" -ForegroundColor Red
        return $false
    }
}

# Function to create project directory structure
function Initialize-ProjectStructure {
    Write-Host "`n[INFO] Ensuring project structure exists..." -ForegroundColor Cyan
    
    $projectsDir = Join-Path $ProjectRoot "projects"
    if (-not (Test-Path $projectsDir)) {
        New-Item -Path $projectsDir -ItemType Directory -Force | Out-Null
        Write-Host "[OK] Created projects directory" -ForegroundColor Green
    }
    else {
        Write-Host "[OK] Projects directory exists" -ForegroundColor Green
    }
}

# Function to handle submodule method
function Add-AsSubmodule {
    Write-Host "`n[INFO] Adding as Git submodule..." -ForegroundColor Cyan
    
    if (-not (Test-GitAvailable)) {
        return $false
    }
    
    try {
        # Check if already a submodule
        $gitmodulesPath = Join-Path $ProjectRoot ".gitmodules"
        if (Test-Path $gitmodulesPath) {
            $gitmodules = Get-Content $gitmodulesPath -Raw
            if ($gitmodules -match "Web-Dev-For-Beginners") {
                Write-Host "[INFO] Submodule already exists" -ForegroundColor Yellow
                return $true
            }
        }
        
        # Add submodule
        Set-Location $ProjectRoot
        $output = git submodule add $GenXFXRepo $TargetPath 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Submodule added successfully" -ForegroundColor Green
            
            # Initialize and update
            git submodule update --init --recursive
            Write-Host "[OK] Submodule initialized" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "[ERROR] Failed to add submodule: $output" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] Exception adding submodule: $_" -ForegroundColor Red
        return $false
    }
}

# Function to handle clone method
function Add-AsClone {
    Write-Host "`n[INFO] Cloning repository..." -ForegroundColor Cyan
    
    if (-not (Test-GitAvailable)) {
        return $false
    }
    
    try {
        # Check if already exists
        if (Test-Path $TargetFullPath) {
            Write-Host "[INFO] Directory already exists at $TargetFullPath" -ForegroundColor Yellow
            
            # Check if it's a git repository
            if (Test-Path (Join-Path $TargetFullPath ".git")) {
                Write-Host "[OK] Git repository already cloned" -ForegroundColor Green
                return $true
            }
        }
        
        # Clone the repository
        $parentDir = Split-Path $TargetFullPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
        }
        
        git clone $GenXFXRepo $TargetFullPath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Repository cloned successfully" -ForegroundColor Green
            
            # Set up remotes
            Set-Location $TargetFullPath
            git remote add genx $GenXFXRepo
            git remote add microsoft $OriginalRepo
            
            Write-Host "[OK] Remote tracking configured" -ForegroundColor Green
            Write-Host "  - origin: $GenXFXRepo" -ForegroundColor White
            Write-Host "  - genx: $GenXFXRepo" -ForegroundColor White
            Write-Host "  - microsoft: $OriginalRepo" -ForegroundColor White
            
            Set-Location $ProjectRoot
            return $true
        }
        else {
            Write-Host "[ERROR] Failed to clone repository" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] Exception cloning repository: $_" -ForegroundColor Red
        return $false
    }
}

# Function to create reference documentation
function Add-ReferenceDocumentation {
    Write-Host "`n[INFO] Creating reference documentation..." -ForegroundColor Cyan
    
    $docPath = Join-Path $ProjectRoot "projects\Web-Dev-For-Beginners-README.md"
    $parentDir = Split-Path $docPath -Parent
    
    if (-not (Test-Path $parentDir)) {
        New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
    }
    
    $content = @"
# Web-Dev-For-Beginners Project Reference

## Fork Status

This document tracks the fork chain for the Microsoft Web-Dev-For-Beginners project.

## Fork Chain

\`\`\`
Microsoft/Web-Dev-For-Beginners (Original)
    ↓
mouyleng/GenX_FX (First Fork)
    ↓
A6-9V/my-drive-projects (This Repository)
\`\`\`

## Repository URLs

- **Original**: $OriginalRepo
- **GenX_FX Fork**: $GenXFXRepo
- **Website**: https://microsoft.github.io/Web-Dev-For-Beginners/

## Integration Method

**Method**: $Method
**Target Location**: $TargetPath
**Status**: Documentation created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## To Complete Integration

### Option 1: Clone the Repository

\`\`\`powershell
.\setup-web-dev-fork.ps1 -Method clone
\`\`\`

### Option 2: Add as Submodule

\`\`\`powershell
.\setup-web-dev-fork.ps1 -Method submodule
\`\`\`

### Option 3: Manual Fork on GitHub

1. Go to: $GenXFXRepo
2. Click "Fork" button
3. Select A6-9V organization
4. Clone to your local machine

## Next Steps

1. **Complete the fork** using one of the methods above
2. **Review the curriculum**: 24 Lessons, 12 Weeks
3. **Start learning**: Begin with Week 1 lessons
4. **Apply knowledge**: Use in A6-9V projects

## Learning Resources

- 📚 Full Curriculum: https://microsoft.github.io/Web-Dev-For-Beginners/
- 📖 Detailed Guide: See WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md
- 🔗 GitHub Repository: $GenXFXRepo

## Last Updated

$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@
    
    Set-Content -Path $docPath -Value $content -Encoding UTF8
    Write-Host "[OK] Reference documentation created at:" -ForegroundColor Green
    Write-Host "     $docPath" -ForegroundColor White
    
    return $true
}

# Function to update main README
function Update-MainReadme {
    Write-Host "`n[INFO] Checking if README needs update..." -ForegroundColor Cyan
    
    $readmePath = Join-Path $ProjectRoot "README.md"
    
    if (-not (Test-Path $readmePath)) {
        Write-Host "[WARNING] README.md not found" -ForegroundColor Yellow
        return $false
    }
    
    try {
        $readme = Get-Content $readmePath -Raw
        
        # Check if already mentioned
        if ($readme -match "Web-Dev-For-Beginners") {
            Write-Host "[INFO] README already mentions Web-Dev-For-Beginners" -ForegroundColor Yellow
            return $true
        }
        
        Write-Host "[INFO] README update needed (manual step)" -ForegroundColor Yellow
        Write-Host "Add this section to README.md under projects:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "### Web Development Learning"
        Write-Host ""
        Write-Host "- **Web-Dev-For-Beginners**: Microsoft's comprehensive web development curriculum"
        Write-Host "  - 24 Lessons covering HTML, CSS, JavaScript"
        Write-Host "  - 12 Weeks of structured learning"
        Write-Host "  - Hands-on projects and exercises"
        Write-Host "  - Fork chain: Microsoft → mouyleng/GenX_FX → A6-9V"
        Write-Host "  - Documentation: See WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md"
        Write-Host ""
        
        return $true
    }
    catch {
        Write-Host "[ERROR] Failed to read README: $_" -ForegroundColor Red
        return $false
    }
}

# Function to display completion summary
function Show-Summary {
    param([bool]$Success)
    
    Write-Host "`n=== Setup Summary ===" -ForegroundColor Cyan
    
    if ($Success) {
        Write-Host "[SUCCESS] Web-Dev-For-Beginners setup completed!" -ForegroundColor Green
    }
    else {
        Write-Host "[PARTIAL] Setup completed with some issues" -ForegroundColor Yellow
    }
    
    Write-Host "`nDocumentation:" -ForegroundColor Cyan
    Write-Host "  - Fork Guide: WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md" -ForegroundColor White
    Write-Host "  - Project Ref: projects/Web-Dev-For-Beginners-README.md" -ForegroundColor White
    
    Write-Host "`nNext Steps:" -ForegroundColor Cyan
    Write-Host "  1. Review the fork guide for detailed instructions" -ForegroundColor White
    Write-Host "  2. Complete any pending fork operations on GitHub" -ForegroundColor White
    Write-Host "  3. Start the learning curriculum" -ForegroundColor White
    Write-Host "  4. Apply learnings to A6-9V projects" -ForegroundColor White
    
    Write-Host "`nRepository Links:" -ForegroundColor Cyan
    Write-Host "  - Original: $OriginalRepo" -ForegroundColor White
    Write-Host "  - GenX_FX: $GenXFXRepo" -ForegroundColor White
    Write-Host "  - Website: https://microsoft.github.io/Web-Dev-For-Beginners/" -ForegroundColor White
}

# Main execution
try {
    Show-ForkChain
    Initialize-ProjectStructure
    
    $success = $false
    
    switch ($Method) {
        "submodule" {
            $success = Add-AsSubmodule
        }
        "clone" {
            $success = Add-AsClone
        }
        "reference-only" {
            $success = Add-ReferenceDocumentation
        }
    }
    
    # Always create reference documentation
    if ($Method -ne "reference-only") {
        Add-ReferenceDocumentation | Out-Null
    }
    
    # Check README
    Update-MainReadme | Out-Null
    
    Show-Summary -Success $success
    
    Write-Host "`n[COMPLETE] Script finished" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERROR] Script failed: $_" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
