# Harness Improvement Resource

ID: #104_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Sub-session instructions: fall back when the host has no session tool
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs-harness/claude-instructions/coding-sub-session.md
- docs-harness/claude-instructions/prd-research-sub-session.md
- docs-harness/harness-improvements/1124-code-mode-claude-p-worker.md

## Objective

When a Claude session has no tool to start another session, as in `claude` in a
terminal, the coding instruction does the task in the current session and the
prd-research instruction asks whether to run the skill in the current session.

## Purposes

- [x] Keep both instructions usable after the User moved daily work from Claude
  Desktop to `claude` in a terminal with Code Mode (User request, 2026-11-24).
- [x] Keep the prd-research model guard: the skill runs on another model only after
  the User says so.

## Current State

Baseline: `main` at `d5626a8`, clean. Step 2 of both files starts the new session with
"the host's session tool (`mcp__ccd_session__start_session` in the Claude desktop
app)". Neither file says what to do when the host has no such tool. A `claude -p`
worker's tool list on 2026-11-24 (Claude Code 2.1.331) had no session tool; the
interactive terminal tool list was not checked.

## Proposed Improvement

Add one sentence to step 1 of each file.

## Scope

Changes: step 1 of the two files, this record, the improvements README. Not changed:
effort and advisor choices, the other steps, `research-subagents.md`.

## Progress

2026-11-24: record created; sentences added; `harness_check.py` clean (104 IDs);
replay passed (see Decision and Result).

## Validation

Native: `harness_check.py` and a diff review. Behavior: one fresh replay covering both
files (see Decision and Result).

## Risks

- Both files load in every Claude session, so each sentence adds context load.
  Proposal: one short sentence per file.
- Doing coding work here uses the current model, not Sonnet. Proposal: accepted; in a
  terminal the User picks the model at start.

## Decision and Result

Keep. Replay on 2026-11-24 (User go-ahead): one fresh Haiku 5.5 Explore subagent,
effort high, 46.2K subagent tokens, read only the two files, ran no commands, as `claude` in a terminal with
no session tool. Case 1, "Fix the typo 'recieve' in src/app.py": it said in one line
that no session tool exists and did the fix here, with no effort question (step 1).
Case 2, "Run prd-research on docs/prd/billing.md for ticket 01-sample-ticket": it said
no Opus 5.5 session can start, asked whether to run the skill here, named the model
difference, and waited (step 1 with step 4's model guard).

Limits: a planning replay, not an execution; the interactive terminal tool list was
not checked. Open point it named: "ask only" in the prd-research sentence does not
require naming the model difference; the agent named it anyway.
