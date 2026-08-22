# Entities: <data-flow-name>

> Template-only: this file is not domain truth. Populate it only inside a
> User-authorized service workspace under `docs-harness/domain/<service-name>/`.
> Until then, keep its placeholders and do not index it as a domain resource.

Record entities and persistence schemas that are actually involved in this E2E
flow. Keep facts source-backed and distinguish observed implementation details
from User-confirmed domain meaning.

## Scope

- Service: `<service-name>`
- Data flow: `<data-flow-name>`
- Last reviewed: `<YYYY-MM-DD>`
- Evidence sources: `<model, migration, schema, query, or documentation paths>`

## Entity Inventory

### `<EntityOrSchemaName>`

- Role in flow: `<read, created, updated, deleted, or referenced>`
- Physical/API name: `<table, collection, document, DTO, or schema>`
- Source: `<path>:L<start>-L<end>`
- Lifecycle impact: `<state change or None verified>`

| Field | Type | Required | Nullable | Default | Enum | Meaning | Evidence |
|---|---|---:|---:|---|---|---|---|
| `<field>` | `<type>` | `<yes/no>` | `<yes/no>` | `<value/none>` | `<enum/none>` | `<meaning>` | `<path>:L<start>-L<end>` |

## Relationships

| From entity/field | Relationship | To entity/field | Flow meaning | Evidence |
|---|---|---|---|---|
| `<Entity.field>` | `<one-to-many/etc.>` | `<Entity.field>` | `<why this relation matters>` | `<path>:L<start>-L<end>` |

## Enum Meanings

| Enum | Value | Meaning in this flow | Used by | Evidence |
|---|---|---|---|---|
| `<EnumName>` | `<VALUE>` | `<meaning or Unverified>` | `<Entity.field>` | `<path>:L<start>-L<end>` |

## Missing or Unverified Entities

- `<entity, field, relationship, enum, or meaning still unresolved; next owner/action>`
