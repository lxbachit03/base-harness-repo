# Harness Improvement Resource

ID: #060_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Name onboarding E2E and activity step files
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- .agents/skills/onboarding/SKILL.md
- .claude/skills/onboarding/SKILL.md
- docs-harness/onboarding/README.md
- docs-harness/harness-improvements/1031-onboarding-step-flows.md
- docs-harness/INDEX.md

## Objective

Have onboarding create a separate E2E overview and `s1-`, `s2-`, and later
activity files for a named flow, following the User's screenshot example.

## Purposes

- [x] Make the E2E overview and each ordered step easy to find together.
- [x] Retain the source-backed explanations, diagrams, API responses, and
  database outcomes introduced by improvement `#054`.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at `02758ac`, clean
worktree, two commits ahead of `origin/main`. The onboarding workspace guide
puts the E2E overview in the flow README and illustrates step filenames using
`01-` and `02-`. The User requested a separate overview and step names like
`s1-...-activity.md`, as shown in the supplied screenshot. The onboarding
folder currently contains only its guide, so no real flow needs migration.
Both skill copies match. The Jev hook is disabled; the existing `#012` routing
drift predates this task.

## Proposed Improvement

Keep the existing onboarding workspace location. Place `e2e-<flow-name>.md`
and `s<N>-<step-name>-activity.md` files together under its `flows/` folder.
Keep the workspace README as an entry point, preserve `#054` evidence and
uncertainty rules, and avoid silently overwriting or renaming existing work.

Hypothesis: a fresh agent following the updated skill creates a linked overview
and correctly ordered activity files without losing step evidence or inventing
outcomes. Contrary evidence would be a missing overview, wrong numbering,
uncited claims, destructive migration, or misleading API/database details.
The onboarding workspace guide owns the layout; revisit it if a fresh scenario
fails or the User changes the desired convention.

## Scope

The onboarding workspace guide, both onboarding skill copies, INDEX, and this
record. Preserve existing task data and user-owned raw requirements. This is a
Harness improvement, not a request to onboard a real flow, query live systems,
write unit tests, stage, commit, or push.

## Progress

- 2026-11-15: Recorded the baseline and intended change before editing the
  skill, workspace guide, or routing.
- Updated both skill copies and the workspace guide for a separate E2E file,
  numbered activity files, numeric ordering and non-destructive legacy reuse.
  The previous step evidence and uncertainty contract was preserved. Started a
  fresh fictional replay with new and legacy workspaces in a task-owned
  temporary directory.
- The first worker identified the requested names in a read-only scenario and
  generated a fictional new workspace. Review found that its diagrams described
  a falsey-value check as presence-only. Tightened the guide to require accurate
  branch predicates in prose and diagrams; rerun the affected case before
  deciding. The legacy workspace has not yet been changed.
- After the User resumed work, a fresh worker reused the fictional legacy
  workspace, preserved its original file and link, and generated the requested
  E2E and numbered activity files. Independent review found an unknown HTTP
  boundary described without the explicit `Unverified` marker. Clarified the
  marker at the API and database requirements and reran the affected case.
- A further fresh read-only draft followed the naming, ordering, branch and
  uncertainty-label rules, but described a `save` call as a write. Clarified
  that a call and its arguments do not establish that a write occurred.
- The same worker reloaded the clarified guide and correctly described the
  observed call and argument while marking any actual write and storage state
  `Unverified`. The primary agent inspected both fictional workspaces and
  removed all ten task-owned fixture files; empty temporary directories remain.

## Validation

Inspect the changed guidance, skill mirrors, tree, links, IDs, metadata and
final diff. Use a fresh worker to exercise the named-file layout and the
preserved evidence rules with a fictional flow in an isolated local fixture.
Also check how existing numbered files are protected when a workspace is reused.

Native inspection found 60 ID-bearing resources with unique numeric sequences,
an INDEX folder tree matching disk, and 113 resolving local links across the
five affected documents. The pre-existing `#012` route drift remains. The two
onboarding skill copies match by SHA-256; `git diff --check` passed with
line-ending warnings. The original step evidence/uncertainty contract was
compared with its baseline; explicit marker placement was later clarified.

Fresh behavioral evidence: one worker generated a fictional new workspace
with a README, `e2e-sample-order.md`, and two numbered activity files. A second
worker independently identified the falsey/presence diagram mismatch after the
guide was clarified; its follow-up edited the fixture but ended with an
out-of-credits error before reporting. The primary agent inspected the corrected
files and confirmed their predicates and links. After the User resumed, a fresh
worker generated the corresponding files in a fictional legacy workspace,
preserving the old `01-...` file and the original README prefix and link. It
used the correct falsey predicate; it added a missing `Unverified` API label
after feedback and reloading the clarified guide.

A third fresh worker produced a read-only draft with correctly ordered file
names, predicates and uncertainty labels. After the guide clarified that a
`save` call does not prove a write occurred, its follow-up described the call
and payload without claiming persistence. The primary agent inspected both
fictional workspaces: each overview linked its two step files, each step had
the required diagram and response/data sections, and all 12 local fixture
links resolved. The source and old legacy file were preserved during the
replay. No unit tests, live APIs or databases were used; no real onboarding or
domain resources were created. This evidence does not establish behavior for
every flow or runtime.

## Risks

- A separate overview could drift from its linked steps. Mitigation: make the
  overview the E2E source and link steps in execution order.
- A diagram could oversimplify a branch predicate. Mitigation: state the
  source condition accurately in both prose and diagrams and replay the case.
- An unknown response or record detail could lack the `Unverified` marker.
  Mitigation: state the marker requirement beside each corresponding section.
- A call to an unknown repository could be described as a confirmed write.
  Mitigation: describe the call and argument; leave actual persistence unverified.
- Lexical sorting puts `s10` before `s2`. Mitigation: order and validate by the
  numeric step number and keep explicit overview links.
- Reusing a workspace could overwrite or rename prior evidence. Mitigation:
  preserve existing files and links and pause only conflicting migration work.
- The pre-existing `#012` plan is not routed in INDEX. Proposed follow-up:
  review its provenance before deciding whether to add a route.
- Empty task-owned fixture directories remain in the operating-system temp
  folder. Mitigation: let normal temporary-directory cleanup remove them.

## Decision and Result

Decision: keep. The naming and evidence contract is implemented and was
exercised in bounded fictional new and legacy workspaces, with observed defects
corrected and rerun. Real-flow and live-system behavior were not tested.
