# APIs: <data-flow-name>

> Template-only: this file is not domain truth. Populate it only inside a
> User-authorized service workspace under `docs-harness/domain/<service-name>/`.
> Until then, keep its placeholders and do not index it as a domain resource.

Record only APIs verified as relevant to this E2E flow. Keep the order aligned
with the overall diagram in `data-flow.md` and give every API one stable name
that its dedicated diagram can reference.

## API Documentation Contract

Repeat the complete contract below for every API in the flow. Record the
request entering the API, the execution context, the output leaving it, and the
domain/database impact observed in code. Use source paths and line ranges for
each implementation fact; keep business meaning marked as `Observed`,
`Authoritative`, `Unverified`, or `Pending User authority`.

- **Input** explains what enters the API, from which caller or prior step, and
  how it is validated or transformed.
- **Context** explains why the API runs at this point in the E2E flow, which
  actor and dependencies apply, and which domain logic controls its branches.
- **Output** explains the response, event, or terminal state produced by the
  API.
- **Entity impact** explains which database entities are read, created,
  updated, deleted, joined, or filtered, which fields are affected, and which
  downstream components depend on the result.

Do not infer entity impact from endpoint names. If the repository does not
establish a detail, use `Unverified` or `None verified` and cite the checked
scope.

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

#### Purpose and Source

- Purpose: `<what this API does in this flow>`
- Source: `<route/controller/handler path>:L<start>-L<end>`
- API status: `<Observed/Authoritative/Unverified>`

#### Input

- Trigger/caller: `<client, prior API, event, job, or internal component>`
- Request path/query: `<parameters, query values, and meanings>`
- Headers/identity: `<headers, tenant, user, role, or scope>`
- Body/payload: `<shape, required fields, and value meanings>`
- Input entities/state: `<records or state required before entry>`
- Validation: `<validators, guards, authorization, or None verified>`
- Defaulting/transformation: `<coercion, normalization, mapping, or None verified>`
- Input evidence: `<path>:L<start>-L<end>`

#### Context

- Position in E2E flow: `<entry, middle step, retry, compensation, or terminal>`
- Why this API runs here: `<dependency and flow purpose>`
- Domain logic: `<rule/decision/state transition or Unverified>`
- Actor and authority: `<caller identity, role, tenant, or Unverified>`
- Dependencies: `<services, repositories, queues, configuration, or None verified>`
- Transaction/state boundary: `<transaction, unit of work, lock, or Unverified>`
- Branches and failure paths: `<condition -> behavior>`
- Context evidence: `<path>:L<start>-L<end>`

#### Output

- Success response: `<status and response shape>`
- Error responses: `<status and error meaning>`
- Event/message emitted: `<topic/event/payload or None verified>`
- Terminal state: `<response, persisted state, event, or next API>`
- Output transformation: `<mapping, serialization, redaction, or None verified>`
- Output evidence: `<path>:L<start>-L<end>`

#### Domain Logic and Entity Impact

- Domain decision: `<decision made by the API and its observed rule>`
- Logic evidence: `<path>:L<start>-L<end>`

| Entity/database component | Action | Fields affected/read | Query/filter/join | Persistence or state impact | Evidence |
|---|---|---|---|---|---|
| `<entity/table/collection>` | `<read/create/update/delete>` | `<fields>` | `<WHERE/JOIN/filter/order or None verified>` | `<record/state change>` | `<path>:L<start>-L<end>` |

Record every verified entity touched by the domain logic, including entities
that are only queried to authorize a branch or determine a response. If a
database effect is suspected but not proven, use `Unverified` rather than
guessing.

#### Downstream Components and Entities

| Component/entity | How it is affected | Direction | Contract/state received | Evidence |
|---|---|---|---|---|
| `<service/repository/queue/job/API/entity>` | `<reads output, receives event, changes state, or None verified>` | `<in/out/read/write>` | `<payload/state or Unverified>` | `<path>:L<start>-L<end>` |

#### Prerequisites and Next Step

- Authentication/authorization: `<required identity, role, scope, or unknown>`
- Prerequisites: `<data or prior API required>`
- Side effects: `<entity/event/state change or None verified>`
- Next step: `<next API, event, or terminal outcome>`
- Recovery/rollback: `<behavior or Unverified>`
- Evidence: `<path>:L<start>-L<end>`

Repeat the complete API section once for every API in the flow. Do not document
an API here unless it is relevant to the flow and supported by evidence. Keep
the API order aligned with `API Sequence` and the per-API diagrams in
`data-flow.md`.

## Missing or Unverified APIs

- `<API or contract still unresolved; evidence checked and next owner/action>`
