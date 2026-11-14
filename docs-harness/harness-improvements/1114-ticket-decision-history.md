# Harness Improvement Resource

ID: #055_IMPROVE_HARNESS_1114
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Keep decision history inside each ticket
CREATED: 2026-11-14
STATUS: completed
REFERENCES:
- .agents/skills/ticket-solving/SKILL.md
- .claude/skills/ticket-solving/SKILL.md
- docs-harness/tickets/README.md
- docs-harness/templates/decision.md
- docs-harness/templates/ticket.md
- docs-harness/INDEX.md

## Objective

Remove the shared `docs-harness/decisions/` folder and make each ticket own an
auditable `decision/` folder whose decision files use `MM-DD-<name>.md`.

## Purposes

- [x] Keep the decisions made to resolve a ticket with that ticket's history.
- [x] Make each recorded decision discoverable and auditable by date.
- [x] Stop storing separate decisions outside tickets, as the User selected.

## Current State

Baseline: `D:/repos/base-harness-repo`, `main` at `fd3dae2`, clean worktree.
The User explicitly requested deletion of `docs-harness/decisions/` and asked
for ticket-local decision history. The folder contains only its tracked README;
no decision records were found there. The ticket guide and skill currently put
decisions inline in `ticket.md`, while current plans and routes refer to the
shared decision folder. Both ticket-solving skill copies have the same hash.

The User selected not storing decisions outside tickets. Existing historical
records and the operational result of this improvement remain history, not new
standalone decision records. The hook is disabled. The unrelated unindexed
completed plan `#012` predates this task and is outside scope.

## Proposed Improvement

Make the ticket workspace guide the owner of one `decision/` directory per
ticket, with an index and dated decision files. Point both skill copies and
ticket templates to that contract, and reconcile current consumers of the
removed shared folder. Hypothesis: a fresh ticket-solving session creates or
reuses the correct per-ticket directory and records actual solution decisions
with rationale, authority, and evidence. A missing directory, wrong date
format, invented decision, broken link, or loss of prior history weakens it.
The ticket guide owns the contract; revisit if fresh use shows missing audit
detail or unnecessary repeated work.

## Scope

The named shared folder; ticket-solving skill and mirror; ticket, decision,
and plan guidance/templates and direct current consumers; INDEX; and this
record. Preserve existing ticket data, historical records, and User-owned raw
requirements. Do not stage, commit, push, or create a real ticket in this task.

## Progress

- 2026-11-14: Inspected baseline, ticket and decision owners, current links,
  and the named deletion target. User chose not to store non-ticket decisions.
  Created this record before changing the intervention's owning guidance.
- Updated the ticket guidance, skill mirrors, templates and direct consumers;
  removed the tracked README from the named shared folder. An automatic
  approval review blocked removing the now-empty directory.
- First fresh fixture replay produced one direct ticket and two batch children,
  each with its own decision index, and one correctly dated decision. Its
  decision linked to the ticket's original-text section even though the
  specific choice was documented in the ticket's context section. Clarified
  that evidence links must support the cited choice and rationale.
- A second fresh worker replay recorded two distinct decisions with the same
  date and candidate slug using `11-14-built-in-trim.md` and
  `11-14-built-in-trim-2.md`. Their links point to the specific fictional User
  follow-ups supporting the choices and rationale. A read-only review reported
  a missing `decision/` folder without creating it. No product implementation,
  real ticket, or external system was touched.
- Deleted the 12 synthetic fixture files after inspection. Their empty
  task-owned directories remain under the operating-system temporary folder.
- The User requested another direct deletion attempt. After verifying the
  named folder still existed and was empty, the same non-recursive removal was
  rejected again by automatic approval review with `blocked by policy`.
- The User subsequently removed the shared directory. Verified that the path
  no longer exists and that the INDEX folder tree matches the filesystem.

## Validation

Native inspection: both skill copies match by SHA-256; all 109 local INDEX links
and 140 local links across the affected documents resolve; 55 resource IDs have
no duplicate numeric sequence. The pre-existing unindexed `#012` plan remains
outside scope. `git diff --check` passed with line-ending warnings. The empty
old `decisions/` directory is absent after User removal; the INDEX folder tree
matches the filesystem.

Fresh fixture replay: one direct ticket and two batch children each had their
own `decision/README.md`. A later ticket contained two collision-safe dated
decision files with separate supported choice/rationale links. A read-only
ticket without a decision folder remained unchanged. Independently inspected
all 12 synthetic Markdown files and their 25 local links and headings: none
were broken. No actual ticket implementation or production behavior was tested.

## Risks

- Future work may overlook ticket-local choices. Mitigation: link a decision
  index from `ticket.md` and preserve the folder through ticket lifecycle moves.
- Dates without years can collide. Mitigation: keep the full date in each
  record, check the path before creation, and never overwrite an existing file.
- An unaccepted proposal could be mistaken for an approved decision.
  Mitigation: record its status, source, decision authority, and evidence.
- Automatic approval review blocked removal of the empty shared
  `docs-harness/decisions/` directory with `blocked by policy`. The User removed
  it, and the subsequent INDEX folder-tree check passed.
- Empty task-owned replay directories remain under the temporary folder after
  the synthetic files were removed. Mitigation: the User may remove the named
  temporary directory or let normal temporary-file cleanup handle it.

## Decision and Result

Decision: keep. The shared directory is absent, the requested ticket guidance
is implemented, and the bounded fresh replay passed. The User removed the
directory after the automatic cleanup block; the final folder-tree check passed.
No actual ticket implementation or production behavior was tested.
