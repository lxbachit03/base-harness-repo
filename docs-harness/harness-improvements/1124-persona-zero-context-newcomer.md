# Harness Improvement Resource

ID: #101_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Add a Zero-Context Newcomer response persona
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs-harness/PERSONA.md
- docs-harness/harness-improvements/1124-persona-plain-ste-lite.md

## Objective

`PERSONA.md` offers a sixth persona, Zero-Context Newcomer. When the User
selects it, the agent explains as if the reader knows nothing about the topic
or the conversation so far: it restates the needed context, defines each term
and file name the first time, and says why each point matters.

## Purposes

- [x] Let the User read an answer without holding the earlier conversation or
  the domain in mind (User request, 2026-11-24).
- [x] Produce an answer the User could pass to someone outside the
  conversation without rewriting it.

## Current State

Baseline: `main` at `c38c801`, clean. `PERSONA.md` has five options; STE-lite
is selected (#100). Friendly Pair Programmer explains step by step with
analogies, but assumes a shared session and sets no rule to restate context or
define terms. No option writes for a reader with no context.

## Proposed Improvement

Add one checklist entry to `PERSONA.md` with a description and a when-to-use
line. The current selection (STE-lite) does not change.

## Scope

Changes: `PERSONA.md`, this record, the improvements README. Not changed: the
selection, the scope and fallback rules of `PERSONA.md`.

## Progress

2026-11-24: record created; option added; harness_check run; replay run.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: one agent with a copy of `PERSONA.md` where the new option is
  the only `[x]` answers the ticket-lifecycle question used in #100. Compare
  with the #100 answers (Default, STE-lite): context restated, terms defined,
  facts kept, length.

## Risks

- Longer answers. Mitigation: define only terms the answer uses; skip what the
  question does not need.
- Talking down to the User. Mitigation: plain, respectful tone; no
  exaggerated simplification that changes facts.

## Decision and Result

**Keep.** `harness_check.py`: clean.

Replay, 2026-11-24: one fresh read-only agent used a scratchpad copy of
`PERSONA.md` with only Zero-Context Newcomer `[x]` and answered the same
ticket-lifecycle question as the #100 replays (A Default, B STE-lite).
- C opened with what a ticket is and which file the rules come from; defined
  slug, batch, acceptance criteria (AC), DoD, `decision/`, waived and
  defaulted at first use; gave an example of a blocker and of prior
  permission; added one "why" paragraph (completed/ is User-confirmed history,
  so the agent does not move a ticket alone); closed with a one-line summary
  of the flow.
- Facts matched A and B. Like A, C did not mention the INDEX Folder Tree
  update that B listed. C addressed the reader as "bạn".
- C was the longest answer, about 1.8 times A, from the definitions and the
  context opener.

Result: the option was retrieved and exercised; the answer stood on its own
for a reader without the repo or the conversation. Limits: one question, one
model; length cost is real for readers who already know the context.
