---
id: WT-005
type: ticket
title: Define Codebase Risk Evidence and Promotion Rules
status: closed
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by: []
assignee: codex
claimed_at: 2026-08-10
resolved_at: 2026-08-10
---

## Question

What minimum observable evidence promotes a concern found in the codebase to a
canonical risk resource? Decide the required source path/line or symbol,
affected behavior, risk category, impact, indicators, and the handling of
uncertain, unreproducible, or non-material observations.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Promotion rule:

- Promote a finding to a canonical risk only when it is a material security,
  performance, or memory-leak concern with a concrete execution or data path
  and a plausible impact.
- Do not promote a generic code smell or a speculative concern without a
  concrete path and impact.

Required evidence:

- Repository-relative source path.
- Line and/or stable symbol locator; the line is a locator, not the sole
  identity of the evidence.
- Affected behavior or data flow.
- At least one risk category: `security`, `performance`, or `memory-leak`.
- Impact and observable indicators.
- Commit/ref or working-tree state when available so the evidence can be
  rechecked against the observed code.

Scope and grouping:

- Evidence may come from first-party code, configuration, or infrastructure
  controlled by the repository.
- Vendor, dependency, or generated output is excluded unless the repository
  controls the relevant source or artifact.
- One canonical risk represents one root cause and impact; multiple source
  references may support that risk.
- A risk may carry multiple applicable categories.

Uncertainty handling:

- Strong static evidence may create an `OPEN` risk without runtime
  reproduction; uncertainty must be recorded in `Indicators` or `Verification`.
- An uncertain or unreproducible observation without sufficient path/impact
  evidence remains a response-level observation, with the missing evidence
  identified; it does not create a canonical risk or proposal artifact.
