param(
    [Parameter(Mandatory)][string]$Q,
    [string]$Effort = 'high',
    # Both modes: -Resume <session id> continues that worker for a follow-up question.
    [string]$Resume = '',
    # TUI mode: an interactive claude the User watches; a new worker takes a fresh
    # -SessionId; the answer ends with DONE-<N> and is read from the transcript.
    [switch]$Tui,
    [string]$SessionId = '',
    [int]$N = 0,
    # -p mode: progress lines in the tab, stream-json log in -Out, ends with WORKER-DONE.
    [string]$Out = ''
)
# Read-only Code Mode search worker for research-subagents.md (Terminal panel host).

# Inherited CLAUDE* variables make claude a child session: no Code Mode, no transcript.
Get-ChildItem Env: | Where-Object Name -like '*CLAUDE*' | ForEach-Object { Remove-Item ('Env:' + $_.Name) }
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$brief = 'You are a read-only search worker for a coordinator. Start no agent and write ' +
    'nothing. The User overrides the INDEX-first rule for this search. Return findings ' +
    'as path:line with a short phrase.'
$deny = @('--disallowedTools', 'Edit', 'Write', 'NotebookEdit', 'Agent')

if ($Tui) {
    if ((-not $SessionId -and -not $Resume) -or $N -le 0) {
        throw 'TUI mode needs -N and either -SessionId (new worker) or -Resume.'
    }
    # Interactive claude reads Code Mode from the shell environment.
    $env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = '1'
    $prompt = $brief + ' Finish with the word DONE, a dash and the number ' + $N +
        ', joined with no spaces. Question: ' + $Q
    # The prompt goes first: --disallowedTools takes every word after it.
    $a = @($prompt)
    if ($Resume) { $a += @('--resume', $Resume) } else { $a += @('--session-id', $SessionId) }
    $a += @('--model', 'haiku', '--effort', $Effort, '--permission-mode', 'default') + $deny
    & claude @a
    return
}

if (-not $Out) { throw '-p mode needs -Out.' }
# claude -p turns Code Mode on only from the env block of --settings.
$settings = Join-Path $env:TEMP 'code-search-worker-settings.json'
Set-Content -Path $settings -Value '{"env":{"CLAUDE_CODE_EXPERIMENTAL_CODE_MODE":"1"}}' -Encoding ASCII
$a = @('-p', ($brief + ' Question: ' + $Q), '--model', 'haiku', '--effort', $Effort,
       '--settings', $settings) + $deny + @('--output-format', 'stream-json', '--verbose')
if ($Resume) { $a += @('--resume', $Resume) }

function Format-Short([string]$s) {
    $s = $s.Trim() -replace '\s+', ' '
    if ($s.Length -gt 110) { $s = $s.Substring(0, 110) + '...' }
    $s
}

'QUESTION: ' + $Q
if (Test-Path $Out) { Remove-Item $Out }
$script:final = $null
& claude @a | ForEach-Object {
    Add-Content -Path $Out -Value $_ -Encoding UTF8
    try { $e = $_ | ConvertFrom-Json } catch { return }
    $time = '[' + (Get-Date -Format 'HH:mm:ss') + '] '
    if ($e.type -eq 'assistant') {
        foreach ($c in $e.message.content) {
            if ($c.type -eq 'tool_use') {
                $s = $c.input | ConvertTo-Json -Compress -Depth 4
                try { $s = [regex]::Unescape($s) } catch {}
                $time + $c.name + ' ' + (Format-Short $s)
            } elseif ($c.type -eq 'text' -and $c.text.Trim()) {
                $time + 'says: ' + (Format-Short $c.text)
            }
        }
    } elseif ($e.type -eq 'result') { $script:final = $e }
}
$o = $script:final
'--- result ---'
if ($o) {
    'session_id: ' + $o.session_id + '  turns: ' + $o.num_turns + '  cost_usd: ' + $o.total_cost_usd
    $o.result
} else { 'No result event: see ' + $Out }
'WORKER-DONE'
