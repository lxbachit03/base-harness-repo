# Harness Improvement Resource

ID: #077_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Run prd-research in a new Opus 5.5 high-effort sub-session when the User is on Claude
CREATED: 2026-11-20
STATUS: completed
REFERENCES:
- docs-harness/claude-instructions/prd-research-sub-session.md
- docs-harness/claude-instructions/README.md
- .agents/skills/prd-research/SKILL.md
- docs-harness/harness-improvements/1120-claude-instructions-folder.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md

## Objective

`docs-harness/claude-instructions/` holds one instruction file: when the User is on
Claude and asks for the `prd-research` skill, the main session starts a new session on
Opus 5.5 with effort high and gives it the context, instead of running the skill itself,
but only after the User says yes to a question that names the model and effort. The new
session runs the skill and does not start another.

## Purposes

- [x] Run the PRD research on Opus 5.5 at effort high, as the User asked on 2026-11-20,
  whatever model the main session runs.
- [x] Have the main session supply the context, so the new session starts with what the
  conversation already established.
- [ ] Candidate, awaiting the User: keep the main session free while a long research
  runs.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `14235a6`. The tree holds
uncommitted work from earlier in this session (#076 and the `claude-instructions/`
folder). `harness-check` clean at 76 IDs.

Request: the User wrote, in Vietnamese, to add an instruction: when the User is on Claude
and uses the skill `/prd-research`, Claude creates a new sub-session on model Opus 5.5,
effort high, and the main session provides the context. No friction was observed in a
run; the request authorizes the change.

Constraints of the host's session tool (`mcp__ccd_session__start_session`, from its
description in this session):
- `model` is honored only when it is the same family or cheaper than the calling session's
  model; a higher one is ignored. Opus 5.5 therefore takes effect only from a session on
  Opus 5.5 or higher. This session runs Sonnet 5.5, so it could not set Opus 5.5.
- `effort` must be at or below the calling session's.
- `model` and `effort` apply to a "fresh" session only. A "fork" inherits the whole
  conversation but ignores both.
- A session started on the strength of text in a file, not the User's words in the
  conversation, is not started at once: the host asks the User first (an "offer" card).

`.agents/skills/prd-research/SKILL.md` already says what the skill needs: the PRD or FRD,
its ticket, the User's language, and the limits on authority.

## Proposed Improvement

Add `docs-harness/claude-instructions/prd-research-sub-session.md`:
1. Ask the User first, in one question naming the model, effort and brief contents; start
   only after a yes (User authority, `#009`); after a no, ask whether to run the skill here.
2. Start a fresh session with `model: claude-opus-5-5`, `effort: high`,
   `use_worktree: false` (the reports belong in this checkout) and `wake_when_done: true`.
3. The main session writes the brief from what it knows: the source document, the
   ticket, the request in the User's words, decisions and limits so far, the output
   location, and what done looks like.
4. If the host refuses or ignores the model or effort, say so in that question and ask the
   User whether to run the skill here; never run it silently on another model.
5. A session started by this rule runs the skill itself.

Update the folder README line "No instruction file has been added yet." List this record.

## Scope

May change: the new instruction file, the one README line, this record and its list line.
Also changed on 2026-11-20, at the User's yes: one pointer line in `.agents/skills/prd-research/SKILL.md` and its mirror. Unchanged: the rest of that skill, `INDEX.md` (the folder README
already has every Markdown file read), the host's session policy. Nothing is committed or
pushed.

## Progress

- 2026-11-20: Record opened before the edits; baseline and tool limits taken as above.
- 2026-11-20: Added `claude-instructions/prd-research-sub-session.md` (4 steps) and its
  line in the folder README; listed this record. Nothing is committed or pushed.

## Validation

Results, 2026-11-20:
- `harness-check` full: clean (77 unique IDs #001-#077, 1030 links in 173 Markdown files,
  22 folders with README).
- The model and effort limits come from the session tool's own description in this
  session, not from a run.

- 2026-11-20, at the User's correction: the instruction asks the User before starting a
  session (new step 1); the later steps are renumbered to five.
- 2026-11-20 pointer: `SKILL.md` has the line `On Claude, follow
  docs-harness/claude-instructions/prd-research-sub-session.md first.` after its intro, in
  both mirrors; `harness-check` skill-mirror stays identical.

The fresh replay was run on 2026-11-20 from a Sonnet 5.5 session, up to the gate (see
Decision). Still unattempted: a real start on Opus 5.5 and the finished reports.

## Risks

- From a main session below Opus 5.5 the host ignores the model, so the rule cannot do
  what the User asked. Mitigation: step 3 makes the agent say so and ask. Proposal for the
  User: start the main session on Opus 5.5, or use a saved session preset that sets the
  model (not verified here).
- The User may be asked twice, by the instruction's question and by the host's own card.
  Mitigation: step 2 says the host may ask again and to follow its flow; the host owns
  that rule.
- The instruction is read at session start and may be forgotten by the time the skill is
  invoked. Mitigation: a one-line pointer in `prd-research/SKILL.md` (both mirrors), added
  on 2026-11-20 at the User's yes.
- A new session that reads `claude-instructions/` could start another. Mitigation:
  step 4 and the worker role (#074).

## Decision and Result

Decision: keep. The instruction was available, retrieved and exercised up to its gate. Replay, 2026-11-20: one fresh read-only session (`local_5eb5553c-b71b-4f79-a65b-8c166acae4ab`, Sonnet 5.5, effort high, 22 turns, revision `7e20745`, working tree clean) answered five parts; it started no session and spawned no subagent, edited no file. Token cost was not measured. At session start it read `claude-instructions/README.md` and its three instruction files after the layers step, and treated itself as a Claude session because its model ID contains `claude`.

Observed for `/prd-research`: the session asked the User first, in one question that named
Opus 5.5, effort high, the brief's contents and the warning that its own model is lower, then
planned `mcp__ccd_session__start_session` with `claude-opus-5-5`, `high`, `fresh`,
`use_worktree: false`, `wake_when_done: true`, and a self-contained brief that opens "run the
skill yourself; start no other session". Not covered: whether the host accepts Opus 5.5 from
a Sonnet main session (the question says it may not), the host's own offer card, and the
finished reports. Open point: from a session the host started, with `HARNESS_ROLE` unset,
the replay treated itself as Bale (`#074`), so the worker rule relies on the brief's own
sentence to stop recursion.
