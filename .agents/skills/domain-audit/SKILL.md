---
name: domain-audit
description: Add one source-backed domain to Harness and check the freshness of related knowledge.
disable-model-invocation: true
---

# Domain Audit

An explicit invocation requests one bounded domain addition. Read AGENTS.md,
docs-harness/INDEX.md, docs-harness/domain/README.md, and docs-harness/templates/domain.md first.
The domain guide owns capture, confirmation, schema tracing, and freshness;
this skill does not define a second authority gate.

## 1. Establish evidence

Use the named repository sources, active ticket/onboarding workspace, or
recorded discovery Q&A. Read the complete relevant source, select one domain
scope and slug, and map every claim to evidence. Preserve contradictions and
questions. A request to add a domain is sufficient capture intent; an existing
ticket/onboarding workspace is helpful evidence, not mandatory ceremony.

Done when the boundary and source map support the resource without guessed policy.

## 2. Check freshness

For runtime/contract changes, select affected domains by changed paths/symbols,
REFERENCES, and dependencies. Apply the domain guide's scoped claim check and
CURRENT/STALE rules. Continue independent work when a claim needs a decision.

Done when affected claims have an explicit result or a reported dependency.

## 3. Persist and verify

Use docs-harness/templates/README.md for collision checks and immutable identity. Create the
date-prefixed canonical README with evidence, confidence, freshness, and open
questions. New knowledge remains UNCERTAIN unless the User explicitly confirms
it. Keep detailed source artifacts with their owner.

Add applicable supporting schema/flow evidence, then update INDEX tree and
classification routes. Perform a targeted manual review of the tree, route
links, metadata, IDs, evidence state, and diff. Do not create or invoke a
repository validation script unless the User explicitly authorizes that proof;
report it as unattempted otherwise. Do not automatically commit ignored or
untracked domain files.

Report canonical path, sources, current classification, freshness results,
proof, and unresolved decisions. A source gap needs an evidence-gathering
proposal; a folder alone does not prove capture completeness.
