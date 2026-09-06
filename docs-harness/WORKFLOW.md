# Repository Workflow

AGENTS.md owns task authority. docs-harness/INDEX.md owns retrieval. This file owns work
shape and proof; consult the specific domain, ticket, or plan guide only when
that workflow is involved.

## Choose the work shape

- **Read-only:** answer, review, diagnosis, status, or an unsaved plan. Inspect
  the necessary evidence and report findings and proposals in the response.
- **Bounded change:** implement the requested local result, using an ephemeral
  plan and focused proof. Routine local verification is part of task authority.
- **Durable change:** use one evolving plan when work spans sessions, coordinates
  contributors, has meaningful dependencies, or needs recovery steps. Follow
  docs-harness/plans/README.md and docs-harness/templates/plan.md.
- **Strict audit:** use the selected audit skill's evidence protocol only when
  that audit is requested. Cryptographic evidence bundles and a fresh reviewer
  are not prerequisites for ordinary inspection or implementation.

Keep task-local progress and decisions together. Add a separate accepted
decision only when future work must inherit a consequential product,
architecture, ownership, security, compatibility, or validation choice.

## Execute a change

1. Establish the observable outcome, inherited task authority, changed-path
   scope, relevant product policy, and existing worktree changes.
2. Read the affected implementation, contracts, neighboring patterns, and proof.
3. Make the smallest coherent change. Do not expand product policy by choosing
   an undocumented default.
4. Run focused local verification under AGENTS.md. Inspect effects before
   unfamiliar commands and honor narrower User restrictions.
5. Update affected product docs and, for runtime/contract changes, apply the
   domain freshness contract. A stale claim blocks only actions relying on it;
   continue independent work and report the unresolved dependency.
6. Inspect the final diff and relevant INDEX consistency. Record final results
   in the durable plan when one was needed.

If a new decision or external action is needed, finish independent preparation
and present the concrete boundary for approval. An unavailable tool is an
unattempted check, not a failing product test.

## Choose proof

Use checks matched to the changed behavior: focused tests for local rules,
integration tests for persistence/boundaries, E2E interaction for user-visible
flows, recovery rehearsal for migrations, or measurements for performance.
For a reversible documentation edit, check its links, consistency, and relevant
instruction scenarios; avoid tests that merely repeat the wording.

Run repository-required checks that are within task authority. Broaden checks
when failures, new changes, or unresolved concerns justify it. Never substitute
a score, folder, proof flag, or successful tool invocation for the requested
observable result.

## Completion

The outcome exists and appropriate proof has passed. Report any missing proof
without implying it passed. Current product/domain context and durable working
memory must reflect relevant changes within authorized scope. A discovered
blocker is a reported limitation, not an achieved outcome.

A verified ordinary plan may move to completed/ as part of finishing its task.
Ticket lifecycle and Harness improvement experiments have their own closure
criteria in docs-harness/tickets/README.md and docs-harness/harness-improvements/README.md.

SQLite intake, story, trace, scoring, audit, and proposal commands are optional
compatibility operations, not a default lifecycle.
