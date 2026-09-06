# Agent Instructions

<!-- HARNESS:BEGIN -->
## Start with the outcome

Use this repository as the system of record. Read docs-harness/INDEX.md after
this file and before other repository documentation. INDEX owns context
retrieval; follow its routes to the current task's evidence.

## Task authority

This section is the canonical operation-authority policy. Workflow guides and
skills refer here instead of defining competing general permission gates.

- Answers, explanations, reviews, diagnoses, and status reports are read-only.
  A planning request stays in the response unless the User asks to save a plan.
- A request to implement, fix, build, or update authorizes necessary local edits
  within the stated task and routine local verification of those edits.
  This includes focused tests, build/lint checks, formatting changed files,
  temporary test fixtures, and disposable build/test caches. Inspect unfamiliar
  commands before running them; their effects determine authority.
- Inspect installation, migration, seed, and cleanup effects before execution.
  Task-owned disposable fixture setup/cleanup is included in local verification.
  Dependency installation and operations touching shared services, real data,
  global settings, credentials, or unrelated paths need specific authority.
  A test name alone does not make those effects routine.
- Deployment, publishing, external messages, account/permission changes,
  destructive data operations, commits, pushes, and deleting or overwriting
  unrelated User work need explicit authority for that action and target.
- Authority and constraints persist for the task across conversation turns
  until completed, revoked, or changed. A follow-up question does not cancel
  earlier permission. On resumption, use a recorded User authorization and
  scope; a plan or skill's own recommendation cannot grant new authority.
- State the affected paths and intended command class before meaningful
  mutations. Continue authorized work without repeated confirmation; ask only
  for a materially new boundary or unresolved product decision.
- A request to improve the Harness, including acceptance of a concrete review,
  authorizes that scoped guidance/skill/tool intervention. Use improve-harness
  and writing-for-agents for it; ordinary tasks do not authorize self-improvement.
- A skill invocation inherits this policy. Its narrower user-selected workflow
  still matters: intake is not solving, an audit is read-only, and a draft goal
  is not permission to start autonomous goal state.
- Preserve existing changes and use recoverable operations. Read-only tasks may
  report drift but must not normalize metadata or repair routing automatically.

## Evidence and judgment

Distinguish observed implementation facts, accepted policy, inference, and
unknowns. Configurable defaults and adjacent code do not establish new product
intent. Before introducing an externally observable policy, locate accepted
authority or obtain the missing decision. Pause the dependent action when
intent, authority, recovery, or proof is insufficient; continue independent
authorized work.

For every material risk reported, include a concrete mitigation or investigation
proposal. It remains a suggestion until authorized. The persisted risk/proposal
contract lives in docs-harness/harness-constraints/0812-risk-proposal-suggestion-cross-link.md.

## Working memory and documentation

- docs-harness/WORKFLOW.md owns work shape, verification, and completion.
- docs-harness/plans/README.md owns the single durable-plan lifecycle.
- docs-harness/templates/README.md owns resource metadata, IDs, and template
  selection. Templates are scaffolding, not product facts.
- docs-harness/domain/README.md owns evidence capture, confirmation, schema
  tracing, and freshness after runtime/contract changes. Check affected claims;
  report or record stale knowledge within the task's authority.
- docs-harness/tickets/README.md owns ticket layout and lifecycle.
- docs-harness/ is the agent context router. Read relevant consumer documents,
  including docs/, when linked or directly needed to answer the task. Edit them
  only when the requested change includes their content; never bootstrap docs/
  merely because a template mentions it.
- If Harness context is missing, report it during inspection. Create only the
  missing task-relevant structure when the requested change needs it.

## Completion

Claim the outcome only with relevant executable or observable evidence. Report
the changes, checks, unattempted proof, and unresolved limitations. Structural
validation proves its named checks; agent effectiveness requires behavioral
evidence. Optional SQLite/control-plane operations run only when requested or
required by an external orchestrator.
<!-- HARNESS:END -->
