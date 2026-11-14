# Harness Improvement Resource

ID: #056_IMPROVE_HARNESS_1114
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Remove the product, risks and proposals folders
CREATED: 2026-11-14
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/README.md
- docs-harness/harness-constraints/0812-risk-proposal-suggestion-cross-link.md
- docs-harness/templates/README.md
- docs-harness/tickets/README.md

## Objective

Remove the User-named `docs-harness/product/`, `risks/`, and `proposals/`
folders and reconcile their active routes and direct consumers.

## Purposes

- [x] Remove the three explicitly named Harness folders.
- [x] Keep the remaining guidance navigable after their removal.

## Current State

Baseline: `D:/repos/base-harness-repo`, `main` at `fd3dae2`, with uncommitted
`#055` ticket-decision work. Each named folder contains only its tracked
`README.md`; `product/README.md` has an uncommitted edit from `#055` and is
inside the User's explicitly named deletion target. Preserve all other `#055`
changes. The Jev hook is disabled.

At baseline, INDEX and current guidance routed to the three folders. Constraint
`#001` and the risk/proposal templates referred to persisted paired resources
in two of the named folders. The User subsequently chose to keep risks and
proposed responses inline in the relevant ticket or plan.

## Proposed Improvement

Remove only the named folders, update their current routes and direct guidance,
and retain risk/mitigation behavior according to the User's answer. Hypothesis:
an agent can follow the updated INDEX without reaching missing paths while
preserving the chosen risk/proposal contract. A broken live link, re-created
folder, or contradictory persistence instruction would weaken the result.
The INDEX and affected policy owners are the maintenance owners; revisit if a
fresh scoped scenario shows routing or reporting does not follow the contract.

## Scope

The three named folders, directly affected current Harness instructions,
templates, skill mirrors if required, INDEX, and this record. Preserve unrelated
`#055` edits, historical records, user-owned raw requirements and real data.
Do not stage, commit, push, or modify external services.

## Progress

- 2026-11-14: Captured the baseline and inspected the named directories and
  direct policy references. Asked the User where risk/proposal information
  should live after their dedicated folders are removed.
- 2026-11-15: Removed the requested `product/README.md` and its direct routes.
  The remaining empty `product/` directory could not be removed because the
  automatic approval review returned `blocked by policy`.
- Removed the requested `risks/README.md` and `proposals/README.md` and their
  INDEX/README routes. Both verified-empty directories remain because the same
  automatic approval review blocked their direct non-recursive removal. Asked
  the User to remove all three empty directories; risk/proposal policy remains
  pending the separate User choice.
- The User selected inline risk and proposed-response notes in tickets/plans
  and reported removing the three empty directories. Verified all three paths
  are absent; updated the constraint, direct guidance, templates, and
  goal-griller mirrors to reflect the selected policy.
- A fresh worker exercised a read-only risk response and an authorized inline
  update in an existing fictional ticket and plan. The read-only case left all
  four fixture files unchanged; the write case changed only the ticket and plan
  and did not create the removed directories. The fixture files were deleted
  after independent inspection; task-owned empty temporary directories remain.

## Validation

Inspect the affected tree, links, policy owners, templates, metadata, preserved
prior changes, and final diff. Run a fresh bounded agent scenario appropriate
to the resulting routing and risk/proposal contract; record any unattempted
proof and keep the experiment active if a fresh replay cannot run.

Interim check: all 104 local INDEX links resolve, 56 resource IDs have no
duplicate numeric sequence, and `git diff --check` passes with line-ending
warnings. The existing unindexed `#012` plan remains outside scope. The folder
tree differs from disk only because the three explicitly named, now-empty
directories remain after the blocked removal. Constraint `#001` and the paired
templates still refer to the removed folder contents while the User's decision
is pending. No final or fresh behavioral replay has been claimed.

Final native review: the three requested paths and the earlier `decisions/` path
are absent; the INDEX folder tree matches disk. All 104 local INDEX links and
135 local links across 21 affected documents resolve; the 56 resource ID
sequences are unique. The pre-existing `#012` routing drift remains unchanged.
The ticket-solving and goal-griller mirrors match by SHA-256. Active-reference
search found no current references to the retired local folder paths.
`git diff --check` passed with line-ending warnings.

Fresh replay: the worker loaded the revised INDEX, constraint, ticket/plan
guides and templates. It reported an evidenced synthetic risk with a concrete,
unaccepted proposed response. Hashes showed no fixture writes during the
read-only case. With scoped write authority, it recorded the risk, evidence,
status and response inline in both the existing ticket and plan. Independent
inspection verified both notes, the four fixture files and absence of new
risk/proposal directories. The fictional app was not executed and no real data
or external services were involved; this does not establish production quality.

## Risks

- Removing the folders without reconciling their consumers could leave broken
  links or cause agents to recreate them. Mitigation: update active owners and
  inspect links and routing after the User's persistence decision.
- Removing `product/README.md` also removes an uncommitted change from `#055`.
  Mitigation: delete only this explicitly named target and preserve all other
  `#055` edits and its completed record.
- Automatic approval review blocked removal of the three verified-empty
  directories. The User removed them, and the INDEX folder-tree check passed.
- Empty task-owned replay directories remain in the operating-system temporary
  folder after fixture files were removed. Mitigation: allow normal temporary
  cleanup or remove the empty fixture directory when convenient.

## Decision and Result

Decision: keep. The User removed all three directories, active routing and the
risk/proposal owners reflect inline ticket/plan storage, and native checks and
the bounded fresh replay passed. The earlier `#055` work is preserved except for
the explicitly requested removal of `product/README.md`. No actual ticket
implementation or production behavior was tested.
