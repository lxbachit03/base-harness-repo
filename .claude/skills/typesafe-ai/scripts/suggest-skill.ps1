<#
.SYNOPSIS
    Suggests optimal Harness skill(s) for a given user prompt using TypeSafe Jev (System One).

.DESCRIPTION
    Analyzes a user request or task description against the repository's 17 skills catalog
    using Jev's Choice primitive. Supports both single-skill and Multi-Skill Chain routing (Top-N thresholding)
    for composite tasks, returning PrimarySkill, SupportingSkills, and SkillChain.
    Includes an explicit-mention bypass and automatic heuristic fallback for offline environments.

.PARAMETER Prompt
    The user's prompt or task description to evaluate.

.PARAMETER ApiKey
    Optional API key override. If omitted, invoke-typesafe.ps1 discovers credentials dynamically.

.PARAMETER Threshold
    Probability threshold (0.0 to 1.0) for identifying supporting skills in composite tasks. Defaults to 0.12 (12%).

.PARAMETER MaxSkills
    Maximum number of skills to include in a multi-skill chain. Defaults to 3.

.PARAMETER ForceJev
    When specified, forces live Jev evaluation even if explicit skill names are mentioned in the prompt.

.PARAMETER Quiet
    Suppresses console output and returns only the result object.

.OUTPUTS
    [PSCustomObject] containing:
      - Skill (string): Primary recommended skill name (backward compatibility).
      - PrimarySkill (string): Top-ranked skill.
      - SupportingSkills (string[]): Additional skills meeting threshold for composite tasks.
      - SkillChain (string[]): Ordered array of skills to combine for execution.
      - IsComposite (bool): True if task benefits from multiple coordinating skills.
      - Confidence (float): Model confidence score (0.0 to 1.0).
      - Probabilities (hashtable/object): Probability distribution across skills.
      - Fallback (bool): True if heuristic fallback was used instead of live Jev.
      - Mode (string): 'ExplicitMention', 'JevDecision', 'JevCompositeDecision', or 'HeuristicFallback'.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Prompt,

    [string]$ApiKey = $null,

    [double]$Threshold = 0.12,

    [int]$MaxSkills = 3,

    [switch]$ForceJev,

    [switch]$Quiet
)

$invokeScript = Join-Path $PSScriptRoot "invoke-typesafe.ps1"
if (-not (Test-Path $invokeScript)) {
    throw "invoke-typesafe.ps1 not found in $PSScriptRoot"
}

# 1. Best Practice 2: Selective Routing Check (Bypass API if prompt explicitly specifies skill(s))
if (-not $ForceJev) {
    $promptLower = $Prompt.ToLowerInvariant()
    $explicitSkills = @(
        "typesafe-ai", "enhance-jev", "writing-for-agents", "goal-griller", "improve-harness",
        "ticket-solving", "herdr-coordinate-agents", "orca-ade-coordinate-agents",
        "sequence-execution-plan", "prompt-leverage", "onboarding", "domain-audit",
        "xia", "utilizing-tools-agy", "utilizing-tools-claude", "utilizing-tools-codex",
        "utilizing-tools-opencode", "utilizing-tools-orca-ade"
    )

    $matchedSkills = [System.Collections.Generic.List[string]]::new()
    foreach ($skillName in $explicitSkills) {
        if ($promptLower -match "(\`$$skillName\b|\b$skillName\b)") {
            if (-not $matchedSkills.Contains($skillName)) {
                $matchedSkills.Add($skillName)
            }
        }
    }

    if ($matchedSkills.Count -gt 0) {
        $primary = $matchedSkills[0]
        $supporting = if ($matchedSkills.Count -gt 1) { $matchedSkills.GetRange(1, $matchedSkills.Count - 1).ToArray() } else { @() }
        $isComposite = ($matchedSkills.Count -gt 1)

        if (-not $Quiet) {
            Write-Host "[SmartRouter] [SELECTIVE-BYPASS] Explicit skill(s) detected: $($matchedSkills -join ' -> ') (Mode: ExplicitMention)`n" -ForegroundColor Green
        }
        return [PSCustomObject]@{
            Skill            = $primary
            PrimarySkill     = $primary
            SupportingSkills = $supporting
            SkillChain       = $matchedSkills.ToArray()
            IsComposite      = $isComposite
            Confidence       = 1.0
            Probabilities    = @{ $primary = 1.0 }
            Fallback         = $false
            Mode             = "ExplicitMention"
            Warning          = $null
        }
    }
}

# 2. Define Skills Catalog Criteria
$skillsCriteria = @{
    "typesafe-ai"                = "Semantic judgments, fast classification, probabilistic routing, Jev primitives, TypeSafe API/SDK"
    "enhance-jev"                = "Customizing and synchronizing Jev semantic scripts and criteria with project-specific requirements in JEV-AI.md"
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

# 3. Heuristic fallback function (offline / no key)
function Get-HeuristicFallbackSkill([string]$text) {
    $lower = $text.ToLowerInvariant()
    if ($lower -match "enhance-jev|custom.*jev|adapt.*jev|jev-ai|manifest") { return "enhance-jev" }
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

# 4. Call Jev via invoke-typesafe.ps1
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

# 5. Handle Fallback
if ($eval.Fallback -or (-not $eval.Success)) {
    $fallbackSkill = Get-HeuristicFallbackSkill -text $Prompt
    if (-not $Quiet) {
        Write-Host "[SmartRouter] Fallback Skill Selected: $fallbackSkill (Mode: HeuristicFallback)`n" -ForegroundColor Yellow
    }
    return [PSCustomObject]@{
        Skill            = $fallbackSkill
        PrimarySkill     = $fallbackSkill
        SupportingSkills = @()
        SkillChain       = @($fallbackSkill)
        IsComposite      = $false
        Confidence       = 0.5
        Probabilities    = $null
        Fallback         = $true
        Mode             = "HeuristicFallback"
        Warning          = $eval.Warning
    }
}

# 6. Parse Multi-Skill Chain from Jev Probability Distribution
$choiceAnswer = $eval.Answers.suggested_skill
$probObj = $choiceAnswer.probabilities

$rankedList = @()
if ($probObj -is [System.Collections.IDictionary]) {
    foreach ($key in $probObj.Keys) {
        $rankedList += [PSCustomObject]@{ Skill = $key; Probability = [double]$probObj[$key] }
    }
} else {
    foreach ($prop in $probObj.PSObject.Properties) {
        $rankedList += [PSCustomObject]@{ Skill = $prop.Name; Probability = [double]$prop.Value }
    }
}

$rankedList = $rankedList | Sort-Object -Property Probability -Descending

$primarySkill = $choiceAnswer.choice
if ([string]::IsNullOrWhiteSpace($primarySkill) -and $rankedList.Count -gt 0) {
    $primarySkill = $rankedList[0].Skill
}

# Extract supporting skills that exceed threshold
$supportingSkills = @(
    $rankedList | Where-Object { $_.Skill -ne $primarySkill -and $_.Probability -ge $Threshold } |
    Select-Object -First ($MaxSkills - 1) | ForEach-Object { $_.Skill }
)

$skillChain = @($primarySkill) + $supportingSkills
$isComposite = ($supportingSkills.Count -gt 0)

if (-not $Quiet) {
    if ($isComposite) {
        Write-Host "`n[SmartRouter] >>> Multi-Skill Chain Detected: $($skillChain -join ' -> ')" -ForegroundColor Magenta
        Write-Host "             Primary: $primarySkill ($([math]::Round(($rankedList | Where-Object {$_.Skill -eq $primarySkill}).Probability * 100, 1))%)" -ForegroundColor Cyan
        foreach ($s in $supportingSkills) {
            $p = ($rankedList | Where-Object { $_.Skill -eq $s }).Probability
            Write-Host "             Supporting: $s ($([math]::Round($p * 100, 1))%)" -ForegroundColor DarkCyan
        }
        Write-Host "             Confidence: $($choiceAnswer.confidence) [Mode: JevCompositeDecision]`n" -ForegroundColor Gray
    } else {
        Write-Host "[SmartRouter] >>> Recommended Skill: $primarySkill (Confidence: $($choiceAnswer.confidence)) [Mode: JevDecision]`n" -ForegroundColor Magenta
    }
}

return [PSCustomObject]@{
    Skill            = $primarySkill
    PrimarySkill     = $primarySkill
    SupportingSkills = $supportingSkills
    SkillChain       = $skillChain
    IsComposite      = $isComposite
    Confidence       = $choiceAnswer.confidence
    Probabilities    = $probObj
    Fallback         = $false
    Mode             = if ($isComposite) { "JevCompositeDecision" } else { "JevDecision" }
    Warning          = $null
}
