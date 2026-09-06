# Resource Templates and Identity

This file owns template selection and resource identity. AGENTS.md owns task
authority; workflow guides own behavior. Read the matching template before
creating a resource. Templates contain placeholders and are not domain truth.

## Catalog

- [plan.md](plan.md): canonical durable plan with metadata and result.
- [exec-plan.md](exec-plan.md): compatibility pointer; no separate plan contract.
- [harness-improvement.md](harness-improvement.md): experiment-specific sections
  used with the plan lifecycle.
- [constraint.md](constraint.md): file/folder/task boundaries.
- [decision.md](decision.md): accepted lasting choices.
- [domain.md](domain.md): canonical date-prefixed domain README.
- [domain-entity.md](domain-entity.md): relevant schema/field evidence.
- [activity-diagram.md](activity-diagram.md): cited flow diagrams.
- [risk.md](risk.md) and [proposal.md](proposal.md): durable paired risk tracking.
- [ticket.md](ticket.md): every ticket's source, result, and evidence.
- [apis.md](apis.md), [entities.md](entities.md): applicable ticket inventories.
- [ticket-docs-README.md](ticket-docs-README.md): manifest when artifacts exist.
- [{service-name}/README.md]({service-name}/README.md): E2E service-flow scaffold.
- [{ticket-number}-{single-ticket}/README.md]({ticket-number}-{single-ticket}/README.md)
  and [{sample-big-ticket}/README.md]({sample-big-ticket}/README.md): layout examples.

Follow ../domain/README.md for capture, confirmation, tracing, and freshness;
follow ../tickets/README.md for optional ticket artifacts. Existing evidence
files are preserved when adopting the smaller layout.

## Common metadata

Canonical classified resources use ID, TAG, PRIORITY, TITLE, CREATED, STATUS,
and REFERENCES before their first level-two heading. Use exactly one priority:
[CRITIAL], [MEDIUM], or [NORMAL]. The existing CRITIAL spelling is retained for
compatibility. Choose it from evidenced impact; do not fill an empty index.

Use one TAG line per classification: [IMPROVE_HARNESS], [CONSTRAINTS], [RISK],
or [DOMAIN] plus exactly one [CONFIRMED]/[UNCERTAIN] line. Combined legacy domain
tags remain readable. A supporting plan or decision with no applicable
classification may omit TAG; its folder supplies its route. Do not invent a
product domain or a new TAG solely to file a plan.

A canonical file is stored once and linked from every applicable classification
and lifecycle route. Templates, ordinary tickets, and child evidence artifacts
do not receive independent resource IDs. A schema may remain supporting evidence
linked from its canonical domain; give it an ID only when separately promoted.

## Immutable identity

Before creating a resource, discover real ID metadata across docs-harness/,
excluding templates. Select the next global sequence, max + 1, padded to at
least three digits. Use #<sequence>_<creation-kind>_<MMDD>.
Creation kind is the applicable classification (DOMAIN_UNCERTAIN or
DOMAIN_CONFIRMED for a domain); an unclassified supporting plan/decision may
use PLAN/DECISION. Creation kind records origin, not current classification.
A confirmation changes TAG and routing without changing the ID.

CREATED uses YYYY-MM-DD and MMDD uses the creation date in Asia/Bangkok.
Preserve creation date and ID after moves, promotion, and content updates.
Name ordinary resources <MMDD>-<lowercase-kebab-case-meaning>.md, without ID.
A domain uses <MMDD>-<name>/README.md instead.

Recheck IDs and target existence immediately before creation. Allocate IDs in
one sequence when coordinating writers, then check the merged result for
duplicate full IDs and reused numeric sequences. If another writer took an ID,
choose the next unused ID for the not-yet-created resource. Never reassign an
existing ID or overwrite a colliding file; resolve ambiguous collisions with
the User. This is collision detection, not a concurrent allocation lock.

## Routing and proof

After creating a resource, update INDEX tree, classification, and lifecycle
links in the same task. Content-only changes need no INDEX rewrite unless
routing metadata changed. Resolve relative links and duplicate IDs before
completion. Static checks do not confirm business facts.

Persisted risk/proposal pairs follow the canonical constraint; inline risks in
a task can stay inline with a proposal. Keep accepted decisions separate from
unaccepted recommendations. Templates keep stable names and no real IDs.
