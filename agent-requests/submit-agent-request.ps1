<#
.SYNOPSIS
Submits an agent request as a GitHub issue (optional workflow).

.DESCRIPTION
Reads a request JSON, renders a prompt, and uses `gh` to create an issue.
This is safe by default: it does not include secrets and does not push code.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$RequestPath,

  [Parameter()]
  [ValidateSet("github-issue", "other")]
  [string]$Destination = "github-issue",

  [Parameter()]
  [string]$Repo,

  [Parameter()]
  [string[]]$Labels = @("agent-request"),

  [Parameter()]
  [string[]]$Assignees = @()
)

function Write-Status {
  param(
    [Parameter(Mandatory = $true)][ValidateSet("OK", "INFO", "WARNING", "ERROR")][string]$Level,
    [Parameter(Mandatory = $true)][string]$Message
  )
  $color = "White"
  switch ($Level) {
    "OK" { $color = "Green" }
    "INFO" { $color = "Cyan" }
    "WARNING" { $color = "Yellow" }
    "ERROR" { $color = "Red" }
  }
  Write-Host ("[{0}] {1}" -f $Level, $Message) -ForegroundColor $color
}

try {
  if (-not (Test-Path $RequestPath)) { throw "RequestPath not found: $RequestPath" }

  if ($Destination -ne "github-issue") {
    throw "Unsupported -Destination '$Destination'. Only 'github-issue' is implemented."
  }

  $gh = Get-Command gh -ErrorAction SilentlyContinue
  if ($null -eq $gh) { throw "GitHub CLI (gh) not found on PATH." }

  if ([string]::IsNullOrWhiteSpace($Repo)) {
    $repoJson = & gh repo view --json nameWithOwner 2>$null
    if ([string]::IsNullOrWhiteSpace($repoJson)) {
      throw "Could not determine repo automatically. Pass -Repo owner/name."
    }
    $Repo = ($repoJson | ConvertFrom-Json).nameWithOwner
  }

  $raw = Get-Content -Path $RequestPath -Raw
  $req = $raw | ConvertFrom-Json

  $renderScript = Join-Path $PSScriptRoot "render-agent-request.ps1"
  if (-not (Test-Path $renderScript)) { throw "render-agent-request.ps1 not found next to this script." }
  $body = & $renderScript -RequestPath $RequestPath

  $finalLabels = @()
  if ($Labels) { $finalLabels += $Labels }
  if ($null -ne $req.type -and -not $finalLabels.Contains([string]$req.type)) { $finalLabels += [string]$req.type }

  $args = @("issue", "create", "--repo", $Repo, "--title", [string]$req.title, "--body", $body)
  foreach ($l in $finalLabels) { $args += @("--label", $l) }
  foreach ($a in $Assignees) { $args += @("--assignee", $a) }

  Write-Status -Level "INFO" -Message ("Creating issue in {0}..." -f $Repo)
  $url = & gh @args
  if ([string]::IsNullOrWhiteSpace($url)) { throw "Issue creation did not return a URL." }

  Write-Status -Level "OK" -Message ("Issue created: {0}" -f $url.Trim())
}
catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  throw
}

