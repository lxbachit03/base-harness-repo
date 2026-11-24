# Searching through a Code Mode worker

Applies to every search of code or file content in the main session: finding files,
grep, tracing a flow, finding callers, or reading part of a file to find something
(small searches included while the worker is on). Reading a file in order to edit it,
session-start retrieval and the harness check stay in the session. A delegated worker
searches with its own tools and starts no worker.

## Search mode (User switch)

- [x] Code Mode worker on

Marked: follow the steps below. Unmarked: research code in Haiku Explore subagents. Ask
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

The search worker is one `claude --model haiku` with Code Mode in a Herdr app space,
kept for the whole session ([HERDR-APP.md](../HERDR-APP.md) sections 2 and 5). User
decisions, 2026-11-24: Haiku 5.5, every search, and on failure ask the User.

## Steps (Code Mode worker on)

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

Leave the space running at the end of the session; the User closes it.
