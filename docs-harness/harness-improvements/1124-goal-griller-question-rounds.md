# Harness Improvement Resource

ID: #099_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Ask goal-griller questions in rounds with yes-accepts recommendations
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- .agents/skills/goal-griller/SKILL.md
- R&D/aihero-skills-research/Wayfinder_va_grill_me.md

## Objective

The `goal-griller` interview asks, in each turn, every hard-gate question whose
answer does not depend on another open answer (a round); a question that
depends on an earlier answer waits for a later round. Each question carries a
recommended answer and is worded so that "yes" accepts it.

## Purposes

- [x] Shape a goal in fewer User turns when the open fields are independent,
  while keeping dependent questions apart (User acceptance of the review,
  2026-11-24).
- [x] Let the User answer a question with "yes" or by its number, lowering the
  cost of each answer.

## Current State

Baseline: `main` at `6d8e5ce`, clean except the untracked
`R&D/aihero-skills-research/`. `goal-griller` (both mirrors identical) says
"ask one question at a time" in its intro and "Ask exactly one question at a
time" in step 4 of the Interview Loop; it asks for a recommended answer with a
reason but says nothing about wording or numbering. The research report on Matt
Pocock's `grilling` skill (MIT, `mattpocock/skills`) describes rounds over the
decision frontier, numbered questions with a recommendation, and "yes" accepts
the recommendation; the User accepted adopting those two ideas on 2026-11-24.
No observed goal-griller run in this repo measured turn count; the replay
below supplies the baseline.

## Proposed Improvement

Rewrite the intro sentence and steps 4–5 of the Interview Loop in
`goal-griller` (both mirrors).

## Scope

Changes: `goal-griller` SKILL.md in `.agents/skills/` and `.claude/skills/`,
this record and the improvements README. Not changed: the hard gate, Question
Priority order, routing, goal prompt contract, `agents/openai.yaml`.

## Progress

2026-11-24: record created; Interview Loop and intro rewritten in both mirrors; harness_check clean; replay A/B run.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: agents given the baseline skill and the changed skill each run
  the same vague goal request against a scripted User; compare User turns to a
  draftable goal, whether dependent questions shared a round, recommendation
  wording, and goal quality.

## Risks

- A round that is too long tires the User. Mitigation: only questions that
  block the goal and are independent of each other enter a round.
- Bundling hides a dependency the agent missed. Mitigation: the rule names the
  dependency test and the User can reopen a branch.

## Decision and Result

**Keep.** `harness_check.py`: clean (99 IDs, links, skill mirror 20 skills / 70
files identical).

Replay, 2026-11-24: two fresh agents in this repository, same request ("make
`harness_check` faster; write a `/goal` prompt for Codex, do not set it"),
read-only, one script run allowed; A followed a copy of the baseline skill, B
the changed skill; the coordinator played the User with the same intent
(full mode, median of 5 runs under 1 s, scope only the script, no new unit
tests, stop and report if already met, `improve-harness` route):
- A (baseline): one question per turn, each with a recommendation and reason.
  Two answer turns (Q1 target, Q2 what to do when the target is already met),
  then the draft. 94.5k tokens in total.
- B (changed): one round of six numbered questions, each worded so "yes"
  accepts the recommendation, plus an invitation to answer by number. One
  answer turn ("1 yes, 2 yes but under 1 s, 3–6 yes"), then the draft. 89.6k
  tokens in total.

Both drafts met the hard gate, measured first, kept the script mirror and
output byte-identical, and paused before narrowing a check. B's draft also
named the profile step and the `--requirements` mode. In B, question 5 (stop
if the baseline is under 0.3 s) depended on question 2 (the target) and still
shared the round; B noticed the overlap and reconciled it in the draft, so no
extra turn was needed, but the dependency test was applied loosely. B also
asked a routing question (Q6) that the skill lets it settle from evidence.

Result: User answer turns went from 2 to 1 on this task, with the same goal
quality. Limits: one scenario, one model, a scripted User; the effect on
tasks where most fields depend on the first answer is untested.
