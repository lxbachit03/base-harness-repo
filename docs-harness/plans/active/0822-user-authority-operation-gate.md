# Harness Improvement Resource

ID: #008_IMPROVE_HARNESS_0822
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Require User authority for mutations and side-effecting validation
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/plans/README.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- .agents/skills/goal-griller/SKILL.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md

## Objective

Make read-only inspection the default and require explicit User authority
before an AI agent mutates files or folders or runs build/test and other
side-effecting commands.

## Current State

Baseline:

- Repository root: `/Users/bale/Documents/Repositories/test-repo/test_custom_harness`
- Revision: `856e13e6237be3e39711027b1a067a6df8058ec0`
- Branch: `main`
- Initial worktree: clean.

`AGENTS.md` already required authority before editing and `WORKFLOW.md`
required focused proof, but the setup did not state one explicit operation gate
covering file/folder mutations and build/test commands. The `$improve-harness`
skill also instructed the agent to run repository-native checks without
distinguishing read-only checks from commands that can write artifacts or state.

## Proposed Improvement

If `AGENTS.md` defines a single User Authority Gate and the workflow, goal
front door, improvement skill, and canonical constraint point to it, then a
fresh agent will inspect by default and pause before unauthorized mutation or
build/test execution, because operation scope and command authority are
explicit rather than inferred from route, validation, or implementation intent.

Evidence that would weaken this:

- A fresh equivalent task creates or edits an unlisted path without explicit
  User authority.
- A fresh agent runs build/test, lint, format, generation, installation, or
  migration without command-level authority.
- The gate blocks an explicitly authorized operation within its stated scope.
- The wording causes agents to skip genuinely read-only inspection or to claim
  validation without reporting unattempted checks.

Maintenance owner and removal condition:

- Owner: repository Harness maintainers.
- Revise the gate if fresh reruns show authority ambiguity, false blocking of
  authorized work, or unchecked side effects.

## Scope

In scope:

- `AGENTS.md` as the authority owner.
- `docs-harness/WORKFLOW.md` and the canonical constraint resource.
- `$goal-griller` and `$improve-harness` wording at their operation boundaries.
- This active improvement record and the required INDEX/plan routing entries.

Out of scope:

- Product code, product policy, external systems, credentials, or the Harness
  binary.
- Running build, test, lint, format, generation, installation, migration, or
  package commands in this intervention.
- Automatically granting authority from a goal, plan, skill invocation,
  acceptance criteria, or a prior note.
- Moving this record to `plans/completed/` before a fresh rerun and decision.

## Validation

During work:

- Verify the authority gate is present in `AGENTS.md` and referenced by the
  workflow and affected skills.
- Verify the constraint and improvement record use unique resource IDs and are
  indexed in the correct sections.
- Run only read-only/static checks such as path, link, whitespace, ID, and
  `git diff --check` checks.

Final proof:

- Use a fresh equivalent prompt that requests a scoped file edit without
  build/test authority; confirm the agent pauses or performs only the named
  authorized mutation and does not run build/test.
- Use a second fresh prompt that explicitly authorizes a named build/test
  command; confirm the command is treated as authorized only within that scope.
- Record the comparison and choose `keep`, `revise`, or `remove` before moving
  this record to `plans/completed/`.

## Native Validation Result

- `git diff --check`: pass.
- `bash .agents/validators/sync-harness-index.sh --check`: pass.
- New paths exist, real resource IDs are unique, and no trailing whitespace was
  found in the changed files.
- Build, test, lint, format, generation, installation, migration, and package
  commands were not run because this User request did not authorize them.
- Fresh equivalent rerun: not performed in this session; decision remains
  `pending fresh rerun`.

## Risks

An overly broad gate could block legitimate implementation work. Proposal: keep
authority scoped to the current User request and allow explicit path/command
authority rather than requiring approval for every read-only inspection.

Skipping build/test without command authority can leave proof incomplete.
Proposal: report the exact unattempted check and ask for the smallest command
authority needed instead of silently running it or overstating completion.

## Current Decision

Decision: pending fresh rerun.

The intervention is implemented and static validation passes. Do not claim the
Harness improved or move this record to `plans/completed/` until a fresh
equivalent session exercises both the blocked and explicitly authorized paths.
