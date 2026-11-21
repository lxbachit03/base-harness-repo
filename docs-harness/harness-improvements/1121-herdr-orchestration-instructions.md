# Harness Improvement Resource

ID: #082_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add docs-harness/HERDR-TUI.md so Claude can open a Herdr pane and orchestrate other agents
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-TUI.md
- docs-harness/INDEX.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- docs-harness/harness-improvements/1031-remove-coordination-skills.md

## Objective

`docs-harness/HERDR-TUI.md` exists and INDEX routes it to sessions only when the User asks for
Herdr or names it. A Claude session that reads it can, from inside a Herdr pane, create a
pane, start another agent there, hand that agent the full context of a task, wait for it,
and read its result back.

## Purposes

- [x] Let Claude coordinate other coding agents through Herdr with enough context for each
  to do the task, as the User asked on 2026-11-21.
- [x] Load the instructions on demand (a User request or a mention of Herdr) so that
  sessions that never use Herdr pay nothing, as the User asked on 2026-11-21.
- [x] Let the User choose which Gemini model Herdr drives through `agy`, with a checkbox
  list in `HERDR-TUI.md`, as the User asked on 2026-11-21.
- [x] Let the User decide, with a checkbox in `HERDR-TUI.md`, whether a Herdr worker loads the
  Harness context (`AGENTS.md`, INDEX retrieval) or only what the brief lists, as the User
  asked on 2026-11-21.
- [x] Let a Claude Desktop session, which runs outside Herdr, orchestrate through its own
  named Herdr session instead of losing its conversation context in a new pane, with a
  checkbox in `HERDR-TUI.md` that the User marks to allow it, as the User asked on 2026-11-21.
- [ ] Candidate, awaiting the User: keep the file small by pointing at the installed CLI
  (`herdr --help`, `herdr agent`, `herdr pane`) for syntax instead of copying it.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `7ae1018`, in sync with
`origin/main`, working tree clean, `harness-check` clean at 81 IDs.

Request: the User asked, in Vietnamese, for a `HERDR-TUI.md` under `docs-harness/`, loaded on
request or mention, written from a deep research of Herdr (https://herdr.dev/) so that
Claude can create a pane and use Herdr to orchestrate other agents, with full context, and
get the results back.

History: the coordination skills were removed (`#048`) and the historical worker catalog
`HERDR-AGENTS.md` was deleted on 2026-11-21 (`e9fc1ae`). This request adds a new reference
file for the tool itself, with no worker or model catalog and no skill.

Evidence gathered on 2026-11-21:
- The installed binary is `herdr 0.9.4-preview.2026-10-14-fbd2ae23927f` (protocol 22), its
  server is running, and `herdr --skill` prints the upstream agent skill file. The
  published stable docs index (`https://herdr.dev/llms.txt`) names release 0.9.5.
- Upstream pages read: the skill file, `llms.txt`, `agent-guide.md`, Agent automation, CLI
  reference, Windows support, Agents and Concepts.
- This session's `HERDR_ENV` is unset, so it runs outside Herdr; the upstream skill says
  to stop there and not to control the User's focused session from outside.

## Proposed Improvement

1. Create `docs-harness/HERDR-TUI.md` from the upstream skill, trimmed to this repository:
   the in-Herdr gate, where syntax comes from, the layout and ID model, one orchestration
   procedure (pane, agent, brief with full context, wait, read the result, review), the
   safety rules, and this repository's role rules for a delegated worker.
2. Route it from INDEX (Root Routing) with a Read when of "the User asks for Herdr or names
   it" and a Skip when of every other request, so it is not a session-start read.
3. List this record in `docs-harness/harness-improvements/README.md`.

## Scope

May change: the new `docs-harness/HERDR-TUI.md`, one INDEX route, this record and its list
line. Unchanged: the skills, `docs/tools/orca-ade/README.md`, `#048`, the session role and
task authority constraints, the Claude instruction files. Nothing is committed or pushed.
Throwaway Herdr work during validation runs only in a named test session that this task
creates and stops, never in the User's own session.

## Progress

- 2026-11-21: Record opened before the edits; baseline and research evidence taken as
  above.
- 2026-11-21: Ran the procedure in a throwaway named session (see Validation), then wrote
  `docs-harness/HERDR-TUI.md` (5 sections) and added its INDEX route (Root Routing) and this
  record's list line. Nothing is committed or pushed.
- 2026-11-21: At the User's request researched the Antigravity CLI (`agy`) and added
  section 5 to `HERDR-TUI.md`; ran it as a Herdr worker in a second throwaway session (see
  Validation).
- 2026-11-21: At the User's request added a Gemini model checklist (one box marked, the
  fallback when none or several are marked) to section 5 of `HERDR-TUI.md`; the entries come
  from `agy models` on that date. Only the default entry was run. Nothing is committed or
  pushed.
- 2026-11-21: The User asked whether a Herdr worker re-reads the Harness. `HERDR-TUI.md` said a
  worker "first reads" `AGENTS.md` and the INDEX retrieval, which no run had measured (the
  `agy` briefs forbade it; the Claude Haiku runs were one-line prompts). Plan: measure it
  with a small real task and no prohibition, correct that sentence to the evidence, and add
  a checkbox for the User's decision. Nothing is committed or pushed.
- 2026-11-21: Ran the fresh replay with Sonnet 5.5 (two cases, see Validation) and closed
  the record. Nothing is committed or pushed.
- 2026-11-21: Reopened (same intervention, same file). The User asked for the Desktop way:
  stay in the Claude Desktop session and let Claude start its own named Herdr session,
  with a checkbox that opts in. The gate of `HERDR-TUI.md` stopped any session outside Herdr
  and allowed a named session only for experiments. Plan: add an unmarked switch and an
  "own named session" procedure from the steps already run on 2026-11-21, plus one line
  that `pane run` types into an agent's pane, then run the documented steps from this
  Desktop session. Nothing is committed or pushed.
- 2026-11-21: At the User's request ran the fresh Desktop-style replay of the own-session
  switch (see Validation) and closed the record. No file text changed. Nothing is pushed.

## Validation

Native check: `harness-check` full run clean (82 IDs, 1041 links in 181 Markdown files,
INDEX route resolves).

Mechanical run, 2026-11-21, `herdr 0.9.4-preview` on Windows, in a named test session
`hrd-probe` (started with `herdr --session hrd-probe server`, stopped and deleted
afterwards; the User's default session stayed running and was never targeted):
- `workspace create`, `pane split` returned the IDs at `.result.root_pane.pane_id` and
  `.result.pane.pane_id`; the panes run PowerShell.
- `pane split --env HARNESS_ROLE=worker` reached the shell: a `pane run` of a Python
  one-liner printed `ROLE=worker ENV=1 PANE=w1:p2`, and `pane wait-output --regex` matched it.
- `agent start --kind claude -- --model claude-haiku-5-5` in an untrusted scratch directory
  returned `agent_not_ready` with status `blocked` on the "trust this folder" dialog;
  `agent read --source visible` showed it, and `agent send-keys esc` exited without
  trusting. The same start in this repository returned `idle`, `interactive_ready: true`.
- `agent prompt --wait` returned for a one-line prompt, a two-line prompt, a one-line
  Vietnamese prompt and a six-line Vietnamese brief read with `$(cat brief.md)`; each
  `agent read --source recent-unwrapped` showed the exact reply (`PONG-6 Đã xong` for the
  brief). The first prompt, sent right after `agent start`, returned `agent_prompt_stalled`
  with nothing submitted; the same brief sent later worked.

Antigravity run, 2026-11-21, `agy 1.5.13`, named test session `hrd-agy` (stopped and
deleted afterwards; the User's own `agy` and Herdr processes were left alone). Sources for
section 5: `agy --help`, `agy models`, `agy changelog`, the official README and the CLI
settings page at antigravity.google, Herdr's agents and Windows pages, and record `#029`.
- `agent start --kind agy -- --model gemini-3.8-flash-low` in this repository returned
  `idle`, `interactive_ready: true` in about 4 s; the TUI header showed the model and the
  working directory.
- Three `agent prompt --wait` runs returned in 4 to 6 s with the correct reply visible in
  `agent read`: a one-line prompt (`PONG-1`); a five-line Vietnamese brief to read
  `docs-harness/claude-instructions/README.md` and count its listed files (`COUNT=4` and
  the four names, final line `Đã xong.`, correct against the file); a four-file read task
  (first line of each file, correct).
- At each read the TUI footer still said `WORKING` while Herdr reported `idle` with the
  reply present. The false `done` signals of `#029` (Flash High, long turn) did not
  appear in these short Flash Low runs; longer work stays unverified.
- `agy -p "Reply with exactly: HEADLESS-OK" --model gemini-3.8-flash-low` printed the
  reply in 9 s.
- Gemini CLI (`--kind gemini`) is not installed, so it was not run.

`gemini-3.8-flash-high` run, 2026-11-21, the model the User marked in the checklist, in
named test session `hrd-high` (stopped and deleted afterwards): `agent start` returned
`idle` in about 4 s with the header showing `Gemini 3.8 Flash (High)`, and the ID was in
`agy models`. The five-line Vietnamese read-and-count brief returned in 35 s with
`COUNT=4`, the four names and `Đã xong.`, correct. A four-file task (file name, number of
`## ` lines, first heading) returned in 33 s, all four lines correct against the files
(3, 0, 2, 1). After each `--wait` the status stayed `idle` with an unchanged
`state_change_seq` over 6 s and over three 8-s polls: no false `done` or `idle` of the kind
`#029` saw in a long turn. Both turns were short; long turns remain unverified for High.

Worker context-loading run, 2026-11-21, named test session `hrd-ctx` (stopped and deleted
afterwards), the same small task for two workers, a brief that says it is a worker and
asks to count the files listed in `docs-harness/claude-instructions/README.md`, with no
prohibition on reading:
- Claude Haiku 5.5: answered `COUNT=4` in 4 s, `Read 1 file` (the target); it read no INDEX.
  `/context` (run with `MSYS_NO_PATHCONV=1`) showed 49.6k tokens in use: system prompt
  3.6k, tools 23.3k, MCP instructions 0.7k, memory files 0.4k (2 files, so `AGENTS.md` was
  loaded as memory), skills 7.6k, messages 13.9k (this includes a detour, below).
- `agy` `gemini-3.8-flash-low`: answered `COUNT=4` in 10 s after reading `INDEX.md` (444
  lines) and then the target file (39 lines); the footer showed +13.0k tokens for the turn
  and 18.4k in total; it read no constraint or retrieval file.
- A first `/context` sent from Git Bash arrived as `C:/Program Files/Git/context` (Git
  Bash converts an argument that starts with `/`); the worker only listed two directories
  and asked what was meant. `MSYS_NO_PATHCONV=1` fixed it.
- Not measured: the cost of a worker told to load the full retrieval in this run (earlier
  Harness replays put it near 100k tokens), the token cost of a Claude worker's own turn
  beyond `/context`, and other kinds and models.

Fresh replay, 2026-11-21, coordinator `claude-sonnet-5-5` (Claude Code 2.1.330, auto
mode), revision `7ae1018` plus the uncommitted change set, cost near 80k tokens of context
for case 1 and 125k cached-read tokens over 9 turns for case 2. Both cases used one
Vietnamese prompt: use Herdr to give another agent a small read-only task (count the files
under "Instruction files" in `docs-harness/claude-instructions/README.md`) and report.
- Case 1, inside a Herdr pane (named session `hrd-replay2`, stopped and deleted afterwards).
  Started cold, the coordinator read `AGENTS.md`, the INDEX, `HERDR-TUI.md`, the two mandatory
  constraints and the `claude-instructions`, `project-constraints` and `layers` files
  without being told to; ran the gate (`HERDR_ENV`, `HERDR_PANE_ID`, `herdr status`);
  asked one question (agent kind and model, then Harness context Load or Skip, with the
  token cost) through its question dialog; printed `herdr agent`, `herdr pane` and checked
  the model ID in `agy models`; read `herdr pane layout` and split down (the pane was
  narrow) with `--cwd`, `--env HARNESS_ROLE=worker` and `--no-focus`; started `counter`
  as `agy` with `gemini-3.8-flash-high`; sent a brief with the role sentence, the file, the
  limits (read-only, no commit or stage), the counting rule and the report shape; got
  `agent_prompt_stalled`, read the pane (an `agy` backend error, nothing submitted) and
  resent once; read the reply, compared its own count with the file, checked
  `git status`, left the pane open and reported the pane, the model, the first failure, the
  worker's cost (about 2.1k tokens, 30 s), the unchanged `git status` and the proof not
  attempted. Answer `4`, correct. The User answered the second question (Skip, so the
  brief forbade reading `AGENTS.md` and the INDEX, and the worker obeyed).
- Case 2, outside Herdr (`claude -p`, `HERDR_ENV` unset, `HERDR_SESSION` pointed at a
  session that does not exist, tools limited to read, search, echo/test and PowerShell). The
  coordinator read the INDEX, `HERDR-TUI.md` and the constraints, ran `harness_check --quick`,
  stopped at the gate with no `herdr` command against any session, explained why, and
  offered the options: start Claude in a Herdr pane, do the count itself, or use `agy -p`
  (asking for consent because it spends Google quota). It also repeated the kind and Load
  or Skip questions for the later run.
- Execution faults, none in the file: my first replay session was discarded because I
  typed a command into the coordinator pane right after it started; in the clean session I
  answered its first question (agent kind, the recommended default) with `agent send-keys`,
  and the auto-mode classifier then refused my answer to the second, so the User answered
  it (consistent with the `HERDR-TUI.md` rule that a dialog answer is the User's).

Own-session steps, 2026-11-21, run from this Claude Desktop session (`HERDR_ENV` unset)
as `HERDR-TUI.md` now words them: `herdr session list --json` showed only `default`; the
server `claude-ownsess` started with `herdr --session claude-ownsess server`; with
`--session` after `herdr` and no `--current`, `workspace create` and `pane split` returned
`w1:p1` and `w1:p2`, `pane layout --pane w1:p1` answered, a `pane run` on the shell pane
printed `ENV=1 SESSIONPANE=w1:p1` (the panes of the named session do carry `HERDR_ENV`), an
`agy` worker (`gemini-3.8-flash-low`) started in `w1:p2` returned `idle` and answered
`PONG-OWN`; then `session stop` and `session delete` left only `default`. The User's own
session was never targeted. Not run: a fresh Desktop Claude that marks the switch and
follows the steps unaided, `session attach` by the User for a `blocked` dialog from this
mode (the replay's attach worked on a named session), and whether the background server
outlives the Desktop session that started it.

Fresh replay of the own-session switch, 2026-11-21, coordinator `claude-sonnet-5-5`
(`claude -p`, Read, Glob, Grep and Bash allowed, `HERDR_*` and `HC_*` variables removed so
it is outside Herdr, 23 turns, 177 s). The prompt, in Vietnamese: use Herdr TUI for a small
read-only task on `agy` (four files of `docs-harness/claude-instructions`, file name and
first heading), the User is in Claude Desktop and ticks "Allow an own named session" in the
prompt (the box in the committed file stays `[ ]`), take the other marked boxes, leave the
`default` session alone, then report the session name and attach command and stop and
delete the session.
- Available and retrieved: it read the INDEX and `HERDR-TUI.md` (and not `HERDR-APP.md`)
  with the session retrieval.
- Exercised: `herdr session list --json` showed only `default`; it started
  `herdr --session claude-readtitles server`, created the workspace with
  `--session` after `herdr`, `--env HARNESS_ROLE=worker`, `--no-focus` and explicit pane
  `w1:p1`, started `agy` as `titles` with `gemini-3.8-flash-high`, gave a brief carrying
  the worker role and the Load line, got `idle` from `agent prompt --wait` on the first
  send (no `agent_prompt_stalled`, no `blocked`), read the result, and ran `session stop`
  then `session delete`; `herdr session list` afterwards showed only `default`.
- Result: the four names and first headings were right (compared with the files);
  `git status` stayed clean; it reported the session name and `herdr session attach
  claude-readtitles` and said the command is dead after the delete.
- Slips and limits: it ran one `herdr status` without `--session` before the named session
  existed; that command is read-only (the gate step 2 asks for it) and it said so. It noticed
  that the box is `[ ]` and treated the User's words in the prompt as the permission,
  and said how to make it durable. It did not hit `blocked`, a Claude worker, a write or
  the question of whether the background server outlives the Desktop session.
Cost: about 47k cache-creation and 676k cache-read tokens over 23 turns, plus the `agy`
quota of one four-file read with Harness loading.

Not covered by those runs: a coordinator that is itself a Claude session inside a Herdr pane
and follows the file by itself, a worker doing real work in the repository (its start-up
reads `AGENTS.md` and the INDEX), `blocked` approval handling beyond the trust dialog,
parallel workers, `--machine`, briefs beyond a few KB, Windows paths from Git Bash, an
`agy` worker that edits files or meets a permission prompt, other `agy` models and efforts,
and the full-retrieval cost of a Herdr worker (the context-loading run above measured only
the unprompted behavior).

## Risks

- The file copies a fast-moving tool's behavior, and a copy goes stale. Mitigation: it
  names the installed CLI as the authority for syntax, records the version it was written
  against, and keeps only rules the CLI does not show.
- A session outside Herdr could control the User's panes. Mitigation: the gate stops the
  session when `HERDR_ENV` is not `1`.
- A worker may block on a permission dialog or edit files the coordinator also edits.
  Mitigation: the procedure treats `blocked` as a User decision and gives each writer
  disjoint paths.
- Each worker agent spends tokens, and a worker in this repository first loads `AGENTS.md`
  and the INDEX retrieval. Mitigation: the User names the agent kind and model, and the
  file says so.

## Decision and Result

Decision: keep. `HERDR-TUI.md` was available, retrieved and exercised in every case run:
inside a Herdr pane the coordinator followed the gate, question, pane, agent, brief, wait,
resend, read and review steps unaided; outside Herdr with the switch `[ ]` it stopped at the
gate; and in the 2026-11-21 fresh replay a Desktop-style Sonnet 5.5 coordinator with the
own-session permission started its own named session, drove an `agy` worker with explicit
pane IDs, verified the result, stopped and deleted the session and left `default` alone.
The Gemini checklist and the Harness context checkbox were read and used.

Observed, not changed: the replay ran `herdr status` before it had a named session and took
the permission from the prompt instead of the box; both are consistent with the file. The
coordinator's session retrieval costs tens of thousands of tokens before any Herdr step, and
it did not ask which paths a worker may write (the task was read-only).

Remaining proof, not required: a worker that edits files, `blocked` approvals beyond the
trust dialog, parallel workers, a Claude-kind worker started by a coordinator in this mode,
long turns, `--machine`, briefs beyond a few KB, and whether the background server outlives
the Desktop session that started it. Nothing is pushed.
