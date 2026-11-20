# Harness Improvement Resource

ID: #077_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Run prd-research in a new Opus 5.5 high-effort sub-session when the User is on Claude
CREATED: 2026-11-20
STATUS: active
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

Unattempted: a fresh Claude session on Opus 5.5 that is asked for `prd-research` (see
Decision).

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

Decision: pending fresh rerun. The instruction is the implementation; whether a Claude
session follows it when the skill is invoked is unverified.

Replay task: in a new session on Opus 5.5, ask for `prd-research` on a small sample PRD;
expect one question, then after a yes one session with `claude-opus-5-5` and effort high, a brief that
names the document and ticket, and no second session. Run a second case from a Sonnet
session and expect the "cannot get Opus 5.5" message with the question. Owner: the next
primary session or the User. Cost: about 100k tokens per case, no build; both cases leave
the finished reports unchecked.
