<#
.SYNOPSIS
  Render an Agent Request JSON file to a Markdown prompt.

.DESCRIPTION
  Reads a request JSON matching agent-requests/schema/agent-request.schema.json
  and outputs a Markdown document suitable for pasting into an agent chat
  or submitting as a GitHub issue body.

.PARAMETER RequestPath
  Path to the request JSON file.

.PARAMETER OutputPath
  Optional path to write the rendered Markdown. If not provided, writes to stdout.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$RequestPath,

  [Parameter(Mandatory = $false)]
  [string]$OutputPath
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

function ConvertTo-Markdown {
  param([Parameter(Mandatory = $true)]$Request)

  $paths = @()
  if ($null -ne $Request.scope -and $null -ne $Request.scope.paths) {
    $paths = @($Request.scope.paths | ForEach-Object { "$_" })
  }

  $targets = @()
  if ($null -ne $Request.routing -and $null -ne $Request.routing.targets) {
    $targets = @(
      $Request.routing.targets | ForEach-Object {
        $mode = if ($null -ne $_.mode -and $_.mode) { $_.mode } else { "paste-prompt" }
        $notes = if ($null -ne $_.notes -and $_.notes) { $_.notes } else { "" }
        if ($notes) { "- $($_.name) ($mode): $notes" } else { "- $($_.name) ($mode)" }
      }
    )
  }

  $allowed = $null
  if ($null -ne $Request.execution -and $null -ne $Request.execution.allowed) {
    $allowed = $Request.execution.allowed
  }

  $commands = @()
  if ($null -ne $Request.execution -and $null -ne $Request.execution.commands) {
    $commands = @($Request.execution.commands | ForEach-Object { "$_" })
  }

  $constraints = $null
  if ($null -ne $Request.constraints) { $constraints = $Request.constraints }

  $priority = if ($null -ne $Request.priority -and $Request.priority) { $Request.priority } else { "medium" }

  $md = New-Object System.Collections.Generic.List[string]
  $md.Add("## Agent Request")
  $md.Add("")
  $md.Add("### Summary")
  $md.Add("- **Title**: $($Request.title)")
  $md.Add("- **Type**: $($Request.type)")
  $md.Add("- **Priority**: $priority")
  $md.Add("- **Created**: $($Request.created_at)")
  $md.Add("- **Id**: $($Request.id)")
  $md.Add("")
  $md.Add("### Instructions")
  $md.Add($Request.instructions)
  $md.Add("")

  if ($paths.Count -gt 0) {
    $md.Add("### Scope")
    $md.Add("Paths:")
    foreach ($p in $paths) { $md.Add("- $p") }
    if ($null -ne $Request.scope -and $Request.scope.notes) {
      $md.Add("")
      $md.Add("Notes:")
      $md.Add("$($Request.scope.notes)")
    }
    $md.Add("")
  }

  if ($null -ne $allowed -or $commands.Count -gt 0) {
    $md.Add("### Execution")
    if ($null -ne $allowed) {
      $md.Add("- **Allowed**: read=$($allowed.read) write=$($allowed.write) execute=$($allowed.execute) network=$($allowed.network)")
    }
    if ($commands.Count -gt 0) {
      $md.Add("- **Suggested commands**:")
      foreach ($c in $commands) { $md.Add("  - $c") }
    }
    $md.Add("")
  }

  if ($null -ne $constraints) {
    $md.Add("### Constraints")
    $md.Add("- **No secrets**: $($constraints.no_secrets)")
    $md.Add("- **Do not push**: $($constraints.do_not_push)")
    $md.Add("- **Do not change git config**: $($constraints.do_not_change_git_config)")
    $md.Add("")
  }

  if ($targets.Count -gt 0) {
    $md.Add("### Routing")
    $md.AddRange($targets)
    $md.Add("")
  }

  return ($md -join "`n")
}

try {
  if (-not (Test-Path -LiteralPath $RequestPath)) {
    throw "Request file not found: $RequestPath"
  }

  $jsonRaw = Get-Content -LiteralPath $RequestPath -Raw
  $request = $jsonRaw | ConvertFrom-Json

  # Best-effort schema validation when Test-Json is available (PowerShell 7+).
  $schemaPath = Join-Path $PSScriptRoot "schema/agent-request.schema.json"
  if ((Get-Command -Name "Test-Json" -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath $schemaPath)) {
    try {
      $isValid = Test-Json -Json $jsonRaw -SchemaFile $schemaPath -ErrorAction Stop
      if (-not $isValid) {
        Write-Status -Level "WARNING" -Message "Request JSON did not validate against schema (continuing anyway)."
      } else {
        Write-Status -Level "OK" -Message "Request JSON validated against schema."
      }
    } catch {
      Write-Status -Level "WARNING" -Message "Schema validation skipped/failed: $($_.Exception.Message)"
    }
  } else {
    Write-Status -Level "INFO" -Message "Schema validation not available (continuing)."
  }

  $markdown = ConvertTo-Markdown -Request $request

  if ($OutputPath) {
    $outDir = Split-Path -Parent $OutputPath
    if ($outDir -and -not (Test-Path -LiteralPath $outDir)) {
      New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }
    Set-Content -LiteralPath $OutputPath -Value $markdown -Encoding UTF8
    Write-Status -Level "OK" -Message "Rendered Markdown written to: $OutputPath"
  } else {
    $markdown
  }
} catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  exit 1
}

