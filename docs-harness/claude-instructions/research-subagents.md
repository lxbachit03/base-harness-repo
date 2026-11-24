# Searching through a Code Mode worker

Applies to every search of code or file content in the main session: finding files,
grep, tracing a flow, finding callers, or reading part of a file to find something
(small searches included while the worker is on). Reading a file in order to edit it,
session-start retrieval and the harness check stay in the session. A delegated worker
searches with its own tools and starts no worker.

## Search mode (User switch)

- [x] Code Mode worker on

Marked: follow the steps of the marked worker host below. Unmarked: research code in
Haiku Explore subagents. Ask
the User once per task before the first spawn, in one question that names the model,
offers the two efforts with the marked one first, and states how many subagents; spawn
each with `subagent_type: Explore`, `model: haiku`, the chosen effort and one
self-contained question; a direct read of one or two known files stays in the session;
read the results yourself before relying on them.

## Effort (select exactly one by marking `[x]`)

If none or several are marked, use high. It applies to the worker (`--effort high`, or
`xhigh` for "extra") and to Explore subagents (`effort: high`, or `xhigh`).

- [ ] Haiku 5.5, effort: high
- [x] Haiku 5.5, effort: extra

## Worker host (select exactly one by marking `[x]`)

If none or several are marked, use the first; on a host without the Terminal panel
tools, use Herdr.

- [x] Terminal panel, TUI + `--resume`: an interactive `claude` per question, in a tab
  the User watches; a follow-up resumes the same worker
- [ ] Terminal panel, `-p` + progress lines: `claude -p` per question, the tab shows
  each worker step as a log line
- [ ] Herdr app space: one interactive `claude` kept for the session

The worker is `claude --model haiku` with Code Mode, started without Edit, Write,
NotebookEdit and Agent. User decisions: 2026-11-24, Haiku 5.5, every search, and on
failure ask the User; 2026-11-25, the Terminal panel hosts, TUI first.

## Steps (Terminal panel)

The script [code-search-worker.ps1](code-search-worker.ps1) clears the inherited
`CLAUDE*` variables, turns Code Mode on and starts the worker: with `-Tui` an
interactive `claude` in `default` permission mode; without it `claude -p`, printing each
step and ending with `WORKER-DONE`. The Terminal panel cannot type into a running
`claude`, so each question is a new run; `-Resume <session id>` carries the worker's
memory into it and writes to the same transcript. Add `-Resume` only when the question
follows up the previous answer; it may then refer to that answer ("the files you just
listed"). The question names the known paths and terms, in ASCII with no `'`, `"`, `$`
or backtick. N counts this session's searches from 1, one higher each time.

1. Tab (TUI): close the previous `code-search` tab you opened, if there is one
   (`stop_terminal_tab`, `close: true`; Ctrl-C does not end the TUI), then open a new
   one with `run_in_terminal`, title `code-search`, the repository root as `cwd`.
   Tab (`-p`): reuse the `code-search` tab when `list_terminal_tabs` marks it reusable;
   otherwise open it the same way.
2. Run with `run_in_terminal`, then at once write one chat line with the tab link,
   `[code-search worker](#terminal/<tab_id>)`, so the User can watch it live:
   - TUI, new worker: generate a UUID (`[guid]::NewGuid()` or Python `uuid4`), then
     `& '<repo>\docs-harness\claude-instructions\code-search-worker.ps1' -Tui -SessionId '<uuid>' -N <N> -Q '<question>' -Effort <high|xhigh>`;
     a follow-up replaces `-SessionId '<uuid>'` with `-Resume '<uuid>'`. Use a fresh N.
   - `-p`: `& '<same script>' -Q '<question>' -Effort <high|xhigh> -Out '<scratchpad>\search-<N>.jsonl'`,
     plus `-Resume '<session_id>'` for a follow-up.
3. Wait, polling from the shell for up to 300 seconds. TUI: done when the transcript
   `~/.claude/projects/<slug>/<uuid>.jsonl` holds `DONE-<N>` (`<slug>` is the repository
   path with `:`, `\` and `/` replaced by `-`). `-p`: done when the log holds a line with
   `"type":"result"` (`WORKER-DONE` is only the tab's last line). A permission prompt
   in the tab is the User's to answer: tell them.
4. Read, in the same shell call as `git status --short` (the worker changes nothing):
   TUI, the last assistant text in the transcript; `-p`, the `result`, `session_id`
   and `total_cost_usd` of the result line. Read cited lines yourself only as part of
   an edit that relies on them. Leave the TUI tab open for the User until the next
   search.
5. On no answer within the wait, a script error or two failed searches, ask the User
   once: retry, switch host, use a Haiku Explore subagent (marked effort), or search
   here.

## Steps (Herdr app space)

The worker is kept for the whole session in a Herdr app space
([HERDR-APP.md](../HERDR-APP.md) sections 2 and 5).

1. Find the worker: `herdr-app ls` lists a space named `code-search` and its terminal.
   If there is none, say so in one line and create it per HERDR-APP.md section 5
   (`--name code-search`, the repository folder, `--focus false`, no `--argv`). Its shell
   is PowerShell: in one `hc send`, clear the inherited `CLAUDE*` variables (section 2
   item 5), set `$env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = '1'`, and start
   `claude --model haiku --effort <marked> --disallowedTools Edit Write NotebookEdit Agent`
   with no permission flag; from Git Bash write each `$` as `\$` inside the double
   quotes. Wait with `hc wait <terminal> --output "Code Mode" --timeout 60`.
   Done when `hc read` shows "Code Mode (experimental) is on".
2. On a worker that has answered before, send `/clear` before a question that does not
   follow up the previous answer (section 2 item 4). Send the question as one line with
   `hc send`: a read-only search worker for a coordinator that starts no agent and
   writes nothing; the User overrides the
   INDEX-first rule for this search; the question with the paths and terms known; what
   to return (findings as `path:line` with a short phrase); and "Finish with the word
   DONE, a dash and the number <N>, joined with no spaces", with a fresh N.
3. Wait with `hc wait <terminal> --output DONE-<N> --timeout 300`. On a timeout, read
   30 lines and wait again. A permission dialog on its screen is the User's to answer:
   tell them.
4. Read with `hc read <terminal> --lines <n>`, the smallest window that holds the
   answer, and run `git status --short` in the same shell call: the worker changes
   nothing. Read cited lines yourself only as part of an edit that relies on them.
5. When the Herdr core does not answer, the worker shows no Code Mode banner, or a
   search fails twice, stop and ask the User once: open Herdr and retry, use a Haiku
   Explore subagent (`subagent_type: Explore`, `model: haiku`, the marked effort, one
   self-contained question), or search here.

Leave the worker's tab or space open at the end of the session; the User closes it.
