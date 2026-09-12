# Harness Improvement Resource

ID: #015_IMPROVE_HARNESS_0906
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: One record per improvement
CREATED: 2026-09-06
STATUS: completed
REFERENCES:
- .agents/skills/improve-harness/SKILL.md
- docs-harness/harness-improvements/README.md
- docs-harness/templates/harness-improvement.md
- docs-harness/templates/README.md
- docs-harness/plans/README.md
- docs-harness/INDEX.md

## Objective

Every new authorized improvement creates its own MMDD-description.md record in
docs-harness/harness-improvements/. Continuing the same improvement updates the
existing record. The User explicitly accepted this distinction after goal-griller
clarification; this is the record for implementing that accepted change.

## Current State

Baseline: D:/repos/base-harness-repo, main, c4c8389. The worktree already contains
the behavior-parity repair and its #014 plan; preserve those changes. Previously
the skill only required a record when durable memory was needed and routed
completion through plans/completed/. The improvement folder contained README.md
only. Evidence: the previous skill baseline and the folder listing.

## Proposed Improvement

Make recording mandatory for a new improvement, with objective/scope-based
continuation, stable identity and completion in place. Keep legacy plan records
in their existing location. The existing template, metadata allocator rules and
structural validator suffice; no new script or runtime dependency is needed.
Hypothesis: explicit create/resume branches prevent both missing records and
duplicate records on continuation. Revise if a fresh scenario chooses otherwise.

Historical note (2026-09-12): the structural validator named by this completed
record was retired by improvement #017. The validation result below records
past evidence and is not a current Harness requirement.

## Scope

Change the improve-harness skill, its folder guide, improvement template,
template catalog and plan-lifecycle cross-reference; add this record and its
INDEX route and exact ignore exception. No migrations/deletions of old records,
validator code changes, unrelated policy decisions, commits or pushes.
Authority is the User's request and acceptance, not this record itself.

## Progress

- 2026-09-06: User chose new improvement -> new file; continuation -> same file.
- 2026-09-06: Created this record and updated the owning guidance and consumers.
- 2026-09-06: Fresh replay returned correct record/lifecycle actions for all seven
  scenarios. Clarified the catalog's domain-only confirmation-tag wording after
  the reviewer found it could be misread as applying to improvement records.

## Validation

- node .agents/validators/sync-harness-index.js --check: exit 0; tree, sections,
  links, routes, metadata, IDs, domain and risk-link checks passed.
- git diff --check: exit 0; only existing Windows LF/CRLF conversion warnings.
- Read-only Node check: unchanged skill frontmatter/invocation; required owner
  paths resolve; both active and simulated completed-in-place record pass the
  structural engine while preserving #015_IMPROVE_HARNESS_0906 and its path.
- Exact .gitignore exception exposes this new record without changing the
  repository's broader ignore policy.
- skill-creator's Python quick_validate.py was not run: available python/python3
  commands still resolve to Windows Store aliases, not the usable interpreter
  required by that helper. Used bounded Node/frontmatter and owner checks instead;
  no interpreter or dependency installation.
- Fresh read-only instruction replay by improvement_record_replay: all seven
  cases returned the intended actions: create a record for a bounded improvement;
  reuse path/ID/date on continuation; allocate a distinct file/ID for a different
  same-day improvement; complete in place; preserve a legacy plan's path/lifecycle;
  create nothing for a read-only inquiry; record an evidence gap and pause the
  intervention when insufficiently grounded. The agent retrieved the changed
  skill and routed owners, without reading this report or prior conclusions.
  Scenario answers were simulated, not real filesystem creation or a production
  effectiveness measurement. Its metadata-ambiguity finding was repaired at the
  catalog owner; the independent focused recheck passed and confirmed the seven
  scenario outcomes remain valid. No fixture-producing test is needed.

## Risks

- Risk: completion guidance could move the new record out of its requested
  folder. Proposal: complete in place and test the completion scenario.
- Risk: continuation could create a duplicate or overwrite another improvement.
  Proposal: compare objective/scope, preserve identity and distinguish collisions.
- Risk: old plan history could be unintentionally migrated. Proposal: preserve
  existing paths and require a separate User request for migration.
- Recovery: reverse only this intervention's hunks; preserve the pre-existing
  dirty worktree and the accepted outcome's evidence.

## Decision and Result

Decision: keep.
Owner: main agent. The skill now requires a record for each new authorized
improvement and updates the same record on continuation. This first record is
completed in place after structural checks and the seven-case fresh scenario
replay, with the metadata clarification independently rechecked. Existing
records and unrelated worktree changes remain preserved. This bounded evidence
does not certify future model behavior or production effectiveness.
