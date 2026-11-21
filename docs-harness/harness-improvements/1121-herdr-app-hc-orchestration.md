# Harness Improvement Resource

ID: #083_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Tell Herdr TUI, the Herdr desktop app and herdr-core (hc) apart in HERDR-TUI.md, and test hc for orchestration
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-TUI.md
- docs-harness/harness-improvements/1121-herdr-orchestration-instructions.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

`docs-harness/HERDR-TUI.md` says which of the three Herdr programs it covers (the terminal
`herdr` TUI) and where the other two stand, so a session that reads "Herdr" does not apply
TUI commands to the desktop app or to `hc`. A separate investigation establishes whether
`hc` can carry the orchestration procedure on this machine, and `HERDR-TUI.md` gains an `hc`
section only when that evidence supports it.

## Purposes

- [x] Stop a Claude session from mixing up the three programs, as the User asked on
  2026-11-21 (step 2 of the evaluation the User accepted).
- [x] Investigate, before any `hc` guidance is written, how Claude Code and `agy` could
  report their status to `hc`, and test `hc wait --children`, as the User asked on
  2026-11-21 (step 3 of the same evaluation).
- [ ] Candidate, awaiting the User: move the orchestration procedure from the TUI to `hc`
  if the investigation shows it is the better carrier (it shows both work; see Decision).

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `7ae1018`, with the
uncommitted `HERDR-TUI.md`, INDEX route, `#082` and its list line; `harness-check` clean at 82
IDs.

Request: after the evaluation of https://herdr.dev/ (desktop app) and https://herdr.dev/tui/
against the Harness repository, the User asked to carry out its recommendations: keep the
TUI procedure, add a note that tells the three programs apart, and open a separate record
that investigates status reporting for Claude Code and `agy` and `hc wait --children`
before any `hc` section is written.

Evidence gathered on 2026-11-21:
- The machine runs all three: `herdr 0.9.4-preview` (TUI, its own server), `herdr-app`
  (desktop app) and `herdr-core` with `hc 0.1.21`. The home page says the app and the TUI do
  not share agents. `hc --skill`, `herdr-app --skill` and `herdr --skill` print each one's
  agent manual.
- Probe in an isolated core (`HC_SESSION=hc-probe`, stopped afterwards; the User's core,
  pid 2644, stayed untouched): a Claude Code worker answered in 3 s, but `hc wait` ran to
  its 120 s timeout and `hc send --wait` to 60 s, both with `status: null`, because `hc`
  takes status only from OSC 7501 reports and Claude Code sent none. `hc run -- agy ...
  "<prompt>"` failed with `unexpected argument`. `hc run` has no `--env` option.

## Proposed Improvement

1. In `HERDR-TUI.md`, a short note after the opening paragraph: this file covers the TUI
   (`herdr`); the desktop app and `hc` are separate programs whose agents the TUI cannot
   see, with their own manuals (`hc --skill`, `herdr-app --skill`) and no procedure here yet.
2. Investigate and record: how the status protocol works, whether Claude Code and `agy`
   can report it here, and whether `hc wait --children` completes for a helper that does.
3. Write an `hc` section only if the investigation shows a working completion signal;
   otherwise record the blocker and leave `HERDR-TUI.md` on the TUI.

## Scope

May change: `docs-harness/HERDR-TUI.md` (the note, and an `hc` section only under item 3), this
record and its list line. Unchanged: the TUI procedure and its checklists, INDEX, the other
constraints and instruction files. Throwaway `hc` work runs only in a named `HC_SESSION`
that this task creates and stops, never in the User's own core. Nothing is committed or
pushed.

## Progress

- 2026-11-21: Record opened before the edits; baseline and probe evidence as above.
- 2026-11-21: Added the three-programs note to `HERDR-TUI.md`, read the `hc` and app manuals and
  the `herdr-core` docs, and ran the investigation (see Validation). No `hc` section was
  written: no working completion signal exists for Claude Code or `agy` here. Nothing is
  committed or pushed.
- 2026-11-21: Ran the `#083` replay of the note (Sonnet 5.5 in a TUI pane; see Validation).
  Then the follow-up the User asked for: searched for a completion signal for `hc`. The
  probes show the earlier claim that `agy` sends no status was wrong (the first `agy` probe
  failed on its arguments before any status could show): `agy` reports OSC 7501 itself and
  `hc send --wait` completes for it; Claude Code does not, and `hc wait --output <marker>`
  completes for it. Plan: correct the note, write an `hc` section from these probes, and
  replay it. Nothing is committed or pushed.

## Validation

Native check: `harness-check` run after the edits (see the final report of the change).

Sources read, 2026-11-21: herdr.dev home, `/core/` and `/guide/` pages; the local
`~/.config/herdr-app/AGENTS.md` (the app's manual, rewritten by the app on every start);
`hc --help`, `hc --skill`, `herdr-app --help`; the `herdr-core` repository `README.md`,
`docs/templates.md`, `docs/commands.md` and the API schema (`hc schema`, 32 methods, none
sets a status). The README states that core "does not guess from screen text or recognize
agent brands" and that a program that does not report status has none; templates "do not
install agents or configure their status reporting", and a template's `ready: quiet`
skips the status wait at start-up only.

Probes in an isolated core (`HC_SESSION=hc-probe`; corrected below for `agy`, started and stopped by this task; the
User's core, pid 2644 with one live terminal, was checked unchanged before and after):
- Claude Code (Haiku 5.5) under `hc run --bg`: answered in 3 s; `hc wait --timeout 120`
  and `hc send --wait --timeout 60` both timed out with `status: null`.
- `agy` as `hc run -- agy --model ... "<prompt>"`: `unexpected argument`; `agy` takes an
  initial prompt through `-i`, so it needs a send after start-up (this probe did not show
  its status; the follow-up probes below do).
- Claude Code with session-only `--settings` hooks (`UserPromptSubmit` and `Stop`) that
  wrote `ESC ] 7501 ; state=working|done : app=claude ESC \` to `CONOUT$`: both hooks ran
  (the script's log showed `wrote working` and `wrote done`), yet `hc get` still showed
  `status: null` and `hc wait` timed out. A first attempt failed because backslashes in the
  hook command were consumed by the hook's shell; forward slashes fixed that.
- `hc wait --children all` from a coordinator terminal: a plain Python child that slept 3 s
  and exited completed the wait (`reason: children`), and `hc read kid` returned its
  output; the whole run took about 2 s of waiting.
- Cleanup: all probe terminals killed, `hc server stop` for the probe core only, and the
  User's core verified unchanged (pid 2644, 1 live terminal).

Follow-up probes, 2026-11-21, in a second isolated core (`HC_SESSION=hc-probe2`, stopped
afterwards; the User's core pid 2644 with one live terminal unchanged):
- The earlier statement that `agy` sends no status was wrong: the first `agy` probe failed
  on its arguments before status could show. Started as `agy --model gemini-3.8-flash-low`,
  it reports itself (`hc get`: `{app: antigravity, state: done, msg: COUNT=4}`), and
  `hc send --wait` returned `reason: status` in 3 s. Claude Code again showed
  `status: null` and `hc send --wait --timeout 20` ran to the timeout.
- A program that writes the OSC 7501 sequence on its own stdout works on Windows: a
  PowerShell script made `hc get` show `working` then `done`, and `hc wait` returned
  `reason: status` at once. The Claude hook route stayed null even with
  `ENABLE_VIRTUAL_TERMINAL_PROCESSING` set and `WriteConsoleW` reporting 33 and 30
  characters written, because the hook is a subprocess whose console output does not
  become the terminal's program output. A wrapper that owns the terminal's output and
  emits the sequence from hook state is the remaining untried route.
- `hc wait --output`: a Claude worker told to end with the word DONE, a dash and a number
  (never written joined in the brief) matched `DONE-4417` after 7.7 s (`reason: output`)
  with `COUNT=4`; an `agy` worker sent the same kind of brief matched `DONE-5520` after
  5.3 s. The brief itself contains no joined marker, so the echoed brief cannot match.

Replays, 2026-11-21, coordinator `claude-sonnet-5-5`, no hint beyond one user prompt each:
- The note (named TUI session `hrd-r83`, Claude in a pane with `HC_SESSION` and
  `HERDR_APP_HOME` pointing at throwaway targets so nothing could reach the User's core or
  window): the prompt asked to use the Herdr desktop app (`hc`) for a small task. The
  coordinator read the INDEX and `HERDR-TUI.md`, saw that the file had no `hc` procedure, read
  `hc --skill`, applied no `herdr` TUI command, started a Haiku worker through `hc run
  --bg`, got `status: null` from `hc wait` (90 s), read the screen, answered `4` correctly,
  reported the gap as `HERDR-TUI.md` described it, and left the terminal running. It also wrote
  a brief that used a variable that does not exist (`$HC_TERMINAL_ID_PARENT`) and said so.
  Result for the note: passed. Because the note then told it only to read the manual, it
  went on to use `hc`; section 6 now covers that path.
- The `hc` section (`claude -p` with an isolated `HC_SESSION=hc-r84` core, 15 turns, 66 s):
  one prompt asked for two read-only tasks in parallel, to `agy` (`gemini-3.8-flash-low`) and
  Claude Haiku 5.5, with Skip context. The coordinator did the session retrieval, ran both
  workers from `hc.exe` (not on `PATH`), waited for `agy` with `send --wait` (`status: done`)
  and for Haiku with a `DONE-4171` marker, collected both lists (4 files, identical, correct
  against the file), left `w-agy` and `w-haiku` running with the `hc attach` command,
  offered `hc kill` and `hc rm`, did not copy the account email, and reported what it had
  not done (no `git status`, no per-worker token count). Result for section 6: passed.
  Cost: 44.6k cache-creation and 520k cache-read tokens over the 15 turns.

Not run: a hook-plus-wrapper route for Claude status, the app showing these terminals,
templates, `--on` machines, `HARNESS_ROLE` reaching a child, `hc wait --children` with
agents, a worker that edits files, `blocked` handling through `hc`, and the Load context
option through `hc`.

## Risks

- A note that is wrong about programs that change weekly. Mitigation: it points at each
  program's own `--skill` output for syntax and claims only the split, the separate agent
  worlds and the 2026-11-21 probe result.
- Probing `hc` could disturb the User's running terminals. Mitigation: every probe used its
  own `HC_SESSION`, and the User's core was checked unchanged afterwards.

## Decision and Result

Decision: keep. `HERDR-TUI.md` now separates the three programs, and a new section 6 carries
orchestration through `hc` for Desktop-style sessions: `agy` completes natively
(`send --wait`), Claude Code completes through a marker with `hc wait --output`. Both the
note and the section were exercised by a fresh Sonnet 5.5 coordinator and passed (see
Validation). The TUI procedure (sections 1 to 5) is unchanged and stays the way to watch
workers in panes; `hc` is the pane-free way and does not show terminals in the app's
screens.

Correction recorded: the 2026-11-21 note and the evaluation reported to the User said that
Claude Code and `agy` give `hc` no completion signal. That was true only of Claude Code.
The note's wording was replaced by section 6.

Remaining proof, not required for this record: a hook-plus-wrapper route that gives Claude
a real status, `HARNESS_ROLE` reaching an `hc` child, a worker that edits files,
`blocked` handling, `hc wait --children` with agents, templates, `--on` machines, and the
app displaying these terminals. The candidate purpose (move the whole procedure from the
TUI to `hc`) stays with the User. Nothing is committed or pushed.
