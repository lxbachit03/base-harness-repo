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

For service-level E2E flow documentation, use the template at
`docs-harness/templates/<service-name>/`. The template is template-only, not domain truth.
A real service workspace belongs here only after explicit User authority and
must retain source-backed evidence and its applicable routing metadata.

## Promotion Gate

The agent must not create or populate a real service workspace here merely
because the template was discovered, read, linked, or referenced by a plan. A
current User request must explicitly name the service and authorize the domain
documentation scope before the template is promoted into this folder.

On promotion, replace placeholders with source-backed or explicitly
User-confirmed facts, preserve `[CONFIRMED]` versus `[UNCERTAIN]`, apply the
metadata in `docs-harness/templates/domain.md`, and update `INDEX.md` only for
the real canonical resources. If authority, scope, or evidence is unclear,
leave the template under `docs-harness/templates/` and pause.

### Schema and field-analysis gate

Create each real schema file under
`docs-harness/domain/<service-name>/schemas/` from
`docs-harness/templates/domain-entity.md`. The current User request must name
the service, schema, and documentation scope before the file is created or
populated.

Detailed field explanation is a separate authority boundary. The User must
explicitly authorize codebase tracing for the named schema or fields before the
agent explains assignment, transformation, reads, serialization, or
`WHERE`/`JOIN`/filter/query usage. Without that authority, keep those sections
as `Pending User authority` or `Unverified` and do not infer their behavior.

## Skip When

Skip this folder when the task is independent of product/domain knowledge or
can be answered from repository structure and executable proof alone.
