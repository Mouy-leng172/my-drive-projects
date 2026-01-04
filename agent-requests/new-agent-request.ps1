<#
.SYNOPSIS
  Create a new Agent Request JSON and a rendered Markdown prompt.

.DESCRIPTION
  Writes a request JSON into agent-requests/inbox/ and a rendered Markdown
  prompt into agent-requests/out/. Both folders are gitignored by design.

.PARAMETER Type
  Request type (review|fix|debug|maintenance|documentation|operations|execute|read|write)

.PARAMETER Title
  Short request title.

.PARAMETER Instructions
  Detailed instructions / acceptance criteria.

.PARAMETER Paths
  Optional list of repo paths to constrain scope.

.PARAMETER Priority
  low|medium|high|critical

.PARAMETER Targets
  Routing targets (e.g., cursor, github, amp, gemini, qodo).
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("review", "fix", "debug", "maintenance", "documentation", "operations", "execute", "read", "write")]
  [string]$Type,

  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$Title,

  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$Instructions,

  [Parameter(Mandatory = $false)]
  [string[]]$Paths = @(),

  [Parameter(Mandatory = $false)]
  [ValidateSet("low", "medium", "high", "critical")]
  [string]$Priority = "medium",

  [Parameter(Mandatory = $false)]
  [string[]]$Targets = @("cursor"),

  [Parameter(Mandatory = $false)]
  [ValidateSet("local", "github-issue", "github-pr", "paste-prompt", "other")]
  [string]$TargetMode = "paste-prompt"
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

function New-Slug {
  param([Parameter(Mandatory = $true)][string]$Text)
  $slug = $Text.ToLowerInvariant()
  $slug = $slug -replace "[^a-z0-9]+", "-"
  $slug = $slug -replace "^-+|-+$", ""
  if (-not $slug) { $slug = "request" }
  if ($slug.Length -gt 60) { $slug = $slug.Substring(0, 60).TrimEnd("-") }
  return $slug
}

try {
  $inboxDir = Join-Path $PSScriptRoot "inbox"
  $outDir = Join-Path $PSScriptRoot "out"
  if (-not (Test-Path -LiteralPath $inboxDir)) { New-Item -ItemType Directory -Path $inboxDir -Force | Out-Null }
  if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

  $id = [guid]::NewGuid().ToString()
  $createdAt = (Get-Date).ToUniversalTime().ToString("o")
  $datePrefix = (Get-Date).ToString("yyyy-MM-dd")
  $slug = New-Slug -Text $Title
  $baseName = "${datePrefix}_${Type}_${slug}"
  $requestPath = Join-Path $inboxDir ("$baseName.json")
  $promptPath = Join-Path $outDir ("$baseName.md")

  $routingTargets = @()
  foreach ($t in $Targets) {
    $routingTargets += [ordered]@{
      name  = $t
      mode  = $TargetMode
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
      allowed  = [ordered]@{
        read    = $true
        write   = $true
        execute = $false
        network = $false
      }
      commands = @()
    }
    constraints = [ordered]@{
      no_secrets               = $true
      do_not_push              = $true
      do_not_change_git_config = $true
    }
    routing     = [ordered]@{
      targets = $routingTargets
      github  = [ordered]@{
        create_issue = $false
        labels       = @("agent-request", $Type)
        assignees    = @()
      }
    }
  }

  $json = $request | ConvertTo-Json -Depth 10
  Set-Content -LiteralPath $requestPath -Value $json -Encoding UTF8
  Write-Status -Level "OK" -Message "Request JSON created: $requestPath"

  $renderScript = Join-Path $PSScriptRoot "render-agent-request.ps1"
  if (Test-Path -LiteralPath $renderScript) {
    & $renderScript -RequestPath $requestPath -OutputPath $promptPath
  } else {
    Write-Status -Level "WARNING" -Message "Render script not found; skipping Markdown output."
  }

  Write-Status -Level "INFO" -Message "Done."
} catch {
  Write-Status -Level "ERROR" -Message $_.Exception.Message
  exit 1
}

