<#
.SYNOPSIS
    Suggests the optimal Harness skill for a given user prompt using TypeSafe Jev (System One).

.DESCRIPTION
    Analyzes a user request or task description against the repository's 17 skills catalog
    using Jev's Choice primitive. Returns the recommended skill name, confidence, and probabilities.
    Includes an automatic heuristic fallback for offline or unauthenticated environments.

.PARAMETER Prompt
    The user's prompt or task description to evaluate.

.PARAMETER ApiKey
    Optional API key override. If omitted, invoke-typesafe.ps1 discovers credentials dynamically.

.OUTPUTS
    [PSCustomObject] containing:
      - Skill (string): The recommended skill name.
      - Confidence (float): Model confidence score (0.0 to 1.0).
      - Probabilities (hashtable): Probability distribution across skills.
      - Fallback (bool): True if heuristic fallback was used instead of live Jev.
      - Mode (string): 'JevDecision' or 'HeuristicFallback'.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Prompt,

    [string]$ApiKey = $null,

    [switch]$Quiet
)

$invokeScript = Join-Path $PSScriptRoot "invoke-typesafe.ps1"
if (-not (Test-Path $invokeScript)) {
    throw "invoke-typesafe.ps1 not found in $PSScriptRoot"
}

# 1. Define Skills Catalog Criteria
$skillsCriteria = @{
    "typesafe-ai"                = "Semantic judgments, fast classification, probabilistic routing, Jev primitives, TypeSafe API/SDK"
    "writing-for-agents"         = "Creating or editing agent skills, guidelines, AGENTS.md, CLAUDE.md, prompt instructions"
    "goal-griller"               = "Transforming fuzzy ideas into verifiable autonomous goals, interview before goal mode (/goal)"
    "improve-harness"            = "Applying scoped improvements to harness repo guidance, routing, skills, tools, or validation"
    "ticket-solving"             = "Investigating, organizing, and solving user tickets and bug reports"
    "herdr-coordinate-agents"    = "Coordinating multi-agent worker sessions via Herdr"
    "orca-ade-coordinate-agents" = "Multi-agent coordination using Orca ADE terminal multiplexing and worktrees"
    "sequence-execution-plan"    = "Building dependency-aware execution plans, sequencing backlogs or prerequisites"
    "prompt-leverage"            = "Upgrading raw prompts into execution-ready instructions, rules, or templates"
    "onboarding"                 = "Mapping brownfield business or data flows into domain context"
    "domain-audit"               = "Adding or auditing domain knowledge and checking freshness against codebase"
    "xia"                        = "Researching unfamiliar libraries, risky implementation, or external APIs before coding"
    "utilizing-tools-agy"        = "Selecting and declaring Antigravity tools, subagents, and plugins"
    "utilizing-tools-claude"     = "Selecting and declaring Claude Code tools, deferred tools, and subagents"
    "utilizing-tools-codex"      = "Selecting and declaring Codex built-in tools, apps, and plugins"
    "utilizing-tools-opencode"   = "Selecting and declaring OpenCode built-in tools, variants, and subagents"
    "utilizing-tools-orca-ade"   = "Selecting and declaring Orca ADE CLI browser and terminal tools"
}

# 2. Heuristic fallback function (offline / no key)
function Get-HeuristicFallbackSkill([string]$text) {
    $lower = $text.ToLowerInvariant()
    if ($lower -match "goal|grill|objective|spec") { return "goal-griller" }
    if ($lower -match "write|writing|doc|guideline|agents\.md|claude\.md|instruction") { return "writing-for-agents" }
    if ($lower -match "ticket|issue|bug|triage|incident|defect") { return "ticket-solving" }
    if ($lower -match "improve|harness|refactor|benchmark") { return "improve-harness" }
    if ($lower -match "jev|typesafe|semantic|judgment|classify|eval") { return "typesafe-ai" }
    if ($lower -match "orca|worktree|multiplex") { return "utilizing-tools-orca-ade" }
    if ($lower -match "plan|sequence|dependency|prerequisite|backlog") { return "sequence-execution-plan" }
    if ($lower -match "research|investigate|explore|xia") { return "xia" }
    if ($lower -match "herdr|worker|dispatch|delegate") { return "herdr-coordinate-agents" }
    if ($lower -match "onboard|brownfield|data-flow") { return "onboarding" }
    if ($lower -match "domain|audit|freshness") { return "domain-audit" }
    if ($lower -match "prompt|template|leverage") { return "prompt-leverage" }
    return "typesafe-ai"
}

# 3. Call Jev via invoke-typesafe.ps1
$stateObj = @{
    user_prompt = $Prompt
}

$questionsObj = @{
    suggested_skill = @{
        type         = "choice"
        instructions = "Select the single best skill from criteria to handle the user's prompt or task."
        criteria     = $skillsCriteria
    }
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -ApiKey $ApiKey -Quiet:$Quiet

# 4. Handle Result or Fallback
if ($eval.Fallback -or (-not $eval.Success)) {
    $fallbackSkill = Get-HeuristicFallbackSkill -text $Prompt
    if (-not $Quiet) {
        Write-Host "[SmartRouter] Fallback Skill Selected: $fallbackSkill (Mode: HeuristicFallback)`n" -ForegroundColor Yellow
    }
    return [PSCustomObject]@{
        Skill         = $fallbackSkill
        Confidence    = 0.5
        Probabilities = $null
        Fallback      = $true
        Mode          = "HeuristicFallback"
        Warning       = $eval.Warning
    }
}

$choiceAnswer = $eval.Answers.suggested_skill
if (-not $Quiet) {
    Write-Host "[SmartRouter] >>> Recommended Skill: $($choiceAnswer.choice) (Confidence: $($choiceAnswer.confidence)) [Mode: JevDecision]`n" -ForegroundColor Magenta
}

return [PSCustomObject]@{
    Skill         = $choiceAnswer.choice
    Confidence    = $choiceAnswer.confidence
    Probabilities = $choiceAnswer.probabilities
    Fallback      = $false
    Mode          = "JevDecision"
    Warning       = $null
}
