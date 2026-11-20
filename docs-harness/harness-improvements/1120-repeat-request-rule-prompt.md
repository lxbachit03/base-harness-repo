# Harness Improvement Resource

ID: #071_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Ask the User to record an action they request a second time as an AGENTS.md rule
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/SESSION.md
- .agents/skills/improve-harness/SKILL.md
- docs-harness/harness-improvements/README.md

## Objective

`AGENTS.md` carries one rule: when the User asks for the same action a second time
in a session, the agent asks whether to add that action as a rule in `AGENTS.md`,
and adds it only after a yes. The harness block between the `HARNESS:BEGIN` and
`HARNESS:END` markers stays as it is.

## Purposes

- [x] Turn an action the User repeats into a standing rule they choose, as the
  User asked on 2026-11-20, so the same request is not typed a third time.
- [ ] Candidate, awaiting the User: keep `AGENTS.md` short, because the file is
  loaded at the start of every session and every added rule costs context each time.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `70578c1`, working
tree clean apart from the untracked `.claude/settings.local.json` written by the
`/doctor` run earlier in this session. `harness-check` clean (70 IDs, 1006 links in
166 Markdown files, 20 skills and 70 files identical, 21 folders with README).

Request: the User wrote, in Vietnamese, to add to `AGENTS.md` a rule that when the
User mentions an action for the second time, the agent asks whether they want to add
a rule to `AGENTS.md`. No friction was observed in a run; the change is a decision
that the request authorizes.

`AGENTS.md` is 332 bytes: a title and the harness block that sends every session to
`docs-harness/INDEX.md`. Only that file holds the markers.

## Proposed Improvement

Add a section `## Repeated User requests` after the harness block:

1. Second request for the same action in a session: ask whether to add it as a rule
   in this file.
2. A yes: write the rule with `improve-harness`, which owns the record and the check.
   A no: the question for that action is closed.
3. A delegated worker reports the repeat to its coordinator, because the worker
   returns evidence and does not talk to the User (`docs-harness/SESSION.md`).

## Scope

May change: `AGENTS.md` (the new section only), this record, and its line in
`docs-harness/harness-improvements/README.md`. Unchanged: the harness block, the
policy owners (`docs-harness/SESSION.md`, `WORKFLOW.md`), every skill. The rule
counts requests inside one session; the agent has no count across sessions.
Nothing is committed or pushed.

## Progress

- 2026-11-20: Record opened before the edit; baseline taken as above.
- 2026-11-20: Added the section `## Repeated User requests` (5 lines) to
  `AGENTS.md` after the harness block; listed this record. Nothing is committed
  or pushed.

## Validation

Results, 2026-11-20:
- `git diff AGENTS.md`: 7 added lines after the `HARNESS:END` marker; the harness
  block is unchanged.
- `harness-check` full: clean (71 unique IDs #001-#071, 71 ID entries in INDEX and
  folder READMEs match their files, 1007 links in 167 Markdown files, 20 skills
  and 70 files identical).

Unattempted: a fresh session that meets the rule (see Decision).

## Risks

- The agent decides what counts as the same action. A loose reading asks too often
  and a strict one never asks. Mitigation: the rule says "the same action", and the
  replay checks one clear repeat and one near miss.
- Each new rule enlarges the always-loaded file. Mitigation: the rule asks the User
  first, so only a chosen rule is added.
- The question is a User-facing prompt in the middle of a task; a worker cannot
  answer it. Mitigation: the worker clause above.

## Decision and Result

Decision: pending fresh rerun. The edit is the implementation; whether an agent
asks on the second request, and only then, is unverified.

Replay task: in a new session, send the same bounded request twice (for example
"list the files in docs-harness/layers" and then again), and a third message with a
different request. Expect one question after the second request offering to add a
rule to `AGENTS.md`, and none after the first or the third. Owner: the next primary
session or the User. Cost: about 100k tokens per scenario, no build; it leaves the
worker clause and the yes path (writing the rule) uncovered.
