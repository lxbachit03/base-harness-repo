# Harness Improvement Resource

ID: #084_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Split the Herdr instructions into HERDR-TUI.md (TUI) and HERDR-APP.md (desktop app and hc)
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/HERDR-TUI.md
- docs-harness/HERDR-APP.md
- docs-harness/INDEX.md
- docs-harness/harness-improvements/1121-herdr-orchestration-instructions.md
- docs-harness/harness-improvements/1121-herdr-app-hc-orchestration.md

## Objective

The Herdr TUI instructions and the Herdr desktop app instructions live in two files, so a
session loads only the way the User chose: `docs-harness/HERDR-TUI.md` covers the terminal app
(`herdr`) and the new `docs-harness/HERDR-APP.md` covers the desktop app and `hc`
(herdr-core). INDEX routes each one by what the User names in the prompt; a bare "Herdr"
gets one question.

## Purposes

- [x] Let the User choose between the two ways and have the session use only that file, as
  the User asked on 2026-11-21.
- [x] Keep each file self-contained, so reading one never requires the other.
- [x] Name the TUI file `HERDR-TUI.md` and drop the default checkbox for a bare "Herdr",
  because the User names the way in the prompt, as the User asked on 2026-11-21.
- [ ] Candidate, awaiting the User: a Herdr-wide shared section for the pieces both ways
  repeat (the Gemini checklist, the Harness context checkbox), if keeping two copies in step
  becomes a burden.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `7ae1018`, with the
uncommitted `HERDR-TUI.md` (TUI sections 1 to 5, an `hc` section 6, Safety as 7), its INDEX route
and records `#082` and `#083`; `harness-check` clean at 83 IDs.

Request: the User asked for a separate `HERDR-APP.md` in `docs-harness/` that holds the
Herdr desktop app instructions apart from the TUI ones, so the file the User picks is the
file used.

Evidence: `#083` found the three programs (`herdr` TUI, `herdr-app`, `hc`), that the app's
and the TUI's agents cannot see each other, and tested the `hc` procedure now in
`HERDR-TUI.md` section 6 (agy completes with `hc send --wait`, Claude Code with
`hc wait --output <marker>`).

## Proposed Improvement

1. Create `HERDR-APP.md` from the `hc` procedure of `HERDR-TUI.md` section 6 plus the app
   basics, with its own Gemini checklist and Harness context checkbox, independent of the
   TUI file's.
2. Cut the `hc` section and the three-programs note out of `HERDR-TUI.md`; keep a pointer to
   `HERDR-APP.md` and add a checkbox for what a bare "Herdr" means (default: the TUI;
   dropped again the same day, see Progress).
3. Route both files in INDEX with their own Read when.

## Scope

May change: the new `HERDR-APP.md`, `HERDR-TUI.md`, the Herdr entry of INDEX, this record and its
list line. Unchanged: the TUI procedure and its checklists, the `hc` procedure's content
(moved, with the app basics added), the other constraints and instruction files. Records
`#082` and `#083` cite `HERDR-TUI.md` by its earlier section numbers and stay historical.
Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edits; baseline as above.
- 2026-11-21: Created `HERDR-APP.md` (app basics, gate, choices, orchestration through `hc`,
  safety), cut the `hc` section and the three-programs note out of `HERDR-TUI.md` (now TUI only,
  with a pointer and a checkbox for what a bare "Herdr" means), and routed both files in
  INDEX. Nothing is committed or pushed.
- 2026-11-21: The User asked to rename `HERDR.md` to `HERDR-TUI.md`, kept for the Herdr TUI
  alone, and to leave the choice of way to the prompt. Plan: rename the file, delete its
  "which Herdr" checkbox, make INDEX route by the words the User uses (a bare "Herdr" gets
  one question), update the other references and the records' mentions of the old name.
  Nothing is committed or pushed.
- 2026-11-21: Renamed the file, removed the checkbox, changed the INDEX entry of the TUI
  file to ask one question for a bare "Herdr", and replaced the old name in `HERDR-APP.md`,
  INDEX, the improvements list and records `#082` to `#084`. Earlier lines of these records
  now use the new name for the file that was then called `HERDR.md`.
- 2026-11-21: Ran the routing replay (four fresh Sonnet 5.5 sessions, see Validation) and
  closed the record. Nothing is committed or pushed.

## Validation

Native check: `harness-check` run after the split: clean at 84 IDs, 1048 local links in 184
Markdown files, INDEX route present, CRLF kept; rerun after the rename (see the final report
of the change).

Read-through of the result:
- `HERDR-TUI.md` (238 lines) holds the TUI only: the gate with the own-session switch, the
  model, the orchestration steps with the Harness context checkbox, ordinary commands, the
  `agy` worker with the Gemini checklist, and Safety (now section 6). No `hc` command is
  left in it; the only mention of the other program is the pointer (the checkbox for a
  bare "Herdr" was removed in the rename step).
- `HERDR-APP.md` (157 lines) holds the desktop app basics, the `hc` gate, its own Harness
  context checkbox and Gemini checklist (marked as independent of the TUI file's), the
  orchestration steps moved from the old section 6 with the brief and review rules added so
  it needs no other file, and Safety. Its only link out is to `HERDR-TUI.md` as the other way
  and to `#074`.
- The section numbers that records `#082` and `#083` cite for `HERDR-TUI.md` refer to the file
  before the split and stay historical.

Routing replay, 2026-11-21: four fresh `claude -p` sessions (Sonnet 5.5, Read, Glob, Grep
and Bash allowed, in parallel) at revision `7ae1018` plus the uncommitted change set. Each
got one Vietnamese prompt asking to give a small read-only task (count the files under
"Instruction files" in `docs-harness/claude-instructions/README.md`) to another agent and
report. `HERDR_ENV` and the pane variables were unset, and `HERDR_SESSION`, `HC_SESSION`
and `HERDR_APP_HOME` pointed at throwaway targets that do not exist, so no action could
reach the User's Herdr session, core or window (checked unchanged afterwards).
- "Dùng Herdr TUI ...": read the INDEX and `HERDR-TUI.md` and never `HERDR-APP.md`; stopped
  at the gate (`HERDR_ENV` empty, the own-session switch `[ ]`), offered the two ways out
  (start Herdr and run the agent in a pane, or mark the switch), and named the Gemini
  model and Harness context choices to settle first. No Herdr command was run.
- "Dùng Herdr desktop app ...": read the INDEX and `HERDR-APP.md` and never
  `HERDR-TUI.md`; ran `hc server status` through the full `hc.exe` path (the throwaway core
  was unreachable), stopped at the gate without starting a core, told the User to open the
  app or run `hc server start`, and listed the choices to settle (agent kind, the marked
  Gemini model, Harness context, write permission), suggesting Skip.
- "Dùng hc ...": the same route as the app case through `HERDR-APP.md`; it explained why it
  called `hc.exe` by full path and stopped at the same gate.
- "Dùng Herdr ..." alone: read neither Herdr file; after the session-start reads it asked
  one question, "Herdr TUI or Herdr desktop app", as the INDEX entry says, and promised to
  read the matching file after the answer.
All four also did the session-start retrieval and counted the four files themselves while
preparing, which the task allowed. Cost across the four: about 137k cache-creation and 783k
cache-read tokens over 53 turns.

## Risks

- Two copies of the Gemini checklist and the Harness context checkbox can drift. Mitigation:
  each file states its choices are its own, so a difference is a legitimate selection.
- A session may read the wrong file for a bare "Herdr". Mitigation: the INDEX routes by the
  words the User uses and tells a session to ask one question when the User names only
  "Herdr".

## Decision and Result

Decision: keep. `HERDR-TUI.md` and `HERDR-APP.md` were available, retrieved by the words the
User used, and exercised up to each file's gate in all four cases: the TUI wording read only
the TUI file, the app and `hc` wordings read only the app file, and a bare "Herdr" read
neither and asked which way. The earlier replays of `#082` (TUI procedure) and `#083` (`hc`
procedure) still describe what each file does after its gate.

Observed, not changed here: every case spent most of its tokens on the session-start
retrieval, not on Herdr; a case that stopped at the gate still counted the files itself.

Remaining proof, not required: the same four prompts after the User answers the question and
the checkboxes, running to a finished worker result in each way. Nothing is committed or
pushed.
