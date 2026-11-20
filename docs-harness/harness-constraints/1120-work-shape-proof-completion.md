# Constraint Resource

ID: #075_CONSTRAINTS_1120
TAG: [CONSTRAINTS]
PRIORITY: [MEDIUM]
TITLE: Work shape, proof and completion
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- docs-harness/INDEX.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/harness-improvements/1120-session-workflow-into-constraints.md

## Constraint

**Work shape.** Choose one per request:
- Read-only: an answer, review, diagnosis, status report or unsaved plan. Inspect the
  evidence and report findings and proposals in the response.
- Bounded change: implement the requested local result with an ephemeral plan and
  focused proof; routine local verification is part of task authority.
- Durable change: use one evolving plan when work spans sessions, coordinates
  contributors, has dependencies, or needs recovery steps
  (`docs-harness/plans/README.md`, `docs-harness/templates/plan.md`).
- Audit: follow an audit skill's protocol only when the User requests that audit.

Keep task-local progress together. Ticket decisions go in the ticket's `decision/`
folder (`docs-harness/tickets/README.md`); non-ticket work gets no separate decision
record.

**Execute a change.**
1. Establish the observable outcome, inherited authority, changed-path scope,
   relevant product policy and existing worktree changes.
2. Read the affected implementation, contracts, neighboring patterns and proof.
3. Make the smallest coherent change; do not choose an undocumented default that
   expands product policy.
4. Run focused local verification under
   [#009](0822-user-authority-operation-gate.md) and the project constraints loaded at
   session start. Inspect unfamiliar commands first and honor narrower User limits.
5. Update affected product docs; after a runtime or contract change apply the
   domain freshness contract. A stale claim blocks only actions that rely on it.
6. Inspect the final diff and the INDEX consistency; record final results in the
   durable plan when one was needed.

When a decision or external action is needed, finish independent preparation and
present the boundary for approval. An unavailable tool is an unattempted check, not a
failing product test. A workflow that uses TypeSafe Jev follows
`docs-harness/JEV-AI.md` section 2. Without network or credentials, degrade to static
heuristics, default categories or human escalation instead of aborting; resolve
credentials from the environment or host registry, never from committed files.

**Proof.** Match the check to the behavior: focused tests for local rules,
integration tests for persistence and boundaries, E2E interaction for user-visible
flows, recovery rehearsal for migrations, measurements for performance. For a
reversible documentation edit check links, consistency and relevant instruction
scenarios, not tests that repeat the wording. For Harness routing, guidance,
metadata and link changes, inspect the affected files, links, IDs, metadata and final
diff, and report the evidence. Run repository-required checks within task authority and
broaden them when failures, new changes or open concerns justify it. A score, folder,
proof flag or successful tool call never stands in for the requested result.

**Completion.** Claim the outcome only with executable or observable evidence.
Report the changes, checks, unattempted proof and open limitations, and never imply
missing proof passed. Agent effectiveness needs behavioral evidence. Product and
domain context and durable working memory reflect relevant changes within authorized
scope. A blocker is a reported limitation, not an achieved outcome. A verified
ordinary plan may move to `completed/`; tickets and Harness improvement records have
their own closure rules (`docs-harness/tickets/README.md`,
`docs-harness/harness-improvements/README.md`).

## Applies To

Every request that creates or changes something, and every completion report.

## Rationale

These rules used to fill `docs-harness/WORKFLOW.md` and the Completion section of
`docs-harness/SESSION.md`. On 2026-11-20 the User asked to optimize both files and
keep their rules as constraints. The retired SQLite lifecycle sentence is dropped.

## Enforcement

Read it before changing anything and before reporting a result; it is not a
session-start read. Before reporting done, name the proof that ran and the proof that
did not.

## Validation

- A completion report separates checks that passed from proof not attempted.
- A Harness guidance change reports the routes, links, IDs and diff it inspected.
- A read-only request changes no file.
