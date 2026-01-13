<#
.SYNOPSIS
  Render all request JSON files in agent-requests/inbox/ to Markdown in agent-requests/out/.

.DESCRIPTION
  Convenience script to support "review all requests":
  - Finds *.json in inbox
  - Renders each to a matching *.md in out
  - Writes an index file (out/_index.md) linking titles to files
#>

[CmdletBinding()]
param()

function Write-Status {
  param(
    [Parameter(Mandatory = $true)][ValidateSet("OK", "INFO", "WARNING", "ERROR")][string]$Level,
    [Parameter(Mandatory = $true)][string]$Message
  )
  $color = switch ($Level) {
    "OK" { "Green" }
    "INFO" { "Cyan" }
    "WARNING" { "Yellow" }
    "ERROR" { "Red" }
  }
  Write-Host "[$Level] $Message" -ForegroundColor $color
}

try {
  $inboxDir = Join-Path $PSScriptRoot "inbox"
  $outDir = Join-Path $PSScriptRoot "out"
  $renderScript = Join-Path $PSScriptRoot "render-agent-request.ps1"

  if (-not (Test-Path -LiteralPath $inboxDir)) {
    Write-Status -Level "WARNING" -Message "Inbox folder not found: $inboxDir"
    exit 0
  }
  if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
  if (-not (Test-Path -LiteralPath $renderScript)) {
    throw "Render script not found: $renderScript"
  }

  $jsonFiles = Get-ChildItem -LiteralPath $inboxDir -Filter "*.json" -File -ErrorAction Stop | Sort-Object Name
  if ($jsonFiles.Count -eq 0) {
    Write-Status -Level "INFO" -Message "No request JSON files found in inbox."
    exit 0
  }

  $indexLines = New-Object System.Collections.Generic.List[string]
  $indexLines.Add("## Agent Requests Index")
  $indexLines.Add("")

  foreach ($f in $jsonFiles) {
    try {
      $raw = Get-Content -LiteralPath $f.FullName -Raw
      $req = $raw | ConvertFrom-Json

      $mdPath = Join-Path $outDir ($f.BaseName + ".md")
      & $renderScript -RequestPath $f.FullName -OutputPath $mdPath | Out-Null

      $title = if ($null -ne $req.title -and $req.title) { $req.title } else { $f.BaseName }
      $type = if ($null -ne $req.type -and $req.type) { $req.type } else { "unknown" }
      $priority = if ($null -ne $req.priority -and $req.priority) { $req.priority } else { "medium" }
      $indexLines.Add("- **$type / $priority**: $title (``$($f.Name)`` -> ``$([IO.Path]::GetFileName($mdPath))``)")
    } catch {
      Write-Status -Level "WARNING" -Message "Failed rendering $($f.Name): $($_.Exception.Message)"
    }
  }

  $indexPath = Join-Path $outDir "_index.md"
  Set-Content -LiteralPath $indexPath -Value ($indexLines -join "`n") -Encoding UTF8
  Write-Status -Level "OK" -Message "Rendered $($jsonFiles.Count) request(s). Index: $indexPath"
} catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  exit 1
}

