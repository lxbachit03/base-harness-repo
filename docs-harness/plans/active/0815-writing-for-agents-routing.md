# Harness Improvement Resource

ID: #003_IMPROVE_HARNESS_0815
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Route writing-for-agents through goal-griller
CREATED: 2026-08-15
STATUS: active
REFERENCES:
- .agents/skills/goal-griller/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- .agents/skills/writing-for-agents/SKILL-MECHANICS.md
- docs-harness/WORKFLOW.md
- docs-harness/INDEX.md

## Objective

When a User asks to create or edit a persistent agent-facing document, the
goal-griller front door should route the task to `$writing-for-agents` so that
pointer wording, information disclosure, steps, completion criteria, and
pruning are reviewed without applying that skill to ordinary product prose.

## Current State

The `writing-for-agents` skill exists locally with its mechanics reference and
agent-facing display metadata, but it is not referenced by the goal-griller
routing contract. The route list currently covers direct handling,
`$prompt-leverage`, `$xia`, `$sequence-execution-plan`, and `$improve-harness`
only. A prior fresh routing experiment established goal-griller as the front
door, but did not cover agent-document writing as a distinct specialist case.

Evidence:

- `.agents/skills/writing-for-agents/SKILL.md` defines the document-writing
  specialist and points skill authors to `SKILL-MECHANICS.md`.
- `.agents/skills/goal-griller/SKILL.md` has no `writing-for-agents` route before
  this intervention.
- `docs-harness/INDEX.md` has no active record for this experiment before this
  intervention.

## Proposed Improvement

If the goal-griller routing contract names `$writing-for-agents` for persistent
agent-facing documents and includes it in the route handoff, then a fresh agent
will select the specialist for skill, `AGENTS.md`, `CLAUDE.md`, or routed
instruction-document work, because the trigger and ownership boundary will be
explicit. `$improve-harness` remains the authority and lifecycle route when the
requested change modifies Harness guidance; `$writing-for-agents` reviews the
document quality within that intervention.

Evidence that would weaken this:

- A fresh equivalent agent-document prompt still selects `direct` without a
  writing specialist or selects every specialist.
- A product-document prompt is incorrectly routed to `$writing-for-agents`.
- The route causes the agent to bypass `AGENTS.md` → `docs-harness/INDEX.md`,
  local authority, validation, or the `$improve-harness` fresh-rerun boundary.

Maintenance owner and removal condition:

- Owner: repository Harness maintainers.
- Revise or remove the route if equivalent reruns show added ceremony,
  incorrect document routing, increased context load, or no improvement in
  agent-facing document tasks.

## Scope

In scope:

- One bounded routing change to `.agents/skills/goal-griller/SKILL.md`.
- This active improvement record and its `INDEX.md` routing entries.
- Fresh equivalent prompts for agent-document and ordinary product-document
  tasks.

Out of scope:

- Rewriting the `writing-for-agents` skill or its mechanics reference.
- Changing `AGENTS.md`, product behavior, product documentation, or the core
  Harness binary.
- Making `$writing-for-agents` a mandatory route for every Markdown edit.
- Claiming improvement before the fresh rerun and decision.

## Validation

During work:

- Check the edited route and all referenced local paths.
- Assert the new route appears in both route lists and the handoff enum.
- Preserve the existing six-field goal gate, direct route, authority rules,
  risk-to-proposal rule, and repository entry order.

Final proof:

- Inspect the diff and run `git diff --check`.
- Validate INDEX folder/section/link consistency and real resource-ID
  uniqueness.
- Run fresh equivalent prompts for agent-facing document work and ordinary
  product-document work, then record route selection and any steering.

## Risks

The new route could increase context load or cause ordinary product Markdown
changes to receive unnecessary specialist ceremony. Proposal: keep the trigger
narrow to persistent agent-facing documents and make direct handling remain the
default for ordinary product work.

The route could be mistaken for authority to modify Harness guidance. Proposal:
keep `$improve-harness` as the explicit intervention owner and leave this
record active until the fresh rerun establishes whether the combination is
useful.

## Current Decision

Decision: pending fresh rerun.

The intervention is implemented and native validation passes. Do not move this
record to `plans/completed/` or claim that the Harness improved until a fresh
equivalent agent session exercises the route and records the comparison.
