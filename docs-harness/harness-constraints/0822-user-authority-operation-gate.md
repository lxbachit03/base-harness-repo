# Constraint Resource

ID: #009_CONSTRAINTS_0822
TAG: [CONSTRAINTS]
PRIORITY: [CRITIAL]
TITLE: Task authority for local work and explicit external boundaries
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/WORKFLOW.md
- docs-harness/plans/completed/0906-task-authority-and-policy-consistency.md

## Constraint

AGENTS.md, section Task authority, is the canonical policy. Read it before
classifying an operation. This resource is its critical routing pointer, not
a second copy of the permission rules.

## Applies To

All repository work and workflow/skill entry points.

## Change history

On 2026-09-06 the User accepted the preceding rules review and requested its
implementation. That replaces the earlier per-command/current-message gate
with task-scoped local implementation and verification authority. The specific
boundaries listed in AGENTS.md still apply; this notice adds no new operation gate.

The ID and creation date are preserved. The earlier experiment records remain
historical evidence and do not override the current policy.

## Validation

Exercise read-only review, local implementation plus verification, a follow-up
turn inheriting authority, and an external action outside scope. Verify that
only the last needs a new action authorization, while read-only work stays
non-mutating and explicit restrictions remain binding.
