# Harness Improvement Resource

ID: #046_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Apply the User's repository, record and template decisions from the optimization review
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- .gitignore
- docs-harness/INDEX.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-2/hooks/README.md
- docs-harness/templates/domain.md
- docs-harness/templates/proposal.md
- .agents/skills/ticket-solving/agents/openai.yaml
- .agents/skills/improve-harness/agents/openai.yaml
- .agents/skills/domain-audit/SKILL.md
- .agents/skills/init-harness-repo/SKILL.md
- docs-harness/plans/README.md

## Objective

The User's remaining review decisions are applied: no file in this repository
is ignored by git; Codex invocation flags match each skill's SKILL.md; the
session-start INDEX check compares files, not only folder names; the eleven
records still waiting on reruns are completed by User decision (legacy plans
moved to `plans/completed/`); and the layers, domain, proposal and
init-harness-repo guidance carry the small clarifications the User accepted.

## Purposes

- [x] Track every repository file, since the global excludes on this machine
  are meant for other repositories.
- [x] Let the session-start check catch a canonical file missing from INDEX.
- [x] Close records the User judged complete, without claiming replays that
  were not separately recorded.

## Current State

Baseline (2026-10-05): `main` at `9b71345`. The repository `.gitignore`
denied `docs-harness/*` and re-included tracked files one by one; the global
`C:\Users\DEV\.gitignore_global` ignores `AGENTS.md`, `docs-harness` and most
skill folders (for other repositories). No file in the repository was
currently ignored (`git ls-files --others --ignored --exclude-standard` empty).

User decisions (2026-10-05):

| # | Decision |
| --- | --- |
| P1 | No file in this repository is ignored; global excludes are for other repositories |
| P2 | Align Codex `openai.yaml` invocation flags with SKILL.md (`ticket-solving` user-invoked; `improve-harness` model-invoked) |
| P4 | Revise #005: the session-start INDEX check compares canonical files with INDEX entries in both directions, report-only |
| P5 | Complete all eleven records waiting on reruns by User decision: #003, #004, #005, #006, #007, #008, #010, #011, #014, #017, #023 |
| F4 | `layers/README.md`: when the runtime exposes no effort value, name the add-on after the model ID |
| F8 | `templates/domain.md` confirmed-path note; domain-audit promotion turns unconfirmed claims into open questions |
| F9 | Standalone proposal: REFERENCES lists related resources or "none"; STATUS is proposed/accepted/rejected/superseded |
| F11 | `init-harness-repo`: name existing files in the step 1 options, point to `scaffold.md` in step 2, ask when created paths are ignored |
| F12, F13 | Not done (User: no live run; User handles the global excludes file) |

## Proposed Improvement

Edit each owner per the table; move the legacy plans with their INDEX routes;
add a dated User-decision note to each completed record.

## Scope

May change: files in REFERENCES, the eleven records in P5 (STATUS, location
for plans, an appended note), INDEX routes for moved plans, `.claude/skills/`
mirrors, this record.

Unchanged: record history; the global excludes file.

## Progress

- 2026-10-05: Record created before edits.
- 2026-10-05: P1 `.gitignore` is now the single rule `!*`; the allow-line
  steps in `layers/README.md` and `hooks/README.md` were removed. P2, F4, F8,
  F9, F11 applied. P4 rewrote INDEX Session retrieval. P5: nine plans set to
  completed with a dated note and moved with a plain `mv` (no staging) to
  `plans/completed/`; #017 and #023 completed with a note; every link to a
  moved path repointed (INDEX, `docs-harness/README.md`, records, and two
  team docs under `docs/` whose links pointed at the moved files);
  `plans/active/README.md` added so the routed folder stays in git.
- 2026-10-05: P4 replay used a disposable fixture
  `docs-harness/proposals/1005-index-check-probe.md` (`#099_PROPOSAL_1005`,
  untracked). Its removal was classified by the shell gate as needing User
  authority, so it awaits the User's decision and must not be committed.

## Validation

- Native: `git check-ignore --no-index` reports nothing ignored for tracked
  and new paths (including paths the global file names); moved plans resolve
  from INDEX and every reference; STATUS values; links; IDs; mirror diff.
- Fresh replay (P4): with a disposable unindexed file planted in a canonical
  folder, a fresh worker's session-start check reports it.

## Risks

- Files once hidden by the global excludes (for example a `.env` created by a
  tool) would now show as untracked and could be committed by mistake.
  Mitigation: staging and commits still need explicit User authority, and the
  diff is reviewed before each commit.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05): `git check-ignore --no-index` reports nothing
ignored for tracked files and for new paths the global excludes name
(`AGENTS.md`, `docs-harness/...`, `.agents/skills/goal-griller/...`,
`sub/AGENTS.md`); `git ls-files --others --ignored --exclude-standard` is
empty; every INDEX link resolves; every resource ID is routed; no duplicate
IDs; STATUS values are only `active`/`completed`; `plans/active/` holds only
its README; every link to a moved plan resolves (the only miss is the retired
#012 path, history in #026/#037); `.agents`/`.claude` differ only by line
endings.

Fresh replay (P4; fresh native read-only worker, startup routine only): it
quoted the new Session retrieval text, listed `docs-harness/`, and reported
the planted unrouted `#099_PROPOSAL_1005` as the one drift item, without
changing files; no missing link targets or folders. It also answered that a
new layer add-on or hook needs no `.gitignore` entry and confirmed with git
that nothing is ignored. P2, F4, F8, F9 and F11 were checked natively.

Limits: P5 closures rest on the User's decision, not on the records' own
rerun scenarios.
