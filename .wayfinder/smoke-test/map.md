---
id: WT-001
type: map
title: Wayfinder Local-Markdown Compatibility Smoke Test
status: closed
labels:
  - wayfinder:map
tracker: local-markdown
test: true
---

## Destination

Prove whether the current Harness repository can host a local-Markdown
Wayfinder map with child tickets, blocking metadata, and a discoverable
frontier without changing the existing Harness routing or product files. This
smoke test ends with compatibility evidence and a recorded limitation list;
it does not implement a product or the base scaffold.

## Notes

- Test subject: current Harness repository on branch `v1-wayfinder-skill`.
- Authority: `AGENTS.md`, `docs-harness/INDEX.md`, `docs/README.md`, and
  `docs/WORKFLOW.md`.
- Tracker: local Markdown only; no external tracker setup.
- Companion skills are present under `.agents/skills/` and were used for the
  HITL compatibility decision.
- This is a disposable smoke-test map, not the base-repository effort.

## Decisions so far

- [Verify Local-Markdown Map, Child Ticket, and Frontier Representation](tickets/verify-local-markdown-map-and-frontier.md) — local Markdown can represent the map, child relation, blocking/frontier metadata, and claim without changing Harness routing.
- [Decide Whether the Current Harness Supports Wayfinder Work-through](tickets/decide-wayfinder-harness-compatibility.md) — full compatibility is accepted for the local-Markdown lifecycle with the required companion skills and no external tracker.

## Not yet specified

<!-- No unresolved fog remains for this smoke-test destination. -->

## Out of scope

- Product or application implementation.
- Base-repository architecture decisions.
- External issue-tracker installation.
