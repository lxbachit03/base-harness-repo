# Harness Improvement Resource

ID: #089_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add UBIQUITOUS-LANGUAGES.md, a shared glossary for the User, agents and the Harness repo
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/INDEX.md
- docs-harness/UBIQUITOUS-LANGUAGES.md
- docs-harness/HERDR-APP.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md

## Objective

`docs-harness/UBIQUITOUS-LANGUAGES.md` exists, defines the shorthand and project terms the
User, agents and the Harness files use (for example HDA = Herdr Desktop App), and is routed
from `docs-harness/INDEX.md`, so an agent resolves a User's term from one place.

## Purposes

- [x] Give the User, the agents and the Harness repo one shared vocabulary, as the User asked
  on 2026-11-21 ("ngon ngu chung", for example HAD = Herdr App Desktop).
- [x] Stop agents guessing at shorthand: the User writes HDA and HAD for the Herdr desktop
  app and "pane" for what the app calls a space; the INDEX already asks which Herdr is
  meant when only "Herdr" is named.
- [ ] Candidate, awaiting the User: more terms as the User names them; a term the User
  defines is added by an improvement record.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `3d345a3` (ahead of
`origin/main` by 3), working tree clean; `harness-check` clean at 88 IDs.

Request: the User asked (through `/improve-harness`) for a file holding the shared language
and for it to be added to `INDEX.md`.

Evidence of the gap: in this repository's own sessions the User named the Herdr desktop app
"HDA", "HAD" and "Herdr App Desktop", called the app's spaces "panes", and used short
confirmations such as "Chay ngay" (run now) and "Da xu ly" (I answered the dialog). No file
defines these; the nearest rule is the INDEX line that asks which Herdr is meant.

## Proposed Improvement

1. Create `docs-harness/UBIQUITOUS-LANGUAGES.md`: a lookup table of terms with a meaning and
   the owner file, grouped by Herdr and agents, Harness structure, work flow, and the User's
   short replies; plus the rule for adding a term and for a conflict.
2. Route it from the Root Routing resources of `INDEX.md` as a lookup, read when a User's
   word or abbreviation is not defined in a loaded document, not at every session start, so
   it adds no start-up cost.

## Scope

May change: `UBIQUITOUS-LANGUAGES.md` (new), `INDEX.md` (one resource line), this record and
its list line. Unchanged: the terms' owner files, constraints, skills, the User's raw
requirements. Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edit; request and evidence above.
- 2026-11-21: Wrote `UBIQUITOUS-LANGUAGES.md` (three tables: Herdr and agents, Harness
  structure, the User's short replies; maintenance rules) and added one resource line after
  `PERSONA.md` in the Root Routing of `INDEX.md`. A pipe inside a table cell was fixed and the
  Vietnamese phrases given their diacritics. Nothing is committed or pushed.
- 2026-11-21: The User corrected the "pane" row: "pane" is a generic word for both the HDA and
  the TUI, so it takes the meaning of the Herdr the User is currently asking for. Rewrote the
  row that way (HDA: space or terminal; TUI: a TUI pane; ask when neither is named). Same
  intervention, so this record continues; `harness-check` rerun. Not replayed again.

## Validation

Native check: `harness-check` clean at 89 IDs (index entries, 1084 local links including every
owner link of the file, skill mirror).

Fresh replay, 2026-11-21: `claude -p --model claude-haiku-5-5` with Read, Glob and Grep only,
outside Herdr. Prompt in Vietnamese: the User says "delete the old `agy-` panes in HAD, then
run it now"; say in 3 to 4 lines what HAD, pane and "run it now" mean and do nothing. The agent
cited `UBIQUITOUS-LANGUAGES.md` and `HERDR-APP.md`, read HAD as the Herdr App Desktop driven by
`herdr-app`, read "pane" as a space named `agy-...` and not a TUI pane, limited "run it now" to
the step just proposed, said it would list the spaces and confirm "old" before closing, and
changed nothing. The prompt named the terms, so this shows the file is findable and read
correctly, not that an agent opens it unprompted.

Not run: a session that meets an unknown term without any hint, and the file's reading cost
at scale (it is about 60 lines).

## Risks

- The glossary drifts from its owners. Mitigation: each entry names the owner file and keeps
  one line; the owner stays the authority.
- Invented meanings. Mitigation: only terms evidenced in the repository or the User's words
  are listed; a guess is marked unverified.

## Decision and Result

Decision: keep. The file was available (routed from the INDEX), retrieved and exercised by a
fresh agent, which resolved HAD, pane and "run it now" from it and from the owner file. It
adds no session-start cost because the INDEX routes it as a lookup.

Observed, not changed: the INDEX line asks the reader to open the file only when a term is not
defined in a loaded document, so whether an agent opens it unprompted depends on that
judgment. Add terms through further records. Nothing is pushed.
