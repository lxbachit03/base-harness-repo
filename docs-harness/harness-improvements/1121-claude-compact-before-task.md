# Harness Improvement Resource

ID: #080_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Ask the User about /compact before a task when context is above 50%
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- docs-harness/claude-instructions/compact-before-task.md
- docs-harness/claude-instructions/README.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

`docs-harness/claude-instructions/` holds a fourth instruction file: when a Claude
session is about to start a task and its context is above 50% of the window, it asks the
User whether to run `/compact`. After a yes it writes one prompt that begins with
`/compact` and carries the full context the next task needs, and starts the task only
after the User has run it.

## Purposes

- [x] Keep a long Claude session from starting a new task on a nearly full context, as
  the User asked on 2026-11-21.
- [x] Let the User decide whether to compact (user authority), as the User asked on
  2026-11-21.
- [x] Hand the User a ready `/compact` prompt that carries the full context for the next
  task, as the User asked on 2026-11-21.
- [x] Write the `/compact` prompt in English, as the User said on 2026-11-21.
- [x] Count every task, with no "small work" exception, as the User said on 2026-11-21:
  only a question that needs no work is not a task.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `e9fc1ae` (six commits
ahead of `origin/main`), working tree clean. `harness-check` clean at 79 IDs.

Request: the User wrote, in Vietnamese, to add a rule for `claude-instructions`: when the
context is above 50% before doing a task, ask the User whether to use `/compact`; if yes,
create a prompt containing `/compact` and the full context before the next task.

Tool facts: `/compact` is a Claude Code command that the User types or sends; an agent
cannot run it. It accepts optional text that tells it what to keep. A session may or may
not see its own context percentage: the host's indicator is the figure when visible; no
tool in this session reports it.

## Proposed Improvement

1. Add `docs-harness/claude-instructions/compact-before-task.md`: when it applies (about
   to start a task, context above 50%), how to read the level (the host's figure, else a
   stated estimate), one question per task, the prompt shape (`/compact` then what to
   keep: the next task in the User's words, files and state, decisions, what is done and
   open, authority and limits, results to preserve), the User runs it and the task starts
   afterwards, a worker reports the level to its coordinator instead of asking.
2. List the file in the folder README.
3. List this record in `harness-improvements/README.md`.

## Scope

May change: the new instruction, the folder README, this record and its list line.
Unchanged: `INDEX.md` (it already loads every file under the folder), `#009`, `#074`, the
other three instructions. Nothing is pushed.

## Progress

- 2026-11-21: Record opened before the edits; baseline and tool facts taken as above.
- 2026-11-21: Added `claude-instructions/compact-before-task.md`; listed it in the folder
  README and this record in `harness-improvements/README.md`. Ran the fresh replay (see
  Decision). Nothing is committed or pushed.

## Validation

Results, 2026-11-21: `harness-check` full clean (80 unique IDs #001-#080, 72 INDEX links,
1036 links in 178 Markdown files).

The fresh replay was run on 2026-11-21 (see Decision). Still unattempted: a real
`/compact` run, a real context figure above 50%, and a delegated worker.

## Risks

- The session may not see a context percentage, so the 50% trigger rests on an estimate.
  Mitigation: the instruction says to use the host's figure and to label an estimate as
  one.
- The prompt can omit a fact the next task needs, and `/compact` then drops it.
  Mitigation: the instruction lists what the prompt carries and asks for the next task in
  the User's words.
- The agent cannot run `/compact`, so the task waits on the User. Mitigation: the
  instruction says so and the User may decline.
- A question before every task could repeat in a long thread. Mitigation: one question per
  task, and a "no" closes it for that task.

## Decision and Result

Decision: keep. The instruction was available, retrieved and exercised in scenarios.
Replay, 2026-11-21: one fresh read-only session (`local_2c5983be-afed-4333-b122-f1f084cd285d`,
Sonnet 5.5, effort high, 18 turns, revision `e9fc1ae` plus the uncommitted edits), four
parts; it edited no file, ran no git write, started no session, spawned no subagent and ran
no `/compact`. Token cost was not measured.

Observed: it read `claude-instructions/README.md` and all four instruction files at session
start, before the scenarios, and counted itself as Claude because its model ID contains
`claude`. With the context at 62% and a new code task, it asked one question before opening
any file (the context is about 62%, run `/compact` first?). After "yes" it wrote a code block
starting with `/compact`, in Vietnamese, carrying the next task in the User's words, the
file and function with lines, state and open item, decisions and what is ruled out, the
User's authority and limits, and the check command with its result; it said it would start
only after the User sent it. After "no" it started the task and did not ask again. At 35% it
did nothing and started the task. It saw no real context percentage in its session.

Not covered: a real `/compact` run, a real figure above 50%, a delegated worker reporting
the level, and a non-Claude session skipping the file. Open points the replay raised, for
the User: the order against `coding-sub-session.md` when a task would go to a sub-session
(the replay guessed compact first for a small task), "a task" and "small" have no threshold,
and the prompt language is the User's.

Follow-up, 2026-11-21: the User asked to drop "small" and use "task". The instruction now
says a question that needs no work is not a task, and mentions no small work; that wording
was not replayed. Then the User asked for English when compacting: the `/compact` prompt is
written in English whatever language the User writes, and the next task stays quoted in the
User's own words and language so its wording is not lost (a reading of the request); this
was not replayed either. The order against `coding-sub-session.md` stays open and
unchanged.
