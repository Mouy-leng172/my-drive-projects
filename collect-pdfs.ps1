# collect-pdfs.ps1
# Script to collect all PDF files and create a consolidated notebook

param(
    [string]$OutputNotebook = "PDF-Collection-Notebook.md",
    [switch]$ClipToClipboard = $false
)

Write-Host "[INFO] Starting PDF Collection..." -ForegroundColor Cyan
Write-Host ""

# Get repository root
$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Get-Location
}

# Initialize notebook content
$NotebookContent = @"
# PDF Collection Notebook
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

This document catalogs all PDF files found in the repository.

---

"@

# Find all PDF files (excluding gitignored directories)
$ExcludedPaths = @(
    "node_modules",
    ".git",
    "Backups",
    "backup",
    "backups",
    "Secrets"
)

Write-Host "[INFO] Scanning for PDF files..." -ForegroundColor Yellow

$PdfFiles = @()
try {
    Get-ChildItem -Path $RepoRoot -Recurse -Filter "*.pdf" -ErrorAction SilentlyContinue | ForEach-Object {
        $Include = $true
        foreach ($Excluded in $ExcludedPaths) {
            if ($_.FullName -like "*\$Excluded\*" -or $_.FullName -like "*/$Excluded/*") {
                $Include = $false
                break
            }
        }
        if ($Include) {
            $PdfFiles += $_
        }
    }
} catch {
    Write-Host "[WARNING] Error during PDF scan: $_" -ForegroundColor Yellow
}

Write-Host "[OK] Found $($PdfFiles.Count) PDF files" -ForegroundColor Green
Write-Host ""

# Process each PDF file
$Index = 1
foreach ($Pdf in $PdfFiles) {
    $RelativePath = $Pdf.FullName.Replace($RepoRoot, "").TrimStart([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    $FileSize = [math]::Round($Pdf.Length / 1KB, 2)
    
    Write-Host "  [$Index/$($PdfFiles.Count)] $RelativePath ($FileSize KB)" -ForegroundColor Cyan
    
    $NotebookContent += @"

## $Index. $($Pdf.Name)

- **Path**: ``$RelativePath``
- **Size**: $FileSize KB
- **Modified**: $($Pdf.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))
- **Created**: $($Pdf.CreationTime.ToString('yyyy-MM-dd HH:mm:ss'))

"@
    $Index++
}

# Add summary section
$NotebookContent += @"

---

## Summary

- **Total PDFs Found**: $($PdfFiles.Count)
- **Total Size**: $([math]::Round(($PdfFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
- **Scan Date**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

### Notes

PDFs are excluded from git tracking by default (see .gitignore).
To include specific PDFs in version control, update the .gitignore file.

"@

# Save to file
try {
    $OutputPath = Join-Path -Path $RepoRoot -ChildPath $OutputNotebook
    $NotebookContent | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host ""
    Write-Host "[OK] Notebook saved to: $OutputNotebook" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to save notebook: $_" -ForegroundColor Red
    exit 1
}

# Copy to clipboard if requested
if ($ClipToClipboard) {
    try {
        $NotebookContent | Set-Clipboard
        Write-Host "[OK] Content copied to clipboard" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Could not copy to clipboard: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "[INFO] PDF collection complete!" -ForegroundColor Cyan
