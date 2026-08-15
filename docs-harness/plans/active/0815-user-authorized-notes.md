# Harness Improvement Resource

ID: #005_IMPROVE_HARNESS_0815
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add a User-authorized notes workspace
CREATED: 2026-08-15
STATUS: active
REFERENCES:
- .agents/skills/goal-griller/SKILL.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- docs-harness/INDEX.md
- docs-harness/README.md
- docs-harness/notes/README.md
- docs-harness/notes/0815-harness-compatibility-gaps.md
- docs-harness/plans/README.md
- docs-harness/WORKFLOW.md

## Objective

Give the Harness a routed, low-overhead place to retain context that the User
explicitly authorizes, including observed gaps and follow-up boundaries,
without turning notes into a second authority or control plane.

## Current State

Baseline:

- Repository root: `/Users/bale/Documents/Repositories/test-repo/test_custom_harness`
- Revision: `e2c64488c7b770001ec25317d3ffd7ead6ea9d3f`
- Branch: `test/take-note`
- Initial worktree: clean.
- `docs-harness/notes/` did not exist.

Observed friction from the compatibility review: the Harness could report
gaps, but had no canonical, User-authorized place to retain those observations
and distinguish them from accepted policy, proposals, or completed work.

## Proposed Improvement

If `docs-harness/notes/` has a routed README defining User authority,
promotion boundaries, and a concise note format, then a fresh agent will be
able to retrieve authorized gap context without treating a note as accepted
policy, because the folder has one explicit owner and canonical promotion
rules.

Evidence that would weaken this:

- A fresh task cannot discover relevant notes through `AGENTS.md` →
  `docs-harness/INDEX.md`.
- The agent treats a suggested follow-up as approved work.
- Notes duplicate or compete with canonical risks, proposals, decisions,
  plans, or tickets.
- The notes contract adds enough context or ceremony to harm unrelated tasks.

Maintenance owner and removal condition:

- Owner: repository Harness maintainers.
- Revise or remove the workspace if fresh reruns show authority confusion,
  duplicate sources of truth, stale notes, or unnecessary context load.

## Scope

In scope:

- `docs-harness/notes/README.md` and the initial User-authorized gap note.
- `docs-harness/INDEX.md`, `docs-harness/README.md`, and the active-plan list
  needed to route the workspace.
- This active improvement record and native consistency validation.

Out of scope:

- Applying any suggested validator or ticket-lifecycle follow-up.
- Changing product behavior, `AGENTS.md`, skills, the Harness binary, or the
  SQLite compatibility surface.
- Replacing canonical risks, proposals, decisions, plans, constraints, or
  tickets with notes.
- Moving this record to `plans/completed/` before a fresh rerun and decision.

## Validation

During work:

- Verify the new folder and all routed links exist.
- Verify the note states User authority, observed facts, suggestions, and the
  resolution boundary separately.
- Preserve the `AGENTS.md` → `docs-harness/INDEX.md` entry order and existing
  active/completed lifecycle.

Final proof:

- Inspect the diff and run `git diff --check`.
- Check the folder tree, INDEX section, links, and duplicate resource IDs.
- Run a fresh equivalent prompt that asks for a prior User-authorized gap and
  confirm the agent retrieves the note without treating its suggestions as
  approval.
- Record the comparison and choose `keep`, `revise`, or `remove` before moving
  this record to `plans/completed/`.

## Native Validation Result

- `git diff --check`: pass.
- The notes folder, README, initial note, active improvement record, and all
  INDEX/README plan-routing paths exist.
- The new `#005_IMPROVE_HARNESS_0815` identifier is unique among real resource
  IDs.
- Fresh equivalent rerun: not performed in this session; decision remains
  `pending fresh rerun`.

## Risks

Notes could become a second source of truth or be mistaken for authority.
Proposal: keep the README's canonical-promotion and suggestion-only rules,
and require a separate User authorization before applying any follow-up.

Notes could add context load to ordinary prompts. Proposal: route the folder
only for tasks with an explicit dependency on User-authorized notes and keep
the note files concise.

## Current Decision

Decision: pending fresh rerun.

The workspace and initial note are implemented and native consistency checks
pass. Do not claim that the Harness improved or move this record to
`plans/completed/` until a fresh equivalent session exercises the route and
records the comparison.
