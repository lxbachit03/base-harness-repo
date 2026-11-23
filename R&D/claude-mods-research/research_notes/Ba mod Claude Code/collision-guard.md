# collision-guard (nateherkai/claude-code-mods): what it does, how it works, risk, and fit with the Harness

Research date: 2026-11-23. Repo state read: single commit `33a936f` (2026-10-02), shallow clone in the session scratchpad, read only and never run. Line numbers below refer to that commit. Base URL for file citations: `https://github.com/nateherkai/claude-code-mods/blob/33a936f/` (shortened to `[file:Lx]`, using `blob/main/...` links).

## What does it do for the user (what they see, when)?

### Takeaway
Before Claude runs an `Edit`, `Write` or `NotebookEdit` call, collision-guard checks whether another open Claude Code chat on the same machine edited the same file in the last 30 minutes. If one did, it shows a blocking question dialog with three choices: Proceed, Move to a worktree, or Cancel. Otherwise it stays silent and adds nothing to the model's context. It warns and asks the person. It never blocks automatically, and an unattended `-p` run lets the edit through.

### Cited Findings
- The README says that with several chats in one project, two of them "can end up changing the same file without knowing it". It describes three options: Proceed (edit anyway), Move to a worktree (only when git tracks the file), and Cancel (Claude leaves the file alone and asks how to go on). Commands: `/guard` shows status, `/guard off` turns it off, `/guard window 60` changes the window. — [README.md L108-116](https://github.com/nateherkai/claude-code-mods/blob/main/README.md)
- The marketplace and manifest description: "Asks before Claude edits a file another open chat changed in the last 30 minutes: Proceed, Move to a worktree, or Cancel (/guard)". — [.claude-plugin/marketplace.json L23-27](https://github.com/nateherkai/claude-code-mods/blob/main/.claude-plugin/marketplace.json); [collision-guard/.claude-plugin/plugin.json L4](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/.claude-plugin/plugin.json)
- The dialog reads `Another open chat, "<other chat title>", edited <file> <N>m ago. Edit it here too?` with the header `Collision`. While Recording Mode is on, the other chat's title is dropped and only "Another open chat" is shown. — [collision-guard/hooks/register.mjs L132-133](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- `/guard` with no arguments prints a status block: on or off, the other open chats with recent edits and their file counts, the last five files this chat changed, per-chat counters (asked, proceeded, worktree, cancelled), and the settings syntax. — [register.mjs L155-170, L229-243](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- A secondary write-up of the author's video calls it "a prompt in the interface, not a block" and notes that an unattended session gets no protection. — [openclawdatabase.com video summary](https://openclawdatabase.com/news/videos/2026-10-02-claude-code-mods-cache-clock-record-mode-collision-guard/index.md). The code confirms this: when `$.session.surfaces()` is empty, the edit goes ahead and only a debug log line is written. — [register.mjs L120-125](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The author's demo video is "Claude Code Mods Are Game Changers. Set Up These 5 NOW." by Nate Herk. — [YouTube, as cited by openclawdatabase.com](https://youtube.com/watch?v=9hetShMMp2s) (I did not watch the video.)

### Inferences
- The user sees nothing unless a real overlap happens. The only visible costs are the dialog and the `/guard` command.
- "Another open chat" means another Claude Code session with this mod loaded, under the same OS user home. No other kind of agent or editor counts (see the fit section).

### Gaps
- I did not observe how the dialog renders in the Desktop app compared with the terminal, because the mod was not run.

## How does it work (files, hooks, APIs, detection, deny or warn, context cost, failure modes)?

### Takeaway
It is a pure hooks-module mod: one `register.mjs` plus three helper files that are shared across the author's mods. Each chat writes a JSON ledger of the files it changed to `~/.claude/mods-data/collision-guard/<sessionId>.json`. Before each edit it reads every other chat's ledger, and if it finds a match it calls `$.ui.ask`. The choice comes back as a `{ deny }` tool result, which the model reads. It makes no network calls and no model calls. It runs one process (`git ls-files`) only when a collision is found. It costs zero tokens unless a collision ends in a deny, which adds about 50 to 90 tokens. It fails open in several ways.

### Cited Findings

**Files in the mod folder** (from the git tree of the clone)
- `.claude-plugin/plugin.json` (276 B), `hooks/hooks.json` (89 B), `hooks/register.mjs` (10,273 B), `hooks/coach.mjs` (17,525 B), `hooks/privacy.mjs` (17,226 B), `hooks/fmt.mjs` (2,233 B), `hooks/pricing.mjs` (3,200 B). The folder has no README, no tests, and no `userConfig`. — [collision-guard/ tree](https://github.com/nateherkai/claude-code-mods/tree/main/collision-guard)
- Manifest fields are `name`, `version` `1.0.0`, `description`, `author.name` "Nate Herk" and `license` "MIT". It declares no `userConfig`, permissions or dependencies. — [plugin.json L1-9](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/.claude-plugin/plugin.json)
- `hooks.json` contains only `{"description": "Collision Guard hooks module", "modules": ["./register.mjs"]}`. — [hooks/hooks.json L1-4](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/hooks.json)
- `coach.mjs`, `fmt.mjs`, `pricing.mjs` and `privacy.mjs` are "Shared source. Copied into each mod's hooks/ folder by _dev/sync-shared.mjs". The `_dev` folder is not in the public repo. `coach.mjs` says it contains "pure functions ... No mods API calls". `privacy.mjs` says "Pure functions: no mods API calls here". — [coach.mjs L1-3](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/coach.mjs); [privacy.mjs L1-3](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/privacy.mjs); [fmt.mjs L1](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/fmt.mjs)
- `register.mjs` imports only `normPath` and `chatName` from coach.mjs, `clip`, `basename` and `minutes` from fmt.mjs, and `makeMasker` from privacy.mjs. — [register.mjs L13-15](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs). coach.mjs also contains a `COACH_SYSTEM` model prompt and imports pricing.mjs. collision-guard never calls either (dead code shipped by the shared-source copy). — [coach.mjs L5-6, L126](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/coach.mjs)

**Events hooked** (register.mjs)
- `session.start` (L173-196) does the following: reads the clock; resolves home from the `USERPROFILE` or `HOME` env var with backslashes turned into forward slashes; sets the ledger dir to `<home>/.claude/mods-data/collision-guard`; reads the session id and cwd; loads saved settings from `$.store`; registers the slash command `guard`, falling back to `collision-guard` if the first name is taken; starts a 60-second `$.clock.every` heartbeat that rewrites this chat's ledger.
- `session.end` (L198-202) writes a final ledger with `ended: true` and an empty `files` list, but only if this chat ever wrote one.
- `prompt.submit` (L205-208) stores the first prompt from the composer, bridge or sdk, cut to 80 characters, as this chat's `title`. Other chats show that title in their dialogs.
- `tool.call` with `{ tool: ['Edit', 'Write', 'NotebookEdit'] }` (L210-227) is the guard. It does not hook `Bash`, `PowerShell` or MCP tools.
- `command.run` with `{ command: ['guard', 'collision-guard'] }` (L229-243) handles `on`, `off`, `window <minutes>` and the status display.
- It hooks no `ui.render`, `prompt.compose`, status line, band, toast or pane.

**`$` APIs used**
- `$.clock.now`, `$.clock.every`, `$.env.get`, `$.session.id`, `$.session.cwd`, `$.session.surfaces`, `$.store.get` and `$.store.set` (settings persisted across chats), `$.command.register`, `$.fs.write`, `$.fs.list`, `$.fs.read`, `$.fs.exists`, `$.process.run`, `$.ui.ask`, `$.ui.log` (debug). It does not use `$.model`, `$.tool`, `$.session.append`, `$.ui.toast`, `$.ui.status`, `$.ui.open` or any network API. — [register.mjs](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs). An independent static catalogue lists the same 16 API calls and grades the mod L2, "writes or runs" (runs processes, writes files, reads files, reads env vars, persists state). It passed `claude plugin validate`, which the catalogue says is a static check only. — [mods.aidojo.si catalogue entry](https://mods.aidojo.si/mods/nateherkai--claude-code-mods--collision-guard/)

**Collision detection**
- Each chat's ledger has the shape `{ id, title, cwd, updatedAt, ended, files: { <normalizedPath>: { path, at } } }` and is written to `<home>/.claude/mods-data/collision-guard/<sessionId>.json`. — [register.mjs L18, L40-54](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs). A chat that never edits writes no file (L47). Entries older than 2× the window (60 minutes by default) are pruned on each write (L46).
- Before an edit, `readOthers` lists the directory and parses every other `*.json`. It skips ledgers marked `ended` and ledgers whose `updatedAt` is more than `liveMin` (15 minutes) old, which it treats as closed chats. — [register.mjs L56-75](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- `collisionFor` picks the most recent edit of the same normalized path made within `windowMin` (30 minutes) by another live chat. It skips that edit if the user already answered Proceed to it; a newer edit asks again. — [register.mjs L36-37, L91-101](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Path normalization (`normPath`) converts backslashes to `/`, maps Git Bash `/c/...` to `c:/...`, makes relative paths absolute against the session cwd, resolves `.` and `..`, and lowercases a path only when it starts with a drive letter. — [coach.mjs L10-29](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/coach.mjs)
- Paths that contain `/.claude/projects/` or `/.claude/mods-data/` are ignored. — [register.mjs L24, L214](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The edit is recorded in the ledger before the tool runs ("so a chat editing at the same moment sees it"). — [register.mjs L223-226](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)

**Deny or warn**
- The "Move to a worktree" option appears only if `git -C <cwd> ls-files --error-unmatch -- <path>` exits 0 within its 5-second timeout. The call goes through `$.process.run` with an argv array, so no shell is involved. — [register.mjs L107-115, L127](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Proceed returns `null` and the edit runs. Move to a worktree returns `{ deny: "Not edited: ... First list the files you already changed in this checkout (they stay here), then use the EnterWorktree tool and make this change inside the worktree." }`. Cancel, or a dismissed dialog, returns `{ deny: "... Don't change this file again. Tell the user what you were about to change and ask how to proceed." }`. Free text typed under "Other" is cut to 400 characters and returned inside a deny. — [register.mjs L134-152](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The API contract says `{ deny }` answers a `tool.call` hook, so the call is refused and the reason becomes the tool's result. — local bundled type file `plugin-authoring/types/claude-code.d.ts` ~L3677 (Claude Code 2.1.330)

**Context injection, model use, files, processes, network**
- The code comments say "Zero tokens ... Nothing is added to the prompt". — [register.mjs L9-11](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs); the README says the same at [README.md L116](https://github.com/nateherkai/claude-code-mods/blob/main/README.md). The only model-visible text is the deny string after a collision dialog. It is roughly 250 to 450 characters, including the other chat's title of up to 80 characters and the raw path. — [register.mjs L137-152](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Files written: only `~/.claude/mods-data/collision-guard/<sessionId>.json`. Files read: that folder, plus `~/.claude/mods-data/recording.json` (Recording Mode's flag). Settings go to the mod's `$.store`. — [register.mjs L18, L49, L77-89, L179, L234](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The only spawned process is `git ls-files`, and only after a collision is found. No network or model calls appear in the code. The README states: "The mods make no network calls of their own". — [README.md L120](https://github.com/nateherkai/claude-code-mods/blob/main/README.md)

**Failure modes, from the code and the API reference**
- Fail-open on error: the `tool.call` hook is registered without `.catch(...)`. The plugin-authoring reference says that without that handler, "what the guard judges goes on when it throws, answers a wrong shape or outlasts its budget". A broken read or ask therefore lets the edit through. — [register.mjs L210](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs); local plugin-authoring `reference.md` L126-128
- Fail-open when unattended: a session with no surfaces (`claude -p`) skips the ask. — [register.mjs L120-125](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Stale ledgers: a chat that crashes keeps blocking others for up to 15 minutes after its last heartbeat (`liveMin`). Ledgers of ended chats are never deleted. They stay as `ended: true` files, and every edit lists and parses all of them. — [register.mjs L22-23, L49, L64-73, L191-194](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Write errors are swallowed ("a locked file: the next edit or heartbeat writes it again"). — [register.mjs L51-53](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- Settings are global: `/guard off` and `/guard window` persist in `$.store` for "every chat that starts from now". — [register.mjs L232-241](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)

### Inferences
- Race window: the check (read the other ledgers) and the record (write our own) are not atomic and use no lock. Two chats that edit the same file within the same few milliseconds could both pass. Recording before the edit narrows that window but does not close it.
- False negatives (edits it does not see): edits made through `Bash` or `PowerShell` (`sed`, redirection, `Set-Content`, `git checkout`, formatters), MCP tools, a human in an IDE, or any non-Claude agent. All of these bypass it because only Edit, Write and NotebookEdit are hooked. Subagents inside one chat most likely share that chat's session id, and `collisionFor` skips the chat's own ledger, so parallel subagents of one chat are not guarded against each other. This is not verified against the engine.
- False positives (dialogs that are not real conflicts): a deliberate hand-off where chat B continues chat A's file within 30 minutes asks every time A edits again, though Proceed is remembered per edit. Generated or shared files that several chats are meant to touch (indexes, changelogs) will trigger it, and only `.claude/projects` and `mods-data` are excluded. The ignore list cannot be changed through `/guard`, only by editing the stored settings.
- Worktrees: keys are absolute paths, so the same file in two worktrees is two different keys and is never flagged. That matches the goal of keeping worktrees separate. The "Move to a worktree" path relies on the model calling `EnterWorktree`.
- Windows: drive-letter case and slash differences are handled. UNC paths, symlinks, junctions, `subst` drives and 8.3 short names are not resolved, so two spellings of the same file could escape the match. On macOS's case-insensitive filesystem, paths without a drive letter are not lowercased.
- Scope: everything is keyed by the OS user's home. Two different Windows accounts, or WSL against Windows, would not see each other.

### Gaps
- No tests exist in the repo, so runtime behavior (dialog rendering, deny delivery, subagent session ids) is unverified. I did not run it, as the task constraints require.
- The token count for a deny is estimated from string length. It was not measured.

## Install: marketplace, command, scopes, requirements

### Takeaway
It installs as a Claude Code plugin from a GitHub marketplace in two commands. It needs Claude Code 2.1.287 or later with mods enabled on the account. The README does not mention scopes.

### Cited Findings
- `claude plugin marketplace add nateherkai/claude-code-mods`, then `claude plugin install collision-guard@nateherk-mods`. The marketplace name is `nateherk-mods`. — [README.md L17-40](https://github.com/nateherkai/claude-code-mods/blob/main/README.md); [marketplace.json L2](https://github.com/nateherkai/claude-code-mods/blob/main/.claude-plugin/marketplace.json)
- Requirements: Claude Code 2.1.287 or later, working in the terminal and the Desktop app's Code tab. "Mods turned on for your account", which can be checked with `claude plugin test`. — [README.md L12-15](https://github.com/nateherkai/claude-code-mods/blob/main/README.md)
- Update: `claude plugin marketplace update nateherk-mods`, then `claude plugin update <mod>@nateherk-mods`. "Installs are copies, so nothing changes until you update." Remove: `claude plugin uninstall`. — [README.md L45-47](https://github.com/nateherkai/claude-code-mods/blob/main/README.md)

### Inferences
- The default `claude plugin install` scope is user-level, configured under `~/.claude`. A `--scope project` install would add an `enabledPlugins` entry to the repo's `.claude/settings.json`. This is general Claude Code behavior that I did not verify for this mod.

### Gaps
- The README does not document scope options or pinning a commit or version. The manifest says `1.0.0`, and no git tags or releases exist.

## Maturity and trust

### Takeaway
This is a young, single-author, single-commit repo by a popular AI YouTuber. It has moderate attention (148 stars, 18 forks), no releases, tests, PRs or contributors besides the author, and five open issues, none about collision-guard. The code is short, readable and does what it claims, but it has not been battle-tested.

### Cited Findings
- 148 stars, 18 forks, 5 open issues, 1 watcher, MIT license, created and last pushed 2026-10-02, size 54 KB. — [GitHub API repos/nateherkai/claude-code-mods](https://api.github.com/repos/nateherkai/claude-code-mods) (fetched 2026-11-23)
- Exactly one commit in the whole repo, `33a936f` (2026-10-02, "Four Claude Code mods: Cache Keeper, Recording Mode, Goal Meter, Collision Guard"). One contributor (`nateherkai`), 0 pull requests, 0 releases. — [commits](https://github.com/nateherkai/claude-code-mods/commits/main); [API contributors/pulls/releases](https://api.github.com/repos/nateherkai/claude-code-mods/contributors)
- Open issues: #1 goal-meter refused by `$.session.append`; #2 Recording Mode listed on statuslin.es; #3 a catalogue maintainer graded cache-keeper L2 and noted that `inematds/5-mods` "carries copies of all four of your mods"; #4 and #5 are cache-keeper bugs. None concern collision-guard. — [issues](https://github.com/nateherkai/claude-code-mods/issues)
- Author account `nateherkai` ("Nate Herk"): created 2026-01-09, 18 public repos, about 2,563 followers, no bio or blog set. — [GitHub API users/nateherkai](https://api.github.com/users/nateherkai)
- The mods are presented in the author's YouTube video and covered by secondary sites (MindStudio, openclawdatabase, Towards Data Science and others). — [openclawdatabase.com](https://openclawdatabase.com/news/videos/2026-10-02-claude-code-mods-cache-clock-record-mode-collision-guard/); [mindstudio.ai guide](https://www.mindstudio.ai/blog/claude-code-mods-guide)
- Forks and copies: 18 to 19 forks, mostly untouched (their push date equals upstream's), plus `neogeweb3/claude-code-mods` (pushed 2026-10-09), `Marketplaces-Plugins-Shared/claude-code-mods` (2026-10-05), and repackaged names such as `ivangegovdve-sudo/claude-code-mods-nate` and `garrethpxy/nateh-claude-code-mods`. — [API forks](https://api.github.com/repos/nateherkai/claude-code-mods/forks). The copy repo `inematds/5-mods` is reported in [issue #3](https://github.com/nateherkai/claude-code-mods/issues/3).

### Inferences
- Install only from `nateherkai/claude-code-mods`. Forks and repackaged copies that changed after upstream (neogeweb3, Marketplaces-Plugins-Shared, inematds/5-mods) should be treated as unreviewed code that may differ from what was audited here.
- Since installs are copies and no version is pinned, a later `plugin update` could pull arbitrary new code from a single maintainer. Re-review before each update.

### Gaps
- I did not inspect fork diffs. Commit-level change history for collision-guard does not exist beyond the initial commit.

## Security and privacy risks

### Takeaway
The risk surface is small and local. The concrete exposures are four: plaintext chat titles (the first 80 characters of each chat's first prompt) and file paths written to `~/.claude/mods-data`; those titles shown to, and sent into the model context of, other chats; fail-open behavior; and supply-chain risk on update. No exfiltration path exists in the current code.

### Cited Findings
- The first prompt of each chat (up to 80 characters) is stored unmasked in a JSON file under the home directory, together with the cwd and the absolute paths of edited files. — [register.mjs L49, L206](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The other chat's title is masked in the dialog only while Recording Mode is on. The deny text sent to the model always includes it unmasked (`chatName(hit.other)`, cut to 80 characters). — [register.mjs L132, L137](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- The guard fails open on hook errors (no `.catch`) and when no surface exists. — [register.mjs L120-125, L210](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs); plugin-authoring `reference.md` L126-128
- `$.process.run` builds `git` argv with `--` before the path, so the path cannot be read as a git option and no shell is involved. — [register.mjs L110](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)
- A static catalogue grades it L2 (writes or runs) and warns that access levels are not safety ratings. — [mods.aidojo.si](https://mods.aidojo.si/mods/nateherkai--claude-code-mods--collision-guard/)

### Inferences
- A secret pasted into a chat's first prompt, such as a token, would be stored on disk and could show up in another chat's dialog and model context.
- Another local process could plant a crafted ledger JSON in the folder. That could inject a misleading title, up to 80 characters, into a deny message the model reads, which is a minor prompt-injection vector. It could also force dialogs, or hide collisions by marking ledgers `ended`. This needs local write access to the home directory, so it is low risk.
- Shipping unused code (the `COACH_SYSTEM` prompt, pricing) does no harm, but it enlarges what a reviewer has to read on each update.

### Gaps
- No third-party security review specific to collision-guard was found beyond the static catalogue grade.

## Fit with the Harness repository (E:\personal\base-harness-repo)

### Takeaway
Only part of this mod fits the Harness. It addresses a real risk: several agents can work in one shared checkout, and the Harness relies on owned paths and serialized writers, which nothing enforces. But it covers only Claude Code sessions using Edit, Write or NotebookEdit. Its "Move to a worktree" option directly conflicts with the Harness's standing no-worktree rule. Installing it is a user-level hook install that needs specific User authority. It costs nothing against the session-start read budget.

### Cited Findings
- Harness rule against worktrees: "No agent coordination creates or uses a Git worktree: both Herdr and Orca coordination run every worker on the coordinator's current checkout and branch, with the shared-checkout rules (owned paths, serialized writers, parallel only for read-only or disjoint outputs)" (User decision 2026-10-05). It also bans `isolation: "worktree"`. — `docs-harness/harness-improvements/1005-coordination-without-worktrees.md` L24-35, L72-78 (#045); also `docs-harness/harness-improvements/0919-herdr-shared-checkout.md` (#024, "Keep Herdr coordination in the current Git checkout")
- Herdr app guidance: "Several workers: one name each, disjoint written paths, and sequential runs for any overlap". It cites a replay that ran `agy` and Claude Haiku workers in parallel. — `docs-harness/HERDR-APP.md` L156-158
- Task authority: "Dependency installation and operations on shared services, real data, global settings, credentials or unrelated paths need specific authority". Account or permission changes need "explicit authority for that action and target". — `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` L26-33 (#009)
- #094's purpose checklist: "Keep the Harness in charge of agent instructions: no third-party installer writes `AGENTS.md`, rules or hooks." — `docs-harness/harness-improvements/1123-code-graph-skill.md` L28-29
- Session-start budget: "The files every session must read at start total at most 33,400 normalized bytes". — `docs-harness/harness-improvements/1115-session-start-context-cut.md` L27 (#064)
- The repo has no `.claude/settings.json`. `.claude/settings.local.json` holds only `skillOverrides` that turn off four `utilizing-tools-*` skills. Nothing enables plugins at project scope. — local read of `E:\personal\base-harness-repo\.claude\`
- The mod's own code writes no repo files (no `AGENTS.md`, rules or repo hooks). It writes only under `~/.claude/mods-data/collision-guard/` and the mod's `$.store`. — [register.mjs L18, L49, L234](https://github.com/nateherkai/claude-code-mods/blob/main/collision-guard/hooks/register.mjs)

### Inferences
- Real risk addressed: Claude Code chats that the User, Herdr or Orca start in the same checkout, editing the same file within 30 minutes, would get a human checkpoint. This backs up the owned-paths rule that the Harness currently enforces only through documentation.
- What it does not cover here:
  - agy (Antigravity), Codex, OpenCode or other non-Claude workers.
  - Claude workers that edit through Bash or PowerShell.
  - Edits by subagents inside one coordinator chat.
  - Headless `claude -p` workers, a likely Herdr or Orca dispatch mode, where it silently lets the edit through.
  - The human in an editor.
  
  In a mixed-agent Harness session, those are most of the parallel writers.
- Conflict with the Harness: picking "Move to a worktree" sends a deny that tells the model to call `EnterWorktree`, which breaks #024 and #045. The option appears for every git-tracked file, which covers nearly everything in this repo. Without forking, the only Harness-safe answers are Proceed and Cancel. A Harness note would then have to tell agents to treat that instruction as overridden. Forking to remove the option would make the Harness maintain third-party code.
- Authority and #094: a `claude plugin install` (user scope, under `~/.claude`) installs a hooks module that runs on every Edit and Write in every project on the machine. Under #009 that counts as dependency installation and a global settings change, which needs specific User authority, plus separate authority for `marketplace add` and each later update. It does not break #094's letter, because it writes no `AGENTS.md`, repo rules or repo hooks. A `--scope project` install would write `.claude/settings.json` in the repo, which falls within #094's concern and #009's scope.
- Context cost: zero bytes against #064's 33,400-byte session-start budget, and zero tokens per turn. It adds about 50 to 90 tokens only when a collision deny happens. The one cross-chat leak is the other chat's title in deny text.
- A cheaper Harness-native alternative for the gap it leaves would be a coordinator-side check (for example comparing `git status` or `git diff --name-only` against workers' owned paths). That would cover every agent type. This is an inference, not an existing Harness feature.

### Gaps
- I did not verify how Herdr or Orca start Claude workers (interactive vs `-p`), which decides whether the guard ever asks in worker sessions.
- I did not verify whether `tool.call` hooks fire with the parent session id for subagent calls.
