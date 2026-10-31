[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'
$script:Failures = [System.Collections.Generic.List[string]]::new()
$script:Checks = 0
$global:HarnessJevMockResponse = $null
$global:HarnessJevMockError = $false
$global:HarnessJevMockStatus = $null
$global:HarnessJevMockCalls = 0
$global:HarnessJevLastRequest = $null
$global:HarnessJevRouterScores = $null
$global:HarnessJevRouterChoice = $null
$global:HarnessJevRouterBadDistribution = $false
$originalKey = $env:TYPESAFE_API_KEY

function Assert-Check([string]$Name, [bool]$Condition) {
    $script:Checks++
    if (-not $Condition) {
        $script:Failures.Add($Name)
        Write-Host "FAIL: $Name"
    }
}

# This function shadows the HTTP cmdlet only inside this test process.
function Invoke-RestMethod {
    [CmdletBinding()]
    param($Uri, $Method, $Headers, $ContentType, [byte[]]$Body, $TimeoutSec)
    $global:HarnessJevMockCalls++
    $global:HarnessJevLastRequest = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
    if ($global:HarnessJevMockError) {
        $exception = [System.Exception]::new('Synthetic HTTP failure')
        if ($null -ne $global:HarnessJevMockStatus) {
            $exception | Add-Member -NotePropertyName Response -NotePropertyValue ([PSCustomObject]@{ StatusCode = $global:HarnessJevMockStatus })
        }
        throw $exception
    }
    if ($null -ne $global:HarnessJevRouterScores) {
        $ranking = @{}
        foreach ($property in $global:HarnessJevLastRequest.questions.suggested_skill.criteria.PSObject.Properties) {
            $ranking[$property.Name] = if ($global:HarnessJevRouterBadDistribution -or $property.Name -eq $global:HarnessJevRouterChoice) { 1.0 } else { 0.0 }
        }
        $answers = @{
            suggested_skill = @{ type = 'choice'; choice = $global:HarnessJevRouterChoice; probabilities = $ranking; confidence = 1.0 }
        }
        foreach ($property in $global:HarnessJevLastRequest.questions.PSObject.Properties) {
            if ($property.Name -like 'applicability_*') {
                $skill = $property.Name.Substring('applicability_'.Length).Replace('_', '-')
                $score = if ($global:HarnessJevRouterScores.ContainsKey($skill)) { $global:HarnessJevRouterScores[$skill] } else { 0.01 }
                $answers[$property.Name] = @{ type = 'noul'; noul = $score }
            }
        }
        return @{ model = 'mock-model'; answers = $answers }
    }
    return $global:HarnessJevMockResponse
}

$scriptRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts'
$invoke = Join-Path $scriptRoot 'invoke-typesafe.ps1'
$precheck = Join-Path $scriptRoot 'precheck-authority.ps1'
$freshness = Join-Path $scriptRoot 'check-domain-freshness.ps1'
$triage = Join-Path $scriptRoot 'triage-ticket.ps1'
$router = Join-Path $scriptRoot 'suggest-skill.ps1'

try {
    $env:TYPESAFE_API_KEY = 'synthetic-test-key'
    $simpleQuestions = @{ present = @{ type = 'noul'; instructions = 'Is the item present?' } }
    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{ present = @{ type = 'noul'; noul = 0.8 } } }

    $deepState = @{ leaf = 'intact' }
    for ($i = 0; $i -lt 13; $i++) { $deepState = @{ child = $deepState } }
    $result = & $invoke -State $deepState -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    $node = $global:HarnessJevLastRequest.state
    for ($i = 0; $i -lt 13; $i++) { $node = $node.child }
    Assert-Check 'nested state preserved' ($result.Success -and $node.leaf -eq 'intact')

    $deepResponse = @{ leaf = 'observable' }
    for ($i = 0; $i -lt 13; $i++) { $deepResponse = @{ child = $deepResponse } }
    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{ present = @{ type = 'noul'; noul = 0.8 } }; extension = $deepResponse }
    $logged = & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' 6>&1 | Out-String
    Assert-Check 'nested response remains observable' ($logged -match '"leaf"\s*:\s*"observable"')

    $callsBefore = $global:HarnessJevMockCalls
    $tooDeep = @{ leaf = 'intact' }
    for ($i = 0; $i -lt 65; $i++) { $tooDeep = @{ child = $tooDeep } }
    $result = & $invoke -State $tooDeep -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    Assert-Check 'excess nesting rejected before HTTP' ($result.Fallback -and $result.Error -eq 'SerializationError' -and $global:HarnessJevMockCalls -eq $callsBefore)

    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{} }
    $result = & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    Assert-Check 'missing answer is invalid response' ($result.Fallback -and $result.Error -eq 'InvalidResponse')

    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{ present = @{ type = 'noul'; noul = 1.2 } } }
    $result = & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    Assert-Check 'out-of-range Noul rejected' ($result.Fallback -and $result.Error -eq 'InvalidResponse')

    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{ present = @{ type = 'choice'; choice = 'yes' } } }
    $result = & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    Assert-Check 'wrong answer type rejected' ($result.Fallback -and $result.Error -eq 'InvalidResponse')

    $strictThrew = $false
    try { & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet -Strict | Out-Null } catch { $strictThrew = $true }
    Assert-Check 'strict invalid response throws' $strictThrew

    $global:HarnessJevMockError = $true
    $global:HarnessJevMockStatus = 429
    $result = & $invoke -State 'test' -Questions $simpleQuestions -ApiKey 'synthetic-test-key' -Quiet
    Assert-Check 'HTTP status exposed on fallback' ($result.Fallback -and $result.Error -eq 'Http429' -and $result.HttpStatus -eq 429)
    $global:HarnessJevMockError = $false
    $global:HarnessJevMockStatus = $null

    $global:HarnessJevMockResponse = @{
        model = 'mock-model'
        answers = @{
            authority_classification = @{ type = 'choice'; choice = 'read_only_routine' }
            risk_score = @{ type = 'score'; score = 0 }
        }
    }
    $boundaryCases = @(
        @{ Command = 'git status'; Allowed = $true },
        @{ Command = 'git -C . status'; Allowed = $true },
        @{ Command = "Write-Output 'git add example.txt'"; Allowed = $true },
        @{ Command = 'git status; git log -1'; Allowed = $true },
        @{ Command = 'git status && git log -1'; Allowed = $true },
        @{ Command = 'git add example.txt'; Allowed = $false },
        @{ Command = 'git commit -m example'; Allowed = $false },
        @{ Command = 'git push origin main'; Allowed = $false },
        @{ Command = 'git rebase main'; Allowed = $false },
        @{ Command = 'git reset --hard HEAD'; Allowed = $false },
        @{ Command = 'git clean -fd'; Allowed = $false },
        @{ Command = 'rm -rf example'; Allowed = $false },
        @{ Command = 'Remove-Item -LiteralPath example -Recurse'; Allowed = $false },
        @{ Command = 'git status; git push origin main'; Allowed = $false },
        @{ Command = 'git -C . add example.txt'; Allowed = $false },
        @{ Command = 'git -c core.filemode=false commit -m example'; Allowed = $false },
        @{ Command = 'git --git-dir .git push origin main'; Allowed = $false },
        @{ Command = '& git add example.txt'; Allowed = $false },
        @{ Command = 'cmd /c git add example.txt'; Allowed = $false }
    )
    foreach ($case in $boundaryCases) {
        $result = & $precheck -Command $case.Command -Quiet
        Assert-Check ("boundary: " + $case.Command) ($result.Permitted -eq $case.Allowed -and -not $result.Fallback)
    }

    $global:HarnessJevMockResponse = @{ model = 'mock-model'; answers = @{ authority_classification = @{ type = 'choice'; choice = 'read_only_routine' } } }
    $result = & $precheck -Command 'Get-Content README.md' -Quiet
    Assert-Check 'missing authority answer uses fallback' ($result.Fallback -and $result.Mode -eq 'GracefulFallback')
    $result = & $precheck -Command 'git -C . add example.txt' -Quiet
    Assert-Check 'hard boundary remains restricted during fallback' ($result.Fallback -and $result.RequiresUserPermission)

    $global:HarnessJevMockResponse = @{
        model = 'mock-model'
        answers = @{
            is_domain_stale = @{ type = 'noul'; noul = 0.45 }
            staleness_severity = @{ type = 'score'; score = 0.2; legend = @{ '0' = 'No impact'; '1' = 'Minor'; '2' = 'Breaking' } }
        }
    }
    $result = & $freshness -DomainText 'Synthetic domain statement.' -CodeDiffOrSummary 'Synthetic change.' -Quiet
    Assert-Check 'freshness review band preserved' (-not $result.IsStale -and $result.Recommendation -eq 'MarkStaleAndScheduleReview' -and -not $result.Fallback)

    $global:HarnessJevMockError = $true
    $result = & $freshness -DomainText 'Synthetic domain statement.' -CodeDiffOrSummary 'Synthetic change.' -Quiet
    Assert-Check 'freshness fallback is unknown' ($result.Fallback -and $null -eq $result.IsStale -and $null -eq $result.StalenessProbability -and $result.Recommendation -eq 'MarkStaleAndScheduleReview')
    $result = & $triage -Content 'Synthetic ticket.' -Quiet
    Assert-Check 'triage fallback is unknown' ($result.Fallback -and $result.RequiresReview -and $null -eq $result.Category -and $null -eq $result.RecommendedPriority)
    $global:HarnessJevMockError = $false

    $global:HarnessJevMockResponse = @{
        model = 'mock-model'
        answers = @{
            category = @{ type = 'choice'; choice = 'bug_defect' }
            severity = @{ type = 'score'; score = 1.8; legend = @{ '0' = 'Low'; '1' = 'Medium'; '2' = 'High' } }
            complexity = @{ type = 'score'; score = 1.7; legend = @{ '0' = 'Trivial'; '1' = 'Moderate'; '2' = 'Complex' } }
            reproducibility = @{ type = 'noul'; noul = 0.98 }
        }
    }
    $result = & $triage -Content 'Synthetic ticket.' -Quiet
    Assert-Check 'valid triage thresholds preserved' (-not $result.Fallback -and $result.Category -eq 'bug_defect' -and $result.RecommendedPriority -eq '[CRITIAL]' -and $result.HasReproductionSteps)

    $callsBefore = $global:HarnessJevMockCalls
    $result = & $router -Prompt 'Use $goal-griller to shape a goal.' -Quiet
    Assert-Check 'explicit skill bypasses Jev' ($result.Mode -eq 'ExplicitMention' -and $result.PrimarySkill -eq 'goal-griller' -and $global:HarnessJevMockCalls -eq $callsBefore)
    Assert-Check 'explicit support list remains an array' ($result.SupportingSkills -is [array] -and $result.SupportingSkills.Count -eq 0)

    $global:HarnessJevRouterScores = @{}
    $global:HarnessJevRouterChoice = 'no_matching_skill'
    $result = & $router -Prompt 'Use $goal-griller-extra for this.' -Quiet
    Assert-Check 'skill name prefix is not an explicit mention' ($result.Mode -ne 'ExplicitMention' -and $global:HarnessJevMockCalls -gt $callsBefore)

    $global:HarnessJevRouterScores = @{ 'goal-griller' = 0.91; 'typesafe-ai' = 0.87 }
    $global:HarnessJevRouterChoice = 'goal-griller'
    $result = & $router -Prompt 'Synthetic composite request.' -Threshold 0.5 -Quiet
    Assert-Check 'independent Noul judgments select multiple skills' ($result.IsComposite -and @($result.SkillChain).Count -eq 2 -and $result.SkillChain -contains 'goal-griller' -and $result.SkillChain -contains 'typesafe-ai')
    $criteriaNames = @($global:HarnessJevLastRequest.questions.suggested_skill.criteria.PSObject.Properties.Name)
    Assert-Check 'user-only skills excluded from automatic selection' (-not ($criteriaNames -contains 'domain-audit') -and -not ($criteriaNames -contains 'ticket-solving'))

    $global:HarnessJevRouterScores = @{ 'goal-griller' = 0.54; 'typesafe-ai' = 0.56 }
    $global:HarnessJevRouterChoice = 'typesafe-ai'
    $result = & $router -Prompt 'Synthetic threshold check.' -Quiet
    Assert-Check 'default Noul threshold is 0.55' ($result.SkillChain.Count -eq 1 -and $result.PrimarySkill -eq 'typesafe-ai')

    $global:HarnessJevRouterScores = @{ 'utilizing-tools-codex' = 0.96; 'utilizing-tools-claude' = 0.96; 'utilizing-tools-agy' = 0.71 }
    $global:HarnessJevRouterChoice = 'utilizing-tools-codex'
    $result = & $router -Prompt 'Select the Codex tools for this task.' -Quiet
    Assert-Check 'named platform excludes other platform tools' ($result.SkillChain.Count -eq 1 -and $result.PrimarySkill -eq 'utilizing-tools-codex')
    $result = & $router -Prompt 'Select the agent tools for this task.' -Quiet
    Assert-Check 'unnamed platform retains semantic suggestions' ($result.SkillChain.Count -eq 3)
    $result = & $router -Prompt 'Use $utilizing-tools-claude while working in Codex.' -Quiet
    Assert-Check 'explicit skill bypasses platform filter' ($result.Mode -eq 'ExplicitMention' -and $result.PrimarySkill -eq 'utilizing-tools-claude')
    $global:HarnessJevRouterBadDistribution = $true
    $result = & $router -Prompt 'Synthetic malformed ranking.' -Quiet
    Assert-Check 'invalid Choice distribution uses fallback' ($result.Fallback -and $result.Mode -eq 'HeuristicFallback')
    $global:HarnessJevRouterBadDistribution = $false

    $global:HarnessJevRouterScores = @{}
    $global:HarnessJevRouterChoice = 'no_matching_skill'
    $result = & $router -Prompt 'What is seven times eight?' -Threshold 0.5 -Quiet
    Assert-Check 'no matching skill is returned explicitly' ($result.Mode -eq 'JevNoMatch' -and $null -eq $result.PrimarySkill -and @($result.SkillChain).Count -eq 0)
    $global:HarnessJevRouterScores = $null
    $global:HarnessJevMockError = $true
    $result = & $router -Prompt 'What is seven times eight?' -Quiet
    Assert-Check 'offline router can return no match' ($result.Fallback -and $null -eq $result.PrimarySkill -and @($result.SkillChain).Count -eq 0)
    $global:HarnessJevMockError = $false

    $fixture = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $PSScriptRoot 'router-cases.json') | ConvertFrom-Json
    Assert-Check 'routing fixture has at least 12 distinct cases' (@($fixture.cases).Count -ge 12 -and @($fixture.cases.id | Sort-Object -Unique).Count -eq @($fixture.cases).Count)

    Write-Host ("Offline checks: {0}; passed: {1}; failed: {2}" -f $script:Checks, ($script:Checks - $script:Failures.Count), $script:Failures.Count)
    if ($script:Failures.Count -gt 0) { throw ("Failed checks: " + ($script:Failures -join ', ')) }
} finally {
    $env:TYPESAFE_API_KEY = $originalKey
}
