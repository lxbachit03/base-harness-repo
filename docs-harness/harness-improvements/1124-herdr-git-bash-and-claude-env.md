# Harness Improvement Resource

ID: #102_IMPROVE_HARNESS_1124
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Herdr app: send slash commands from Git Bash and clear inherited Claude variables
CREATED: 2026-11-24
STATUS: completed
REFERENCES:
- docs-harness/HERDR-APP.md

## Objective

`HERDR-APP.md` section 2 tells the agent to send a text that starts with `/` from Git
Bash with `MSYS_NO_PATHCONV=1`, and to clear inherited `CLAUDE*` variables in an `hc`
terminal before it starts `claude` there.

## Purposes

- [x] Keep a slash command such as `/exit` a command: Git Bash rewrote it into a path
  and the agent received it as a prompt, which spent the User's quota (User request,
  2026-11-24).
- [x] Let `claude` started in a Herdr terminal run as an ordinary terminal session, so
  Code Mode can turn on and transcripts are saved (User request, 2026-11-24).

## Current State

Baseline: `main` at `c38c801`, clean; `hc 0.1.22`, Claude Code v2.1.331, Windows,
Claude Desktop session using Git Bash. The User asked to test Code Mode in the Herdr
desktop app. Observed on 2026-11-24 in a new space (`herdr-app do space.new`,
terminal `t2s`):

1. `$env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = '1'; claude` printed "Code Mode
   (experimental) isn't available … not in cloud, remote, or prewarmed sessions" and
   "Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker".
2. The shell held 33 `CLAUDE*` variables of a Claude Desktop session, among them
   `CLAUDECODE`, `CLAUDE_CODE_CHILD_SESSION` and `CLAUDE_CODE_ENTRYPOINT`. Their source
   (the core, the app, or the `herdr-app` call from Claude Desktop) is unverified.
3. `hc send t2s "/exit"` from Git Bash arrived as `C:/Program Files/Git/exit`; the
   running `claude` treated it, and the next command, as prompts.
4. With `MSYS_NO_PATHCONV=1` the `/exit` worked. After removing every `CLAUDE*`
   variable except the Code Mode switch in that shell, `claude` printed "Code Mode
   (experimental) is on".

## Proposed Improvement

Add two items to the section 2 gate of `HERDR-APP.md`.

## Scope

Changes: `HERDR-APP.md` section 2, this record, the improvements README. Not changed:
the User's `hc` core, `~/.config/herdr-app`, the TUI file, worker choices.

## Progress

2026-11-24: record created; two gate items added; `harness_check.py` run (see
Validation). Fresh replay run and passed (see Decision and Result).

## Validation

Native: `python -I .agents/skills/harness-check/scripts/harness_check.py` and a diff
review: clean, 102 IDs. Behavior: the four steps under Current State ran live in the
User's app before the edit; a fresh replay ran after it (see Decision and Result).

## Risks

- Clearing `CLAUDE*` also drops variables the User set on purpose. Proposal: the item
  clears first and then sets the wanted ones, such as the Code Mode switch.
- The variables' source is unverified, so the item states the observation, not a
  cause. Proposal: check a terminal the User starts in the app from a fresh core.

## Decision and Result

Keep. Replay on 2026-11-24 (User go-ahead): a fresh Haiku 5.5 Explore subagent, effort
high, read only `HERDR-APP.md`, ran no commands, and planned how to exit a `claude` in
`hc` terminal `t9` from Git Bash and restart it with Code Mode. Pass criteria: it sends
`/exit` with `MSYS_NO_PATHCONV=1` and clears `CLAUDE*` before it sets the Code Mode
variable and starts `claude`. Observed: both met, citing section 2 items 4 and 5; it
also read the screen after `/exit` before sending shell text, and gave no worker
permission flag to this non-worker start.

Limits: a planning replay, not an execution; the variables' source stays unverified.
Gaps it named, left open as outside this change: no stated check that Code Mode is on
(the banner line), and no status signal for a Claude exit beyond reading the screen.
