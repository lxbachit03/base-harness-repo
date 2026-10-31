<#
.SYNOPSIS
    Invokes the TypeSafe (Jev) System One evaluation API with zero external dependencies.

.DESCRIPTION
    Provides a resilient PowerShell helper to send semantic state and typed questions
    (Choice, Score, Noul) to the TypeSafe System One API (jev-latest).
    Implements dynamic credential discovery (Environment & Windows User/Machine Registry)
    and graceful fallback for offline/unauthenticated execution environments.

.PARAMETER State
    The content or context to evaluate (string or structured hashtable/PSCustomObject).

.PARAMETER Questions
    Hashtable defining the questions and criteria (Choice, Score, Noul).

.PARAMETER Model
    The TypeSafe model ID to evaluate with. Defaults to 'jev-latest'.

.PARAMETER ApiKey
    Optional explicit API key override. If omitted, checks $env:TYPESAFE_API_KEY,
    then Windows User Registry, then Machine Registry.

.PARAMETER TimeoutSec
    HTTP request timeout in seconds. Defaults to 15.

.PARAMETER Strict
    When present, throws terminating errors instead of returning graceful fallback objects.

.OUTPUTS
    [PSCustomObject] containing:
      - Success (bool): True if API responded successfully.
      - Fallback (bool): True if fallback was triggered due to missing key or network error.
      - Model (string): The model used or requested.
      - Answers (PSCustomObject): Evaluated answers if successful.
      - Usage (PSCustomObject): Token usage statistics if successful.
      - Error (string): Error code/type if failed.
      - Warning (string): Descriptive warning message for logging.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [object]$State,

    [Parameter(Mandatory = $true)]
    [hashtable]$Questions,

    [string]$Model = "jev-latest",

    [string]$ApiKey = $null,

    [int]$TimeoutSec = 15,

    [switch]$Strict,

    [switch]$Quiet
)

function Get-FieldValue([object]$Value, [string]$Name) {
    if ($null -eq $Value) { return $null }
    if ($Value -is [System.Collections.IDictionary]) {
        if ($Value.Contains($Name)) { return $Value[$Name] }
        return $null
    }
    $property = $Value.PSObject.Properties[$Name]
    if ($null -ne $property) { return $property.Value }
    return $null
}

function Assert-JsonDepth([object]$Value, [int]$Depth = 0) {
    if ($null -eq $Value -or $Value -is [string] -or $Value -is [ValueType]) { return }
    if ($Depth -ge 64) {
        throw "JSON state, instructions, or criteria exceed the API's 64-level nesting limit."
    }
    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($child in $Value.Values) { Assert-JsonDepth -Value $child -Depth ($Depth + 1) }
    } elseif ($Value -is [System.Collections.IEnumerable]) {
        foreach ($child in $Value) { Assert-JsonDepth -Value $child -Depth ($Depth + 1) }
    } else {
        foreach ($property in $Value.PSObject.Properties) {
            if ($property.IsGettable) {
                Assert-JsonDepth -Value $property.Value -Depth ($Depth + 1)
            }
        }
    }
}

function Test-FiniteNumber([object]$Value, [double]$Minimum, [double]$Maximum) {
    if ($null -eq $Value -or $Value -is [bool] -or $Value -is [string]) { return $false }
    try { $number = [double]$Value } catch { return $false }
    return (-not [double]::IsNaN($number) -and -not [double]::IsInfinity($number) -and
        $number -ge $Minimum -and $number -le $Maximum)
}

function Get-ResponseValidationError([object]$Response, [hashtable]$RequestedQuestions) {
    $modelId = Get-FieldValue -Value $Response -Name 'model'
    $answerSet = Get-FieldValue -Value $Response -Name 'answers'
    if ($modelId -isnot [string] -or [string]::IsNullOrWhiteSpace($modelId) -or $null -eq $answerSet) {
        return "Response is missing a model ID or answers."
    }
    foreach ($name in $RequestedQuestions.Keys) {
        $question = $RequestedQuestions[$name]
        $answer = Get-FieldValue -Value $answerSet -Name $name
        if ($null -eq $answer) { return "Response is missing answer '$name'." }
        $expectedType = Get-FieldValue -Value $question -Name 'type'
        if ($expectedType -notin @('choice', 'score', 'noul')) { continue }
        $actualType = Get-FieldValue -Value $answer -Name 'type'
        if ($actualType -ne $expectedType) { return "Answer '$name' has an unexpected type." }
        switch ($expectedType) {
            'choice' {
                $choice = Get-FieldValue -Value $answer -Name 'choice'
                $criteria = Get-FieldValue -Value $question -Name 'criteria'
                if ($choice -isnot [string] -or [string]::IsNullOrWhiteSpace($choice)) {
                    return "Answer '$name' has no valid choice."
                }
                if ($criteria -is [System.Collections.IDictionary] -and -not $criteria.Contains($choice)) {
                    return "Answer '$name' contains a choice outside the supplied criteria."
                }
            }
            'noul' {
                if (-not (Test-FiniteNumber -Value (Get-FieldValue -Value $answer -Name 'noul') -Minimum 0 -Maximum 1)) {
                    return "Answer '$name' has an invalid Noul probability."
                }
            }
            'score' {
                $criteria = Get-FieldValue -Value $question -Name 'criteria'
                $maximum = if ($criteria -is [array] -and $criteria.Count -gt 0) { $criteria.Count - 1 } else { [double]::MaxValue }
                if (-not (Test-FiniteNumber -Value (Get-FieldValue -Value $answer -Name 'score') -Minimum 0 -Maximum $maximum)) {
                    return "Answer '$name' has an invalid score."
                }
            }
        }
    }
    return $null
}

# 1. Dynamic Credential Discovery
$resolvedKey = $ApiKey
if ([string]::IsNullOrWhiteSpace($resolvedKey)) {
    $resolvedKey = $env:TYPESAFE_API_KEY
}
if ([string]::IsNullOrWhiteSpace($resolvedKey)) {
    $resolvedKey = [System.Environment]::GetEnvironmentVariable('TYPESAFE_API_KEY', 'User')
}
if ([string]::IsNullOrWhiteSpace($resolvedKey)) {
    $resolvedKey = [System.Environment]::GetEnvironmentVariable('TYPESAFE_API_KEY', 'Machine')
}

# 2. Check for missing credentials (Graceful Fallback)
if ([string]::IsNullOrWhiteSpace($resolvedKey)) {
    $warnMsg = "TYPESAFE_API_KEY is not configured in process environment or Windows registry. Graceful fallback active."
    if ($Strict) {
        throw $warnMsg
    }
    Write-Warning $warnMsg
    return [PSCustomObject]@{
        Success  = $false
        Fallback = $true
        Model    = $Model
        Answers  = $null
        Usage    = $null
        Error    = "MissingApiKey"
        Warning  = $warnMsg
    }
}

# 3. Payload Construction & UTF-8 Byte Encoding
try {
    Assert-JsonDepth -Value $State
    foreach ($question in $Questions.Values) {
        Assert-JsonDepth -Value (Get-FieldValue -Value $question -Name 'instructions')
        Assert-JsonDepth -Value (Get-FieldValue -Value $question -Name 'criteria')
    }
    $payloadObj = @{
        state     = $State
        model     = $Model
        questions = $Questions
    }
    $jsonString = $payloadObj | ConvertTo-Json -Depth 100 -WarningAction Stop -ErrorAction Stop
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonString)
} catch {
    $errMsg = "Failed to serialize payload to JSON: $($_.Exception.Message)"
    if ($Strict) {
        throw $errMsg
    }
    Write-Warning $errMsg
    return [PSCustomObject]@{
        Success  = $false
        Fallback = $true
        Model    = $Model
        Answers  = $null
        Usage    = $null
        Error    = "SerializationError"
        Warning  = $errMsg
    }
}

# 4. Invoke API with Network Error Handling and Real-time Observability
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
if (-not $Quiet) {
    Write-Host "`n[TypeSafe] --------------------------------------------------" -ForegroundColor Cyan
    Write-Host "[TypeSafe] --> Calling Jev API: https://api.typesafe.ai/v1/systemone" -ForegroundColor Cyan
    Write-Host "[TypeSafe] Model: $Model | Timeout: ${TimeoutSec}s" -ForegroundColor Cyan
    Write-Host "[TypeSafe] Request Payload:" -ForegroundColor Yellow
    Write-Host $jsonString -ForegroundColor Gray
    Write-Host "[TypeSafe] --------------------------------------------------" -ForegroundColor Cyan
}

try {
    $response = Invoke-RestMethod -Uri "https://api.typesafe.ai/v1/systemone" `
        -Method Post `
        -Headers @{ "Authorization" = "Bearer $resolvedKey" } `
        -ContentType "application/json; charset=utf-8" `
        -Body $bodyBytes `
        -TimeoutSec $TimeoutSec

    $stopwatch.Stop()
    $elapsedMs = $stopwatch.ElapsedMilliseconds

    if (-not $Quiet) {
        Write-Host "`n[TypeSafe] <-- Response received in ${elapsedMs} ms ($([math]::Round($elapsedMs / 1000, 2))s):" -ForegroundColor Green
        Write-Host ($response | ConvertTo-Json -Depth 100 -WarningAction Stop -ErrorAction Stop) -ForegroundColor Gray
        Write-Host "[TypeSafe] --------------------------------------------------`n" -ForegroundColor Green
    }

} catch {
    $stopwatch.Stop()
    $elapsedMs = $stopwatch.ElapsedMilliseconds
    $httpStatus = $null
    if ($null -ne $_.Exception.Response -and $null -ne $_.Exception.Response.StatusCode) {
        try { $httpStatus = [int]$_.Exception.Response.StatusCode } catch { $httpStatus = $null }
    }
    $apiErrorMsg = "TypeSafe API request failed after ${elapsedMs} ms: $($_.Exception.Message)"

    if (-not $Quiet) {
        Write-Host "`n[TypeSafe] [!] API Call Failed after ${elapsedMs} ms: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "[TypeSafe] --------------------------------------------------`n" -ForegroundColor Red
    }

    if ($Strict) {
        throw $apiErrorMsg
    }
    Write-Warning $apiErrorMsg
    return [PSCustomObject]@{
        Success   = $false
        Fallback  = $true
        Model     = $Model
        Answers   = $null
        Usage     = $null
        ElapsedMs = $elapsedMs
        Error     = if ($null -ne $httpStatus) { "Http$httpStatus" } else { "NetworkOrApiError" }
        HttpStatus = $httpStatus
        Warning   = $apiErrorMsg
    }
}

$validationError = Get-ResponseValidationError -Response $response -RequestedQuestions $Questions
if ($null -ne $validationError) {
    if ($Strict) { throw $validationError }
    Write-Warning $validationError
    return [PSCustomObject]@{
        Success   = $false
        Fallback  = $true
        Model     = Get-FieldValue -Value $response -Name 'model'
        Answers   = $null
        Usage     = Get-FieldValue -Value $response -Name 'usage'
        ElapsedMs = $elapsedMs
        Error     = "InvalidResponse"
        Warning   = $validationError
    }
}

return [PSCustomObject]@{
    Success   = $true
    Fallback  = $false
    Model     = Get-FieldValue -Value $response -Name 'model'
    Answers   = Get-FieldValue -Value $response -Name 'answers'
    Usage     = Get-FieldValue -Value $response -Name 'usage'
    ElapsedMs = $elapsedMs
    Error     = $null
    Warning   = $null
}
