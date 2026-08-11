---
id: WT-004
type: map
title: Risk Detection to Proposal Cross-Link Policy
status: closed
labels:
  - wayfinder:map
tracker: local-markdown
---

## Destination

Produce an implementation-ready Harness policy for codebase risk findings:
every confirmed risk gets a proposal artifact in the same bounded change,
risk and proposal resources cross-link in both directions, and `INDEX.md`
lists risk items only. The map ends with a complete policy and validation gate;
it does not implement runtime risk scanning or risk mitigation.

## Notes

- Domain: Harness context and resource governance.
- Skills every session should consult: `grilling` and `domain-modeling`.
- Authority: the User-confirmed answers in this session, `AGENTS.md`,
  `docs-harness/INDEX.md`, and the risk/proposal templates.
- Tracker: local Markdown under `.wayfinder/`; no external issue tracker is
  configured.
- `Codebase risk` means a material security, performance, or memory-leak issue
  found in the codebase and promoted to a canonical `TAG: [RISK]` resource.
- `Proposal` means a resource under `docs-harness/proposals/` that records
  options, a recommendation, decision status, consequences, and rollback; one
  proposal may address multiple risks.
- `Cross-link` means reciprocal relative links with immutable resource IDs in
  `REFERENCES` and human-readable related-resource sections.
- User-confirmed constraints: documentation policy only; trigger on codebase
  discovery; at least one proposal per risk; many-to-many relationships;
  reciprocal links; risk-only entries in `INDEX.md`; codebase evidence is
  required; risk and proposal creation is one bounded change; unknown
  mitigations remain `OPEN`/`PROPOSED`; missing reciprocal links fail
  validation.
- Existing `docs-harness/risks/` and `docs-harness/proposals/` contain no
  canonical resources to migrate. Existing `/docs` content remains out of
  scope.

## Decisions so far

- [Define Codebase Risk Evidence and Promotion Rules](tickets/define-codebase-risk-evidence-and-promotion-rules.md) — a canonical risk requires material impact, concrete first-party code/config/infra evidence, category, and observable indicators; static evidence can be `OPEN` without runtime reproduction, while weak observations remain non-canonical.
- [Define Bidirectional Risk–Proposal Resource Link Schema](tickets/define-bidirectional-resource-link-schema.md) — reciprocal relative-ID links live in `REFERENCES` and mirrored related-resource sections; many-to-many and orphan-free integrity is required, while code evidence stays in a dedicated risk section.
- [Define Artifact-Creation Authorization Boundary](tickets/define-artifact-creation-authorization-boundary.md) — canonical artifacts may be written only within the current authorized bounded change; read-only and explicitly code-only scopes remain non-mutating, and authority never carries across prompts.
- [Define Atomic Risk-to-Proposal Creation and Failure Recovery](tickets/define-atomic-risk-to-proposal-workflow.md) — validate evidence and authority first, render and link the pair, update risk-only INDEX, validate, and treat any incomplete pair/index state as recoverable failure rather than completion.
- [Define Risk-Only INDEX Cross-Link Presentation](tickets/define-risk-only-index-presentation.md) — `TAG: [RISK]` contains the only canonical entries; proposals are deterministic nested links reached through risks, while the supporting proposals section provides routing guidance without listing proposal items.
- [Define Proposal Handling When Mitigation Is Unknown](tickets/define-unknown-mitigation-proposal-handling.md) — unknown mitigation remains `OPEN`/`PROPOSED`; proposals document evidence gaps, investigation, residual risk, options, and rollback without inventing a solution or closing the risk.
- [Define Risk–Proposal Reciprocal-Link Validation Gate](tickets/define-risk-proposal-validation-gate.md) — a deterministic read-only gate checks metadata, IDs, paths, reciprocal relationships, and risk-only INDEX integrity; exit `0` requires a stable complete snapshot, while contract, tooling, parse, or snapshot failures block completion.

## Not yet specified

<!-- No unresolved fog remains for this destination. -->

## Out of scope

- Implementing a runtime or static risk scanner.
- Implementing product-code risk mitigations.
- Migrating, copying, or moving `/docs` content.
- Installing or integrating an external issue tracker.
