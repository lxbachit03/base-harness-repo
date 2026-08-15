# Harness Improvement Resource

ID: #004_IMPROVE_HARNESS_0815
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Separate active and completed ticket context
CREATED: 2026-08-15
STATUS: active
REFERENCES:
- .agents/skills/ticket-solving/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- docs-harness/tickets/README.md
- docs-harness/templates/ticket.md
- docs-harness/tickets/active/README.md
- docs-harness/tickets/completed/README.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md

## Objective

Give ticket work an explicit active/completed lifecycle so the agent reads
current work by default, preserves completed history without loading it on every
ticket, and treats User authority or an explicit active-to-completed move as the
completion boundary.

## Current State

Baseline:

- Repository root: `/Users/bale/Documents/Repositories/test-repo/test_custom_harness`
- Revision: `84bd1eeb4f6423ab9d635f117a59c0ce2eed4997`
- Branch: `main`
- Initial worktree also contains unrelated edits to `docs-harness/INDEX.md`,
  `docs-harness/README.md`, `docs-harness/WORKFLOW.md`, and untracked skill and
  ticket scaffold paths; preserve them.

The ticket workspace initially had `docs-harness/tickets/README.md` and a
ticket template under the ticket workspace, but no lifecycle folders. The
template now lives at `docs-harness/templates/ticket.md`, while the lifecycle
folders separate current and completed work. `ticket-solving` previously
placed tickets directly under the workspace and did not define a default read
boundary for completed work.

Observed friction: the User had to distinguish a completed skill artifact from
an active Harness improvement record whose fresh-rerun evidence was still
pending. The same ambiguity can occur when a ticket's acceptance proof is done
but User authority to close the lifecycle has not been given.

## Proposed Improvement

Add `docs-harness/tickets/active/` and `docs-harness/tickets/completed/`.
Route new and in-progress tickets through `active/`; skip `completed/` during
default context loading and retrieve it only for explicit history or dependency
needs. Define User authority or an explicit active-to-completed move as the
completion boundary. If a record is found under `completed/` with
`status: active`, normalize it to `status: completed` while preserving its
decision history.

Keep `.agents/skills/writing-for-agents/SKILL.md` at its discoverable root. Use
it to review the ticket lifecycle wording; keep ticket lifecycle ownership in
`ticket-solving` and the `docs-harness/tickets/` workspace.

## Scope

In scope:

- `ticket-solving` lifecycle and default-read behavior;
- `docs-harness/tickets/` README, active/completed guidance, and template
  placement;
- `docs-harness/INDEX.md` and relevant Harness map entries;
- native checks and a fresh equivalent ticket rerun.

Out of scope:

- moving `.agents/skills/writing-for-agents/SKILL.md` itself;
- changing product tickets, product behavior, or the Harness binary;
- assigning Harness resource IDs to ordinary ticket records;
- treating completed history as permanently unreadable.

## Validation

During work:

- verify the active/completed tree and template links;
- verify the skill reads `active/` by default and discloses the completed
  retrieval branch;
- verify no old one-level ticket layout remains in the skill or README;
- run `git diff --check` and preserve unrelated worktree changes.

Final proof:

- run a fresh equivalent ticket intake/solve session from a clean starting
  context;
- confirm a new ticket lands under `active/`;
- confirm a User-authorized move lands under `completed/` and normalizes an
  active metadata status;
- confirm a default run does not read completed history unless the task needs
  it;
- record the comparison and choose `keep`, `revise`, or `remove` before moving
  this record to `plans/completed/`.

## Risks

Skipping completed history by default could hide a dependency that a current
ticket needs. Proposal: allow explicit path, User request, or declared
dependency to reopen completed context and report when it is used.

Folder-based completion could normalize a stale metadata field without making
the User's authority visible. Proposal: preserve the decision log, record the
normalization in the ticket, and report the active-to-completed move.

Decision: pending fresh rerun.
