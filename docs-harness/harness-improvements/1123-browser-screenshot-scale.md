# Harness Improvement Resource

ID: #096_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Default Claude browser screenshots to scale 0.5 and zoom for detail
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

Changes: `utilizing-tools-claude` in `.agents/skills/` and `.claude/skills/`,
this record and the improvements README. The agy rule and agy's Chrome DevTools
MCP were tried and removed (see Decision and Result). Not changed: the agy,
Codex and OpenCode tool skills; no Claude mod or hook is installed.

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

agy replay through the Herdr desktop app, 2026-11-23 (`hc 0.1.22`, `agy` 1.5.14
banner, `gemini-4-hydrogen-high`, Load context, Skip permission, read-only):
the worker did the full session retrieval and asked for the same check on the
local page. It found no screenshot path: 14 built-in tools with no browser tool
(`/browser` is a User-only slash command), `agy mcp list` reports no MCP servers,
and `agy plugin list --json` returns `[]`, so `chrome-devtools-plugin` is not
installed in this profile, unlike `docs/tools/antigravity/README.md` (2026-11-21).
It stopped as briefed, made no browser call, and `git status` stayed clean.
No agy rule is added: there is no tool to write it for. Next case: once the User
authorizes installing Chrome DevTools MCP for agy (#009), read its screenshot
schema, add the matching line to `utilizing-tools-agy`, and replay with agy.

Install and second agy replay, 2026-11-23: the User authorized installing Chrome
DevTools MCP for agy. Added with `agy mcp add chrome-devtools -- npx -y
chrome-devtools-mcp@1.13.0 --isolated --usageStatistics=false --executablePath
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"` to the
global `~/.gemini/config/mcp_config.json` (empty before): the npm package is
Google's `ChromeDevTools/chrome-devtools-mcp`, pinned; Chrome is not installed
here, so it drives Edge; `--isolated` uses a temporary profile; usage statistics
are off. A fresh agy worker in a new Herdr tab (same model and choices) listed
the tools and schemas: `take_screenshot` has `pageId`, `filePath`, `format`
(png/jpeg/webp), `quality`, `fullPage`, `uid`; no `scale` and no zoom action.
Unprompted, it took the layout screenshot as `webp`, `quality: 50`, viewport
only (6.5 KB), then for the footer set `emulate` viewport `900x600x3`, saved a
PNG with `filePath` and cropped the footer locally; both verdicts were correct,
it closed its page, and `git status` stayed clean. The agy rule is not yet
written; `docs/tools/antigravity/README.md` (plugin enabled, 0 MCP) is stale.

Measurement, 2026-11-23 (User asked whether the rules really cut tokens):
- Claude built-in browser: the pane returns at most 800 px wide. `scale: 1` gave
  800x600 and 800x500 images, `scale: 0.5` gave 400x300 and 400x250. With
  Anthropic's `width x height / 750`, that is about 640 vs 160 tokens per
  screenshot (75% less). Tokens computed from returned sizes, not read from
  usage; Claude in Chrome (a larger real window) not measured.
- agy (`gemini-4-hydrogen-high`, one fresh session, prompt tokens per request
  read from the session's `transcript_full.jsonl`): a screenshot the model saw
  added about 1.3k prompt tokens (+1391 for webp and jpeg at 460x440; about the
  same for webp at 921x881), so pixel size and quality do not change the cost.
  PNG (17-29 KB) and a 13 KB JPEG were offloaded to a file and never shown to
  the model; webp/jpeg of 5-9 KB were shown, so a size limit near 10 KB is
  inferred. `take_snapshot` of the test page added about 0.37k tokens.
- Conclusion: the Claude rule saves tokens; for agy the lever is fewer images
  (snapshot first), and `webp` at `quality: 50` is what keeps an image visible,
  not cheaper.

agy rule, 2026-11-23: added the screenshot line and the MCP tools to the browser
row of `utilizing-tools-agy` (both mirrors); `harness_check.py` clean. Fresh agy
replay in a new Herdr tab (Load context, told to read the skill, task: layout
and footer text, no hint about tokens): it called `new_page`, `take_snapshot`
(footer text from the tree), one `take_screenshot` with `webp`/`quality: 50` for
the side-by-side layout, then `close_page`; both answers correct, repository
untouched. Still stale: `docs/tools/antigravity/README.md` (plugin
enabled, 0 MCP). Single page, single run: the 10 KB limit and the 1.3k cost
are observations, not documented behaviour.

User decision, 2026-11-23: keep the rule for Claude only; remove the agy rule
and the MCP, keeping this audit. Reverted both `utilizing-tools-agy` mirrors to
`HEAD` (never committed); ran `agy mcp remove chrome-devtools` and restored
`~/.gemini/config/mcp_config.json` to its earlier empty (0-byte) state; stopped
the `chrome-devtools-mcp` processes the test sessions had left running; deleted
its `npx` cache folder. `agy mcp list`: no MCP servers. Final decision: keep for
Claude; agy removed. The measurements above stand as the audit.
