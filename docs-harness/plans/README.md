# Execution Plans

Execution plans are Git-native working memory for complex tasks. They preserve
enough context for another agent or human to resume work without reconstructing
intent from chat history or a partial diff.

## Read When

Read this folder when work spans sessions, contributors, dependencies,
recovery, or an ordered sequence that would be unsafe or expensive to recover
from the final diff alone.

Use an ephemeral plan for bounded, single-session work. Do not create a durable
plan merely to add ceremony to a small change.

## When To Create A Plan

Use an ephemeral plan for bounded, single-session work.

Create one durable plan when work spans sessions, coordinates contributors, has
meaningful dependencies or ordering, requires recovery steps, or would be unsafe
to resume from the diff alone.

Use `docs-harness/templates/exec-plan.md` and place the file under `active/`.

## Lifecycle

```text
docs-harness/plans/active/<slug>.md
  -> update progress and decisions during implementation
  -> record final validation and result
  -> move to docs-harness/plans/completed/<slug>.md
```

The plan is the primary task artifact. Promote a lasting product or architecture
decision into `docs-harness/decisions/`; keep task-local choices in the plan.

## Boundaries

A plan records outcome, context, approach, risks, recovery, progress, decisions,
and validation. It is working memory that must be updated when evidence changes
the approach; it is not authority to invent product policy or bypass a required
approval.

## Active Plans

No active execution plans are currently indexed.

## Active Directory Guidance

Place one evolving plan here when work needs durable memory. Use
`docs-harness/templates/exec-plan.md`, keep progress and validation current, and
move the plan to `../completed/` only after the result is verified.

## Completed Directory Guidance

Move a plan here only after its requested outcome and validation are recorded.
Completed plans are historical evidence, not default task instructions.

Keep a completed plan when it explains a consequential migration, recovery
procedure, architectural transition, or decision history that future work may
need. Ordinary bounded changes should rely on Git and pull-request history.
