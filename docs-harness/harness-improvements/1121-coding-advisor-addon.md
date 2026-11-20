# Harness Improvement Resource

ID: #081_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Let the coding sub-session consult an Opus 5.5 advisor, with an on/off switch and an effort checklist
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/claude-instructions/coding-sub-session.md
- docs-harness/claude-instructions/README.md
- docs-harness/harness-improvements/1120-coding-sub-session.md
- docs/tools/claude/README.md

## Objective

`docs-harness/claude-instructions/coding-sub-session.md` gains an advisor add-on: the
Sonnet 5.5 coding session it starts may consult Opus 5.5 as its advisor. The file carries
one checkbox that turns the add-on on or off and a two-option checklist for the advisor's
effort (medium or high, high by default), and the step 1 question lets the User change
either for one task.

## Purposes

- [x] Give the coding session a stronger model to consult without moving the coding itself
  off Sonnet 5.5, as the User asked on 2026-11-21.
- [x] Let the User choose dynamically: an effort checklist (Opus 5.5 medium or high) and a
  checkbox that switches the whole add-on on or off, as the User asked on 2026-11-21.
- [ ] Candidate, awaiting the User: keep the advisor's cost visible, since each consult
  runs a second, larger model.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `48c96eb`, in sync with
`origin/main`, working tree clean, `harness-check` clean at 80 IDs.

Request: the User wrote, in Vietnamese, to add to `coding-sub-session.md` that the Claude
in the sub-session can call Opus 5.5, effort high by default, as its Advisor, with a
checkbox list (Opus 5.5 effort medium, Opus 5.5 effort high) so the User can choose
dynamically, and one more checkbox to switch the instruction on or off.

The coding instruction (`#078`) starts a Sonnet 5.5 session and says that session starts
no other session. The Claude Code catalog lists `/advisor [model|off]`, which switches the
advisor tool on or off (`docs/tools/claude/README.md`, slash commands); an advisor consult
is a tool call inside the session, not a new session. Whether a session started by
`mcp__ccd_session__start_session` has that tool, and whether the tool takes an effort, is
not established in this repository.

## Proposed Improvement

In `coding-sub-session.md`:
1. A switch checkbox, marked by default, for the whole advisor add-on.
2. A two-option checklist (Opus 5.5 effort medium or high, high marked) with the same
   fallback as the effort list: none or several marked means high.
3. The step 1 question also names the advisor and its efforts when the switch is on.
4. The brief tells the coding session that it may consult Opus 5.5 through the host's
   advisor tool at the chosen effort, and that advice informs the work while the task, the
   User's limits and the project constraints decide.
5. If the session has no advisor tool or the tool cannot take the model or effort, the
   session says so in its report and continues alone.
6. The sentence that the started session starts no other session says a consult is not a
   session.
Update the folder README line and list this record.

## Scope

May change: the instruction file, one README line, this record and its list line.
Unchanged: the effort checklist and step 2 and step 5 of the instruction, other instruction
files, the skills, `#009`, `#074`, `#058`. The add-on is on by default; the User turns it
off by unmarking one box. Nothing is committed or pushed.

## Progress

- 2026-11-21: Record opened before the edits; baseline and the open tool question taken as
  above.
- 2026-11-21: Added the advisor switch, the two-option effort checklist and the step 1, 3
  and 4 wording to `coding-sub-session.md`, its README line and this record's list line.
  Nothing is committed or pushed.
- 2026-11-21: Ran the fresh read-only replay (see Validation and Decision); closed the
  record.

## Validation

Results, 2026-11-21: `harness-check` clean (81 IDs, 1037 links in 179 Markdown files);
the instruction file and both README files keep pure CRLF.

Replay, 2026-11-21: one fresh read-only session (`local_378b6719-ffb5-4488-b51f-8c2fbd04d316`,
Sonnet 5.5, effort high, 19 turns, revision `48c96eb` plus the uncommitted edits) was told
not to edit, to start no session or subagent, and to stop at the gate. It created and
changed no file (`git status` showed only the edits of this record's own change set).
Started cold, it read AGENTS.md, INDEX, the mandatory constraints and all instruction files
without being told to, then answered two cases for a non-small coding task written in
Vietnamese.
- Case 1, switch on: it asked one question that named the Sonnet 5.5 efforts, the Opus 5.5
  advisor with its two efforts, and the option to switch the advisor off for the task; it
  planned `start_session` with `claude-sonnet-5-5`, `high`, `fresh`, `use_worktree: false`,
  `wake_when_done: true`, and a brief that carried the task, limits (no unit tests, `#058`),
  the advisor sentence at the effort marked in the file, and the fallback "say so in the
  report and continue alone".
- Case 2, switch unmarked: the question and the brief held no mention of the advisor.
- State of the file during the replay: the effort checklist had `medium` marked and `high`
  unmarked, which differs from what this change wrote (high marked); the file changed
  after that edit and the replay was read-only. The replay followed the file as it stood,
  so its default advisor effort was medium.
Not covered: whether a started session has an advisor tool (the replay saw none in its own
tool list, so the "continue alone" branch is the likely one), whether the tool takes an
effort, a real start, and the finished work.

## Risks

- Each consult runs Opus 5.5, so a coding task costs more with the add-on on. Mitigation:
  the question names the advisor and the User can switch it off per task or in the file.
- The advisor tool may be missing in a started session or may not accept an effort.
  Mitigation: step 4 makes the session say so and continue alone; the mechanism is
  unverified here.
- The coding session may consult too often or send the advisor more than it needs.
  Mitigation: the brief limits a consult to what the question needs; the User can switch
  the add-on off.

## Decision and Result

Decision: keep, with open points for the User. The instruction was available, retrieved and
exercised up to its gate in both cases (see Validation). Open points the replay raised,
none changed here:
- Step 1 offers the advisor without checking that the host has the tool, and the step 4
  clause "say so in the step 1 question" cannot run before the session starts; only the
  brief's fallback works. Option: let the question say the advisor may be unavailable.
- `use_worktree: false` assumes the work lands in this checkout; a target outside it (here
  `C:/tmp`) needs a `cwd` the instruction does not mention (also true of `#078`).
- `#074` lists research subagents as the only worker exception and does not mention an
  advisor consult.
- "Small work" still has no threshold (open since `#078`).
Remaining proof: a real start, whether the advisor tool exists in a started session and
takes an effort, and the finished work; about 100k tokens, not required for this record.
Owner: the User. Nothing is committed or pushed.
