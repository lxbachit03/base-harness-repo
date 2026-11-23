# Harness Improvement Resource

ID: #096_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Default browser screenshots to scale 0.5 and zoom for detail
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- .agents/skills/utilizing-tools-claude/SKILL.md
- R&D/claude-mods-research/reports/Three_Claude_Code_mods_2.md

## Objective

The `utilizing-tools-claude` skill tells Claude to pass `scale: 0.5` on routine
browser and computer-use screenshots and to `zoom` into a region when it needs
small text or visual detail.

## Purposes

- [x] Cut screenshot image tokens to about a quarter without installing the
  third-party `efficient-browser` mod (User request, 2026-11-23).
- [x] Keep full detail reachable: `zoom` covers small text and visual bugs, so
  the lower default does not hide what the task needs.

## Current State

Baseline: `main` at `6c558a0` (2 commits ahead of origin), clean. The skill's
only browser line routes sign-in and script-rendered pages to the built-in
browser; nothing sets a screenshot scale, so agents take full-resolution
screenshots by default. The `efficient-browser` mod research
(`R&D/claude-mods-research/`) found the mod forces `scale: 0.5` with a hook but
is unpinned, one day old and never run live; the report proposed this one-line
rule instead. Both browser tools' schemas in this session expose `scale`
(0.5 ≈ a quarter of the tokens; click coordinates stay in the full-resolution
frame) and a `zoom` action.

## Proposed Improvement

One line under the Phase 1 capability table of `utilizing-tools-claude`
(both mirrors) stating the default and the zoom route.

## Scope

Changes: the skill in `.agents/skills/` and `.claude/skills/`, this record and
the improvements README. Not changed: other agents' `utilizing-tools-*` skills
(their browsers expose different tools), no mod or hook is installed.

## Progress

2026-11-23: record created; rule added to both mirrors. `harness_check.py`
first reported 35 broken `R/` shorthand links in the efficient-browser research
note; expanded them to full GitHub URLs; the check then passed.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: an agent loads the skill and takes a screenshot of a local page
  in the built-in browser for a routine check, then needs small text; it should
  pass `scale: 0.5` first and use `zoom` for the detail.

## Risks

- A soft rule: an agent may still take full-resolution screenshots.
  Mitigation: the line sits beside the tool table the skill makes agents read;
  the replay checks compliance.
- Lower detail hides a visual bug. Mitigation: the rule names `zoom` for small
  text and visual detail.

## Decision and Result

**Keep.** `harness_check.py`: clean (96 IDs, links, skill mirror 20 skills / 70
files identical).

Fresh replay, 2026-11-23: a separate agent was told to read the skill, then
check the layout of a local scratchpad page in the built-in browser and read its
7px footer visually; the prompt did not mention scale or zoom. All three of its
screenshots passed `scale: 0.5`, and it read the footer with two `zoom` calls on
the footer region. Layout verdict and footer text were both correct. Observed
limits: the built-in browser refuses page tools on a `file://` tab, so the agent
served the folder on `127.0.0.1` and used that; it reported that `zoom` crops
without enlarging, so tiny text stays at native size (it still read the text
correctly). Not exercised: Claude in Chrome, computer-use, a real visual bug.
