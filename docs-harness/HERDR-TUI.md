# Herdr TUI: run other agents in panes

Read this file only when the User asks for the Herdr terminal app (TUI), a Herdr pane or
the `herdr` command (for example "use Herdr TUI", "open a Herdr pane"). Every other session
skips it. The User names the way in the prompt: for the Herdr desktop app or `hc` read
[HERDR-APP.md](HERDR-APP.md) instead; the two are separate ways and neither file needs the
other.

Written 2026-11-21 from the upstream agent skill (`herdr --skill`), the documentation
index <https://herdr.dev/llms.txt> (stable 0.9.5), the Antigravity CLI docs and runs on
Windows with `herdr 0.9.4-preview`. The installed CLI is the authority for syntax; this file keeps what
the CLI does not say. Raw upstream pages are listed in the `llms.txt` index.

The desktop app and the TUI are separate programs: their agents cannot see each other, so a
command of one never reaches the other's terminals.

## 1. Gate

Session outside Herdr (mark `[x]` to allow it; leave `[ ]` to stop at the gate). A session
that does not run in a Herdr pane, such as Claude Desktop, then keeps its own conversation
and drives a Herdr session of its own, as the own-session steps below say.

- [ ] Allow an own named session

Attach command for an own session (matters only when the box above is marked; mark `[x]` to
let Claude open the command in a terminal tab of the host, leave `[ ]` to get the command
and run it yourself):

- [ ] Open the attach command myself

1. Check `test "${HERDR_ENV:-}" = 1` (PowerShell: `$env:HERDR_ENV -eq '1'`). When it
   fails and the switch is `[ ]`, tell the User this session is not inside a Herdr pane and
   stop; they start the agent from a Herdr pane (run `herdr`, then the agent, in a pane).
   When it fails and the switch is `[x]`, follow the own-session steps. Either way, do not
   inspect or control the User's own Herdr session from outside; an experiment that needs
   its own server uses a named session as well.
2. Run `herdr status` and read the server version and `endpoint_compatible`. A missing
   method is not permission to stop or upgrade the server.
3. Print the syntax a step needs from the binary: `herdr --help`, then a group name alone
   (`herdr agent`, `herdr pane`, `herdr workspace`, `herdr tab`). Never run bare `herdr`
   (it launches the TUI) and never probe a mutating command by omitting its arguments:
   `herdr workspace create` runs with defaults.

Done when the check passed and the commands you will use are printed.

### Own session (outside Herdr, switch `[x]`)

This session starts a Herdr server of its own and drives only that server. A new pane
would not carry this conversation; this way the conversation stays here.

1. Pick a lowercase name (`[a-z0-9-]`, for example `claude-<task>`) that `herdr session
   list --json` does not list, and never use `default` or a session you did not create.
2. Start the server in the background: `herdr --session <name> server`. It keeps running
   until stopped.
3. Put `--session <name>` right after `herdr` in every later command. There is no calling
   pane: skip `--current` and `$HERDR_PANE_ID`, take pane IDs from the JSON of
   `workspace create` (`.result.root_pane.pane_id`) and `pane split`, and pass them
   explicitly. Section 3 then applies unchanged.
4. Right after `agent start` succeeds, before the call that waits for the worker
   (`agent prompt --wait`), write the attach command, `herdr session attach <name>`, in a
   message to the User, so it is on screen while the worker runs, not only in the final
   report; write it again whenever the worker is `blocked`. It shows every pane of the
   session. A `blocked` dialog is theirs to answer there; Claude Code's auto mode refused
   this session's `agent send-keys` answer to one in the replay.
   - Box `[ ]`: show the command alone in its own fenced `powershell` block (no `$` prompt,
     no output inside) with one line saying it opens the session's panes, so the User runs it
     from there.
   - Box `[x]`: open it in a terminal tool of the host that keeps a process running in a
     tab the User can see and type in (Claude Desktop: `run_in_terminal` with a short
     title and the repository as `cwd`), and name the tab. Without such a tool, show the
     block as for `[ ]`.
   - Never run `herdr session attach` through a shell tool that waits for the command to
     exit (such as Bash): it opens an interactive TUI and does not return.
5. When the User no longer needs the panes, run `herdr session stop <name>` and then
   `herdr session delete <name>`; stop and delete only a session you created. Then close
   the terminal tab you opened for the attach command (Claude Desktop: `stop_terminal_tab`
   with `close: true`), never a tab the User opened.

## 2. Model

- Workspace contains tabs; a tab contains panes; a pane is a real terminal (PowerShell on
  Windows). An agent is the recognized coding agent running in a pane. `agent start`
  needs an existing shell pane at its prompt and never creates layout.
- IDs are opaque handles: `w1`, `w1:t1`, `w1:p1`. Read them from JSON responses
  (`.result.pane.pane_id`, `.result.root_pane.pane_id`), never from examples. Each pane
  also gets `HERDR_WORKSPACE_ID`, `HERDR_TAB_ID`, `HERDR_PANE_ID`; `--current` targets the
  calling pane.
- An agent name matches `[a-z][a-z0-9_-]{0,31}`, is unique among live agents, and follows
  the pane's current occupant. Agent commands take the name or the pane ID.
- Status: `idle` and `done` are ready for input; `working`; `blocked` is an approval or
  question dialog Herdr recognized; `unknown` proves nothing about completion.

## 3. Orchestrate one task

Harness context for the worker (select exactly one by marking `[x]`). If none or several
are marked, use the first.

- [x] Load: the brief tells the worker to follow `AGENTS.md` first (read the INDEX and its
  mandatory session retrieval), as the repository requires of every session, workers
  included.
- [ ] Skip: the brief names the only files to read and tells the worker not to read
  `AGENTS.md` or the INDEX; the task and the limits in the brief carry the rules.

Measured on 2026-11-21 with a small read-only task and no prohibition in the brief:
Claude Haiku 5.5 received `AGENTS.md` as memory (436 tokens for two memory files), did not
read the INDEX, and carried about 36k tokens of fixed start-up (system prompt, tools,
skills); `agy` with `gemini-3.8-flash-low` read the INDEX (444 lines) on its own and then
the target file, +13k tokens in its turn, and read none of the other retrieval files.
Neither worker did the full retrieval unprompted; a worker told to load does it, and
earlier Harness replays that did it used about 100k tokens each.

1. Settle with the User the agent kind (`herdr agent` lists kinds), its model or native
   arguments, the task, and the paths it may write. Take none of these from yourself:
   each worker spends the User's tokens, and the Harness context checkbox above sets how
   many.
2. Create the pane. Default to a sibling pane of the current tab in the current directory;
   make no workspace, tab, worktree or other cwd unless the User asks. Pick the direction
   from `herdr pane layout --pane "$HERDR_PANE_ID"` (right for a wide pane, down for a
   narrow one) and keep the User's focus:

   `herdr pane split --current --direction right --cwd "<Windows path>" --env HARNESS_ROLE=worker --no-focus`

   `--env` reaches the new shell and so the agent started in it, which marks the agent as
   a delegated worker ([#074](harness-constraints/1120-session-role-and-judgment.md)).
3. Start the agent: `herdr agent start <name> --kind <kind> --pane <pane_id> [-- <native args>]`.
   Success means the agent is `idle` and ready. `agent_not_ready` with `blocked` is a
   start-up dialog such as the "trust this folder" prompt of an untrusted directory: read
   it (`herdr agent read <name> --source visible`) and ask the User; trust and permission
   choices are theirs.
4. Write the brief. The worker has not seen this conversation, so the brief carries what
   this session knows: the task in the User's words and language; the files or area to
   read first, or the Harness context line the checkbox selects; the decisions so far; the User's authority and limits (no commit, push,
   staging or dependency install unless the User said so; the unit-test rule); the paths
   it may write, disjoint from every other worker and from yours while it runs; what done
   looks like and the checks to run; one sentence that it is a worker, reports to its
   coordinator and starts no agent; and the report shape: outcome, changed paths, checks
   run with results, proof not attempted, open questions.
5. Send it and wait:

   `herdr agent prompt <name> "$(cat brief.md)" --wait --timeout 600000`

   Git Bash rewrites an argument that starts with `/` into a path (`/context` reached the
   worker as `C:/Program Files/Git/context`); set `MSYS_NO_PATHCONV=1` for a slash command.
   A multi-line Vietnamese brief passed as one argument arrived intact in the run; briefs
   beyond a few KB are untested (a Windows command line holds about 32 KB). `--wait`
   returns at the first settled `idle`, `done` or `blocked` after activity; add no
   `--until` for normal work. Outcomes:
   - `agent_prompt_stalled`: no activity within 5 s. It happened on the first prompt right
     after `agent start` for both a Claude and an `agy` worker (`agy` printed a backend
     error, "empty conversation id"), with nothing submitted; read the agent, then resend
     once.
   - `timeout`: the prompt may have been delivered. Read before resending, then continue
     with `herdr agent wait <name> --timeout <ms>`.
   - `agent_blocked` or status `blocked`: read the dialog and ask the User before any
     `herdr agent send-keys`; never answer an approval on their behalf.
6. Collect: `herdr agent read <name> --source recent-unwrapped --lines 120` shows the
   worker's reply. When the reply is cut off, ask the worker to write it as Markdown in a
   temporary directory and answer with the path, then read that file (fallback only).
7. Review before reporting: inspect the changes (`git status`, `git diff`) and the checks
   the report names; a worker's report is evidence, not proof. Send follow-up work to the
   same name; it keeps its context.

Done when the User has the worker's result, the changes you inspected, the checks that ran
and the proof not attempted, plus each pane ID and agent name you created.

Several workers: one pane and one name each, disjoint written paths, and sequential runs
for any overlap. Leave worker panes open for the User to inspect; close only panes you
created (`herdr pane close <pane_id>`), and only when they ask or no longer need them.

## 4. Ordinary commands in a pane

`herdr pane run <pane_id> "<command>"` queues the text and Enter; success means admission,
not execution. It types into whatever occupies the pane, an agent included (in the replay a
`pane run` sent just after `agent start` reached the agent as a prompt), so use it only on
a shell pane and send an agent its work with `agent prompt`. Then `herdr pane wait-output <pane_id> --regex "<pattern>" --timeout <ms>`
(matches already-present text) and `herdr pane read <pane_id> --source recent-unwrapped
--lines 120`. Use `pane` commands for tests, servers and watchers, and `agent` commands
only for a recognized agent.

## 5. Antigravity worker (`--kind agy`)

`agy` is Google's Antigravity CLI (1.5.13 here, `%LOCALAPPDATA%\agy\bin`); it signs in with
the User's Google account and runs Gemini, Claude and GPT-OSS models. Herdr's integration
for it is named `antigravity-cli`. Gemini CLI is a different tool (`--kind gemini`) and is
not installed here. Print the live syntax with `agy --help` and `agy models`.

Gemini model for the worker (select exactly one by marking `[x]`). If none or several are
marked, use `gemini-3.8-flash-low`. The IDs were copied from `agy models` on 2026-11-21 and
the list depends on the account and the release: before starting, confirm the marked ID
is in `agy models`, and when it is not, tell the User and ask. The User may name another
model for one task.

- [ ] `gemini-3.8-flash-low`: Gemini 3.8 Flash (Low), run 2026-11-21
- [ ] `gemini-3.8-flash-medium`: Gemini 3.8 Flash (Medium)
- [x] `gemini-3.8-flash-high`: Gemini 3.8 Flash (High), run 2026-11-21
- [ ] `gemini-4-neon-low`: Gemini 4 Neon (Low)
- [ ] `gemini-4-neon-medium`: Gemini 4 Neon (Medium)
- [ ] `gemini-4-neon-high`: Gemini 4 Neon (High)
- [ ] `gemini-4-neon-xhigh`: Gemini 4 Neon (XHigh)
- [ ] `gemini-4-argon-low`: Gemini 4 Argon (Low)
- [ ] `gemini-4-argon-medium`: Gemini 4 Argon (Medium)
- [ ] `gemini-4-argon-high`: Gemini 4 Argon (High)
- [ ] `gemini-4-hydrogen-low`: Gemini 4 Hydrogen (Low)
- [ ] `gemini-4-hydrogen-medium`: Gemini 4 Hydrogen (Medium)
- [ ] `gemini-4-hydrogen-high`: Gemini 4 Hydrogen (High)
- [ ] `gemini-4-hydrogen-xhigh`: Gemini 4 Hydrogen (XHigh)
- [ ] `gemini-pro-orchestrator-neon`: Orchestrator (Neon)
- [ ] `gemini-pro-orchestrator-g1-pro`: Orchestrator (Argon)

- The marked box is the User's choice. `agy models` also lists `claude-opus-5-5-*`,
  `claude-sonnet-5-5-*` and `gpt-oss-120b-medium`, which this checklist does not offer. The
  effort is the suffix of the ID; `--effort low|medium|high|xhigh|max` also exists. Pass
  the choice as `herdr agent start <name> --kind agy --pane <pane_id> -- --model <id>`.
- Its default mode auto-approves edits and safe commands. Add `--mode plan|accept-edits`
  when the task calls for it, and `--dangerously-skip-permissions` or `--sandbox` only when
  the User asks for that exact flag.
- Step 3 of section 3 applies unchanged. In the run, `agent start --kind agy` returned
  `idle` and ready in about 4 s in this repository, with no trust dialog.
- Run on 2026-11-21 with `gemini-3.8-flash-low` and `-high` as `HARNESS_ROLE=worker`: a one-line
  prompt, a five-line Vietnamese brief that asked it to read a repository file and count
  entries (answered correctly, last line as instructed), and a four-file read task each
  returned from `agent prompt --wait` in 4 to 6 s (Low) or about 35 s (High, the brief and
  the four-file task) with the full reply in `agent read`.
- Read the reply, not the status bar: right after a reply the TUI footer still showed
  `WORKING` while Herdr already reported `idle`. Herdr counts an Antigravity agent as idle
  at its prompt even while background tasks or subagents run, so `idle` proves a prompt,
  not finished work. A 2026-09-22 run with `gemini-3.8-flash-high`
  ([#029](harness-improvements/0922-agy-done-signal-reliability.md)) saw six false `done` or
  `idle` signals inside one long turn; the short runs above, High included, saw none. For long work wait,
  read, and confirm the artifact or the report the brief asked for before accepting.
- The TUI footer shows the account's 5-hour and 7-day quota bars; each worker spends them.
- Without a pane, `agy -p "<prompt>" --model <id> --output-format text|json|stream-json`
  answers one prompt and exits (run: `HEADLESS-OK` in 9 s). Use it for a single answer
  when the User does not need a pane; a pane keeps context across prompts.
- The footer shows the User's account email; leave it out of briefs and records.

## 6. Safety

- Target with `--current`, an explicit pane ID or a unique agent name, never the focused
  pane, which may belong to the User or another client. Use `--no-focus` for background
  work.
- Close or stop only what you created. Never run `herdr server stop` or kill the Herdr
  process from a live session; it ends every pane process. Your own named session is
  stopped with `herdr session stop <name>`.
- Add `--trust-repository` only after the User verified the repository.
- A saved SSH machine needs the User to name it; then prefix every command with
  `--machine <label-or-id>` and run no `machine reconnect`, add or remove.
- A server error is JSON on stderr with exit 1; a syntax error exits 2.
- A session that is itself a delegated worker starts no agents
  ([#074](harness-constraints/1120-session-role-and-judgment.md)); it reports the request
  to its coordinator.
