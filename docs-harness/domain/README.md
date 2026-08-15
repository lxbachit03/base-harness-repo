# Domain Knowledge

This folder contains project or domain knowledge that the agent may need to
understand vocabulary, behavior, ownership, or accepted context. It is not a
place to invent business rules or replace product-owned source of truth.

## Knowledge States

- `TAG: [DOMAIN] [CONFIRMED]`: supported by an authoritative source or explicit
  User confirmation.
- `TAG: [DOMAIN] [UNCERTAIN]`: useful working context that still requires
  confirmation before it becomes policy.

Keep the uncertainty state visible. Do not silently promote uncertain knowledge
to confirmed knowledge because it appears plausible.

## Read When

Read this folder when the task depends on project vocabulary, domain behavior,
or User-confirmed context. Follow only the classification route selected in
`docs-harness/INDEX.md`.

## Create And Maintain

Use `docs-harness/templates/domain.md`. Record the source, confidence/state,
scope, and references. Promote a resource to confirmed only when its authority
is explicit, and index each real resource without copying its contents.

## Skip When

Skip this folder when the task is independent of product/domain knowledge or
can be answered from repository structure and executable proof alone.
