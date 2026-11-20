# Harness Improvement Resource

ID: #079_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Run code research in Haiku 5.5 subagents with a User-selectable effort
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- docs-harness/claude-instructions/research-subagents.md
- docs-harness/claude-instructions/README.md
- docs-harness/claude-instructions/coding-sub-session.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/harness-improvements/1120-coding-sub-session.md

## Objective

`docs-harness/claude-instructions/` holds a third instruction file: when the User is on
Claude and a task researches code (searching it, tracing it, finding where something
happens), the session that is doing the task asks the User, then spawns subagents on
Haiku 5.5. The effort comes from a checklist with two choices (high, extra), high by
default. A subagent returns its findings to the session that spawned it. Both the main
session and a session started by the two earlier instructions may spawn them.

## Purposes

- [x] Run code research on Haiku 5.5 in subagents, as the User asked on 2026-11-20.
- [x] Let the User choose the effort (high or extra) from a checklist, as the User asked
  on 2026-11-20.
- [x] Return the data to the spawning session first, as the User asked on 2026-11-20.
- [x] Give each subagent all its context in one prompt so it finishes without asking, as
  the User asked on 2026-11-20.
- [ ] Candidate, awaiting the User: keep the spawning session's context free of raw search
  output.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `bed2550` (four commits
ahead of `origin/main`). The tree holds one uncommitted edit by the User in
`coding-sub-session.md` (an "extra" effort option). `harness-check` clean at 78 IDs.

Request: the User wrote, in Vietnamese, the third Claude instruction: for tasks that
research or search code, Claude creates subagents (Haiku 5.5, effort high), with a
checklist for the User to choose between Haiku 5.5 effort high and effort extra; the main
session and a sub-session may both spawn them; Claude asks the User before spawning (user
authority); subagents prefer to return data to the session that spawned them.

Tool facts (the Agent tool's description in this session): `model` accepts `sonnet`,
`opus`, `haiku` or `fable`, not a version number, so "Haiku 5.5" means whatever the host
resolves `haiku` to; `effort` accepts `low`, `medium`, `high`, `xhigh`, `max` and is set
only when the User or an instruction file asks for a level, which this one does. "Extra" is
not a value; it is read as `xhigh`, the level between high and max. The `Explore` agent
type is a read-only search agent. A subagent's result returns to the session that spawned
it.

Conflict found: `#074` says a delegated worker works "without spawning agents", and the two
earlier instructions start sessions that are workers. The User now says a sub-session may
spawn subagents, so `#074` needs a narrow exception.

## Proposed Improvement

1. Add `docs-harness/claude-instructions/research-subagents.md`: scope (code research, read
   only), the checklist (high marked, extra), ask the User first once per research task
   (the answer covers the subagents that task needs), spawn with `Explore`, `model: haiku`
   and the chosen effort, a single prompt that carries all the context the subagent needs (question, why, repository
   root and known paths and terms, what is ruled out, limits, assumptions) so it never has
   to ask, and that asks for findings with paths and line numbers returned to the spawner, and a rule that a subagent spawns none.
2. `#074`: name the exception in the Role paragraph and its validation line.
3. `coding-sub-session.md` (the User's "extra" edit): say "the efforts" instead of "three"
   and map "extra" to `xhigh`.
4. Update the folder README and list this record.

## Scope

May change: the new instruction, `#074` (two lines), `coding-sub-session.md` (those two
points), the folder README, this record and its list line. Unchanged: the prd-research
instruction, `INDEX.md`, `#009`, `#075`. Nothing is committed or pushed.

## Progress

- 2026-11-20: Record opened before the edits; baseline and tool facts taken as above.
- 2026-11-20, at the User's addition: step 3 of the instruction lists what the one prompt
  must carry so the subagent finishes without asking (a subagent cannot ask the spawner or
  the User).
- 2026-11-20: Added `claude-instructions/research-subagents.md` (checklist and 5 steps);
  added the research-subagent exception to `#074` (Role paragraph and validation line);
  made `coding-sub-session.md` say "the efforts" and map "extra" to `xhigh` (the User's
  edit kept); updated the folder README; listed this record. Nothing is committed or
  pushed.

## Validation

Results, 2026-11-20: see the `harness-check` line in the report; the model and effort
facts come from the Agent tool's description, not from a run.

Unattempted: a fresh Claude session given a code research task (see Decision).

## Risks

- "Haiku 5.5" cannot be named: the host resolves `haiku`. Mitigation: the instruction names
  the alias and says so; the User can check the model the host used.
- "Extra" as `xhigh` is a reading; Haiku may not support that level. Mitigation: the
  instruction asks the agent to say so when the host refuses the effort.
- One question per research task keeps the User from a prompt per subagent, but a wide
  fan-out under one yes spends more. Mitigation: the question states the number of
  subagents planned.
- The exception in `#074` lets a worker spawn agents. Mitigation: it is limited to research
  subagents that this instruction allows, and a subagent spawns none.
- A prompt that omits a needed fact leaves the subagent guessing or returning a gap.
  Mitigation: the list in step 3 names the facts, including what to assume when something is
  unclear, and step 5 has the spawner check results.
- The spawning session may skip the instruction for a quick lookup. Mitigation: the
  instruction keeps one or two direct reads in the session, as small work.

## Decision and Result

Decision: pending fresh rerun. The instruction and the `#074` exception are the
implementation; whether a Claude session asks, spawns Haiku subagents and gets results back
is unverified.

Replay task: in a new session, ask where a named function in a small sample repo is called;
expect one question naming Haiku, the efforts and the subagent count, then `Explore`
subagents on `haiku` and results with paths and lines in the main session. A second case
from a session started by the coding instruction expects the same. Owner: the next primary
session or the User. Cost: about 100k tokens per case, no build; it leaves the `xhigh`
refusal path uncovered.
