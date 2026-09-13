# Harness Improvement Resource

ID: #023_IMPROVE_HARNESS_0913
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Remove strict onboarding and audit skills
CREATED: 2026-09-13
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/README.md
- docs-harness/harness-improvements/0912-agent-self-validation.md
- docs-harness/plans/active/0906-behavior-parity-audit.md
- docs/tools/antigravity/README.md

## Objective

Remove the strict `onboard-repository` producer skill and its sibling
`audit-onboarding-proposal` auditor skill from the agent skill catalog, and
update every direct consumer so no live pointer remains.

## Current State

- Repository: `D:/repos/base-harness-repo`, branch `main`, revision
  `85fb4e51e261b162ce038ef2f0d5a5b0f9ac77c5`, clean worktree.
- `.agents/skills/onboard-repository/` and
  `.agents/skills/audit-onboarding-proposal/` are auto-discovered agent skills
  (9 files, about 108 KB). The pair implements a strict evidence-capsule and
  patch-admissibility protocol; `onboarding` remains the supported named-flow
  mapping skill.
- Prior friction: improvement #017 (2026-09-12) already reduced the helper
  scripts to explicit-User-authority-only use. `onboard-repository` step 5
  still requires piping the spec to `emit_evidence_bundle.py`, and the
  mandatory machine-emitted v2 bundle cannot be produced on a machine without
  Python; this machine has only the Windows Store execution stubs.
- Live references at decision time: `docs-harness/README.md` (installed-core
  list and invocation note), plan `#014` File Coverage rows, improvement #017
  REFERENCES, and `docs/tools/antigravity/README.md` skill catalog.
- User decision: on 2026-09-13 the User chose removal over keeping or
  temporarily disabling the pair, with the record and direct consumers updated
  in the same task.

## Proposed Improvement

Delete both skill directories, remove their current routing and documentation
pointers, and mark historical references as removed instead of rewriting past
evidence. Keep `onboarding` and `docs-harness/WORKFLOW.md` as the supported
routes. Record the lost capability and its Git-history recovery path.

## Scope

In scope:

- `.agents/skills/onboard-repository/` and
  `.agents/skills/audit-onboarding-proposal/`.
- `docs-harness/README.md` installed-core list and invocation note.
- Improvement #017 REFERENCES entries for the two skills.
- A dated continuation note in plan `#014` closing its P13 choice.
- `docs/tools/antigravity/README.md` repository-local skill catalog.
- This record and its INDEX entry.

Out of scope:

- The `onboarding` skill, `AGENTS.md` authority rules, and WORKFLOW policy.
- The upstream installer/Rust repository and `.harness-core` history.
- Commits, pushes, or other unrelated files.

## Progress

- 2026-09-13: Baseline captured, live references mapped, this record created
  before intervention edits, and the User removal decision recorded.
- 2026-09-13: Deleted both skill directories and removed their current pointers
  in `docs-harness/README.md`, improvement #017, plan #014,
  `docs/tools/antigravity/README.md`, and `utilizing-tools-agy/SKILL.md`; then
  indexed this record.

## Validation

- Manual inspection: both skill directories are absent and `.agents/skills/`
  retains its 13 remaining skill directories.
- Repository-wide tracked-file scan for both skill names after deletion:
  remaining mentions are only the labeled historical entries in improvement
  #017, plan #014, and this record; no live operational pointer remains.
- `docs-harness/INDEX.md` routes this record and the linked file exists.
- `git diff --check` exited 0; Git emitted only its normal LF/CRLF conversion
  warnings for touched files.
- No Harness validation script was created or invoked.

## Risks

- Capability loss: no strict evidence-bundle onboarding or patch-audit path
  remains. Proposal: use `onboarding` plus WORKFLOW; restore the pair from Git
  history at the baseline revision only if a concrete need appears.
- Stale pointers: consumers may still reference a deleted skill. Proposal: a
  repository-wide manual scan for both names after deletion; only historical,
  labeled mentions may remain.
- Upstream install drift: if the upstream installer still ships these skills, a
  future install can recreate them. This is a known unknown; reconcile only if
  an install occurs.

## Decision and Result

Implementation complete; fresh replay pending. Replay task: a fresh agent
session asked to run the strict onboarding or audit protocol should report the
skill unavailable and route to `onboarding`/WORKFLOW without dangling
pointers. Owner: main agent when a fresh session is available.
