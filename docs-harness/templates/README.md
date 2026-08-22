# Resource Templates

This folder contains stable system templates for creating supported Harness
resources. Templates are scaffolding, not canonical resources and not default
task instructions.

## Available Templates

- `activity-diagram.md`: Mermaid flow/activity diagrams with file and line range citations for onboarding flows.
- `constraint.md`: file, folder, or task constraints.
- `decision.md`: lasting product or architecture decisions.
- `domain.md`: confirmed or uncertain domain knowledge.
- `domain-entity.md`: detailed service schema/entity documentation, including
  field code-usage and query tracing gated by explicit User authority.
- `exec-plan.md`: durable execution plans.
- `harness-improvement.md`: bounded Harness improvement experiments.
- `plan.md`: plan resources requiring the common resource metadata.
- `proposal.md`: options and recommendations awaiting authority.
- `risk.md`: security, performance, and memory-leak risks.
- `ticket.md`: ticket records managed under `docs-harness/tickets/active/` or
  `docs-harness/tickets/completed/`; use the direct
  `<ticket-number>-<single-ticket>/` layout for one ticket and a
  `<sample-big-ticket>/` container with numbered child folders for a batch.
- `APIs.md`: ticket-local API inventories and data-preparation alternatives.
- `SCHEMAs.md`: ticket-local database schema, field, relationship, and enum
  inventories.
- `ticket-docs-README.md`: the required owner/link/provenance manifest for a
  ticket's `docs/` folder.

## Ticket Folder Layout Templates

The placeholder folders below are layout examples, not active ticket records:

- `<ticket-number>-<single-ticket>/`: one ticket directly under the active or
  completed lifecycle folder.
- `<sample-big-ticket>/`: a batch container whose child folders are named
  `<ticket-number>-<ticket-name>/`, one child per ticket.

Use the file templates above inside each ticket folder. Do not route or solve
these placeholder folders as tickets merely because they exist under
`templates/`.

## Domain E2E Flow Template

`<service-name>/` is the folder template for service-level domain knowledge
organized as multiple isolated E2E data flows:

```text
<service-name>/
├── README.md
├── data-flows/
│   └── <data-flow-name>/
│       ├── apis.md
│       ├── entities.md
│       ├── prerequisite.md
│       └── data-flow.md
└── schemas/
    └── <schema-name>.md
```

The first Mermaid diagram in each `data-flow.md` is the complete E2E flow. Every
following diagram covers one API from `apis.md`. Each real schema file under a
promoted service workspace uses `domain-entity.md`; the placeholder
`schemas/<schema-name>.md` remains empty until a concrete User-authorized schema
is documented.

## Domain Schema/Entity Template

Use `domain-entity.md` for one schema/entity file under
`docs-harness/domain/<service-name>/schemas/`. It covers schema meaning, fields,
enums, relationships, constraints, indexes, lifecycle, and source-backed code
usage. Code usage means tracing where a field is assigned, transformed, read,
serialized, and used in `WHERE`, `JOIN`, filter, sort, or index conditions.

The schema documentation authority and the detailed field-analysis authority
are separate. A current User request must name the schema before a real file is
created. Detailed field/code tracing is prohibited unless that authority also
explicitly covers the analysis scope. Otherwise retain `Pending User authority`
or `Unverified` placeholders.

## Usage Rules

- Read the matching template before creating a new supported resource.
- Preserve the required metadata, immutable IDs, dates, tags, priorities, and
  references defined by `AGENTS.md`.
- Replace placeholders with evidence; do not fabricate domain knowledge,
  priority, authority, or validation.
- Templates do not receive real resource IDs or date-prefixed filenames and
  should not be indexed as real resources.
- Domain templates are not domain truth. Creating or populating a real service
  workspace under `docs-harness/domain/` requires an explicit current User
  request naming the service and authorizing its documentation scope; agent
  inference, discovery, or a plan alone is insufficient.
- A domain schema file must use `domain-entity.md`. Its detailed field and code
  usage sections require explicit User authority for the named schema/fields;
  the template may define the sections but must not be populated from agent
  inference without that authority.
- After promotion, replace placeholders with source-backed or explicitly
  User-confirmed facts, apply `templates/domain.md`, and update `INDEX.md` only
  for the real canonical resources. If authority or evidence is unresolved,
  keep the scaffold under `templates/`.
- Update `docs-harness/INDEX.md` in the same task when a real resource or
  routing metadata changes.

## Skip When

Skip this folder when the task edits existing content only or does not create a
supported resource.
