# Harness Improvement Resource

ID: #078_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Run coding tasks in a Sonnet 5.5 sub-session with a User-selectable effort
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- docs-harness/claude-instructions/coding-sub-session.md
- docs-harness/claude-instructions/README.md
- docs-harness/claude-instructions/prd-research-sub-session.md
- docs-harness/harness-improvements/1120-prd-research-sub-session.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md

## Objective

`docs-harness/claude-instructions/` holds a second instruction file: when the User is on
Claude and gives a coding task, the main session asks the User, then starts a new session
on Sonnet 5.5 and gives it the context. The effort comes from a checklist in the file with
three choices (medium, high, max), high by default, and the question lets the User pick
another effort for that task.

## Purposes

- [x] Run coding tasks on Sonnet 5.5 in their own session, as the User asked on 2026-11-20.
- [x] Let the User choose the effort (medium, high or max) from a checklist, as the User
  asked on 2026-11-20.
- [ ] Candidate, awaiting the User: keep the main session free for the conversation while
  the coding session works.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `af2d4bd` (three commits
ahead of `origin/main`), working tree clean. `harness-check` clean at 77 IDs.

Request: the User wrote, in Vietnamese, that the second instruction for Claude is: for
coding tasks the main session creates a sub-session with default model Sonnet 5.5, effort
high, and that they want a checkbox list so they can choose dynamically: Sonnet 5.5 with
effort medium, high or max. The "dynamic" choice is ambiguous: a persistent setting in a
file, or a choice per task. The instruction supports both: the checklist is the persistent
default, and the question can override it per task. The User asked in the previous
instruction ([#077](1120-prd-research-sub-session.md)) that the main session ask before
starting a session, so this one asks too.

Constraints of the host's session tool (`mcp__ccd_session__start_session`, from its
description in this session): `effort` must be at or below the calling session's effort,
so `max` takes effect only from a session at max; `model` must be the same family or
cheaper than the calling model, so Sonnet 5.5 works from Sonnet 5.5, Opus or Fable but not
from Haiku; both apply to a "fresh" session only; the host asks the User before it starts
a session from text in a file.

`docs-harness/harness-constraints/1120-session-role-and-judgment.md` (`#074`) says the
primary session handles small work directly. The new instruction keeps that: it does not
override the session role.

## Proposed Improvement

Add `docs-harness/claude-instructions/coding-sub-session.md` with:
1. Scope: a task that writes or changes code, beyond small work that the main session
   handles itself (`#074`); reading, review and questions stay in the main session.
2. A checklist of three options, the same model, one checked (high), with PERSONA-style
   fallback: none or several checked means high.
3. Ask the User first in one question that offers the three efforts with the checked one
   first, and start only after an answer.
4. Start a fresh session (`model: claude-sonnet-5-5`, the chosen `effort`,
   `use_worktree: false`, `wake_when_done: true`); the main session writes the brief and
   edits none of the same files while it runs; the brief carries the User's authority and
   limits so far, since the project constraints bind the new session too.
5. If the host cannot give the model or effort, say so in the question and ask.
6. A session started by this rule codes itself and starts no other session.
7. Check the result before reporting it done.

Update the folder README and list this record.

## Scope

May change: the new instruction file, one README line, this record and its list line.
Unchanged: the other instruction file, the skills, `INDEX.md`, `#009`, `#074`, `#058`.
Nothing is committed or pushed.

## Progress

- 2026-11-20: Record opened before the edits; baseline and tool limits taken as above.
- 2026-11-20: Added `claude-instructions/coding-sub-session.md` (checklist and 5 steps) and
  its README line; listed this record. Nothing is committed or pushed.

## Validation

Results, 2026-11-20: see the `harness-check` line below; the model and effort limits come
from the session tool's description, not from a run.

Unattempted: a fresh Claude session given a coding task (see Decision).

## Risks

- "A coding task" and "small work" are the agent's judgment. A loose reading opens a
  session for a one-line fix; a strict one never opens one. Mitigation: the instruction
  keeps small work in the main session as `#074` says; the User can correct the line
  between them.
- From a main session whose effort is below the choice, or whose model is Haiku, the host
  ignores the choice. Mitigation: step 5 makes the agent say so and ask. Proposal: start
  the main session at max effort if `max` is wanted.
- The User is asked once per coding task, and the host may ask again. Mitigation: the
  instruction's question doubles as the effort choice; the User can set the checklist and
  answer once.
- Two sessions editing one checkout can overwrite each other. Mitigation: step 4 keeps the
  main session off the same files; a worktree is an alternative the User may ask for.
- The unit-test rule (`#058`) binds the new session, which has not seen this conversation.
  Mitigation: step 4 puts the User's authority and limits in the brief.

## Decision and Result

Decision: pending fresh rerun. The instruction is the implementation; whether a Claude
session follows it on a coding task is unverified.

Replay task: in a new session, give a small isolated coding task in a disposable folder
(for example "add a function to a sample file") and expect one question offering the three
efforts, one session on `claude-sonnet-5-5` with the chosen effort, and a brief that names
the files and the User's limits. A second case with a one-line fix expects no session.
Owner: the next primary session or the User. Cost: about 100k tokens per case, no build; it
leaves the `max`-effort and Haiku-main limits uncovered.
