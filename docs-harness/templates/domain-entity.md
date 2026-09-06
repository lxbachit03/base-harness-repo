# Domain Entity / Schema Evidence

This is a supporting template for
docs-harness/domain/<MMDD>-<name>/schemas/<schema-name>.md.
Follow docs-harness/domain/README.md for scope, source evidence, tracing,
confirmation, and freshness. A supporting schema inherits its domain's identity;
assign separate resource metadata only when explicitly promoted to a canonical
resource under templates/README.md.

## Scope and Review

- Domain README: <relative link>
- Schema/entity and owner: <name and source>
- Task scope: <authorized investigation/documentation task>
- Last reviewed: <YYYY-MM-DD>
- Sources: <definition/migration/model paths and lines or symbols/revision>
- State: <Observed / User-confirmed policy / Unverified>

## Schema Meaning

<Purpose, identifier/storage, lifecycle, invariants, and what remains unknown.
Separate implementation facts from business intent.>

## Field Inventory

| Field | Type | Required/nullable | Default/key | Meaning | Evidence |
| --- | --- | --- | --- | --- | --- |
| <field> | <type> | <constraints> | <default/key> | <fact or Unverified> | <source> |

## Field Usage

Include this section for fields relevant to the investigation. Detailed tracing
is read-only work within that scope; it is not a separate approval step.
For an unrelated exhaustive schema audit, establish the expanded scope first.

| Field | Assigned/transformed in | Read/serialized by | Query/filter/join condition | Effect | Evidence |
| --- | --- | --- | --- | --- | --- |
| <field> | <locations and value source> | <consumers> | <actual predicate or None verified> | <branch/state effect> | <source> |

Record competing assignment paths, normalization/defaulting, null semantics,
bound parameters, downstream mappings, and concurrency/idempotency behavior
when relevant and verified. Do not infer meaning from names alone.

## Enums and State Transitions

| Enum/field | Value | Meaning | Allowed/forbidden transition | Unknown handling | Evidence |
| --- | --- | --- | --- | --- | --- |
| <enum> | <value> | <meaning> | <condition> | <behavior> | <source> |

## Relationships, Constraints, and Indexes

| Relationship/constraint/index | Fields | Rule or access path | Enforcement/failure | Evidence |
| --- | --- | --- | --- | --- |
| <name> | <fields/order> | <cardinality/predicate/rule> | <DB/code/Unverified> | <source> |

## Gaps and Freshness

<Affected claims, missing sources, or conflicting policy with next verification
or User decision. Link the canonical domain freshness result.>

## Completion

The named scope is covered with source-backed facts or explicit unknowns.
No placeholder is presented as verified. Links resolve, applicable claims were
checked, and documentation persistence stays within task authority.
