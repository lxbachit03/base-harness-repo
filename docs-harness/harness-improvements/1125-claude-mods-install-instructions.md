# Harness Improvement Resource

ID: #107_IMPROVE_HARNESS_1125
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Add per-mod instructions under claude-instructions/mods/ that ask the User before installing a mod
CREATED: 2026-11-25
STATUS: active
REFERENCES:
- docs-harness/claude-instructions/mods/README.md
- docs-harness/claude-instructions/mods/cache-watch.md
- docs-harness/claude-instructions/README.md
- docs-harness/INDEX.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

`docs-harness/claude-instructions/mods/` holds one instruction file per Claude Code mod
the User keeps, plus a README that a Claude Code session reads at session start. The
README has the session check which listed mods this machine lacks and ask the User once
whether to install them; a mod is installed only after the User's yes. The first mod is
`cache-watch` from the private marketplace `lxbachit03/claude-mods`.

## Purposes

- [x] Carry the User's mods to every machine that uses this Harness, so a new machine
  gets the same Claude interface (User request, 2026-11-25: "viết instructions vào trong
  này với mỗi mod").
- [x] Keep installation under User authority: ask first, never install unasked (User:
  "hãy hỏi user xem có muốn cài hay không? (không tự cài khi chưa có user authority)").
- [x] Keep the always-loaded cost small: only the README loads at session start; a mod's
  own file loads when it is needed.

## Current State

Baseline: `main` at `be230fa`, clean. The folder `claude-instructions/mods/` existed and
was empty. In this session the User built the `cache-watch` mod (prompt cache band with a
5-minute expiry warning and the `/cache-watch` toggle), pushed it to the private repo
`lxbachit03/claude-mods` (commit `1b573d7`), and had it installed at user scope with
`claude plugin marketplace add lxbachit03/claude-mods` and
`claude plugin install cache-watch@claude-mods --scope user`; `claude plugin list` showed
it enabled. No Harness file named any mod, so another machine had no route to it.
`claude-instructions/README.md` loads every Markdown file under the folder in every
Claude session.

## Proposed Improvement

- `mods/README.md`: the session-start check (`claude plugin list`), one question to the
  User for the missing mods, install only on a yes, and the mod list.
- `mods/cache-watch.md`: what the mod does, its source, install, verify, update and
  remove commands, and its limits.
- `claude-instructions/README.md`: per-mod files load through `mods/README.md`, not at
  session start.
- `INDEX.md`: `mods/` in the Folder Tree.

## Scope

Changes only the files above and this record's list entry. Installs, updates or removes
no plugin, and changes no settings.

## Progress

2026-11-25: record created; files written; harness check and diff inspected (see
Validation).

## Validation

- `python -I .agents/skills/harness-check/scripts/harness_check.py --quick`: RESULT line.
- Links from the new files and the README resolve; the Folder Tree lists `mods/`.
- Replay (pending): a fresh Claude Code session on this repository, with `cache-watch`
  uninstalled or the check simulated, asks one question before installing and installs
  nothing on a no.

## Risks

- Each Claude Code session runs `claude plugin list` once (a few seconds). Mitigation: the
  check runs only on hosts with the `claude` command and stops after one question.
- A declined install is asked again in the next session. Mitigation: the User can mark a
  mod's switch off in `mods/README.md`.
- A private marketplace needs a GitHub git credential on the machine; without one the
  install fails. The instruction says so before installing.

## Decision and Result

Pending fresh rerun. Implementation done; the behaviour (one question, no install without
a yes) has not been exercised in a fresh session. Next case: the replay in Validation,
owner the User's choice.
