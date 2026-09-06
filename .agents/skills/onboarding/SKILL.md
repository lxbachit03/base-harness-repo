---
name: onboarding
description: Map a named brownfield business or data flow into an evidence-backed workspace and bounded uncertain domain context.
---

# Onboarding Brownfield Flows

Read AGENTS.md, docs-harness/INDEX.md, then the relevant resources and
docs-harness/onboarding/README.md. That guide owns artifact selection;
docs-harness/domain/README.md owns capture, tracing, confirmation, and freshness.

## 1. Select the flow

Identify one kebab-case flow name, entry point, terminal result, contracts, and
source boundaries. Follow only its dependencies. Inspect answers available in
the repository instead of asking the User to repeat them.

Done when the scope is concrete and any policy ambiguity is explicit.

## 2. Trace and record evidence

Create or reuse docs-harness/onboarding/<flow-name>/README.md within the requested task.
Use a compact trace for a small flow; add the standard five evidence artifacts
when a multi-step E2E investigation benefits from them. Read the diagram
template when needed. Cover data transformation, models, integrations, and
edge cases with sources or explicit unknowns.

Distinguish observed behavior from authoritative requirements. Cite implementation
steps with file/line ranges or symbol/revision; mark external actors explicitly.
Record configuration names and ownership, never secret values.

Done when each material flow claim has evidence and uncovered branches are named.

## 3. Capture and hand off

Apply docs-harness/domain/README.md to the bounded domain capture, IDs, confirmation, and
freshness impact check. Keep exploration evidence in its owning flow workspace
and link it from the domain README. Update INDEX for new canonical resources
and folder changes, then run relevant structural checks.

Report the flow boundary, observed path, evidence, domain state, validation,
and unresolved decisions. Source contradictions block dependent claims, not
unrelated authorized work. File count alone is not completion evidence.
