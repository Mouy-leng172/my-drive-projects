# auto-install-dependencies.ps1
# Automatically detect and install project dependencies

param(
    [switch]$Force = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Auto-Dependency Installation Script  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Get-Location
}

$InstallationLog = @()
$SuccessCount = 0
$FailCount = 0

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Function to install Node.js dependencies
function Install-NodeDependencies {
    param([string]$ProjectPath)
    
    Write-Host "[INFO] Detected Node.js project: $ProjectPath" -ForegroundColor Cyan
    
    $PackageJson = Join-Path -Path $ProjectPath -ChildPath "package.json"
    $NodeModules = Join-Path -Path $ProjectPath -ChildPath "node_modules"
    
    if (-not (Test-Path $NodeModules) -or $Force) {
        Write-Host "[INFO] Installing npm dependencies..." -ForegroundColor Yellow
        
        Push-Location $ProjectPath
        try {
            npm install
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] npm dependencies installed successfully" -ForegroundColor Green
                $script:SuccessCount++
                $script:InstallationLog += "✓ Node.js: $ProjectPath"
            } else {
                Write-Host "[ERROR] npm install failed" -ForegroundColor Red
                $script:FailCount++
                $script:InstallationLog += "✗ Node.js: $ProjectPath (npm install failed)"
            }
        } catch {
            Write-Host "[ERROR] Exception during npm install: $_" -ForegroundColor Red
            $script:FailCount++
            $script:InstallationLog += "✗ Node.js: $ProjectPath ($_)"
        }
        Pop-Location
    } else {
        Write-Host "[OK] Node.js dependencies already installed" -ForegroundColor Green
        $script:InstallationLog += "→ Node.js: $ProjectPath (already installed)"
    }
}

# Function to install Python dependencies
function Install-PythonDependencies {
    param([string]$ProjectPath)
    
    Write-Host "[INFO] Detected Python project: $ProjectPath" -ForegroundColor Cyan
    
    $RequirementsTxt = Join-Path -Path $ProjectPath -ChildPath "requirements.txt"
    
    if (Test-Path $RequirementsTxt) {
        Write-Host "[INFO] Installing Python dependencies..." -ForegroundColor Yellow
        
        Push-Location $ProjectPath
        try {
            # Try pip3 first, then pip
            if (Test-Command "pip3") {
                pip3 install -r requirements.txt
            } elseif (Test-Command "pip") {
                pip install -r requirements.txt
            } else {
                Write-Host "[ERROR] pip/pip3 not found" -ForegroundColor Red
                $script:FailCount++
                $script:InstallationLog += "✗ Python: $ProjectPath (pip not found)"
                Pop-Location
                return
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Python dependencies installed successfully" -ForegroundColor Green
                $script:SuccessCount++
                $script:InstallationLog += "✓ Python: $ProjectPath"
            } else {
                Write-Host "[ERROR] pip install failed" -ForegroundColor Red
                $script:FailCount++
                $script:InstallationLog += "✗ Python: $ProjectPath (pip install failed)"
            }
        } catch {
            Write-Host "[ERROR] Exception during pip install: $_" -ForegroundColor Red
            $script:FailCount++
            $script:InstallationLog += "✗ Python: $ProjectPath ($_)"
        }
        Pop-Location
    }
}

# Function to install Ruby dependencies
function Install-RubyDependencies {
    param([string]$ProjectPath)
    
    Write-Host "[INFO] Detected Ruby project: $ProjectPath" -ForegroundColor Cyan
    
    $Gemfile = Join-Path -Path $ProjectPath -ChildPath "Gemfile"
    
    if (Test-Path $Gemfile) {
        if (Test-Command "bundle") {
            Write-Host "[INFO] Installing Ruby gems..." -ForegroundColor Yellow
            
            Push-Location $ProjectPath
            try {
                bundle install
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "[OK] Ruby gems installed successfully" -ForegroundColor Green
                    $script:SuccessCount++
                    $script:InstallationLog += "✓ Ruby: $ProjectPath"
                } else {
                    Write-Host "[ERROR] bundle install failed" -ForegroundColor Red
                    $script:FailCount++
                    $script:InstallationLog += "✗ Ruby: $ProjectPath (bundle install failed)"
                }
            } catch {
                Write-Host "[ERROR] Exception during bundle install: $_" -ForegroundColor Red
                $script:FailCount++
                $script:InstallationLog += "✗ Ruby: $ProjectPath ($_)"
            }
            Pop-Location
        } else {
            Write-Host "[WARNING] Bundler not installed. Run: gem install bundler" -ForegroundColor Yellow
            $script:InstallationLog += "→ Ruby: $ProjectPath (bundler not installed)"
        }
    }
}

# Scan for project files
Write-Host "[INFO] Scanning repository for project dependencies..." -ForegroundColor Cyan
Write-Host ""

# Exclude common non-project directories
$ExcludeDirs = @("node_modules", ".git", ".vscode", ".idea", "dist", "build", "bin", "obj", "venv", "__pycache__")

# Find all package.json files (Node.js)
$NodeProjects = Get-ChildItem -Path $RepoRoot -Recurse -Filter "package.json" -ErrorAction SilentlyContinue | 
    Where-Object { 
        $Include = $true
        foreach ($Exclude in $ExcludeDirs) {
            if ($_.DirectoryName -like "*\$Exclude\*" -or $_.DirectoryName -like "*/$Exclude/*") {
                $Include = $false
                break
            }
        }
        $Include
    }

if ($NodeProjects.Count -gt 0) {
    Write-Host "[INFO] Found $($NodeProjects.Count) Node.js project(s)" -ForegroundColor Yellow
    
    if (-not (Test-Command "npm")) {
        Write-Host "[ERROR] npm not found. Please install Node.js first." -ForegroundColor Red
        Write-Host "[INFO] Run: .\install-nodejs-npm.ps1" -ForegroundColor Yellow
        Write-Host ""
    } else {
        foreach ($Project in $NodeProjects) {
            Install-NodeDependencies -ProjectPath $Project.DirectoryName
            Write-Host ""
        }
    }
}

# Find all requirements.txt files (Python)
$PythonProjects = Get-ChildItem -Path $RepoRoot -Recurse -Filter "requirements.txt" -ErrorAction SilentlyContinue |
    Where-Object { 
        $Include = $true
        foreach ($Exclude in $ExcludeDirs) {
            if ($_.DirectoryName -like "*\$Exclude\*" -or $_.DirectoryName -like "*/$Exclude/*") {
                $Include = $false
                break
            }
        }
        $Include
    }

if ($PythonProjects.Count -gt 0) {
    Write-Host "[INFO] Found $($PythonProjects.Count) Python project(s)" -ForegroundColor Yellow
    
    if (-not (Test-Command "pip") -and -not (Test-Command "pip3")) {
        Write-Host "[ERROR] pip not found. Please install Python first." -ForegroundColor Red
        Write-Host ""
    } else {
        foreach ($Project in $PythonProjects) {
            Install-PythonDependencies -ProjectPath $Project.DirectoryName
            Write-Host ""
        }
    }
}

# Find all Gemfile files (Ruby)
$RubyProjects = Get-ChildItem -Path $RepoRoot -Recurse -Filter "Gemfile" -ErrorAction SilentlyContinue |
    Where-Object { 
        $Include = $true
        foreach ($Exclude in $ExcludeDirs) {
            if ($_.DirectoryName -like "*\$Exclude\*" -or $_.DirectoryName -like "*/$Exclude/*") {
                $Include = $false
                break
            }
        }
        $Include
    }

if ($RubyProjects.Count -gt 0) {
    Write-Host "[INFO] Found $($RubyProjects.Count) Ruby project(s)" -ForegroundColor Yellow
    
    foreach ($Project in $RubyProjects) {
        Install-RubyDependencies -ProjectPath $Project.DirectoryName
        Write-Host ""
    }
}

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($InstallationLog.Count -gt 0) {
    foreach ($Entry in $InstallationLog) {
        if ($Entry.StartsWith("✓")) {
            Write-Host $Entry -ForegroundColor Green
        } elseif ($Entry.StartsWith("✗")) {
            Write-Host $Entry -ForegroundColor Red
        } else {
            Write-Host $Entry -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "[INFO] No projects requiring dependency installation found." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Success: $SuccessCount | Failed: $FailCount | Total: $($InstallationLog.Count)" -ForegroundColor Cyan
Write-Host ""
