# playwright-cli (microsoft/playwright-cli, npm `@playwright/cli`) as a browser tool for AI coding agents

Research date: 2026-11-23. Read-only web research; nothing was installed or run. Labels used below: **[Doc]** = official Microsoft/Playwright documentation or repo; **[Community]** = third-party claim or measurement; **[Inference]** = this researcher's reasoning.

## What it is, relation to Playwright / Playwright MCP, install, version, license, activity

### Takeaway
playwright-cli is Microsoft's official shell CLI (`playwright-cli`, npm `@playwright/cli`, Apache-2.0) that exposes the same browser automation as Playwright MCP as shell commands plus an installable agent skill, aimed at coding agents such as Claude Code. It is young (first npm publish 2026-01-26, still 0.1.x, latest 0.1.25 on 2026-11-18) but released roughly every 1-4 weeks and runs on alpha builds of Playwright.

### Cited Findings
- [Doc] Published as `@playwright/cli`; aimed mainly at coding agents such as Claude Code and GitHub Copilot. The README says that for coding agents the CLI is "the best fit" and positions MCP for "specialized agentic loops" that need persistent state and rich page introspection. — [README](https://github.com/microsoft/playwright-cli)
- [Doc] Install: `npm install -g @playwright/cli@latest`, then `playwright-cli --help`; local alternative `npx playwright cli` (needs Playwright 1.59+). Requires Node.js 20+. — [README](https://github.com/microsoft/playwright-cli); engines `node >=20`, bin `playwright-cli` — [npm registry](https://registry.npmjs.org/@playwright/cli)
- [Doc] Bundled skill: `playwright-cli install --skills` installs the skill into the project (Claude Code and Copilot pick it up); `install --skills -g` installs it globally (added in v0.1.18). Agents can also work without the skill by reading `playwright-cli --help`. — [README](https://github.com/microsoft/playwright-cli); [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] Skill lives at `skills/playwright-cli/SKILL.md` plus 10 reference files (element-attributes, playwright-tests, pr-attachments, request-mocking, running-code, session-management, storage-state, test-generation, tracing, video-recording). — [repo tree](https://api.github.com/repos/microsoft/playwright-cli/git/trees/main?recursive=1)
- [Doc] playwright.dev has a dedicated "Agent CLI" section (introduction, installation, quick-start, skills, snapshots, capabilities, vision-mode, per-command pages, sessions, configuration). It describes the CLI as using "a persistent daemon, ref-based accessibility snapshots", supporting Chrome, Firefox, WebKit, Edge, multiple isolated sessions; default headless (MCP default headed). — [playwright.dev/agent-cli/introduction](https://playwright.dev/agent-cli/introduction)
- [Doc] npm: latest `0.1.25` (2026-11-18); first publish `0.0.60` on 2026-01-26; a `next` tag exists (`0.1.18-alpha-...`). 0.1.25 depends on `playwright` and `playwright-core` `1.66.0-alpha-2026-11-18`. License Apache-2.0. — [npm registry](https://registry.npmjs.org/@playwright/cli)
- [Doc] Release cadence 2026: v0.1.11 (05-01), 0.1.12 (05-06), 0.1.13 (05-07), 0.1.14 (06-10), 0.1.15 (06-30), 0.1.16 and 0.1.17 (07-09), 0.1.18 (08-06), 0.1.19 (09-01), 0.1.20 (09-14), 0.1.21 (09-18), 0.1.22 (09-28), 0.1.23 (10-31), 0.1.24 (11-10), 0.1.25 (11-18). — [GitHub releases API](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] GitHub repo stats at 2026-11-23: 15,401 stars, 953 forks, `open_issues_count` 3 (this API field counts issues plus PRs), last push 2026-11-18, not archived, repo `created_at` 2020-06-19, description still "CLI for common Playwright actions. Record and generate Playwright code, inspect selectors and take screenshots." — [GitHub API](https://api.github.com/repos/microsoft/playwright-cli)
- [Doc] For comparison, microsoft/playwright-mcp shows about 40.0k stars and 72 documented tools (25 core and tab tools not gated behind `--caps`). — [playwright-mcp README](https://github.com/microsoft/playwright-mcp)
- [Community] Checkly reports that `playwright-cli` commands call the MCP tools internally, and that both use the same backend and snapshot files. — [Checkly, 2026-07-30](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)
- [Doc] The repo is maintained partly by agent workflows (`.github/workflows/agent-release.yml`, `agent-review.yml`, `agent-roll.yml`, `agent-task.yml`, `agent-triage.yml`) and has its own `.claude/skills/dev` skill. — [repo tree](https://api.github.com/repos/microsoft/playwright-cli/git/trees/main?recursive=1)

### Inferences
- [Inference] The 2020 repo creation date and the old description suggest Microsoft reused the name of the 2020 `playwright-cli` codegen repo. So some of the 15.4k stars may predate the agent CLI, and star count overstates its own adoption.
- [Inference] The very low open-issue count most likely reflects aggressive agent triage or issues being routed to the main Playwright repo, not a lack of bugs. Not verified.
- [Inference] It is still pre-1.0 and depends on Playwright alpha builds, so expect behavior changes between minor versions. Pin a version if the harness depends on exact output.

### Gaps
- Commit count and frequency (the `gh` CLI was unavailable and the commits API was not fetched). Release dates are used as the activity signal instead.
- Where issues are actually filed (this repo or microsoft/playwright) was not confirmed.
- Release dates before v0.1.11 (January to April 2026) were not listed.

## Command set and element addressing

### Takeaway
It covers the full Playwright MCP surface as subcommands: navigation, ref-based interaction, snapshots, `find`, screenshots/PDF, tabs, named sessions, persistent profiles, storage state, network routing and inspection, console, tracing, video, and attach to an existing browser by extension or CDP. Elements are addressed by snapshot refs (`e15`), or by CSS selectors and Playwright locators.

### Cited Findings
- [Doc] Command groups (README):
  - **Core:** `open`, `goto`, `close`, `type`, `click`, `dblclick`, `fill`, `drag`, `drop`, `hover`, `select`, `upload`, `check`, `uncheck`, `snapshot`, `find`, `eval`, `dialog-accept`, `dialog-dismiss`, `resize`
  - **Navigation:** `go-back`, `go-forward`, `reload`
  - **Keyboard and mouse:** `press`, `keydown`, `keyup`, `mousemove`, `mousedown`, `mouseup`, `mousewheel`
  - **Output:** `screenshot` (`--filename`, `--hires`), `pdf`
  - **Tabs:** `tab-list`, `tab-new` (`--isolated-context`), `tab-close`, `tab-select`
  - **Storage:** `state-save`, `state-load`, plus cookie, localStorage and sessionStorage list/get/set/delete/clear
  - **Emulation:** color scheme, reduced motion, forced colors, contrast, media type
  - **Network:** `route`, `route-list`, `unroute`, `requests`, `request <index>`
  - **DevTools:** `console`, `run-code`, `tracing-start`/`tracing-stop`, `recording-start`/`recording-stop`, `video-start`/`video-chapter`/`video-show-actions`/`video-stop`, `show`, `generate-locator`, `highlight`
  - **WebMCP:** `webmcp-list`, `webmcp-call`
  - **Attach:** `attach --extension=chrome`, `attach --cdp=chrome`, `attach --cdp=<url>`, `detach`, `detach --close-tabs`

  — [README](https://github.com/microsoft/playwright-cli)
- [Doc] Refs: "`e` followed by a number (e.g., `e1`, `e15`, `e203`)". They are unique within one snapshot, "stable within a single snapshot but invalidated when the page changes", and only interactive elements get them. — [playwright.dev snapshots](https://playwright.dev/agent-cli/snapshots)
- [Doc] Usage pattern: `click e15`, `fill e5 "user@example.com" --submit`. The skill says "By default, use refs from the snapshot to interact with page elements"; CSS selectors and `getByRole(...)` locators are alternatives. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
- [Doc] Sessions: select with `-s=name`, `--session name` or env `PLAYWRIGHT_CLI_SESSION`. Profiles are in memory by default; `--persistent` saves the profile to disk and `--profile=<path>` uses a given directory; `delete-data` removes a session's data. Session management: `list`, `close-all`, `kill-all`, `-s=name close`. A headless session shuts down after 1 hour idle; `--idle-timeout=<ms>` changes this and `0` disables it. — [README](https://github.com/microsoft/playwright-cli)
- [Doc] Headless by default; `open <url> --headed` shows the browser, and "Headed browsers stay open." — [README](https://github.com/microsoft/playwright-cli)
- [Doc] Attach modes: `attach <name>` (a bound Playwright browser, for example `npx playwright test --debug=cli`), `--cdp=<channel>` (running Chrome/Edge with remote debugging enabled at `chrome://inspect/#remote-debugging`), `--cdp=<url>` (for example port 9222, Electron, cloud browsers), `--endpoint=<ws url>` (Playwright server), and `--extension[=<channel>]` (existing tabs through the Playwright Extension from the Chrome Web Store). `detach` leaves the external browser running. — [playwright.dev attach](https://playwright.dev/agent-cli/commands/attach)
- [Doc] Extension attach: the session controls only tabs the user selects and tabs it opens, grouped under the session name (tab-group labels added in v0.1.25). Background mode was added in v0.1.24. Attach fails after 30 s with a hint on an extension token mismatch (v0.1.20). — [README](https://github.com/microsoft/playwright-cli); [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] Vision mode: coordinate commands (`mousemove x y`, `mousedown`, `mouseup`, `mousewheel`) together with `screenshot --filename=...`, for canvas, maps and custom widgets. `snapshot --boxes` gives bounding boxes and is called more reliable than reading coordinates off a screenshot. The snapshot approach is called "more reliable and token-efficient". — [playwright.dev vision-mode](https://playwright.dev/agent-cli/vision-mode)
- [Doc] `--json` returns a structured snapshot (v0.1.18); `open --mobile` emulates devices (v0.1.16). — [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)

### Inferences
- [Inference] Network inspection (`requests`), `console` and tracing are built in, so for debugging it is close to Playwright MCP with all `--caps` enabled, without paying for those tool schemas.

### Gaps
- The per-command docs pages (network-routing, console-eval, tracing) were not fetched individually. Exact flags beyond the README are unverified.

## Token-saving design and evidence vs Playwright MCP and screenshot tools

### Takeaway
By design, each command prints only page URL, title and a link to a YAML snapshot file under `.playwright-cli/`. The agent loads tree content only on purpose, with `snapshot` (scoped by `--depth` or a ref), `find`, or a file read, and there are no MCP tool schemas in context. Measurements conflict, though. Microsoft's widely quoted figure (about 114k MCP tokens vs 27k CLI) is untraceable to a primary source. Checkly (July 2026) measured near parity. Slack (June 2026) measured CLI using more tokens on a long flow because it took about twice as many turns. The saving is real per call but not guaranteed per task.

### Cited Findings
- [Doc] Per-command stdout: "Every command returns page info and a link to the snapshot file." Example:
  ```
  ### Page
  - Page URL: https://demo.playwright.dev/todomvc/#/
  - Page Title: React - TodoMVC
  ### Snapshot
  - [Snapshot](.playwright-cli/page-2026-02-14T19-22-42-679Z.yml)
  ```
  The file holds the accessibility tree with refs (for example `textbox "What needs to be done?" [ref=e5]`). — [playwright.dev snapshots](https://playwright.dev/agent-cli/snapshots)
- [Doc] Output-shrinking controls: `snapshot --depth=N` (the docs recommend a shallow snapshot first, then a partial one of the relevant subtree), `snapshot <ref|selector>` to scope to one subtree, `find <text>` / `find --regex` (matches with 3 lines of context; `--max-results` added in v0.1.23), and `--raw` (strips status and generated code, leaving the result). — [playwright.dev snapshots](https://playwright.dev/agent-cli/snapshots); [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] The skill steers toward text: `screenshot` is "rarely used, as snapshot is more common" and writes to a file (`--filename=page.png`). It also suggests mobile emulation because "mobile pages are usually lighter, so snapshots are smaller and cheaper." — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
- [Doc] README claims CLI invocations "avoid loading large tool schemas and verbose accessibility trees into the model context" and lists "Does not force page data into LLM". It also says MCP "remains relevant" where continuous browser context matters more than token cost. — [README](https://github.com/microsoft/playwright-cli)
- [Doc] playwright.dev lists token cost as "lower" for CLI and "higher" for MCP (tool schemas plus snapshots in context). This is a qualitative claim only, with no numbers. — [playwright.dev intro](https://playwright.dev/agent-cli/introduction)
- [Doc] Playwright MCP's own README also says "CLI invocations are more token-efficient". MCP's `--snapshot-mode` defaults to `full`, which returns the snapshot in the tool response; `none` and the `browser_snapshot` `filename` parameter (save to file "instead of returning it in the response") are opt-in. — [playwright-mcp README](https://github.com/microsoft/playwright-mcp)
- [Doc] Skill cost: SKILL.md is about 330 lines and about 1,700 words (roughly 2-3k tokens when loaded, by the ~1.3 tokens/word heuristic [Inference]). Frontmatter `allowed-tools: Bash(playwright-cli:*), Bash(npx playwright:*), Bash(npx --no-install playwright:*)`. Only the skill description (about 30-50 tokens per Checkly) sits in context until the skill is invoked. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md); [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)
- [Community] MCP schema cost: Playwright MCP's 48 tool schemas took 5.9k tokens upfront (2025 figure, older), and another estimate puts about 26 tools at about 3,600 tokens per session. Checkly notes Claude Code now loads MCP tool definitions on demand (tool search/deferred tools), which shrinks this gap. — [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/); estimate via [search summary of community articles, e.g. morphllm](https://morphllm.com/playwright-mcp)
- [Community, unverified origin] "About 114,000 tokens with MCP vs about 27,000 with CLI" (about 4x) for a "typical browser automation task" is attributed to the Playwright team or Microsoft in many articles, dating from early 2026. At least one writer could not trace it to a primary source. A later re-run (MCP 0.0.78 vs CLI 0.1.17, July 2026) reportedly found about 3,580 vs 3,620 tokens. Another (Leapwork) reports about 89k vs 24k on a different flow. — [Better Stack](https://betterstack.com/community/guides/ai/playwright-cli-vs-mcp-browser/); [dev.to (114k)](https://dev.to/leonting1010/playwright-mcp-burns-114k-tokens-for-one-workflow-heres-why-and-what-to-do-about-it-57k8); [Hive re-run](https://hive.blog/hive-178315/@excomunicado/using-playwright-cli-461772); [Leapwork](https://leapwork.com/?p=13152). These were reached through search summaries; only the attribution and figures were seen, not the methods.
- [Community] Checkly (Stefan Judis, 2026-07-30): two fresh Claude Code sessions, the same demo-shop task (search, open product, add to cart, verify total), 3 runs. MCP session ended at "48k to 50k tokens of context"; CLI "at 45k to 48k". Conclusion: roughly equal. Reasons: Claude Code now defers MCP tool definitions, and Playwright MCP writes snapshots to disk and returns resource links. The author works for a vendor that sells both a CLI and an MCP server. — [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)
- [Community] Slack Engineering (2026-06-11), 200+ runs of non-interactive `claude -p`, 20 runs per configuration per flow:
  - Failure rate (Thread Reply / Search Discovery): MCP 0% / ~12%; CLI ~12% / ~20%.
  - Turns: MCP ~40; CLI ~85.
  - Tokens (Search Discovery): MCP ~3.5M (Sonnet 4.5) and ~3.8M (Opus 4.6); CLI ~6M (Opus 4.6).
  - Runtime: MCP 5-8 min; CLI 9-11 min.
  - Explanations: CLI splits each interaction into separate action, wait, snapshot and read commands, while MCP returns state in the same round trip. CLI runs were also hard to parallelize.
  - Caveat: the token comparison is not cleanly model-matched.

  — [Slack Engineering](https://slack.engineering/agentic-testing-where-agents-fit-in-the-e2e-testing-stack/)
- [Community] GitHub Agentic Workflows (gh-aw, 2026-09-01) made its built-in Playwright tool CLI-only. Its reasons are qualitative and include no measurements: MCP schema cost "in tokens on every turn", a smaller attack surface (one npm package instead of a Docker MCP image), and direct localhost access. MCP stays available through explicit `mcp-servers` configuration. — [gh-aw blog](https://github.github.com/gh-aw/blog/2026-09-01-why-playwright-cli-replaces-playwright-mcp/)

### Inferences
- [Inference] Versus screenshot-based tools (Claude in Chrome / computer-use style), the saving is larger and less disputed. The CLI's default loop is text: a ~4-line stdout plus an optional scoped YAML read. Screenshots happen only when explicitly requested, are written to disk, and enter context only if the agent reads the PNG. No benchmark of CLI vs screenshot tools was found, though.
- [Inference] The CLI vs MCP token gap depends mostly on (a) whether the MCP client defers tool schemas (Claude Code now does), (b) whether the MCP snapshot is inlined (MCP default `full`) or file-based, and (c) turn count. The CLI wins per call but can lose per task if the agent issues many extra `snapshot`/read/wait turns, as in Slack's runs.
- [Inference] Each turn re-sends the whole conversation, so 85 cheap turns can cost more than 40 heavy ones. In the harness, the token benefit is realized only if agents batch work (scoped snapshots, `find`, `run-code` for multi-step sequences) rather than snapshotting after every action.

### Gaps
- No primary Microsoft source (blog, release note or video) for the 114k/27k figure was found. Treat it as unverified.
- The Hive and Leapwork numbers were seen only through search snippets, not read in full.
- No independent benchmark compares playwright-cli with screenshot-based browser tools.
- No measured per-session token count for the CLI skill was found; the ~2-3k estimate is derived from word count.

## Limitations, reliability, Windows, logged-in sessions, security

### Takeaway
It needs a shell tool and filesystem access. It works on Windows, with known quoting pitfalls and daemon fixes landing through late 2026. Login reuse works through `state-save`/`state-load`, persistent profiles, or attaching to the user's real Chrome through the Playwright Extension or CDP. Reliability on long flows was measurably worse than MCP in Slack's study. Security relies on the agent's shell permissions; the origin allow/block lists are explicitly not a security boundary.

### Cited Findings
- [Doc] The CLI depends on the agent knowing its commands (skill or `--help`) and on shell permission for `playwright-cli`. — [gh-aw blog](https://github.github.com/gh-aw/blog/2026-09-01-why-playwright-cli-replaces-playwright-mcp/). Per community sources, the CLI vs MCP choice "often comes down to" whether the agent can touch the filesystem. — [Better Stack](https://betterstack.com/community/guides/ai/playwright-cli-vs-mcp-browser/)
- [Doc] Windows:
  - `&` in URLs is a command separator in cmd.exe and PowerShell, so URLs get truncated. Use `^&` in cmd, or `playwright-cli --% goto "https://example.com/?a=1&b=2"` in PowerShell. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
  - Fixes in release notes: the daemon no longer opens a console window (v0.1.19); ffmpeg windows are hidden (v0.1.23); `kill-all` reports stopped daemons correctly on Windows (v0.1.24); escaping docs added (v0.1.14). — [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] Logged-in sessions:
  - `state-save`/`state-load` (for example `auth.json`), `--persistent` and `--profile=<path>` ("when requested explicitly"), and cookie and storage commands. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
  - Extension attach reuses the user's existing logins, cookies and extensions, which helps with SSO and 2FA. — [playwright.dev attach](https://playwright.dev/agent-cli/commands/attach)
- [Doc] Security:
  - Origin allow and block lists are not a security boundary.
  - File uploads are restricted to workspace roots by default (`PLAYWRIGHT_MCP_ALLOW_UNRESTRICTED_FILE_ACCESS` relaxes this).
  - WebMCP results "are untrusted input, not instructions".

  — [README](https://github.com/microsoft/playwright-cli)
- [Doc] Since v0.1.19, `install --skills` gitignores `.playwright-cli/`, because traces may hold credentials. `redactUrlParams` masks token-like URL params such as `access_token` (v0.1.23). Configured secrets are redacted from console logs (v0.1.15). Since v0.1.22 the bundled skill preapproves only Playwright commands. — [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] The skill notes "Package installation and custom `npm` scripts may require separate approval." — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
- [Community] Reliability: in Slack's runs, most CLI failures came from "authentication and navigation issues" (sign-in errors, timeouts, session instability), and MCP was more reliable, with the gap widening on complex flows. — [Slack Engineering](https://slack.engineering/agentic-testing-where-agents-fit-in-the-e2e-testing-stack/)

### Inferences
- [Inference] Prompt injection: snapshot YAML and page text are attacker-controllable content that the agent reads from disk. Writing to files does not sanitize it; it only delays reading. `eval` and `run-code` give the agent arbitrary JS in the page. Extension or CDP attach to the user's real Chrome exposes every logged-in account in the controlled tabs. Prefer isolated in-memory sessions by default and attach only on an explicit User request.
- [Inference] `.playwright-cli/` (snapshots, traces, videos, state files such as `auth.json`) can contain secrets. Gitignore it, and the same for any `state-save` output, in any repo where it is used.
- [Inference] Anti-bot: no documented stealth features were found. Headless Chromium launched by Playwright is likely detected like any Playwright browser. Attaching to the user's real Chrome is the documented way around login and 2FA friction, not around bot detection.

### Gaps
- No official anti-bot or CAPTCHA guidance was found.
- No Windows-specific known-issue list beyond release notes. Behavior under Git Bash (as opposed to PowerShell or cmd) is undocumented.
- MCP-side failure causes in the Slack study were not broken down.

## Using it from Claude Code on Windows, and what the harness must allow

### Takeaway
It is a third-party (Microsoft) global npm install plus a downloaded browser and a skill written into the project or user directory. The harness must grant dependency-install authority and shell permission for `Bash(playwright-cli:*)` (or the PowerShell equivalent). After that, the agent drives it with plain shell commands and reads `.playwright-cli/*.yml` files only when needed.

### Cited Findings
- [Doc] Setup commands: `npm install -g @playwright/cli@latest`; `playwright-cli --help`; `playwright-cli install --skills` (project) or `playwright-cli install --skills -g` (global). Alternatively `npx playwright cli` in a project with Playwright 1.59+. — [README](https://github.com/microsoft/playwright-cli); [releases](https://api.github.com/repos/microsoft/playwright-cli/releases?per_page=15)
- [Doc] Typical loop (commands as documented):
  ```
  playwright-cli open https://example.com            # headless; add --headed to watch
  playwright-cli snapshot --depth=4                  # shallow tree, refs like e15
  playwright-cli find "Sign in"                      # targeted search instead of full tree
  playwright-cli click e15
  playwright-cli fill e5 "user@example.com" --submit
  playwright-cli screenshot --filename=page.png      # only when visual check needed
  playwright-cli console ; playwright-cli requests   # debugging
  playwright-cli state-save auth.json                # reuse login later via state-load
  playwright-cli -s=myapp close                      # or close-all / kill-all
  ```
  In PowerShell, URLs containing `&` need `playwright-cli --% goto "https://host/?a=1&b=2"`. — [README](https://github.com/microsoft/playwright-cli); [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md); [playwright.dev snapshots](https://playwright.dev/agent-cli/snapshots)
- [Doc] The skill's `allowed-tools` preapproves `Bash(playwright-cli:*)`, `Bash(npx playwright:*)` and `Bash(npx --no-install playwright:*)`. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md)
- [Doc] Attach to the user's logged-in Chrome: install the Playwright Extension, then `playwright-cli attach --extension=chrome --session=<name>`; clean up with `detach --close-tabs`. — [SKILL.md](https://raw.githubusercontent.com/microsoft/playwright-cli/main/skills/playwright-cli/SKILL.md); [playwright.dev attach](https://playwright.dev/agent-cli/commands/attach)

### Inferences
- [Inference] Harness requirements, judged against this repo's task-authority policy:
  - The global npm install, the browser download, and `install --skills` (which writes a skill and a `.gitignore` entry) are dependency installation and global changes that need specific User authority.
  - Allowlisting `Bash(playwright-cli:*)` is a settings change.
  - Pinning `@playwright/cli@0.1.x` is advisable, because the package tracks Playwright alpha builds.
- [Inference] Claude Code's Bash tool on this machine is Git Bash, where `&` inside double quotes is safe. The PowerShell `--%` caveat matters only when the PowerShell tool is used.
- [Inference] Adoption guidance:
  - Strongest fit: short or medium agent tasks such as checking a page, reproducing a UI bug, or PR screenshots, where the CLI replaces screenshot-heavy browser tools or an always-loaded MCP server.
  - Weaker fit: long multi-step flows that need high reliability, where Slack found MCP faster, more reliable and cheaper.
  - Re-measure in this harness rather than trusting the 4x figure, because Claude Code's deferred MCP tool loading already removes much of MCP's schema overhead.

### Gaps
- Exactly how the global skill install (`-g`) places files for Claude Code on Windows (target path) was not documented in the sources read.
- Browser binary download behavior on first `open` (whether it auto-installs Chromium or uses installed Chrome by default) was not confirmed.
