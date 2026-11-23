# Harness Improvement Resource

ID: #093_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Refresh the Claude Code catalog against the 2026-11-23 Desktop host
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- docs/tools/claude/README.md
- docs/tools/claude/README.html
- .agents/skills/utilizing-tools-claude/SKILL.md
- docs-harness/harness-improvements/1115-claude-catalog-refresh.md

## Objective

`docs/tools/claude/README.md` (and its derived `README.html`) describes the Claude Code
surface that the current Desktop host exposes on 2026-11-23, with each changed claim dated
and labeled by evidence class, and `utilizing-tools-claude` routes a known URL to the
capability the session actually has.

## Purposes

- [x] Let an agent or a teammate pick the right tool for web reading and delegation without
  trusting a tool list that the host no longer exposes; the User asked on 2026-11-23 after
  finding `web-fetch` missing from the catalog ("Hãy deep research lại để up-to-date tài
  liệu trên").
- [x] Keep the catalog's provenance discipline from `#067`: every volatile table names its
  host, binary, date and evidence class.

## Current State

Baseline: repository `E:\personal\base-harness-repo`, branch `main`, revision `e1dcbf2`,
clean worktree. The catalog pins host `2.1.325` and PATH CLI `2.1.268` with evidence of
2026-11-15 (`#067`).

Observed on 2026-11-23 in this Claude desktop app session (Claude Opus 5.5):

- Host folders `claude-code/2.1.328` and `2.1.330` exist; `claude --version` on PATH
  returns `2.1.304`.
- The agent list has `web-fetch` (tool: WebFetch), absent from catalog section 8; the
  `claude-security:*` plugin agents are absent.
- `WebFetch` is neither loaded nor deferred, while sections 1, 3 and 11 and the skill route
  known URLs to a deferred `WebFetch`.
- Deferred list: new `PublishPlugin`; absent `WebFetch`, `ListMcpResourcesTool`,
  `ReadMcpResourceTool`, `ReadMcpResourceDirTool`, `FetchInboxMessage`, `SendToProject`,
  `SendToProjectContext`.
- Loaded tools now include `Workflow` and `ShareOnboardingGuide` in the Desktop session
  (catalog: CLI-only).
- MCP servers new to the session: a certified-queries server, Claude Meetings, `ccd_turn`,
  and the `productivity` plugin servers (six need authentication, `asana` failed).
- Skill listing: plugins `productivity` (4 skills) present; `postman`, `desktop-commander`,
  `pdf-viewer`, `cowork-plugin-management`, `frontend-design`, `skill-creator` absent;
  user skill `taste-skill` new; repo skills `utilizing-tools-agy`, `-codex`, `-opencode`,
  `-orca-ade` are model-invoked on disk but missing from the listing.

## Proposed Improvement

Collect local evidence (host and PATH binaries, `--help` surfaces, `claude mcp list`,
`claude plugin list`/`details`, `settings.json` keys) and official evidence (changelog after
`2.1.325`, tools reference, subagents, commands pages); update the affected catalog
sections, the provenance table and the skill's version boundary and web row; mirror the
skill; rebuild `README.html`.

## Scope

May change: `docs/tools/claude/README.md`, `docs/tools/claude/README.html`,
`.agents/skills/utilizing-tools-claude/SKILL.md` and its `.claude/skills` mirror, this
record and its list entry. No settings, plugin, MCP or account change; no install.

## Progress

2026-11-23: record created from the session observations above.

2026-11-23: evidence collected.
- Local: running host `claude.exe` is `claude-code\2.1.330`; PATH `2.1.304`; npm
  `latest`/`next` `2.1.330`, `stable` `2.1.323`. Both binaries: 18 subcommands, 11 `mcp`,
  66 identical flags; `plugin` 17 (`2.1.330`) vs 16 (`2.1.304`, no `restore-set-aside`).
  `claude mcp list` and `claude plugin list` empty on both; two marketplaces; 317 catalog
  plugins; `~/.claude/plugins/cache/` and `installed_plugins.json` gone; `settings.json`
  keys recorded. Repository `.claude/settings.local.json` (commit `14235a6`) sets
  `skillOverrides` to `"off"` for the four non-Claude `utilizing-tools-*` skills, which
  explains their absence from the listing.
- Official, read through three `web-fetch` subagents: tools reference (53 rows, WebFetch
  still listed, no `PublishPlugin`), sub-agents (built-in `web-fetch`, Haiku), commands
  (first 81 rows verbatim, match), skills (load locations), changelog `2.1.280`-`2.1.330`
  (partly summarized; several version headings not seen). `PublishPlugin` described from
  its own schema loaded through `ToolSearch`.

2026-11-23: updated the catalog header and sections 1, 2, 2.5, 3, 4.2, 5.1, 5.2, 6, 7.1,
7.2, 7.3, 8, 9 (intro, 9.1-9.5, 9.7 deltas), 10.1, 11 and 14; the skill's version
boundary, web row, plugin and skill discovery lines (mirrored); the `docs/README.md`
entry. Rebuilt `README.html` with a scratch converter that first reproduced the old
`README.html` byte for byte from the old `README.md`.

## Validation

`harness_check.py` full run; table column counts; line endings of changed files; the
mirror; a fresh replay that answers "how do I read a known URL here" and "which agents
exist" from the updated catalog and skill.

## Risks

The host updates itself (two versions appeared within eight days); the refreshed tables go
stale again. Mitigation as in `#067`: dated rows, evidence classes, reproducing commands.

## Decision and Result

Decision: keep.

Checks: `harness_check.py` full run `RESULT: clean (exit 0)` (93 IDs, 1104 links, 20
skills and 70 files identical across the mirror); catalog 956 of 956 lines CRLF, skill
186 of 186; every catalog table row has its header's column count (the one mismatch the
script reported is the ASCII diagram inside a code block, whose lines are all 85 wide);
`README.html` source hash matches the README, no broken in-page anchors.

Fresh replay 1 (general-purpose subagent, read only the skill and the catalog): three
questions (known URL, agent types, why `utilizing-tools-codex` is missing). Agent types
and the `skillOverrides` cause matched its session. The URL answer exposed a defect: the
subagent had `WebFetch` deferred, while the catalog said the Desktop session has none.
Revised: the main conversation lacks `WebFetch`, its subagents keep it deferred.

Fresh replay 2 (rerun of the URL case after the revision): correct for the main
conversation (`web-fetch`), for a subagent (`WebFetch` after `ToolSearch`) and for sign-in
pages (built-in browser), and it matched the subagent's own tool list. It noted two gaps,
then added: `gh` or an authenticated MCP tool for private sources, and Claude in Chrome
when the User asks for it.

Limits: the changelog and the later parts of tools-reference and skills were partly
read through summaries; the condition under which the host swaps `WebFetch` for
`web-fetch`, the plugin load source of the Desktop session, and a plain CLI `2.1.330`
tool count stay [UNKNOWN] in catalog section 14. Section 9.7 rows after `/rename` were
not re-read verbatim. One run per replay case.
