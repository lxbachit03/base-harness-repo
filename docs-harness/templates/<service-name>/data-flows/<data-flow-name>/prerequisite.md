# Prerequisites: <data-flow-name>

> Template-only: this file is not domain truth. Populate it only inside a
> User-authorized service workspace under `docs-harness/domain/<service-name>/`.
> Until then, keep its placeholders and do not index it as a domain resource.

Record everything that must exist or run before the E2E flow can start. Prefer
the least stateful preparation path and keep commands or API calls as proposed
instructions until the User explicitly authorizes execution.

## E2E Gate

- Flow: `<data-flow-name>`
- Required starting state: `<state that must be true>`
- Reset/cleanup boundary: `<how state is isolated or removed>`
- Last reviewed: `<YYYY-MM-DD>`
- Evidence sources: `<fixtures, factories, APIs, migrations, or code paths>`

## Ordered Prerequisites

| Order | Data/state required | Preparation path | Required by | Evidence | Status |
|---:|---|---|---|---|---|
| 1 | `<record, configuration, or external state>` | `<seed/API/manual/unknown>` | `<API or step>` | `<path>:L<start>-L<end>` | `<required/unverified>` |

## Preparation Options

### Seed data

- Source or fixture: `<path>`
- Inputs: `<required values>`
- Produces: `<records/state>`
- Command: `<command or Not requested>`
- Required User authority: `<authority or Not requested>`

### API preparation

- API: `<method> <path>`
- Request: `<body/query/headers>`
- Produces: `<records/state>`
- Ordering/dependencies: `<prior API or data>`
- Required User authority: `<authority or Not requested>`

## Cleanup and Recovery

- Cleanup: `<rollback, delete, reset, or None verified>`
- Recovery if preparation fails: `<safe recovery step>`
- Data ownership: `<owner>`

## Missing or Unverified Prerequisites

- `<missing data, preparation path, authority, or evidence; next owner/action>`
