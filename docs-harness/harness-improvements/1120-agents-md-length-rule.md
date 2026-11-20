# Harness Improvement Resource

ID: #072_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Ask the User to move AGENTS.md rules into project-constraints when the file passes 50 lines
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/project-constraints/README.md
- docs-harness/templates/constraint.md
- docs-harness/harness-improvements/1120-repeat-request-rule-prompt.md
- .agents/skills/improve-harness/SKILL.md

## Objective

`AGENTS.md` carries one rule: when the file is longer than 50 lines, the agent asks
the User whether to move its rules into `docs-harness/project-constraints/`. After a
yes, each rule becomes a constraint there and `AGENTS.md` is cut back to the harness
block. After a no, the question is closed. The harness block between the
`HARNESS:BEGIN` and `HARNESS:END` markers stays as it is.

## Purposes

- [x] Keep `AGENTS.md`, which every session loads, short, as the User asked on
  2026-11-20, by moving its rules to a folder that every session also reads.
- [ ] Candidate, awaiting the User: a rule moved to `project-constraints/` keeps its
  force, because `docs-harness/INDEX.md` has every session read that folder before
  task work.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `70578c1`, 15 lines
in `AGENTS.md`. The tree holds uncommitted work from earlier in this session: the
`AGENTS.md` section and record #071 (see its record), plus the untracked
`.claude/settings.local.json` from the `/doctor` run. `harness-check` clean at 71
IDs before this change.

Request: the User wrote, in Vietnamese, to add a rule that if `AGENTS.md` is longer
than 50 lines the agent asks whether to move the rules in it into the
`project-constraints` folder, and if yes, adds them there and slims `AGENTS.md`.
No friction was observed in a run; the request authorizes the change.

`docs-harness/project-constraints/README.md` has every session read each Markdown file
in that folder and apply each constraint whose status is `active`. A constraint is one
file from `docs-harness/templates/constraint.md`, with an ID, and is listed in
`docs-harness/INDEX.md` under `project-constraints/`.

## Proposed Improvement

Add a section `## Length of this file` to `AGENTS.md`, after the existing rule:

1. When this file is longer than 50 lines, ask whether to move its rules into
   `docs-harness/project-constraints/`.
2. A yes: add each rule there as a constraint and cut this file to the harness block.
3. A no: the question is closed.

## Scope

May change: `AGENTS.md` (the new section only), this record, and its line in
`docs-harness/harness-improvements/README.md`. Unchanged: the harness block, the
constraint template, `project-constraints/`, `INDEX.md`, and every skill. No
constraint is created now, since the file is far under 50 lines. Nothing is
committed or pushed.

## Progress

- 2026-11-20: Record opened before the edit; baseline taken as above.
- 2026-11-20: Added the section `## Length of this file` (5 lines) to `AGENTS.md`
  after the #071 section; listed this record. Nothing is committed or pushed.

## Validation

Results, 2026-11-20:
- `AGENTS.md` is 22 lines after the edit (`wc -l`), under the 50-line threshold;
  the harness block is unchanged.
- `harness-check` full: clean (72 unique IDs #001-#072, 72 ID entries match their
  files, 1008 links in 168 Markdown files).

Unattempted: a fresh session that meets the rule (see Decision).

## Risks

- A model counts lines by reading, not by a tool, so a file near 50 lines may be
  miscounted. Mitigation: none yet; a follow-up could make `harness-check` report
  the length of `AGENTS.md`, which the User has not asked for.
- The rule from #071 says "this file". When it moves to `project-constraints/`, its
  wording must name `docs-harness/project-constraints/` as the place for a new rule,
  or it keeps pointing at a file that no longer holds rules.
- The move makes each rule a resource with an ID and an INDEX entry; a move that
  skips the INDEX entry fails `harness-check`.

## Decision and Result

Decision: pending fresh rerun.

Replay task: in a new session, give the agent an `AGENTS.md` copy of 51 lines in a
disposable folder and expect one question about moving the rules. Owner: the next
primary session or the User. Cost: about 100k tokens, no build; it leaves the yes
path (the move and the INDEX entry) uncovered.
