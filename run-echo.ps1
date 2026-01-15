#Requires -Version 5.1
<#
.SYNOPSIS
    Simple "echo" test script for automation/scheduled tasks.
#>

$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "[OK] Echo OK - $ts" -ForegroundColor Green

