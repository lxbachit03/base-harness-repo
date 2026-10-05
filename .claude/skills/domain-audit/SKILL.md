---
name: domain-audit
description: Record domain knowledge the User confirmed (a service or an E2E data flow, typically after onboarding) into docs-harness/domain and check the freshness of related knowledge.
disable-model-invocation: true
---

# Domain Audit

An explicit invocation requests one bounded domain addition: the business
domain, service or E2E data flow the User confirmed, typically after reading
an onboarding workspace. Read AGENTS.md,
docs-harness/INDEX.md, docs-harness/domain/README.md, and docs-harness/templates/domain.md first.
The domain guide owns capture, confirmation, schema tracing, and freshness;
this skill does not define a second authority gate.

## 1. Establish evidence

Use the named repository sources, active ticket/onboarding workspace, or
recorded discovery Q&A. Read the complete relevant source, select one domain
scope and slug, and map every claim to evidence. Preserve contradictions and
questions. A request to record a User-confirmed domain is sufficient capture
intent; an existing ticket/onboarding workspace is helpful evidence, not
mandatory ceremony.

Done when the boundary and source map support the resource without guessed policy.

## 2. Check freshness

For runtime/contract changes, select affected domains by changed paths/symbols,
REFERENCES, and dependencies. Apply the domain guide's scoped claim check and
CURRENT/STALE rules. Continue independent work when a claim needs a decision.

Done when affected claims have an explicit result or a reported dependency.

## 3. Persist and verify

Use docs-harness/templates/README.md for collision checks and immutable identity. Create the
date-prefixed canonical README with evidence, confidence, freshness, and open
questions. Tag the resource [CONFIRMED] for the scope the User explicitly
confirmed, and list anything the User did not confirm as open questions. If
the User has not confirmed the scope, ask before persisting; unconfirmed
discovery belongs to onboarding as [UNCERTAIN] context. If an [UNCERTAIN]
resource for this scope already exists, promote its tags in place, keep its
ID and creation date, and move its claims the User did not confirm into open
questions. Keep detailed source artifacts with their owner.

Add applicable supporting schema/flow evidence, then update INDEX tree and
classification routes. Perform a targeted manual review of the tree, route
links, metadata, IDs, evidence state, and diff, and report the evidence
inspected. Do not automatically commit ignored or untracked domain files.

Report canonical path, sources, current classification, freshness results,
proof, and unresolved decisions. A source gap needs an evidence-gathering
proposal; a folder alone does not prove capture completeness.
