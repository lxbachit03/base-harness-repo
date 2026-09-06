# Ticket Workspace

This file owns ticket layout and lifecycle. AGENTS.md owns operation authority.
Use the source's ticket ID and wording; do not invent requirements or business
numbers. Missing IDs use TBD and a stable lowercase-kebab-case slug.

## Intake and scope

Read the complete named source before creating records. A request to organize
tickets authorizes intake; a request to solve them includes implementation and
routine local proof under AGENTS.md. Review/status requests remain read-only.
Preserve existing files and clarify ambiguous identity or folder collisions.

For one ticket use active/<ticket-number>-<slug>/ticket.md. For multiple tickets
from one source, use active/<batch-slug>/<ticket-number>-<slug>/ticket.md.
The batch is a container, not a ticket. Source text and agent interpretation
remain separate in ticket.md.

## Proportional artifacts

Every ticket needs ticket.md, initialized from templates/ticket.md. Record its
source, owner when known, outcome, acceptance criteria, scope, decisions,
validation, risks/proposals, and status there.

Add only artifacts the task needs:

- apis.md when API behavior or data preparation is relevant;
- entities.md when persistence, schemas, or enum behavior is relevant;
- docs/README.md and docs/ when attachments or additional generated artifacts
  need a manifest. Inline-only intake does not need an empty docs/ folder.

Use the corresponding templates. If an inventory is applicable, record a real
review date, evidence sources, and verified facts or an explicit unknown.
Record non-applicability briefly in ticket.md; do not create empty inventories
merely to satisfy a layout. Preserve existing inventories and manifests.

Every artifact under docs/ has one owner, resolvable link, purpose, source or
generator, and status in its manifest. Shared batch artifacts live in the
batch docs/ with their own manifest. Implementation source stays in its normal
repository location; link it rather than copying it into the ticket.

## Work and lifecycle

Default to active/; discover nested ticket.md records and read only relevant
tickets. Read completed history for a named ticket or a real dependency.

Use intake, ready, in-progress, blocked, or resolved as appropriate. Work one
ticket at a time unless independent parallel work has been requested. When a
batch ticket is blocked, continue another independent requested ticket.

Acceptance proof marks a ticket resolved. Keep it in active/ for review unless
the User requested closure or approved the active-to-completed move; that
authority may already exist earlier in the task. Preserve artifacts and history
when moving, update status to completed, and maintain current links.

If a completed folder still declares active metadata, report the mismatch in a
read-only task. Normalize it only during authorized ticket maintenance; preserve
the history and report the correction. Location does not itself grant a write.

## Evidence and handoff

Read the ticket and applicable inventories/manifest before solving. Record
evidence after meaningful progress; do not report resolution from folder
creation. Missing tool access is distinct from failing acceptance criteria.

Domain discovery and freshness follow domain/README.md. Risks and proposals may
remain inline in the ticket. Create canonical paired resources only when
durable risk tracking is requested or part of the accepted scope.

Before handoff verify requested ticket count/identity, applicable artifacts and
links, acceptance evidence, lifecycle, and the final diff. Report outcomes,
checks, unresolved decisions, and any unattempted proof. INDEX routes to stable
ticket lifecycle folders; ordinary ticket records do not receive Harness IDs.
