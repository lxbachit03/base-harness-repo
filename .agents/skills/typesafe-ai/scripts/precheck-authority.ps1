<#
.SYNOPSIS
    Task Authority Gate precheck for shell commands (docs-harness/harness-constraints/0822).

.DESCRIPTION
    Best Practice 1: Task Authority Precheck.
    Evaluates shell commands and proposed file actions against the repository's
    Task Authority Policy (AGENTS.md & 0822-user-authority-operation-gate.md).
    Every command is classified by TypeSafe Jev System One (~450ms), so each
    verdict carries an observable request and response. A regex hard boundary
    runs on every command segment as an override: a segment that stages,
    commits, pushes or destroys data always requires explicit User authority,
    whatever Jev answers. Segments are split on shell separators outside quotes.

.PARAMETER Command
    The shell command or tool invocation to inspect.

.PARAMETER ActionDescription
    Optional descriptive context of the intended action.

.PARAMETER TargetFiles
    Optional array of file paths touched by this operation.

.PARAMETER Quiet
    Suppresses console output and returns only the result object.

.OUTPUTS
    [PSCustomObject] containing:
      - Permitted (bool): Whether the action can run under routine local authority.
      - RequiresUserPermission (bool): True if explicit User authority is mandatory.
      - Risk (string): 'Low', 'Moderate', or 'Critical'.
      - Classification (string): Jev's classification, 'CriticalMutationRequiresUserAuthority'
        when the hard boundary overrides it, or a 'ConservativeFallback*' value.
      - Mode (string): 'JevSemanticEvaluation', 'JevWithHardBoundary', or 'GracefulFallback'.
      - HardBoundarySegments (string[]): Segments that matched the hard boundary.
      - LatencyMs (double): Execution latency in milliseconds.
      - Reason (string): Explanation of the determination.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Command,

    [string]$ActionDescription = "",

    [string[]]$TargetFiles = @(),

    [switch]$Quiet
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$trimmedCmd = $Command.Trim()

# Split a command into the segments a shell would run separately. Separators
# (; | || && newline) inside single or double quotes do not split; command
# substitution ($( and backtick) still splits inside double quotes because the
# shell executes it there.
function Split-CommandSegments([string]$Text) {
    $parts = [System.Collections.Generic.List[string]]::new()
    $current = [System.Text.StringBuilder]::new()
    $quote = [char]0
    $i = 0
    while ($i -lt $Text.Length) {
        $c = $Text[$i]
        $pair = if ($i + 1 -lt $Text.Length) { $Text.Substring($i, 2) } else { '' }
        if ($quote -eq [char]"'") {
            if ($c -eq [char]"'") { $quote = [char]0 }
            [void]$current.Append($c); $i++; continue
        }
        if ($pair -eq '$(' -or $c -eq [char]'`') {
            $parts.Add($current.ToString()); [void]$current.Clear()
            $i += $(if ($pair -eq '$(') { 2 } else { 1 }); continue
        }
        if ($quote -eq [char]'"') {
            if ($c -eq [char]'"') { $quote = [char]0 }
            [void]$current.Append($c); $i++; continue
        }
        if ($c -eq [char]"'" -or $c -eq [char]'"') {
            $quote = $c; [void]$current.Append($c); $i++; continue
        }
        if ($pair -eq '&&' -or $pair -eq '||') {
            $parts.Add($current.ToString()); [void]$current.Clear(); $i += 2; continue
        }
        if ($c -eq [char]';' -or $c -eq [char]'|' -or $c -eq [char]"`n" -or $c -eq [char]"`r") {
            $parts.Add($current.ToString()); [void]$current.Clear(); $i++; continue
        }
        [void]$current.Append($c); $i++
    }
    $parts.Add($current.ToString())
    return @($parts |
        ForEach-Object { $_.Trim().TrimStart('(', '{').TrimEnd(')', '}').Trim() } |
        Where-Object { $_ })
}

$segments = Split-CommandSegments $trimmedCmd

# -------------------------------------------------------------------------
# Hard boundary: evaluated on every segment, applied after the Jev verdict
# -------------------------------------------------------------------------
$hardBoundaryPattern = '^(git\s+(add\b|commit\b|push\b|rebase\b|reset\s+--hard|clean\s+-[a-zA-Z]*f)|rm\s+-[a-zA-Z]*r|Remove-Item\s+.*-Recurse|format\s+[a-zA-Z]:|Drop-Database)'
$hardSegments = @($segments | Where-Object { $_ -match $hardBoundaryPattern })
$hardHit = $hardSegments.Count -gt 0

# -------------------------------------------------------------------------
# Jev classification for every command
# -------------------------------------------------------------------------
$invokeScript = Join-Path $PSScriptRoot "invoke-typesafe.ps1"
if (-not (Test-Path $invokeScript)) {
    $stopwatch.Stop()
    $latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)
    Write-Warning "invoke-typesafe.ps1 not found in $PSScriptRoot. Using conservative fallback."
    return [PSCustomObject]@{
        Permitted              = $false
        RequiresUserPermission = $true
        Risk                   = "Moderate"
        Classification         = "AmbiguousFallback"
        Mode                   = "GracefulFallback"
        HardBoundarySegments   = $hardSegments
        LatencyMs              = $latency
        Reason                 = "Helper script missing; defaulting to safe conservative gate."
    }
}

$stateObj = @{
    command            = $trimmedCmd
    segments           = $segments
    action_description = $ActionDescription
    target_files       = $TargetFiles
    authority_policy   = "Policy 0822: Read-only answers require zero mutations. Local fix/build authorizes routine local edits and tests. Staging, commit, push, external network requests, credential access, or destructive file operations strictly require explicit User authorization. The Jev helpers' own TypeSafe API calls and API-key lookup are routine (User decision 2026-10-05)."
}

$questionsObj = @{
    authority_classification = @{
        type         = "choice"
        instructions = "Classify this command, considering every segment, under the repository's 0822 Task Authority Policy."
        criteria     = @{
            "read_only_routine"                      = "Command only reads repository state, inspects files, runs read-only tests, or queries status without mutations"
            "local_routine_authorized"               = "Command performs routine local temporary builds, test fixtures, formatting, or edits authorized by a fix/build task"
            "critical_mutation_requires_permission"  = "Command mutates git repository index or refs (add/commit/push/branch deletion), touches external services or accesses credentials (other than the Jev helpers' own TypeSafe calls and key lookup), or permanently deletes files"
        }
    }
    risk_score = @{
        type         = "score"
        instructions = "Rate the mutation and irreversibility risk of this command."
        criteria     = @(
            "Safe; zero persistent changes or read-only inspection",
            "Low to Moderate; local file change that can be cleanly discarded via git checkout or undo",
            "High; persistent external mutation, commit/push, credential access, or destructive action"
        )
    }
}

if (-not $Quiet) {
    Write-Host "[AuthorityGate] Requesting Jev judgment for $($segments.Count) segment(s)..." -ForegroundColor Cyan
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -Quiet:$Quiet

$stopwatch.Stop()
$latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)

if ($eval.Fallback -or (-not $eval.Success)) {
    # Conservative fallback when offline or missing key
    $isSuspect = $hardHit -or ($trimmedCmd -match '(\bSet-Content\b|\bOut-File\b|\bdel\b|\brm\b|\bInvoke-RestMethod\b|\bgit\b)')
    return [PSCustomObject]@{
        Permitted              = (-not $isSuspect)
        RequiresUserPermission = $isSuspect
        Risk                   = if ($isSuspect) { "Moderate" } else { "Low" }
        Classification         = if ($isSuspect) { "ConservativeFallbackRestricted" } else { "ConservativeFallbackPermitted" }
        Mode                   = "GracefulFallback"
        HardBoundarySegments   = $hardSegments
        LatencyMs              = $latency
        Reason                 = "Jev evaluation unavailable ($($eval.Error)). Conservative heuristic applied."
    }
}

$classification = $eval.Answers.authority_classification.choice
$riskScore = $eval.Answers.risk_score.score
$requiresUserPermission = ($hardHit -or $classification -eq "critical_mutation_requires_permission" -or $riskScore -ge 1.4)
$permitted = (-not $requiresUserPermission)

$riskLevel = if ($hardHit -or $riskScore -ge 1.4) { "Critical" } elseif ($riskScore -lt 0.7) { "Low" } else { "Moderate" }
$mode = if ($hardHit) { "JevWithHardBoundary" } else { "JevSemanticEvaluation" }
$finalClass = if ($hardHit) { "CriticalMutationRequiresUserAuthority" } else { $classification }
$reason = if ($hardHit) {
    "Hard boundary matched segment(s) [$($hardSegments -join ' | ')]; explicit User authority required (Jev: '$classification', risk $riskScore)."
} else {
    "Jev evaluated classification as '$classification' with risk score $riskScore"
}

if (-not $Quiet) {
    if ($requiresUserPermission) {
        Write-Host "`n[AuthorityGate] [GATE REQUIRED] Explicit User authority needed before running (${latency}ms)!" -ForegroundColor Yellow
        Write-Host "[AuthorityGate] Jev: $classification (Risk Score: $riskScore)" -ForegroundColor Yellow
        if ($hardHit) {
            Write-Host "[AuthorityGate] Hard boundary segment(s): $($hardSegments -join ' | ')" -ForegroundColor Red
        }
        Write-Host ""
    } else {
        Write-Host "[AuthorityGate] [SEMANTIC-PASS] Command authorized under routine local scope in ${latency}ms (Risk: $riskScore)" -ForegroundColor Green
    }
}

return [PSCustomObject]@{
    Permitted              = $permitted
    RequiresUserPermission = $requiresUserPermission
    Risk                   = $riskLevel
    Classification         = $finalClass
    Mode                   = $mode
    HardBoundarySegments   = $hardSegments
    LatencyMs              = $latency
    Reason                 = $reason
}
