# Ponytail upstream verification

- Subject: <https://github.com/DietrichGebert/ponytail>
- Checks: `R&D/ponytail-deep-research.md` (written 2026-11-22, in Vietnamese)
- Verified: 2026-11-23
- Pinned commit: `ebd8654c2c627f721eb8f9c0d1bd4090a29f9e10` (main, 2026-11-22T02:31:58Z)
- How: GitHub REST API (`api.github.com`), raw files from `raw.githubusercontent.com` at that commit (fetched with curl and read in full), the npm registry, the HN Algolia API, and WebFetch/WebSearch for third-party pages. The verbatim core rules are in [upstream-rules.md](upstream-rules.md).

Legend: **confirmed** / **wrong** (with the correct value) / **imprecise** (the substance holds but a detail is off) / **could not verify**.

## 1. Key facts

| Claim in the write-up | Verdict | Observed value and source |
|---|---|---|
| 196.7k stars, 11.1k forks, 455 watching | confirmed (drift) | API: 197,081 stars, 11,124 forks, 456 subscribers (`/repos/DietrichGebert/ponytail`) |
| 145 open issues, 170 open PRs, 129 contributors | confirmed (drift) | 146 open issues, 173 open PRs (search API; `open_issues_count`=319 counts both), 133 contributors (API pagination) |
| Languages JS 49.5 / Py 25.2 / TS 25.1 | confirmed | `/languages`: JS 309,843 B, Python 157,958, TS 157,343, plus PowerShell 885 and Shell 696 |
| MIT license | confirmed | `LICENSE`: "MIT License, Copyright (c) 2026 DietrichGebert"; the API reports `spdx_id: MIT` |
| Latest release v5.3.3, 2026-10-29, 30 releases | confirmed | `/releases`: v5.3.3 published 2026-10-29T03:11:08Z; 30 releases (pagination). The tag commit `7801d06` was not checked |
| Latest main commit `ebd8654` 2026-11-22, #1495 by Afloat16 | confirmed (I did not check the author) | `/commits/main` |
| Recent commits `affbac1`, `dec89d9` | confirmed | `affbac1` 2026-11-22 (#1461); `dec89d9` 2026-11-21 (#1537) |
| Homepage ponytail.dev | confirmed | API `homepage` |
| npm `@dietrichgebert/ponytail` 5.3.3, 0 runtime deps | confirmed | registry: `dist-tags.latest`=5.3.3, published 2026-10-29T03:08:20Z, `dependencies` and `devDependencies` are both absent, license MIT |
| `package.json` main/exports point to `.opencode/plugins/ponytail.mjs`, `pi` block, test script | confirmed | `package.json`. `files` publishes `AGENTS.md`, `hooks/`, `skills/`, `.opencode/`, `.qoder/`, `.qoder-plugin/`, `pi-extension/`, `scripts/uninstall.js`, `scripts/cursor-hooks.js` and `LICENSE` |
| 6 skills: ponytail, -review, -audit, -debt, -gain, -help | confirmed | `skills/*/SKILL.md` (6 folders) plus `skills/plugin.json` |
| Folder layout (root files, adapters, rule copies, hooks, band, scripts, 23 tests, 11 examples, docs) | confirmed | git tree (recursive, not truncated). `tests/` has 23 files; `examples/` has README plus 11 files; `docs/` has `agent-portability.md` and `cursor-hooks.md`. The `.github/plugin/{plugin,marketplace}.json` Copilot CLI manifests also exist |
| `.claude-plugin/plugin.json` registers `claude-codex-hooks.json`, `claude-band.json` and types `band/types.d.ts` | confirmed | the file itself |
| `userConfig`: `ledger` (bool, true), `webhookUrl` ("" default), `webhookToken` (sensitive, keychain), `sendNames` (bool, true) | confirmed | `.claude-plugin/plugin.json`. `webhookToken` has `"sensitive": true` and the description "Kept in the system keychain". The `webhookUrl` description says "Empty: nothing leaves this machine." |
| `.codex-plugin/plugin.json` → `skills: ./skills/`, `hooks: ./hooks/claude-codex-hooks.json` | confirmed | it also has `interface.capabilities: ["Instructions","Lifecycle hooks"]` |
| `commands/*.toml` for Gemini/Qwen/Antigravity | confirmed (6 files) | `commands/ponytail{,-audit,-debt,-gain,-help,-review}.toml`. Each is a `description` plus a `prompt` string, a short inline restatement of the rules. Antigravity turns these commands into skills (INSTALL.md) |
| `.agents/rules/ponytail.md` byte-identical to AGENTS.md | imprecise | It is AGENTS.md minus the final repo-specific line ("Yes, this file also applies to agents working on the ponytail repo itself..."): 2,623 B vs 2,721 B. `check-rule-copies.js` compares after this normalisation |
| `gemini-extension.json` `contextFileName: AGENTS.md`; `opencode.json` is only `$schema` | confirmed | both files |
| Hook events: `SessionStart` (`startup\|resume\|clear\|compact`), `UserPromptSubmit`, `SubagentStart` | confirmed | `hooks/claude-codex-hooks.json`: each runs `node -e require(<CLAUDE_PLUGIN_ROOT>/hooks/<x>.js)` with a 15 s timeout |
| `claude-band.json` | confirmed, detail added | it contains `{"hooks":{}, "modules":["./band/register.tsx"]}`, a Claude Code UI module, not a hook |
| Band in the `AbovePrompt` slot, needs Claude Code 2.1.290+, not shown in VS Code panel, cloud or `claude -p` | confirmed | `register.tsx` `on('ui.render',{component:'AbovePrompt'})`; README line 130 |
| Band data in `~/.config/ponytail/band/<project>.csv` (RFC 4180), plus an offline `board.html` | confirmed, with a Windows caveat | `ledgerDir` = `$XDG_CONFIG_HOME` or `~/.config` + `/ponytail/band`. The source comment says: "shortcut: ~/.config only (XDG respected); Windows would want %APPDATA%". So on Windows the ledger goes to `%USERPROFILE%\.config\ponytail\band\`, while `config.json` goes to `%APPDATA%\ponytail\`. `board.html` is written into the same folder |
| CSV columns | added | `key,started,project,name,cost_usd,turns,agent_minutes,tokens_total,tokens_output,reuse_pct,reused,new,callers_open,tests,level,model` (`metrics.ts` `CSV_HEADER`) |
| `/ponytail band import` backfills from old transcripts | confirmed | `mode-tracker.js` spawns `ponytail-band-import.js` detached. It reads `~/.claude/projects/**/*.jsonl` (subagent transcripts too), estimates cost from a hard-coded price table, and merges rows into the ledger CSV |
| `SKILL.md` 3,495 B, `AGENTS.md` 2,720 B | imprecise (off by 1) | 3,496 B and 2,721 B at the pinned commit (raw bytes; the difference is probably the trailing newline) |
| AGENTS.md "drops frontmatter and the Levels table" | imprecise | It also drops the "Active for the whole session until... `/ponytail lite\|full\|ultra`" line, and it uses a different H1 and adds a closing repo line. The rule body is otherwise identical |
| `filterSkillBodyForMode` keeps `- mode: "..."` examples | imprecise (dormant) | The code supports it, but the current SKILL.md has no worked-example lines. In practice the filter only removes the two inactive rows of the Levels table |
| Symbol map: 3 s timeout, 2,000-char budget, `git ls-files` + regex, shared dirs first | confirmed | `ponytail-map.js`: `BUDGET = PONYTAIL_MAP_CHARS \|\| 2000`, MAX_FILES 4000, reads at most 64 KiB per file; `activate.js` runs it with `timeout: 3000, maxBuffer: 64*1024`. `PONYTAIL_MAP=0` turns it off. The SHARED regex also covers `common, shared, core, model, schema, api` |
| CI checks 7 manifests' versions | could not verify (did not read `check-versions.js`) | `.github/plugin/plugin.json` exists, so the list is plausible |
| `ponytail-review` order: correctness → security → load → tests → speed → bloat | confirmed | "Order of importance: correct, safe, holds under load, tested, fast, lean." |

## 2. Core rules and the review/audit skills

The verbatim `skills/ponytail/SKILL.md` and `AGENTS.md` are saved, with the license line and the source commit, in [upstream-rules.md](upstream-rules.md).

**`ponytail-review` (5,143 B).** A read-only quality review of a change. With no target it reviews the uncommitted changes, or the last commit if there are none. Steps:

1. Understand first: read the diff and the connected code (callers, callees, tests, README), trace the data flow, grep callers when a signature changes, and find the expected load in the repo.
2. Look for six categories: Bug, Risk (security and data loss), Scale (races, N+1, O(n²), state that only grows), Missing test, Speed, Lean (delete / reuse / stdlib / yagni / merge / split by job).
3. Check before reporting: every finding needs a concrete triggering case ("No case, no finding"), and the reviewer re-reads to confirm. A `shortcut:` comment that names its limit is a decision, not a finding. The proposed fix is the smallest one, preferring deletion. No style taste and no "consider".
4. Output in plain English: "What this change does:", then numbered findings in Must fix / Should fix / Nice to have. Each finding has four parts (What this is / Problem / Fix / If we skip it). It ends with `Verdict:`, `Lean: -N lines possible.` and `Not checked:`. It changes no code.

**`ponytail-audit` (5,417 B).** The same structure applied to a whole repo or a named folder:

- Map first: README, deploy and build config, the dependency list, entry points, tests, and the expected load. It traces the main flows end to end and goes deep where mistakes cost most, naming the parts it did not read.
- The six categories are the same as the review's.
- It adds a rule to grep the whole tree, including string and dynamic references, before calling code unused.
- It caps the report at 20 findings and says how many it left out.
- It ends with `Verdict:`, `Lean: -N lines, -M dependencies possible.` and `Not checked:`. It is a one-shot report and changes nothing.

## 3. Benchmarks

### Methodology (`benchmarks/results/2026-10-07-agentic.md`, `benchmarks/agentic/README.md`)

- **Agent and model:** headless `claude -p`, Opus 5.5 at default effort, Claude Code CLI 2.1.288. The plugin is loaded with `--plugin-dir`.
- **Arms:** three, run together: no skill, Ponytail v4.13.0, and Ponytail 5. The harness also has `caveman`, `yagni` and `yagni-oneliner` arms, but this report did not run them.
- **Tasks (39):**
  - 12 feature tickets on `fastapi/full-stack-fastapi-template@cd83fc1`, scored on `git diff`
  - 18 surgical tasks with hidden checks (bug fixes, refunds, SQL injection, path traversal, forged tokens, rate limit, a privacy case, renames that must reach every caller)
  - 6 "build me a small app" and 3 "show me an example" tasks
- **Runs:** 5 per task per arm, giving **585 sessions = 39 × 5 × 3 arms**. The write-up's "39 × 5 = 585" is wrong arithmetic: 39 × 5 is 195 sessions per arm.
- **Isolation:** each session runs in a fresh temp folder outside git, with CLAUDE.md loading and auto memory off. Bash is disabled (`--disallowedTools Bash`) and MCP is stripped (`--strict-mcp-config`). The agent only writes code; the harness runs the checks afterwards.
- **Statistics:** for each task, the median of the 5 runs divided by the baseline; the report gives the geometric mean of these ratios with a 95% bootstrap interval, plus sign tests.
- **Judges:**
  - Completeness: `complete.py`, Opus 5.5 as judge, blind, scored 0 to 3, with a self-test gate. It judged only the 21 tasks that are scored on size alone.
  - Replies: Sonnet 5.5, blind, order shuffled per pair.
  - Over-engineering: `judge.py` (fixed `claude-sonnet-4-6`, temperature 0) exists in the harness but is **not reported** in this results file. The write-up implies it was used.

### Numbers (Ponytail 5 vs no skill)

| Metric | Ponytail 5 vs no skill | 95% CI |
|---|---|---|
| Lines of code | -53% | [-63..-41] |
| gzip of delivered code | -41% | [-51..-30] |
| Output tokens | -45% | [-54..-35] |
| Cost | -26% | [-36..-16] |
| Time | -41% | [-49..-32] |
| Turns | -22% | not given |
| Cheaper on | 30 of 38 tasks | |

- Mean cost per session: $0.200 (no skill), $0.156 (v4.13), $0.142 (Ponytail 5).
- **Hidden checks (18 tasks):** 86/90 = 95.6% (no skill), 86/90 = 95.6% (v4.13), 87/90 = 96.7% (Ponytail 5). The report says itself: "Less code did not cost correctness or safety. It did not add any either." The write-up's "97% vs 96% for v4.13" should be read as 96.7% vs 95.6% for both other arms; the difference is one run out of 90.
- On the six safety tasks of the earlier safety tier, all arms passed 30/30.
- **Completeness:** 100/100 (no skill) vs 105/105 (Ponytail 5). One judge score of 1 was manually overridden to complete because of a missing import that the judge, seeing only the diff, could not see.
- **Tests:**
  - A test where the logic needs one: 98% (Ponytail 5) vs 68% (no skill). Confirmed.
  - Injected bugs caught over all cells: 66% vs 46%.
  - Injected bugs caught **where a test exists**: 69% (Ponytail 5) vs **77% (no skill)**. The no-skill tests are more thorough when they exist.
  - A test where none was needed: 45% vs 36%.
- **Reply quality vs no skill:** the blind judge preferred no-skill replies 106 to 82 (p=0.09); with both replies describing the same code, 118 to 99 (p=0.22). Not significant, and leaning against Ponytail. Against v4.13, Ponytail 5 clearly wins.

### Independent evaluations and critiques

1. **Colin Eberhardt (Scott Logic), "Ponytail? YAGNI!", 2026-06-16**, <https://blog.scottlogic.com/2026/06/16/ponytail-yagni-and-the-problem-with-prompt-benchmarks.html>; issue [#126](https://github.com/DietrichGebert/ponytail/issues/126). This was against the old promptfoo single-shot benchmark.
   - The chatty baseline inflated LOC. With "one example only", the baseline LOC went from 108 to 16; Ponytail scored 8.25; a seven-word "Follow YAGNI principles, and prefer one-liner solutions" prompt scored 6.9 (Haiku).
   - This critique triggered the agentic harness. In the author's 2026-06-18 agentic rerun the one-liner prompt was "erratic", and once in four runs it went unsafe on `safe-path` (19/20 safe).
2. **DocSpring (Nathan Broadbent), "Ponytail vs. a good AGENTS.md", 2026-11-13**, <https://docspring.com/blog/posts/ponytail-vs-agents-md/> (HN 50478165).
   - Setup: a Rails and React monorepo, 4 tasks × 2 runs × 2 arms (16 sessions), Opus 5.5, Ponytail 5.3.3 on top of the repo's own AGENTS.md.
   - Ponytail gave -56% source lines, -34% cost and -41% output tokens, **but blind-judge quality was 5.9 vs 6.8 and completeness 2.1 vs 2.4**. Both Ponytail runs missed a sign-up path; both left a failing test and made an untrue claim in their final reply.
   - DocSpring did not install Ponytail. It copied three of its ideas into its own AGENTS.md. The sample is small and the author says so.
3. **KuldeepB19 independent benchmark v3**, issue [#236](https://github.com/DietrichGebert/ponytail/issues/236), <https://github.com/KuldeepB19/ponytail-benchmark>.
   - Setup: 480 builds (24 jobs × 4 levels × 5 reps), Opus 4.8, the real plugin, graded by running the code.
   - Result: about 44% less code with no loss of correctness or security, **but a real robustness cost on the 5 jobs with unstated edge cases, and it gets worse at higher levels** (lite → full → ultra).
   - The project's GitHub Pages site returned 404 on 2026-11-23, so I took these figures from the issue text only.
4. **Issue [#685](https://github.com/DietrichGebert/ponytail/issues/685), token overhead (RoxsLee, Sonnet 5, v4-era).**
   - The resident ruleset is re-read on every API call, so its cost grows with each turn. Measured: +6.9% cost [+3.9, +10.0] vs a one-sentence "leave a runnable check" prompt, and +8–13% per turn with no break-even.
   - The maintainer closed it as won't-fix: "The resident ruleset is the product." The same decision was made for subagents in [#597](https://github.com/DietrichGebert/ponytail/issues/597).
5. **Other issues:**
   - [#660](https://github.com/DietrichGebert/ponytail/issues/660): "shortest diff" pushed policy into callers and increased complexity; the reporter proposes optimising for contained complexity. Closed.
   - [#121](https://github.com/DietrichGebert/ponytail/issues/121): a Cursor SDK A/B saw more tool calls and higher cost with Ponytail on.
   - [#1225](https://github.com/DietrichGebert/ponytail/issues/1225), open: context-retention loss on Antigravity CLI/Gemini with v5.3.2; anecdotal.
   - [#1316](https://github.com/DietrichGebert/ponytail/issues/1316), open: graders in the old single-shot benchmark pass replies with no code.
   - [#1171](https://github.com/DietrichGebert/ponytail/issues/1171), open: a production `_check()` helper is counted as a self-check.
6. **HN:** launch thread 48527946 (2026-06-14, 98 points, 17 comments). It is mostly jokes plus "the repo is bigger than the code it allows" and "it's just these rules plus plugin boilerplate"; no data. No substantive Reddit critique was found. I could not read the JetBrains blog (403) or the InfoQ article (405).

### What the SessionStart hook injects (Claude Code, default `full`)

1. `PONYTAIL MODE ACTIVE — level: full` followed by the SKILL.md body without frontmatter and without the lite/ultra table rows: **2,858 chars, 493 words, about 700 tokens** (computed with the hook's own filter logic).
2. The codebase map: a header plus one line per folder, capped at 2,000 chars, plus a "(N more folders not listed)" line. **About 500 tokens at most**; on Windows Git Bash paths and in non-source repos it can be empty.
3. On first run only, if `statusLine` is unset: a "STATUSLINE SETUP NEEDED" paragraph (about 100 tokens) telling the model to "Proactively offer to set this up".

That is **about 1.0–1.3k tokens per SessionStart**, re-sent on `startup`, `resume`, `clear` and `compact`. Every subagent also gets the same ~700-token ruleset (no map) via `SubagentStart`, unless `PONYTAIL_SUBAGENT_MATCHER` excludes it. The cost recurs on every API call as cached input (#685). Older issues cite ~2.8k tokens and 5,229 chars; those figures are for the v4 SKILL.md, which was longer.

Known side effect, [#1421](https://github.com/DietrichGebert/ponytail/issues/1421), open: native Claude SessionStart writes raw stdout, so sessions closed without a prompt are still saved and titled "PONYTAIL MODE ACTIVE…" in `--resume`.

## 4. Privacy and security

### What runs

Every hook is `node -e require(...)` on plugin JS files, with no npm dependencies. Child processes:

- `activate.js` runs `node ponytail-map.js`, which runs `git ls-files`.
- `register.tsx` (the band) runs `git grep --untracked -nE <defs>` and `git grep -nw <name>` to compute reuse and open callers.
- `band-import.js` runs `git rev-parse` and is spawned detached by `/ponytail band import`.
- The statusline is a bash or PowerShell script. The suggested Windows command is `powershell -ExecutionPolicy Bypass -File "<claudeDir>\ponytail-statusline.ps1"`, added only if the user accepts the nudge.

### What it writes to disk

| Path | Content |
|---|---|
| `~/.claude/.ponytail-active` | mode flag |
| `~/.claude/ponytail-modes/<sha256(project dir)>` | per-project mode |
| `~/.claude/ponytail-statusline.{sh,ps1}` | copy refreshed every session once the script exists |
| `~/.claude/.ponytail-statusline-nudged` | flag that the nudge was shown |
| `~/.claude/.ponytail-band` | "off" flag that hides the band |
| `~/.config/ponytail/config.json` (`%APPDATA%\ponytail\` on Windows) | default mode, written only by `/ponytail default` |
| `~/.config/ponytail/band/<project>.csv` and `board.html` | written after every turn when `ledger` is true, which is the default; on Windows also under `~/.config` |
| `~/.claude/settings.json` | only if the agent accepts the statusLine nudge |
| `PLUGIN_DATA`, `~/.cursor`, `~/.codebuddy`, `~/.qoder` | the same flag files, used instead of `~/.claude` on Codex, Cursor, CodeBuddy and Qoder |

- The ledger stores task names, which are the sidebar title or the first prompt line, 60 chars. The import reads all past transcripts to build them.
- `scripts/uninstall.js` removes the flags, `ponytail-modes/`, the nudge flag and the statusline entry. From the paths it references, it does **not** remove `~/.config/ponytail/band/`.

### Network

- The only outbound call is the optional band webhook: a POST of the task row as JSON after every turn, with a Bearer token if one is set.
- It is **off by default** (`webhookUrl: ""`). `webhookRequest` refuses anything that is not https, except plain http to localhost/127.0.0.1/[::1].
- `sendNames` defaults to **true**, so a user who enables the webhook also sends the first prompt line by default. Issue [#1312](https://github.com/DietrichGebert/ponytail/issues/1312) is open asking to flip this default.
- I found no telemetry or analytics code in the hooks I read (grep for fetch and http). `board.ts` references only SVG namespaces and data URIs, no CDN.

### Security history

- [#735](https://github.com/DietrichGebert/ponytail/issues/735): a **trojanized clone** `0xwilliamortiz/ponytail-improved` (v4.8.4) shipped a DLL side-load (a renamed signed `gup.exe` plus a malicious `libcurl.dll`, Defender `Trojan:Win64/DLLHijack.MK!MTB`) through a fake Claude Code marketplace. The account has been removed. README: install only from `DietrichGebert/ponytail` or `@dietrichgebert/ponytail`. Many forks and mirrors exist (claudepluginhub listings under other owners).
- [#1326](https://github.com/DietrichGebert/ponytail/issues/1326): a private vulnerability report was requested on 2026-10-31. The maintainer enabled private reporting on 2026-11-06. No published advisory (the `/security-advisories` API returned `[]`), and there is no SECURITY.md in the tree.
- Hardening present in the code:
  - `isShellSafe` keeps settings.json paths out of model context.
  - The statusline copy is written to a temp file and renamed, so it replaces a symlink instead of writing through it.
  - The subagent matcher regex runs under a `vm` timeout against ReDoS.
- Open: [#1311](https://github.com/DietrichGebert/ponytail/issues/1311), `cursorRuleNotice` puts a raw workspace path into context without the shell-safe guard.

## 5. Install paths

| Host | Command | Hooks? |
|---|---|---|
| Claude Code (CLI and Desktop Code tab) | `/plugin marketplace add DietrichGebert/ponytail`, then, as a **separate** prompt, `/plugin install ponytail@ponytail` | yes: SessionStart, UserPromptSubmit, SubagentStart, plus the band module |
| Codex (CLI and desktop) | `codex plugin marketplace add DietrichGebert/ponytail` then `codex plugin add ponytail@ponytail`; open `/hooks`, trust the two lifecycle hooks, start a new thread | yes |
| Antigravity CLI (agy) | `agy plugin install https://github.com/DietrichGebert/ponytail` (verified by the author with agy 1.3.3) | **no lifecycle hooks**. It installs the six skills, the commands become skills, and levels do not persist. For always-on rules, copy `AGENTS.md` into the project, which Antigravity reads as workspace rules |
| OpenCode | `opencode plugin add @dietrichgebert/ponytail` (OpenCode 2), or `{ "plugins": ["./.opencode/plugins"] }` in `opencode.json` (must be a directory); OpenCode 1 uses `{ "plugin": ["@dietrichgebert/ponytail"] }` | plugin injects the ruleset every turn; OpenCode also auto-loads `AGENTS.md` |
| Gemini CLI / Qwen | `gemini extensions install https://github.com/DietrichGebert/ponytail` | no hooks; `AGENTS.md` is the context file |
| Skills CLI | `npx skills add DietrichGebert/ponytail [--agent X] [--skill '*'] [--global]` | skills only |

**Rules without hooks: yes, officially supported.** INSTALL.md says: "Most agents read AGENTS.md: copy it into your project, or ask your agent to install skills/ponytail/SKILL.md as a skill." Rule-only installs give up the following:

- level switching and persistence (`/ponytail lite|ultra`, `stop ponytail`)
- the SessionStart codebase map
- subagent injection
- the band and statusline

Rule-only installs also write nothing to disk and make no network calls.

Trade-off between the two files:

- Copying `SKILL.md` alone gives an on-demand skill that loads only when triggered by its description ("Use on any coding task..."). Whether it is always applied then depends on how the host triggers skills.
- `AGENTS.md` is the always-on variant.

## Sources

- Repo and API: <https://github.com/DietrichGebert/ponytail>, <https://api.github.com/repos/DietrichGebert/ponytail>, `/commits/main`, `/releases`, `/languages`, `/git/trees/main?recursive=1`, `/search/issues`
- Raw files at `ebd8654`: `skills/ponytail/SKILL.md`, `AGENTS.md`, `skills/ponytail-review/SKILL.md`, `skills/ponytail-audit/SKILL.md`, `LICENSE`, `package.json`, `.claude-plugin/{plugin,marketplace}.json`, `.codex-plugin/plugin.json`, `hooks/{claude-codex-hooks,claude-band}.json`, `hooks/ponytail-{activate,map,runtime,config,instructions,mode-tracker,subagent,band-import}.js`, `hooks/band/{register.tsx,metrics.ts,board.ts}`, `INSTALL.md`, `README.md`, `scripts/uninstall.js`, `commands/ponytail.toml`, `.agents/rules/ponytail.md`, `benchmarks/results/{2026-10-07,2026-06-18}-agentic.md`, `benchmarks/agentic/README.md`
- npm: <https://registry.npmjs.org/@dietrichgebert%2fponytail>
- Issues: #126, #121, #236, #502, #597, #660, #685, #735, #1171, #1225, #1311, #1312, #1316, #1326, #1421 (each at `https://github.com/DietrichGebert/ponytail/issues/<n>`)
- Scott Logic: <https://blog.scottlogic.com/2026/06/16/ponytail-yagni-and-the-problem-with-prompt-benchmarks.html>
- DocSpring: <https://docspring.com/blog/posts/ponytail-vs-agents-md/>
- KuldeepB19: <https://github.com/KuldeepB19/ponytail-benchmark>
- HN: <https://news.ycombinator.com/item?id=48527946>, <https://news.ycombinator.com/item?id=50478165> (via <https://hn.algolia.com/api>)
- Not readable: <https://blog.jetbrains.com/ai/2026/07/ponytail-skill-claude-tested/> (403), <https://infoq.com/news/2026/08/ponytail-agent-skill-benchmark> (405), <https://kuldeepb19.github.io/ponytail-benchmark/> (404)
