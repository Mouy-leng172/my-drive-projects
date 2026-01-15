<#
.SYNOPSIS
Renders an agent request JSON to a Markdown prompt for paste-into-agent usage.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$RequestPath,

  [Parameter()]
  [string]$OutputPath
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

function Write-Utf8NoBomFile {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Content
  )
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

try {
  if (-not (Test-Path $RequestPath)) {
    throw "RequestPath not found: $RequestPath"
  }

  $raw = Get-Content -Path $RequestPath -Raw
  $req = $raw | ConvertFrom-Json

  $paths = @()
  if ($null -ne $req.scope -and $null -ne $req.scope.paths) { $paths = @($req.scope.paths) }
  $pathsBlock = ""
  if ($paths.Count -gt 0) {
    $pathsBlock = ($paths | ForEach-Object { "- $($_)" }) -join "`n"
  }
  else {
    $pathsBlock = "- (none)"
  }

  $targetsBlock = "- (none)"
  if ($null -ne $req.routing -and $null -ne $req.routing.targets) {
    $targetsBlock = (@($req.routing.targets) | ForEach-Object { "- $($_.name) ($($_.mode))" }) -join "`n"
  }

  $prompt = @()
  $prompt += "## Agent Request"
  $prompt += ""
  $prompt += "- **id**: $($req.id)"
  $prompt += "- **created_at**: $($req.created_at)"
  $prompt += "- **type**: $($req.type)"
  if ($null -ne $req.priority) { $prompt += "- **priority**: $($req.priority)" }
  $prompt += ""
  $prompt += "### Title"
  $prompt += "$($req.title)"
  $prompt += ""
  $prompt += "### Scope (paths)"
  $prompt += $pathsBlock
  $prompt += ""
  $prompt += "### Routing targets"
  $prompt += $targetsBlock
  $prompt += ""
  $prompt += "### Instructions"
  $prompt += "<user_query>"
  $prompt += "$($req.instructions)"
  $prompt += "</user_query>"
  $prompt += ""

  $md = ($prompt -join "`n") + "`n"

  if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $md
  }
  else {
    $outDir = Split-Path -Parent $OutputPath
    if (-not [string]::IsNullOrWhiteSpace($outDir) -and -not (Test-Path $outDir)) {
      New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }
    Write-Utf8NoBomFile -Path $OutputPath -Content $md
    Write-Status -Level "OK" -Message ("Rendered Markdown written: {0}" -f $OutputPath)
  }
}
catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  throw
}

