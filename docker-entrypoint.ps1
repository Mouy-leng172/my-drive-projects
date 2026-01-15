Write-Host 'Container ready.' -ForegroundColor Green
Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  My Drive Projects Container' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'This container includes:' -ForegroundColor Yellow
Write-Host '  - PowerShell 7.5 automation scripts' -ForegroundColor White
Write-Host '  - Python trading bridge' -ForegroundColor White
Write-Host '  - Telegram notification service' -ForegroundColor White
Write-Host '  - Multi-broker API support (Exness, Bitget)' -ForegroundColor White
Write-Host ''
Write-Host 'Available services:' -ForegroundColor Yellow
Write-Host '  - Trading Bridge: cd trading-bridge && python3 -m python.services.background_service' -ForegroundColor White
Write-Host '  - Project Scanner: pwsh -File ./project-scanner/run-all-projects.ps1' -ForegroundColor White
Write-Host ''
Write-Host 'Top-level .ps1 scripts (first 30):' -ForegroundColor Yellow
Get-ChildItem -Path . -Filter '*.ps1' -File |
    Select-Object -First 30 |
    ForEach-Object { '  ' + $_.Name }
