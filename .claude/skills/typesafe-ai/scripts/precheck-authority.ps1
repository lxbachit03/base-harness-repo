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

$segments = @(Split-CommandSegments $trimmedCmd)

# -------------------------------------------------------------------------
# Hard boundary: evaluated on every segment, applied after the Jev verdict
# -------------------------------------------------------------------------
function Test-HardBoundary([string]$Text, [int]$Depth = 0) {
    if ($Depth -gt 4) { return $false }
    $candidate = $Text.Trim()
    if ($candidate -match '^&\s+') { $candidate = $candidate.Substring($Matches[0].Length).Trim() }

    # Inspect literal command strings passed through common shell wrappers.
    $wrapper = '(?is)^(?:cmd(?:\.exe)?\s+(?:/s\s+)?/[ck]|(?:powershell|pwsh)(?:\.exe)?\s+(?:(?:-noprofile|-nologo|-noninteractive)\s+)*(?:-command|-c)|(?:bash|sh)(?:\.exe)?\s+-c)\s+(?<inner>.+)$'
    if ($candidate -match $wrapper) {
        $inner = $Matches['inner'].Trim()
        if ($inner.Length -ge 2 -and ($inner[0] -eq [char]34 -or $inner[0] -eq [char]39) -and $inner[$inner.Length - 1] -eq $inner[0]) {
            $inner = $inner.Substring(1, $inner.Length - 2)
        }
        foreach ($part in @(Split-CommandSegments $inner)) {
            if (Test-HardBoundary -Text $part -Depth ($Depth + 1)) { return $true }
        }
        return $false
    }

    if ($candidate -match '^(rm\s+-[a-zA-Z]*r|Remove-Item\s+.*-Recurse|format\s+[a-zA-Z]:|Drop-Database)') {
        return $true
    }
    $tokenPattern = '"(?:[^"]|"")*"|''(?:[^'']|'''')*''|\S+'
    $words = @([regex]::Matches($candidate, $tokenPattern) | ForEach-Object { $_.Value.Trim([char[]]@([char]34, [char]39)) })
    if ($words.Count -lt 2 -or $words[0] -notmatch '(?i)(?:^|[\\/])git(?:\.exe)?$') { return $false }

    $index = 1
    $optionsWithValue = @('-C', '-c', '--git-dir', '--work-tree', '--namespace', '--exec-path', '--config-env', '--super-prefix')
    while ($index -lt $words.Count) {
        $word = $words[$index]
        if ($word -in $optionsWithValue) { $index += 2; continue }
        if ($word -match '^(?:-[Cc].+|--(?:git-dir|work-tree|namespace|exec-path|config-env|super-prefix)=.+)$' -or
            $word -in @('--no-pager', '--paginate', '--bare', '--no-optional-locks', '--literal-pathspecs', '--glob-pathspecs', '--noglob-pathspecs', '--icase-pathspecs')) {
            $index++; continue
        }
        break
    }
    if ($index -ge $words.Count) { return $false }
    $subcommand = $words[$index].ToLowerInvariant()
    $arguments = @($words | Select-Object -Skip ($index + 1))
    if ($subcommand -in @('add', 'commit', 'push', 'rebase', 'rm', 'mv')) { return $true }
    if ($subcommand -eq 'reset' -and $arguments -contains '--hard') { return $true }
    if ($subcommand -eq 'restore' -and ($arguments -contains '--staged' -or $arguments -ccontains '-S')) { return $true }
    if ($subcommand -eq 'branch' -and @($arguments | Where-Object { $_ -in @('-d', '-D', '--delete') }).Count -gt 0) { return $true }
    if ($subcommand -eq 'clean' -and @($arguments | Where-Object { $_ -match '^(--force|-[^-]*f)' }).Count -gt 0) { return $true }
    return $false
}

$hardSegments = @($segments | Where-Object { Test-HardBoundary -Text $_ })
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
        Fallback               = $true
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

$classification = $null
$riskScore = $null
$invalidAnswer = $false
if ($null -ne $eval -and -not $eval.Fallback -and $eval.Success) {
    if ($null -ne $eval.Answers) {
        $classification = $eval.Answers.authority_classification.choice
        $riskScore = $eval.Answers.risk_score.score
    }
    $validScore = $false
    if ($null -ne $riskScore -and $riskScore -is [ValueType] -and $riskScore -isnot [bool]) {
        try {
            $numericRisk = [double]$riskScore
            $validScore = (-not [double]::IsNaN($numericRisk) -and -not [double]::IsInfinity($numericRisk) -and $numericRisk -ge 0 -and $numericRisk -le 2)
        } catch { $validScore = $false }
    }
    $invalidAnswer = ($classification -isnot [string] -or $classification -notin @('read_only_routine', 'local_routine_authorized', 'critical_mutation_requires_permission') -or -not $validScore)
}

if ($null -eq $eval -or $eval.Fallback -or (-not $eval.Success) -or $invalidAnswer) {
    # Conservative fallback when offline or missing key
    $isSuspect = $hardHit -or ($trimmedCmd -match '(\bSet-Content\b|\bOut-File\b|\bdel\b|\brm\b|\bInvoke-RestMethod\b|\bgit\b)')
    return [PSCustomObject]@{
        Permitted              = (-not $isSuspect)
        RequiresUserPermission = $isSuspect
        Risk                   = if ($isSuspect) { "Moderate" } else { "Low" }
        Classification         = if ($isSuspect) { "ConservativeFallbackRestricted" } else { "ConservativeFallbackPermitted" }
        Mode                   = "GracefulFallback"
        Fallback               = $true
        HardBoundarySegments   = $hardSegments
        LatencyMs              = $latency
        Reason                 = if ($invalidAnswer) { "Jev returned invalid authority answers. Conservative heuristic applied." } else { "Jev evaluation unavailable. Conservative heuristic applied." }
    }
}

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
    Fallback               = $false
    HardBoundarySegments   = $hardSegments
    LatencyMs              = $latency
    Reason                 = $reason
}
