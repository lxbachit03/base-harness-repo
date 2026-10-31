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
    return $global:HarnessJevMockResponse
}

$scriptRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts'
$invoke = Join-Path $scriptRoot 'invoke-typesafe.ps1'

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

    Write-Host ("Offline checks: {0}; passed: {1}; failed: {2}" -f $script:Checks, ($script:Checks - $script:Failures.Count), $script:Failures.Count)
    if ($script:Failures.Count -gt 0) { throw ("Failed checks: " + ($script:Failures -join ', ')) }
} finally {
    $env:TYPESAFE_API_KEY = $originalKey
}
