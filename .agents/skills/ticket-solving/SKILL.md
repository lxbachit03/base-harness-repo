---
name: ticket-solving
description: Organize or solve supplied tickets using proportional evidence workspaces and explicit lifecycle tracking.
disable-model-invocation: true
---

# Ticket Solving

Use when the User invokes this skill. Follow AGENTS.md and docs-harness/INDEX.md, then
docs-harness/tickets/README.md, which owns layout, artifacts, and lifecycle.
Task authority persists across turns; intake, solving, and closure are distinct
requested outcomes.

## Intake

1. Locate the supplied source and read it completely. Preserve its wording.
2. Establish ticket count, source IDs or TBD, boundaries, and attachment owners.
   Clarify conflicting sources or identity collisions before creating records.
3. Use the guide's direct or batch-child layout and docs-harness/templates/ticket.md.
4. Add API/schema inventories and an artifact manifest only when applicable,
   reading each selected template first. Preserve existing files.
5. Record unknown acceptance criteria instead of inventing requirements.

Done when each requested ticket has a traceable source and coherent workspace.
Stop here for intake-only work.

## Solve

1. Read the relevant active ticket and its applicable inventories/manifest.
   Retrieve completed history only for a named request or dependency.
2. Establish acceptance proof, inherited task authority, and current state.
3. Implement the scoped solution and run routine local verification under
   AGENTS.md. Keep implementation code in its normal repository paths.
4. Record meaningful progress, decisions, evidence, and applicable artifacts.
5. For domain discovery or runtime changes apply docs-harness/domain/README.md; keep material
   risks paired with an inline mitigation or investigation proposal.
6. Mark resolved only with acceptance evidence. Apply completed moves and
   metadata correction only under the guide's authorized maintenance boundary.

For a requested batch, continue another independent ticket when one is blocked.
Do not expand from source organization to implementation or external actions.

## Validate and report

Verify ticket count and identity, required ticket.md records, applicable
inventories/manifests, their evidence and links, acceptance proof, lifecycle,
and final diff. Inspect only relevant records; an inspection never normalizes
metadata. Update stable INDEX routes and folder tree when their structure
changes; ordinary tickets are not classified Harness resources.

Report outcome, changed paths, checks, and unresolved dependencies or decisions.
A missing tool is not a failing test. Prepared intake is not a solved ticket.
