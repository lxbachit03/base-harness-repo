# Harness Improvement Resource

ID: #037_IMPROVE_HARNESS_1003
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Retire the missing #012 plan route from INDEX
CREATED: 2026-10-03
STATUS: completed
REFERENCES:
- docs-harness/INDEX.md
- #026_IMPROVE_HARNESS_0921
- .gitignore

## Objective

`docs-harness/INDEX.md` routes only to existing files: the two entries for
`#012_IMPROVE_HARNESS_0902`
(`plans/completed/0902-evidence-backed-domain-freshness.md`) are removed, and
`#012` is recorded here as retired.

## Purposes

- [x] Keep every INDEX route resolvable, so an agent following the
  `[IMPROVE_HARNESS]` or `plans/completed/` routes reaches evidence instead of
  a dead link.
- [x] Retire `#012` explicitly rather than reconstructing a record whose
  original content is unknown, so no history is fabricated.

## Current State

Baseline (2026-10-03): repository `D:\repos\base-harness-repo`, branch `main`,
revision `6b1bd92`, worktree clean and level with `origin/main`.

- INDEX lines 152 (`[IMPROVE_HARNESS]`) and 312 (`plans/completed/`) link
  `plans/completed/0902-evidence-backed-domain-freshness.md` with ID `#012`.
- The file is absent on disk. `git log --all` shows no commit that ever added
  or deleted it; the route was introduced by commit `7cf83c1` ("enhance:
  harness domain knowledge"), which changed `domain/README.md`,
  `templates/README.md`, `templates/domain.md` and related skills but never
  added the plan file. `.gitignore` has no allowlist line for it.
- `#026_IMPROVE_HARNESS_0921` already reported the dead link under Risks and
  left recreate-versus-retire to the User.
- Observed during a read-only session-start status check on 2026-10-03.

## Proposed Improvement

Remove both INDEX entries for `#012`. Record the retirement in this file.
Sequence `012` stays consumed: the max + 1 allocation rule in
`templates/README.md` never reissues it.

## Scope

May change: `docs-harness/INDEX.md` (two `#012` entries removed, this record
indexed under `[IMPROVE_HARNESS]`), `.gitignore` (allowlist line for this
record), and this record.

Unchanged: the historical mention of `#012` in
`harness-improvements/0921-utilizing-tools-claude-capability-catalog.md`; the
`.gitignore` line for `plans/completed/0906-behavior-parity-audit.md` (User
decision 2026-10-03: keep it, since it becomes valid when `#014` completes);
all other plans and their statuses.

## Progress

- 2026-10-03: User chose "Retire #012" over retroactive recreation and chose to
  keep the `0906-behavior-parity-audit.md` `.gitignore` line. Record created;
  INDEX and `.gitignore` edited.
- 2026-10-03: Native checks passed; fresh replay run and reviewed (see
  Decision and Result).

## Validation

- Native: every relative link in `docs-harness/INDEX.md` resolves to an
  existing path; `#012` no longer appears in INDEX; `#037` appears once in the
  `[IMPROVE_HARNESS]` route; no duplicate full IDs or reused sequences across
  `docs-harness/` (templates excluded); `git status` shows this record as an
  untracked, non-ignored file.
- Fresh replay: a fresh read-only agent session, asked to locate the history of
  the evidence-backed domain capture and freshness work through INDEX, reaches
  existing evidence without following a dead route.

## Risks

- Lost provenance: the domain-freshness work that `#012` would have described
  is now reachable only through `domain/README.md` and commit `7cf83c1`.
  Mitigation: this record names that commit; a retroactive summary can be
  written later as a new record if the User asks.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-03):

- Every relative link target in `docs-harness/INDEX.md` exists (0 missing).
- `#012` appears in INDEX only inside this record's title; `#037` appears once,
  under `[IMPROVE_HARNESS]`.
- No duplicate `ID:` sequences across `docs-harness/` (templates excluded).
- `git status`: `M .gitignore`, `M docs-harness/INDEX.md`, `??` this record;
  `git check-ignore -v` resolves it to the new `.gitignore:57` allow line.

Fresh replay (2026-10-03, fresh read-only native subagent, worker role; the
task named only the "evidence-backed domain capture and freshness" history,
not `#012` or this record):

- Available and retrieved: the agent followed AGENTS.md -> INDEX -> session
  retrieval -> `[DOMAIN]`, `plans/`, `plans/completed/` and `[IMPROVE_HARNESS]`
  routes, and every INDEX link it followed existed.
- Outcome: it located current policy in `domain/README.md` and history in
  commit `7cf83c1`, `#013`, `#034` and this record, without hitting a dead route.
- Reported drift reviewed: `[CRITIAL]` and `[NORMAL]` are both catalog values
  in `templates/README.md`; `domain-audit` is a live skill (`#023` removed
  `onboard-repository` and `audit-onboarding-proposal`); the
  `0906-behavior-parity-audit.md` `.gitignore` line is kept by User decision.
  None requires a change in this scope.

Limits: one bounded replay; it read this record, so its account of the
retirement partly reflects this record's own text. The replay prompt forbade
script runs and external actions, so the agent skipped `jev-hook` consults and
reported that conflict instead of a gate verdict; replay prompts for this
repository should state the hook's expected handling explicitly.
