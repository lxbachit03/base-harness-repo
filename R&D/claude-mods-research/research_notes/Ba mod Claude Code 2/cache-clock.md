# cache-clock (jz-wilson/claude-mods, pinned cd9448a7) — research note

Scope: one mod, `cache-clock`, at pinned commit `cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e` (commit dated 2026-11-10, message "savvy-progress 1.3.0 ... (#25)"; cache-clock there is **v0.3.2**), plus what changed on `main` since. Current as of 2026-11-23. Nothing was installed or run. Files were downloaded as data into the scratchpad (`.../scratchpad/mods2/cache-clock/pin/`).

Short URLs used below:
- PIN = `https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e`
- REG = PIN + `/cache-clock/hooks/register.tsx`
- TTL = PIN + `/cache-clock/bin/ttl.py`
- TYP = PIN + `/cache-clock/types/index.d.ts`
- CMP = `https://github.com/jz-wilson/claude-mods/compare/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e...main`
- CCDOC = `https://code.claude.com/docs/en/prompt-caching`
- APIREF = local mod API reference `C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/.../plugin-authoring/reference.md` and `types/claude-code.d.ts` (Claude Code 2.1.330 bundle)

## What does it do, and does it cost money?

### Takeaway
cache-clock draws a band above the prompt (not a status-line entry) that counts down until the main chat's prompt cache goes cold, then says "Cache cold" and, for chats of 150k+ tokens, offers a "Hand off to a fresh chat" button. It also has an opt-in **Keep warm** feature that sends real background model calls (`$.model.fork`) about 45 s before expiry, up to 30 pings or 2 hours: this costs tokens and is billed to the session's credentials. The clock itself makes no model calls.

### Cited Findings
- Manifest: name `cache-clock`, version `0.3.2`, description "Counts down until the chat's prompt cache goes cold, above the prompt. When a big chat goes cold, offers a handoff to a fresh chat. Keep warm pings the cache in the background so it does not go cold"; author "Ben AI" (benai.co); `types: ./types/index.d.ts`; no `engines`, no `userConfig`, no license field — [plugin.json](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/.claude-plugin/plugin.json) (lines 1-10).
- `hooks/hooks.json` is only `{ "modules": ["./register.tsx"] }`: the whole mod is one hooks module in the mod API (no shell hooks, no MCP server, no skills, no agents) — [hooks.json](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/hooks.json).
- Constants: `FIVE_MIN`, `ONE_HOUR`, `DEMO_MS = 60_000`, `BIG = 150_000` (handoff button threshold), bar width 20 — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 8-13.
- What the user sees: an `AbovePrompt` band, `ui.render { component: 'AbovePrompt' }` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 408-474. While warm: "◷ Cache warm M:SS", a coloured bar (green, then `warning` under 50 %, `error` under 60 s), a label such as "1 hour cache, as Anthropic's last reply set it", "Reply now and Nk tokens cost 5 to 10% as much", buttons "Keep warm" / "Hide", and a dim tip line (lines 423-450, 110-114, 28). When cold: "❄ Cache cold since N min ago. Your next message re-reads Nk tokens at full cost." plus "Hand off to a fresh chat" if tokens >= 150k (lines 453-473). The band hides while a turn runs, while `isWorking`/`hasSurvey`, before the first reply, or when hidden/off (line 411).
- Toasts (`$.ui.toast`) for keep-warm start and stop and for hide — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 146-152, 165-171, 374, 404. No sound, no pane, no status-line entry.
- Slash commands registered: `/cacheclock [hide|demo|auto]` and `/keepwarm [off]`, both `immediate: true` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 309-320, 358-393. `/cacheclock demo` switches to a 60 s fake TTL for filming, this chat only (lines 116-121, 382-385).
- **Keep warm makes model calls.** `ping()` calls `$.model.fork({ prompt: 'Reply with the single word: ok' })` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 27, 192-229. It fires when `lastEnd + ttlMs - now <= 45 s` (`LEAD = 45_000`, line 22, 184). Caps: `MAX_PINGS = 30`, `MAX_MS = 2 h`, `MAX_FAILS = 3` in a row, `RETRY_MS = 20 s` after a failure (lines 23-26, 179-181, 224-226). It is off by default; it starts only on the "Keep warm" button or `/keepwarm` (lines 358-376), and stops when the person sends any prompt that is not the mod's own command or a background origin (`task-notification`, `peer`, `coordinator`, `channel`, `auto-continuation`, etc.) (lines 30, 347-356).
- The fork request names no `effort`, so it runs at the session's effort level — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) line 198; the API doc says "A fork thinks as hard as the session does, which at `max` can be a minute for a one-line answer" and naming no effort is what keeps the cache read on every model — [APIREF reference.md](file:///C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/a99ddd21ff91346d87ab040c163f5795/plugin-authoring/reference.md) line 265.
- `$.model.fork` "Runs one tool-less completion over the session's OWN transcript as the main thread last sent it, so the API serves that prefix from its cache ... the prefix billed afresh once the entry lapsed, after `/model`" — [APIREF claude-code.d.ts](file:///C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/a99ddd21ff91346d87ab040c163f5795/plugin-authoring/reference.md) lines 3150-3176. Fork costs are "billed to the session's credentials", counted in the session's cost total, and "nothing caps them per call" — [APIREF reference.md](file:///C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/a99ddd21ff91346d87ab040c163f5795/plugin-authoring/reference.md) line 265.
- The mod records each ping's `cache_read_input_tokens` / `cache_creation_input_tokens` and flags `cold: write > read` (the ping had to rewrite the cache) — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 208-220, 237. Unlike Nate Herk's cache-keeper, it does **not** stop when a ping writes instead of reads; it keeps pinging (see lineage section).
- Type doc confirms the keep-warm state model ("it stops by itself 2 hours later", "after 30", "it stops after 3") — [TYP](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/types/index.d.ts) lines 16-35.

### Inferences
- Cost arithmetic (input-token equivalents, C = context tokens; using the published multipliers cache read 0.1x base input, 5-minute write 1.25x, 1-hour write 2x — [Anthropic prompt caching pricing](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#pricing)): on a **5-minute** TTL a ping fires every ~4 min 15 s, so the 2-hour cap allows ~28 pings ≈ 2.8 C, more than one cold rewrite (1.25 C); break-even is ~12 pings (~50 min). Keep warm only pays on 5-minute TTL for short absences. On a **1-hour** TTL a ping fires at ~59 min 15 s, so at most 2 pings in 2 hours ≈ 0.2 C vs a 2 C rewrite: cheap, if the ping really refreshes the 1-hour entry (see Gaps). Each ping also bills output/thinking tokens at session effort, which on high/max effort can exceed the tiny "ok" answer.
- The in-band claims are approximate: "5 to 10% as much" is right for reads vs base input (10 %) or vs a 1-hour write (5 %), but "re-reads ... at full cost" understates the cold case, which is billed as a cache **write** at 1.25x or 2x base input.

### Gaps
- Whether a `$.model.fork` read refreshes the main thread's **1-hour** entry for another hour. Claude Code docs put forks in the "everything else" TTL bucket (five minutes by default) — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Which TTL each request gets" — but a cache hit is a read of the existing prefix entry; I found no source stating which TTL a read through a fork refreshes. Not verified (would require running the mod).
- Exact $ cost per ping for this user's model and effort not computed (no live pricing for "Opus 5.5" fetched).

## How does the code know the TTL and the last cache write? Is it accurate for 1-hour sessions?

### Takeaway
The TTL is **detected**, not assumed: on every main-thread `turn.complete` (and at session start) it spawns `python3`/`python bin/ttl.py <sessionId>`, which reads the tail of the session transcript JSONL and returns `1h` if the newest main-thread assistant reply with a cache write has `ephemeral_1h_input_tokens > 0`, else `5m`, else `unknown` (then a 5-minute guess). So it works for this user's 1-hour sessions as long as Python runs. At the pinned v0.3.2 the countdown starts at turn **end**, which overstates the remaining time by the length of the last request; v0.3.4 on `main` fixed this by starting from the last request's `api-request` timestamp.

### Cited Findings
- `ttl.py` globs `~/.claude/projects/*/{sid}.jsonl`, reads the last 3,000,000 bytes, drops the first (possibly cut) line, walks backward over `type == 'assistant'` rows that are not `isSidechain`, and prints `1h` / `5m` from `message.usage.cache_creation.ephemeral_1h_input_tokens` / `ephemeral_5m_input_tokens`, else `unknown` — [TTL](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/bin/ttl.py) lines 1-25.
- Claude Code itself reports 1-hour writes under `ephemeral_1h_input_tokens` and 5-minute writes under `ephemeral_5m_input_tokens` — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Choose the TTL yourself".
- `detect()` tries `python3`, then `python` ("Windows installs often have only `python`"), logs "no python3 or python" on failure — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 255-265. `ttl()` falls back to `FIVE_MIN` with `ttlSource: 'default'` ("a guess until the first reply") — lines 109-121.
- `restart()` on each main-thread `turn.complete` (`e.agentId === undefined`) sets `lastEnd: now`, re-detects TTL, and stores `context.tokens` from `$.session.usage()` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 267-273, 337-345. Subagent ("helper") turns are ignored (lines 331-343). A successful ping moves `lastEnd` to the ping's start (line 222).
- The tick runs every 1 s (`$.clock.every(1000, …)`) and skips while a turn runs — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 275-285, 321-324.
- Default TTLs: on a Claude subscription within plan usage the main conversation gets **one hour**; API key / cloud / usage credits get five minutes; going over plan usage onto usage credits drops the main conversation to five minutes unless `promptCacheTtl` is set — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Which TTL each request gets".
- Cache lifetime counts from request time: "Each request that hits the cache resets the timer" — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Cache lifetime". The `main` commit #32 states "The cache lifetime counts from the start of the request that last wrote or read it, not from the end of its reply ... so the countdown has to start there" — [CMP](https://github.com/jz-wilson/claude-mods/compare/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e...main) (`cache-clock/bin/ttl.py`).
- `main` (v0.3.4, commit `1f637d6`, 2026-11-16, "count the cache lifetime from the request start (#32)"): `ttl.py` now prints `"<ttl> <startMs>"` taken from the `api-request` row before the last reply (falls back to the previous user/assistant row); `register.tsx` adds `detectedStart`, `turnStartedAt`, `cacheStart(now)` and uses it as `lastEnd`; a new fixture test `bin/test_ttl.py` (7 cases) — [CMP](https://github.com/jz-wilson/claude-mods/compare/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e...main); [commit list](https://api.github.com/repos/jz-wilson/claude-mods/commits?path=cache-clock).

### Inferences
- For this user (subscription, 1-hour main-thread TTL, `promptCacheTtl` not set in `~/.claude/settings.json` — checked locally), detection should return `1h` after the first reply; Python 3.14 is installed at `%LOCALAPPDATA%\Programs\Python\Python314`, so the `python` fallback should work even if `python3` is the Windows Store stub. If Python failed, the band would claim "cold" after 5 minutes while the cache is really warm for ~55 more minutes.
- Pinned v0.3.2 error: the clock runs late by the duration of the last API request (seconds, up to minutes for long generations), so it can say "warm" for a short time after the cache expired. On a 1-hour TTL this matters little; on 5 minutes it is a larger share. v0.3.4 fixes it.
- The clock is per Claude Code process (module variables reset on reload, state in `$.state`), so each harness worker session would show its own clock.

### Gaps
- Not verified that Claude Code 2.1.330 still writes `api-request` rows and `cache_creation` sub-objects in the transcript exactly as `ttl.py` expects (transcript format is not a public contract).

## Every file at the pinned commit: events, $ APIs, timers, files, processes, network, tests

### Takeaway
Five files (plus a 30 KB test): `plugin.json`, `hooks/hooks.json`, `hooks/register.tsx` (475 lines), `bin/ttl.py` (25 lines), `types/index.d.ts`, `hooks/register.test.tsx`. It writes three files under `~/.claude/` (switches, log, handoff request), spawns Python each turn, and its only network use is the opt-in fork pings through Claude Code's own client.

### Cited Findings
- Tree at the pin (sizes): `.claude-plugin/plugin.json` 377 B, `bin/ttl.py` 923 B, `hooks/hooks.json` 34 B, `hooks/register.tsx` 20,704 B, `hooks/register.test.tsx` 30,290 B, `types/index.d.ts` 1,368 B — [git tree API](https://api.github.com/repos/jz-wilson/claude-mods/git/trees/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e?recursive=1).
- Events hooked: `session.start` (L296), `turn.start` (L329), `turn.complete` (L337), `prompt.submit` (L348), `command.run` ×2 (`keepwarm` L358, `cacheclock` L378), `ui.press` ×3 (`keepwarm` L371, `handoff` L395, `hide` L400), `ui.render` `AbovePrompt` (L408) — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx). No `tool.*`, `prompt.section`, `prompt.compose` or `tool.describe` hooks: it adds nothing to the model's context.
- $ APIs: `$.session.id`, `$.session.usage`, `$.plugin.root`, `$.store.get/set` (only to clear an old `demo` flag), `$.state.get/set`, `$.clock.now/every`, `$.command.register`, `$.fs.exists/read/write`, `$.process.run`, `$.model.fork`, `$.ui.toast/invalidate/resolve` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 47-298.
- Timers: `$.clock.every(3000)` re-reads `switches.json` (L306-308); `$.clock.every(1000)` runs `tick` and `warmTick` (L321-324).
- Files written: `~/.claude/mods/switches.json` (read every 3 s; written on hide/show, key `cache-clock:hidden`; `cache-clock: false` there means off — shared with the `/mods` switchboard mod) (L40-97); `~/.claude/mods-logs/cache-clock.log` (rolling last 200 lines, each with ISO time, the first 8 chars of the session id, and events such as ping token counts) (L242-252); `~/.claude/handoffs/.request-<sessionId>` (timestamp only, written on the handoff button; "The handoff mod picks this file up within 5 seconds") (L287-293). Home is derived by splitting `$.plugin.root` at `/.claude/` (L47, 298).
- Processes: `python3`/`python <root>/bin/ttl.py <sid>` at session start and after every main turn (L258-260, 271, 325). `ttl.py` only reads the transcript and prints one word (TTL lines 1-25).
- Network: no `fetch`/HTTP in the code; the only outbound traffic is `$.model.fork` to the session's model provider when keep warm is on — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) line 198.
- userConfig: none — [plugin.json](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/.claude-plugin/plugin.json).
- Tests: `register.test.tsx` runs 9 tests × 2 surfaces (desktop, terminal) with `claude-code/testing` mocks: countdown/cold/handoff, hidden flag, switched off in `/mods`, keep warm start/ping/stop, 30-ping cap, stop on switch-off, 40/80/144-column layout with theme colours only, no tick during a turn, survives a helper's turn — [register.test.tsx](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.test.tsx) lines 25-468. CI runs `claude plugin validate` and `claude plugin test` per mod on ubuntu-24.04 and windows-2025 with Claude Code 2.1.304 pinned — [ci.yml](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/.github/workflows/ci.yml) lines 17-48.

### Inferences
- The handoff button does nothing by itself unless the separate `handoff` mod is installed; it just drops a request file.
- `switches.json` and the log are global (all projects, all sessions), so hiding the clock in one chat hides it everywhere (the code says so: "Cache Clock hidden in every chat", L389).

### Gaps
- Whether `$.process.run` triggers a permission prompt in this Claude Code build was not checked.

## Lineage: Ben AI benai-mods vs nateherkai's mod; licence

### Takeaway
jz-wilson's cache-clock is a lightly modified copy of **Ben AI's** cache-clock from "benai-mods", imported with history and "redistributed with permission" plus Windows fixes. It is **not** a fork of nateherkai/claude-code-mods: that repo has no `cache-clock`; its cache mod is **cache-keeper** (MIT, Nate Herk), an independent implementation with the same idea. There is also a third, unrelated `cache-clock` by hamzafer (status-line based). Neither jz-wilson's repo nor this mod carries a licence.

### Cited Findings
- jz-wilson README: "The eight mods other than replay-theater, from helper-desk to effort-optimizer, come from Ben AI's benai-mods (benai.co) and are redistributed with permission, with Windows fixes added here." — [README.md](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/README.md) line 22. First cache-clock commit: `e29fddc` 2026-10-22 "Merge benai-mods: brain-dump, cache-clock, chat-inventory, handoff, ..." — [commits API](https://api.github.com/repos/jz-wilson/claude-mods/commits?path=cache-clock).
- Several unrelated GitHub accounts host non-fork uploads of `benai-mods` containing `plugins/cache-clock` (e.g. jai38, created 2026-11-19, cache-clock v0.3.1, no licence) — [jai38/benai-mods](https://github.com/jai38/benai-mods); [GitHub search](https://api.github.com/search/repositories?q=benai-mods). Its `ttl.py` is byte-identical to the pinned one; `register.tsx` differs by Windows path/PowerShell helpers, hex colours (pinned uses theme keys) and the `barColumns` width logic (diff run locally).
- jz-wilson repo licence: `license: null` from the GitHub API; no LICENSE file at root; plugin.json has no licence — [repo API](https://api.github.com/repos/jz-wilson/claude-mods); tree listing above.
- nateherkai/claude-code-mods: created 2026-10-02, 148 stars, 18 forks, MIT, description "Four Claude Code mods: Cache Keeper, Recording Mode, Goal Meter, and Collision Guard"; directories `cache-keeper/`, `collision-guard/`, `goal-meter/`, `recording-mode/` — [repo API](https://api.github.com/repos/nateherkai/claude-code-mods).
- cache-keeper differences: default TTL 60 min (`ttlMin: 60`), keep-warm window 4 h, margin 8 min on 1-hour TTL / 90 s otherwise, ping prompt "cache-keeper keep-alive ping. Reply with only: ok", tracks ping $ cost, and **stops keep-warm if a ping writes instead of reads**; also a `/board` of all local chats, privacy module and a session-handoff skill — [cache-keeper register.mjs](https://github.com/nateherkai/claude-code-mods/blob/main/cache-keeper/hooks/register.mjs) lines 25-48, 346-380; [plugin.json](https://github.com/nateherkai/claude-code-mods/blob/main/cache-keeper/.claude-plugin/plugin.json).
- The 2026-10-02 Nate Herk video calls it a "cache clock" counting down from 60 minutes with a handoff button; the write-up links no repo and says the mods are distributed through his community — [openclawdatabase summary](https://openclawdatabase.com/news/videos/2026-10-02-claude-code-mods-cache-clock-record-mode-collision-guard/).
- A different `cache-clock` (hamzafer/claude-code-mods, v0.1.1) adds a prompt-cache line under the status line via `/cache-clock setup` — [claudemarketplaces listing](https://claudemarketplaces.com/plugins/hamzafer-claude-code-mods/cache-clock); [mods.aidojo.si](https://mods.aidojo.si) lists hamzafer's, not jz-wilson's.

### Inferences
- Name collisions: at least three "cache clock" mods exist (Ben AI → jz-wilson; Nate Herk's video name for cache-keeper; hamzafer). Installing by bare name from the wrong marketplace is a realistic mix-up.
- No licence means no explicit right to reuse or modify the code beyond what the author permits; the "with permission" statement is the only grant, and it is the redistributor's claim.

### Gaps
- Ben AI's original benai-mods source repo/distribution channel was not found publicly; "with permission" could not be verified.

## Install, scopes, version, pinning

### Takeaway
Install from the marketplace `jz-wilson/claude-mods` with `/plugin install cache-clock --marketplace jz-wilson/claude-mods` (or `claude plugin install ...`), pick a scope. The pinned v0.3.2 declares no engine requirement; `main` v0.3.4 requires Claude Code >= 2.1.323. Releases are tagged per mod (`cache-clock-v0.3.x`), which are the pinning points.

### Cited Findings
- marketplace.json lists 14 plugins including `{ "name": "cache-clock", "source": "./cache-clock" }`, owner jz-wilson — [marketplace.json](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/.claude-plugin/marketplace.json) lines 1-21.
- Install: "/plugin install helper-desk --marketplace jz-wilson/claude-mods ... Answer y to add the marketplace, then pick a scope"; shell `claude plugin install ...`; desktop app: + → Plugins → Add marketplace — [README.md](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/README.md) lines 30-47.
- `main` adds `"engines": { "claude-code": ">=2.1.323" }` and an `icon.png` — [CMP](https://github.com/jz-wilson/claude-mods/compare/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e...main); repo-wide commit "Pin mods to Claude Code >=2.1.323 and validate with --strict on 2.1.325 (#28)".
- Releases: `cache-clock-v0.3.1` (2026-10-22), `v0.3.2` (2026-10-23), `v0.3.3` (2026-11-14, icon), `v0.3.4` (2026-11-16) — [releases API](https://api.github.com/repos/jz-wilson/claude-mods/releases); release workflow tags `<mod>-v<version>` after CI passes — [release.yml](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/.github/workflows/release.yml).

### Inferences
- A marketplace install tracks the branch head, not the pinned commit; to stay on reviewed code one would need a marketplace pointed at a commit/tag. The pinned 0.3.2 is already superseded by the 0.3.4 accuracy fix.

### Gaps
- Exact marketplace syntax to pin a git ref was not looked up for this build.

## Maturity and trust

### Takeaway
Small, young, single-maintainer repo: 3 stars, 2 forks, 48 commits, one contributor, no licence, created 2026-10-19, last push 2026-11-18. Engineering hygiene is decent (CI on Linux and Windows, mock tests, per-mod releases, PRs for every change), but the code originates from a third party (Ben AI) and the repo has no outside review.

### Cited Findings
- Repo: created 2026-10-19, pushed 2026-11-18, 3 stars, 2 forks, 0 open issues, default branch `main`, not a fork, licence none — [repo API](https://api.github.com/repos/jz-wilson/claude-mods).
- 48 commits (pagination `last` page 48 at per_page=1); contributors: jz-wilson only (48) — [commits](https://api.github.com/repos/jz-wilson/claude-mods/commits); [contributors](https://api.github.com/repos/jz-wilson/claude-mods/contributors).
- 33 issues/PRs, all closed, all self-authored change PRs (#1-#33); cache-clock-specific: #9 (theme keys, width bars, countdown fixes) and #32 (request-start fix) — [issues API](https://api.github.com/repos/jz-wilson/claude-mods/issues?state=all).
- Author account: "Johnzell", created 2017, 45 public repos, 1 follower — [user API](https://api.github.com/users/jz-wilson).
- cache-clock commit history: 6 commits touching the folder, 2026-10-22 to 2026-11-16 — [commits?path=cache-clock](https://api.github.com/repos/jz-wilson/claude-mods/commits?path=cache-clock).
- No independent discussion of jz-wilson's cache-clock found; web search surfaces hamzafer's and Nate Herk's instead — [search results incl. claudemarketplaces](https://claudemarketplaces.com/plugins/hamzafer-claude-code-mods/cache-clock).

### Inferences
- Trust rests on reading the 500 lines yourself; they are readable and do what the README says. The repo bundles 13 other mods (some write `CLAUDE.md`, e.g. `reflect`), so the marketplace as a whole is wider-reaching than this mod.

### Gaps
- No security advisories or third-party audit found.

## Security and privacy risks

### Takeaway
Low surface: no own network calls, no secrets handling, no context injection. Real risks are (1) unbounded-by-default spend from keep warm within its caps (billed silently in the background), (2) running an executable named `python3`/`python` from PATH every turn, (3) a global log and switch file under `~/.claude/`, and (4) future updates arriving via an unpinned marketplace from a single unlicensed repo.

### Cited Findings
- Spend: `$.model.fork` costs are billed to the session and "nothing caps them per call" — [APIREF reference.md](file:///C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/a99ddd21ff91346d87ab040c163f5795/plugin-authoring/reference.md) line 265; the mod's caps are 30 pings / 2 h / 3 failures — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 23-26. It does not stop when pings rewrite the cache (`cold` is only displayed) — lines 220, 237.
- PATH execution: `$.process.run([bin, ttl.py, sid])` with bare `python3` then `python` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 258-260.
- Transcript read: `ttl.py` reads up to 3 MB of the session transcript, but only prints a TTL word — [TTL](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/bin/ttl.py) lines 7-25.
- Log content: session-id prefix, token counts, error text up to 200 chars — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 214, 242-252, 264.
- Handoff request file named with the full session id under `~/.claude/handoffs/` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) line 290.
- Background-origin exemption: prompts from `task-notification`, `peer`, `coordinator`, `channel`, `auto-continuation`, etc. do not stop keep warm — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 30, 352.

### Inferences
- On Windows, a planted `python.exe` earlier in PATH (or the repo's cwd if the engine resolves relative) would run every turn; the risk equals any tool that shells out to Python.
- In orchestrated sessions, worker/peer messages exempt from stopping keep warm means pings may continue while the coordinator is busy being messaged; turns triggered by those messages refresh the cache anyway, so the pings add little.
- Fork pings run with the full transcript as context; nothing new leaves the machine beyond what the main thread already sent the same provider.

### Gaps
- No check of the other 13 mods' behaviour; risk statement is for cache-clock only.

## Token/cost impact on context

### Takeaway
Zero context-token cost: the mod injects no prompt sections, tool descriptions or reminders, and enabling a hooks/commands plugin keeps the prompt cache. Costs come only from opt-in keep-warm pings (see first section) and a Python process per turn (CPU, not tokens).

### Cited Findings
- No `prompt.section`, `prompt.compose`, `tool.describe` or `prompt.submit` context return in the code — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) (all hooks at lines 296-474; `prompt.submit` only returns `next(e)`, L348-356).
- "Claude Code never invalidates the cache for a plugin's skills, commands, agents, hooks, monitors, or themes" — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Plugin components that keep the cache".
- Native alternative: `/usage` shows a `Prompt cache (main)` line with hit ratio, misses and "whether the cache is warm right now", and status-line scripts get a `prompt_cache` object (v2.1.251+) — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Check cache performance".
- Claude Code may idle-compact a long conversation left idle on the 1-hour TTL (`idleCompaction`, v2.1.290+) — [CCDOC](https://code.claude.com/docs/en/prompt-caching) "Compacting the conversation".

### Inferences
- Whether the two registered slash commands appear in the model's command/skill listing (a few dozen tokens) is unverified; it would be an append, not a cache break.
- Interaction to watch: keep warm prevents the idle state that idle compaction looks for, or vice versa; behaviour unverified.

### Gaps
- Effect of `immediate: true` commands on model-visible listings not checked.

## Fit with the harness repo (E:\personal\base-harness-repo)

### Takeaway
Technically compatible and context-neutral, but low value for this harness: sessions run on a 1-hour TTL where the cache rarely goes cold mid-work, Claude Code already exposes cache warmth in `/usage` and the status-line `prompt_cache` fields, and installing it is a global-settings/dependency change that needs specific User authority under #009. It does not collide with the user's custom `statusLine`, because it draws an above-prompt band, not a status line.

### Cited Findings
- Display surface is `AbovePrompt`, not `statusLine` — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) line 408. The user's `~/.claude/settings.json` has a `statusLine` with `type`/`command` (checked locally, no `refreshInterval`, no `promptCacheTtl`, no `enabledPlugins` listed). The sibling `cache-bar` mod, by contrast, takes over `statusLine.command` and wraps the old one — [README.md](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/README.md) lines 49-67.
- #009: "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority" — `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` lines 26-29 (local file). A user-scope plugin install writes user settings and the mod writes `~/.claude/mods/`, `~/.claude/mods-logs/`, `~/.claude/handoffs/` (none exist today; checked locally).
- #094 precedent (third-party installers must not write AGENTS.md, rules or hooks): cache-clock writes none of these and adds no Claude Code hooks to settings; its hooks live inside the plugin module — [hooks.json](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/hooks.json), [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx).
- #064 session-start read budget (33,400 bytes): the mod adds no session-start reading or context — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) (no context hooks).
- Subagent turns are ignored, and each separate worker session would run its own clock — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 331-343.
- With a 1-hour TTL, the band would read "warm" for up to an hour after each reply; ping cadence would be ~59 min — [REG](https://github.com/jz-wilson/claude-mods/blob/cd9448a70f4e51c3a271d9d5b57032d2ebbdb24e/cache-clock/hooks/register.tsx) lines 22, 184; [CCDOC](https://code.claude.com/docs/en/prompt-caching) TTL table.

### Inferences
- Possible value: a coordinator idle for more than an hour while workers run (e.g. long Orca/Herdr worker tasks) could see "cold" and decide to hand off or compact before resuming; for 150k+ chats the handoff button is relevant only if the separate `handoff` mod is also installed. Keep warm across a >1 h coordinator wait costs ~0.1 C per ping, cheap relative to a 2 C rewrite, but only if the 1-hour refresh question (Gaps, first section) holds.
- Lower-risk alternative for the same need: read the `prompt_cache` fields in the existing custom status line, which needs no plugin, no Python spawn and no model calls.
- If adopted: pin to `cache-clock-v0.3.4` or later (not the pinned 0.3.2), install at project or local scope rather than user scope if the goal is harness-only, get explicit User authority per #009, and leave keep warm off by default.

### Gaps
- Harness session-start alignment check (`harness_check.py --quick`) was not run in this worker session; this note is a read-only research output.
- Whether the user's custom status line already shows `prompt_cache` data was not read (only key presence checked).
