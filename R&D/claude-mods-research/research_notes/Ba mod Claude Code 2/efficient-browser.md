# efficient-browser (Sagor31h2/claude-mods): research notes

Snapshot read: branch `dev`, commit `90df9ee2d7bf04cecf06c72f40c703cd6f4732fb` ("Add README", 2026-11-15T09:19:12Z). No `main` branch exists: the branches API lists only `dev`, and `commits/main` returns "No commit found for SHA: main"; `dev` is the repo's default branch. Research date 2026-11-23. Files were downloaded (not executed) to `C:\Users\DEV\AppData\Local\Temp\claude\0ed3496d66f1fae8\0177b282-eb90-4624-92e8-d40ef616ad25\scratchpad\mods2\efficient-browser\src`.

Shorthand: `R` = `https://github.com/Sagor31h2/claude-mods/blob/90df9ee2d7bf04cecf06c72f40c703cd6f4732fb`. API = `https://api.github.com/repos/Sagor31h2/claude-mods`.

## What does it do, and exactly how does the code work?

### Takeaway
It does one small thing. It hooks `tool.call` and adds `scale: 0.5` (configurable, clamped to 0.1–1) to screenshot actions on a fixed list of seven browser and computer-use tools when the model did not set `scale`. Zoom actions are scaled only if the user opts in. It does not touch tool results, deny calls, add system-prompt text, call a model, start processes or use the network. Its only state is one on/off flag in the plugin's own `$.store`, and it adds a `/efficient-browser [on|off|status]` slash command.

### Cited Findings
- **Files (whole mod, 4 files, about 8.3 KB):** `.claude-plugin/plugin.json` (653 B), `hooks/hooks.json` (30 B), `hooks/register.ts` (3,015 B, 99 lines), `hooks/register.test.ts` (4,574 B, 111 lines) — [API git tree](https://api.github.com/repos/Sagor31h2/claude-mods/git/trees/90df9ee2d7bf04cecf06c72f40c703cd6f4732fb?recursive=1)
- **Manifest:** name `efficient-browser`, version `0.1.0`, description "Adds scale 0.5 to browser and computer-use screenshots when unset." It has no engine/version requirement, dependencies or `types` field — [plugin.json L1-L4](R/mods/efficient-browser/.claude-plugin/plugin.json)
- **userConfig:** `scale` (number, default 0.5, "between 0.1 and 1"), `scaleZoom` (boolean, default false, "Also scale zoom actions"), `extraTools` (string, default "", comma-separated extra tool names) — [plugin.json L5-L24](R/mods/efficient-browser/.claude-plugin/plugin.json)
- **hooks.json:** `{"modules":["./register.ts"]}`. It is a hooks module, with no shell-command hooks — [hooks.json L1](R/mods/efficient-browser/hooks/hooks.json)
- **Tools targeted (hardcoded):** `mcp__Claude_Browser__computer`, `mcp__Claude_Browser__browser_batch`, `mcp__claude-in-chrome__computer`, `mcp__claude-in-chrome__browser_batch`, `mcp__computer-use__screenshot`, `mcp__computer-use__zoom`, `mcp__computer-use__computer_batch` — [register.ts L5-L13](R/mods/efficient-browser/hooks/register.ts#L5-L13)
- **Not targeted:** Playwright MCP, WebFetch, `get_page_text`/`read_page`, `mcp__remote-devices__Claude_Browser__*` (the cloud-linked name of the built-in browser), and Bash-driven screenshots such as `orca screenshot`. None of these appear in the list above, though users can add exact names through `extraTools` — [register.ts L5-L13, L57-L60](R/mods/efficient-browser/hooks/register.ts#L57-L60)
- **Rewrite logic:** `scaleWalk` copies the tool-call event recursively. Any object whose `action` is `"screenshot"` (or `"zoom"` when `scaleZoom` is on) and has no `scale` gets `scale = cfg.scale`. Any object whose `name` is `"screenshot"`/`"zoom"` and has a record `input` without `scale` gets `input.scale`. A `scale` the model set is never overwritten — [register.ts L18-L38](R/mods/efficient-browser/hooks/register.ts#L18-L38)
- **Batch shape:** for `browser_batch` items shaped `{name:'computer', input:{action:'screenshot'}}`, the walk reaches the inner `input` record through its `action` key and scales it — [register.ts L26-L31](R/mods/efficient-browser/hooks/register.ts#L26-L31); test [register.test.ts L39-L53](R/mods/efficient-browser/hooks/register.test.ts#L39-L53)
- **Per-tool fallback:** `patch` returns `undefined` for tools outside the list. When the last `__` segment of the tool name is `screenshot` (or `zoom` with `scaleZoom`), it also sets a top-level `scale`. This covers `mcp__computer-use__screenshot`, which has no `action` field — [register.ts L40-L47](R/mods/efficient-browser/hooks/register.ts#L40-L47)
- **Config parsing:** `scale` goes through `Number()`. A non-finite value becomes 0.5; anything else is clamped to [0.1, 1]. `zoom` is on only when `options.scaleZoom === true` — [register.ts L52-L60](R/mods/efficient-browser/hooks/register.ts#L52-L60)
- **Events hooked (3):** `session.start` registers the slash command, with its errors swallowed ([L62-L71](R/mods/efficient-browser/hooks/register.ts#L62-L71)). `command.run` with matcher `{command:'efficient-browser'}` handles on/off/status ([L73-L86](R/mods/efficient-browser/hooks/register.ts#L73-L86)). `tool.call` has no matcher, so it runs on every tool call and filters inside `patch` ([L88-L98](R/mods/efficient-browser/hooks/register.ts#L88-L98)). No `prompt.compose`, `ui.render`, `tool.result`, `tool.list` or `tool.offer` hooks — [register.ts](R/mods/efficient-browser/hooks/register.ts)
- **`$` APIs used:** `$.command.register`, `$.store.get('enabled')`, `$.store.set('enabled', bool)`. Nothing else — [register.ts L64, L77, L81, L91](R/mods/efficient-browser/hooks/register.ts)
- **What the user sees:** a `/efficient-browser` command whose text replies are `efficient-browser on|off`, `Usage: on|off|status` or `efficient-browser error`. There is no toast, panel or status line — [register.ts L65-L84](R/mods/efficient-browser/hooks/register.ts#L65-L84)
- **The `tool.call` event shape matches the mod's assumption.** The tool's arguments sit at the top level of the event beside the reserved keys `tool`, `tool_use_id` and `consent`, which "none of which the tool sees (the engine strips them before the tool runs)". So writing `scale` at the top level of `e` reaches the tool — local mod API typings, `plugin-authoring/types/claude-code.d.ts` L17738-L17765 (`ToolCallInput`, `ToolCallReserved`)
- **`$.store` scope:** it is "This plugin's own key-value store, kept between sessions and hot reloads … A JSON file of the plugin's own under the user's Claude Code configuration directory." So `/efficient-browser off` applies user-wide, in every project — local typings `claude-code.d.ts` L4115-L4121
- **Tests:** 9 tests using `claude-code/testing`. They cover: unset scale added and existing scale kept; other actions and tools untouched; nested batch; computer-use screenshot, batch and name-shaped items; zoom skipped by default; zoom with `scaleZoom` and custom scale 0.3; `extraTools`; `/efficient-browser` off/on/status/bogus; persisted off state — [register.test.ts L21-L111](R/mods/efficient-browser/hooks/register.test.ts)

### Inferences
- The token saving comes entirely from the target tools' own `scale` parameter. The mod only fills in a default the model could pass itself.
- The unmatched `tool.call` hook runs on every tool call (Bash, Read and so on), but its work for non-target tools is one `$.store.get` plus an array lookup. The overhead is small, though not zero: a store read on every call.

### Gaps
- The mod was not run (the constraints forbid it), so the live behaviour was not seen, including whether the transcript or the model's view shows the injected `scale`.

## Correctness risks, failure mode, measured savings

### Takeaway
It fails open: any error passes the original call through unchanged. Clicks stay correct, because the browser tools report coordinates in the full-resolution frame even for scaled images. The main risk is legibility: at 0.5 each image dimension is halved, so small text, thin borders and subtle visual bugs are harder to see. Zoom is left alone by default, which keeps a full-detail route. The author measured no savings and says the mod was never run in a live session.

### Cited Findings
- **Fail-open:** `patch` runs inside `try {…} catch { patched = undefined }`, and the hook then calls `next(e)` with the original event — [register.ts L89-L97](R/mods/efficient-browser/hooks/register.ts#L89-L97)
- If the hook itself throws outside that try (for example in `next`), the engine skips the hook and the call goes on. The mod has no `.catch` handler, and the reference says that without one, what a hook judges "goes on when it throws, answers a wrong shape or outlasts its budget" — local `plugin-authoring/reference.md` L128
- Claude in Chrome `computer` schema on `scale`: "For `screenshot` and `zoom` only. Scale factor in [0.1, 1] … 0.5 returns an image at half the width and height (~quarter of the tokens). Coordinates are ALWAYS in the full-resolution coordinate frame (reported with every scaled screenshot) … Requires a Claude in Chrome extension version that supports scale; older extensions return the full-size image." — tool schema of `mcp__claude-in-chrome__computer` as loaded in this session (Claude Code Desktop 2.1.330)
- The built-in browser's `mcp__Claude_Browser__computer` schema has the same `scale` parameter and the same full-resolution coordinate note — tool schema in this session
- **Author's known limits:** "Only tested with the plugin test kit, not in a live session." and "efficient-browser: input shapes for `mcp__Claude_Browser__*` and `mcp__computer-use__*` are guessed. Add tool names through `extraTools` if they differ." — [README.md L30-L31](R/README.md#L28-L31)
- **Model override wins:** an explicit `scale` (even 1) is never overwritten — [register.ts L31, L35, L43](R/mods/efficient-browser/hooks/register.ts#L31); tests [L24-L26, L46, L52](R/mods/efficient-browser/hooks/register.test.ts#L21-L27)
- **No measured token savings:** neither the README nor the manifest gives any figure apart from the "Scales browser screenshots to 0.5" description — [marketplace.json L8](R/.claude-plugin/marketplace.json#L8), [README.md](R/README.md)

### Inferences
- **Information loss:** halving resolution can hide visual details that only show at full size. The model can still ask for `scale: 1` or use `zoom` (unscaled by default), but only if it notices. Downscaled shots by default may push it into extra zoom calls, which eats into the saving.
- **Possible tool errors:** the top-level `scale` added to `mcp__computer-use__screenshot` / `zoom` / `computer_batch` relies on a guessed input shape. If those tools reject unknown properties, screenshots there could fail. That would be a hard error, not a silent pass, because the rewrite already happened. Not verified: computer-use tools were not loaded in this session.
- **Over-reach in the walk:** `scaleWalk` copies every nested object and scales any nested record with `action: "screenshot"`. For the listed tools this matches the real shapes, and I found no realistic false positive.
- **Older Claude in Chrome extensions** ignore `scale` and return full size, so the mod does nothing there. That is harmless.

### Gaps
- No measured before/after token data exists. The "~quarter of the tokens" figure comes from the tool's own schema text, not from the mod's author.
- Whether `mcp__computer-use__*` tools accept `scale` is unknown.

## Install, release status, version requirements

### Takeaway
Install is through a root-level marketplace named `my-mods` on the default `dev` branch: `claude plugin marketplace add Sagor31h2/claude-mods`, then `claude plugin install efficient-browser@my-mods --scope user`. There is no `main` branch, release or tag, so "released on main" does not apply: `dev` is the only line. No minimum Claude Code version is declared.

### Cited Findings
- `marketplace.json` at the repo root: `"name": "my-mods"`, `"owner": {"name": "local"}`, four plugins. Entry: `{"name":"efficient-browser","source":"./mods/efficient-browser","description":"Scales browser screenshots to 0.5 by default."}` — [.claude-plugin/marketplace.json L1-L10](R/.claude-plugin/marketplace.json)
- Install commands: `claude plugin marketplace add Sagor31h2/claude-mods` then `claude plugin install efficient-browser@my-mods --scope user`. "The marketplace lives on the `dev` branch. If `marketplace add` does not find it, use `Sagor31h2/claude-mods#dev`." — [README.md L5-L15](R/README.md#L5-L15)
- Options are changed with `/plugin configure <name>@my-mods` — [README.md L26](R/README.md#L26)
- Branches: only `dev` (head `90df9ee2d7`). The default branch is `dev`. There is no `main` — [API branches](https://api.github.com/repos/Sagor31h2/claude-mods/branches), [API repo](https://api.github.com/repos/Sagor31h2/claude-mods), [API commits/main](https://api.github.com/repos/Sagor31h2/claude-mods/commits/main)
- Releases: none. Tags: none — [API releases](https://api.github.com/repos/Sagor31h2/claude-mods/releases), [API tags](https://api.github.com/repos/Sagor31h2/claude-mods/tags)
- The manifest declares no engine/version constraint — [plugin.json](R/mods/efficient-browser/.claude-plugin/plugin.json)

### Inferences
- Without a tag or release, `marketplace add` follows the moving `dev` head. Pinning would need a fork or a specific-ref install; the README documents neither.
- The marketplace name `my-mods` is generic and its owner is recorded as "local". It could clash with another marketplace of the same name the user adds later.

### Gaps
- The minimum Claude Code version that supports hooks-module plugins with `$.command.register` and `$.store` was not determined from public sources.

## Maturity, trust, author, other mods

### Takeaway
This is a brand-new, single-author hobby repo: 1 star, 0 forks, 4 commits pushed within about 6 minutes on 2026-11-15, no issues, releases or outside discussion. MIT licensed. Web searches found no catalogue listing or discussion. The repo name `claude-mods` collides with the larger, unrelated `0xDarkMatter/claude-mods`.

### Cited Findings
- Stars 1, forks 0, open issues 0, created 2026-11-15T09:13:11Z, pushed 2026-11-15T09:19:15Z, license MIT, no description — [API repo](https://api.github.com/repos/Sagor31h2/claude-mods)
- Commits (4): `e9409780be` "Initial commit" 09:13:13Z; `8974b0cd56` "Add my-mods marketplace with four mods" 09:18:30Z; `e882b5e67a` "Merge dev" 09:18:30Z; `90df9ee2d7` "Add README" 09:19:12Z. All on 2026-11-15 — [API commits](https://api.github.com/repos/Sagor31h2/claude-mods/commits?sha=dev)
- Contributors: `Sagor31h2` (4) only — [API contributors](https://api.github.com/repos/Sagor31h2/claude-mods/contributors)
- License: MIT, copyright 2026 Md. Kamrul Hassan Sagor — [LICENSE](R/LICENSE)
- Author profile: account created 2019-09-13, 35 public repos, 12 followers. Profile lists name "Md. Kamrul Hassan Sagor", company "Surbana Jurong Group", location Dhaka, Bangladesh — [API user](https://api.github.com/users/Sagor31h2)
- Web searches for "efficient-browser" with Sagor31h2, and for "Sagor31h2 claude-mods", found no mention of this repo. The results showed other "mods" marketplaces (0xDarkMatter/claude-mods, hamzafer/claude-code-mods, YeonwooSung/my-claude-code-mods, karanb192/awesome-claude-code-mods) — [claudemarketplaces hamzafer](https://claudemarketplaces.com/plugins/hamzafer-claude-code-mods), [0xDarkMatter/claude-mods](https://github.com/0xDarkMatter/claude-mods), [claudemarketplaces YeonwooSung](https://claudemarketplaces.com/plugins/yeonwoosung-my-claude-code-mods)
- **Other mods in the repo:** `input-router` ("Shrinks large Read and MCP results by asking Haiku for only the relevant verbatim lines. Keeps the original if the saving is under 30%."), `effort-optimizer` ("Picks low or high effort per prompt. Never above high."), `subagent-model-selector` ("Sends simple Agent tasks to haiku or sonnet when no model is named. Never touches forks.") — [README.md L19-L24](R/README.md#L19-L24)

### Inferences
- Trust rests on reading the 99-line source, which is small and auditable. There is no community vetting, track record or release discipline.
- Searches for "claude-mods" will mostly surface 0xDarkMatter's repo. Anyone installing should check the owner `Sagor31h2` and the SHA.
- `input-router` is the sibling with the most privacy weight (it sends Read/MCP content to Haiku), but installing `efficient-browser` alone does not enable it.

### Gaps
- mods.aidojo.si was not fetched. Whether it lists this mod is unverified (web search found no listing).
- No suspicious clones or forks were found (forks = 0), but no search was made for re-uploads under other names.

## Security and privacy risks

### Takeaway
The privacy surface is minimal. The mod never reads, logs or stores page content or tool results. It only rewrites screenshot request inputs and persists one boolean. It makes no network calls, model calls, process spawns or file writes outside its own store.

### Cited Findings
- The only persisted data is `enabled` (boolean) through `$.store.set` — [register.ts L77](R/mods/efficient-browser/hooks/register.ts#L77). That store is a JSON file under the user's Claude Code config directory — local typings `claude-code.d.ts` L4115-L4121
- The `tool.call` hook reads the input event and calls `next`. It never awaits or inspects the result of `next` — [register.ts L88-L98](R/mods/efficient-browser/hooks/register.ts#L88-L98)
- No imports besides the `claude-code` type import, so no `fetch`, `fs` or `child_process` — [register.ts L1](R/mods/efficient-browser/hooks/register.ts#L1)

### Inferences
- **Supply-chain risk:** a user-scope install follows the unpinned `dev` head. A later push could change the code with full hooks-module power (a `tool.call` hook on every call). This is the main real risk, not current behaviour.
- Smaller screenshots slightly reduce the screen content (which may include secrets or PII) sent to the model. That is a mild side benefit, not a security control.

### Gaps
- None material for the pinned SHA.

## Token and cost impact

### Takeaway
Each affected screenshot should cost about a quarter of the image tokens at the default 0.5, per the tool schema. Text tools (`get_page_text`, `read_page`, WebFetch) are unaffected. The mod adds no prompt or context tokens of its own.

### Cited Findings
- "0.5 returns an image at half the width and height (~quarter of the tokens)" — `mcp__claude-in-chrome__computer` and `mcp__Claude_Browser__computer` schema `scale` descriptions (this session, Desktop 2.1.330)
- The mod registers no `prompt.compose`/`prompt.submit`/system-prompt hook and adds no tool description — [register.ts](R/mods/efficient-browser/hooks/register.ts)
- The default `scale` is 0.5 and the minimum is 0.1 — [plugin.json L6-L11](R/mods/efficient-browser/.claude-plugin/plugin.json), [register.ts L54](R/mods/efficient-browser/hooks/register.ts#L54)

### Inferences
- Net savings depend on how often the agent screenshots without setting `scale`, minus any extra zoom or re-screenshot calls caused by lost legibility. Neither is measured.

### Gaps
- No empirical token measurements, from the author or elsewhere.

## Fit with the harness repo (E:\personal\base-harness-repo)

### Takeaway
The harness prescribes no text-first browsing or screenshot-scale policy, so the mod neither duplicates nor conflicts with harness rules. It also adds nothing to the session-start read budget. Installing it is a global-settings and dependency change under #009, though: a user-scope install edits `~/.claude/settings.json`, which already holds the Orca hooks and statusLine. That needs specific User authority. The mod writes no AGENTS.md, rules or repo hooks, so it passes the #094 installer precedent, though it is itself a runtime hook.

### Cited Findings
- **#009:** "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority" — `E:\personal\base-harness-repo\docs-harness\harness-constraints\0822-user-authority-operation-gate.md` (Constraint section)
- The project has no `.claude/settings.json`; `.claude/settings.local.json` holds only `skillOverrides` (four `utilizing-tools-*` skills off) — `E:\personal\base-harness-repo\.claude\settings.local.json`
- User-level `~/.claude/settings.json` (174 lines) has `hooks` entries calling `C:/Users/DEV/.orca/agent-hooks/orca-agent-hook.exe claude` and a `statusLine` (`bash ~/.claude/statusline-command.sh`). No `enabledPlugins` key was found by grep — `C:\Users\DEV\.claude\settings.json` L3-L50, L152-L155
- **#064 budget:** session-start reads total at most 33,400 normalized bytes — `docs-harness/harness-improvements/1115-session-start-context-cut.md` L27. The mod injects no text, so it has no effect on this budget.
- **Harness browser guidance (grep for browser/screenshot/get_page_text/read_page/Claude_Browser/claude-in-chrome/computer-use in docs-harness and .agents/.claude skills):** the only Claude routing line is `utilizing-tools-claude/SKILL.md` L59: "a sign-in or script-rendered page: the built-in browser (Claude in Chrome when the User asks for it)". `utilizing-tools-orca-ade/SKILL.md` L59 maps visual evidence to `orca screenshot --format png`, and that skill is turned off in `settings.local.json`. The other hits are historical improvement records mentioning headless-Edge screenshots. No text-first or scale rule was found — `E:\personal\base-harness-repo\.claude\skills\utilizing-tools-claude\SKILL.md`, `E:\personal\base-harness-repo\.agents\skills\utilizing-tools-orca-ade\SKILL.md`
- **#094 precedent** (third-party installers must not write AGENTS.md, rules or hooks): from the coordinator's brief. #094 is listed in `docs-harness/harness-improvements/README.md` L111 ("Add a code-graph skill and a Graphify catalog…")

### Inferences
- **Complementary, not overlapping:** the bundled Anthropic `built-in-browser` skill already covers "reading pages as text", per its description in this session's skill list. The mod only cheapens screenshots that still happen. It does not cover `orca screenshot` (a Bash command), the harness's Orca route.
- If the User wants the effect without a third-party dependency, a one-line harness rule ("pass `scale: 0.5` on routine screenshots; zoom for detail") would cost a few dozen bytes of always-read context. A small self-authored mod would avoid both the context cost and the supply-chain risk. Both are proposals, not decisions.
- **Risk and proposal (#001):** the unpinned `dev` branch and user-wide `tool.call` hook mean any future push runs on every tool call in every project. If adopted, the proposal is to fork or vendor the 99-line `register.ts` at SHA `90df9ee2` (or install from a pinned ref) rather than track `dev`, and to record the User's specific authority for the global settings change under #009.
- A project-scope install would create a new `.claude/settings.json` in the repo, a new checked-in file that would need User approval and routing consideration.

### Gaps
- The exact keys `claude plugin install --scope user` writes (for example `enabledPlugins` and `extraKnownMarketplaces`) were not verified against current Claude Code docs.
