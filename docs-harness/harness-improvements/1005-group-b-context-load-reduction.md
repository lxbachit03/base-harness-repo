# Harness Improvement Resource

ID: #042_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Apply the User's group B decisions to reduce always-loaded Harness context
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- AGENTS.md
- README.md
- docs-harness/INDEX.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/WORKFLOW.md
- docs-harness/templates/README.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- .agents/skills/domain-audit/SKILL.md
- docs-harness/harness-improvements/0912-agent-self-validation.md
- docs-harness/harness-improvements/1003-optimization-review-correctness-fixes.md

## Objective

The User's group B decisions from the 2026-10-03 optimization review are
applied: Herdr rules live only in the `herdr-coordinate-agents` skill and its
references (AGENTS.md and INDEX.md keep routing, `HERDR-AGENTS.md` keeps only
the catalog, README keeps one summary sentence); the prohibition on creating
or invoking a repository validation script is removed while targeted
self-review stays; the always-loaded `layers/README.md` and `jev-hook.md` are
shorter; and INDEX drops duplicate legacy plan and template entries and lists
improvement records in ID order.

## Purposes

- [x] Cut the context every session loads (AGENTS.md, INDEX.md, layers
  README, active hook) without changing what agents must do.
- [x] Keep each Herdr rule in one owner, the skill, so changes are one-place
  edits.
- [x] Let agents use validation scripts when useful, while still reporting
  the evidence they inspected.

## Current State

Baseline (2026-10-05): branch `main` at `eebb57f`, level with `origin/main`,
worktree clean. Sizes: AGENTS.md 7,0 KB, INDEX.md 21,6 KB, layers/README.md
6,0 KB, jev-hook.md 3,4 KB, HERDR-AGENTS.md 37,2 KB.

User decisions (2026-10-05) on the review's group B:

| # | Decision |
| --- | --- |
| B1 | Option A: drop the 11 legacy plan entries repeated in INDEX `[IMPROVE_HARNESS]`; they stay in the `plans/` lifecycle routes |
| B2 | Not done (no STATUS tokens in INDEX entries) |
| B3, B4 | Not done (skill descriptions unchanged) |
| B5 (+C1) | Herdr rules only in the skill: remove from AGENTS.md and INDEX.md; `HERDR-AGENTS.md` keeps only the catalog; README.md keeps one summary sentence |
| B6 | Remove the "do not create or invoke a repository validation script" rule; keep targeted self-review and evidence reporting |
| B7 | Trim explanatory text in `layers/README.md`, keeping rules and recorded User decisions |
| B8 | Toggle rules only in `hooks/README.md`; `jev-hook.md` keeps its checkbox |
| B9 | Items 1–2: drop template links repeated in the INDEX `tickets/` section; sort the improvement list by ID |

Rules found only in `HERDR-AGENTS.md` (not in the skill or its references,
grep 2026-10-05): resolve and record the exact provider model ID when an entry
lists several; no global `config.toml` change; inspect capabilities in the
worker's own `CODEX_HOME`, recording names/state only; no Codex flags on a
non-Codex process; no global wildcard or shared-settings rewrite to make an
unverified adapter look ready.

## Proposed Improvement

Move those five rules into `herdr-runtime.md` first, then reduce
`HERDR-AGENTS.md`; edit the other owners per the table; add a current-policy
notice to `#017`; mirror skill files.

## Scope

May change: files in REFERENCES, their `.claude/skills/` mirrors, this
record, its INDEX entry and `.gitignore` allow line.

Unchanged: the catalog's model entries, checklists, selections, template,
Resolved worker evidence and Sources; skill descriptions; groups C (except
C1), P and F.

## Progress

- 2026-10-05: Record created before edits.
- 2026-10-05: Applied B1, B5+C1, B6, B7, B8, B9 (items 1–2). Five Herdr rules
  were added to `herdr-runtime.md` before `HERDR-AGENTS.md` lost its rule
  sections; its adapter-table pointer to the removed `agy` note now points to
  the runtime reference. B1 also needed one routing-rule exception in
  `templates/README.md`, INDEX "Resource Routing Rules" and
  `harness-improvements/README.md`. B8 moved "a workspace switch" into the
  `hooks/README.md` load points. #017 received a current-policy notice.
- 2026-10-05: The replay answered all four questions correctly and found
  leftovers, all fixed: the Herdr skill's self-check still said no validation
  script may be invoked; `HERDR-AGENTS.md` still held three rule sentences (the
  "runtime evidence wins" rule moved to `herdr-runtime.md`, the other two
  already lived there); INDEX labelled the AGENTS link "Manual
  self-validation"; and "an unchecked hook is dormant" existed only in the
  removed `jev-hook.md` text, so it was added to `hooks/README.md`.

## Validation

- Native: sizes before/after; every rule removed from `HERDR-AGENTS.md` is
  present in the skill or its references; no reference to removed headings;
  validator-prohibition text absent from current guidance; INDEX links
  resolve; no record lost from INDEX routing; IDs unique; mirror diff.
- Fresh replay: a fresh read-only worker, from the repository alone, explains
  how to select and launch a Herdr worker (finding the rules through the
  skill), whether it may write a validation script, and whether a checked
  hook's toggle rules are still discoverable.

## Risks

- Agents that read only AGENTS.md lose the inline Herdr launch reminders.
  Mitigation: AGENTS.md still routes every delegation to the skill, which
  carries the rules.
- Removing the validator prohibition reverses part of `#017`. Mitigation:
  a current-policy notice on `#017` records the User decision.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05), sizes in bytes with line endings normalized:

| File | Before | After | Load |
| --- | --- | --- | --- |
| AGENTS.md | 6,810 | 6,211 | every session |
| docs-harness/INDEX.md | 21,567 | ~19,750 | every session |
| docs-harness/layers/README.md | 5,934 | 3,382 | every session |
| docs-harness/layers/layer-2/hooks/jev-hook.md | 3,343 | 3,046 | every session while checked |
| docs-harness/HERDR-AGENTS.md | 36,190 | 25,078 | on demand |
| README.md | 4,056 | 2,943 | human-facing |

- No validation-script prohibition remains in AGENTS.md, README.md,
  WORKFLOW.md, INDEX.md or any skill; self-review and evidence reporting
  remain in AGENTS.md, WORKFLOW.md, INDEX.md and domain-audit.
- AGENTS.md and INDEX.md carry no Herdr launch rules; every rule removed from
  `HERDR-AGENTS.md` is present in the skill or its references (grep per rule);
  no file references a removed heading.
- Every resource ID under `docs-harness/` (templates excluded) is still
  routed in INDEX; the `[IMPROVE_HARNESS]` list is in ID order; INDEX links
  resolve; no duplicate IDs; `.agents`/`.claude` differ only by line endings.

Fresh replay (fresh native general-purpose read-only worker, 2026-10-05): it
reached the Codex launch rules through AGENTS.md → the Herdr skill →
`herdr-runtime.md`, including the moved `config.toml` and `CODEX_HOME` rules;
answered that a link-check script is allowed while self-review evidence is
still required; found the hook toggle rules in `hooks/README.md` through the
`jev-hook.md` pointer; and found legacy plans in the `plans/` routes through
the new INDEX note. Leftovers it reported were fixed (see Progress); the
fixes were checked natively, not re-replayed.

Not done by User decision: B2 (STATUS tokens in INDEX), B3 and B4 (skill
descriptions).

Limits: the replay worker's own startup context carried the committed
AGENTS.md, so the working-tree answers take effect for sessions only after
commit.
