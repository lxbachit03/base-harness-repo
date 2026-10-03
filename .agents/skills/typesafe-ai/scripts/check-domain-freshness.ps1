<#
.SYNOPSIS
    Evaluates domain documentation freshness and detects contract drift using TypeSafe Jev System One.

.DESCRIPTION
    Best Practice 4: Domain Spec Freshness Validation Cascade.
    Compares code diffs or implementation changes against canonical domain specifications
    (docs-harness/domain/README.md) using Noul and Score primitives.
    Flags domain knowledge for STATUS: needs-review and Freshness: STALE when code-level
    schema or business logic drift contradicts it. Confirmation tags stay unchanged;
    only the User changes them (docs-harness/domain/README.md).

.PARAMETER DomainPath
    Path to the domain Markdown file (e.g. docs-harness/domain/0902-auth-service/README.md).

.PARAMETER DomainText
    Raw domain document text if not reading from a file.

.PARAMETER CodeDiffOrSummary
    Git diff, commit changes, or summary of modified code.

.PARAMETER Quiet
    Suppresses console output and returns only the result object.

.OUTPUTS
    [PSCustomObject] containing:
      - IsStale (bool): True if domain specification is likely outdated or contradictory.
      - StalenessProbability (double): Noul probability (0.0 to 1.0).
      - SeverityScore (double): 0.0 to 2.0.
      - SeverityLabel (string): Descriptive severity level.
      - Recommendation (string): 'KeepCurrent', 'MarkStaleAndScheduleReview', or 'ImmediateDomainUpdateRequired'.
      - LatencyMs (double): Execution latency in milliseconds.
#>
[CmdletBinding()]
param(
    [string]$DomainPath = "",

    [string]$DomainText = "",

    [Parameter(Mandatory = $true)]
    [string]$CodeDiffOrSummary,

    [switch]$Quiet
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# 1. Resolve Domain Specification Text
$domainSpec = $DomainText
if ([string]::IsNullOrWhiteSpace($domainSpec) -and [string]::IsNullOrWhiteSpace($DomainPath)) {
    throw "Either -DomainPath or -DomainText must be provided."
}
if ([string]::IsNullOrWhiteSpace($domainSpec)) {
    if (-not (Test-Path $DomainPath)) {
        throw "Domain document not found: $DomainPath"
    }
    $domainSpec = Get-Content -Path $DomainPath -Raw -Encoding UTF8
}

if ([string]::IsNullOrWhiteSpace($domainSpec)) {
    throw "Domain specification content is empty."
}

# 2. Invoke TypeSafe Jev System One
$invokeScript = Join-Path $PSScriptRoot "invoke-typesafe.ps1"
if (-not (Test-Path $invokeScript)) {
    throw "invoke-typesafe.ps1 not found in $PSScriptRoot"
}

$stateObj = @{
    domain_specification = $domainSpec
    code_diff_summary    = $CodeDiffOrSummary
}

$questionsObj = @{
    is_domain_stale = @{
        type         = "noul"
        instructions = "Does the provided code change invalidate, contradict, or require updates to the domain concepts, business rules, or schemas described in the domain specification?"
    }
    staleness_severity = @{
        type         = "score"
        instructions = "Rate the severity of drift between the code change and the domain specification."
        criteria     = @(
            "No impact; domain document remains accurate, synchronized, and complete",
            "Minor drift; non-breaking additions or cosmetic terminology updates needed",
            "Breaking staleness; core domain invariants, schemas, or business assumptions have been invalidated by the code change"
        )
    }
}

if (-not $Quiet) {
    Write-Host "[DomainFreshness] Verifying domain freshness with TypeSafe Jev System One..." -ForegroundColor Cyan
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -Quiet:$Quiet

$stopwatch.Stop()
$latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)

if ($eval.Fallback -or (-not $eval.Success)) {
    Write-Warning "Jev domain freshness evaluation unavailable. Using fallback default values."
    return [PSCustomObject]@{
        IsStale              = $false
        StalenessProbability = 0.5
        SeverityScore        = 0.5
        SeverityLabel        = "Indeterminate (Fallback)"
        Recommendation       = "MarkStaleAndScheduleReview"
        Mode                 = "GracefulFallback"
        LatencyMs            = $latency
    }
}

$staleProb = $eval.Answers.is_domain_stale.noul
$sevScore = $eval.Answers.staleness_severity.score
$isStale = ($staleProb -ge 0.5)

$sevLegend = $eval.Answers.staleness_severity.legend
$sevIndex = [math]::Min([int][math]::Round($sevScore), 2)
$sevLabel = $sevLegend."$sevIndex"

$recommendation = if ($staleProb -lt 0.4) {
    "KeepCurrent"
} elseif ($sevScore -ge 1.4) {
    "ImmediateDomainUpdateRequired"
} else {
    "MarkStaleAndScheduleReview"
}

if (-not $Quiet) {
    Write-Host "`n[DomainFreshness] === DOMAIN FRESHNESS RESULT (${latency}ms) ===" -ForegroundColor $(if ($isStale) { "Yellow" } else { "Green" })
    Write-Host "Is Stale / Outdated    : $(if ($isStale) { 'YES (Drift Detected)' } else { 'NO (Synchronized)' })" -ForegroundColor White
    Write-Host "Staleness Probability  : $([math]::Round($staleProb * 100, 1))%" -ForegroundColor White
    Write-Host "Drift Severity Score   : $([math]::Round($sevScore, 2)) ($sevLabel)" -ForegroundColor White
    Write-Host "Recommendation         : $recommendation" -ForegroundColor $(if ($recommendation -eq 'KeepCurrent') { "Green" } else { "Yellow" })
    Write-Host "[DomainFreshness] =============================================`n" -ForegroundColor $(if ($isStale) { "Yellow" } else { "Green" })
}

return [PSCustomObject]@{
    IsStale              = $isStale
    StalenessProbability = [math]::Round($staleProb, 3)
    SeverityScore        = [math]::Round($sevScore, 2)
    SeverityLabel        = $sevLabel
    Recommendation       = $recommendation
    Mode                 = "JevDecision"
    LatencyMs            = $latency
}
