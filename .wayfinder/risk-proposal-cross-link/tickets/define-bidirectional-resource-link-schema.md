---
id: WT-006
type: ticket
title: Define Bidirectional Risk–Proposal Resource Link Schema
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

How exactly should risk and proposal resources express reciprocal many-to-many
relationships while preserving the existing immutable ID and filename rules?
Decide the `REFERENCES` representation, canonical relative-link form, and
human-readable related-resource sections for both resource types.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Canonical relationship contract:

- `REFERENCES` contains canonical resource links whose labels use the immutable
  resource ID and whose targets use repository-relative Markdown paths.
- Risk resources link to proposals from `../proposals/`; proposal resources
  link to risks from `../risks/`.
- Risk resources add `## Related Proposals`; proposal resources add
  `## Related Risks`.
- The `REFERENCES` set and the corresponding human-readable related-resource
  set must be identical.
- A relationship is many-to-many: every related resource is listed on both
  sides, with no fixed cardinality limit.

Resource boundaries:

- Risk source-code evidence is recorded in a dedicated `## Evidence` section,
  not mixed into the canonical Risk–Proposal `REFERENCES` set.
- A proposal that addresses a risk carries `TAG: [RISK]`, but proposals are
  not standalone items in `docs-harness/INDEX.md`; risk entries remain the
  canonical INDEX route.
- Every canonical risk must link to at least one proposal, and every
  canonical proposal must link to at least one risk.

Integrity rules:

- IDs remain immutable even when a resource is renamed or moved.
- Rename or move operations must update all inbound links and the risk-only
  INDEX in the same bounded change.
- Missing reciprocal links, a mismatch between `REFERENCES` and related
  sections, dangling targets, or orphan resources are validation failures.
