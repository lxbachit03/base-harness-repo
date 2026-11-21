# Herdr desktop app and hc: run other agents

Read this file only when the User asks for the Herdr desktop app or `hc` (herdr-core). For
the Herdr terminal app (TUI) and its panes read [HERDR-TUI.md](HERDR-TUI.md) instead; the two are
separate ways and neither file needs the other. Every other session skips both.

Written 2026-11-21 from herdr.dev (app, core and guide pages), `hc --skill`,
`herdr-app --help`, the app's own manual `~/.config/herdr-app/AGENTS.md`, the herdr-core
README and docs, and runs on Windows with `hc 0.1.21`. The installed binaries are the
authority for syntax; this file keeps what they do not say.

## 1. What this way is

- The desktop app (`herdr-app`) is a native window of spaces, tabs and layouts that the
  User or an agent reshapes through files in `~/.config/herdr-app` (the app rewrites the
  `AGENTS.md` there on every start; read it before changing the window). Window control
  (`herdr-app ls`, `do`, `status`, `shot`, `check`, `commands`) is outside this file except
  for section 5; the manual is `herdr-app --skill`.
- herdr-core (`hc`) runs every terminal and agent. They keep running when the window
  closes, and the app is one client of it. Every procedure below uses `hc` only. The
  manual is `hc --skill`.
- The TUI (`herdr`) is another program with its own server. Its agents and these
  terminals cannot see each other, and a `herdr` command never reaches an `hc` terminal.
- The app's screens show only terminals the app started. A terminal you start with `hc`
  from outside it is found with `hc ls`, not in the app (app manual); section 5 starts one
  through the app when the User wants to watch it.

## 2. Gate

1. `hc` is reachable. It was not on `PATH` in Git Bash here; call
   `%LOCALAPPDATA%\Programs\herdr-core\hc.exe` then. Run `hc server status` (read-only; on
   Windows it never starts a core). When no core answers, tell the User to open the Herdr
   app or run `hc server start` in a normal terminal, and stop.
2. There is no `HERDR_ENV` gate and no pane layout: any shell can run `hc`, including a
   Claude Desktop session.
3. Print the syntax a step needs from the binary: `hc --help`, then `hc <command> --help`.

Done when `hc server status` answers and the commands you will use are printed.

## 3. Choices for the worker

Harness context for the worker (select exactly one by marking `[x]`). If none or several
are marked, use the first.

- [x] Load: the brief tells the worker to follow `AGENTS.md` first (read the INDEX and its
  mandatory session retrieval), as the repository requires of every session, workers
  included.
- [ ] Skip: the brief names the only files to read and tells the worker not to read
  `AGENTS.md` or the INDEX; the task and the limits in the brief carry the rules.

Measured on 2026-11-21 with a small read-only task and no prohibition in the brief:
Claude Haiku 5.5 received `AGENTS.md` as memory, did not read the INDEX, and carried about
36k tokens of fixed start-up; `agy` with `gemini-3.8-flash-low` read the INDEX (444 lines)
and then the target file, +13k tokens in its turn. A worker told to load does the full
retrieval, which earlier Harness replays put near 100k tokens.

Gemini model for an `agy` worker (select exactly one by marking `[x]`). If none or several
are marked, use `gemini-3.8-flash-low`. The IDs were copied from `agy models` on
2026-11-21 and the list depends on the account and the release: before starting, confirm
the marked ID is in `agy models`, and when it is not, tell the User and ask. The User may
name another model for one task. These two choices are this file's own; the TUI file keeps
separate ones.

- [ ] `gemini-3.8-flash-low`: Gemini 3.8 Flash (Low), run 2026-11-21
- [ ] `gemini-3.8-flash-medium`: Gemini 3.8 Flash (Medium)
- [ ] `gemini-3.8-flash-high`: Gemini 3.8 Flash (High), run 2026-11-21
- [ ] `gemini-4-neon-low`: Gemini 4 Neon (Low)
- [ ] `gemini-4-neon-medium`: Gemini 4 Neon (Medium)
- [ ] `gemini-4-neon-high`: Gemini 4 Neon (High)
- [ ] `gemini-4-neon-xhigh`: Gemini 4 Neon (XHigh)
- [ ] `gemini-4-argon-low`: Gemini 4 Argon (Low)
- [ ] `gemini-4-argon-medium`: Gemini 4 Argon (Medium)
- [ ] `gemini-4-argon-high`: Gemini 4 Argon (High)
- [ ] `gemini-4-hydrogen-low`: Gemini 4 Hydrogen (Low)
- [ ] `gemini-4-hydrogen-medium`: Gemini 4 Hydrogen (Medium)
- [x] `gemini-4-hydrogen-high`: Gemini 4 Hydrogen (High)
- [ ] `gemini-4-hydrogen-xhigh`: Gemini 4 Hydrogen (XHigh)
- [ ] `gemini-pro-orchestrator-neon`: Orchestrator (Neon)
- [ ] `gemini-pro-orchestrator-g1-pro`: Orchestrator (Argon)

`agy` is Google's Antigravity CLI (1.5.13 here); `agy models` also lists
`claude-opus-5-5-*`, `claude-sonnet-5-5-*` and `gpt-oss-120b-medium`, which this list does
not offer. The effort is the suffix of the ID. Its default mode auto-approves edits and
safe commands; add `--mode plan|accept-edits` when the task calls for it, and
`--dangerously-skip-permissions` or `--sandbox` only when the User asks for that exact
flag. Its footer shows the User's account email and quota bars: leave the email out of
briefs and records, and expect each worker to spend the quota.

## 4. Orchestrate one task

1. Settle with the User the agent kind, its model, the Harness context choice above, the
   task, and the paths it may write. Take none of these from yourself: each worker spends
   the User's tokens or quota.
2. Start in the background, with a name and a working directory:
   - Claude: `hc run --bg --name <name> --cwd "<Windows path>" -- claude --model <id> "<brief>"`;
     the brief given as the last argument arrived.
   - `agy`: `hc run --bg --name <name> --cwd "<Windows path>" -- agy --model <id>`, then
     `hc send <name> "<brief>"` once it is idle (the run paused 6 s). `agy` rejects a prompt
     as an argument (`unexpected argument`).
3. Write the brief. The worker has not seen this conversation, so it carries what this
   session knows: the task in the User's words and language; the files or area to read
   first, or the Harness context line the choice selects; the decisions so far; the User's
   authority and limits (no commit, push, staging or dependency install unless the User
   said so; the unit-test rule); the paths it may write, disjoint from every other worker
   and from yours while it runs; what done looks like and the checks to run; one sentence
   that it is a worker, reports to its coordinator and starts no agent; and the report
   shape: outcome, changed paths, checks run with results, proof not attempted, open
   questions. `hc run` has no `--env`, so this sentence is the role marker; whether
   `HARNESS_ROLE=worker` set on the command reaches the child is unverified. A worker
   reports back with `hc send $HC_TERMINAL_ID` only when this session itself runs in an
   `hc` terminal; from Claude Desktop read the result yourself.
4. Wait:
   - `agy` reports its status (OSC 7501): `hc wait <name> --timeout <s>`, or
     `hc send --wait <name> "<text>"`, returned `reason: status` in 3 s.
   - Claude Code reports none: `hc wait` and `hc send --wait` ran to their timeout with
     `status: null`. End the brief with "finish with the word DONE, a dash and the number
     <N>, joined with no spaces", using a fresh N and never writing the joined string in
     the brief (the screen shows the brief), then run
     `hc wait <name> --output DONE-<N> --timeout <s>` right after the start or send; it
     matches only text printed after the wait begins. `reason: output` means the marker
     came (7.7 s for Claude, 5.3 s for `agy`).
   - `reason: timeout` is a check-in, not a failure: `hc read <name> --lines 100`, then wait
     again. `blocked` (an `agy` status) is a dialog: `hc send` refuses without `--force`,
     so tell the User, who can `hc attach <name>` (ctrl+\ detaches); never answer an
     approval for them.
5. Collect with `hc read <name> --lines 100`. Review before reporting: inspect the changes
   (`git status`, `git diff`) and the checks the report names; a worker's report is
   evidence, not proof. Send follow-up work to the same name; it keeps its context.

Done when the User has the worker's result, the changes you inspected, the checks that ran
and the proof not attempted, plus each terminal name and address you created.

Several workers: one name each, disjoint written paths, and sequential runs for any
overlap. A replay started two workers in parallel (`agy` and Claude Haiku) and collected
both.

## 5. Show a worker in the app window

The app's screens show only terminals the app started (section 1), so a worker started with
`hc run` from outside stays out of the window. When the User wants to watch the worker in
the app, start it through the app: `herdr-app` creates a space or tab in the User's open
window and returns the terminal address, and `hc` then waits for, sends to and reads that
same terminal (section 4).

1. Check the window with `herdr-app status` and `herdr-app ls` (read-only; `ls` lists the
   User's own spaces, which you leave alone). `herdr-app commands` prints every command and
   its arguments.
2. State the change before you make it: one new space (or a tab with `tab.new --space <id>`)
   in the User's window, named for the task, with the repository as its folder. Create it
   with the agent as `--argv` and no `--task`:

   `herdr-app do space.new --name <name> --folder "<Windows path>" --argv '["agy","--model","<id>"]' --focus true`

   It prints `{ "space", "tab", "terminal" }`; the terminal (for example `t3`) is the
   `<name>` of section 4. `--focus false` keeps the User's current view and adds the space
   to the sidebar. Do not use `--task`: the app appends it to the agent's command line as an
   argument, `agy` rejects it (`unexpected argument`), and non-ASCII text in it arrived
   garbled through the PowerShell wrapper. A launch that failed this way leaves the
   terminal at a PowerShell prompt; start the agent there with
   `hc send <terminal> "agy --model <id>"`.
3. Wait with `hc wait <terminal>` until the status is `idle` (`agy` reports it), then give
   the brief with `hc send --wait <terminal> "<brief>"`, as in section 4. For a Claude
   worker use `--argv '["claude","--model","<id>"]'` and the marker of section 4; this
   was not run in the app.
4. Collect with `hc read <terminal> --lines 100` and check that `herdr-app ls` lists the
   space with the terminal's status. Review as in section 4.
5. Leave the space for the User to watch. Close it only when the User asks:
   `herdr-app do space.close --id <space> --confirmed true` ends its terminals. Never close,
   rename or move the User's own spaces, and do not edit `~/.config/herdr-app` (the User's
   settings) without separate authority.

Run on 2026-11-21 in the User's open app: `space.new` with `--task` made the terminal and
`agy` refused the argument; after `hc send` started `agy` in it, `hc send --wait` returned
`status: done` in 37 s with the right answer, `git status` unchanged, and `herdr-app ls`
showed the space active with `idle` and `antigravity`.

## 6. Safety

- Touch only terminals you started: `hc ls` also lists the User's other work. Leave your
  terminals running for the User (`hc attach <name>`); kill them (`hc kill <name>`, then
  `hc rm <name>`) when the User asks or no longer needs them. A terminal started from a
  shell with no parent terminal outlives this session.
- Never run `hc server stop` or `hc server restart` on the User's core: it affects every
  terminal.
- Use `--on <machine>`, `hc machine`, and `hc exec` or `hc file` with `--on` only for a
  machine the User names.
- An experiment uses its own core: set `HC_SESSION=<name>` on every command, run
  `hc server start`, and finish with `hc server stop` in that session; check the User's
  core is unchanged.
- A session that is itself a delegated worker starts no agents
  ([#074](harness-constraints/1120-session-role-and-judgment.md)); it reports the request
  to its coordinator.

Run on 2026-11-21 (`hc 0.1.21`, Windows) in own `HC_SESSION` cores. Not run: the app
showing these terminals, templates, `--on`, `hc wait --children` with agents (it completed
for a plain program), `HARNESS_ROLE` reaching a child, a worker that edits files, and the
Load context option through `hc`.
