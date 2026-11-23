# effort-optimizer (jz-wilson/claude-mods): mechanism, install, trust, risk, cost and Harness fit

Scope: the Claude Code mod at `jz-wilson/claude-mods`, folder `effort-optimizer/`, pinned commit `2153b719d5766e8814500a5e0ae30b94ff60e30d` (2026-10-23), compared with `main` (HEAD `87e98524fc`, 2026-11-18). Current as of 2026-11-23. Files were downloaded with curl into the scratchpad (`...\scratchpad\mods2\effort-optimizer\pin` and `\head`) and read as data. Nothing was installed or executed.

Short links used below:
- PIN = `https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d`
- REG = PIN + `/effort-optimizer/hooks/register.tsx` (537 lines, 20,586 bytes)
- TYPES = local Claude Code 2.1.330 mod API types, `C:/Users/DEV/AppData/Local/Temp/claude/bundled-skills/2.1.330/a99ddd21ff91346d87ab040c163f5795/plugin-authoring/types/claude-code.d.ts`, with `reference.md` beside it

## 1. What it does for the User, and exactly how the code works

### Takeaway
On each prompt the User types, the mod asks Claude Sonnet 5.5 (at low effort, 120 output tokens at most) to pick an effort level using Ben AI's "four questions" rubric. In `suggest` mode (the default) it opens a dialog that offers to switch. In `auto` mode it switches with no dialog. It first tries to change the effort row in `/config`. If that is refused, it rewrites the `effort` field on every main-thread model request through a `turn.step` hook until the User moves the effort picker. It never changes the model, the prompt or the system prompt, and it never denies tool calls.

### Cited Findings
**Files at the pinned commit** (whole folder, from the git tree API): `.claude-plugin/plugin.json` (337 B), `hooks/hooks.json` (34 B), `hooks/register.tsx` (20,586 B), `hooks/register.test.tsx` (2,989 B), `types/index.d.ts` (891 B). There is no README, LICENSE, `bin/`, `commands/` or skills folder in the mod. — [git tree](https://api.github.com/repos/jz-wilson/claude-mods/git/trees/2153b719d5766e8814500a5e0ae30b94ff60e30d?recursive=1)
- **Manifest:** name `effort-optimizer`, version `0.1.0`. Description: "Reads each prompt, picks the effort level it needs with Ben's four-question framework, and offers Switch to that level, or sets it by itself in auto mode". Author "Ben AI", url `https://www.benai.co`, `types: ./types/index.d.ts`. There is no `userConfig`, no `engines` and no `dependencies`. — [plugin.json](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/.claude-plugin/plugin.json)
- **hooks.json:** `{ "modules": ["./register.tsx"] }`. It is a mod-API module, not shell-command hooks. — [hooks.json](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/hooks.json)
- **types/index.d.ts:** declares `Level = low|medium|high|xhigh|max` and a `Band` (`phase: offer|applied|info`, id, level, from, why, note), plus a `PluginState['effort-optimizer']` with `band` and `override`. — [index.d.ts](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/types/index.d.ts)

**Events hooked** (REG):
- `session.start` (L315-334): registers the slash command `/effort-optimizer [auto|suggest|off|on]` and reads `enabled` and `mode` from `$.store`. It reads the shared switch file once, then polls it every 3,000 ms with `$.clock.every`. In the background it finds the effort row in `$.config.list()` and logs it. — [REG L315-334](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L315-L334)
- `prompt.submit` (L336-350): acts only when `e.origin.kind` is `composer` (typed at the terminal) or `bridge` (Remote Control). It skips empty text and anything starting with `/`. It bumps a generation counter, clears a stale offer band and stores the prompt in `held`. The prompt always passes through unchanged (`return next(e)`), and the hook has a `.catch` that passes it on. — [REG L336-350](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L336-L350)
- `turn.step` (L353-376), a streaming generator: ignores subagent steps (`e.agentId !== undefined`) and steps with no string `effort`. It records `lastEffort`. If the User moved the picker (`e.effort !== hold.base`), it drops the hold. On the turn's first step (`e.index === 0`) with a held prompt, it runs `autoAdjust` or `suggest` *before* the first request goes out. If a level is wanted and differs, it sends `next({ ...e, effort: want })` and logs `"<old> -> <new>"`. — [REG L353-376](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L353-L376)
- `command.run` for `effort-optimizer` (L378-413): `auto` or `suggest` sets the mode and turns the mod on. `off` or `on` toggles it, and `off` clears the override and the band. With no argument it prints a status: on or off, the mode, the current level, "held by the mod", and the effort row key. — [REG L378-413](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L378-L413)
- `ui.press` on the elements `switch`, `auto`, `info`, `info-close` and `skip` (L415-453). — [REG L415-453](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L415-L453)
- `ui.render` on `SessionMode` (L457-467): while an override is held, draws an orange "Effort Low/Medium/…" label in the footer. On desktop and vscode this is a `Text`; in the terminal the label is appended to `modes`. The code comment explains why: "The app's model menu belongs to the app: it refuses a chat that changes its own effort." — [REG L455-467](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L455-L467)
- `ui.render` on `AbovePrompt` (L469-536): draws the band. `applied` shows "✓ Effort set to X (was Y) · why" plus a Learn more button, for 15 s (`APPLIED_MS = 15000`, L13). `info` is an explainer saying the effort menu still shows the old level and that moving the menu by hand makes the mod follow it again. `offer` shows Switch, Auto-adjust every prompt and Skip buttons. — [REG L469-536](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L469-L536)

**How it decides** (REG L176-233): `pick()` reads `$.session.messages()` and takes the last assistant reply, cut to 600 characters. It then calls `$.model.complete({ model: 'claude-sonnet-5-5', prompt: pickPrompt(text.slice(0, 4000), lastReply, now), maxTokens: 120, effort: 'low', timeoutMs: 20_000 })` (L224-230). The rubric prompt (L177-205) asks four ordered questions and stops at the first yes:
1. iterative or simple work → low;
2. a hidden mistake would cost money, a client or trust → high;
3. a long, hard, critical hand-off with nobody around to answer questions → xhigh, and max only if the prompt explicitly asks for the deepest work and says it is critical;
4. everything else, or unsure → medium.

It says "A task being long does not make it high" and answers `keep` for short approvals ("yes, go, ok"). The reply must be JSON `{"level","why"}`. `parsePick` (L208-219) maps `keep`, or anything that is not a level, to `null`, which means no change. `cleanWhy` (L158-166) strips dashes, replaces the word "ship" with "publish" and cuts the result to 90 characters. — [REG L157-233](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L157-L233)
- The rubric copies Ben AI's video "Anthropic Just Revealed When to Actually Use Each Effort Level" (22 Oct 2026): the same four questions, "stop at first yes", and xhigh or max only when all three hand-off conditions hold. — [Nic's notes summary of the video](https://notes.nicolasdeville.com/ai/claude-effort-levels/)

**How it applies a level** (`applyLevel`, REG L123-147):
1. It finds a `/config` row whose key or label matches `/effort/i`, whose kind is `choice`, and which has a `high` option (L99-108).
2. If the row exists and is not locked, it calls `$.config.set({ key, value: option })`. On success it clears the override.
3. If the call is denied, or there is no row, or the row is locked, it logs the reason, sets `hold = { level, base: lastEffort }` and `state.override = level`. From then on `turn.step` puts that level on every main-chat request "until the person moves the picker" (comment L121-122, logic L357-375). No `/effort` command is run (L122). — [REG L121-147](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L121-L147)
- The engine API supports this. The `turn.step` docs say "`next({ ...e, model })` or `effort` sends another" and "A rewrite lasts one step". — TYPES L5938-5946, L18858-18868
- `$.config.set` "Changes one row as if the person did in the menu: the event `config.set` with origin { kind: 'plugin', name }, then the writer". It returns `{ deny }` when a hook refuses, a trusted source owns the row, or "only its dialog changes it". — TYPES L3803-3815
- `$.model.complete` takes `effort` ("`low` for a cheap label"). — TYPES L7919-7930

**What the User sees:**
- In suggest mode, `suggest()` (L248-286) shows the status "checking effort…" while Sonnet runs. If the pick differs from the current level, it opens a modal `$.ui.ask` dialog with the header "Effort": "This looks like a X effort task: <why>. Switch before Claude starts?" The options are "Switch to X", "Switch, and auto-adjust from now" and "Keep Y". A dismissed dialog keeps the current level. In auto mode the status reads "picking effort…" and the change happens silently, followed by the 15 s "applied" band. — [REG L247-312](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L247-L312)
- **Code observation:** nothing in REG ever sets a band with `phase: 'offer'`. A grep for `phase: 'offer'` finds no matches, and `setBand` is only called with `applied`, `info` or `null`. So the Switch / Auto-adjust / Skip band (L517-535) and its `switch`, `auto` and `skip` press handlers are unreachable at this commit. Suggest mode uses the modal dialog instead. The `/effort-optimizer suggest` reply still says "a Switch button shows above the prompt" (L390), which does not match the code. — [REG L390, L517-535](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L517-L535)

**$ APIs used:** `$.command.register`, `$.store.get/set` (keys `enabled`, `mode`), `$.state.get/set` (band, override), `$.clock.every/sleep/now`, `$.fs.exists/read/write`, `$.config.list/set`, `$.session.messages`, `$.model.complete`, `$.ui.status`, `$.ui.ask`, `$.ui.invalidate`, `$.ui.resolve`, `$.plugin.root`. — REG passim

**Files written or read, processes, network:**
- It writes `~/.claude/mods-logs/effort-optimizer.log` and keeps the old content trimmed to its last 20,000 characters (L66-75). Logged items: the effort row's key, value and options; failures; and `request` lines of the form "high -> low". Prompt text is not logged.
- It reads `~/.claude/mods/switches.json` (the `/mods` switchboard) every 3 s (L41-64). `home` is derived by splitting `$.plugin.root` at `/.claude/` (L316).
- No `$.process.run`. No `fetch` or other network call except `$.model.complete`, which goes through the session's own client and provider. — [REG L41-75](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L41-L75)

**Tests** (`register.test.tsx`, 58 lines): on desktop and terminal, the test checks the `/effort-optimizer` status, auto, suggest, off and on, that `/help` passes through untouched, and that a typed prompt passes through with zero model calls at submit time. No test exercises `turn.step`, `applyLevel`, the dialog or the rewritten request effort. — [register.test.tsx](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.test.tsx)

**Changes since the pin:** the GitHub compare from pin to `main` shows `main` 16 commits ahead. For this mod, only `plugin.json` changed (version 0.1.0 → 0.1.1, adds `"engines": { "claude-code": ">=2.1.323" }`) and `.claude-plugin/icon.png` (28 KB) was added. A local `diff` confirms `register.tsx`, `register.test.tsx` and `types/index.d.ts` are byte-identical; `hooks.json` is the same 34-byte size in the HEAD tree. The commits touching the folder are #13 (added 2026-10-23), #28 (engines pin), #29 (icons) and #30 (patch bump). — [compare](https://github.com/jz-wilson/claude-mods/compare/2153b719d5766e8814500a5e0ae30b94ff60e30d...main); [path commits](https://github.com/jz-wilson/claude-mods/commits/main/effort-optimizer)
- The pinned commit is not the commit that added this mod. 2153b719 is #16 ("helpin-per: add author so marketplace validation passes"), made 2 minutes after #15. The mod was added in 8987dedfa7 (#13). — [commits API](https://api.github.com/repos/jz-wilson/claude-mods/commits)

### Inferences
- The default (suggest) mode blocks the first model request of every turn until the User answers a modal dialog whenever Sonnet's pick differs from the current level. The dialog runs inside the `turn.step` hook before `next`. That costs friction on many prompts.
- In the fallback path the real effort differs from what Claude Code's own effort menu shows. The mod admits this in the info band (L506) and compensates with the orange footer label.
- The `keep` answer and the 4,000-character cut mean long pasted prompts are judged on their first 4,000 characters only.

### Gaps
- I did not run the mod, so I could not see whether `$.config.set` on the effort row is accepted or denied on Claude Code 2.1.330 (desktop or terminal). The code comment (L455) implies the app often refuses it. Whether an accepted write persists to `~/.claude/settings.json` `effortLevel` is unverified. TYPES only says "as if the person did in the menu… then the writer".
- I could not establish the origin kind of a prompt that `start_session`, Herdr/`hc` or a coordinator injects into a new session. If it is not `composer` or `bridge`, that prompt is not checked.

## 2. Impact on answer quality, and any evaluation

### Takeaway
The author provides no evaluation, benchmark or accuracy data for the classifier. Quality rests entirely on a Sonnet 5.5 low-effort judgment of the prompt text plus a 600-character context snippet. Anthropic's own guidance advises using the default effort and treating effort as a general preference, not a per-task choice. Automatic lowering to `low` therefore carries a real risk of under-thinking.

### Cited Findings
- The repo contains no eval, benchmark or README for the mod, and the only test checks command plumbing (section 1). — [register.test.tsx](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.test.tsx)
- The rubric's first question sends "brainstorming, quick rewrites, … simple questions" and any back-and-forth work to low (REG L182-183). Low is the first rule, and the stop-at-first-yes order means a prompt that is both iterative and risky gets low. — [REG L180-190](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L180-L190)
- Anthropic (Lydia Hallie, 7 Jul 2026): "for most tasks you should use the model's default effort level". Effort is a manual override that should be a general preference tied to your work rather than a per-task choice, and at lower effort Claude is more likely to ask for context than work things out. — [Claude blog](https://www.claude.com/blog/claude-model-and-effort-level-in-claude-code)
- Ben AI's video, as summarized: in a data-analysis test, low "was wrong every time" while high was right 4 of 5 times; a simple redesign took 1 min at low and 28 min at max with similar results. These figures are relayed through an AI-drafted note, not a primary source. — [Nic's notes](https://notes.nicolasdeville.com/ai/claude-effort-levels/)
- The pick sees only the prompt (≤4,000 characters), the last reply (≤600 characters) and the current level. It sees no repository, CLAUDE.md or AGENTS.md context. — [REG L221-230](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L221-L230)

### Inferences
- In auto mode a short coding prompt such as "fix the login bug" could be classed as "simple" or "small tweak" and run at low, which would skip verification steps the User expects at their configured xhigh/high.
- Upward moves (to high or xhigh) raise cost and latency without the User asking for them in auto mode.

### Gaps
- No measured accuracy of the classifier, and no comparison of task outcomes with and without the mod, was found from any source.

## 3. Install, scopes, version requirement, pinning

### Takeaway
It installs as one plugin from the `jz-wilson/claude-mods` marketplace, by `/plugin install effort-optimizer --marketplace jz-wilson/claude-mods`, `claude plugin install …`, or the desktop app's Plugins UI. On `main` it requires Claude Code ≥2.1.323. The repo documents no commit-pinned install. Pinning needs a local copy of the folder at the commit (for example via `--plugin-dir`) or a pinned marketplace source.

### Cited Findings
- `marketplace.json` at the repo root, named `claude-mods`, owner `jz-wilson`, lists `effort-optimizer` with source `./effort-optimizer`. At the pin there are 13 plugins, and on `main` there are 14 (brain-dump replaced by prompt-refiner, savvy-progress added). — [marketplace.json @pin](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/.claude-plugin/marketplace.json); [@main](https://github.com/jz-wilson/claude-mods/blob/main/.claude-plugin/marketplace.json)
- The README's install instructions:
  - in a terminal session, `/plugin install helper-desk --marketplace jz-wilson/claude-mods`, then answer `y` to add the marketplace and pick a scope;
  - from a shell, `claude plugin install <mod> --marketplace jz-wilson/claude-mods`;
  - in the desktop app, + → Plugins → Add marketplace `jz-wilson/claude-mods` → Add plugin. — [README](https://github.com/jz-wilson/claude-mods/blob/main/README.md#install)
- The README says each `plugin.json` sets `engines["claude-code"]`, the floor is `>=2.1.323`, and "Claude Code does not install, update or load a mod outside that range". The pinned 0.1.0 manifest has no `engines` field. — [README Development](https://github.com/jz-wilson/claude-mods/blob/main/README.md#development); [plugin.json @main](https://github.com/jz-wilson/claude-mods/blob/main/effort-optimizer/.claude-plugin/plugin.json)
- CI runs on ubuntu-24.04 and windows-2025. At the pin it installs `@anthropic-ai/claude-code@2.1.304`, runs `claude plugin validate` (warnings fail the build) and `claude plugin test` per mod. A merge that bumps a version publishes a release tagged `<mod>-v<version>`. — [ci.yml](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/.github/workflows/ci.yml); [release.yml](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/.github/workflows/release.yml)
- Per-mod release tags exist (for example `effort-optimizer-v0.1.1` is implied by the release workflow; listed releases include `screen-share-v0.2.2`, `mods-v0.5.2` and others dated 2026-11-14). — [releases API](https://api.github.com/repos/jz-wilson/claude-mods/releases)

### Inferences
- A marketplace install follows `main`, so a future update to the code would arrive automatically unless auto-update is off. The code has been unchanged from the pin to `main` so far.

### Gaps
- I did not confirm from the release list that a tag named exactly `effort-optimizer-v0.1.1` exists. The first page showed 10 releases, and that tag was not among them.

## 4. Maturity and trust

### Takeaway
This is a very young, single-maintainer repository with 3 stars and 2 forks, no license file at the root, and all 48 commits by one author. The mod itself is a redistribution of Ben AI's "benai-mods" with Windows fixes. It is not listed in the largest community mod catalogue. Similar effort-routing mods are common.

### Cited Findings
- Repo `jz-wilson/claude-mods`: "Mods for Claude Code", created 2026-10-19, last push 2026-11-18. 3 stars, 2 forks, 0 open issues, `license: null`, not a fork. — [repo API](https://api.github.com/repos/jz-wilson/claude-mods)
- 48 commits, all by jz-wilson ("Johnzell"). Contributors API: `jz-wilson` 48. 33 issue numbers, all of them merged or closed PRs by the owner, and no user-filed issues. — [contributors](https://api.github.com/repos/jz-wilson/claude-mods/contributors); [issues](https://api.github.com/repos/jz-wilson/claude-mods/issues?state=all)
- Author profile: login `jz-wilson`, name "Johnzell", company "OnShift", 45 public repos, 1 follower, account created 2017-11-09. — [user API](https://api.github.com/users/jz-wilson)
- The README credits Ben AI: "The eight mods other than replay-theater, from helper-desk to effort-optimizer, come from Ben AI's benai-mods (benai.co) and are redistributed with permission, with Windows fixes added here." I found no public benai-mods repository to compare against. — [README](https://github.com/jz-wilson/claude-mods/blob/main/README.md); search for "benai-mods" found nothing ([web search](https://www.skool.com/systems-to-scale-9517/ai-hack-which-claude-code-effort-level-to-use) returned only Ben AI's effort-level content)
- License: the repo root has no LICENSE. Only `filetree/` (fork, LICENSE), `replay-theater/` (Apache 2.0) and savvy-progress (MIT) carry licenses. effort-optimizer has none, so reuse rights are unclear beyond "redistributed with permission". — [git tree](https://api.github.com/repos/jz-wilson/claude-mods/git/trees/2153b719d5766e8814500a5e0ae30b94ff60e30d?recursive=1)
- Both forks, `QuesoMan/claude-mods` and `SLANTDholdings/terminal-mods` (0 stars each), have an `effort-optimizer/hooks/register.tsx` byte-identical to the pin (sha256 `98607370…982d`). Their changes are in other mods. No suspicious altered copy was found. — [forks API](https://api.github.com/repos/jz-wilson/claude-mods/forks)
- The mods.aidojo.si catalogue ("9,018 mods scanned… An independent community scan. Not an official Anthropic directory", stats as of 2026-11-21 against 2.1.330) does not list `jz-wilson` or `effort-optimizer`. A grep of the 11 MB raw `catalogue.md` found 0 matches. It lists many similar mods, for example `effortless` (HeyCubit), `effort-auto` (KilimcininKorOglu; wdsewdser-bit), `effort-pilot`, `effort-router` and `quality-router` (nextscape), `automode`, `claude-router`, `magic-router`, `jev-router` and `ripple`. — [mods.aidojo.si](https://mods.aidojo.si); [raw catalogue](https://raw.githubusercontent.com/karanb192/awesome-claude-code-mods/main/catalogue.md)
- A different, unrelated "effort-optimizer" exists as a SKILL.md on the ClaudSkills registry (task-category effort suggestions for ralph loops). It is not this mod. — [ClaudSkills](https://claudskills.com/skills/effort-optimizer/)
- The other mods in the repo at `main`: prompt-refiner, cache-bar (a status-line script that takes over `statusLine` via `/cache-bar:setup`), cache-clock, chat-inventory, filetree (fork), handoff, helper-desk, helpin-per, mods (`/mods` switchboard), reflect (writes rules to `~/.claude/CLAUDE.md` or a folder), replay-theater (Anthropic sample), savvy-progress (fork) and screen-share. At the pin, brain-dump was present instead of prompt-refiner and savvy-progress. — [README](https://github.com/jz-wilson/claude-mods/blob/main/README.md)

### Inferences
- The mod's code is small, readable and has not changed since it was added, but nobody outside the author has reviewed it publicly.

### Gaps
- I could not verify Ben AI's permission claim or find Ben AI's original source.

## 5. Security and privacy risks

### Takeaway
The risk surface is modest. There is no shell, no third-party network and no file writes outside a log. The concrete exposures are: (a) every typed prompt (≤4,000 characters) plus 600 characters of Claude's last reply is sent in an extra Sonnet 5.5 request on the User's credentials; (b) the mod can change the User's effort setting through `$.config.set` and silently override per-request effort; (c) any future marketplace update would run with the same in-process mod privileges.

### Cited Findings
- Data sent: `pickPrompt(text.slice(0, 4000), lastReply)` with `lastReply = lastAssistantText(...).slice(0, 600)`, through `$.model.complete` on model `claude-sonnet-5-5`. — [REG L221-230](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L221-L230)
- `$.model.complete` "runs one text completion with no history on the session's own client". Costs are "billed to the session's credentials", count in the session cost total and `/usage`, and "nothing caps them per call". — reference.md L265
- Settings mutation: `$.config.set({ key: row.key, value: option })` on the effort row (REG L130). This is the same path as the person using the menu (TYPES L3803-3815).
- Silent override: `next({ ...e, effort: want })` on main-thread steps (REG L375). The info band admits "The effort menu next to the model name still shows {was}" (REG L506).
- Prompt injection in the classifier: user text and the assistant reply are embedded raw in the rubric prompt inside `<prompt>` and `<reply>` tags (REG L195-203). Text in a pasted document could steer the level, for example toward `max`. The output is limited to one of five levels or `keep`, so the damage is bounded to the effort choice.
- File I/O is limited to the log under `~/.claude/mods-logs/` and reading `~/.claude/mods/switches.json` (REG L48, L68). No `$.process.run` and no `$.fs` writes elsewhere.

### Inferences
- Steering toward `max` through injected text would raise cost and latency for that turn. Steering toward `low` would lower diligence. Neither exposes data beyond the session's own provider.
- Because it is installed from a marketplace that follows `main`, trust depends on a single maintainer's future pushes.

### Gaps
- Whether `api_request` telemetry (OTEL) for the mod's calls is on for this User is unknown.

## 6. Token and cost impact

### Takeaway
It costs one extra Sonnet 5.5 call per typed prompt that is not a slash command (when enabled): about 2.1 KB of fixed rubric plus the prompt (≤4,000 characters) plus ≤600 characters of reply as input, and ≤120 output tokens. There may also be indirect costs: prompt-cache churn when per-request effort changes, and more main-model tokens whenever it raises the level.

### Cited Findings
- The rubric template (REG L178-205) is 2,096 bytes before the prompt and reply are inserted (measured locally). `maxTokens: 120`, `effort: 'low'`, timeout 20 s. — [REG L224-230](https://github.com/jz-wilson/claude-mods/blob/2153b719d5766e8814500a5e0ae30b94ff60e30d/effort-optimizer/hooks/register.tsx#L224-L230)
- It is called once per held prompt at the turn's first step (REG L365-371). Prompts starting with `/`, empty prompts, non-composer and non-bridge origins, and the off state cost nothing (REG L337-340).
- There is no prompt-cache marking (`cache: true`) on the fixed rubric, so the rubric is re-sent uncached each time. — REG L224-230; caching mechanism per reference.md L265
- Effort and caching: TYPES notes that on a model with per-message effort a level "on a step with input stays for later tool steps", and reference.md says that where effort is "one setting of the whole request" a different level makes a fork re-write the whole conversation as its own cache entry. — TYPES L18858-18866; reference.md L265

### Inferences
- Rough order of magnitude: about 600 to 1,800 input tokens and at most 120 output tokens of Sonnet per prompt. This is small next to an xhigh Opus turn. If auto mode lowers the User's xhigh default to low or medium, net main-model spend could fall, which is presumably the intended benefit.
- If the session's model takes effort as a whole-request setting, switching level between turns may invalidate or duplicate the main thread's prompt cache. This is inferred from the fork documentation and was not verified for main-thread `turn.step` rewrites.

### Gaps
- No price figures were verified for Sonnet 5.5 in this research. Real cache behaviour under main-thread effort rewrites was not measured.

## 7. Fit with the Harness repo (E:\personal\base-harness-repo)

### Takeaway
The fit is poor as an always-on, user-scoped mod. The Harness and the User make explicit effort choices: user settings set `effortLevel: xhigh` and per-model `high`, and the Claude instructions give sub-sessions a User-selected model and effort with a confirm step. Auto mode would override those choices silently. Suggest mode would interrupt turns with dialogs, including in delegated sessions where nobody may be watching. Installing it needs specific User authority under #009 (a dependency install that changes a global setting). It does not violate the #094 precedent, since it writes no AGENTS.md, rules or hooks files, and it adds nothing to the session-start read budget (#064).

### Cited Findings
- #009 "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority". — `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` L26-30 (local file)
- #094 records "Keep the Harness in charge of agent instructions: no third-party installer writes `AGENTS.md`, rules or hooks." The mod's code writes only the log file and uses mod hooks inside its own plugin folder (REG L68). — `docs-harness/harness-improvements/1123-code-graph-skill.md` L28-29 (local file)
- The Harness assigns effort explicitly:
  - `claude-instructions/coding-sub-session.md` has an effort checklist (marked `[x]` Sonnet 5.5 high) and step 1 "Ask the User before starting a session… offers the efforts", passing `effort` to the new session (L8-15, L32-40);
  - `prd-research-sub-session.md` fixes Opus 5.5 at `high` (L7-11);
  - `research-subagents.md` fixes Haiku 5.5 at `high`, with `xhigh` for "extra" (L8-24);
  - HERDR-APP.md and HERDR-TUI.md encode worker effort in the model ID or `--effort` (HERDR-APP.md L86; HERDR-TUI.md L212).

  All local files under `docs-harness/`.
- The User's own user settings at `C:\Users\DEV\.claude\settings.json` set `"effortLevel": "xhigh"` and `modelSettings` with `effortLevel: "high"` for `claude-opus-5`, `claude-sonnet-5` and `claude-opus-5-5` (L156-166, local, read-only).
- The mod leaves subagent effort alone (`e.agentId !== undefined` skips, REG L354). Every separate top-level session (a coordinator, a `start_session` sub-session, a Herdr/`hc` worker running Claude Code) loads user-scoped plugins and would be subject to it on its own main thread.
- Suggest mode calls `$.ui.ask` inside `turn.step` before the first request (REG L271, L365-369). An unattended worker session would wait on that dialog. A dismissed dialog keeps the level (REG L276-277). Only `composer` and `bridge` prompts trigger a pick (REG L338).
- #074 says a delegated worker "keeps its launch role" and session settings come from the coordinator. — `docs-harness/harness-constraints/1120-session-role-and-judgment.md` L17-25 (local file)
- The mod loads no text into agent context (no skills, commands with bodies, or system-prompt edits), so the #064 session-start read budget of 33,400 bytes is unaffected. — REG passim
- There is no project `.claude/settings.json`, so a project-scope install would create Harness-repo configuration. A user-scope install alters every project. — prior-round fact from the brief

### Inferences
- Auto mode conflicts with the User's explicit `xhigh` default and with the Harness's per-role effort checklists. It would silently replace a chosen level for a whole turn, and keep holding it until the picker moves, without the User re-confirming. That runs against the spirit of "the User selects effort" in the sub-session instructions.
- Suggest mode is the less risky option. It keeps the User in control but adds one dialog plus one Sonnet call per typed prompt.
- If the User wants to trial it: install at project or local scope in a scratch repo, not user scope, with specific User authority (#009). Keep it in `suggest` or `/effort-optimizer off` in coordinator and worker sessions, and compare the outcome. A Harness-native alternative is to keep explicit effort checklists, which already exist, and skip the mod.
- Every risk above carries the proposal in the previous bullet (per #001).

### Gaps
- I could not confirm whether a coordinator's `start_session`, or a Herdr/`hc`-delivered first prompt, arrives as `composer`. If it does not, the mod would not pick for that prompt, but any held override would still apply.
- Whether `$.config.set` succeeds, which would persist a new effort into user settings and alter the User's `effortLevel: xhigh` across sessions, or is refused, which leaves the per-request override, needs a live check that this research did not run.
- Session-retrieval note: as a research subagent, I read INDEX, #009 and #074. I did not run the `harness_check.py --quick` alignment check, the layers, the persona or the project-constraints steps, because the task was read-only external research.
