# Domain Entity / Schema Resource

> Template-only: this file defines a documentation contract; it is not a
> schema, domain resource, or source of domain truth. Do not populate it with
> schema-specific facts without the required User authority.

## Authority Gate

Creating a real schema file under
`docs-harness/domain/<service-name>/schemas/<schema-name>.md` requires an
explicit current User request that names the service, schema, and documentation
scope.

Detailed field analysis requires an additional explicit User authority covering
codebase tracing for the named schema or fields. This includes explaining:

- where a field receives its initial value;
- how the value is transformed, normalized, defaulted, or overwritten;
- where the value is read or serialized;
- how the value is used in `WHERE`, `JOIN`, filter, sort, or index conditions;
- which APIs, events, jobs, handlers, or downstream services depend on it.

Without that field-analysis authority, keep the detailed sections as
`Pending User authority` or `Unverified`. Do not infer, summarize, or persist
field behavior from code inspection alone. Reading this template does not grant
authority to create a schema resource or perform detailed field analysis.

## Resource Metadata

ID: #<next-sequence>_<PRIMARY_CLASSIFICATION>_<MMDD>
TAG: [DOMAIN] [<CONFIRMED|UNCERTAIN>]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <service> <schema> entity documentation
CREATED: <YYYY-MM-DD>
STATUS: <status>
REFERENCES:
- <schema definition, migration, model, or resource path>

## Scope and Review

- Service: `<service-name>`
- Schema/entity name: `<schema-name>`
- Schema kind: `<table/collection/document/view/DTO/event/other>`
- Domain documentation authority: `<User request or Pending User authority>`
- Detailed field-analysis authority: `<User request/scope or Pending User authority>`
- Last reviewed: `<YYYY-MM-DD>`
- Review evidence: `<paths and line ranges inspected>`

## Schema Identity

- Canonical name: `<database and code-level names>`
- Physical location: `<database, schema, table, collection, or None verified>`
- Owning service/module: `<service/module>`
- Definition source: `<migration/model/schema/DDL path>:L<start>-L<end>`
- Persistence technology: `<technology/version or Unverified>`
- Identifier strategy: `<primary key/partition key/document key or Unverified>`
- Lifecycle owner: `<service/team or Unverified>`
- Sensitive-data classification: `<classification or Unverified>`

## Schema Meaning

> Populate schema-specific meaning only after domain documentation authority is
> granted. Separate source-backed implementation facts from User-confirmed
> business meaning.

- One-sentence purpose: `<what this schema represents>`
- Detailed purpose: `<why it exists and what boundary owns it>`
- Created when: `<trigger or Unverified>`
- Updated when: `<trigger or Unverified>`
- Retired/deleted when: `<trigger or Unverified>`
- Invariants: `<rules supported by evidence>`
- Out-of-scope meanings: `<what this schema must not be interpreted as>`
- Confirmation state: `<[CONFIRMED]/[UNCERTAIN]>`
- Evidence: `<path>:L<start>-L<end>`

## Field Inventory

Record one row per field. Do not use the `Meaning`, `Value Lifecycle`, or
`Code-usage status` columns to make unsupported business claims.

| Field | Type | Required | Nullable | Default/generated | Key | Meaning | Code-usage status | Evidence |
|---|---|---:|---:|---|---|---|---|---|
| `<field-name>` | `<type>` | `<yes/no>` | `<yes/no>` | `<value/none>` | `<PK/FK/index/none>` | `<source-backed meaning or Pending User authority>` | `<Pending User authority/Unverified/Verified>` | `<path>:L<start>-L<end>` |

## Field Analysis Contract

Populate the following section once for each field that falls within the
explicit field-analysis authority. If authority does not cover a field, retain
the placeholder and state `Pending User authority`; do not partially infer the
trace.

### Field: `<field-name>`

Analysis authority: `<explicit User scope or Pending User authority>`
Analysis status: `<Pending User authority/In progress/Verified/Unverified>`

#### Definition and Meaning

- Declared type: `<type and source>`
- Runtime type: `<type after mapping/serialization or Unverified>`
- Meaning in the schema: `<meaning>`
- Meaning in the domain: `<User-confirmed meaning or Uncertain>`
- Allowed values/range: `<values, range, or Unverified>`
- Null/absence semantics: `<meaning of null, empty, missing, or default>`
- Evidence: `<path>:L<start>-L<end>`

#### Assignment and Creation Trace

| Code location | Operation | Value source | Transformation/default | Condition | Persisted value | Evidence |
|---|---|---|---|---|---|---|
| `<path>:L<start>-L<end>` | `<create/assign/update/map>` | `<request/input/constant/derived/entity/API>` | `<transform or none>` | `<condition>` | `<result>` | `<path>:L<start>-L<end>` |

Explain every verified creation or update path, including whether the field is
assigned by a constructor, mapper, default, handler, job, event consumer, or
database trigger. Record competing assignment paths separately.

#### Transformation and Normalization Trace

| Code location | Before value | Operation | After value | Applies when | Evidence |
|---|---|---|---|---|---|
| `<path>:L<start>-L<end>` | `<input representation>` | `<trim/cast/normalize/hash/derive/none>` | `<stored representation>` | `<condition>` | `<path>:L<start>-L<end>` |

Record validation, coercion, truncation, casing, timezone, precision, hashing,
redaction, defaulting, and overwrite behavior when verified. Do not fill this
section from naming conventions alone.

#### Read and Consumption Trace

| Code location | Consumer | Read operation | Representation | Downstream effect | Evidence |
|---|---|---|---|---|---|
| `<path>:L<start>-L<end>` | `<handler/service/job/API/event>` | `<select/map/compare/serialize/display>` | `<value/DTO/event>` | `<effect>` | `<path>:L<start>-L<end>` |

Describe where the field is read, which branch or state transition it affects,
and whether it is exposed to an API, event, log, job, or external service.

#### Query, Filter, and Join Trace

| Code location | Query type | Field usage | Operator/condition | Bound value source | Index/plan relevance | Result/use | Evidence |
|---|---|---|---|---|---|---|---|
| `<path>:L<start>-L<end>` | `<select/update/delete/existence>` | `<WHERE/JOIN/ORDER BY/GROUP BY>` | `<operator and predicate>` | `<parameter/constant/derived>` | `<index or Unverified>` | `<what result controls>` | `<path>:L<start>-L<end>` |

For every verified query use, show the actual predicate or join relationship,
not only the method name. Record whether the field is optional, combined with
other predicates, used for pagination, used in a uniqueness check, or used to
select a state transition.

#### API, Event, and Boundary Mapping

| Boundary | Direction | Field representation | Mapping/rename | Required/optional | Evidence |
|---|---|---|---|---|---|
| `<API/event/job/service>` | `<in/out>` | `<request/response/event/DTO>` | `<mapping>` | `<required/optional>` | `<path>:L<start>-L<end>` |

#### Lifecycle and State Impact

- Initial state/value: `<value or Unverified>`
- State transitions involving this field: `<transition and condition>`
- Mutable after creation: `<yes/no/Unverified>`
- Ownership of updates: `<component or Unverified>`
- Retention/deletion effect: `<effect or Unverified>`
- Concurrency/idempotency behavior: `<behavior or Unverified>`
- Evidence: `<path>:L<start>-L<end>`

## Enum and Value Semantics

Use this section for enum types, status values, discriminator values, and other
closed sets. Detailed code usage of an enum or value set is also gated by the
field-analysis authority.

| Enum/type | Field(s) | Value | Meaning | Created by | Used by/transition | Unknown/invalid behavior | Evidence |
|---|---|---|---|---|---|---|---|
| `<EnumName>` | `<Entity.field>` | `<VALUE>` | `<meaning>` | `<path/component>` | `<consumer or transition>` | `<validation/fallback/error>` | `<path>:L<start>-L<end>` |

### Enum Transition Notes

- Allowed transitions: `<from -> to and condition>`
- Forbidden transitions: `<rule or Unverified>`
- Default value: `<value or None verified>`
- API/event serialization: `<representation>`
- Query/filter usage: `<predicate or None verified>`
- Evidence: `<path>:L<start>-L<end>`

## Relationships, Constraints, and Indexes

### Relationships

| From field | Relationship | To schema/field | Cardinality | Enforcement | Flow meaning | Evidence |
|---|---|---|---|---|---|---|
| `<schema.field>` | `<FK/reference/derived>` | `<schema.field>` | `<1:1/1:N/N:N>` | `<DB/code/none/Unverified>` | `<meaning>` | `<path>:L<start>-L<end>` |

### Constraints

| Constraint | Fields | Rule | Enforcement location | Failure behavior | Evidence |
|---|---|---|---|---|---|
| `<unique/check/not-null/foreign-key>` | `<fields>` | `<rule>` | `<database/code/both>` | `<error/rollback/fallback>` | `<path>:L<start>-L<end>` |

### Indexes and Access Paths

| Index/name | Fields/order | Query or access path supported | Uniqueness/partial condition | Evidence |
|---|---|---|---|---|
| `<index>` | `<field ASC/DESC>` | `<query or consumer>` | `<condition>` | `<path>:L<start>-L<end>` |

## Cross-Reference and Code-Usage Summary

Use this summary to make the field trace reviewable without replacing the
detailed sections above.

| Field | Assigned in | Read in | Queried in | Joined/sorted in | Exposed by | Evidence completeness |
|---|---|---|---|---|---|---|
| `<field>` | `<locations>` | `<locations>` | `<locations/predicate>` | `<locations>` | `<API/event/job>` | `<complete/partial/Unverified>` |

## Open Questions and Gaps

- `<schema or field fact still unresolved>` — Evidence checked: `<paths>`;
  owner/action: `<owner/action>`.
- `<missing User authority scope>` — Required before detailed analysis:
  `<scope>`.

## Completion Checklist

- [ ] Current User authority names the service and schema documentation scope.
- [ ] Detailed field-analysis authority explicitly covers the fields/code trace.
- [ ] Schema definition and physical storage have source evidence.
- [ ] Every documented field has type, nullability, default, meaning, and evidence.
- [ ] Every detailed field trace identifies assignment, transformation, reads, and
      query/filter/join usage or marks the item `Unverified`.
- [ ] Enum values and transitions are source-backed or explicitly User-confirmed.
- [ ] Relationships, constraints, and indexes are recorded or marked unknown.
- [ ] No placeholder remains in a claimed verified section.
- [ ] The real resource is indexed only after the file exists under
      `docs-harness/domain/<service-name>/schemas/`.
