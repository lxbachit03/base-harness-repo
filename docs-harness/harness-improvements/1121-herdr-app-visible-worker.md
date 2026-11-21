# Harness Improvement Resource

ID: #085_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add to HERDR-APP.md how to show a worker in the Herdr desktop app window
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-APP.md
- docs-harness/harness-improvements/1121-herdr-app-file-split.md
- docs-harness/harness-improvements/1121-herdr-app-hc-orchestration.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

`docs-harness/HERDR-APP.md` gains a section that lets a Claude Desktop session start a worker
so that it appears in the Herdr app window, then drive that same terminal with `hc`, with
the failure modes seen on 2026-11-21 written down.

## Purposes

- [x] Let the User watch a worker run in the Herdr app while Claude Desktop orchestrates it,
  as the User asked on 2026-11-21.
- [ ] Candidate, awaiting the User: a Claude-worker variant of the section, once it is run.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `7ae1018`, with the
uncommitted `HERDR-TUI.md`, `HERDR-APP.md`, INDEX route and records `#082` to `#084`;
`harness-check` clean at 84 IDs.

Request: the User asked to see Claude Desktop orchestrate one agent and to see the work in
the Herdr app window; after the run the User asked to add the finding to `HERDR-APP.md`.

Evidence, 2026-11-21, in the User's open Herdr app (core pid 2644, space `base-harness-repo`
with the User's own `agy` terminal `t1`, left untouched):
- `herdr-app do space.new --name claude-demo --folder <repo> --argv '["agy","--model",
  "gemini-3.8-flash-high"]' --task "<brief>" --focus true` returned
  `{space, tab, terminal: t3}` and the space appeared.
- The app appended `--task` to the agent's command line (the process was `powershell
  -NoExit -Command "& 'agy' '--model' ... '<brief>'"`): `agy` answered `unexpected argument`
  and the terminal stayed at a PowerShell prompt; the Vietnamese text in the argument was
  garbled by that wrapper.
- `hc send t3 "agy --model gemini-3.8-flash-high"` started `agy` in that terminal (`hc get`:
  `{app: antigravity, state: idle}` at once), then `hc send --wait t3 "<brief>"` returned
  `reason: status`, `status: done` after 37 s. `agy` read 9 files (the Load context choice)
  and answered the four-file task correctly; `git status` was unchanged; `herdr-app ls`
  listed `claude-demo` (active) with `t3 idle antigravity`.

## Proposed Improvement

1. In `HERDR-APP.md`, a section "Show a worker in the app window" with the steps above:
   check the window read-only, state the change, create the space or tab through `herdr-app`
   without `--task`, start the agent in the returned terminal, drive it with `hc`, leave it
   for the User and close it only on request.
2. Adjust the section 1 bullets and Safety that the new section touches.

## Scope

May change: `HERDR-APP.md`, this record and its list line. Unchanged: the `hc` procedure of
section 4, `HERDR-TUI.md`, INDEX, the other constraints. The space `claude-demo` stays in the
User's window until the User closes it. Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edit; baseline and the run above as evidence.
- 2026-11-21: Added section 5 "Show a worker in the app window" to `HERDR-APP.md` (Safety is
  now section 6) and adjusted two section 1 bullets. Nothing is committed or pushed.
- 2026-11-21: At the User's request closed the `claude-demo` space and ran the fresh replay
  in the User's open window (see Validation); closed the record. Nothing is committed or
  pushed.

## Validation

Native check: `harness-check` after the edit: clean at 85 IDs.

Close step, 2026-11-21, at the User's request: `herdr-app do space.close --id <claude-demo>
--confirmed true` printed `{"ok": true}`; `herdr-app ls` then listed only the User's
`base-harness-repo` space (its `t1` still `idle` and live) and `hc ls --all` showed `t3`
`finished`.

Fresh replay, 2026-11-21, in the User's open app window, coordinator `claude-sonnet-5-5`
(`claude -p`, Read, Glob, Grep and Bash allowed, no isolation, 16 turns, 98 s). The prompt:
use the Herdr desktop app to run a small read-only task on `agy` so the User can watch it
in the app (read four files of `docs-harness/claude-instructions/`, give each file's name
and first heading), take the boxes marked in `HERDR-APP.md`, and consent to one new space.
- It read the INDEX and `HERDR-APP.md` (and not `HERDR-TUI.md`) with the session retrieval,
  ran `hc server status`, `herdr-app status` and `herdr-app ls`, and checked that
  `gemini-3.8-flash-high` is in `agy models`.
- It created the space with `herdr-app do space.new --name read-claude-instructions
  --folder <repo> --argv '["agy","--model","gemini-3.8-flash-high"]' --focus true` and no
  `--task`, so none of the 2026-11-21 launch faults recurred; the terminal was `t4`.
- It waited with `hc wait t4`, then gave the brief with `hc send --wait t4`: the worker
  sentence, the Load context line, the read-only limits (no write, commit or stage), the four
  files and the report shape. `agy` finished (`done`); its four first headings matched the
  files.
- It collected with `hc read`, listed the space in `herdr-app ls`, compared `git status`
  before and after (unchanged), left the space open, gave the exact `space.close` command,
  and said it had not taken a `herdr-app shot` to confirm what is on screen.
- Afterwards `herdr-app ls` showed the User's `base-harness-repo` space unchanged and the new
  space `read-claude-instructions` active with `t4` `done`; `git status` still showed the 8
  uncommitted items of the User's change set and no worker change.
Cost: about 42k cache-creation and 522k cache-read tokens over the 16 turns, plus the `agy`
quota of one 9-file read.

Not run: a Claude worker started through `space.new`, `tab.new --space`, `--focus false`,
and a screenshot of the window.

## Risks

- Creating a space changes the User's open window. Mitigation: the section has the session
  state the change first, do it only when the User wants to see the worker, name the space
  for the task, and never touch or close the User's own spaces; the replay touched only its
  own space.
- `herdr-app` commands may change between versions. Mitigation: the section points at
  `herdr-app commands` for the syntax.

## Decision and Result

Decision: keep. Section 5 of `HERDR-APP.md` was available, retrieved and exercised by a
fresh Sonnet 5.5 coordinator in the User's real window: it created a visible space without
`--task`, drove `agy` with `hc`, verified, and left the User's own space alone. The space
`read-claude-instructions` stays open for the User to see; the User closes it, or asks for
`herdr-app do space.close --id spf2574f817c6b92c0d2692bdd79a49b4e --confirmed true`.

Remaining proof, not required: a Claude worker through `space.new`, `tab.new --space`,
`--focus false`, a `herdr-app shot` check, and a worker that edits files. Nothing is
committed or pushed.
