# Domain Knowledge

This file owns domain capture, confirmation, layout, tracing, and freshness.
AGENTS.md owns task authority; templates and skills apply this contract.

## Capture and layout

Capture a domain when the User requests onboarding of a named flow, domain
addition (including domain-audit), ticket work that discovers domain behavior,
or Q&A explicitly marked as domain discovery. Ordinary Q&A stays in the answer.
A capture request includes the bounded domain and INDEX edits; it does not
confirm business policy.

Use docs-harness/templates/domain.md for the canonical
docs-harness/domain/<MMDD>-<lowercase-kebab-case-name>/README.md.
Optional data-flows/ and schemas/ support that README. Use the identity rules
in docs-harness/templates/README.md. Keep source artifacts in their ticket/onboarding
workspace and link them instead of copying transcripts.

Before creating the resource, establish one non-colliding scope and a concrete
source for every claim: repository path and line range, stable symbol with
revision, ticket/section, or recorded Q&A decision. Record contradictions and
questions; corroborate independent sources when practical.

New observed knowledge starts with separate TAG: [DOMAIN] and TAG: [UNCERTAIN]
lines. Only explicit User confirmation makes it [CONFIRMED]. Keep observed
implementation facts separate from accepted policy. Confirmation changes the
current tags, not the immutable ID or creation date.

## Schema and flow detail

Relevant read-only schema/field tracing is part of an authorized investigation;
it does not need a second permission solely because it follows assignments,
transformations, serialization, WHERE/JOIN/filter conditions, or consumers.
Follow only the named flow/schema and its necessary dependencies. Reading is
not authority to query live data, expose secrets, or mutate an external system.

Persist a schema summary only within authorized documentation/domain capture.
Use docs-harness/templates/domain-entity.md, populating applicable sections with evidence;
omit unrelated detailed sections or mark unverified claims explicitly. A
separate exhaustive schema audit needs an explicitly requested broader scope.
Use the service-flow template when E2E artifacts help explain the domain.

## Freshness after changes

Runtime logic, persistence, contract, or data-flow changes trigger an impact
check. First compare changed paths and symbols with domain REFERENCES and
evidence/dependency links. Read metadata/references before full domain bodies.
Include uncertain overlaps; clearly unrelated domains need no revalidation.

For each affected domain, recheck the affected claims and their dependent
claims. Check the whole resource only when the dependency boundary is unclear.
Record the changed sources, inspected scope, date, and result:

- Claims still hold: update citations as needed and record Freshness: CURRENT.
- A claim is contradicted or cannot be checked: record STATUS: needs-review and
  Freshness: STALE with the exact unresolved claim.
- Directly evidenced UNCERTAIN content may be updated within task authority.
  Preserve CONFIRMED statements until the User authorizes a changed policy;
  freshness metadata may flag them for review.

A source edit or line-number shift alone does not prove a domain claim false.
Resolve the current symbol/range and check meaning. Documentation-only edits
with no domain-contract effect do not trigger revalidation.

Pause only an action whose correctness depends on an unresolved claim.
Continue independent authorized work and propose the next verification or
User decision. A read-only request reports stale state inline and leaves files
unchanged. For an authorized code change, related freshness metadata and
routing maintenance are included in the task.
