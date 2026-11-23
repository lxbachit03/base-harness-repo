# savvy-progress (JohnnyVizz/claude-kit): a Claude Code mod

Researched 2026-11-23 from the repository's files on `main`, fetched through raw.githubusercontent.com and the GitHub REST API (gh was not installed, so unauthenticated curl was used). Snapshot copies are in `C:\Users\DEV\AppData\Local\Temp\claude\0ed3496d66f1fae8\0177b282-eb90-4624-92e8-d40ef616ad25\scratchpad\mods\savvy-progress\` (nothing was executed). Short forms used below: R = `https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress`, REG = `R/hooks/register.tsx`. Every file in the plugin folder was read: plugin.json, README.md, hooks/hooks.json, hooks/register.tsx (1,271 lines; the SVG drawing helpers at L330-L763 were skimmed and grepped for API calls), the four test files and types/index.d.ts.

## 1. What it does for the user

### Takeaway
It is a display-only mod. It adds a progress bar above the prompt for the author's `/savvy-flow` orchestration skill, and an "Agents" pane listing every subagent in the session with model, effort, step progress, context fill, estimated cost and elapsed time. It also adds two model-callable tools and one slash command.

### Cited Findings
- README summary: "a progress bar above the prompt and a live panel of subagents". It was made for savvy-flow and is "useful with any subagents". — [README](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/README.md)
- The bar shows the flow title, phase, accepted tasks out of planned, and a crew-size button that opens the pane. It appears only after something reports progress or a `savvy-*` worker starts. — [README](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/README.md); code: the AbovePrompt hook passes through (`return next(e)`) while `flow === null` — [REG L1205-L1207](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L1205-L1207)
- `/agents-info` toggles the pane and `/agents-info open` opens it or brings it forward. The pane lists running, finished and planned subagents. Animated pixel "crabs" in per-tier costumes are drawn, and `prefers-reduced-motion` stops the animation. — [README](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/README.md); [REG L847-L874](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L847-L874)
- Cost is "a rough estimate from token counts and a built-in per-model price table", list prices as of 2026-10-10, "not a bill". Cache writes are priced at the 1-hour rate. — [README](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/README.md); `PRICES` table, e.g. opus-5-5 at $4/$20 per million input/output — [REG L387-L436](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L387-L436)
- A `✕` button on the bar clears the flow, which hides the bar. — [REG L1222-L1230](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L1222-L1230)
- The pane opens by itself (once per flow title) when a `savvy-*` worker starts or a plan with tasks is reported. With `autoOpen: any` it also opens once per session for any other subagent. — [REG L786-L791, L951-L956](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L786-L791)
- The UI is available in English, Russian and Hebrew (right to left). — [REG L47-L170](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L47-L170)

### Inferences
- Without savvy-flow (or something else calling its `progress` tool, or agent types named `savvy-*`), the bar never appears. The user gets only the `/agents-info` pane with per-subagent cost and context, plus the always-loaded `step` tool (see section 2).

### Gaps
- I did not see it run (running it was out of scope), so the visuals are described from code and README only.

## 2. How the code works

### Takeaway
It is one TSX function-hooks module. It holds state only in session-scoped `$.state` atoms. It has no filesystem, process, network, `$.store` or model calls. It hooks agent spawn and turn usage to build the pane, and it changes model context in exactly two places. First, it registers a `step` tool with `isDeferred: false`, so that tool's schema sits in every agent's tool list. Second, it appends about 70 tokens of "Progress reporting" instructions to the prompt of every `savvy-*` subagent.

### Cited Findings
**Manifest and wiring**
- plugin.json: name `savvy-progress`, version `1.2.1`, author `johnnyvizz`, `types: ./types/index.d.ts`, license MIT, homepage and repository on GitHub. `userConfig` has two options: `language` (`auto`/`en`/`ru`/`he`, default `auto`) and `autoOpen` (`savvy`/`any`, default `savvy`). There are no dependencies, no `mcpServers`, no `agents` and no `skills`. — [plugin.json](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/.claude-plugin/plugin.json)
- hooks/hooks.json is `{ "modules": ["./register.tsx"] }`. It is a function-hooks (mod) module, not classic shell hooks. — [hooks.json](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/hooks.json)
- No classic settings hooks or shell scripts ship in the plugin. Its tree holds only `.claude-plugin/plugin.json`, `README.md`, `hooks/{hooks.json, register.tsx, 4 tests}` and `types/index.d.ts` (8 files, about 79.7 KB). — [git tree API](https://api.github.com/repos/JohnnyVizz/claude-kit/git/trees/main?recursive=1)
- The only imports are `atom, read, update` (and types) from `claude-code`, plus its own `../types`. There are no npm packages. — [REG L1-L4](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L1-L4)
- The state contract has `flow`, `agents` (capped at 200 runs), `panel` and `now`, all in `PluginState['savvy-progress']`. — [types/index.d.ts](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/types/index.d.ts); [REG L6-L13, L948](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L6-L13)

**Events hooked (all in `register`, [REG L793-L1271](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L793-L1271))**
- `session.start` (L794-L862): detects the language, registers the tools `progress` and `step` and the command `agents-info`, and starts a 1 s `$.clock.every` tick that writes `now` only while some agent is running.
- `command.run {command:'agents-info'}` (L864-L874): toggles or opens the pane.
- `tool.call {tool:'mcp__savvy-progress__progress'}` (L876-L889): ignores the call if `e.agentId` is set (a subagent), otherwise merges the input into `flow`. Its inputs are bounded: at most 200 tasks, 20 `after` entries and a 120-character title (L26-L30, L191-L217).
- `tool.call {tool:'mcp__savvy-progress__step'}` (L892-L907): accepts the call only from subagents and updates that agent's `stepDone`, `stepTotal` and `stepNote`.
- `tool.call {tool:'Agent'}` (L910-L923): for `subagent_type` starting with `savvy-`, it increments and decrements `flow.running` around `next(e)`.
- `agent.spawn` (L925-L958): **rewrites the spawn prompt** of `savvy-*` subagents that do not already mention the step tool by appending `STEP_BRIEF` (L20-L22). It then records an `AgentRun` (model, context window of 200K for haiku-4/claude-3, else 1M; L439) and may auto-open the pane.
- `turn.step` (L961-L996): reads each subagent model request's `usage` to compute context, tokens and cost.
- `turn.complete` (L998-L1028): marks a run done or failed, with a usage fallback.
- `ui.render {component:'Pane', requestId:'savvy-agents'}` (L1030-L1203): draws SVG rows on the `desktop` surface and Ink-style text rows elsewhere.
- `ui.render {component:'AbovePrompt'}` (L1205-L1270): draws the bar and stacks other mods' bands beneath it, but never nests the engine's own placeholder (L1208-L1211). It skips drawing when `hasSurvey` is set. SVG is used on non-terminal surfaces and text in the terminal.
- No hooks on `prompt.submit`, `prompt.compose`, `ToolUse`, `ContextMenu` or the system prompt. Grepping the file found none of these.

**$ APIs used** (grep of REG)
- `$.tool.register` ×2 (L797, L829), `$.command.register` (L847), `$.clock.every`/`$.clock.now` (L853-L1001), `$.ui.open`/`close`/`panes`/`resolve` (L775-L790, L1032, L1213), `$.settings.read` (L163, used only to read `language`), `$.env.get('LC_ALL'|'LC_MESSAGES'|'LANG')` (L168), and `$.state` through `atom`/`read`/`update`. — [REG](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx)
- A grep for `fetch(`, `http` (other than SVG xmlns strings), `eval`, `Function(`, `import(`, `require(`, `process.`, `$.fs`, `$.store`, `$.model`, `$.process`, `ui.toast` and `ui.status` found **no matches**. The only `url(` strings are SVG-internal `url(#c)`/`url(#g)` references (L337, L502). — [REG](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx)
- Model-supplied text placed in SVG (flow title, label, agent description, notes) goes through `xml()` escaping (L247-L248; uses at L334, L343, L680, L716-L718, L736-L737). — [REG](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L247-L248)

**Surfaces**
- Explicit branches exist for `desktop` (SVG pane), `terminal` (text bar) and "non-terminal with Svg" (SVG bar, which would include vscode). Every other surface gets the text pane. — [REG L1065, L1233](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L1065)
- Open issue #37 reports that the bar and pane are not drawn in cloud sessions (`remote_desktop`). Open PR #56 draws the pane as SVG on vscode. — [issues API](https://api.github.com/repos/JohnnyVizz/claude-kit/issues?state=all&per_page=100)

**Context injection and cost**
- `step` is registered with `isDeferred: false`, commented "In every agent's tool list, not behind ToolSearch" (L844-L845). Per the local Claude Code 2.1.330 plugin reference, `isDeferred: false` "puts the schema in the prompt's tool list from the start". `progress` is left deferred, so only its name is listed. — [REG L829-L846](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L829-L846); local `plugin-authoring/reference.md` L336-L344
- `STEP_BRIEF` (about 300 characters) is appended to each `savvy-*` worker's prompt and tells it to call `step` "before any other work" and again after each step. — [REG L17-L22, L926-L927](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L17-L22)
- Tool results returned to the model are short strings such as `ok: Tasks 1/3`, `ok` or `ignored: ...`. — [REG L879-L906](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L879-L906)
- No model calls are made by this plugin (no `$.model`), so the mod itself has no API cost. — grep of [REG](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx)

**Tests**
- There are four test files using `claude-code/testing`. They cover the band on terminal and desktop, rejection of a subagent hijacking the flow, the cost table and context windows, schema-violating input, and title capping. Run with `claude plugin test`; I did not run them. — [caller.test.ts](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/caller.test.ts), [register.test.ts](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.test.ts), [cost.test.ts](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/cost.test.ts), [band.test.tsx](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/band.test.tsx)

### Inferences
- Token estimate, my own count and not measured: the `step` description plus schema is about 600 characters, roughly 130-170 tokens. It is added to the tool list of every request in the main session and every subagent, whether savvy-flow is used or not. Prompt caching makes the repeat cost small. `STEP_BRIEF` adds about 70 tokens once per `savvy-*` worker. Each worker's obedient `step` calls (one up front and 3-8 more) add tool-call round trips and output tokens. That is likely the largest indirect cost, though it applies only to savvy workers.
- The prompt rewrite is limited to `savvy-*` subagents. User prompts and the system prompt are not touched.
- The mod writes no files. `$.state` is session-held and nothing is persisted with `$.store`. The only files written belong to the install itself (Claude Code's plugin cache and the settings `enabledPlugins` entry), or a user-made settings `env` or `pluginConfigs` edit for the by-hand install.
- The plugin serves its own tools by answering the `tool.call` hook. The 2.1.330 reference says a plugin serves a registered tool by hooking `tool.run` (reference.md L345-L351). This may reflect API drift from the version the author tested (2.1.286). Functionally the answer only writes in-memory display state.

### Gaps
- I did not verify whether answering at `tool.call` still works on the current Claude Code build, or whether it bypasses permission prompts for the two tools. Neither tool touches anything outside display state.
- The exact token counts were not measured with a tokenizer.

## 3. Install

### Takeaway
It installs as a marketplace plugin (`/plugin marketplace add johnnyvizz/claude-kit` then `/plugin install savvy-progress@claude-kit`) or by hand with `--plugin-dir` or `CLAUDE_CODE_PLUGIN_DIRS`. It relies on the early-access function-hooks API, which was tested only on Claude Code 2.1.286.

### Cited Findings
- `.claude-plugin/marketplace.json` names the marketplace `claude-kit`, owner `johnnyvizz`, with three plugins: savvy-flow 1.2.0 (skill), savvy-progress 1.2.1 (mod) and session-band 0.2.0 (mod). — [marketplace.json](https://github.com/JohnnyVizz/claude-kit/blob/main/.claude-plugin/marketplace.json)
- Install commands: `/plugin marketplace add johnnyvizz/claude-kit` and `/plugin install savvy-progress@claude-kit`, then restart the session. By hand: `claude --plugin-dir ~/claude-kit/plugins/savvy-progress`, or `"env": {"CLAUDE_CODE_PLUGIN_DIRS": ...}` in `~/.claude/settings.json`. — [repo README](https://github.com/JohnnyVizz/claude-kit/blob/main/README.md)
- "Mods are built on function hooks (`hooks/register.tsx`), an early-access Claude Code API: tested on Claude Code 2.1.286, and it may change between releases. If a mod installed from the marketplace does not show up, load it by hand." — [repo README](https://github.com/JohnnyVizz/claude-kit/blob/main/README.md)
- Options are set in `/config`, or as `pluginConfigs.savvy-progress.options` in `~/.claude/settings.json` for a by-hand load. — [plugin README](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/README.md)
- Closed issue #8 reported the terminal bar empty on 2.1.295, and closed PR #33 dropped `userConfig` options arrays "rejected by some Claud…" (title truncated by the API listing). Both point to sensitivity to the Claude Code version. — [issues API](https://api.github.com/repos/JohnnyVizz/claude-kit/issues?state=all&per_page=100)

### Inferences
- Claude Code's `/plugin install` generally offers user, project and local scopes. A project-scope install would write `enabledPlugins` into the repo's `.claude/settings.json`, which would be a change to a shared, checked-in file. This comes from general knowledge of Claude Code and was not re-verified against docs this session.

### Gaps
- Scope behaviour was not checked against current official docs. The repo README does not mention scopes.

## 4. Maturity and trust

### Takeaway
It is popular but young and maintained by one person: 430 stars and 109 forks in seven weeks. All development happened from 2026-10-04 to 2026-10-12, and there have been no commits for six weeks while about 25 PRs sit unmerged. There are no releases or tags. The license is MIT. I found no evidence of trojanized forks among those I grep-checked.

### Cited Findings
- The repo `JohnnyVizz/claude-kit` (not a fork) was created 2026-10-04 and last pushed 2026-10-12. It has 430 stars, 109 forks and `open_issues_count` 34 (issues plus PRs). The license is MIT (also stated in plugin.json). The description is "Public Claude Code skills and mods". — [repo API](https://api.github.com/repos/JohnnyVizz/claude-kit)
- There are 35 commits on main, 27 of which touch `plugins/savvy-progress`. The first was `3008472` on 2026-10-04 and the last was `af8902c` on 2026-10-12, a batch of PR merges. — [commits API](https://api.github.com/repos/JohnnyVizz/claude-kit/commits?path=plugins/savvy-progress&per_page=100)
- Ten contributors: JohnnyVizz (21 commits) and thammarongg (5); Herr-Enklo, willyab, Cvv9, Elalouf2024, Ademord, Br4inergy, prefect12 and rishabhsxn have 1-2 each. — [contributors API](https://api.github.com/repos/JohnnyVizz/claude-kit/contributors)
- No releases and no tags. — [releases API](https://api.github.com/repos/JohnnyVizz/claude-kit/releases), [tags API](https://api.github.com/repos/JohnnyVizz/claude-kit/tags)
- There are 59 issues and PRs in total. Open PRs since 2026-10-12 include #61, #60, #59, #56, #55, #54, #53, #52, #50, #48, #47, #45, #44, #43, #42, #40, #38, #36, #34, #31, #30, #29, #23, #17, #15, #14 and #3, none merged. Open bugs include #57 (named subagents stay "Running" forever), #37 (no drawing in cloud sessions) and #35 (namespaced savvy-flow agents never auto-open the pane). Issues #51 and #58 look like third-party catalogue or listing notices; I did not read their bodies. — [issues API](https://api.github.com/repos/JohnnyVizz/claude-kit/issues?state=all&per_page=100)
- The code shows a namespace mismatch. `tierOf` strips a `plugin:` prefix (REG L441-L446), but `agent.spawn` tests `e.subagentType.startsWith('savvy-')` (L926, L951). The marketplace-installed agents are named `savvy-flow:savvy-careful` ([repo README](https://github.com/JohnnyVizz/claude-kit/blob/main/README.md)), so the brief injection and auto-open would not fire for them. This matches issue #35 and open PR #50. — [REG L925-L956](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L925-L956)
- Author profile: GitHub user `JohnnyVizz` ("Johnny"), account created 2021-04-13, 5 public repos, 16 followers, no bio or company. — [user API](https://api.github.com/users/JohnnyVizz)
- Renamed forks were grep-checked for `fetch(`, URLs, `$.process`, `$.fs`, `$.store`, `$.model`, `eval(`, `atob(` and `Buffer.from` in `register.tsx`:
  - `niMgnoeSeeL/savvy-progress-px` (99 KB, also ships `tools/preview/render.py` and `run.sh`): no hits.
  - `Rexvirgo-cyber/claude-kit-savvy-mod` (46,825 B, an early snapshot; `tblack01/claude-kit-saavy-progress` has the same file sizes): no hits.
  - `LOUONE/crabcam` (109 KB) adds a `$.model.complete` "narrator" that sends agent tool and target lines to a model (crabcam register.tsx L815-L835), which carries model cost and data flow.
  — [GitHub API forks list](https://api.github.com/repos/JohnnyVizz/claude-kit/forks?per_page=100&sort=newest)
- A web search for "savvy-progress claude-kit" returned no relevant third-party discussion or reviews; the results were unrelated "claude-kit" projects. — [web search, e.g. pypi claude-code-kit](https://pypi.org/project/claude-code-kit/0.75.0/)

### Inferences
- The star and fork count relative to six weeks of age, plus a burst of drive-by PRs, suggests the repo was featured somewhere (perhaps a mods catalogue). Maintenance has stalled since 2026-10-12.
- Install only from `johnnyvizz/claude-kit`. Copies under other names exist (crabcam, claude-crew, savvy-claude, cc-plugin-claude-kit, savvy-progress-px, and others) and some add behaviour such as model calls.

### Gaps
- I did not audit all 109 forks or full fork diffs, only grep on 3-4 renamed forks.
- I found no independent security review.

## 5. Security and privacy risks

### Takeaway
The risk is low as code: it is local, display-only, and makes no I/O beyond reading settings and locale env vars. The real risks are supply-chain ones: an early-access API, a single inactive maintainer with an unpinned `main`, and look-alike forks. The mod also changes agent behaviour by injecting instructions into savvy worker prompts and permanently listing a tool.

### Cited Findings
- No network, process, filesystem, store or model calls (grep results in section 2). — [REG](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx)
- It reads the whole merged settings object through `$.settings.read()` but uses only `.language`, and it reads `LC_ALL`, `LC_MESSAGES` and `LANG`. — [REG L160-L170](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L160-L170)
- Prompt modification: it appends instructions to `savvy-*` subagent prompts. — [REG L926-L927](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L926-L927)
- Hardening against model-supplied input: subagent calls to `progress` are ignored (`e.agentId`), sizes are capped, tiers are whitelisted and SVG text is XML-escaped. — [REG L26-L30, L185-L199, L247-L248, L879](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L26-L30); [caller.test.ts](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/caller.test.ts)
- The pane shows subagent task descriptions and step notes on screen. That is a minor screen-sharing exposure only, with nothing persisted. — [REG L1099-L1145](https://github.com/JohnnyVizz/claude-kit/blob/main/plugins/savvy-progress/hooks/register.tsx#L1099-L1145)

### Inferences
- A marketplace install follows `main`, so a future push, by the author or by a compromised account, could add I/O, and the module runs with the full mod `$` API. Pinning a commit or vendoring a reviewed copy reduces this.
- The cost figures are estimates. They could mislead a user who reads them as billing.

### Gaps
- I did not check the plugin-install trust prompts or sandboxing on the current Claude Code build.

## 6. Fit with the harness repo (E:\personal\base-harness-repo)

### Takeaway
There is no conflict or duplication: the repo has no project `.claude/settings.json`, no statusLine and no settings hooks, and the mod writes no AGENTS.md, rules or hooks files. Its value to the harness is small, though. The bar lights up only with savvy-flow or `savvy-*` agents, which the harness does not use, so the only gain would be the `/agents-info` subagent cost and context pane. Installing it is a hook/plugin install that needs separate User authority under #009, and it adds an always-on tool schema to every request.

### Cited Findings
- The repo has no `.claude/settings.json`. `.claude/settings.local.json` holds only `skillOverrides` (four `utilizing-tools-*` skills turned off), so there is no `statusLine`, `hooks` or `enabledPlugins` in the project. — local files `E:\personal\base-harness-repo\.claude\` (directory listing and JSON keys checked 2026-11-23)
- `#009` task authority: "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority". Deployment, publishing and permission changes also need "explicit authority for that action and target". — `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` (Constraint section)
- `#094` code-graph pilot purpose: "Keep the Harness in charge of agent instructions: no third-party installer writes `AGENTS.md`, rules or hooks." It rejected Graphify partly because "its installer writes `AGENTS.md`/rules and hooks". — `docs-harness/harness-improvements/1123-code-graph-skill.md` L28-L29, L38-L41
- `#064`: "The files every session must read at start total at most 33,400 normalized bytes". — `docs-harness/harness-improvements/1115-session-start-context-cut.md` L27
- The harness already has its own Markdown "hooks" mechanism (`docs-harness/layers/layer-2/hooks/`, e.g. `jev-hook.md`), separate from Claude Code hooks. — `docs-harness/INDEX.md` (layers section) and directory listing

### Inferences
- **#094**: the mod ships a Claude Code function-hooks module but writes no `AGENTS.md`, rules or hook files into the repo. The marketplace install writes only Claude Code's plugin cache and a settings `enabledPlugins` entry, user-level unless project scope is chosen. It therefore satisfies the letter of #094 if installed at user or local scope. A project-scope install would add `enabledPlugins` to a checked-in `.claude/settings.json`, which is a repo change needing its own authority.
- **#064**: it adds no session-start file reads, so the 33,400-byte budget is unaffected. In the same context-cost spirit, though, the `isDeferred: false` `step` tool adds about 130-170 tokens to every request of the main session and of every subagent, including the harness's worker and swarm subagents, while giving the harness nothing unless a worker calls it.
- **Duplication or conflict**: nothing in the repo duplicates it. Its AbovePrompt band stacks other mods' bands beneath it, so it is unlikely to clash with another mod's band (session-band's own bug #46 is the reverse case). Agent type names in the harness are not `savvy-*`, so no prompt injection would happen to harness workers.
- **Help**: the `/agents-info` pane could give visibility into per-subagent cost, context and time when the harness delegates work, for example with the coding-subagent swarm (#1122 records). The README warns that these numbers are estimates.
- **Lower-risk alternative**: a vendored, reviewed copy loaded with `claude --plugin-dir` for one session. That avoids a persistent install and an unpinned `main`, but still needs User authority under #009.

### Gaps
- I did not test the mod in a harness session, so actual token overhead and pane behaviour with the harness's subagents are unmeasured.
- Harness worker agent type names were not inventoried. Whether any start with `savvy-` is assumed "no" from the repo's naming, not exhaustively checked.
