# Claude in Chrome (Anthropic browser extension) as a browser tool for Claude Code

Research date: 2026-11-23. Sources were read on that date. Labels used below: **[doc]** official Anthropic documentation; **[community]** GitHub issues, blogs and third-party reports; **[observed]** seen directly in this research session, which ran in the Claude desktop app with the `claude-in-chrome` MCP server configured. Only tool schemas were loaded. No browser action was run. **[inference]** marks my own reasoning.

## How Claude Code connects to it, and the requirements (browser, plan, OS)

### Takeaway
Claude Code uses the extension through a built-in MCP server named `claude-in-chrome`. You turn it on with `claude --chrome`, the `/chrome` command, or the "Enabled by default" setting. Claude Code installs a native-messaging host the first time you enable it, and the docs also name a bridge service, `bridge.claudeusercontent.com`. You need a direct Anthropic paid plan and a `/login` sign-in, since API keys don't work. Browser support is contradictory: the Claude Code docs say Brave and other Chromium browsers are detected, but the extension's own listing, support article and GA post say "Google Chrome only".

### Cited Findings
- **[doc]** Claude Code works with the Claude in Chrome extension from the CLI or the VS Code extension. You start it with `claude --chrome`, or use `/chrome` to check status, manage permissions, reconnect, or pick a browser. `/chrome` can also turn on "Enabled by default", which the CLI and VS Code share. `claude --no-chrome` skips it for one session. — [Claude Code docs: Use Claude Code with Chrome](https://code.claude.com/docs/en/chrome)
- **[doc]** Prerequisites: extension version 1.0.36 or later, and a direct Anthropic plan (Pro, Max, Ultra, Team or Enterprise) signed in with `/login`. With an API key or a `claude setup-token` token, Claude Code keeps Chrome off even when you pass `--chrome`. It isn't available through Bedrock, Google Cloud or Microsoft Foundry. It's also off under Zero Data Retention, and off by default under HIPAA. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[doc]** On first enable, Claude Code installs a native messaging host config, `com.anthropic.claude_code_browser_extension.json`. On Windows it is a registry key under `HKCU\Software\Google\Chrome\NativeMessagingHosts\`, with matching Edge keys. Other Chromium browsers read it from their own directory, for example `HKCU\Software\BraveSoftware\Brave-Browser\NativeMessagingHosts\`. Chrome reads the file only at startup, so the first connection may need a Chrome restart. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[doc]** The error table says "Browser extension is not connected" and "No browsers are connected" can come from failing to reach `bridge.claudeusercontent.com`, or from the extension being signed in to a different claude.ai account or organization than Claude Code. Connection is account-based, and more than one browser can connect. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[observed]** This session exposes `list_connected_browsers`, which returns deviceId, name, OS, isLocal, onThisComputer and inUse. It also exposes `select_browser`, and `switch_browser`, which "Send[s] a connection request to every Chrome browser with the extension installed and wait[s] (up to 2 minutes) for the user to click 'Connect'". This matches account-level multi-browser routing.
- **[doc]** Current Claude Code docs: "Chrome integration works with Google Chrome and Microsoft Edge. Claude Code also detects the extension and sets up the connection in other Chromium-based browsers, including Brave, Arc, Vivaldi, and Opera." WSL is not supported. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[doc, conflicting]** Three other sources say the extension runs on Google Chrome only:
  - The support article says it is "not supported on other Chromium-based web browsers or mobile devices." — [Getting started with Claude in Chrome](https://support.claude.com/en/articles/12012173-getting-started-with-claude-in-chrome)
  - The GA post (Aug 26, 2026) says it "doesn't run on other Chromium browsers or on mobile yet." — [Claude in Chrome is generally available](https://claude.com/blog/claude-in-chrome-generally-available)
  - The Web Store listing says the same. — [Chrome Web Store listing](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)
- **[community, older]** Issue #14616 (Dec 2025, Claude Code v2.0.73, extension v1.0.36):
  - `/chrome` showed "Extension: Not detected" in Brave on macOS, and the same problem was reported on Windows 11 in Jan 2026.
  - The extension's own side panel worked in Brave.
  - Copying the manifest into Brave's directory did not fix it.
  - The author closed the issue on Apr 29, 2026 because the docs then said Brave was unsupported. It was closed for documentation, with no code fix.
  - A third-party script, `stolot0mt0m/claude-chromium-native-messaging`, was posted as a workaround and is unverified.

  — [GitHub #14616](https://github.com/anthropics/claude-code/issues/14616)
- **[community]** Search snippets point to more Brave issues. Brave was not selectable in the browser picker during reconnect (#63840). On Linux, the native host was not installed for Chromium or Brave (#14391). I could not open the mirror site (DNS failure), so these are unverified. — [claudeissues.com #63840 (search snippet)](https://claudeissues.com/issue/63840-bug-brave-not-selectable-in-chrome-browser-picker-reconnect-opens-authorizes-bra)
- **[community]** Trail of Bits says the Claude desktop app's Cowork feature registers a competing native host with a different socket format. It recommends disabling the config you don't use. — [Trail of Bits skill: claude-in-chrome troubleshooting (search snippet)](https://trailofbits.com/skills/claude-in-chrome-troubleshooting/)
- **[doc]** Known operational issues:
  - The extension's service worker goes idle in long sessions ("Receiving end does not exist"). The fix is "Reconnect extension", which restarts the connection only from v2.1.290.
  - On Windows, named-pipe conflicts (EADDRINUSE) occur when another Claude Code session uses Chrome.
  - JS `alert`/`confirm`/`prompt` dialogs block all events until you dismiss them by hand.
  - A project's `.claude/settings.json` can't turn Chrome on, because `CLAUDE_CODE_ENABLE_CFC` set there is ignored.

  — [Claude Code docs](https://code.claude.com/docs/en/chrome)

### Inferences
- Since about mid-2026, Claude Code itself tries to connect to Brave. Whether it works now depends on two things: (a) whether the extension can be installed in Brave at all, given the "Switch to Chrome to install" banner, and (b) whether the extension runs there, which Anthropic's product pages deny. On the User's Brave setup, expect it to be unsupported and possibly flaky. Google Chrome or Edge is the documented, safe path.
- The connection is tied to an account through a cloud bridge plus native messaging. It is not a purely local CDP socket. Commands and page content therefore pass through Anthropic infrastructure, which is relevant to privacy.

### Gaps
- I could not verify whether Brave's Web Store page still lets you "Add to Brave" for this extension, or whether the current extension (v1.0.109) refuses to run in non-Chrome browsers.
- I found no first-hand report from late 2026 of Claude Code with Brave working or failing.

## What tools it exposes to Claude Code and what each returns

### Takeaway
The MCP server exposes about 20 tools. They cover a pixel-and-keyboard `computer` tool, accessibility-tree reading with `ref_N` handles (`read_page`, `find`), text extraction (`get_page_text`), `form_input`, `javascript_tool`, console and network readers, tab management, uploads, GIF recording, multi-browser selection, and a `browser_batch` meta-tool for several steps in one round trip. Screenshots come back as images. They default to "full image token budget", and the `scale` parameter (0.1–1) shrinks them.

### Cited Findings
- **[observed]** The deferred tool list in this session contains these 20 tools:
  - `browser_batch`, `computer`, `file_upload`, `find`, `form_input`, `get_page_text`, `gif_creator`, `javascript_tool`
  - `list_connected_browsers`, `navigate`, `read_console_messages`, `read_network_requests`, `read_page`, `resize_window`
  - `select_browser`, `switch_browser`, `tabs_close_mcp`, `tabs_context_mcp`, `tabs_create_mcp`, `upload_image`

  Every name has the prefix `mcp__claude-in-chrome__`.
- **[observed]** The `computer` schema:
  - Actions: left/right/double/triple click, type, screenshot, wait (max 10 s), scroll, key (repeat 1–100), left_click_drag, `zoom` (region screenshot), `scroll_to` (by ref), and hover.
  - Clicks take a coordinate or a `ref` from read_page or find.
  - `scale` is described as "Scale factor in [0.1, 1] for the returned image; 1 (default) uses the full image token budget, 0.5 returns an image at half the width and height (~quarter of the tokens)". It "Requires a Claude in Chrome extension version that supports scale; older extensions return the full-size image." Coordinates always stay in the full-resolution frame.
  - `save_to_disk` writes the image to a file.
- **[observed]** `read_page` returns an "accessibility tree representation", which "By default returns all elements including non-visible ones". Output is capped at 50,000 characters by default and truncated at a line boundary with a note giving the full size. Options are `filter: "interactive"` (buttons, links and inputs only), `depth` (default 15), `ref_id` for a subtree, and `max_chars`.
- **[observed]** `find`: a natural-language element search that "Returns up to 20 matching elements with references". `get_page_text`: "Extract raw text content from the page, prioritizing article content … plain text". `javascript_tool` runs JS in the page with REPL semantics and returns the last expression.
- **[observed]** `browser_batch` executes "a sequence of browser tool calls in ONE round trip … SEQUENTIALLY … and stop on the first error". It also says "Each tool's own permission check runs per item" and that screenshots are returned interleaved with the other outputs. Batches cannot nest.
- **[observed]** The server instructions tell the model to load the tools with one ToolSearch call, starting from this core set: `tabs_context_mcp`, `navigate`, `computer`, `read_page`, `tabs_create_mcp`, `tabs_close_mcp`.
- **[doc]** The public API "browser use tool" (`browser_toolset_20260801`) has the same design: `read_page` returns the tree with `[ref_2]`-style tags, a `filter` of interactive or all, `depth` (default 15), a `ref` scope, and a 50,000-character cap. `zoom` returns "a cropped, upscaled image of region". This is likely the same tool family, but the API page does not name Claude in Chrome. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- **[doc]** `file_upload` limits:
  - Uploads are capped at 10 MB total.
  - Files blocked by Read-deny permission rules can't be uploaded.
  - Hard-linked files are refused.
  - Credential-like names (`.env`, `.pem`, `.key`, `.ssh/`) are refused from v2.1.293.
  - Claude Code reads the file and sends its contents to the browser, so uploads work in remote sessions too.

  GIF recordings capture everything visible, logged-in account details included. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[community]** One developer claims the extension's `read_page` uses a DOM walker. This is unverified. — search snippet via [DEV: Giving AI agents eyes](https://dev.to/gauravchodwadia/giving-ai-agents-eyes-part-1-6-tricks-for-reading-web-pages-without-vision-models-4193)

### Inferences
- The token-cheap path is `find` or `read_page(filter:"interactive")`, then act by `ref`, then verify with `get_page_text` or a scoped `read_page`. Use screenshots only when layout matters, and then with `scale` around 0.5 and `zoom` for detail. All of this can be grouped in `browser_batch`.

### Gaps
- I found no official public reference page listing Claude in Chrome's tool set. The list above comes from this session's MCP schemas, so the version may differ from what the User gets.
- I could not determine the exact output format of `read_page` (YAML-like indented text or something else) without running it, and the task was read-only.

## Token and context cost per browser action

### Takeaway
Fixed cost:
- About 3.5–6k tokens of tool schemas, but only once they're loaded. Claude Code now defers them behind ToolSearch, while "Enabled by default" sessions keep the instructions loaded.
- A late-2025 community estimate put the full set at about 15.4k tokens.

Variable cost:
- A screenshot at default size costs roughly 1–1.6k image tokens. At `scale:0.5` it costs about 300–400.
- `read_page` with no filter can reach the 50k-character cap, about 12k tokens. Interactive-only or ref-scoped reads cost much less.

The dominant real-world cost is accumulation. Every screenshot stays in the transcript and is re-sent on every later turn and on resume.

### Cited Findings
- **[doc]** "Enabling Chrome by default increases context usage since the browser tools and their instructions are always loaded. If you notice increased context consumption, turn the setting off and connect only when needed". — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[observed]** In this session (Claude desktop app, Nov 2026), all 20 `claude-in-chrome` tools were deferred: only their names were in context until ToolSearch loaded them. The server instructions say to batch them into one ToolSearch call because "each separate ToolSearch call wastes a full round-trip".
- **[community, Dec 2025]** A Claude-generated comparison report lists Claude in Chrome at "~15.4k tokens (7.7%)" of a 200k context, against Playwright MCP at ~13.7k (6.8%) and Chrome DevTools MCP at ~19.0k (9.5%). The same report gives the tool count as 16 in one place and 17 in another, so the figures are unreliable. — [claude-code-best-practice report (jsDelivr copy)](https://cdn.jsdelivr.net/npm/drupal-claude-collective@2.4.0/claude-code-best-practice/reports/claude-in-chrome-v-chrome-devtools-mcp.md)
- **[doc]** The comparable API browser toolset's definition overhead is "about 6,600 input tokens", covering member definitions plus the system prompt. Optional members add about 880. Its cost is listed as screenshots "billed as image input" plus text results "such as accessibility trees, page text, and console or network entries". — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- **[doc]** API guidance: "a tree read of a typical page often costs fewer input tokens than a screenshot while giving Claude references it can act on immediately". It recommends `filter: "interactive"` or a container `ref` on large pages. The API "doesn't downscale toolset images", and images over the size limits are rejected, with a stricter per-image limit once a request holds more than 20 images. — [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- **[observed]** The `scale` parameter text: 0.5 returns "half the width and height (~quarter of the tokens)". `zoom` returns only a region.
- **[community]** Issue #27869 (Feb 2026, Claude Code 2.1.50, Opus, Max plan):
  - Screenshots are "base64-encoded JPEG" image blocks, duplicated in `toolUseResult` in the JSONL.
  - 18 screenshots averaged about 97 KB each (range 42–297 KB) and made up 64% of a 2.7 MB session.
  - Resuming the session cost an estimated ~279K tokens per call, against ~20K fresh. Five trivial turns used 17% of a 5-hour Max quota.
  - The bot closed it "not planned" in May 2026. There was no maintainer reply.
  - Community workarounds: a SessionEnd hook that strips old images, and the `cozempic` image-strip tool.

  — [GitHub #27869](https://github.com/anthropics/claude-code/issues/27869)
- **[community, unverified snippets]** Two more reports. #77360: browser automation in sessions near 1M tokens silently burns extreme volume because the full context is re-read on every click or screenshot. #65927: one Claude in Chrome prompt used about 61% of the session limit; the reporter guessed full-DOM injection, which is unconfirmed. — [claudeissues #77360](https://claudeissues.com/issue/77360-browser-automation-in-near-1m-token-sessions-silently-burns-extreme-token-volume), [claudeissues #65927](https://claudeissues.com/issue/65927-bug-claude-in-chrome-single-prompt-consuming-61-of-session-usage-limit)
- **[community, unverified snippet]** #45695: on HiDPI or Retina displays, screenshots exceeded the 2000 px multi-image limit, which suggests that at the time captures were taken at device-pixel resolution without automatic downscaling. — [claudeissues #45695 (search snippet)](https://claudeissues.com/issue/45695-chrome-extension-screenshots-exceed-2000px-limit-on-hidpi-displays)
- **[community]** TechStackups (Jan 2026, updated May 2026) compared Claude in Chrome with dev-browser, a Playwright skill, using token counts shown in the Claude Code UI:

  | Task | Claude in Chrome | dev-browser |
  |---|---|---|
  | Auth flow | 13k tokens, 15 min | 8k tokens |
  | Docs task | ~45k tokens, 20 min | ~22k tokens, 12 min |
  | CSS injection | 4.6k tokens | 6.3k tokens |

  Other findings:
  - Each tool call took about 200 ms, but there were 3–20 s of model thinking between steps.
  - The break-even point against the Playwright skill was about 15–20 actions.
  - dev-browser used 33% fewer tokens on average.

  — [TechStackups comparison](https://techstackups.com/comparisons/we-tried-different-ways-to-give-claude-code-access-to-a-web-browser/)
- **[community]** Search snippets claim Playwright MCP snapshots can exceed 50k tokens on complex pages, and that Claude in Chrome costs "10,000+" tokens per page. The sources conflict and their methods are unclear. — [DEV: I tested all 3 browser tools](https://dev.to/ayyazzafar/i-tested-all-3-browser-tools-for-claude-code-heres-the-best-one-1cn5) (snippet only)

### Inferences
- **Schema size.** I estimated it by eye from the schemas loaded in this session; I didn't measure it. `computer` is the largest, at about 5.5k characters. Ten tools came to about 14k characters, roughly 3.5k tokens. All 20 probably come to about 5–7k tokens. That is in line with the API toolset's ~6.6k, and it applies only after ToolSearch loads them.
- **Screenshot tokens** use Anthropic's ≈ w×h/750 rule:
  - A 1280×800 viewport is about 1,365 tokens.
  - A 1920×1080 capture would be about 2,765 tokens, but the API's roughly 1.15 MP / 1568 px long-edge budget caps it at about 1.5–1.6k tokens.
  - At `scale:0.5`, 640×400 is about 340 tokens.
  - `zoom` on a 400×300 region is about 160 tokens.

  These are estimates; the extension's actual default capture size isn't documented.
- **`read_page` size.** The default is "all elements including non-visible", capped at 50k characters (about 12.5k tokens at ~4 characters per token). On real app pages it can hit that cap. `filter:"interactive"` typically cuts this by about 5–20×. That ratio is my inference; I have no measurement.
- **Accumulation matters more than per-action size.** Each screenshot stays in history, so 20 full screenshots add about 20–30k tokens to every later request until compaction. Scaled screenshots, text-first observation, and short dedicated browser sessions (or subagents) are the main levers.
- **Batching.** `browser_batch` cuts round trips, so it avoids repeated model thinking time and repeated re-sending of context. It doesn't shrink the outputs themselves.

### Gaps
- I found no official per-action token figures for Claude in Chrome.
- I found no measured `read_page` or `get_page_text` sizes on named real pages.
- I found no official confirmation of the default screenshot resolution, or of whether the current extension downscales HiDPI captures.
- The ~15.4k schema figure is from a single, internally inconsistent, model-generated report.

## Strengths and weaknesses (sessions, latency, reliability, permissions, security, data)

### Takeaway
Its main strength is that it acts in the User's real, visible, logged-in Chrome, with console and network reading and no automation fingerprinting. Its weaknesses:
- Slower step-by-step loops, and screenshots that are expensive and pile up.
- Service-worker disconnects, and dialogs that block it.
- Per-site permission prompts.
- Real prompt-injection exposure in logged-in sessions, and page content flowing through Anthropic's cloud bridge.

### Cited Findings
- **[doc]** Claude "shares your browser's login state, so it can access any site you're already signed into". Actions run in a visible window. On a login page or CAPTCHA it pauses for the user. Tabs are kept in a session tab group, which `/clear` closes. — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[doc]** Permissions:
  - Approve per site ("Claude in Chrome wants to …", with an option to allow all actions on that site for the session).
  - In auto mode, a classifier-approved call can skip the extension's own per-site check.
  - In plan mode, GIF recording, opening tabs, `tabs_context_mcp(createIfEmpty)` and any batch containing those actions prompt.
  - Organizations can block the server with `deniedMcpServers`.

  — [Claude Code docs](https://code.claude.com/docs/en/chrome)
- **[doc]** The extension side panel starts in "Automatically approve" mode, with a safety classifier that blocks actions not matching the request. Team and Enterprise admins can set allow and block lists. — [Support: Getting started](https://support.claude.com/en/articles/12012173-getting-started-with-claude-in-chrome); [GA post](https://claude.com/blog/claude-in-chrome-generally-available)
- **[doc]** Prompt injection, from the GA post (Aug 2026):
  - Under the stronger red-team evaluation, attacks that reached the model succeeded "against Opus 4.5 17.6% of the time and against Opus 5 3.8%" before safeguards.
  - With probes and the classifier, "no attacks succeeded against Claude Sonnet 5, Claude Opus 5, or Claude Mythos 5".
  - Fable 5 had a 0.3% attack success rate.
  - The earlier Nov 2025 evaluation reported 1.4% for Opus 4.5 with improved safeguards, against a weaker attacker. Anthropic noted that 1% "still represents meaningful risk".

  — [GA post](https://claude.com/blog/claude-in-chrome-generally-available); [Anthropic: prompt injection defenses](https://www.anthropic.com/research/prompt-injection-defenses) (via search summary)
- **[doc]** Data: the Web Store disclosure lists PII, personal communications, location, web history, user activity and website content as handled data. It's unavailable under ZDR, and the HIPAA BAA doesn't cover data sent to third-party sites. Console and network entries can contain secrets (API docs advise redaction). — [Web Store listing](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn); [Claude Code docs](https://code.claude.com/docs/en/chrome); [Browser use tool docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-tool)
- **[community]** A privacy blog alleges Anthropic "silently installed a spyware bridge" (the native host). This is an opinion piece; I didn't read it in full. — [thatprivacyguy.com (search result title only)](https://thatprivacyguy.com/blog/anthropic-spyware)
- **[community]** Latency: about 200 ms per tool call plus 3–20 s of model thinking per step. It was slower than a Playwright skill on workflows of more than about 15–20 actions. — [TechStackups](https://techstackups.com/comparisons/we-tried-different-ways-to-give-claude-code-access-to-a-web-browser/)

### Inferences
- Use it where its strengths are unique: authenticated SaaS, the User's own sessions, and debugging a real browser profile. For token-cheap, repeatable automation of local or test apps, a headless Playwright CLI or skill is likely cheaper and faster, per the TechStackups data.
- Because it drives the User's real logged-in profile, a successful prompt injection has a larger blast radius than in a throwaway Playwright profile.

### Gaps
- I found no reliability or success-rate numbers for Claude Code with Claude in Chrome on standard benchmarks.
- I found no official statement on whether page content and screenshots are retained by the bridge beyond normal model-request handling.

## Release status, docs and known issues (as of November 2026)

### Takeaway
Claude in Chrome has been generally available on all paid plans since August 26, 2026. It was a beta in late 2025. The Web Store shows version 1.0.109, updated 2026-11-23, with about 24M users and a 3.6 rating from about 2K reviews. Claude Code's Chrome docs are current, with features gated by version up to v2.1.293. Most token-drain issues were closed by the stale bot rather than fixed.

### Cited Findings
- **[doc]** GA on Aug 26, 2026 "on every paid Claude plan". It adds autonomous action with auto-approval, plus a classifier. — [GA post](https://claude.com/blog/claude-in-chrome-generally-available)
- **[community, older]** In Dec 2025 it was described as "Beta, rolling out to all paid plans". — [claude-code-best-practice report](https://cdn.jsdelivr.net/npm/drupal-claude-collective@2.4.0/claude-code-best-practice/reports/claude-in-chrome-v-chrome-devtools-mcp.md)
- **[doc]** Web Store: v1.0.109, updated Nov 23 2026, 7.22 MiB, 24,000,000 users, 3.6/5 from about 2K ratings, publisher Anthropic (claude.com). — [Chrome Web Store](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)
- **[doc]** Version notes in the Claude Code docs:
  - v2.1.211: Windows setup page fix.
  - v2.1.287: VS Code sessions auto-connect.
  - v2.1.290: Reconnect really restarts the connection.
  - v2.1.293: credential-file upload block.

  The Claude desktop app also has a separate built-in browser, the Cowork browser, which is rolling out gradually. — [Claude Code docs](https://code.claude.com/docs/en/chrome); [Support article](https://support.claude.com/en/articles/12012173-getting-started-with-claude-in-chrome)
- **[community]** Issue #27869 (screenshot accumulation) and #46216 (no HiDPI guidance) were both closed "not planned" by the stale bot with no maintainer reply. — [#27869](https://github.com/anthropics/claude-code/issues/27869); [#46216](https://github.com/anthropics/claude-code/issues/46216)

### Inferences
- The `scale` parameter, with its note about older extensions, looks like a 2026 response to the screenshot-cost complaints. Its existence is observed only in this session's schema, not in public docs.

### Gaps
- I found no public changelog for the extension, so I can't date when `scale`, `browser_batch` or `find` were introduced.
