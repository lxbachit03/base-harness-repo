<#
.SYNOPSIS
    Suggests optimal Harness skill(s) for a given user prompt using TypeSafe Jev (System One).

.DESCRIPTION
    Analyzes a user request or task description against the repository's available skills catalog
    using a Choice for primary ranking and independent Noul applicability judgments.
    Returns PrimarySkill, SupportingSkills, and SkillChain, or no skill when none qualifies.
    Includes an explicit-mention bypass and automatic heuristic fallback for offline environments.

.PARAMETER Prompt
    The user's prompt or task description to evaluate.

.PARAMETER ApiKey
    Optional API key override. If omitted, invoke-typesafe.ps1 discovers credentials dynamically.

.PARAMETER Threshold
    Minimum independent Noul applicability (0.0 to 1.0). The default is calibrated
    against the synthetic routing cases recorded in the Harness improvement.

.PARAMETER MaxSkills
    Maximum automatic chain length. Defaults to 3; explicit mentions bypass it.

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
      - Confidence (float): Choice confidence, not confidence in the combined chain.
      - Probabilities (hashtable/object): Choice probability distribution across skills.
      - ApplicabilityProbabilities (hashtable): Independent Noul values by skill.
      - Fallback (bool): True if heuristic fallback was used instead of live Jev.
      - Mode (string): 'ExplicitMention', 'JevDecision', 'JevCompositeDecision', 'JevNoMatch', or 'HeuristicFallback'.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Prompt,

    [string]$ApiKey = $null,

    [ValidateRange(0.0, 1.0)]
    [double]$Threshold = 0.55,

    [ValidateRange(1, 100)]
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
        "ticket-solving",
        "sequence-execution-plan", "prompt-leverage", "onboarding", "domain-audit",
        "xia", "utilizing-tools-agy", "utilizing-tools-claude", "utilizing-tools-codex",
        "utilizing-tools-opencode", "utilizing-tools-orca-ade", "init-harness-repo"
    )

    # Only an explicit "$skill-name" mention bypasses routing; a bare word does not.
    $matchedSkills = [System.Collections.Generic.List[string]]::new()
    foreach ($skillName in $explicitSkills) {
        if ($promptLower -match "\`$$([regex]::Escape($skillName))(?![a-z0-9_-])") {
            if (-not $matchedSkills.Contains($skillName)) {
                $matchedSkills.Add($skillName)
            }
        }
    }

    if ($matchedSkills.Count -gt 0) {
        $primary = $matchedSkills[0]
        $supporting = @(if ($matchedSkills.Count -gt 1) { $matchedSkills.GetRange(1, $matchedSkills.Count - 1).ToArray() })
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
            ApplicabilityProbabilities = $null
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
    "writing-for-agents"         = "Creating or editing persistent agent skills, agent-facing instructions, AGENTS.md, or CLAUDE.md; not ordinary user-facing prose"
    "goal-griller"               = "Shaping a verifiable autonomous goal, goal mode, or an interview before goal creation; not every task that has an objective"
    "improve-harness"            = "Applying scoped improvements to harness repo guidance, routing, skills, tools, or validation"
    "sequence-execution-plan"    = "Building dependency-aware execution plans, sequencing backlogs or prerequisites"
    "prompt-leverage"            = "Improving a raw prompt, adding instructions or verification, extracting a prompt template, or designing a prompt enhancement hook; not ordinary goal shaping"
    "onboarding"                 = "Mapping a named brownfield business or data flow into an evidence-backed workspace; not general onboarding"
    "xia"                        = "Researching unfamiliar or risky implementation, local reuse, or current APIs before coding; not a general explanation"
    "utilizing-tools-agy"        = "User asks to select or leverage Antigravity tools, plugins, skills, or subagents effectively; routine tool use alone does not qualify"
    "utilizing-tools-claude"     = "User asks to select or leverage Claude Code tools, connectors, skills, or subagents effectively; routine tool use alone does not qualify"
    "utilizing-tools-codex"      = "User asks to select or leverage Codex tools, apps, plugins, skills, or subagents effectively; routine tool use or mentioning Codex alone does not qualify"
    "utilizing-tools-opencode"   = "User asks to select or leverage OpenCode tools, plugins, skills, or agents effectively; routine tool use alone does not qualify"
    "utilizing-tools-orca-ade"   = "User asks to select or leverage Orca ADE CLI, browser, worktree, or terminal capabilities effectively; routine Git use alone does not qualify"
}

# 3. Heuristic fallback function (offline / no key)
function Get-HeuristicFallbackSkill([string]$text) {
    $lower = $text.ToLowerInvariant()
    if ($lower -match "enhance-jev|custom.*jev|adapt.*jev|jev-ai|manifest") { return "enhance-jev" }
    if ($lower -match "goal|grill|objective|spec") { return "goal-griller" }
    if ($lower -match "write|writing|doc|guideline|agents\.md|claude\.md|instruction") { return "writing-for-agents" }
    if ($lower -match "improve|harness|refactor|benchmark") { return "improve-harness" }
    if ($lower -match "jev|typesafe|semantic|judgment|classify|eval") { return "typesafe-ai" }
    if ($lower -match "orca|worktree|multiplex") { return "utilizing-tools-orca-ade" }
    if ($lower -match "plan|sequence|dependency|prerequisite|backlog") { return "sequence-execution-plan" }
    if ($lower -match "research|investigate|explore|xia") { return "xia" }
    if ($lower -match "onboard|brownfield|data-flow") { return "onboarding" }
    if ($lower -match "prompt|template|leverage") { return "prompt-leverage" }
    return $null
}

# 4. Call Jev via invoke-typesafe.ps1
$stateObj = @{
    user_prompt = $Prompt
}

$choiceCriteria = @{}
foreach ($skillName in $skillsCriteria.Keys) { $choiceCriteria[$skillName] = $skillsCriteria[$skillName] }
$choiceCriteria['no_matching_skill'] = "No available skill is needed for the user's request."
$questionsObj = @{
    suggested_skill = @{
        type         = "choice"
        instructions = "Select the single best available skill for the user's request, or no_matching_skill if none is needed."
        criteria     = $choiceCriteria
    }
}
$questionNames = @{}
foreach ($skillName in $skillsCriteria.Keys) {
    $questionName = 'applicability_' + ($skillName -replace '-', '_')
    $questionNames[$skillName] = $questionName
    $questionsObj[$questionName] = @{
        type = 'noul'
        instructions = ('Does the user_prompt meet the conditions for using the {0} skill? Conditions: {1}. Judge this skill independently; several skills may apply. Only answer yes when its specific trigger is present.' -f $skillName, $skillsCriteria[$skillName])
    }
}

$eval = & $invokeScript -State $stateObj -Questions $questionsObj -ApiKey $ApiKey -Quiet:$Quiet

# 5. Handle Fallback
$choiceAnswer = if ($null -ne $eval -and $null -ne $eval.Answers) { $eval.Answers.suggested_skill } else { $null }
$probObj = if ($null -ne $choiceAnswer) { $choiceAnswer.probabilities } else { $null }
$invalidRanking = ($null -eq $probObj)
if (-not $invalidRanking) {
    $probabilitySum = 0.0
    foreach ($name in $choiceCriteria.Keys) {
        $probability = if ($probObj -is [System.Collections.IDictionary]) { $probObj[$name] } else {
            $property = $probObj.PSObject.Properties[$name]
            if ($null -ne $property) { $property.Value } else { $null }
        }
        if ($null -eq $probability -or $probability -isnot [ValueType] -or $probability -is [bool]) { $invalidRanking = $true; break }
        try { $number = [double]$probability } catch { $invalidRanking = $true; break }
        if ([double]::IsNaN($number) -or [double]::IsInfinity($number) -or $number -lt 0 -or $number -gt 1) { $invalidRanking = $true; break }
        $probabilitySum += $number
    }
    # Allow modest rounding in the returned distribution.
    if ([math]::Abs($probabilitySum - 1.0) -gt 0.05) { $invalidRanking = $true }
}
if ($null -eq $eval -or $eval.Fallback -or (-not $eval.Success) -or $invalidRanking) {
    $fallbackSkill = Get-HeuristicFallbackSkill -text $Prompt
    $fallbackChain = @(if ($null -ne $fallbackSkill) { $fallbackSkill })
    if (-not $Quiet) {
        Write-Host "[SmartRouter] Fallback suggestion: $fallbackSkill (Mode: HeuristicFallback)`n" -ForegroundColor Yellow
    }
    return [PSCustomObject]@{
        Skill            = $fallbackSkill
        PrimarySkill     = $fallbackSkill
        SupportingSkills = @()
        SkillChain       = $fallbackChain
        IsComposite      = $false
        Confidence       = $null
        Probabilities    = $null
        ApplicabilityProbabilities = $null
        Fallback         = $true
        Mode             = "HeuristicFallback"
        Warning          = if ($invalidRanking -and $null -ne $eval -and $eval.Success) { "Invalid Choice probability distribution." } elseif ($null -ne $eval) { $eval.Warning } else { "Jev result unavailable." }
    }
}

# 6. Compose independent applicability judgments with primary ranking.
$applicability = @{}
$rankedList = @()
foreach ($skillName in $skillsCriteria.Keys) {
    $questionName = $questionNames[$skillName]
    $noul = [double]$eval.Answers.$questionName.noul
    $choiceProbability = if ($probObj -is [System.Collections.IDictionary]) { [double]$probObj[$skillName] } else { [double]$probObj.PSObject.Properties[$skillName].Value }
    $applicability[$skillName] = $noul
    $rankedList += [PSCustomObject]@{ Skill = $skillName; Applicability = $noul; ChoiceProbability = $choiceProbability }
}
$rankedList = @($rankedList | Sort-Object -Property @{Expression='Applicability';Descending=$true}, @{Expression='ChoiceProbability';Descending=$true})
$platformPatterns = @{
    'utilizing-tools-agy' = '(?i)\b(?:antigravity|agy)\b'
    'utilizing-tools-claude' = '(?i)\bclaude\b'
    'utilizing-tools-codex' = '(?i)\bcodex\b'
    'utilizing-tools-opencode' = '(?i)\bopen[\s-]?code\b'
    'utilizing-tools-orca-ade' = '(?i)\borca\b'
}
$namedPlatforms = @($platformPatterns.Keys | Where-Object { $Prompt -match $platformPatterns[$_] })
$eligible = @($rankedList | Where-Object {
    $_.Applicability -ge $Threshold -and
    ($namedPlatforms.Count -eq 0 -or -not $platformPatterns.ContainsKey($_.Skill) -or $namedPlatforms -contains $_.Skill)
})
$primarySkill = $null
if ($eligible.Count -gt 0) {
    $selected = @($eligible | Where-Object { $_.Skill -eq $choiceAnswer.choice })
    $primarySkill = if ($selected.Count -gt 0) { $selected[0].Skill } else { $eligible[0].Skill }
}
$supportingSkills = @(
    $eligible | Where-Object { $_.Skill -ne $primarySkill } |
    Select-Object -First ($MaxSkills - 1) | ForEach-Object { $_.Skill }
)
$skillChain = @(if ($null -ne $primarySkill) { $primarySkill; $supportingSkills })
$isComposite = ($supportingSkills.Count -gt 0)

if (-not $Quiet) {
    Write-Host "`n[SmartRouter] Choice ranking and independent applicability:" -ForegroundColor Cyan
    foreach ($row in @($rankedList | Sort-Object -Property ChoiceProbability -Descending)) {
        Write-Host ("  {0}: Choice={1:P1}; Noul={2:P1}" -f $row.Skill, $row.ChoiceProbability, $row.Applicability)
    }
    Write-Host ("[SmartRouter] Selected: {0}" -f $(if ($skillChain.Count -gt 0) { $skillChain -join ' -> ' } else { '(no matching skill)' })) -ForegroundColor Magenta
}

return [PSCustomObject]@{
    Skill            = $primarySkill
    PrimarySkill     = $primarySkill
    SupportingSkills = $supportingSkills
    SkillChain       = $skillChain
    IsComposite      = $isComposite
    Confidence       = $choiceAnswer.confidence
    Probabilities    = $probObj
    ApplicabilityProbabilities = $applicability
    Model            = $eval.Model
    Fallback         = $false
    Mode             = if ($isComposite) { "JevCompositeDecision" } elseif ($null -eq $primarySkill) { "JevNoMatch" } else { "JevDecision" }
    Warning          = $null
}
