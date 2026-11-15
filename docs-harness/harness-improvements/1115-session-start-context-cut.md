# Harness Improvement Resource

ID: #064_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Cut the session-start context load without losing routes
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- docs-harness/INDEX.md
- docs-harness/harness-improvements/README.md
- docs-harness/plans/completed/README.md
- docs-harness/plans/README.md
- docs-harness/templates/README.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-2/hooks/README.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- docs-harness/harness-improvements/1003-retire-missing-012-plan-route.md
- docs-harness/harness-improvements/1005-group-b-context-load-reduction.md
- docs-harness/harness-improvements/1115-harness-check-skill.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/harness-check/SKILL.md
- .agents/skills/harness-check/scripts/harness_check.py

## Objective

The files every session must read at start total at most 33,400 normalized
bytes (at least 25% below the 44,532-byte baseline the User accepted), INDEX
no longer grows with each improvement record or completed plan, and every
route stays reachable and checkable by `harness-check`.

## Purposes

- [x] Cut the context every session spends at start, now that a Claude
  subscription's usage allowance pays for it on every session.
- [x] Stop INDEX from growing with each new improvement record or completed
  plan.
- [x] Keep every route reachable and machine-checked, including the `#012`
  history the User chose to route.
- [x] Keep the hook switch where the User controls it (`#042` B8) while a
  dormant hook's body stays unread.

## Current State

Baseline (2026-11-15 12:22, Asia/Bangkok): `D:/repos/base-harness-repo`,
branch `main` at `377a0fc` (the Goal A commit, one ahead of `origin/main`),
worktree clean; Jev hook disabled.

Mandatory session-start reads, normalized bytes (CR removed):

| File | Bytes |
| --- | ---: |
| AGENTS.md | 324 |
| docs-harness/INDEX.md | 24,836 |
| docs-harness/SESSION.md | 5,747 |
| docs-harness/PERSONA.md | 2,219 |
| docs-harness/layers/README.md | 3,397 |
| docs-harness/layers/layer-2/hooks/README.md | 1,512 |
| docs-harness/layers/layer-2/hooks/jev-hook.md | 3,432 |
| docs-harness/project-constraints/README.md | 1,587 |
| docs-harness/project-constraints/1115-unit-test-authority.md | 1,760 |
| Total | 44,814 |

The total was 44,532 before `#063` added three INDEX lines. INDEX lists 48
improvement records and 11 completed plans; those sections take 9,345 and
1,993 bytes. INDEX was about 19,750 bytes on 2026-10-05 (`#042`). The manual
session-start alignment check lists names: one recursive listing of
`docs-harness/` with templates pruned prints 6,133 bytes, while
`harness-check --quick` prints 519. The jev-hook Activation block is the first
351 of its 3,432 bytes.

User decisions (2026-11-15, goal-griller and follow-up questions): apply all
three levers below; an INDEX back-link to a folder README that links each
record satisfies raw requirement init-harness-repo 1.4; route the `#012` file
as history with a provenance note and a notice on `#037`; commit Goal A first
(done as `377a0fc`).

## Proposed Improvement

(a) Move the improvement-record list into `harness-improvements/README.md`
and the completed-plan list into a new `plans/completed/README.md`; INDEX
keeps one link per list. Domain, constraint, active plan and ticket, and layer
routes stay in INDEX. (b) INDEX's session-start alignment check runs
`harness-check --quick`, with a manual fallback; the jev-hook exemption covers
that run. (c) Hook loading reads each hook through its `## Activation`
section and loads the rest only when checked; the checkbox stays in
`jev-hook.md`.

Update the owners that say where records are routed (INDEX routing rules,
`templates/README.md`, `plans/README.md`, `harness-improvements/README.md`,
improve-harness) and `harness-check`, which must validate entries in the
folder READMEs and report README-routed resources as a count.

Hypothesis: one more hop for history, plus a script in place of a manual
listing, cuts the start-up load by at least 25% while every route stays
reachable. Contrary evidence: a fresh agent cannot find a named record, skips
or misreads the quick check, reads a dormant hook's body anyway, or the byte
target is missed. Owner: INDEX's routing rules with the two folder READMEs and
`harness-check`. Revert a lever when a fresh replay shows agents losing the
route it moved.

## Scope

May change: the REFERENCES files above (only the dated notice in `#037`; only
the exemption sentence in `jev-hook.md`), the `.claude/skills/` mirrors of
the changed skills, and this record.

Unchanged: `#042` decisions B2, B3, B4 and B8 (no STATUS tokens in INDEX, skill
descriptions, the checkbox in `jev-hook.md`), IDs, file names, record bodies,
the `#012` file's content and `docs/raw-requirements/`. No push; a commit
needs the User's separate approval.

## Progress

- 2026-11-15: Baseline captured; record created before intervention edits.
- 2026-11-15: A one-off script moved the 48 improvement entries (plus this
  record) to `harness-improvements/README.md` and the 11 completed-plan
  entries (plus `#012`) to the new `plans/completed/README.md`, asserting
  each replaced passage. Updated INDEX (session start, layers, the two
  history sections, routing rules), `templates/README.md`, `plans/README.md`,
  `layers/README.md`, `hooks/README.md`, the `jev-hook.md` exemption, the
  `#037` notice, improve-harness and `harness-check`, with mirrors.
- 2026-11-15: Native checks, a seeded copy and one fresh replay shared with
  `#063` ran (see Validation). The replay's friction led to two wording fixes:
  INDEX now names the read-only alignment check and its RESULT line, and
  `hooks/README.md` allows a search for the checklist line. Both were checked
  natively, not re-replayed.

## Validation

Normalized bytes every session reads at start:

| File | Before | After |
| --- | ---: | ---: |
| AGENTS.md | 324 | 324 |
| docs-harness/INDEX.md | 24,836 | 14,938 |
| docs-harness/SESSION.md | 5,747 | 5,747 |
| docs-harness/PERSONA.md | 2,219 | 2,219 |
| docs-harness/layers/README.md | 3,397 | 3,414 |
| docs-harness/layers/layer-2/hooks/README.md | 1,512 | 1,677 |
| jev-hook.md (Activation section only while unchecked) | 3,432 | 351 |
| docs-harness/project-constraints/README.md | 1,587 | 1,587 |
| docs-harness/project-constraints/1115-unit-test-authority.md | 1,760 | 1,760 |
| `harness-check --quick` output (replaces a manual name listing of 6,133+) | — | 514 |
| Total | 44,814 | 32,531 |

The total is 26.9% below the accepted 44,532-byte baseline, within the
33,400-byte target. A new improvement record or completed plan now adds to a
folder README instead of INDEX.

Native: a full `harness-check` run routes all 64 resources with an ID (61
through the two folder READMEs); 62 INDEX links, the 64 ID entries in INDEX
and its folder READMEs, 942 local links and the skill mirror pass; the only
drift is the five pre-existing folders without README. `--quick` exits 0.
Line endings are consistent and mirrors byte-identical. A seeded copy showed
that `--quick` reports an improvement record dropped from the README list,
and `index-entries` reports a README entry with a wrong PRIORITY, a duplicate
entry and an entry whose file is missing (`links` reports the last one too);
nothing else changed.

Fresh replay (2026-11-15, fresh general-purpose read-only worker, shared with
`#063`; about 190k tokens and 52 tool calls in total):

- Session start (16 calls): it followed AGENTS.md, INDEX and SESSION.md, ran
  `--quick` (clean), then PERSONA, the layers walk and the project
  constraints. It read `jev-hook.md` only through its Activation section and
  did not apply the unchecked hook.
- History (5 calls): it found decision B8 in `#042` through INDEX,
  `harness-improvements/README.md` and the record.
- Checked hook (3 calls, disposable copy): it read the Activation line, saw it
  checked, read the rest and reported that the gate applies.
- Friction it reported: INDEX did not name the "alignment check", "report its
  drift rows" left a clean run's report unclear, it inspected the script
  before running it because INDEX did not call it read-only, and reading
  "through the Activation section" cost an extra search. The two wording
  fixes address these.

## Risks

- History sits one hop further from INDEX, so an agent may miss a record.
  Mitigation: the INDEX section names what the README lists and the
  "names an improvement record" branch; the replay checks it.
- Without Python 3 or a shell, the quick check cannot run. Mitigation: INDEX
  keeps a one-sentence manual fallback.
- A partial hook read could skip rules a checked hook needs. Mitigation: the
  rest of a hook loads whenever its checklist is checked; new hooks put their
  Activation section first.
- Restoring the `#012` route reverses part of `#037`. Mitigation: a dated
  notice on `#037` records the User decision and the unverified provenance.

## Decision and Result

Decision: keep. The start-up load fell to 32,531 normalized bytes (26.9% below
the accepted baseline, within the target), and a fresh agent reached the moved
history, ran the quick check and loaded only a dormant hook's Activation
section.

Limits: one bounded replay; the two wording fixes were checked natively, not
re-replayed. A session started from a checkout without these changes keeps the
old INDEX until they are committed. The replay prompt confused the review date
(2026-10-03) with the decision date (2026-10-05); the agent resolved it from
the record.
