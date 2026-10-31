# Harness Improvement Resource

ID: #050_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Retire three Jev helper scripts
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/JEV-AI.md
- docs-harness/WORKFLOW.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/
- .agents/skills/typesafe-ai/tests/reliability-check.ps1
- .agents/skills/utilizing-tools-agy/SKILL.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/utilizing-tools-codex/SKILL.md
- .agents/skills/utilizing-tools-opencode/SKILL.md
- .claude/skills/typesafe-ai/

## Objective

Remove the Jev authority-precheck, ticket-triage, and domain-freshness helpers
and update their current direct consumers and mirrors without disturbing the
remaining TypeSafe integration or the User's authority policy.

## Purposes

- [x] Stop maintaining the three helper capabilities the User no longer needs.
- [x] Keep current instructions and validation aligned with the remaining Jev
  components.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, HEAD `1a72228`.
The tracked worktree is clean. The pre-existing untracked file
`docs-harness/plans/completed/0902-evidence-backed-domain-freshness.md` is
outside scope and is preserved.

The three named scripts exist under `.agents/skills/typesafe-ai/scripts/`
and have `.claude` mirrors. The manifest, skill documents, and offline runner
refer to them. The active `jev-hook` currently invokes the authority helper
for shell actions. The User requested removing the three helpers; the desired
hook behavior after removal is being clarified separately.

## Proposed Improvement

Retire the named scripts and their executable consumers. Remove current
guidance that promises those capabilities while keeping historic improvement
records as historical evidence. Update `JEV-AI.md` before the scripts.
Hypothesis: removing active references and relevant tests with the helpers
will leave the retained transport and router usable. The active hook dependency
is contrary evidence until its behavior is resolved. The skill and manifest
remain maintenance owners; revisit the change if requested functionality is
reintroduced.

## Scope

The three named scripts and direct mirrors, current `typesafe-ai` skill and
manifest references, their utilizing-tools routing descriptions, focused test
runner, any hook change the User selects, INDEX route and this record. Preserve
existing Git state and unrelated work;
do not stage, commit, push, or change `docs/raw-requirements/`.

## Progress

- 2026-10-31: Inspected the scripts' active references and preserved the
  baseline before intervention. Asked the User how the active hook should
  operate after its shell helper is removed.
- 2026-10-31: The User selected disabling automatic `jev-hook` consultation.
  Updated the manifest before retiring the helpers. The dormant optional hook
  uses the generic helper for all groups if the User enables it later.
- Removed the three named helpers and their `.claude` mirrors. Updated the
  skill documents and offline runner, removing only tests for retired helpers.
- The first fresh replay found four utilizing-tools skills and mirrors still
  advertising Jev ticket triage. Removed that stale routing label while
  retaining the route to the generic TypeSafe helper; the affected replay
  subsequently passed.

## Validation

Inspect the affected active references and links, verify both skill trees are
identical, run the remaining offline checks on PowerShell 7 and 5.1, and run a
live synthetic consult for retained Jev functionality where relevant. Exercise
the changed instructions in a fresh bounded agent session.

2026-10-31 native proof: 21/21 remaining offline checks passed in both skill
trees on PowerShell 7 and Windows PowerShell 5.1; all six remaining PowerShell
scripts parse. The seven files in each TypeSafe tree match byte-for-byte.
Targeted live links and current references were inspected: no active reference
to a retired helper remains, and `git diff --check` passes. A separate live
synthetic Noul request to the retained transport succeeded in 483 ms with
`jev-1.14.0` and `Fallback=false`. This was an explicit verification call,
not an automatically triggered hook consult.

Initial fresh replay: a delegated read-only agent loaded the applicable
instructions, observed the unchecked hook, ran `git status` without a Jev
consult, confirmed AGENTS.md authority, and passed 21/21 mocked checks in both
skill trees. It found the stale utilizing-tools labels noted above; those were
revised. Its focused rerun confirmed all eight routing files omit that label,
still point to the existing helper, and match their mirrors. The worker found
no active references to retired helpers or broken inspected local links, made
no live Jev calls, and asked no repeated User questions. External links were
outside the replay.

## Risks

- The optional hook no longer has the retired shell helper's deterministic
  boundary checks. Mitigation: leave the hook disabled as requested and apply
  AGENTS.md authority independently even if it is enabled again later.
- User-owned raw requirements or historical records may still describe former
  behavior. Mitigation: preserve historical evidence and propose any exact raw
  requirement changes to the User instead of editing those files. In
  `docs/raw-requirements/jev-ai/jev-ai.json`, requirement 4 still describes
  automatic activation when the User names Jev; propose replacing it with an
  optional, checkbox-controlled hook and on-demand Jev usage.

## Decision and Result

Keep the removal. The named helpers and mirrors are absent, their current
consumers were updated, the hook is unchecked, and the retained transport and
router passed the focused checks and fresh replay. Historical records remain
as evidence, and no production performance claim is made.
