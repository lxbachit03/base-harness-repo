# Harness Improvement Resource

ID: #103_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Record how to turn on Code Mode for claude -p workers, with token measurements
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs/tools/claude/README.md
- docs-harness/HERDR-APP.md
- docs-harness/harness-improvements/1124-herdr-git-bash-and-claude-env.md

## Objective

The Claude Code catalog states how Code Mode turns on for interactive `claude` and for
`claude -p`, how to confirm it ran, and points to the measurements below.

## Purposes

- [x] Let a session that delegates work to a `claude -p` worker turn Code Mode on at
  the first try (User request, 2026-11-24).
- [x] Keep the token measurements of the "talk in Desktop, work in a Code Mode
  terminal" idea, so later decisions start from evidence (User request, 2026-11-24).

## Current State

Baseline: `main` at `01a94b4`, clean; Claude Code 2.1.331, Windows, Claude Pro. The
User proposed talking in the Desktop app while a terminal Claude with Code Mode does
the work. One fixed read-only task (count `.md` files per `docs-harness/` subfolder;
list records with `STATUS: active` outside `templates/`), Sonnet 5.5 workers, auto
mode, CLAUDE* variables cleared, one run each:

| Arm | Correct | Tool calls | Input (cache read / creation) | Output | Cost (list) | Time |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Desktop session (Opus 5.5, ~176K context) | yes, 13 | 1 Bash | context +3,318; each model call rereads ~176K | n/a | n/a | ~1 s |
| `claude -p`, Code Mode off | yes, 13 | 1 Bash | 62,253 (45,663 / 16,586) | 930 | $0.080 | 9.2 s |
| `claude -p`, Code Mode on | yes, 13 | 1 Bash (`toolu_cc_` id) | 51,810 (25,303 / 26,503) | 972 | $0.118 | 9.5 s |

Findings:

1. `claude -p` ignored `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1` from the shell and from
   `~/.claude/settings.json`. Text output printed: Code Mode "isn't available: claude
   -p and Agent SDK apps get it only when CLAUDE_CODE_EXPERIMENTAL_CODE_MODE is in the
   env block of --settings". `stream-json` output printed no warning (it runs as
   `cc_entrypoint=sdk-cli`). With `--settings '{"env":{...:"1"}}'` it ran.
2. The `init` event lists no `REPL` tool even when Code Mode runs; the signal is a
   `tool_use` id starting `toolu_cc_` (docs also name `repl_`).
3. Code Mode cut worker context by about 16% (last-call context ~26.5K against
   ~31.6K) but cost more on this cold cache (26.5K cache creation).
4. For a one-call task, delegation adds the whole worker run (~50–60K input) on top
   of the coordinator's own two calls; it can only pay off on tasks with many calls.
5. A tiny `claude -p` ("Reply OK") made 3 API requests and read ~108K input.

## Proposed Improvement

Add a short Code Mode subsection after the flag table (9.4) of
`docs/tools/claude/README.md`, which is not loaded at session start.

## Scope

Changes: that subsection, this record, the improvements README. Not changed:
`claude-instructions/` (loaded every Claude session), `HERDR-APP.md`, User settings.

## Progress

2026-11-24: measurements run; record and catalog subsection added; `harness_check.py`
run (see Validation). Replay 1 exposed two defects; the subsection was revised
(`--verbose` with `stream-json`, the Desktop-app scope sentence, a Git Bash clearing
line) and replay 2 passed (see Decision and Result).

## Validation

Native: `harness_check.py` and a diff review. Behavior: the documented `--settings`
command ran live and produced `toolu_cc_` ids. Two fresh agent replays ran (see
Decision and Result).

## Risks

- One run per arm on a one-call task; warm-cache cost and many-call tasks are not
  measured. Proposal: rerun the Code Mode arm within the hour, and add a task that
  needs several dependent calls.
- Code Mode is experimental and may change. Proposal: the subsection names the
  version it was checked on.

## Decision and Result

Keep. Case (User go-ahead, 2026-11-24): a fresh Haiku 5.5 Explore subagent, effort
high, reads only the catalog subsection and writes the Git Bash commands for a
`claude -p` Sonnet worker with Code Mode and JSON events, from a Claude Desktop shell.
Pass: it uses `--settings` with the env block, clears `CLAUDE*` first, checks for
`toolu_cc_`, and the command would run.

- Replay 1 (45.1K subagent tokens): the three checks passed, but the command lacked
  `--verbose`, which `-p` needs with `stream-json`, and the agent read "Không chạy
  trong app Desktop" as possibly covering a worker started from a Desktop shell.
  Revised as listed under Progress.
- Replay 2 (45.2K subagent tokens), same case on the revised text: all checks passed, with the subshell
  clearing line, `--settings`, `--verbose` and a `toolu_cc_` check. It left out
  `--model sonnet`, which the 9.4 table above the subsection supplies.

Limits: planning replays, not executions; the measurements stay one run per arm on a
one-call task, with warm cache and many-call tasks unmeasured.

Follow-up A/B, 2026-11-24 (User request: should code research in
`claude-instructions/research-subagents.md` move to a Code Mode worker?). Question:
every `HARNESS_ROLE` mention with path, line and meaning; grep truth 13 mentions in 7
files. Same brief, one run each:

| Arm | Correct | Calls | Tokens | Time |
| :--- | :--- | :--- | :--- | :--- |
| A: Explore subagent, Haiku 5.5, effort high | yes, 13/7 | 2 tool uses | 43,859 (host `subagent_tokens`) | 14.8 s |
| B: `claude -p --model haiku --effort high`, Code Mode via `--settings`, `--disallowedTools Edit Write NotebookEdit Agent Task` | yes, 13/7 | 4 `toolu_cc_` calls, 6 turns | 108,326 input (77,898 read / 30,420 creation) + 3,591 output; $0.0087 list | 20.7 s |

Result: no clear win for B; keep the Explore rule unchanged. B was slower, needs
more setup (clearing `CLAUDE*`, `--settings`, tool deny list) and lacks the host's
read-only guarantee for Explore. The token columns are not the same unit:
`subagent_tokens` is the host's figure and its definition (final context or
cumulative input) is unverified, so the cost comparison stays open. Not tested: a
larger multi-file trace, warm cache, repeated runs.
