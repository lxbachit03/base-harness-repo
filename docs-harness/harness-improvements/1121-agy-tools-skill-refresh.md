# Harness Improvement Resource

ID: #087_IMPROVE_HARNESS_1121
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Refresh the utilizing-tools-agy skill and docs/tools/antigravity from five agy workers run through the Herdr desktop app
CREATED: 2026-11-21
STATUS: completed
REFERENCES:
- .agents/skills/utilizing-tools-agy/SKILL.md
- .claude/skills/utilizing-tools-agy/SKILL.md
- docs/tools/antigravity/README.md
- docs-harness/HERDR-APP.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

`utilizing-tools-agy` and `docs/tools/antigravity/README.md` list the built-in tools,
MCP servers, plugins, skills, subagent modes and slash commands of Antigravity (`agy`
1.5.x) as they stand on 2026-11-21, each entry traced to what at least two of five `agy`
workers saw in their own session or to the official documentation.

## Purposes

- [x] Keep the AGY tool router honest against the current runtime, so a session using the skill
  names tools, plugins and skills that exist, as the User asked on 2026-11-21 ("up-to-date
  đến thời điểm hiện tại").
- [x] Keep the team-facing Vietnamese reference in `docs/tools/antigravity/` consistent with
  that skill, as the User asked on 2026-11-21.
- [x] Use the Herdr desktop app way of `HERDR-APP.md` for the research, with models
  hydrogen, neon, argon and the two Orchestrators, as the User chose on 2026-11-21.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at revision `c7aa668`, with an
uncommitted change in `docs-harness/HERDR-APP.md` that belongs to another session (it marks
`gemini-4-hydrogen-high`); this record does not touch it. The two copies of the skill are
identical (`diff -rq` empty), 141 lines. The README is 156 lines, Vietnamese, and states 13
built-in tools, 3 plugins (`chrome-devtools-plugin`, `modern-web-guidance-plugin`,
`google-antigravity-sdk`), the `builtin` skills and four slash commands. Its provenance and
date are not stated in the file. `hc server status` answers (core `desktop-85n4d20`,
`hc 0.1.21`), `herdr-app status` answers, and `agy models` lists all five chosen IDs.

Request: the User asked for deep research on the built-in tools, skills, MCP servers and
plugins of Gemini/Antigravity through the Herdr desktop app, with the models hydrogen, neon,
argon and Orchestrator (Neon, Argon), then an update of the skill and the docs. The User chose
one common brief for all five workers with cross-checking, effort high, and a cross-check
table plus `harness-check` as proof, with no fresh replay.

## Proposed Improvement

1. Five workers, one `herdr-app` space each, `gemini-4-hydrogen-high`,
   `gemini-4-neon-high`, `gemini-4-argon-high`, `gemini-pro-orchestrator-neon` and
   `gemini-pro-orchestrator-g1-pro`, receive the same read-only brief: part A lists what their
   own session exposes, part B checks the official documentation, and only then compare with
   the two existing files.
2. Merge the five reports into a cross-check table. An entry seen by at least two workers or
   confirmed by official documentation is stated as fact; an entry seen by one worker is
   written as conditional.
3. Update both copies of the skill and the README from that table.

## Scope

May change: the two skill copies, `docs/tools/antigravity/README.md`, this record and the
`harness-improvements/README.md` line. May not change: `HERDR-APP.md` (including the other
session's uncommitted change), `HERDR-TUI.md`, `GOAL.md`, any commit, push or staging, the
User's own spaces and tabs. Workers write no repository file and receive the `Skip` Harness
context choice (the brief names its files; the task carries the limits), a cost choice made
for the User to confirm.

## Progress

- 2026-11-21: Record created before edits; gate checked (core, app, models).
- 2026-11-21: Started five spaces in the User's open app window (`space.new --argv`, no
  `--task`, `--focus false`): `agy-4-hydrogen-high` t5, `agy-4-neon-high` t6,
  `agy-4-argon-high` t7, `agy-pro-orchestrator-neon` t8, `agy-pro-orchestrator-g1-pro` t9,
  and sent each the same brief by `hc send` (the brief sits in a scratchpad file; the
  message names its path). t7 and t8 stopped at a File access dialog (read of
  `~/.gemini/config/mcp_config.json`, outside the workspace); the User answered both, not
  this session. All five finished with `status: done` and a report between
  `BEGIN-REPORT` and `END-REPORT`; `git status` showed no change from the workers.
- 2026-11-21: Rewrote both copies of the skill (identical, CRLF) and
  `docs/tools/antigravity/README.md` from the cross-check below. Nothing is committed or pushed.
- 2026-11-21: The User asked about the commands behind `/`. The five reports had only the nine
  prompt-level commands, so I opened `/help` and the `/` menu in worker t5 (hydrogen, idle; UI
  only) and scrolled all of it, then rewrote README 5.1. A first `hc send "/help"` from Git
  Bash was turned into `C:/Program Files/Git/help` (MSYS path conversion) and reached the model
  as a prompt: one short, harmless answer from t5, interrupted with `hc interrupt`; later sends
  used `MSYS_NO_PATHCONV=1`. t5's input was cleared afterwards.

## Validation

Cross-check of the five reports (h = hydrogen-high, n = neon-high, a = argon-high, On =
Orchestrator Neon, Oa = Orchestrator Argon; "docs" = official pages or `agy changelog` cited by
a worker). Every entry is exposed in the session or confirmed by a cited page.

| Entry | h | n | a | On | Oa | docs | Written as |
| :--- | :-: | :-: | :-: | :-: | :-: | :-- | :--- |
| 14 tools: `read_file`, `write_file`, `edit_file`, `run_command`, `manage_task`, `schedule`, `search_web`, `ask_question`, `invoke_subagent`, `define_subagent`, `manage_subagents`, `send_message`, `run_workflow`, `swarm` | yes | yes | yes | yes | yes | changelog 1.5.9, 1.5.13 | fact |
| `exit_plan_mode` | no | no | no | yes | yes | n/a | conditional (Orchestrator, Plan Mode) |
| `view_file`, `write_to_file`, `replace_file_content`, `list_dir`, `grep_search`, `read_url_content`, `generate_image` | absent | absent | absent | absent | absent | 1.2.7 retired the search tools, 1.2.16 moved image generation to `image-generator` | fact: not exposed |
| 3 plugins enabled, 0 MCP tool: `chrome-devtools-plugin` 1.10.1, `modern-web-guidance-plugin` 1.0.0, `google-antigravity-sdk` 0.0.9 | yes | yes | yes | yes | yes | plugins.md | fact |
| Plugin skills listed bare, without `<plugin>:` | yes | yes | yes | yes | yes | docs: qualified only on name clashes | fact |
| 30 skills (5 builtin, 9 plugin, 16 repository), plugin skill `cookie-debugging` is the sixth of chrome-devtools | yes | yes | yes | yes | yes | n/a | fact |
| Slash commands `/goal /compact /schedule /browser /plan /grill-me /teamwork /learn /boost` and `/swarm` | yes | yes | yes | yes | yes | reference.md, changelog | fact |
| Subagent types `self`, `research`, `image-generator`; `Workspace` and `Model` values | yes | yes | yes | yes | yes | features.md | fact |
| Sandbox default (no network, workspace only), `--mode accept-edits\|auto\|plan` | yes | yes | yes | yes | yes | sandbox.md, permissions.md | fact |
| Global `mcp_config.json` empty (0 bytes) | denied | denied | read | read | denied | n/a | fact (two readers) |
| MCP: Stdio and Streamable HTTP, no HTTP+SSE; three config locations | n/a | cited | cited | cited | cited | mcp.md | fact (docs) |
| Hooks: 6 events; rules 24 KB per file, 20,000-token budget; `.agentrules` no longer used | cited | cited | cited | cited | cited | hooks.md, rules.md | fact (docs) |
| `/` menu: 80 entries (38 CLI commands, 9 prompt-level, `/swarm`, skills as `/<skill>`; plugin skills qualified `<plugin>:<skill>`; model-hidden skills included) | live read | not read | not read | not read | not read | `/help` in the same session | fact (one session; last 2 entries unseen) |
| Subagent `browser` (changelog 1.5.1) | no | no | no | docs only | no | changelog | conditional, not in README tables |

Native checks: `diff -r` of the two skill copies is empty; `harness-check` result below.
Not run: a fresh replay of the skill (the User chose not to spend the quota) and a page-by-page
read of `antigravity.google/docs` (the workers' sandbox had no network).

## Risks

- The five workers spend the User's Gemini quota. Mitigation: effort high, one brief each,
  no second round unless a gap blocks the edit.
- A worker may describe a documented tool its session does not expose. Mitigation: part A
  asks for what the session exposes before it reads the docs, and a single-worker claim is
  written as conditional.

## Decision and Result

Decision: keep. The skill's Phase 1 table now names the tools the five sessions exposed
(`read_file`, `edit_file`, `write_file`, `run_command` for listing and search, `run_workflow`,
`swarm` behind `/swarm`, `image-generator` for images), says plugin skills may appear bare, and
warns that an enabled plugin gave no MCP tool. The README keeps the structure and the
Vietnamese text, corrects the 13-versus-16 count and the old names, adds the missing tools,
skills, slash commands and sandbox rules, and marks one-source entries as conditional.

Observed, not changed: the brief told the workers to skip `AGENTS.md` and the INDEX, but the
Argon and Orchestrator Neon workers read the INDEX and the constraints anyway (the repository
loads `AGENTS.md` into an `agy` session), which spent quota beyond the plan. Two workers also
ran `harness_check.py --quick` (read-only). The reports' tool lists may describe the CLI
surface only; the IDE and App 2.0 surfaces were not checked.

Remaining proof, not required: a fresh `agy` session that follows the updated skill, and the
IDE surface. The five spaces stay open in the User's window for the User to review.
