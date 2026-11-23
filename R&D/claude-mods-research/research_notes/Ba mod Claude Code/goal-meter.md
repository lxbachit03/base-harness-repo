# goal-meter (nateherkai/claude-code-mods): what it does, how its code works, install, maturity, risks, and fit with base-harness-repo

Scope and method: every file in `goal-meter/` was downloaded as data (not run) from commit `33a936f`, the repo's only commit, into the scratchpad folder `mods/goal-meter-clone`. Line numbers refer to that commit. GitHub metadata comes from the public REST API on 2026-11-23. Short names used below: R = `goal-meter/hooks/register.mjs`, P = `goal-meter/hooks/plan.mjs`. Base URL: `https://github.com/nateherkai/claude-code-mods/blob/main/`.

## What does it do for the user (what they see, and when)?

### Takeaway
goal-meter is a progress display for Claude Code's built-in `/goal` command. Its own MCP-style task tool makes Claude write a plan of tasks sized S, M or L and mark each one started and done. The mod then draws a weighted progress bar with an ETA above the prompt, adds a footer label, and offers a `/goals` pane that also lists goals from other chats. The mod does not score progress with a model: the numbers come only from the task list Claude reports.

### Cited Findings
- The marketplace description reads: "A progress bar for /goal built from Claude's own task plan: tasks done out of the plan, elapsed time, an ETA at the goal's own pace, and every chat's goal in /goals". — [.claude-plugin/marketplace.json](https://github.com/nateherkai/claude-code-mods/blob/main/.claude-plugin/marketplace.json)
- What the README describes:
  - **Trigger and plan.** The user types `/goal <what done looks like>`. Claude "first writes its plan with the goal meter's task tool", then marks each task.
  - **Band above the prompt.** It shows text like `5 of 8 tasks · 69%`, a bar, elapsed time, the ETA, "plan grew 7 → 8", how many agents are running, the last tasks done, the running task, the next tasks, and the latest "not met yet" reason from the goal check. Pressing `g` opens the full list.
  - **Footer.** It shows `◎ goal 69% · ~17m`.
  - **`/goals`.** It lists this chat's tasks plus every other chat's goal from the last 12 hours. `/goals hide|show`, `/goals strict on` and `/goals clear` change its behaviour.

  — [README.md#goal-meter](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#goal-meter)
- The README says it "sends no extra requests to Claude", and that "A plan Claude makes without `/goal` shows the same way". — [README.md](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#goal-meter)
- The header comment explains why the mod ships its own tool: "Claude Code stopped shipping a task-list tool after 2.1.229, so the mod brings its own". This is the author's claim and was not verified here. — [R L1-L13](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L1-L13)
- **How the percentage is computed.** S, M and L tasks weigh 1, 2 and 3. Dropped and replaced tasks do not count. pct = round(100 × done weight / total weight). — [P L5, L51-L74](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L51-L74)
- **How the ETA is computed.** ETA = (time since the plan was written ÷ finished weight) × remaining weight. No ETA is shown until 2 tasks are done or while the goal is not running. — [P L76-L85](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L76-L85)
- **When a goal ends.**
  - The goal check (Claude Code's own `/goal` evaluator) writes a `goal_status` verdict, and the mod reads it.
  - A turn ends with reason `answer`, it was not aborted, and every task is done.
  - A goal closed on its tasks reopens if the goal loop continues within 5 minutes without a new prompt.
  - A finished goal stays on screen for 10 minutes.

  — [R L21-L23, L233, L305-L310, L381](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L216-L238)
- When a goal finishes, a toast reads "Goal done in Xm: <title>". — [R L150-L160](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L150-L160)
- The author's video "Claude Code Mods Are Game Changers. Set Up These 5 NOW." (Nate Herk, about 2026-10-02) demos the meter with a 4-task list, elapsed time, a percentage, and one view across sessions. This comes from a page run by AI agents, not the video itself. — [openclawdatabase.com](https://openclawdatabase.com/news/videos/2026-10-02-claude-code-mods-cache-clock-record-mode-collision-guard/)

### Inferences
- The progress shown is only as accurate as Claude's own bookkeeping. If Claude skips a `start` or `done` call, or sizes tasks badly, the bar and ETA are wrong. Nothing checks the work independently.
- The ETA has no prior estimate to start from. It is a linear rate on weights the model chose itself, so expect it to jump around early in a goal.

### Gaps
- Not verified here: whether Claude Code 2.1.330 still lacks a built-in task tool, which is the mod's premise, or whether `/goal` still writes `goal_status` attachment rows in the format the mod parses. The code itself calls that format "not documented" ([P L182-L183](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L182-L191)).

## How does it work (manifest, hooks, $ APIs, context injection, files, processes, network)?

### Takeaway
goal-meter is a single hooks module of about 640 lines. Three of its features matter most:
- **A deferred-capable task tool.** It registers `mcp__goal-meter__tasks`.
- **One hidden instruction per `/goal`.** It attaches the instruction to the `/goal` command's hidden `context`, which by design leaves the cached prompt prefix untouched.
- **A PowerShell or `tail` subprocess per goal check.** It reads the last 12 lines of the chat's transcript JSONL to find the verdict.

It writes one plain-text JSON file per chat under `~/.claude/mods-data/goal-meter/`. It makes no network calls and no `$.model` calls.

### Cited Findings
- **Files in the mod.**
  - `.claude-plugin/plugin.json`: name `goal-meter`, version `1.0.0`, author "Nate Herk", license MIT. It has no `userConfig`, no dependencies and no surface restrictions.
  - `hooks/hooks.json`: `{"description":"Goal Meter hooks module","modules":["./register.mjs"]}`.
  - `hooks/register.mjs` (24,911 B), `hooks/plan.mjs` (9,678 B), `hooks/fmt.mjs` (2,164 B) and `hooks/privacy.mjs` (16,890 B).
  - No skills, agents, commands folder or tests.

  — [repo tree](https://github.com/nateherkai/claude-code-mods/tree/main/goal-meter); [plugin.json](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/.claude-plugin/plugin.json); [hooks.json](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/hooks.json)
- **Shared helpers.** `fmt.mjs` and `privacy.mjs` are shared code copied into each mod by a `_dev/sync-shared.mjs` script, which is not in the public repo. `privacy.mjs` is pure functions with no mod API calls. It masks secrets, names and figures when the sibling recording-mode flag is on. — [fmt.mjs L1](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/fmt.mjs#L1); [privacy.mjs L1-L3](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/privacy.mjs#L1-L3)
- **Events hooked** (`register(on)`, R L240-L443):
  - `session.start` (L241-L266): reads `USERPROFILE` or `HOME`, the session id and the cwd. It builds the transcript path `~/.claude/projects/<cwd with non-alphanumerics as '-'>/<session>.jsonl`, loads settings from `$.store`, calls `$.tool.register(TOOL_SPEC)` and `$.command.register('goals')` (falling back to `goal-meter`), and restores a saved goal less than 24 h old. It starts two timers: one every 15 s to re-render (and reload other chats while the pane is open), and one every 10 s to re-read `~/.claude/mods-data/recording.json`.
  - `command.run {command:'goal'}` (L270-L283): after core runs `/goal`, it starts the meter. It returns `context: [...notes, instruction(toolName)]`, so the plan request rides as a hidden user note. Stop words (`clear|stop|off|cancel|end|none|reset`) stop the meter instead (P L7-L11).
  - `prompt.submit` (L287-L291) and `turn.start` (L293-L316) form a fallback for when `/goal` arrives without `command.run`. In that case it appends the instruction with `$.session.append({type:'user', ...})`.
  - `classic.Stop` (L319-L322): takes the real `transcript_path` from the settings-hook event.
  - `tool.call` (L324-L340):
    - It serves its own tool.
    - In a running `/goal` with no plan yet, main thread only: strict mode denies `Edit/Write/NotebookEdit/MultiEdit` with a "plan first" message. After 4 non-ToolSearch tool calls it appends a one-time nudge.
  - `agent.spawn` (L342-L350) and `turn.complete` (L366-L386): count running subagents and close or save the goal.
  - `session.append {door:'attachment'}` (L353-L364): spots the `goal_status` row and calls `onCheck`.
  - `command.run {command:['goals','goal-meter']}` (L388-L412): sets strict, hide/show and clear, or opens the pane. Without a surface it returns plain text.
  - `ui.close` (L414-L417).
  - Three `ui.render` hooks: `AbovePrompt` (the band, L419-L427, skipped when a survey shows), `SessionMode` (the footer label, L430-L435), and `Pane` with id `goal-meter` (L437-L442).

  — [R L240-L443](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L240-L443)
- **$ APIs used.** A static scan found 22 distinct calls:
  - `$.clock`: `after`, `every`, `now`
  - `$.command.register`
  - `$.env.get`
  - `$.fs`: `exists`, `list`, `read`, `write`
  - `$.process.run`
  - `$.session`: `append`, `cwd`, `id`, `surface`
  - `$.store`: `get`, `set`
  - `$.tool.register`
  - `$.ui`: `invalidate`, `log`, `open`, `resolve`, `toast`

  The catalogue grades it L2 ("writes or runs") and says it passed `claude plugin validate`, from a static scan only. A grep of all four files finds no `fetch`, `http`, `$.model` or `$.prompt`. — [mods.aidojo.si goal-meter page](https://mods.aidojo.si/mods/nateherkai--claude-code-mods--goal-meter/); [R L1-L13](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L1-L13)
- **No model calls.** The header says "The mod sends no model requests of its own". The code agrees: it has no `$.model` usage, so there is no scoring model and no added model cost beyond the tool calls Claude makes in its own turns. — [R L13](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L13)
- **Subprocess.** `lastGoalStatus()` runs `powershell.exe -NoProfile -NonInteractive -Command "Get-Content -LiteralPath '<path>' -Tail 12 -Encoding UTF8"` on Windows (single quotes doubled), or `tail -n 12 <path>` elsewhere. The timeout is 15 s, and it reads only lines that contain `"goal_status"`. It runs on each goal-check row and retries up to twice, after 1.5 s and 4 s. Per the local type file, `$.process.run` runs "as the user the session runs as. CLI only". — [R L181-L238](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L181-L238); local `plugin-authoring/types/claude-code.d.ts` around L4285-L4310
- **Files written.** Each change writes `~/.claude/mods-data/goal-meter/<sessionId>.json`. It holds the whole goal object: the condition (up to 2,000 chars), the title, the cwd plus a `label`, and the tasks with titles, notes and the `by` agent name. Files from other chats less than 12 h old are read for `/goals`. Settings persist through `$.store`. The code never deletes a file; it only marks goals stopped. — [R L47-L100](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L47-L100); [P L18-L39](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L18-L39)
- **Text that reaches the model.** All sizes below are character counts measured on the downloaded source, with tokens estimated at about 4 chars per token.
  - **Tool definition `TOOL_SPEC`** (P L193-L224): about 1.6 KB of JS source, roughly 350-400 tokens, present whenever the tool is loaded. The instruction itself says "load it with ToolSearch if it is deferred", which suggests it may sit deferred until used.
  - **Plan instruction** (P L226-L234): about 600 chars, roughly 150 tokens, once per `/goal`, as a hidden `command.run` context note.
  - **Nudge** (P L236-L238): about 250 chars, roughly 60 tokens, at most once per goal.
  - **Strict deny message:** about 120 chars when triggered.
  - **Tool results:** each call returns `listText`, the whole plan at one line per task (P L125-L134, L179). A goal of N tasks needs about 2N+1 calls (plan, then start and done for each task), so result text grows about O(N²). For example, 8 tasks means about 17 calls of about 100-200 tokens each.
  - Nothing is injected into the system prompt or on every turn.

  — [P L193-L242](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L193-L242)
- **The hidden note keeps the prompt cache intact.** The code comment says "The ask rides as the command's hidden note, so the cached prefix is untouched". The local type file defines `command.run` `context` as notes the model reads "and the person never sees, each entry one hidden user message". — [R L268-L283](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L268-L283); local `claude-code.d.ts` around L2250-L2262
- **Known defect (issue #1, open, no reply).** The fallback instruction (`turn.start`) and the nudge (`tool.call`) append `{type:'user'}` rows without `isMeta`. Claude Code 2.1.287 refuses these: "a user row that is not isMeta (a plugin appends a user-role isMeta row or a system notice ...)". The empty `catch {}` hides the refusal. `nudged = true` is set before the append, so a refused nudge is never retried. The reporter notes that "the `claude-code/testing` kit does not apply this rule, so the mod's tests pass either way". — [issue #1](https://github.com/nateherkai/claude-code-mods/issues/1); code at [R L298-L302, L329-L337](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L324-L340)
- **Surfaces.** The README says it works "in the terminal and in the Desktop app's Code tab". `/goals` falls back to plain text when `$.session.surface()` is empty (R L407-L408). `$.process.run`, which the goal-check reader needs, is "CLI only" per the type file. — [README](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#requirements); [R L406-L411](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L406-L411)
- **Tests.** `plan.mjs` says it is pure "so the harness tests can drive them directly", but no test files are published (see the repo tree). — [P L1-L3](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L1-L3)

### Inferences
- **The main path works; the fallbacks are silent.** The plan request through `command.run` context is the main path and should work. The `prompt.submit` → `turn.start` fallback and the nudge are dead code on 2.1.287+ until issue #1 is fixed. If `/goal` arrives without `command.run`, Claude never gets the plan request, and the band stays on "Waiting for Claude's task plan…" or "reminded Claude", which is misleading because the nudge was refused.
- **Strict mode is the only real enforcement**, and only before the first plan exists. After that, Claude can skip updates with no consequence.
- **Goal-check detection is fragile.** It relies on an undocumented transcript schema (`attachment.type === 'goal_status'`), on a path derived from cwd (until a `classic.Stop` settings hook reveals the real one), and on PowerShell being available. On a non-CLI surface `$.process.run` is unavailable, so the goal can close only "on tasks".
- **Per-goal context cost is small but not zero.** It is roughly 2-5k tokens of tool calls and results for a typical 8-12 task goal, against no per-turn overhead.

### Gaps
- No runtime test was done, per the constraints, so the actual token counts, deferred-tool behaviour and goal-check parsing were not observed.
- Whether the `tool.call` hook's `e.action`, `e.tasks` and similar fields map to the tool input as written was checked against the code only, not at runtime.

## How does it install (marketplace, command, scopes, requirements)?

### Takeaway
You add the repo as the marketplace `nateherk-mods`, then run `claude plugin install goal-meter@nateherk-mods`. It needs Claude Code 2.1.287 or later with mods enabled for the account. It loads only in a new chat.

### Cited Findings
- `marketplace.json`: name `nateherk-mods`, owner "Nate Herk", four plugins, goal-meter at `./goal-meter`. — [marketplace.json](https://github.com/nateherkai/claude-code-mods/blob/main/.claude-plugin/marketplace.json)
- The commands are `claude plugin marketplace add nateherkai/claude-code-mods`, then `claude plugin install goal-meter@nateherk-mods`, then open a new chat. "`/reload-plugins` does not reload it". Installs are copies. To update, run `claude plugin marketplace update nateherk-mods` and then `claude plugin update goal-meter@nateherk-mods`. To remove, run `claude plugin uninstall goal-meter@nateherk-mods`. — [README#install](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#install)
- The requirements are Claude Code 2.1.287 or later and "Mods turned on for your account". Running `claude plugin test` prints "no hooks module to load" when mods can load, and "served off" when they cannot. — [README#requirements](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#requirements)
- An identical copy exists in `inematds/5-mods`: SHA-1 hashes of `register.mjs`, `plan.mjs`, `privacy.mjs` and `fmt.mjs` match the original. That repo was created 2026-10-05, has 0 stars, and adds a fifth "next-steps" mod plus Portuguese and Spanish docs. — [inematds/5-mods](https://github.com/inematds/5-mods); [issue #3](https://github.com/nateherkai/claude-code-mods/issues/3)

### Inferences
- The README does not mention install scope (user, project or local). The default `claude plugin install` scope applies.
- Because installs are copies, pinning to the reviewed commit `33a936f` is effectively automatic until someone runs an update.

### Gaps
- The install scope flags and their behaviour for this marketplace were not verified, because nothing was installed.

## How mature and trustworthy is it?

### Takeaway
It is a young single-commit drop (2026-10-02) from a popular AI-automation YouTuber, with moderate traction: 148 stars and 18 forks. It has no releases, no published tests, a single contributor, and 5 open issues with no author replies, one of them a real goal-meter bug. The code is readable and has no network calls, but it is unmaintained so far.

### Cited Findings
- **Repo metadata.**
  - 148 stars, 18 forks (the forks endpoint lists 19), 1 watcher, 5 open issues.
  - Created and pushed 2026-10-02T20:43Z.
  - MIT license, size 54 KB, 0 releases.
  - Contributors: `nateherkai`, 1 commit.

  — [GitHub API repos/nateherkai/claude-code-mods](https://api.github.com/repos/nateherkai/claude-code-mods)
- **Commits.** There is only one: `33a936f`, 2026-10-02T20:42:44Z, "Four Claude Code mods: Cache Keeper, Recording Mode, Goal Meter, Collision Guard". It is also the only commit for `path=goal-meter`. — [commits API](https://api.github.com/repos/nateherkai/claude-code-mods/commits?path=goal-meter)
- **Issues.** All are open with 0 comments, and there are no PRs:
  - #1 goal-meter `isMeta` bug (2026-10-05)
  - #2 Recording Mode listed on statuslin.es
  - #3 the catalogue maintainer notes copies in `inematds/5-mods`
  - #4 a cache-keeper SessionStart issue
  - #5 a cache-keeper countdown issue

  — [issues](https://github.com/nateherkai/claude-code-mods/issues?q=is%3Aissue)
- **Author.** The `nateherkai` account was created 2026-01-09 and has 2,563 followers and 18 public repos. It lists no bio or blog. — [users/nateherkai](https://api.github.com/users/nateherkai)
- **Coverage.** The video "Claude Code Mods Are Game Changers. Set Up These 5 NOW." is summarized on an aggregator run by AI agents. That page warns that each mod "runs code inside Claude Code, so you should read one before enabling it". — [openclawdatabase.com](https://openclawdatabase.com/news/videos/2026-10-02-claude-code-mods-cache-clock-record-mode-collision-guard/)
- **Catalogue listing.** The mod appears on awesome-claude-code-mods (mods.aidojo.si) as L2, from a static scan, with the note "Access levels are not safety ratings". — [mods.aidojo.si](https://mods.aidojo.si/mods/nateherkai--claude-code-mods--goal-meter/)
- **Forks.** All 18 forks inspected have 0 stars, and 17 of them still have the original push time, meaning no new commits. — [forks API](https://api.github.com/repos/nateherkai/claude-code-mods/forks)
- **The other mods in the repo.**
  - **cache-keeper:** a cache warm/cold band, `/keepwarm` pings (small model requests), a guard before a cold send, `/board` for all chats, and `/handoff` with a bundled skill.
  - **recording-mode:** `/rec` masks keys, personal data and business figures on screen and blocks private files.
  - **collision-guard:** asks before editing a file another chat changed in the last 30 minutes (Proceed, Worktree or Cancel).

  — [README](https://github.com/nateherkai/claude-code-mods/blob/main/README.md); [marketplace.json](https://github.com/nateherkai/claude-code-mods/blob/main/.claude-plugin/marketplace.json)

### Inferences
- **It is a demo-grade release.** One commit, no tests published, a silent-catch bug left for 7 weeks, and no responses to issues all point that way. Treat it as a reference implementation more than a maintained dependency.
- **No malicious behaviour found.** No suspicious fork or copy shows code changes in goal-meter, since the inematds copy is byte-identical. A copy remains a supply-chain vector if someone installs from it instead of the original.

### Gaps
- No independent review of goal-meter specifically was found, and no author blog post either. Web search returned other `/goal` tools (claude-goal, goalify) but nothing on this mod beyond the video aggregator ([search coverage](https://towardsdatascience.com/claude-code-mods-custom-hooks-to-fix-my-biggest-ai-coding-frustrations/) describes different mods such as plan-meter and done-gate by another author).

## What are the security and privacy risks?

### Takeaway
The risks are low to moderate and local:
- The goal text, task titles and cwd are stored in plain text, and they are visible across projects in `/goals`.
- A shell process (PowerShell or `tail`) runs on transcript paths.
- A hidden instruction changes Claude's behaviour during goals, and strict mode can deny edits.
- Files accumulate with no cleanup.

It sends nothing over the network, and it makes no model calls.

### Cited Findings
- **Plain-text persistence.** The goal condition (up to 2,000 chars), task titles and notes, the cwd and the label are written to `~/.claude/mods-data/goal-meter/<session>.json` on every change, and nothing ever deletes them. — [R L59-L67](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L59-L67); [P L18-L39](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/plan.mjs#L18-L39)
- **Cross-chat exposure.** `/goals` reads every other session's file from the last 12 h, from any project, and draws up to 15 rows showing project label, title and progress. Text is masked only when `~/.claude/mods-data/recording.json` is on. — [R L80-L114, L621-L625](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L80-L114)
- **Process execution.** The mod spawns `powershell.exe -Command` with a path inside single quotes (`'` doubled), or `tail`. The path comes from `USERPROFILE` plus the cwd, or from a settings-hook `transcript_path`. It reads at most the last 12 transcript lines. — [R L184-L197](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L184-L197)
- **Behaviour steering.** The hidden instruction tells Claude to plan with the tool "Before you start the work" (P L226-L234). Strict mode returns `deny` on Edit and similar tools before a plan exists (R L327, P L240-L242). These are user-visible settings, and strict is off by default (R L34).
- **Network.** "The mods make no network calls of their own" (README), which matches a grep that found no fetch or http in the goal-meter files. — [README#where-the-data-lives](https://github.com/nateherkai/claude-code-mods/blob/main/README.md#where-the-data-lives)

### Inferences
- **Command execution: low risk.** Injecting a command through the PowerShell string would need a malicious cwd or `transcript_path` that contains a quote, and the quote escaping handles that case for single-quoted strings. Building the command through `-Command` rather than an argv form is still a code smell.
- **Privacy: mainly on screen and on disk.** Goal text that contains client names or secrets ends up in a durable plain-text file and on screen in other projects' `/goals` panes, for example during screen sharing without recording-mode.
- **Silent failures.** Empty `catch` blocks (issue #1) hide failures, so the user cannot tell whether Claude received the instruction.
- **Mitigation if used.** Install from the original repo at `33a936f`, keep strict off unless you want it, clear the `mods-data/goal-meter` folder now and then, and apply the issue #1 fix (`isMeta: true`) in a local fork.

### Gaps
- Not checked: how Claude Code sandboxes or permission-gates `$.process.run` and `$.fs.write` for a plugin, and whether the user is prompted.

## How would it fit base-harness-repo (duplicate, complement, or conflict)?

### Takeaway
goal-meter mostly complements the Harness:
- **goal-griller** shapes a `/goal` prompt, and goal-meter only displays progress after the goal is set.
- **ticket-DoD** tracks what the User owes; goal-meter tracks the agent's own ephemeral task progress.

It adds no session-start reads and so does not touch the #064 budget. It is Claude-Code-only, however, while the Harness targets Codex, AGY and OpenCode too. Installing it is a dependency installation that needs specific User authority under #009. The overlap is that its forced plan, its strict gate and the hidden instruction add another planning layer next to the Harness's own planning skills.

### Cited Findings
- **#009 task authority.** "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority". It also says "a draft goal does not start autonomous goal state". — [0822-user-authority-operation-gate.md](file:///E:/personal/base-harness-repo/docs-harness/harness-constraints/0822-user-authority-operation-gate.md)
- **#064 budget.** "The files every session must read at start total at most 33,400 normalized bytes". The measured total was 32,531, and a later record measured 32,799. — [1115-session-start-context-cut.md L27, L140-L148](file:///E:/personal/base-harness-repo/docs-harness/harness-improvements/1115-session-start-context-cut.md); [1115-folder-readmes.md L104](file:///E:/personal/base-harness-repo/docs-harness/harness-improvements/1115-folder-readmes.md)
- **#094 code-graph precedent.**
  - The record keeps "the Harness in charge of agent instructions: no third-party installer writes `AGENTS.md`, rules or hooks".
  - It requires the User's authority for third-party installs.
  - It writes the capability into the Harness first and pilots later "khi có user authority" (Vietnamese for "when there is user authority").

  — [1123-code-graph-skill.md](file:///E:/personal/base-harness-repo/docs-harness/harness-improvements/1123-code-graph-skill.md)
- **Claude settings in the repo.** The repo has no project `.claude/settings.json`. Only `.claude/settings.local.json` exists, holding `skillOverrides` and no hooks or statusLine. The user-level `~/.claude/settings.json` holds hooks (SessionStart, Stop, PreToolUse, all through an Orca agent hook) and a `statusLine` entry. — local files `E:\personal\base-harness-repo\.claude\settings.local.json`, `~/.claude/settings.json` (checked with grep only)
- **Ticket DoD.** Every ticket gets a `ticket-DoD.md` file: "the single list of questions the User must answer and actions the User must take before the ticket can be resolved". Each item is triaged as required or optional. — [tickets/README.md L57-L75](file:///E:/personal/base-harness-repo/docs-harness/tickets/README.md); [templates/ticket-DoD.md](file:///E:/personal/base-harness-repo/docs-harness/templates/ticket-DoD.md)
- **goal-griller.**
  - Its description: "Turn vague ideas into verifiable Codex goals".
  - It requires six fields, including a success condition and stop rules, before it drafts a `/goal` prompt.
  - It does not invoke `/goal` unless the User asked and confirmed the draft (L148-L150).
  - It mentions a general "Goal Guard" `PreToolUse` hook that may block `/goal` (L154). That hook is not found elsewhere in `docs-harness`.
  - The skill is mirrored in `.agents/skills/goal-griller/` and `.claude/skills/goal-griller/`.

  — [SKILL.md](file:///E:/personal/base-harness-repo/.agents/skills/goal-griller/SKILL.md)
- **How goal-meter could hook into the existing setup.**
  - It listens to `classic.Stop` to learn the transcript path, which "reaches a `*` or `classic.*` hook" only when a settings hook is configured. The user's global Stop hook would supply that path.
  - It draws in the `AbovePrompt` band and the `SessionMode` footer, not in `statusLine`, so it should not clash with the existing statusLine.

  — [R L318-L322, L419-L435](https://github.com/nateherkai/claude-code-mods/blob/main/goal-meter/hooks/register.mjs#L318-L322); local `claude-code.d.ts` L1639-L1645

### Inferences
- **Complement: goal-griller → goal-meter.** goal-griller turns intent into a `/goal` with a success condition. goal-meter then shows plan progress and the goal check's "not met yet" reason. Their gates do not conflict: goal-griller acts before `/goal`, and goal-meter after it. goal-griller is worded for Codex, so a Claude Code user running its output through `/goal` would get the meter.
- **Partial overlap with Harness planning.**
  - The hidden instruction makes Claude produce an S/M/L plan before work. That can duplicate a plan already made with `$sequence-execution-plan`, or the Purposes checkboxes in improvement records.
  - The meter's plan is ephemeral (24 h restore, under `~/.claude`, outside the repo), so it does not compete with the durable `plans/` or tickets as a record.
  - In strict mode it could deny edits during Harness session-start work that happens inside a `/goal` before a plan exists.
- **Not a ticket-DoD substitute.** DoD items are User-owed questions and actions with required or optional triage, resolved in the repo. goal-meter tracks agent tasks only, and nothing maps between the two.
- **Context budget.** The mod adds no session-start reads, so #064's 33,400-byte budget is unaffected. Each goal costs roughly 2-5k tokens of tool traffic, plus possibly about 400 tokens of tool schema if the tool is not deferred.
- **Multi-agent (Herdr/Orca) use.** `/goals` shows goals from every chat in the last 12 h on one machine. That could help a coordinator watch workers, but it also mixes in other projects.
- **Adoption path consistent with #094.** Treat it as an opt-in, User-authorized install at user scope. Do not vendor it into the Harness and do not let it write Harness instructions. Record the decision as an improvement record or a tool catalog entry if the User wants it. Note issue #1 and the Claude-only scope.

### Gaps
- Not observed at runtime: how the meter's hidden instruction interacts with the Harness's mandatory session-start retrieval, or with the Orca PreToolUse hook.
- "Goal Guard", referenced by goal-griller, could not be located in the repo, so its interaction with goal-meter's strict deny cannot be assessed.
