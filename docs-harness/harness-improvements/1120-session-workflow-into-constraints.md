# Harness Improvement Resource

ID: #073_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Move SESSION.md and WORKFLOW.md into trimmed harness-constraints and delete both files
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- docs-harness/INDEX.md
- docs-harness/harness-constraints/README.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/harness-constraints/1120-work-shape-proof-completion.md
- docs-harness/harness-improvements/1115-session-policy-routing.md

## Objective

The rules of `docs-harness/SESSION.md` and `docs-harness/WORKFLOW.md`, trimmed, live
as three constraints under `docs-harness/harness-constraints/`, and the two files
are gone. Task authority is `#009` (the existing resource, now holding the policy
itself), the session role, judgment and documentation ownership are `#074`, and the
work shape, proof and completion are `#075`. `docs-harness/INDEX.md` has every
session read `#009` and `#074` at session start, where it used to have it read
`SESSION.md`; `#075` is read before a change or a report. Live guidance that named either file names the new owner.

## Purposes

- [x] Optimize the two files and keep their rules as constraints, as the User asked
  on 2026-11-20.
- [ ] Candidate, awaiting the User: the session-start read stays about as small as
  before. Only `#009` and `#074` load at session start (6,083 characters against
  5,747 for `SESSION.md`); `#075` loads before a change or a report, as
  `WORKFLOW.md` did.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `70578c1`. The tree
holds uncommitted work from earlier in this session (#071, #072 and their
`AGENTS.md` sections) and the untracked `.claude/settings.local.json`.
`harness-check` clean at 72 IDs before this change.

Request: during a `/doctor` run the User wrote, in Vietnamese, that they want to
optimize the two files, add their rules to `harness-constraints`, and then delete
the two files from `docs-harness`. Before that, a read-only question showed what
deleting them would break: INDEX makes `SESSION.md` a mandatory session-start read
and pauses work if it cannot be read, and 26 live files plus 41 historical records
name one of the two.

`SESSION.md` is 100 lines (role, task authority, evidence and judgment, working
memory and documentation, completion) and `WORKFLOW.md` is 83 lines (work shape,
execute a change, proof, completion). `harness-constraints/` is read only when a
task touches a constrained path, so moving the rules there changes what loads at
session start unless INDEX names them.

## Proposed Improvement

1. `#009`: replace the pointer with the Task authority policy, trimmed.
2. `#074` (new): session role, evidence and judgment, documentation ownership.
3. `#075` (new): work shape, execute a change, proof, completion, with the stale
   SQLite sentence dropped; read on demand, not at session start.
4. `harness-constraints/README.md`: a section that lists the two session-start
   constraints and the on-demand one.
5. `INDEX.md`: session retrieval links `#009` and `#074`; routes and the
   self-review link point at the new owners.
6. Replace every live reference to the two files, in both skill mirrors, and refresh
   the derived `docs/tools/claude/README.html`.
7. Delete `docs-harness/SESSION.md` and `docs-harness/WORKFLOW.md`.

## Scope

May change: the files above and the live files that name either deleted file.
Unchanged: the 41 historical plan, record and ticket files that name the old paths
(they keep the paths of their time, recoverable at revision `70578c1`),
`docs/raw-requirements/`, `PERSONA.md`, `project-constraints/` rules, and the
meaning of every rule moved. Nothing is committed or pushed.

## Progress

- 2026-11-20: Record opened before the edits; baseline taken as above.
- 2026-11-20: Rewrote `#009` as the trimmed policy; added `#074` and `#075`; updated
  `harness-constraints/README.md`, `INDEX.md`, the root and `docs-harness` READMEs,
  26 live files that named the old paths (7 skills in both mirrors, the Jev manifest
  and hook, two layer add-ons, templates, ticket and onboarding READMEs, the claude
  catalog and its `README.html` with its source SHA-256); deleted `SESSION.md` and
  `WORKFLOW.md` from the working tree. Nothing is committed or pushed.
- 2026-11-20: Size check after the first draft showed `#075` (4.6k characters) would
  have made the session-start read twice the old one, so `#075` became an on-demand
  read and `#009` and `#074` were trimmed.

## Validation

Results, 2026-11-20:
- `harness-check` full and `--quick`: clean (75 unique IDs #001-#075, 70 INDEX links,
  1019 links in 169 Markdown files, 20 skills and 70 files identical).
- Search of the working tree for `SESSION.md` and `WORKFLOW.md`, excluding `plans/`
  and `harness-improvements/`: hits only in the "moved from" notes of `#009`, `#074`
  and `#075`.
- Characters read at session start: `#009` 3,344 + `#074` 2,739 = 6,083, against
  5,747 for the old `SESSION.md`. Before-change read: `#075` 4,628 against
  4,417 for `WORKFLOW.md`.
- `README.html` source SHA-256 equals the hash of `README.md` with CRLF as LF.

Unattempted: a fresh session that starts from `AGENTS.md` and finds the rules (see
Decision); a line-by-line comparison of each moved rule with the deleted text beyond
the author's own pass.

## Risks

- A session that does not read the three constraints loses the task-authority rules.
  Mitigation: INDEX session retrieval names them, and `harness-check` checks that the
  INDEX links resolve.
- A reference missed in a live file points at a deleted path. Mitigation: a search of
  the working tree for both names, excluding the historical files.
- The 41 historical files still name the old paths. Mitigation: this record states
  where the files live in history; they are not rewritten.

## Decision and Result

Decision: pending fresh rerun. The edits are the implementation; that a new session
reaches `#009` and `#074` from `AGENTS.md` through INDEX is unverified.

Replay task: in a new session, ask for a read-only review and then a local edit
request; expect the session to name `#009` and `#074` at start, treat the review as
read-only and the edit as authorized. Owner: the next primary session or the User.
Cost: about 100k tokens, no build; it leaves the worker role and the on-demand `#075`
read uncovered.
