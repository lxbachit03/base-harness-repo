# Harness Improvement Resource

ID: #088_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Start Herdr desktop app workers with --dangerously-skip-permissions so they do not ask the User
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-APP.md
- docs-harness/harness-improvements/1121-herdr-app-visible-worker.md
- docs-harness/harness-improvements/1121-agy-tools-skill-refresh.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

When a Claude session orchestrates agents through the Herdr desktop app or `hc`, it starts
each worker (`agy` or Claude) with `--dangerously-skip-permissions`, so a worker does not
stop at a permission dialog for a command or a file read, unless the User unmarks the choice.

## Purposes

- [x] Stop workers from blocking on approval dialogs the User has to answer one by one; the
  User asked for this on 2026-11-21 after twelve parallel `agy` workers needed attention
  (one asked to run an `npx` command, earlier ones to read a file outside the workspace).
- [x] Keep the choice visible and reversible: one checkbox in `HERDR-APP.md`, like the
  file's other choices, so the User can switch it back to asking.
- [ ] Candidate, awaiting the User: the same default for the Herdr TUI way in `HERDR-TUI.md`.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `c4a2136`, 12 untracked
HTML files under `docs/tools/antigravity/` from the task board run, nothing else changed;
`harness-check` clean at 87 IDs.

Request: the User wants the flag added whenever the Herdr desktop app (HDA) orchestrates
agents so that agents in the panes do not ask the User for permission to run CLI commands.

Evidence in the file: section 3 says to add `--dangerously-skip-permissions` or `--sandbox`
"only when the User asks for that exact flag", so no start line carries it and each worker
stops at dialogs; section 4 step 4 says a `blocked` worker needs the User to answer.
`agy --help` (1.5.14) lists `--dangerously-skip-permissions` ("Auto-approve all tool
permission requests without prompting"); `docs/tools/antigravity/README.md` notes it still
blocks the system-command list. Without the flag, workers t7 and t8 of record #087 stopped
at a File access dialog for a read of `~/.gemini/config/mcp_config.json`, and t1h of the
task board run stopped at an `npx -y modern-web-guidance@latest` dialog.

## Proposed Improvement

1. Add a choice to section 3 of `HERDR-APP.md`: Skip (start every worker with
   `--dangerously-skip-permissions`, marked) or Ask (no flag), with the same fallback rule
   as the file's other choices.
2. Put the flag in every start line of the file that names an agent: `hc run` for `agy` and
   Claude, and `space.new --argv` and the `hc send` fallback in section 5.
3. Say in the safety section what the flag removes: the dialogs for out-of-workspace reads,
   network and unsandboxed commands. The paths and limits in the brief and the review of
   `git status` and `git diff` become the only guard; the User's own spaces stay untouched.

## Scope

May change: `HERDR-APP.md` (sections 3, 4, 5, 6), this record and its list line.
Unchanged: `HERDR-TUI.md`, INDEX, the constraints, the User's own spaces and terminals,
`GOAL.md`. Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edit; the request and evidence above.
- 2026-11-21: Edited `HERDR-APP.md`: the Skip/Ask choice after the model list (Skip marked),
  `<perm>` in the `hc run` lines for `agy` and Claude and in the section 5 `--argv` and
  `hc send` lines, and a safety bullet. Ran the check below. Nothing is committed or pushed.

## Validation

Native check: `harness-check` after the edit: clean at 88 IDs.

Run in the User's open app, 2026-11-21: `herdr-app do space.new --name agy-perm-test --argv
'["agy","--model","gemini-4-hydrogen-high","--dangerously-skip-permissions"]' --focus false`
returned terminal `t1t`; `hc wait` returned `idle`; `hc send --wait` with a brief to read
`~/.gemini/config/mcp_config.json` with `read_file` (outside the workspace) and to run
`Get-Date -Format yyyy-MM-dd` with `run_command` returned `status: done` in one turn with
the answers `0 bytes` and `2026-11-21`, and no dialog. The same outside read stopped workers
t7 and t8 at a File access dialog in #087, which started without the flag. The test space
was closed afterwards; the User's own spaces were not touched.

Not run: a Claude worker with the flag in the app, `--dangerously-skip-permissions` against
the `npx` or `BypassSandbox` dialog that t1h raised, and a fresh coordinator that follows the
new text to start a worker.

## Risks

- The flag lets a worker read outside the workspace, run network commands and use
  `BypassSandbox` without the User's approval. Mitigation: the choice is one checkbox that
  the User can unmark; the brief still carries the allowed paths and limits; the
  coordinator reviews changes before reporting; `agy` keeps its system-command block list.
- For Claude workers the flag was not run in the app. It stays stated as unverified.

## Decision and Result

Decision: keep. `HERDR-APP.md` now marks Skip, so a coordinator that follows it starts each
`agy` or Claude worker with `--dangerously-skip-permissions`; the one `agy` run showed an
outside-workspace read and a command finishing with no dialog where the same read stopped two
workers before. The User can mark Ask to restore the dialogs.

Observed, not changed: the footer still reads "Auto mode: edits & safe commands auto-approved",
so it does not show the flag; `HERDR-TUI.md` still says to add the flag only on request
(the candidate purpose, awaiting the User). Nothing is pushed.
