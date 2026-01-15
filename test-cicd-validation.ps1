# CI/CD Test Script
# This script demonstrates the CI/CD validation features

# Test 1: Well-formatted function with proper error handling
function Test-CICDValidation {
    <#
    .SYNOPSIS
        Test function for CI/CD validation
    
    .DESCRIPTION
        Demonstrates proper PowerShell script structure with error handling
    
    .EXAMPLE
        Test-CICDValidation
    #>
    [CmdletBinding()]
    param()
    
    try {
        Write-Host "[INFO] Running CI/CD validation test..." -ForegroundColor Cyan
        
        # Test basic operations
        $testValue = "CI/CD is working!"
        Write-Host "[OK] $testValue" -ForegroundColor Green
        
        # Test error handling
        if (Test-Path -Path $PSScriptRoot) {
            Write-Host "[OK] Script root path exists: $PSScriptRoot" -ForegroundColor Green
        }
        
        return $true
    }
    catch {
        Write-Host "[ERROR] Test failed: $_" -ForegroundColor Red
        return $false
    }
}

# Test 2: Demonstrate PSScriptAnalyzer best practices
function Get-SystemInformation {
    <#
    .SYNOPSIS
        Gets basic system information
    
    .DESCRIPTION
        Returns basic system information including OS and PowerShell version
    
    .EXAMPLE
        Get-SystemInformation
    #>
    [CmdletBinding()]
    param()
    
    try {
        $info = [PSCustomObject]@{
            PSVersion = $PSVersionTable.PSVersion.ToString()
            OS        = if ($IsWindows -or $PSVersionTable.PSVersion.Major -lt 6) {
                "Windows"
            } elseif ($IsLinux) {
                "Linux"
            } elseif ($IsMacOS) {
                "macOS"
            } else {
                "Unknown"
            }
            Date      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        
        Write-Host "[INFO] System Information:" -ForegroundColor Cyan
        Write-Host "  PowerShell Version: $($info.PSVersion)" -ForegroundColor White
        Write-Host "  Operating System: $($info.OS)" -ForegroundColor White
        Write-Host "  Current Date: $($info.Date)" -ForegroundColor White
        
        return $info
    }
    catch {
        Write-Host "[ERROR] Failed to get system information: $_" -ForegroundColor Red
        throw
    }
}

# Main execution
if ($MyInvocation.InvocationName -ne '.') {
    Write-Host "`n=== CI/CD Test Script ===" -ForegroundColor Cyan
    Write-Host "This script demonstrates proper PowerShell coding practices" -ForegroundColor White
    Write-Host "that will pass CI/CD validation checks.`n" -ForegroundColor White
    
    # Run tests
    $validationResult = Test-CICDValidation
    $systemInfo = Get-SystemInformation
    
    if ($validationResult) {
        Write-Host "`n[SUCCESS] All tests passed! This script follows best practices." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "`n[FAILURE] Some tests failed." -ForegroundColor Red
        exit 1
    }
}
