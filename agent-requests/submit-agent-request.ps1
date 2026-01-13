<#
.SYNOPSIS
  Submit an Agent Request to a destination (GitHub issue or paste prompt).

.DESCRIPTION
  Renders the request JSON to Markdown and optionally creates a GitHub issue
  via the authenticated GitHub CLI (`gh`).

.PARAMETER RequestPath
  Path to the request JSON file.

.PARAMETER Destination
  github-issue | paste-prompt | other

.PARAMETER Labels
  Optional labels override for GitHub issues.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$RequestPath,

  [Parameter(Mandatory = $false)]
  [ValidateSet("github-issue", "paste-prompt", "other")]
  [string]$Destination = "github-issue",

  [Parameter(Mandatory = $false)]
  [string[]]$Labels
)

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
  if (-not (Test-Path -LiteralPath $RequestPath)) {
    throw "Request file not found: $RequestPath"
  }

  $jsonRaw = Get-Content -LiteralPath $RequestPath -Raw
  $request = $jsonRaw | ConvertFrom-Json

  $renderScript = Join-Path $PSScriptRoot "render-agent-request.ps1"
  if (-not (Test-Path -LiteralPath $renderScript)) {
    throw "Render script not found: $renderScript"
  }

  $body = & $renderScript -RequestPath $RequestPath
  $title = $request.title

  if ($Destination -eq "paste-prompt" -or $Destination -eq "other") {
    Write-Status -Level "INFO" -Message "Rendered prompt (copy/paste):"
    $body
    exit 0
  }

  # github-issue
  if (-not (Get-Command -Name "gh" -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) not found in PATH."
  }

  $issueLabels = @()
  if ($Labels -and $Labels.Count -gt 0) {
    $issueLabels = @($Labels)
  } elseif ($null -ne $request.routing -and $null -ne $request.routing.github -and $null -ne $request.routing.github.labels) {
    $issueLabels = @($request.routing.github.labels | ForEach-Object { "$_" })
  } else {
    $issueLabels = @("agent-request", "$($request.type)")
  }

  $labelArgs = @()
  foreach ($l in $issueLabels) {
    if ($l) { $labelArgs += @("--label", $l) }
  }

  Write-Status -Level "INFO" -Message "Creating GitHub issue via gh..."
  $cmd = @("issue", "create", "--title", $title, "--body", $body) + $labelArgs
  $result = & gh @cmd

  if ($LASTEXITCODE -ne 0) {
    throw "gh issue create failed."
  }

  Write-Status -Level "OK" -Message "Created issue: $result"
} catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  exit 1
}

