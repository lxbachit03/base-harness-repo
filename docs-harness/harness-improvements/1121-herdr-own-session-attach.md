# Harness Improvement Resource

ID: #086_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Offer the Herdr attach command when an own named session runs, with a box for Claude to open it
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-TUI.md
- docs-harness/harness-improvements/1121-herdr-orchestration-instructions.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

When the own-session switch of `docs-harness/HERDR-TUI.md` is marked, the Claude session gives
the User the `herdr session attach <name>` command as soon as the worker has started, and
again when the worker is `blocked`, either as a command the User runs from a code block or,
when the User marks a second box, opened by Claude in a terminal tab of the host.

## Purposes

- [x] Let the User watch the own-session worker and answer its dialogs without hunting for the
  command, as the User asked on 2026-11-21 (a command to run from the reply, like the
  one shown in the conversation).
- [x] Let the User choose whether Claude only shows that command or also runs it, through one
  checkbox, as the User asked on 2026-11-21.
- [ ] Candidate, awaiting the User: the same offer for the `hc` and app way in `HERDR-APP.md`.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `99ad974`, with
`1121-herdr-orchestration-instructions.md` (#082) closed and not yet committed;
`harness-check` clean at 85 IDs.

Request: after the own-session replay the User asked what Claude does when the switch is
marked, and whether the work shows in the Herdr TUI. The answer: the named session is a
separate server, so the work is not in the User's `default` TUI; it appears only after
`herdr session attach <name>`. The User asked for Claude to propose that command so it can
be run with one click, plus a checkbox that decides whether Claude runs it or the User does.

Evidence in the file: own-session step 4 says "Give the User the name and tell them
`herdr session attach <name>` in a terminal shows every pane" and does not say when to give
it, in what form, or that a shell tool that waits for exit would hang on it (the command opens
an interactive TUI). The Claude Desktop host has a Terminal panel tool that types a command
into a visible shell tab (`run_in_terminal`) and closes only tabs Claude opened
(`stop_terminal_tab`).

## Proposed Improvement

1. In the Gate of `HERDR-TUI.md`, add a second box next to the own-session switch: unmarked,
   Claude shows the attach command for the User to run; marked, Claude runs it in the host's
   terminal tab. The box matters only when the own-session switch is marked.
2. Rewrite own-session step 4: give the command when the worker has started and again when
   the worker is `blocked`; in its own fenced `powershell` block when the box is unmarked;
   through the host's terminal tool when marked, never through a shell tool that waits for
   exit; fall back to the block when no such tool exists.
3. In the cleanup step, close the tab Claude opened after the session is stopped.

## Scope

May change: `HERDR-TUI.md` (Gate and own-session steps), this record and its list line.
Unchanged: `HERDR-APP.md`, INDEX, the other constraints, the User's `default` session and the
User's own Terminal tabs. Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edit; baseline and request above as evidence.
- 2026-11-21: Added the second box to the Gate of `HERDR-TUI.md` and rewrote own-session
  steps 4 and 5 (when to give the command, the `[ ]` and `[x]` forms, the Bash hang, closing
  the tab). Ran the `[x]` path from this session (see Validation). Nothing is committed or
  pushed.
- 2026-11-21: Replay case A (box `[ ]`) found a defect: the coordinator gave the attach
  command only in its final report, after it had deleted the session. Reworded step 4 so
  the command goes in a message right after `agent start`, before the call that waits, and
  reran A and B (see Validation).
- 2026-11-21: Case B through a native subagent was refused by the role rule; at the User's
  request ran it in a separate Claude Desktop session, which passed (see Validation) and
  closed the record. Nothing is committed or pushed.

## Validation

Native check: `harness-check` after the edit: clean at 86 IDs.

Run of the `[x]` path from this Claude Desktop session, 2026-11-21, following the steps as
now worded: `herdr session list --json` showed only `default`; `herdr --session
claude-attachtest server` started and `workspace create` returned `w1:p1`; then
`run_in_terminal` typed `herdr session attach claude-attachtest` into a new tab `c1` (the
host asked for approval of the exact line); `read_terminal` showed the attached TUI with the
space `base-harness-repo` and its shell pane; `session stop` and `session delete` left only
`default`, and `c1` printed `server shut down` and returned to its prompt; `stop_terminal_tab`
with `close: true` closed `c1`. The User's `default` session and own tabs were not touched.

The `[ ]` form is the code block of the reply to the User for this change.

Fresh replays, 2026-11-21, coordinator `claude-sonnet-5-5` through `claude -p` (Read, Glob,
Grep and Bash allowed, `HERDR_*` and `HC_*` variables removed, outside Herdr). The prompt, in
Vietnamese: use Herdr TUI for a small read-only task on `agy` (four files of
`docs-harness/claude-instructions`, name and first heading), the User ticks "Allow an own
named session" in the prompt (the box in the file stays `[ ]`), does not tick "Open the
attach command myself", takes the other marked boxes, leaves `default` alone, and wants the
session stopped and deleted afterwards. `claude -p` has no terminal tool, so these runs
also exercise the fallback to the block.
- Case A, first run (18 turns, 127 s): the coordinator read the INDEX and `HERDR-TUI.md`,
  started its own session, drove `agy` and got the four headings right, `git status`
  unchanged, session stopped and deleted. Defect: it gave the attach command only in the
  final report, after the session was deleted ("you no longer need it"), so step 4's "as soon
  as the worker has started" was not followed. Fix: step 4 now says to write the command in a
  message right after `agent start` succeeds, before the call that waits for the worker.
- Case A, rerun after the fix (25 turns, 93 s, about 46k cache-creation and 829k cache-read
  tokens): the same chain; right after `agent start` it wrote the line "this command opens
  the session's panes" and the command alone in a fenced `powershell` block
  (`herdr session attach claude-read-titles`), before the brief and the wait; opened no
  tab (it has no terminal tool); the four headings matched the files; `git status`
  unchanged; stop and delete left only `default`; the final report said the box was
  unmarked and the command was given as a block.
- Case B (box `[x]`), through a native subagent (Agent tool, Sonnet, which has the Terminal
  tools): not exercised. The subagent stopped before any `herdr` command: as a delegated
  worker it starts no agents (`1120-session-role-and-judgment.md` and `HERDR-TUI.md`
  section 6), and it noted both boxes are `[ ]` in the file. That is the role rule working,
  not a defect of the boxes. It touched no tab (`list_terminal_tabs` shows only the User's
  `Terminal 1`), no session (only `default` listed) and no file.

- Case B again, in a separate Claude Desktop session started for it (not a delegated worker,
  with the Terminal tools; 32 turns), same prompt with both boxes ticked in the prompt, and
  with the instruction to close the tab it opened. It followed the steps: its own session
  `claude-agy-read`, `agy` worker `agyread` with `gemini-3.8-flash-high` and the Load
  brief; right after `agent start` succeeded it wrote the attach command for the User and
  typed `herdr session attach claude-agy-read` into a new tab `herdr-claude-agy-read`
  (`c1`, cwd the repository) with `run_in_terminal`, before it wrote the brief and before
  the wait; the four headings matched the files; `git status` unchanged; after `session
  stop` and `session delete` it closed `c1` with `stop_terminal_tab` (`close: true`; the
  tab showed `server shut down`). Afterwards only `default` is listed and the only
  Terminal tab is the User's `Terminal 1`.

Not run: the attach command while a worker is `blocked`, whether the User watched the
attached tab, and a host with no terminal tool in a Desktop-like session (case A covered the
fallback through `claude -p`).

## Risks

- Opening a tab changes the User's Terminal panel. Mitigation: the box is unmarked by default,
  the host asks for approval of the exact command, and Claude closes only the tab it opened.
- A second `attach` client or a stale tab after `session stop`. Mitigation: the cleanup step
  stops the session first and then closes the tab Claude opened.

## Decision and Result

Decision: keep. `HERDR-TUI.md` was available, retrieved and exercised in both cases. With the
second box `[ ]` a fresh coordinator gave the attach command alone in a fenced `powershell`
block right after the worker started (after one rewording of step 4 found by the first
run). With the box `[x]` a fresh Desktop session typed the command into its own Terminal tab
at the same point and closed that tab after it stopped and deleted its session. In both,
the User's `default` session and own tabs were left alone. A native subagent did not run the
case because a delegated worker starts no agents, which is the role rule working.

Observed, not changed: both replay prompts ticked the boxes in the prompt while the file
keeps them `[ ]`; a coordinator treats the User's words as the permission, a subagent
stopped on the unmarked file. The retrieval cost of a coordinator stays at tens of thousands
of tokens before any Herdr step.

Remaining proof, not required: the command while a worker is `blocked`, whether a User
attached to the tab can answer a dialog there, `HERDR-APP.md` (the candidate purpose, awaiting
the User). Nothing is pushed.
