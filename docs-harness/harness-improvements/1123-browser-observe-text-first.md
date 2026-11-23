# Harness Improvement Resource

ID: #097_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Observe browser pages text-first and wait for a fresh tab before read_page
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- .agents/skills/utilizing-tools-claude/SKILL.md
- docs-harness/harness-improvements/1123-browser-screenshot-scale.md
- R&D/browser-tools-research/reports/Browser_tools_token_comparison.md

## Objective

The `utilizing-tools-claude` skill tells Claude to observe browser pages
text-first (`get_page_text` or `find`, then a filtered `read_page`, then a
`scale: 0.5` screenshot, then `zoom`), to batch actions with one observation
per batch, and to confirm a freshly opened tab has rendered before `read_page`.

## Purposes

- [x] Cut tokens per browser task through observation habits rather than a new
  tool: the browser-tools research found this is the main lever, and neither
  Claude in Chrome nor `playwright-cli` beat the pane (User request,
  2026-11-23).
- [x] Remove the wasted calls seen in every pane benchmark run, where
  `read_page` on a just-opened tab returned an empty page (viewport 0x0).

## Current State

Baseline: `main` at `ff589d7`, clean except the untracked
`R&D/browser-tools-research/`. The skill's only browser-observation line is the
#096 screenshot rule (`scale: 0.5`, `zoom` for detail). Pane benchmark on a
local shipping-form page (fill, submit, read confirmation, check two-column
layout, read a 7px footer), three fresh agents, 2026-11-23: task tokens about
12.7k, 12.9k and 13.8k (mean about 13.1k, subagent total minus a 52.7k
no-tool baseline); all three called `read_page` right after opening the tab and
got an empty page with a 0x0 viewport, once or twice each; one run read the
whole tree (`filter: all`); one run tried `zoom` on the 7px footer, could not
read it and fell back to the tree.

## Proposed Improvement

Extend the #096 line under the Phase 1 capability table of
`utilizing-tools-claude` (both mirrors) into a short browser-observation
paragraph.

## Scope

Changes: `utilizing-tools-claude` in `.agents/skills/` and `.claude/skills/`,
this record and the improvements README. Not changed: other tool skills, the
#096 record, installed tools (`playwright-cli` 0.1.25 stays installed globally
at the User's request).

## Progress

2026-11-23: record created; rule added to both mirrors; `harness_check.py`
clean. Revised twice from replay evidence (see Decision and Result): the first
wording ("first `find` text the task needs") and the second ("open with
`preview_start`") both missed the cause.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: three agents with the changed skill run the same pane task and
  prompt as the baseline; compare task tokens, wasted empty `read_page` calls,
  observation order, and correctness.

## Risks

- Waiting adds a call when the tab was already rendered. Mitigation: the check
  is a `find` for a word the task already needs, so it does work as well.
- Text-first can miss visual defects. Mitigation: the rule keeps a screenshot
  for layout and visual checks.

## Decision and Result

**Keep.** `harness_check.py`: clean (97 IDs, links, skill mirror 20 skills / 70
files identical) after each revision.

Replays, 2026-11-23: fresh agents, same prompt and page as the baseline (no
hint about the rule), task tokens = subagent total minus a 52.8k no-tool
baseline (re-measured: 52,798):
- Wording 1 ("`find` text first"): 13.8k, 11 tool uses, 29.5 s. The agent still
  called `read_page` first, and `read_page` stayed empty even after `find`
  found the form, so the rule named the wrong cause.
- Direct check in the main session: a pane opened by `navigate` reported
  `Viewport: 0x0` on two `read_page` calls while `find` worked; one screenshot
  set the viewport to 1024x768 and `read_page` then returned all refs. A pane
  opened by `preview_start` returned refs at once in that session.
- Wording 2 ("open with `preview_start`"): 13.0k, 9 tool uses, 21.1 s. The agent
  used `preview_start` and still got a 0x0 viewport once, so the cause is timing
  until the first screenshot, not the opening tool.
- Final wording (screenshot before the first `read_page`), two runs: 12.4k with
  7 tool uses in 19.8 s, and 12.5k with 5 tool uses in 17.9 s. Both took the
  screenshot first, had no empty `read_page`, batched the form actions with one
  `get_page_text` at the end, and read the 7px footer with `find`. All answers
  correct in every run; tabs closed.

Against the baseline (13.1k mean, 7–9 tool uses, 21.8–25.1 s, an empty
`read_page` in every run), the final rule saved about 0.6k tokens (about 5%),
removed the wasted calls and shortened runs by about 4 s. Limits: two runs on
one small page and one model; token savings on larger pages, where an
unfiltered `read_page` or a full-page screenshot is the costly mistake, are
untested; the 0x0 viewport behaviour is an observation of this Desktop host,
not documented.
