# Token economics of browser automation for LLM coding agents (state as of 2026-11-23)

Labels used on every number: **[official]** = vendor documentation; **[measured]** = someone ran it and reported a count; **[claimed]** = asserted without a method; **[estimated]** = computed here or by the source from a formula. Dates are given where the source shows them; anything before mid-2026 is marked *older*.

## 1. Image (screenshot) token cost for Claude

### Takeaway
Claude now bills images by 28x28-px patches: `ceil(w/28) x ceil(h/28)` tokens (about w*h/784, close to the older w*h/750 rule of thumb). Claude 4.7+ models accept up to 2,576 px long edge / 4,784 tokens per image; older models cap at 1,568 px / 1,568 tokens. Halving each side cuts cost to about one quarter, so the local measurement (800 px wide pane: about 640 tokens at scale 1, about 160 at scale 0.5) matches the formula.

### Cited Findings
- Formula: "Each patch is a 28x28-pixel block ... An image, therefore, costs `⌈width / 28⌉ × ⌈height / 28⌉` visual tokens." [official] — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Resolution tiers: High-resolution tier (Claude 4.7 and later) max long edge 2,576 px, max 4,784 visual tokens; Standard tier (all other models) 1,568 px, 1,568 tokens. Larger images are downscaled preserving aspect ratio. [official] — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Token table [official]: 200x200 = 64; 1000x1000 = 1,296; 1920x1080 = 1,560 (standard, downsized to 1456x819) vs 2,691 (high-res, not resized); 3840x2160 = 1,560 (standard) vs 4,784 (high-res, downsized to 2576x1449). "High-resolution images can use up to roughly three times more visual tokens"; the docs advise downsampling when the extra fidelity is not needed. — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Dollar example [official]: on Claude Opus 5.5 ($4/M input, high-res tier) a 1000x1000 image is about $5.18 per thousand images; a 4K image about $19.14 per thousand. — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Exception for agent tools [official]: screenshots and zoom images returned to the computer-use and browser-use toolsets are NOT downscaled by the API; an oversized `tool_result` image is rejected with a validation error, so the client must resize. — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision); [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Hard limits [official]: 8000x8000 px max per image; with more than 20 images in one request (including screenshots from earlier turns inside `tool_result`s) a stricter per-image limit applies, docs advise keeping each side at or below 3,000 px; up to 600 images per request (100 for 200k-context models). — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Images are billed by pixels, not by base64 size. Some blogs convert base64 KB to tokens (e.g. "~10–30k tokens per screenshot" from "~50–200 KB base64") [claimed] — [Dave Kurian, DEV](https://dev.to/davekurian/vercels-agent-browser-is-15x-cheaper-than-playwright-mcp-and-thats-not-the-most-interesting-part-3ian). Under the official formula no single Claude image can exceed 4,784 tokens, so these figures are wrong for Claude.
- Worked examples using the official formula [estimated, computed here]: 800x600 = 638 (matches the repo's measured ~640 at scale 1); 400x300 = 165 (matches ~160 at scale 0.5); 1280x800 viewport = 1,334; 640x400 = 345; 1280x720 = 1,196; 640x360 = 299.
- `zoom` semantics vary by host. The API browser toolset defines `zoom` as "Return a cropped, upscaled `image` of `region`" [official] — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool). The repo's local measurement found the Claude Desktop browser pane's `zoom` crops without magnifying (task brief; not re-verified here).

### Inferences
- Cost scales with area: scale 0.5 costs about 25% of scale 1, and scale 0.25 about 6%. Below about 200 px Claude's accuracy degrades (docs warn about images "under 200 pixels"), so 0.5 on an 800–1280 px viewport is a safe default and 0.25 is risky for text.
- A full-page screenshot of a long page (e.g. 1280x6000) exceeds the 2,576 px long edge. The API rejects it in a tool result, or a host downscales it to roughly 550 px wide at about the 4,784-token cap, where body text is illegible. Full-page screenshots are poor value. A viewport shot plus a cropped `zoom` on the area of interest is better.
- Screenshots persist in context. With N screenshots in history, each later turn re-sends them (prompt caching reduces price, not context use), and over 20 images the stricter per-image size limit applies.

### Gaps
- No Anthropic statement found on whether hosts such as Claude Code, Claude in Chrome or the Desktop pane pre-resize screenshots, or to what size, apart from the repo's own 800 px measurement.

## 2. Accessibility snapshot size vs screenshots; scoped/diff snapshots; tool-schema overhead

### Takeaway
A filtered (interactive-only or subtree) accessibility snapshot is usually smaller than one viewport screenshot and gives actionable refs. Unfiltered snapshots of large SPAs can reach 5k–15k+ tokens, which is more than a 0.5-scale screenshot. Fixed tool-schema overhead is real (about 4.5k–18k tokens per MCP server, about 6.6k for Anthropic's API browser toolset), but Claude Code now defers MCP tool definitions by default, which mostly removes it there.

### Cited Findings
- Anthropic guidance [official]: "a tree read of a typical page often costs fewer input tokens than a screenshot while giving Claude references it can act on immediately. Screenshots remain the right observation when visual layout, images, or rendering state matter." The same docs advise `read_page` with `filter: "interactive"` or a container `ref` for a focused subtree on large pages. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Anthropic browser toolset `read_page` contract [official]: `filter` (default visible elements; `"interactive"`; `"all"`), `depth` (default 15), `ref` (subtree); output capped at 50,000 characters, and Claude then narrows with a smaller depth or a ref. `find` returns at most 20 matches. `get_page_text` returns visible text, "prioritizing the main article content". — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Anthropic browser toolset definition overhead [official]: `browser_toolset_20260801` with 27 default members adds about 6,600 input tokens per request (about 6,670 on Sonnet 5); the four optional members add about 880. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Snapshot size on a typical SPA: "~5–15K tokens" for the accessibility tree and "~2–8K" for a screenshot [estimated by the source, no method]. — [Leon / taprun.dev on DEV, Apr 2026 (older)](https://dev.to/leonting1010/playwright-mcp-burns-114k-tokens-for-one-workflow-heres-why-and-what-to-do-about-it-57k8)
- agent-browser snapshot "200–400 tokens", filtered snapshot "~50 tokens", post-action diff "~100 tokens" vs "~30k" for two screenshots [claimed, no method]. — [Dave Kurian, DEV](https://dev.to/davekurian/vercels-agent-browser-is-15x-cheaper-than-playwright-mcp-and-thats-not-the-most-interesting-part-3ian)
- agent-browser snapshot flags [official]: `-i/--interactive` (recommended), `-u/--urls`, `-c/--compact`, `-d/--depth`, `-s/--selector` (scope to a CSS selector), e.g. `snapshot -i -c -d 5`. — [agent-browser snapshots docs](https://agent-browser.dev/snapshots). The README lists a `diff` command under Capture (no detail on that page) [official] — [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser)
- Playwright MCP [official]: about 25 default tools, with opt-in `--caps` groups (vision 6, devtools 13, testing 5, network 4, storage 17, pdf, config); `--snapshot-mode` `full` (default) or `none`; `browser_snapshot` accepts a `filename` to save to a file "instead of returning it in the response"; `--image-responses allow|omit|only`; `browser_find` is "cheaper than capturing the whole snapshot"; `--mobile` saves tokens. — [microsoft/playwright-mcp README](https://github.com/microsoft/playwright-mcp)
- Playwright MCP schema cost: 48 schemas, about 5.9k tokens (2025, *older*) [measured] — [Checkly, Jul 2026](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/). Other sources give "~13,000 tokens per request" [claimed] — [Kurian](https://dev.to/davekurian/vercels-agent-browser-is-15x-cheaper-than-playwright-mcp-and-thats-not-the-most-interesting-part-3ian) and "~1.3K per tool × ~28 tools ≈ 36K" [estimated, implausibly high] — [Leon](https://dev.to/leonting1010/playwright-mcp-burns-114k-tokens-for-one-workflow-heres-why-and-what-to-do-about-it-57k8). These conflict. The Checkly measurement is the only one with a stated method.
- Chrome DevTools MCP schema cost: about 4,475 tokens for 29 tools (tiktoken count of tools/list) [measured, third-party] vs about 18K (around v0.12, *older*) [claimed]; `--slim` (added v0.18.0, 2026-02-24) leaves 3 tools (navigate, evaluate, screenshot), about 368 tokens, and drops `take_snapshot`. — [policylayer token-cost page](https://policylayer.com/token-cost/io-github-chromedevtools-chrome-devtools-mcp); [ChatForest review](https://chatforest.com/reviews/chrome-devtools-mcp-server/); [changelog via Glama](https://glama.ai/mcp/servers/@ChromeDevTools/chrome-devtools-mcp/blob/505089c2884428ef7d040a36dd0b50ee30f0e623/CHANGELOG.md) (search-result summaries; tokenizer is tiktoken, not Claude's)
- GitHub MCP for comparison: about 17.8k tokens of tool definitions (2025, *older*) [measured]. — [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)
- Claude Code tool search [official]: "Tool search is enabled by default: MCP tools are deferred and discovered on demand"; "Only tool names and server instructions load at session start". `ENABLE_TOOL_SEARCH=auto` loads tools upfront only while their definitions total under 10% of the context window (`auto:N` sets a custom percentage); `alwaysLoad: true` forces a server upfront. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- Claude Code MCP output limits [official]: warning when one MCP tool output exceeds 10,000 tokens; default `MAX_MCP_OUTPUT_TOKENS` is 25,000; text results over 50,000 characters (no image) are saved to a file and replaced by a file reference; image results stay subject to the token limit. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- Chrome DevTools team on token design [official, qualitative]: send a summary plus task-specific data and fetch detail on demand through functions; a compact keyless line format; no before/after numbers. — [Chrome for Developers blog, Jan 2026](https://developer.chrome.com/blog/designing-devtools-efficient-token-usage)

### Inferences
- Rough per-observation costs (mixing sources above; treat as order-of-magnitude): interactive-only scoped snapshot about 50–1,000 tokens; full snapshot about 2k–15k+; viewport screenshot 300–1,350 (0.5–1.0 scale at 1280x800); `get_page_text` scales with content (a docs page often 1k–5k; no measured source found).
- With Claude Code's default deferral, the "MCP schema tax" mostly disappears (only tool names load). It still applies to clients without deferral, to `alwaysLoad` servers, to API users declaring toolsets (about 6.6k for Anthropic's browser toolset), and once tools are loaded.
- Large snapshot outputs already overflow to files in Claude Code above 50k characters, so the MCP-vs-CLI difference ("output in context vs on disk") narrows for very large snapshots but not for mid-size ones (10–50k chars), which still land in context.

### Gaps
- No independent, method-stated measurement of snapshot tokens per page type (e.g. Wikipedia vs Gmail vs a React dashboard) using Claude's tokenizer was found.
- No published size figures for Claude in Chrome's `read_page`/`get_page_text` outputs, or for its tool-definition overhead.

## 3. Published benchmarks: Playwright MCP vs playwright-cli vs agent-browser vs Claude in Chrome

### Takeaway
The widely repeated "4x" (114k vs 27k tokens) and "15x / 93% / 97%" claims are poorly sourced anecdotes from early 2026, before Playwright MCP wrote snapshots to files and before Claude Code deferred tool schemas. The best-documented later test (Checkly, July 2026, Claude Code, 3 runs) found MCP and CLI essentially equal (48–50k vs 45–48k tokens per task). No benchmark found reports task success rates head-to-head, and none includes Claude in Chrome.

### Cited Findings
- Playwright's official position [official, qualitative, no numbers]: CLI token cost "Lower — concise CLI output, skills loaded on demand"; MCP "Higher — tool schemas + snapshots in context". CLI for coding agents with large codebases; MCP for "specialized agentic loops, exploratory automation". The CLI writes snapshots to `.playwright-cli/page-<timestamp>.yml` and prints URL, title and the file link after each command. — [Playwright CLI docs](https://playwright.dev/agent-cli/introduction); [playwright-mcp README](https://github.com/microsoft/playwright-mcp)
- 114k vs 27k: widely attributed to "Microsoft's Playwright team" by secondary blogs, but one author traced 114k to an unnamed r/ClaudeAI post (a 7-step workflow; reconstructed as 7 × ~15k per step plus about 36k of schemas) [claimed/estimated] — [Leon, DEV](https://dev.to/leonting1010/playwright-mcp-burns-114k-tokens-for-one-workflow-heres-why-and-what-to-do-about-it-57k8). Another cites "Pramod Dutta's November 2025 analysis" for 114k per test and an "Özal benchmark" in a playwright-mcp issue for about 1.5M tokens on an e-commerce flow, vs CLI about 27k [claimed, secondary] — [Creatman, DEV, May 2026](https://dev.to/creatman/playwright-mcp-burns-15m-tokens-cli-does-it-in-27k-so-i-built-the-skill-that-splits-the-phases-50j7). No primary Microsoft benchmark page was found.
- Checkly re-test [measured, July 30 2026, Stefan Judis]: two fresh Claude Code sessions (Playwright MCP vs `playwright-cli` + skill), same 6-step shop task, 3 runs each. End-of-task context MCP 48k–50k vs CLI 45k–48k. Conclusion: "There's no big difference in using CLIs or MCPs these days", because Claude Code defers tool loading and Playwright MCP now writes snapshots to disk and returns a link, with the CLI calling the same backend. Caveats: one task, n=3, author's employer is in the Playwright tooling space. — [Checkly blog](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)
- A search summary mentions a DEV re-run on @playwright/mcp 0.0.78 vs @playwright/cli 0.1.17 giving about 3,580 vs 3,620 tokens per action, and a Leapwork-cited flow at about 89k (MCP) vs 24k (CLI). The pages fetched did not contain these figures, so they are **unverified**. — [search result: Leapwork](https://leapwork.com/?p=13152)
- GitHub Agentic Workflows switched the built-in Playwright tool to CLI-only (Sep 1 2026). The reasons given are schema cost, a smaller attack surface (no Docker container), and localhost reachability; the post reports no measurements. MCP remains opt-in (e.g. pin `@playwright/mcp@0.0.79`). — [gh-aw blog](https://github.github.com/gh-aw/blog/2026-09-01-why-playwright-cli-replaces-playwright-mcp/)
- agent-browser vs Playwright MCP "15x cheaper": 10-step task 100k+ vs about 7k tokens, single anecdotal run, no task named [claimed]. — [Dave Kurian, DEV](https://dev.to/davekurian/vercels-agent-browser-is-15x-cheaper-than-playwright-mcp-and-thats-not-the-most-interesting-part-3ian). Other figures ("up to 97%", "82.5%", "93%") come from blogs and community posts with no method [claimed] — [DEV/chen_zhang](https://dev.to/chen_zhang_bac430bc7f6b95/why-vercels-agent-browser-is-winning-the-token-efficiency-war-for-ai-browser-automation-4p87); [Skool post](https://www.skool.com/build-with-ai-9352/agent-browser-cuts-your-ai-agents-token-use-by-93). The official README makes no token claims, only "compact text" snapshots and "one short shell call" per step; the repo has a `benchmarks` folder whose results were not published on the README (53.5k stars at fetch time). — [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser)
- Anthropic offers an API-level browser toolset (`browser_toolset_20260801`, 27 members, about 6.6k definition tokens) with the same `read_page`/`find`/`get_page_text`/`zoom`/ref model as Claude in Chrome and the Desktop browser pane; it publishes no success-rate benchmark vs Playwright. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)

### Inferences
- Trust ranking: (1) vendor docs for mechanisms and fixed overheads; (2) Checkly (method stated, small n, current versions); (3) everything else is anecdote. The big multipliers mostly measured (a) eager schema loading and (b) inline snapshots/screenshots, both of which current Claude Code + Playwright MCP defaults have reduced.
- The remaining CLI advantage comes from behaviour, not architecture: the agent reads only the part of the snapshot file it needs (grep/head), and nothing large enters context by default. An MCP client gets the same effect by passing `filename`, using `--snapshot-mode none` + `browser_find`, or `--image-responses omit`.

### Gaps
- No published head-to-head success-rate or reliability benchmark (e.g. WebArena-style) across Playwright MCP, playwright-cli, agent-browser, Chrome DevTools MCP and Claude in Chrome.
- browser-use (Python agent library) token numbers were not researched in depth within the tool-call budget; no figures found.
- No measurement found for Claude in Chrome token use per action.

## 4. Best practices to cut tokens without losing effectiveness

### Takeaway
Observe with the cheapest representation that answers the question: page text or a targeted `find`, then an interactive or scoped snapshot, then a scaled viewport screenshot, then a cropped zoom. Batch actions and end a batch with a single observation. Keep large outputs in files. Fixed schema costs matter less than per-step observation habits.

### Cited Findings
- Read the tree before screenshotting; scope with `filter: "interactive"` or a container `ref`; use screenshots when layout or rendering state matters [official]. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- You need not screenshot after every call: Claude typically ends a batch with one observation (`screenshot`, `read_page`, or `get_page_text`), and an observation can be attached to the last result of a batch to save a round trip [official]. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Downsample when high-res fidelity is not needed; pre-resize or crop [official]. — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- Playwright MCP levers [official]: `browser_snapshot` with `filename` (to a file), `browser_find` (cheaper than a full snapshot), `--snapshot-mode none`, `--image-responses omit`, `--mobile`, only the `--caps` you need. — [playwright-mcp README](https://github.com/microsoft/playwright-mcp)
- agent-browser levers [official]: `snapshot -i -c -d N -s "<selector>"`; re-snapshot after interactions and always after navigation. — [agent-browser snapshots](https://agent-browser.dev/snapshots)
- Chrome DevTools MCP `--slim` for navigate, evaluate and screenshot-only work [third-party summary of official README]. — [ChatForest](https://chatforest.com/reviews/chrome-devtools-mcp-server/)
- Claude Code: keep tool search on (the default); avoid `alwaysLoad` for browser servers; tune `MAX_MCP_OUTPUT_TOKENS` down rather than up; outputs over 50k characters go to files automatically [official]. — [Claude Code MCP docs](https://code.claude.com/docs/en/mcp)
- Offload screenshots to a subagent that returns text descriptions; one author reports 6 PNGs read by a subagent with the parent's image count staying at zero [measured, single anecdote]. — [Creatman, DEV](https://dev.to/creatman/playwright-mcp-burns-15m-tokens-cli-does-it-in-27k-so-i-built-the-skill-that-splits-the-phases-50j7)
- Once a flow is understood, generate a Playwright test or script and run it without the LLM (zero tokens per re-run; the source claims about 200 ms per run) [claimed]. — [Leon, DEV](https://dev.to/leonting1010/playwright-mcp-burns-114k-tokens-for-one-workflow-heres-why-and-what-to-do-about-it-57k8)

### Inferences (candidate usage rules)
- Default observation order: `get_page_text` (reading content) / `find` (locating one control), then `read_page filter=interactive` or `ref`-scoped, then screenshot at scale 0.5 (about 160–350 tokens), then `zoom` on a region. Full-page screenshots: never by default.
- Click by ref, not by coordinate, whenever the tree exposes the element. Re-read after navigation or a DOM-changing action instead of reusing old refs.
- Use batch tools (Claude browser `browser_batch`, agent-browser `batch`) for predictable multi-step sequences, with one observation at the end.
- Use console and network reads to diagnose "nothing happened" instead of repeated screenshots (the docs list them for this purpose [official] — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)); truncate and redact them.
- Close finished tabs. Tab lists and context footers add text every turn (inferred from the toolset's tab-context footer; size not documented).
- For repeated flows (regression checks), convert to a script or test once; use the agent only for exploration and failures.

### Gaps
- No controlled study quantifying how much each practice saves on its own.

## 5. Effectiveness trade-offs: when screenshots are needed; ref reliability; dynamic pages

### Takeaway
Text or snapshot-first fails on canvas, video, remote-desktop surfaces, heavily virtualized lists, cross-origin iframes and anything about visual appearance. Refs are tied to a DOM snapshot and go stale on navigation or re-render, so dynamic pages need re-snapshots. Screenshots stay necessary for visual verification, and cheap 0.5-scale shots plus zoom keep that affordable.

### Cited Findings
- Fall back to screenshot + zoom + coordinate clicks for "Canvas-rendered interfaces, embedded video or remote-desktop surfaces, heavily virtualized lists, and elements inside cross-origin iframes" [official]. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Screenshots "remain the right observation when visual layout, images, or rendering state matter" [official]. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- agent-browser refs: surviving elements keep refs across snapshots; replacing an element or navigating invalidates them; a fallback matches by role+name if unique, else the action fails. Clicks fail if the target is hidden, disabled, off-viewport or covered [official]. — [agent-browser snapshots](https://agent-browser.dev/snapshots); [agent-browser README](https://github.com/vercel-labs/agent-browser)
- Resized screenshots require scaling coordinates back by the inverse factor, and Claude infers viewport size from screenshots, "so keep them one consistent size" [official]. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- Small or blurry images below about 200 px cause hallucination or mistakes [official]. — [Claude vision docs](https://platform.claude.com/docs/en/build-with-claude/vision)
- MCP keeps continuous browser context, which matters for "exploratory automation, self-healing tests, and long-running autonomous workflows" [official, Playwright's framing]; the CLI needs filesystem access, so chat-only clients (e.g. Claude Desktop chat) need MCP [secondary]. — [playwright-mcp README](https://github.com/microsoft/playwright-mcp); [search summary, Better Stack/others](https://betterstack.com/community/guides/ai/playwright-cli-vs-mcp-browser/)

### Inferences
- Mixing screenshot scales in one session can confuse coordinate inference. Pick one scale (e.g. 0.5) for coordinate work, and use `zoom` (viewport-coordinate region) for detail instead of a scale-1 shot.
- A snapshot-only agent can "pass" a task while the UI is visually broken (overlap, contrast, wrong image). Visual checks need at least one screenshot at the end of a UI change.
- On SPAs with frequent re-renders, ref-based clicks can fail after a stale snapshot. The cost of a re-snapshot (scoped: hundreds of tokens) is lower than a failed action plus recovery.

### Gaps
- No quantitative data found on ref staleness or failure rates, or on task success differences between snapshot-first and screenshot-first agents on current Claude models.
