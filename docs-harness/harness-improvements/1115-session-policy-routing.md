# Harness Improvement Resource

ID: #059_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Route session policy through the Harness index
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/SESSION.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- docs-harness/project-constraints/1115-unit-test-authority.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- .agents/skills/improve-harness/SKILL.md

## Objective

Reduce `AGENTS.md` to an entry pointer and move its existing rules into
`docs-harness/`, with mandatory retrieval in every session.

## Purposes

- [x] Keep `AGENTS.md` focused on routing agents into the Harness index.
- [x] Preserve session role, operation authority, evidence, documentation,
  completion and project-constraint behavior after moving their policy owner.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at `f91a31f`, one commit
ahead of `origin/main`. The 101-line `AGENTS.md` directly owns session role,
task authority, judgment, documentation and completion. The User requested a
smaller pointer and explicit per-session retrieval of the same rules.

The worktree already contains completed but uncommitted improvement `#057`
and active project constraint `#058`, including changes to `AGENTS.md`, INDEX,
workflow, guides and the dormant Jev hook. Preserve that work and the unit-test
authority rule. The unindexed `#012` plan is pre-existing unrelated drift.

## Proposed Improvement

Move the current rules into one always-read Harness session policy, route it
unconditionally from INDEX immediately after entry, and keep `AGENTS.md` as a
short pointer. Update direct references to the former policy owner without
rewriting historical records or user-owned raw requirements.

Hypothesis: a fresh session reads the complete transferred policy before task
work, and a worker retains its delegated role and authority boundaries.
Contrary evidence includes a skipped policy, lost rule, stale live owner
reference, or a circular session-start hook gate. INDEX and the session policy
are the maintenance owners; revisit if fresh-session evidence shows a rule is
not retrieved or the User changes the desired boundary.

## Scope

`AGENTS.md`, a session-policy file under `docs-harness/`, INDEX, the hook and
direct current Harness and skill consumers, plus this improvement record.
Preserve existing `#057`/`#058` intent and unrelated work. Do not change
user-owned `docs/raw-requirements/`, unrelated `docs/`, stage, commit, push,
write unit tests, or perform external actions.

## Progress

- 2026-11-15: Recorded the baseline before modifying policy or routing.
- Reduced `AGENTS.md` from 101 lines to an eight-line INDEX entry pointer.
  Created `SESSION.md` and made it the first mandatory document read after
  INDEX. Updated the hook exemption and active policy-owner references; kept
  the project-constraint route, `#057` record and `#058` rule.
- Compared the former `AGENTS.md` sections from Session role through
  Completion with the new session policy: all 5,476 characters matched after
  normalizing line endings. The entry section was adapted for its new location.
- A fresh worker loaded INDEX, SESSION, persona, layers, hook and project
  constraints, then reviewed the role and authority cases without writes. In a
  follow-up, it changed only an authorized fictional text fixture and verified
  it; the primary agent independently checked and removed the fixture file.

## Validation

Compare the transferred policy against the current `AGENTS.md`, inspect all
affected routes, links, IDs, metadata, direct owner references, skill mirrors,
and final diff. Use a fresh worker to exercise session retrieval, worker role,
task authority, and the unit-test constraint; keep external actions simulated.

Native inspection: the INDEX folder tree matches disk; 59 ID-bearing resources
have unique numeric sequences, with only the pre-existing `#012` unrouted.
Across 38 changed/new Markdown documents, 153 local links resolved. Seven
updated skill pairs have identical `.agents` and `.claude` hashes. The `#057`
record is byte-identical to baseline, and `#058` differs only in the policy
owner path. `git diff --check` passed with line-ending warnings.

The fresh worker reported that its initial AGENTS instructions were supplied
by the host; its first filesystem reads were INDEX and then SESSION. It also
loaded persona, layers, the dormant Jev hook, and both project-constraint
files. It identified itself as a worker and described the primary Bale role,
read-only behavior, local implementation authority, explicit stage/commit
boundaries, and the distinction between writing and running unit tests. It
correctly reported the pause behavior for an unreadable mandatory policy.

The coordinator then delegated one User-authorized disposable fixture edit:
the worker changed `status: pending` to `status: done` in a two-line text
file, verified both lines, and changed no other path. The primary agent
confirmed that the temporary directory contained only that fixture and then
removed it. No unit tests were written or run, and no external action occurred.
This covers one delegated worker and simulated authority choices; a fresh
primary session and an enabled Jev hook were not exercised.

## Risks

- A fresh agent could skip the transferred policy. Mitigation: require it at
  the start of INDEX and verify the actual files read in a fresh session.
- Moving authority could leave stale references or weaken a boundary.
  Mitigation: compare every prior rule and update current direct consumers.
- The enabled Jev hook could gate its own policy retrieval. Mitigation: keep
  session-policy loading in the hook's session-start exemption.
- Team-facing `docs/tools/claude/README.md` and `docs/tools/opencode/README.md`
  still describe `AGENTS.md` as the role or authority owner. They are outside
  the requested documentation scope. Proposed follow-up: update those direct
  references to `docs-harness/SESSION.md` when those guides are in scope.
- Existing `#012` remains unindexed. Proposed follow-up: review the resource's
  provenance before restoring a route or recording an exception.

## Decision and Result

Decision: keep. The mandatory INDEX route, transferred policy, native checks,
and fresh bounded worker replay support the requested behavior. The replay
does not establish that every host will load the policy or prove the untested
fresh-primary and enabled-hook cases.
