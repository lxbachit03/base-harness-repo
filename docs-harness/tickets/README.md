# Ticket Workspace

This file owns ticket layout and lifecycle. docs-harness/SESSION.md owns operation authority.
Use the source's ticket ID and wording; do not invent requirements or business
numbers. Missing IDs use TBD and a stable lowercase-kebab-case slug.

## Intake and scope

Read the complete named source before creating records. A request to organize
tickets authorizes intake; a request to solve them includes implementation and
routine local proof under docs-harness/SESSION.md. Review/status requests remain read-only.
Preserve existing files and clarify ambiguous identity or folder collisions.

For one ticket use active/<ticket-number>-<slug>/ticket.md. For multiple tickets
from one source, use active/<batch-slug>/<ticket-number>-<slug>/ticket.md.
The batch is a container, not a ticket. Source text and agent interpretation
remain separate in ticket.md.

## Ticket records and decision history

Every ticket needs ticket.md, initialized from templates/ticket.md, and its own
`decision/README.md`. During authorized intake or solving, create or reuse both
the `decision/` folder and its README for each ticket, including each child of
a batch. The batch container is not a ticket. A read-only review reports missing
artifacts without creating them.

Each ticket folder, batch container and artifact folder under a ticket's
`docs/` also gets a short README.md from templates/folder-readme.md: a ticket
folder's README points to its ticket.md, a batch container's to its child
tickets, and an artifact folder's to the `docs/README.md` manifest. Create
them during authorized intake or artifact creation; they repeat nothing the
record or manifest already holds.

Record the ticket source, owner when known, outcome, acceptance criteria,
scope, validation, risks/proposals, and status in ticket.md. Link its decision
history from ticket.md. Initialize `decision/README.md` as an index of the
ticket's decision files; state `No decisions recorded yet` until there are any.
Keep the index and links current without overwriting existing history.

Record each material choice made to resolve that ticket in a separate
`decision/MM-DD-<lowercase-kebab-case-name>.md`, using the local date in
Asia/Bangkok. Start from templates/decision.md and record the full year in the
file, context, chosen approach, rationale, alternatives when relevant,
decision-maker or authority, status, consequences, and supporting evidence.
Each evidence link must resolve to the source or section that actually supports
the cited choice or rationale. When a source cannot be linked, identify it and
the missing proof explicitly instead of linking an unrelated section.
Distinguish a proposal from an accepted choice and an agent's technical judgment
from User-approved policy. Update a decision's status when it is superseded;
preserve its history. If the path already exists, reuse the same decision only
when identity is clear; otherwise choose a distinct slug or numeric suffix.
Never overwrite another decision. Do not invent past choices for an existing
ticket. Ticket decisions are supporting artifacts, not canonical Harness
resources: do not assign them global resource IDs or individually index them
in docs-harness/INDEX.md.

## Proportional artifacts

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
including the `decision/` folder when moving, update status to completed, and
maintain current links.

If a completed folder still declares active metadata, report the mismatch in a
read-only task. Normalize it only during authorized ticket maintenance; preserve
the history and report the correction. Location does not itself grant a write.

## Evidence and handoff

Read the ticket and applicable inventories/manifest before solving. Record
evidence after meaningful progress; do not report resolution from folder
creation. Missing tool access is distinct from failing acceptance criteria.

Domain discovery and freshness follow domain/README.md. Record each risk and
its proposed response together inline in ticket.md under the task's authority;
follow harness-constraints/0812-risk-proposal-suggestion-cross-link.md. A
proposal remains a suggestion until accepted by the relevant authority.

Before handoff verify requested ticket count/identity, each decision folder,
index, dated decision files and links, folder READMEs, applicable artifacts,
acceptance
evidence, lifecycle, and the final diff. Report outcomes, checks, unresolved
decisions, and any unattempted proof. INDEX routes to stable ticket lifecycle
folders; ordinary ticket records do not receive Harness IDs.
