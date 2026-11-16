# Harness Improvement Resource

ID: #067_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Refresh the Claude Code catalog and routing skill to the 2026-11-15 runtime
CREATED: 2026-11-15
STATUS: active
REFERENCES:
- docs/tools/claude/README.md
- docs/README.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .claude/skills/utilizing-tools-claude/SKILL.md
- docs-harness/SESSION.md
- docs-harness/JEV-AI.md
- docs-harness/harness-improvements/0921-utilizing-tools-claude-capability-catalog.md
- docs-harness/harness-improvements/0921-utilizing-tools-skill-parity.md
- docs-harness/harness-improvements/1115-jev-trigger-and-fixture-cleanup.md

## Objective

`docs/tools/claude/README.md` and the `utilizing-tools-claude` skill describe
the Claude Code runtime as it is on 2026-11-15: the app host `2.1.325` and the
`claude` on PATH `2.1.268`, each claim dated and labeled by evidence class. No
claim that the current runtime, the official documentation or the repository
contradicts remains, and role and authority claims point to
`docs-harness/SESSION.md`.

## Purposes

- [x] Make the catalog's runtime claims reproducible on the current machine, with the binary or host that produced each one named.
- [x] Keep the catalog and `utilizing-tools-claude` agreeing on the version boundary, skill load paths, MCP authority and the Jev trigger.
- [x] Point role and authority claims to their current owner instead of `AGENTS.md`.
- [x] Keep the volatile tables cheap to maintain by dating them and naming the command that re-measures each.

## Current State

Baseline (2026-11-15 21:50, Asia/Bangkok): `D:/repos/base-harness-repo`,
branch `main` at `1a002a6`, four commits ahead of `origin/main`, worktree
clean. `harness-check` full run: RESULT clean (66 IDs, 958 links in 132
Markdown files, 18 skills and 36 files identical across the mirror, 21 folders
with README).

Request: the User asked whether the catalog is out of date, then asked to bring
it and `utilizing-tools-claude` up to date after a read-only review.

Observed gap, from read-only checks of 2026-11-15:

- Version: the catalog and the skill pin `2.1.278` (evidence of 2026-09-21).
  The app host that runs the session is `2.1.325` (npm `latest`; `stable` is
  `2.1.311`) and `claude --version` on PATH is `2.1.268`. The two binaries
  disagree on `claude plugin list` (`postman` enabled vs disabled) and on
  `claude plugin marketplace list` (one marketplace vs two).
- State tables no longer reproduce: `claude mcp list` shows one server (PATH) or
  none (app) against 25 recorded; the installed plugin is `postman` 2.3.0, not
  `productivity@synced`; `~/.claude/plugins/synced/` does not exist and plugins
  live under `cache/` with `installed_plugins.json`; the catalog holds 317
  plugins, not 310; `settings.json` shares 3 of the 7 recorded keys.
- CLI surface at `2.1.325`: `project` is gone and `purge` (deletes project data)
  is new; `claude plugin` has 17 subcommands, not 14 (`configure`,
  `restore-set-aside`, `test`); `attach` and `logs` accept a session name.
- Repository drift: `.agents/skills` and `.claude/skills` are byte-identical,
  not "different in line endings"; 18 skills exist and 4 are user-invoked
  (`harness-check` and `prd-research` are missing from the lists); the session
  role and task authority sit in `docs-harness/SESSION.md`, not `AGENTS.md`;
  section 10 numbers its subsections 9.1 and 9.2.
- Official documentation (`code.claude.com`, 2026-11-15): the tools reference
  lists 46 tools (`TaskOutput` removed in `2.1.277`), 11 active ones missing from
  the catalog; the skills page lists no `.agents/skills` load path.
- Skill: version boundary `2.1.278`; "`claude mcp list` is the authority" omits
  the servers a Desktop host exposes itself; `.agents/skills` is named as a load
  path; the Jev row routes "semantic judgment" to `typesafe-ai` although
  `docs-harness/JEV-AI.md` limits Jev to explicit User requests (#065).

Limits of the evidence: no plain CLI `2.1.325` session was available to recount
the built-in tools; the changelog was read only for `2.1.319`-`2.1.325`;
`.agents/skills` loading was not tried in a live session.

## Proposed Improvement

Re-measure each volatile claim on both binaries and against the official
documentation, restate it with its date and evidence class (catalog section
14), and correct the stale ones: version stamps, MCP and plugin state, plugin
paths, CLI tables, skill lists and load paths, role and authority pointers,
section numbering, and the tool inventory (host-dependent counts, conditional
tools). Update `utilizing-tools-claude` where it repeats a stale claim, and
mirror it.

Hypothesis: naming the host, the binary and the evidence date for each table
keeps the catalog true until the next release and exposes a mismatch when the
CLI and the host differ. Contrary evidence: a later release, host or account
changes the surface again; a reader treats the catalog as current without
re-running the commands; the skill and the catalog drift apart. Owner: catalog
section 14 and the skill's version boundary. Revise when the host or the CLI
changes, or when the User wants the catalog to follow the official
documentation alone.

## Scope

May change: `docs/tools/claude/README.md` and its derived `README.html`, its
entry in `docs/README.md`, `utilizing-tools-claude` and its `.claude` mirror,
this record and its list entry.

Unchanged: the other `docs/tools/` guides and `utilizing-tools-*` skills (the
agy, codex and opencode skills carry the same Jev row, left for a separate
decision), `docs/raw-requirements/`, the `harness-check` script and INDEX. No
commit or push without the User's approval.

## Progress

- 2026-11-15: Baseline captured; record created and listed before intervention
  edits.
- 2026-11-15: Re-measured on both binaries (`--version`, `--help`,
  `mcp --help`, `plugin --help`, `mcp list`, `plugin list`,
  `plugin marketplace list`, `plugin details postman`), the local plugin
  directory, the `settings.json` key names and the official pages (tools
  reference, skills, plugin loading, CLI reference, changelog `2.1.319`-`2.1.325`,
  npm dist-tags). Updated the catalog: version stamps and a two-binary note; the
  tool inventory with host-specific and conditional tools; MCP and plugin state;
  plugin paths; skill load paths and lists; delegation and authority pointers;
  the CLI tables for `2.1.325`; section 10 numbering and keys; the provenance
  table with a [DOCS] class. Updated the `docs/README.md` entry and the skill
  (version boundary, MCP authority and CLI-binary note, skill load path, Jev
  row), and mirrored the skill.
- 2026-11-16: At the User's request, added section 9.7 (the official
  slash-command table, 121 rows, in nine groups, with the Desktop differences)
  to the catalog. Corrected section 9.5: skills are slash commands, and the
  `--disable-slash-commands` wording differs between `2.1.268` and `2.1.325`.
  Added the evidence row to section 14. Rebuilt the derived `README.html` and
  added the same section to the design artifact built from the catalog.
- 2026-11-16: At the User's request, linked the design artifact from the
  catalog header (`README.md`) and from the rebuilt `README.html`, where
  external links open in a new tab. The artifact is private, so the link opens
  only after its owner shares it.

## Validation

- `harness-check` full run after the edits: RESULT clean (exit 0). 67 unique IDs
  `#001`-`#067`; 960 local links in 133 Markdown files resolve; 18 skills and 36
  files identical across the mirror; 21 folders with README.
- SHA-256 comparison of `.agents/skills` and `.claude/skills`: 36 files, 0
  differences.
- Line endings are consistent in every changed file (catalog 758 of 758 CRLF,
  skill 182 of 182, `docs/README.md` 18 of 18, record list 86 of 86).
- Catalog tables: 26 tables, every row has its header's column count.
- Remaining `2.1.278` mentions in the catalog are four dated notes about the
  2026-09-21 CLI session; remaining `AGENTS.md` mentions are the generic
  rule/instruction row and the provenance row that names it as the entry point.
- Figures stated in the catalog (317 catalog plugins; 17 and 14 `plugin`
  subcommands; 18 `claude` and 11 `mcp` subcommands; 19 Postman skills; 45
  documented tools; 36 mirrored files) come from those runs.
- 2026-11-16, after adding section 9.7: `harness-check` full run RESULT clean;
  the catalog has 35 tables and every row has its header's column count;
  section 9.7 covers the 121 rows of the official commands table (98 table
  rows, some listing two or three commands); `README.html` was rebuilt from the
  updated README. The counts (20 bundled skills, 1 workflow, 3 removed
  commands) come from the official page read on 2026-11-16.

Unattempted: a fresh-session replay that selects capabilities from the updated
catalog and skill; a plain CLI `2.1.325` session to recount the built-in tools;
the changelog for `2.1.279`-`2.1.318`.

## Risks

- The volatile tables go stale again. Mitigation: each is dated, labeled by
  evidence class and paired with the command that reproduces it.
- Two hosts (CLI and Desktop) make one list wrong for the other. Mitigation: the
  catalog labels host-specific rows and says where only one host was observed.
- The official documentation and the session disagree. Mitigation: rows carry
  [DOCS] or [SESSION], and unverified items stay [UNKNOWN].

## Decision and Result

Decision: keep; pending a fresh rerun. The catalog and the skill match the
2026-11-15 evidence and `harness-check` stays clean. Whether a fresh agent picks
capabilities correctly from them is unverified.

Next case: in a disposable copy, a fresh session reads the skill and the catalog
and selects capabilities for three tasks: (1) report MCP and plugin state, (2)
read and summarize a PDF, (3) a task that tempts a Jev consult. It then shows
that it names the binary or host behind any `claude mcp list` or
`claude plugin list` output, treats the session's tool surface as the evidence
for host-exposed MCP servers, and consults Jev only when the User names it. The
run can share a session with the pending cases of `#063`, `#065` and `#066`.
Owner: the primary (Bale) session, when the User authorizes the rerun.
