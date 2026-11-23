# Harness Improvement Resource

ID: #098_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Give agy a working browser route through playwright-cli
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- .agents/skills/utilizing-tools-agy/SKILL.md
- docs/tools/antigravity/README.md
- docs-harness/harness-improvements/1123-browser-screenshot-scale.md
- R&D/browser-tools-research/reports/Browser_tools_token_comparison.md

## Objective

The `utilizing-tools-agy` skill routes browser work to `playwright-cli` 0.1.25
through `run_command`, with the steps that make it work on this machine (Edge,
session name, output folder outside the repository, text-first observation).

## Purposes

- [x] When Claude runs out of usage, the User can switch to `agy` and still ask
  the agent to interact with a browser (User request, 2026-11-24).
- [x] Keep the rule for `agy` only; Claude keeps the built-in browser pane
  (#096, #097).

## Current State

Baseline: `main` at `45fa0e6` (2 commits ahead of origin), clean. Tests on
2026-11-23/24 (Herdr, `agy` 1.5.15, `gemini-4-neon-high`): `/browser` invokes a
`browser` subagent whose built-in Chrome DevTools MCP looks for
`C:\Users\DEV\AppData\Local\Google\Chrome\User Data\DevToolsActivePort`; Google
Chrome is not installed, so `new_page` hung about 4.5 minutes and failed with
`ENOENT`. `agy plugin list --json` returned `[]` after the 2026-11-23 update
(`config.json` rewritten 09:00, binary replaced 09:19); `chrome-devtools-plugin`
1.10.1 was reinstalled on 2026-11-24 at the User's request and gives skills
only, no MCP server. The skill's browser row still points to those plugin
skills, and the README lists three enabled plugins. `playwright-cli` 0.1.25 ran
from Claude on 2026-11-23 with `--browser msedge` (all runs correct).

Authority: the User asked on 2026-11-24 to reinstall Playwright for `agy`;
`@playwright/cli@0.1.25` was installed globally (npm, pinned), no browser
download, no `install --skills`.

## Proposed Improvement

Replace the skill's browser row and add a short `agy` browser note; correct the
plugin facts in the skill and the Antigravity README.

## Scope

Changes: `utilizing-tools-agy` (both mirrors), `docs/tools/antigravity/README.md`
(plugin section), this record and the improvements README. Not changed: the
Claude skill, `.gitignore` (#046 keeps every file tracked, so the note sends
`playwright-cli` output to a temp folder instead).

## Progress

2026-11-24: `playwright-cli` installed; record created; skill note and README
plugin section written; `harness_check.py` clean. Replay 1 exposed three gaps
(see Decision and Result); step 3 of the note was rewritten and step 2 made
explicit, then replay 2 ran.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: an `agy` worker in Herdr with the changed skill does the
  shipping-form task on the local test page, with no hint about the tool; it
  should use `playwright-cli` per the note, answer correctly, close its session
  and leave `git status` unchanged.

## Risks

- `run_command` is sandboxed by default; launching a browser needs
  `BypassSandbox: true`, which raises a dialog the User answers when the
  worker is not started with Skip permission. Mitigation: the note names it.
- A global npm tool can disappear (uninstall, Node switch through nvm).
  Mitigation: the note starts with `playwright-cli --version` and tells the
  agent to report a missing tool instead of installing it.

## Decision and Result

**Keep.** `harness_check.py`: clean after each edit (skill mirror identical).

Replays, 2026-11-24, through the Herdr desktop app (`hc 0.1.22`, `agy` 1.5.15,
`gemini-4-neon-high`, Load context, Skip permission), each a fresh worker told
to read `utilizing-tools-agy` and do the shipping-form task on the local test
page, with no hint about the tool:
- Replay 1 (first note): the worker picked `playwright-cli` from the skill,
  worked from `$env:TEMP\agy-playwright` with `--browser msedge`, and answered
  all three items correctly, checking layout with `eval` (grid columns and card
  rectangles) and taking no screenshot. Gaps: the browser session ended when the
  `run_command` shell exited, so the next command failed; PowerShell stripped
  double quotes inside a single-quoted `eval`; `run_command` exposed no
  `BypassSandbox` parameter under Skip permission. 5 `run_command` calls, 1
  failed; session total 61.9k tokens.
- Replay 2 (revised note: one `run_command` per flow, quoting rule,
  `BypassSandbox` only when offered): a snapshot run, then one run for open,
  fill, select, check, click, snapshot, `eval`, close; no failed command; all
  three answers correct; `playwright-cli list` showed no browsers; 3
  `run_command` calls, session total 56.5k tokens (about 33k of it the Load
  context retrieval). It reported that `--help` showed no skill path, although
  the third line carries it here; step 2 now names that line.

Both runs left `git status` unchanged and wrote only under
`$env:TEMP\agy-playwright` (removed after replay 1).

Headed check, 2026-11-24 (User request), follow-up to the replay 2 worker: told
the User wants to watch, it re-read the note and ran one `run_command` with
`--browser msedge --headed` and 2-second pauses (`eval` with `setTimeout`)
between actions. A process watch from the coordinator saw one Edge browser
process without `--headless` for about 25 s; `playwright-cli list` reported
`headed: true`; all three answers correct; session closed, no Edge left. Gap:
the temp folder had been deleted after the earlier runs and the command did
`Set-Location` without creating it, so `.playwright-cli/` (four log and
snapshot files) landed in the repository root; the worker found and removed it
and `git status` stayed unchanged. Step 3 now gives the exact first line that
creates the folder and enters it; that wording was not replayed.

Replay 3, fresh worker, temp folder absent beforehand: the command began with
the step 3 line, the folder was created and all `.playwright-cli/` output
stayed in it; answers correct; sessions closed; `git status` unchanged. It again
found no `Agent skill:` line. Cause, from `playwright-core`
`lib/tools/cli-client/program.js`: `--help` prints that line only when
`CLAUDECODE` or `COPILOT_CLI` is set, so `agy` never sees it. Step 2 now builds
the path from `npm root -g` (checked: the file exists at that path).

Replay 4, fresh worker, temp folder absent: it ran `playwright-cli --version`
and the `Join-Path (npm root -g) …` line, read the skill file, used the step 3
line, and answered all three items correctly; browser closed, output only
under the temp folder, `git status` unchanged; session total 68.4k tokens.

Limits: one small local page and one model; a logged-in site and a sandboxed
session that offers `BypassSandbox` were not exercised.
