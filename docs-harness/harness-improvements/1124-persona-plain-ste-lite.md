# Harness Improvement Resource

ID: #100_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Add a Plain / Controlled (STE-lite) response persona
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs-harness/PERSONA.md
- R&D/karpathy-llm-output-research/Dinh_dang_output_LLM.md

## Objective

`PERSONA.md` offers a fifth persona, Plain / Controlled (STE-lite), in the same
format as the other four. When the User selects it, chat responses follow the
core rules of Simplified Technical English: short sentences, one idea per
sentence, active voice, one meaning per term.

## Purposes

- [x] Give the User a selectable chat style that is easier to read and check,
  following Karpathy's tip to ask for "80% of the way to ASD-STE100" (User
  approval, 2026-11-24).
- [x] Keep the scope of PERSONA.md unchanged: chat only, one selection, Default
  stays selected until the User changes it.

## Current State

Baseline: `main` at `37b8ea3`, clean except the untracked
`R&D/karpathy-llm-output-research/`. `PERSONA.md` lists four personas
(Default selected, Senior Architect, Minimalist, Friendly Pair Programmer);
none sets sentence-level writing rules. The research report's proposal 1
suggests an STE-lite style; the User asked to add it as a PERSONA option on
2026-11-24, after being told that the option is exclusive with the other
personas and applies to chat only.

## Proposed Improvement

Add one checklist entry to `PERSONA.md` with a description and a when-to-use
line. The current selection does not change.

## Scope

Changes: `PERSONA.md`, this record, the improvements README. Not changed: the
selection, the scope and fallback rules of `PERSONA.md`, report or
documentation style rules.

## Progress

2026-11-24: record created; option added; harness_check run; replay run.
2026-11-24: after reading both replay answers, the User selected STE-lite as
the active persona (Default unchecked).

## Validation

- `harness_check.py` on the repo.
- Fresh replay: one agent with a copy of `PERSONA.md` where STE-lite is the only
  `[x]` answers the same question as one with the baseline (Default). Compare
  sentence length, one idea per sentence, active voice, and that facts stay
  equal.

## Risks

- Short sentences can drop nuance or caveats. Mitigation: the description keeps
  facts and caveats and splits them into more sentences.
- Vietnamese answers: STE is defined for English. Mitigation: the description
  names the rules that carry across languages.

## Decision and Result

**Keep.** `harness_check.py`: clean (100 IDs, 1156 links, skill mirror 20
skills / 70 files identical).

Replay, 2026-11-24: two fresh read-only agents in this repository, each told to
use a scratchpad copy of `PERSONA.md` instead of the repo file. A had the
baseline (Default `[x]`); B had the changed file with only STE-lite `[x]`. Same
question in Vietnamese: explain the ticket lifecycle (states, when a ticket
moves from active to completed, what the move requires), from
`docs-harness/tickets/README.md`.
- A (Default): correct and structured, five sections. Several sentences carry
  two or three ideas joined by commas or "và"; the five states are listed in
  one sentence.
- B (STE-lite): same five sections and the same facts. One idea per sentence,
  short sentences, active voice, one bullet per state, numbered steps for the
  move, and "chỉ đọc" requests named as not granting the move. B also listed
  the INDEX Folder Tree update, which the move in this session needed. About
  10% longer than A because facts were split, not dropped.

Result: the option was retrieved and exercised; the answer kept every fact and
caveat and followed the sentence, voice and term rules in Vietnamese. Limits:
one question, one model, no User reading test. B called the reader "User" in
the third person where A used "bạn"; the persona does not set the form of
address.
