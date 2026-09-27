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
    $payloadObj = @{
        state     = $State
        model     = $Model
        questions = $Questions
    }
    $jsonString = $payloadObj | ConvertTo-Json -Depth 10
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
        Write-Host ($response | ConvertTo-Json -Depth 10) -ForegroundColor Gray
        Write-Host "[TypeSafe] --------------------------------------------------`n" -ForegroundColor Green
    }

    return [PSCustomObject]@{
        Success   = $true
        Fallback  = $false
        Model     = $response.model
        Answers   = $response.answers
        Usage     = $response.usage
        ElapsedMs = $elapsedMs
        Error     = $null
        Warning   = $null
    }
} catch {
    $stopwatch.Stop()
    $elapsedMs = $stopwatch.ElapsedMilliseconds
    $apiErrorMsg = "Failed to reach TypeSafe API after ${elapsedMs} ms: $($_.Exception.Message)"

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
        Error     = "NetworkOrApiError"
        Warning   = $apiErrorMsg
    }
}
