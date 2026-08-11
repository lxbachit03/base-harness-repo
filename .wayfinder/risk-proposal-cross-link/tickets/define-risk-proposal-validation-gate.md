---
id: WT-011
type: ticket
title: Define Risk–Proposal Reciprocal-Link Validation Gate
status: closed
assignee: codex
resolved_at: 2026-08-10
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by:
  - WT-008
  - WT-009
  - WT-010
---

## Question

What observable checks prove that every canonical risk has at least one
proposal, every relationship is reciprocal, every target link and ID is valid,
and `INDEX.md` contains risk items only? Decide the static validation command
or procedure and the exact completion failure behavior.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Canonical validation gate:

- The execution handoff exposes one deterministic, read-only repository-local
  entry point, invoked from the repository root as
  `bash .agents/validators/validate-risk-proposal-links.sh`.
- The validator scans the current filesystem, including untracked canonical
  resources, and does not require a clean Git worktree, stage/commit/reset
  files, use an external tracker, or access the network.
- Its scope is `docs-harness/INDEX.md`, canonical Markdown files directly under
  `docs-harness/risks/` and `docs-harness/proposals/`; `README.md`, templates,
  symlinks, nested resources, and paths outside the repository are excluded or
  rejected according to the scope contract.

Validation order and invariants:

1. Capture a file-list/content-hash snapshot and reject scope changes during
   the run as indeterminate.
2. Validate inventory, required metadata (`ID`, `TAG`, `PRIORITY`, `TITLE`,
   `CREATED`, `STATUS`, and `REFERENCES`), required sections, immutable global
   ID uniqueness, ID format, and `<MMDD>-<kebab-case>.md` filenames.
3. Validate canonical relative Markdown links: every target exists, stays in
   the expected folder, has the referenced immutable ID, and has the expected
   title. External, absolute, dangling, duplicate, or malformed links fail.
4. Validate that every risk has at least one proposal and every proposal has
   at least one risk; the relationship is many-to-many and reciprocal.
5. Compare the normalized immutable-ID sets in `REFERENCES` and the matching
   related-resource sections. Any mismatch, one-way link, or orphan fails.
6. Validate the risk-only `INDEX.md`: every risk appears exactly once, every
   nested proposal relationship is present, all links resolve, risk and nested
   proposal IDs are sorted ascending, and proposals never appear as
   independent resources. The supporting `proposals/` section contains only
   routing guidance.
7. Recompute the snapshot before returning success.

The risk INDEX grammar is strict. A risk is a top-level item containing its
priority and nested proposal links, for example:

```markdown
- [#001_RISK_0810 Risk title](risks/0810-risk-title.md) — PRIORITY: [CRITIAL]
  - Proposal: [#002_RISK_0810 Proposal title](proposals/0810-proposal-title.md)
```

The gate checks that `STATUS` is present and non-empty but does not invent or
enforce a complete lifecycle enum. `OPEN` risks and `PROPOSED` proposals are
valid; `ACCEPTED` or `REJECTED` proposals remain valid only while their
canonical relationships are intact. With zero canonical resources, the gate
passes and reports zero risks/proposals while still validating INDEX structure.

Diagnostics and completion behavior:

- Run all independent checks and emit deterministic diagnostics containing a
  stable rule code, relative path, line when available, expected/actual
  values, and the related resource or target. Report scanned counts and the
  final snapshot result.
- Exit `0` only when every invariant passes on a stable snapshot. Exit `1`
  means a contract violation; exit `2` means a tooling, parse, or snapshot
  failure. Both non-zero results block completion.
- The validator never auto-fixes. Within an authorized bounded change, repair
  safely and rerun the gate. If repair is unsafe or impossible, roll back only
  newly created resources and INDEX changes from that change, preserve
  pre-existing or unrelated changes, report the blocker, and do not claim
  completion.
- A pre-existing invalid state outside the current authorized scope is
  reported, not silently repaired; the agent cannot claim an outcome that
  depends on a failing gate.
- Implementing the validator script or CI integration is execution work after
  this Wayfinder decision and is not part of resolving this ticket.
