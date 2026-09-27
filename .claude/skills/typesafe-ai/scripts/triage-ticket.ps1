<#
.SYNOPSIS
    Triage and score inbound tickets using TypeSafe Jev System One.

.DESCRIPTION
    Best Practice 3: Probabilistic Ticket Intake Triage & Complexity Scoring.
    Extracts semantic judgments from ticket reports (category, severity, reproduction clarity,
    and estimated implementation complexity) using typed Choice, Score, and Noul primitives.
    Enables rapid automated intake into docs-harness/tickets/active/.

.PARAMETER TicketPath
    Path to a ticket Markdown file (e.g., templates/ticket.md or a ticket in tickets/active/).

.PARAMETER Content
    Raw ticket text content if not reading from a file.

.PARAMETER Quiet
    Suppresses console output and returns only the result object.

.OUTPUTS
    [PSCustomObject] containing:
      - Category (string): 'bug_defect', 'feature_request', 'harness_refactor', or 'domain_documentation'.
      - SeverityScore (double): 0.0 to 2.0.
      - SeverityLabel (string): Descriptive severity level.
      - ComplexityScore (double): 0.0 to 2.0.
      - ComplexityLabel (string): Descriptive complexity level.
      - HasReproductionSteps (bool): Whether reproduction steps are clearly present.
      - RecommendedPriority (string): '[CRITICAL]', '[MEDIUM]', or '[NORMAL]'.
      - RecommendedModelTier (string): 'flash' (low complexity) or 'pro' (high complexity).
      - LatencyMs (double): Execution latency in milliseconds.
#>
[CmdletBinding()]
param(
    [string]$TicketPath = "",

    [string]$Content = "",

    [switch]$Quiet
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# 1. Resolve Ticket Content
$ticketText = $Content
if ([string]::IsNullOrWhiteSpace($ticketText) -and [string]::IsNullOrWhiteSpace($TicketPath)) {
    throw "Either -TicketPath or -Content must be provided."
}
if ([string]::IsNullOrWhiteSpace($ticketText)) {
    if (-not (Test-Path $TicketPath)) {
        throw "Ticket file not found: $TicketPath"
    }
    $ticketText = Get-Content -Path $TicketPath -Raw -Encoding UTF8
}

if ([string]::IsNullOrWhiteSpace($ticketText)) {
    throw "Ticket content is empty."
}

# 2. Invoke TypeSafe Jev System One
$invokeScript = Join-Path $PSScriptRoot "invoke-typesafe.ps1"
if (-not (Test-Path $invokeScript)) {
    throw "invoke-typesafe.ps1 not found in $PSScriptRoot"
}

$stateObj = @{
    ticket_content = $ticketText
}

$questionsObj = @{
    category = @{
        type         = "choice"
        instructions = "What is the primary category of this ticket?"
        criteria     = @{
            "bug_defect"           = "Software bug, unexpected error, broken behavior, regression, or crash"
            "feature_request"      = "Request for new functionality, user-facing feature, or capability addition"
            "harness_refactor"     = "Internal repository improvement, agent tooling, workflow script, or guideline update"
            "domain_documentation" = "Documentation update, domain business rule specification, or schema clarification"
        }
    }
    severity = @{
        type         = "score"
        instructions = "How severe is the issue or impact described in this ticket?"
        criteria     = @(
            "Cosmetic / Low; minor styling, typo, or non-functional documentation note",
            "Degraded / Medium; non-critical feature impaired, but workaround exists or scope is isolated",
            "Blocking / High; system crash, data loss risk, regression blocking core workflow, or critical failure"
        )
    }
    reproducibility = @{
        type         = "noul"
        instructions = "Does the ticket include concrete, verifiable steps to reproduce or clear observable environment details?"
    }
    complexity = @{
        type         = "score"
        instructions = "Estimate the engineering implementation complexity of resolving this ticket."
        criteria     = @(
            "Trivial; single file edit, localized bug fix, or simple parameter change",
            "Moderate; multi-file modification, unit test additions, or local refactoring",
            "Complex; architectural redesign, cross-subsystem dependencies, or multi-agent delegation"
        )
    }
}

if (-not $Quiet) {
    Write-Host "[TicketTriage] Triaging ticket with TypeSafe Jev System One..." -ForegroundColor Cyan
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -Quiet:$Quiet

$stopwatch.Stop()
$latency = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)

if ($eval.Fallback -or (-not $eval.Success)) {
    Write-Warning "Jev ticket triage unavailable. Using fallback default values."
    return [PSCustomObject]@{
        Category             = "bug_defect"
        SeverityScore        = 1.0
        SeverityLabel        = "Medium (Fallback)"
        ComplexityScore      = 1.0
        ComplexityLabel      = "Moderate (Fallback)"
        HasReproductionSteps = $false
        RecommendedPriority  = "[MEDIUM]"
        RecommendedModelTier = "flash"
        Mode                 = "GracefulFallback"
        LatencyMs            = $latency
    }
}

$category = $eval.Answers.category.choice
$sevScore = $eval.Answers.severity.score
$compScore = $eval.Answers.complexity.score
$hasRepro = ($eval.Answers.reproducibility.noul -ge 0.5)

$sevLegend = $eval.Answers.severity.legend
$sevIndex = [math]::Min([int][math]::Round($sevScore), 2)
$sevLabel = $sevLegend."$sevIndex"

$compLegend = $eval.Answers.complexity.legend
$compIndex = [math]::Min([int][math]::Round($compScore), 2)
$compLabel = $compLegend."$compIndex"

$recommendedPriority = if ($sevScore -ge 1.4) { "[CRITICAL]" } elseif ($sevScore -ge 0.7) { "[MEDIUM]" } else { "[NORMAL]" }
$recommendedModelTier = if ($compScore -ge 1.3) { "pro" } else { "flash" }

if (-not $Quiet) {
    Write-Host "`n[TicketTriage] === TRIAGE RESULT (${latency}ms) ===" -ForegroundColor Green
    Write-Host "Category             : $category" -ForegroundColor White
    Write-Host "Severity Score       : $([math]::Round($sevScore, 2)) ($sevLabel)" -ForegroundColor White
    Write-Host "Complexity Score     : $([math]::Round($compScore, 2)) ($compLabel)" -ForegroundColor White
    Write-Host "Reproduction Steps   : $(if ($hasRepro) { 'Yes (Verified)' } else { 'Missing / Incomplete' })" -ForegroundColor White
    Write-Host "Recommended Priority : $recommendedPriority" -ForegroundColor Green
    Write-Host "Recommended Tier     : $recommendedModelTier" -ForegroundColor Cyan
    Write-Host "[TicketTriage] ==================================`n" -ForegroundColor Green
}

return [PSCustomObject]@{
    Category             = $category
    SeverityScore        = [math]::Round($sevScore, 2)
    SeverityLabel        = $sevLabel
    ComplexityScore      = [math]::Round($compScore, 2)
    ComplexityLabel      = $compLabel
    HasReproductionSteps = $hasRepro
    ReproductionNoul     = $eval.Answers.reproducibility.noul
    RecommendedPriority  = $recommendedPriority
    RecommendedModelTier = $recommendedModelTier
    Mode                 = "JevDecision"
    LatencyMs            = $latency
}
