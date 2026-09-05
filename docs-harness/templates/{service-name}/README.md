# Service Domain E2E Flow Template

This folder is a reusable Harness template for documenting one service and its
end-to-end data flows. It is template-only, not domain truth. A qualifying
evidence-backed workflow may instantiate its content inside
`docs-harness/domain/<MMDD>-<name>/`.

## Template Use and Confirmation Gate

This folder is scaffolding only. It is not a canonical domain resource, source
of business truth, or evidence that the placeholder service exists. Use it only
after the workflow has a concrete domain scope and source-backed evidence.

Creating or populating `docs-harness/domain/<MMDD>-<name>/` is limited to an
explicitly scoped `$onboarding` run, ticket-solving workspace, or Q&A marked as
domain discovery. Before instantiation, confirm the service or flow name,
data-flow scope, authoritative evidence sources, and whether each statement is
`[CONFIRMED]` or `[UNCERTAIN]`.

After the evidence gate is satisfied:

1. Create the date-prefixed domain workspace and its canonical `README.md`.
2. Replace placeholders only with source-backed or explicitly User-confirmed
   facts; keep unknowns marked as `Unverified` or `[UNCERTAIN]`.
3. Apply the metadata and evidence requirements from
   `docs-harness/templates/domain.md` to each canonical domain resource.
4. Update `docs-harness/INDEX.md` for the real resources and applicable
   classification routes.

If the evidence, scope, or folder collision check is missing or ambiguous,
leave this template under `docs-harness/templates/` and report the missing
input instead of creating domain documentation.

## Folder contract

```text
{service-name}/
├── README.md
├── data-flows/
│   └── {data-flow-name}/
│       ├── apis.md
│       ├── entities.md
│       ├── prerequisite.md
│       └── data-flow.md
└── schemas/
    └── {schema-name}.md  # create from templates/domain-entity.md
```

Create one child folder under `data-flows/` for each concrete E2E flow. Keep
different business or API journeys isolated; do not combine unrelated flows in
one folder.

## Data-flow files

- `apis.md`: APIs that participate in the flow, their order, role, request and
  response contracts, side effects, and source evidence.
- `entities.md`: entities or database schemas used by the flow, their fields,
  relationships, enum meanings, and source evidence.
- `prerequisite.md`: seed data or API preparation that must run before the E2E
  flow, in dependency order, with authority and cleanup notes.
- `data-flow.md`: Mermaid activity diagrams. The first diagram is the complete
  E2E journey from client/trigger through terminal outcome. Every later diagram
  covers exactly one API from `apis.md`.

The `schemas/` folder is carried as a placeholder. Its contract is defined by
`docs-harness/templates/domain-entity.md`. Each concrete schema file under
`docs-harness/domain/<MMDD>-<name>/schemas/` must be created from that template
and must retain source evidence.

Creating or populating a schema file requires explicit current User authority
for the named service and schema. Detailed field analysis is a separate gate:
the User authority must explicitly allow codebase tracing of field assignment,
transformation, reads, and `WHERE`/`JOIN`/filter/query usage. Without that
authority, keep the detailed sections as `Pending User authority` or
`Unverified`; do not infer field behavior.

## Evidence and freshness rules

Use repository paths and line ranges for observed implementation facts, or
ticket/section and Q&A decision references. Mark unknown or unverified details
explicitly. New domain content starts as `[UNCERTAIN]`; only explicit User
confirmation makes it `[CONFIRMED]`.

After runtime-logic, persistence, contract, or data-flow code changes, compare
changed paths with domain references, evidence citations, and linked
dependencies. Re-validate every possible affected resource. Record
`Freshness: CURRENT`, or mark `STATUS: needs-review` and `Freshness: STALE`,
record the changed source, and pause when a claim is stale or contradictory.
