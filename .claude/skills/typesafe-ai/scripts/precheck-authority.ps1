<#
.SYNOPSIS
    Hybrid Preflight Hook for Task Authority Gate (docs-harness/harness-constraints/0822).

.DESCRIPTION
    Best Practice 1: Hybrid Task Authority Precheck.
    Evaluates shell commands and proposed file actions against the repository's
    Task Authority Policy (AGENTS.md & 0822-user-authority-operation-gate.md).
    Uses a sub-millisecond (<5ms) regex fast-path for obvious read-only and hard-blocked
    mutations, and delegates ambiguous commands to TypeSafe Jev System One (~450ms)
    for semantic classification.

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
      - Classification (string): 'ReadOnlyRoutine', 'LocalRoutineAuthorized', or 'CriticalMutationRequiresUserAuthority'.
      - Mode (string): 'RegexFastPath', 'RegexHardBoundary', 'JevSemanticEvaluation', or 'GracefulFallback'.
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

# Classify every segment of a chained, piped or substituted command, so a
# read-only prefix cannot carry a mutation (e.g. "git status; git push").
# A quoted separator may over-split; that only routes the command to Jev.
$segments = @([regex]::Split($trimmedCmd, '\|\||&&|;|\||\r?\n|\$\(|`') |
    ForEach-Object { $_.Trim().TrimStart('(', '{').TrimEnd(')', '}').Trim() } |
    Where-Object { $_ })

# -------------------------------------------------------------------------
# Step 1: Sub-millisecond Regex Fast-Path for Known Read-Only Operations
# -------------------------------------------------------------------------
$readOnlyPattern = '^(Get-ChildItem|dir\b|ls\b|Get-Content|cat\b|type\b|Get-Item|Test-Path|view_file|git\s+(status|diff|log|branch|show)|read_file|findstr|Select-String|grep\b|pwd\b|echo\b|Write-Host)'
$allSegmentsReadOnly = $segments.Count -gt 0 -and @($segments | Where-Object { $_ -notmatch $readOnlyPattern }).Count -eq 0
if ($allSegmentsReadOnly -and $trimmedCmd -notmatch '(>|>>|Set-Content|Out-File|Remove-Item|del\b|rm\b)') {
    $stopwatch.Stop()
    $latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)
    if (-not $Quiet) {
        Write-Host "[AuthorityGate] [FAST-PASS] Read-only command verified in ${latency}ms: $trimmedCmd" -ForegroundColor Green
    }
    return [PSCustomObject]@{
        Permitted              = $true
        RequiresUserPermission = $false
        Risk                   = "Low"
        Classification         = "ReadOnlyRoutine"
        Mode                   = "RegexFastPath"
        LatencyMs              = $latency
        Reason                 = "Matches known read-only pattern with zero file or repository state mutation."
    }
}

# -------------------------------------------------------------------------
# Step 2: Sub-millisecond Regex Hard Boundary for Critical Mutations
# -------------------------------------------------------------------------
$hardBoundaryPattern = '^(git\s+(add\b|commit\b|push\b|rebase\b|reset\s+--hard|clean\s+-[a-zA-Z]*f)|rm\s+-[a-zA-Z]*r|Remove-Item\s+.*-Recurse|format\s+[a-zA-Z]:|Drop-Database)'
if (@($segments | Where-Object { $_ -match $hardBoundaryPattern }).Count -gt 0) {
    $stopwatch.Stop()
    $latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)
    if (-not $Quiet) {
        Write-Host "`n[AuthorityGate] [HARD-BLOCK] Critical mutation requires explicit User permission (${latency}ms)!" -ForegroundColor Red
        Write-Host "[AuthorityGate] Command: $trimmedCmd" -ForegroundColor Yellow
        Write-Host "[AuthorityGate] Rule: Git index mutations (add/commit/push) and destructive commands violate policy without explicit User authority.`n" -ForegroundColor Red
    }
    return [PSCustomObject]@{
        Permitted              = $false
        RequiresUserPermission = $true
        Risk                   = "Critical"
        Classification         = "CriticalMutationRequiresUserAuthority"
        Mode                   = "RegexHardBoundary"
        LatencyMs              = $latency
        Reason                 = "Violates strict User Authority constraint: Git staging, commits, pushes, and destructive operations require explicit User approval."
    }
}

# -------------------------------------------------------------------------
# Step 3: Ambiguous Operations -> Delegate to TypeSafe Jev System One
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
        LatencyMs              = $latency
        Reason                 = "Helper script missing; defaulting to safe conservative gate."
    }
}

$stateObj = @{
    command            = $trimmedCmd
    action_description = $ActionDescription
    target_files       = $TargetFiles
    authority_policy   = "Policy 0822: Read-only answers require zero mutations. Local fix/build authorizes routine local edits and tests. Staging, commit, push, external network requests, or destructive file operations strictly require explicit User authorization."
}

$questionsObj = @{
    authority_classification = @{
        type         = "choice"
        instructions = "Classify this command under the repository's 0822 Task Authority Policy."
        criteria     = @{
            "read_only_routine"                      = "Command only reads repository state, inspects files, runs read-only tests, or queries status without mutations"
            "local_routine_authorized"               = "Command performs routine local temporary builds, test fixtures, formatting, or edits authorized by a fix/build task"
            "critical_mutation_requires_permission"  = "Command mutates git repository index (add/commit/push), touches external services, accesses credentials, or permanently deletes files"
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
    Write-Host "[AuthorityGate] Ambiguous command detected. Requesting Jev semantic judgment..." -ForegroundColor Cyan
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -Quiet:$Quiet

$stopwatch.Stop()
$latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)

if ($eval.Fallback -or (-not $eval.Success)) {
    # Conservative fallback when offline or missing key
    $isSuspect = ($trimmedCmd -match '(\bSet-Content\b|\bOut-File\b|\bdel\b|\brm\b|\bInvoke-RestMethod\b|\bgit\b)')
    return [PSCustomObject]@{
        Permitted              = (-not $isSuspect)
        RequiresUserPermission = $isSuspect
        Risk                   = if ($isSuspect) { "Moderate" } else { "Low" }
        Classification         = if ($isSuspect) { "ConservativeFallbackRestricted" } else { "ConservativeFallbackPermitted" }
        Mode                   = "GracefulFallback"
        LatencyMs              = $latency
        Reason                 = "Jev evaluation unavailable ($($eval.Error)). Conservative heuristic applied."
    }
}

$classification = $eval.Answers.authority_classification.choice
$riskScore = $eval.Answers.risk_score.score
$requiresUserPermission = ($classification -eq "critical_mutation_requires_permission" -or $riskScore -ge 1.4)
$permitted = (-not $requiresUserPermission)

$riskLevel = if ($riskScore -lt 0.7) { "Low" } elseif ($riskScore -lt 1.4) { "Moderate" } else { "Critical" }

if (-not $Quiet) {
    if ($requiresUserPermission) {
        Write-Host "`n[AuthorityGate] [GATE REQUIRED] Explicit User authority needed before running (${latency}ms)!" -ForegroundColor Yellow
        Write-Host "[AuthorityGate] Classification: $classification (Risk Score: $riskScore)" -ForegroundColor Yellow
        Write-Host "[AuthorityGate] Reason: High risk or persistent mutation requires User confirmation.`n" -ForegroundColor Yellow
    } else {
        Write-Host "[AuthorityGate] [SEMANTIC-PASS] Command authorized under routine local scope in ${latency}ms (Risk: $riskScore)" -ForegroundColor Green
    }
}

return [PSCustomObject]@{
    Permitted              = $permitted
    RequiresUserPermission = $requiresUserPermission
    Risk                   = $riskLevel
    Classification         = $classification
    Mode                   = "JevSemanticEvaluation"
    LatencyMs              = $latency
    Reason                 = "Jev evaluated classification as '$classification' with risk score $riskScore"
}
