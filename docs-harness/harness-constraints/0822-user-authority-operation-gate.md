# Constraint Resource

ID: #009_CONSTRAINTS_0822
TAG: [CONSTRAINTS]
PRIORITY: [CRITIAL]
TITLE: Task authority for local work and explicit external boundaries
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- docs-harness/harness-constraints/1120-work-shape-proof-completion.md
- docs-harness/plans/completed/0906-task-authority-and-policy-consistency.md
- docs-harness/harness-improvements/1120-session-workflow-into-constraints.md

## Constraint

This is the canonical task-authority policy; workflows and skills refer here instead
of defining their own gates.

- Answers, explanations, reviews, diagnoses and status reports are read-only. A
  plan stays in the response unless the User asks to save it.
- A request to implement, fix, build or update authorizes the necessary local edits
  within the task and routine local verification: existing focused tests, build and
  lint checks, formatting changed files, temporary fixtures, disposable caches.
  Project constraints can narrow this. Inspect unfamiliar commands first; their
  effects decide authority.
- Inspect installation, migration, seed and cleanup effects before running them;
  task-owned disposable fixtures are routine. Dependency installation and operations
  on shared services, real data, global settings, credentials or unrelated paths need
  specific authority; a test name alone does not make them routine. The Jev helpers'
  own API-key lookup and TypeSafe API calls are permitted by default.
- Deployment, publishing, external messages, account or permission changes,
  destructive data operations, staging (`git add`), commits, pushes, and deleting or
  overwriting unrelated User work need explicit authority for that action and target.
- Authority lasts for the task across turns until completed, revoked or changed; a
  follow-up question does not cancel it. A plan or skill recommendation cannot grant
  new authority.
- State the affected paths and command class before meaningful mutations, then
  continue without repeated confirmation. Ask only for a materially new boundary or
  an unresolved product decision.
- A request to improve the Harness, including acceptance of a concrete review,
  authorizes that scoped change through `improve-harness` and `writing-for-agents`;
  ordinary tasks do not authorize self-improvement.
- A skill inherits this policy and keeps its narrower workflow: intake is not
  solving, a review is read-only, `domain-audit` records only what the User
  confirmed, and a draft goal does not start autonomous goal state.
- Preserve existing changes and use recoverable operations. A read-only task reports
  drift without normalizing metadata or repairing routing.

## Applies To

All repository work and workflow/skill entry points.

## Change history

2026-09-06: the User accepted a rules review; task-scoped local implementation and
verification authority replaced the per-command gate. 2026-11-20: the policy moved
here, trimmed, from `docs-harness/SESSION.md` with no new gate. ID and creation date
are preserved; earlier experiment records stay historical.

## Validation

Exercise read-only review, local implementation plus verification, a follow-up turn
inheriting authority, and an external action outside scope. Only the last needs a new
authorization, read-only work stays non-mutating, and explicit restrictions bind.
