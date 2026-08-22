# SCHEMAs: <ticket-title>

This file inventories database entities and schemas relevant to this ticket.
Record verified field and enum meanings from repository evidence; mark unknown
details instead of guessing.

## Scope

- Ticket: <ticket-id-or-title>
- Ticket owner: <person-team-or-role>
- Canonical ticket record: [`ticket.md`](ticket.md)
- Artifact manifest: [`docs/README.md`](docs/README.md)
- Database or persistence area: <database, service, or area>

## Review Record

- Last reviewed: <YYYY-MM-DD>
- Evidence sources: <model, migration, schema, query, or documentation paths>
- Evidence summary: <what was verified, or what was checked before recording `None found`>

Replace every placeholder above with a real review date and evidence before
using this file as a ticket record. If no relevant schema is found, record the
review date, the repository paths or commands checked, and `None found` rather
than omitting the review evidence.

## Entity and Schema Inventory

### `<EntityOrSchemaName>`

- Purpose: <business meaning>
- Physical name: <table, collection, document, or schema name>
- Source: `<path>:<line>`
- Relationships: <related entities and relationship meaning>

| Field | Type | Required | Nullable | Default | Enum | Meaning | Evidence |
|---|---|---:|---:|---|---|---|---|
| `<field>` | `<type>` | `<yes/no>` | `<yes/no>` | `<value/none>` | `<enum/none>` | `<field meaning>` | `<path>:<line>` |

## Relationships

| From entity/field | Relationship | To entity/field | Meaning | Evidence |
|---|---|---|---|---|
| `<Entity.field>` | `<one-to-many/etc.>` | `<Entity.field>` | `<relationship meaning>` | `<path>:<line>` |

## Enum Definitions

### `<EnumName>`

- Source: `<path>:<line>`
- Purpose: <what this enum represents>

| Value | Meaning | Used by field(s) | Persistence/API representation | Evidence |
|---|---|---|---|---|
| `<VALUE>` | `<meaning>` | `<Entity.field>` | `<stored or exposed form>` | `<path>:<line>` |

Include every verified enum value relevant to the ticket. Use `TBD`, `Not
found`, or `Unverified` when a value's meaning is not established.

## Missing or Unverified Schema Facts

- <entity, field, relationship, or enum meaning still unresolved, evidence
  checked, and next owner/action>
