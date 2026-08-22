# APIs: <data-flow-name>

> Template-only: this file is not domain truth. Populate it only inside a
> User-authorized service workspace under `docs-harness/domain/<service-name>/`.
> Until then, keep its placeholders and do not index it as a domain resource.

Record only APIs verified as relevant to this E2E flow. Keep the order aligned
with the overall diagram in `data-flow.md` and give every API one stable name
that its dedicated diagram can reference.

## Scope

- Service: `<service-name>`
- Data flow: `<data-flow-name>`
- Entry API or trigger: `<method> <path>`
- Terminal outcome: `<response, event, or state>`
- Last reviewed: `<YYYY-MM-DD>`
- Evidence sources: `<file paths and line ranges inspected>`

## API Sequence

| Order | API | Role in the E2E flow | Depends on | Enables | Evidence |
|---:|---|---|---|---|---|
| 1 | `<method> <path>` | `<entry/validation/read/write/etc.>` | `<prerequisite>` | `<next API or outcome>` | `<path>:L<start>-L<end>` |

## API Inventory

### API 1 — `<method> <path>`

- Purpose: `<what this API does in this flow>`
- Source: `<route/controller/handler path>:L<start>-L<end>`
- Authentication/authorization: `<required identity, role, scope, or unknown>`
- Request: `<path/query/header/body shape>`
- Success response: `<status and response shape>`
- Error responses: `<status and meaning>`
- Side effects: `<entity/event/state change or None verified>`
- Prerequisites: `<data or prior API required>`
- Next step: `<next API, event, or terminal outcome>`

Repeat the section once for every API in the flow. Do not document an API here
unless it is relevant to the flow and supported by evidence.

## Missing or Unverified APIs

- `<API or contract still unresolved; evidence checked and next owner/action>`
