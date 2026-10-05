# Harness Improvement Resource

ID: #040_IMPROVE_HARNESS_1003
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Record metadata cleanup from the 2026-10-03 optimization review (group E)
CREATED: 2026-10-03
STATUS: completed
REFERENCES:
- docs-harness/harness-improvements/0907-bale-herdr-orchestration.md
- docs-harness/harness-improvements/0912-herdr-agent-catalog.md
- docs-harness/harness-improvements/0930-layer-2-hooks-and-jev-gate.md
- docs-harness/harness-improvements/1003-retire-missing-012-plan-route.md
- docs-harness/harness-improvements/1003-init-harness-repo-skill.md
- docs-harness/harness-improvements/1003-optimization-review-correctness-fixes.md
- .gitignore

## Objective

Record metadata, cross-links and `.gitignore` allow lines are consistent, with
every record's content, history and decisions unchanged: superseded Herdr
records point to the records that replaced their policy, `#036` uses a plain
STATUS value, `#037`/`#038` REFERENCES resolve, and every tracked record has
an explicit allow line, including the `plans/completed/` target of each active
legacy plan.

## Purposes

- [x] Stop a reader of a superseded record from treating its "keep" decision
  as current policy.
- [x] Keep status filters and reference checks exact without rewriting history.
- [x] Prevent a plan moved from `active/` to `completed/` from silently
  dropping out of git tracking.

## Current State

Baseline (2026-10-03): branch `harness/optimization-review` at `acb5035`,
worktree clean. Source: group E of the read-only optimization review (records
reviewer); the User accepted group E on 2026-10-03.

| # | Finding | Evidence (baseline) |
| --- | --- | --- |
| E1 | `#016` keeps mandatory GPT-5.6 Luna workers and detached worktrees with no forward link; `#018` replaced the Luna rule, `#024` forbids worktrees; `#018` has no link to `#016` or to `#022`, which replaced its mandatory pre-submission preflight | `0907-bale-herdr-orchestration.md:20,82`; `0912-herdr-agent-catalog.md:21`; `0919-herdr-shared-checkout.md:18,23`; `0913-opencode-windows-launch-and-lean-herdr.md:26` |
| E2 | Non-standard STATUS value | `0930-layer-2-hooks-and-jev-gate.md:8` |
| E3 | REFERENCES entries that do not resolve | `1003-retire-missing-012-plan-route.md:11` (an ID); `1003-init-harness-repo-skill.md:14` (`GOAL.md`, no longer present) |
| E4 | 11 tracked records have no allow line (`git check-ignore --no-index`), and the 8 active legacy plans have no `plans/completed/` allow line for their lifecycle move | `.gitignore:7,38,40,43`; header `.gitignore:1-2` |

## Proposed Improvement

Add a dated "Current policy notice" under the metadata of `#016` and `#018`,
following the pattern of `plans/completed/0815-writing-for-agents-routing.md`.
Use `STATUS: completed` in `#036` and move its revision note into Progress.
Point `#037` REFERENCES at the `#026` path; mark `GOAL.md` as not retained in
`#038`. Add the allow lines.

## Scope

May change: the records in REFERENCES (metadata, notices, REFERENCES and
Progress lines only), `.gitignore` allow lines, this record and its INDEX
entry.

Unchanged: every record's Objective, evidence, decision and result text; the
`.gitignore` deny-all design (whether to replace it is a User decision raised
in `#026` and still open); about 40 tracked non-record files under
`docs-harness/` that also lack allow lines (same open decision); groups B–D.

## Progress

- 2026-10-03: Record created before edits.
- 2026-10-03: E1–E4 applied. `#036` already recorded its 2026-09-30 revision
  in Progress, so only the STATUS line changed plus a dated Progress line.
  Native checks and one fresh replay passed.

## Validation

- Native: `git check-ignore --no-index` returns no record path; each
  anticipatory allow line matches an active legacy plan filename; REFERENCES
  paths resolve; INDEX links resolve; IDs unique; `git diff` touches only
  metadata, notice, REFERENCES and Progress lines in existing records.
- Fresh replay: a fresh read-only worker asked for the current Herdr worktree
  and worker-model policy, starting from `#016`, follows the notice to the
  current records and policy owners.

## Risks

- A notice could be read as rewriting history. Mitigation: the notice states
  that the record keeps its original evidence and decision.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-03): no tracked file under `plans/` or
`harness-improvements/` matches an ignore rule (`git check-ignore --no-index`);
each of the 9 active plans has a matching `plans/completed/` allow line, and a
simulated move target for each is not ignored; REFERENCES of `#037` and this
record resolve; the four notice links resolve; INDEX links resolve; no
duplicate IDs; STATUS values are only `active`/`completed`. The diff changes 3
existing lines (`#036` STATUS, two REFERENCES entries); every other change is
an addition.

Fresh replay (fresh native general-purpose worker, read-only): given only the
`#016` file and a teammate's question whether workers should run GPT-5.6 Luna
at max effort in detached worktrees, it quoted the new notice
(`0907-bale-herdr-orchestration.md:16-25`), followed it to `#018`, `#024`,
`HERDR-AGENTS.md` and the `herdr-coordinate-agents` skill, and answered no to
both, citing the current catalog selection and the shared-checkout rule.

Limits and follow-ups (suggestions until authorized):

- The notices take effect for readers only once committed.
- About 40 tracked non-record files under `docs-harness/` (for example
  `INDEX.md`, `templates/`) still rely on being tracked rather than on allow
  lines; replacing or keeping the deny-all design is an open User decision
  (raised in `#026`).
- The replay restated the open Orca-worktree versus `#024` contradiction
  (`HERDR-AGENTS.md:191-198`); it is review group D item 1.
