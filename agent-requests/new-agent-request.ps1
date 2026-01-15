<#
.SYNOPSIS
Creates a new agent request JSON (and rendered Markdown prompt).

.DESCRIPTION
Writes the request JSON into agent-requests/inbox/ and a rendered prompt into agent-requests/out/.
Both directories are gitignored by default.

.NOTES
- Never put tokens/keys/passwords in requests.
- Designed to be compatible with Windows PowerShell 5.1+.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("review", "fix", "debug", "maintenance", "documentation", "operations", "execute", "read", "write")]
  [string]$Type,

  [Parameter(Mandatory = $true)]
  [string]$Title,

  [Parameter(Mandatory = $true)]
  [string]$Instructions,

  [Parameter()]
  [ValidateSet("low", "medium", "high", "critical")]
  [string]$Priority = "medium",

  [Parameter()]
  [string[]]$Paths = @(),

  [Parameter()]
  [string[]]$Targets = @("cursor"),

  [Parameter()]
  [ValidateSet("local", "github-issue", "github-pr", "paste-prompt", "other")]
  [string]$Mode = "paste-prompt"
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

function New-SafeSlug {
  param([Parameter(Mandatory = $true)][string]$Text)

  $t = $Text.ToLowerInvariant()
  $t = $t -replace "[^a-z0-9]+", "-"
  $t = $t.Trim("-")
  if ([string]::IsNullOrWhiteSpace($t)) { $t = "request" }
  if ($t.Length -gt 60) { $t = $t.Substring(0, 60).Trim("-") }
  return $t
}

try {
  $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
  $inboxDir = Join-Path $repoRoot "agent-requests/inbox"
  $outDir = Join-Path $repoRoot "agent-requests/out"

  if (-not (Test-Path $inboxDir)) { New-Item -ItemType Directory -Path $inboxDir -Force | Out-Null }
  if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

  $id = [guid]::NewGuid().ToString()
  $createdAt = (Get-Date).ToUniversalTime().ToString("o")
  $stamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd_HHmmss")
  $slug = New-SafeSlug -Text $Title

  $targetObjs = @()
  foreach ($t in $Targets) {
    $targetObjs += [ordered]@{
      name  = $t
      mode  = $Mode
      notes = ""
    }
  }

  $request = [ordered]@{
    version     = "1.0"
    id          = $id
    created_at  = $createdAt
    type        = $Type
    priority    = $Priority
    title       = $Title
    instructions = $Instructions
    scope       = [ordered]@{
      paths = @($Paths)
      notes = ""
    }
    execution   = [ordered]@{
      allowed  = [ordered]@{ read = $true; write = $true; execute = $false; network = $false }
      commands = @()
    }
    constraints = [ordered]@{
      no_secrets              = $true
      do_not_push             = $true
      do_not_change_git_config = $true
    }
    routing     = [ordered]@{
      targets = @($targetObjs)
      github  = [ordered]@{ create_issue = $false; labels = @("agent-request", $Type); assignees = @() }
    }
  }

  $jsonPath = Join-Path $inboxDir ("{0}_{1}_{2}.json" -f $stamp, $Type, $slug)
  $mdPath = Join-Path $outDir ("{0}_{1}_{2}.md" -f $stamp, $Type, $slug)

  $json = ($request | ConvertTo-Json -Depth 12)
  Write-Utf8NoBomFile -Path $jsonPath -Content ($json + "`n")
  Write-Status -Level "OK" -Message ("Request JSON written: {0}" -f $jsonPath)

  $renderScript = Join-Path $PSScriptRoot "render-agent-request.ps1"
  if (Test-Path $renderScript) {
    & $renderScript -RequestPath $jsonPath -OutputPath $mdPath | Out-Null
    Write-Status -Level "OK" -Message ("Rendered prompt written: {0}" -f $mdPath)
  }
  else {
    Write-Status -Level "WARNING" -Message "render-agent-request.ps1 not found; skipping prompt render."
  }

  Write-Status -Level "INFO" -Message "Reminder: agent-requests/inbox and agent-requests/out are gitignored."
}
catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  throw
}

