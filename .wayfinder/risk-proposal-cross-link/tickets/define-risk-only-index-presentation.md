---
id: WT-010
type: ticket
title: Define Risk-Only INDEX Cross-Link Presentation
status: closed
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by:
  - WT-006
assignee: codex
claimed_at: 2026-08-10
resolved_at: 2026-08-10
---

## Question

How should `docs-harness/INDEX.md` present each risk and its related proposals
while listing risk items only? Decide the nested link format, preservation of
the supporting `proposals/` routing section, and how to avoid duplicating a
proposal as an independent INDEX resource.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

INDEX contract:

- `TAG: [RISK]` contains only canonical risk resource entries.
- Each risk entry displays its immutable ID, title, priority, and canonical
  risk link, followed by nested links to every related proposal.
- Proposal links may appear under multiple risk entries when the relationship
  is many-to-many; this repeats a relationship, not a canonical resource.
- Proposal resources never appear as independent INDEX items.
- A risk is not indexed until its proposal and reciprocal links are complete.
- Risk entries and their nested proposal links are sorted by immutable ID in
  ascending order for deterministic routing.

Supporting proposal routing:

- Keep the `proposals/` supporting-folder section and its Purpose/Read when/
  Skip when guidance.
- Replace the standalone “no proposal resources” resource list with guidance
  that proposals are reached through nested links under `TAG: [RISK]`.
- When the User intent concerns a proposal, route through the relevant risk
  entry and follow only its nested canonical proposal links.

Synchronization and failure:

- Create, move, rename, delete, or relationship changes update the nested
  INDEX links in the same bounded change.
- Missing nested links, dangling targets, out-of-order entries, or an
  incomplete risk/proposal pair are validation failures.
