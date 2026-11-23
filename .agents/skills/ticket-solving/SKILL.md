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
3. Use the guide's direct or batch-child layout and docs-harness/templates/ticket.md;
   create or reuse each ticket's decision/ index, `ticket-DoD.md` and folder
   READMEs as the guide specifies.
4. Add API/schema inventories and an artifact manifest only when applicable,
   reading each selected template first. Preserve existing files.
5. Record each unknown acceptance criterion as an open item in
   `ticket-DoD.md` instead of inventing requirements.

Done when each requested ticket has a traceable source and coherent workspace.
Stop here for intake-only work.

## Solve

1. Read the relevant active ticket and its applicable inventories/manifest;
   create or reuse its decision/ index for authorized solving. Retrieve
   completed history only for a named request or dependency.
2. Establish acceptance proof, inherited task authority, and current state.
3. Implement the scoped solution and run routine local verification under
   docs-harness/harness-constraints/0822-user-authority-operation-gate.md. Record each solution decision as it is made in the ticket's dated
   decision/ files and maintain its index per the workspace guide. Keep
   implementation code in its normal repository paths.
4. Record meaningful progress, evidence, and applicable artifacts. Add a
   triaged `ticket-DoD.md` item whenever the work needs a User answer or
   action;
   close items with the answer and where it was applied.
5. For domain discovery or runtime changes apply docs-harness/domain/README.md;
   pair every reported risk with an inline mitigation or investigation proposal.
6. Mark resolved only with acceptance evidence and no open required
   `ticket-DoD.md` item; close open optional items as defaulted. Apply completed moves and
   metadata correction only under the guide's authorized maintenance boundary.

For a requested batch, continue another independent ticket when one is blocked.
Do not expand from source organization to implementation or external actions.

## Validate and report

Verify ticket count and identity, ticket.md, decision/ records and
`ticket-DoD.md`, folder READMEs, applicable inventories/manifests, their evidence and links, acceptance proof, lifecycle,
and final diff. Inspect only relevant records; an inspection never normalizes
metadata. Update stable INDEX routes and folder tree when their structure
changes; ordinary tickets are not classified Harness resources.

Report outcome, changed paths, checks, and unresolved dependencies. Ask the
User every open `ticket-DoD.md` item by its `U<n>` ID, required first, and
list the defaults that optional items will apply.
A missing tool is not a failing test. Prepared intake is not a solved ticket.
