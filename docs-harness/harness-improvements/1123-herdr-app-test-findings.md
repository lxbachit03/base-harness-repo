# Harness Improvement Resource

ID: #092_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add three findings from a live Herdr desktop app test to HERDR-APP.md
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- docs-harness/HERDR-APP.md
- docs-harness/harness-improvements/1121-herdr-app-visible-worker.md
- docs-harness/harness-improvements/1121-herdr-app-skip-permissions.md

## Objective

HERDR-APP.md tells the orchestrating session, before it starts an `agy` worker through the
Herdr desktop app, about three things a live test met: the folder-trust dialog on the first
launch in a folder, the Claude Code auto mode refusal of a launch with
`--dangerously-skip-permissions`, and the sentence a Skip-context brief needs so that the
worker does not pause on the `AGENTS.md` INDEX rule.

## Purposes

- [x] Spare the User a test round that stops on a dialog or a refusal the guide could have
  predicted; the User asked on 2026-11-23 to record the findings after the test.
- [x] Make the Skip Harness-context choice work in one worker turn instead of two.

## Current State

Baseline: repository `E:\personal\base-harness-repo`, branch `main`, revision `0321745`,
clean worktree. Request: "tôi mới cài HAD, hãy test thử điều phối thử" (Claude Opus 5.5 in
the Claude desktop app, `hc 0.1.22`, `agy` 1.5.14, model `gemini-4-hydrogen-high`, task:
read `docs-harness/PERSONA.md` and report the selected persona, no file written).

Observed on 2026-11-23:

1. `herdr-app do space.new ... --argv '["agy", ..., "--dangerously-skip-permissions"]'` was
   denied by the Claude Code auto mode classifier ("Undermining Oversight"). With the User's
   permission mode set to Bypass permissions, the same command ran (space
   `harness-test-skip`, terminal `t3`).
2. The first `agy` start in the repository (terminal `t2`, `--mode plan`) stopped at "Do you
   trust the contents of this project?"; `hc wait` returned `status: blocked`. After the User
   answered Yes in the app, the worker went `idle`; the later start in `t3` showed no dialog.
3. A brief that only said "Do not read AGENTS.md or docs-harness/INDEX.md" made the worker
   pause: `agy` had `AGENTS.md` as memory, and its rule requires the INDEX first. A
   follow-up quoting the User's choice to skip the INDEX unblocked it (28.7k tokens, two
   turns). A brief that stated the User's override from the start finished in one turn
   (16.4k tokens), correct answer, `git status` clean.

HERDR-APP.md mentioned none of the three. One run each; no claim about other models.

## Proposed Improvement

Edit HERDR-APP.md section 3 (the Skip context option and the Skip permission choice) and
section 5 step 3 (the trust dialog), and record the 2026-11-23 run in the section 5 note.

## Scope

Only HERDR-APP.md and this record with its list entry. HERDR-TUI.md, the glossary and the
choices' marks stay as they are.

## Progress

2026-11-23: record created, then HERDR-APP.md edited: section 3 Skip context option (the
override sentence), section 3 after the permission choice (host permission mode and the
auto mode refusal), section 5 step 3 (trust question), and a 2026-11-23 run note.
`harness_check.py` full run: `RESULT: clean (exit 0)`, 92 IDs, 1103 links. Diff limited to
HERDR-APP.md, this record and its list entry.

## Validation

`harness_check.py` full run, diff review, and a fresh replay: a new session reads the edited
HERDR-APP.md and starts one Skip-context `agy` worker on the same read-only task.

## Risks

The auto mode classifier's behavior may change between Claude Code releases; the note says
when it was observed, and the binary and the host stay the authority.

## Decision and Result

Decision: keep.

Fresh replay on 2026-11-23: a new general-purpose Claude subagent, same host and Bypass
permissions, told only the User's request and choices and barred from
`harness-improvements/`, read AGENTS.md, INDEX and HERDR-APP.md and started an `agy`
worker (`gemini-4-hydrogen-high`, Skip permission flag) in a new space `harness-replay`,
terminal `t4`. Retrieved and exercised: its brief carried the User's INDEX override,
citing the new section 3 sentence; the worker answered in one turn (`status: done`,
`turn: 1`, 19.1k tokens), Default at `docs-harness/PERSONA.md:14`, no question asked. The
coordinator read `t4` itself and found the same answer; `git status` was unchanged.

Not exercised by the replay: the folder-trust question (the folder was already trusted)
and the auto mode refusal (the host ran in Bypass permissions). Both rest on the
original run's observation only. One run per case; no claim about other models or
releases.
