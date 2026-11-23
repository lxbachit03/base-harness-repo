# Harness Improvement Resource

ID: #094_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add a code-graph skill and a Graphify catalog for projects with large codebases
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- docs-harness/tickets/active/TBD-code-graph-pilot-ygz/ticket.md
- docs/tools/graphify/README.md
- R&D/graphify-research/reports/Đánh giá dự án Graphify.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md

## Objective

A project that uses this Harness and has a large codebase can opt in to a local,
code-only code graph built by Graphify: the `code-graph` skill tells an agent how to set it
up (with the User's authority for the install), how to query it before reading many files,
and how to keep it fresh, the same way on Claude Code, Codex, OpenCode and Antigravity.
`docs/tools/graphify/README.md` holds the team-facing reference.

## Purposes

- [x] Cut the files an agent reads for cross-file questions (callers, impact, paths between
  modules) in large codebases; the User chose this use on 2026-11-23 ("Dùng cho các project
  áp dụng harness mà có codebase lớn").
- [x] Keep the Harness in charge of agent instructions: no third-party installer writes
  `AGENTS.md`, rules or hooks.
- [x] Keep code on the machine and token cost at zero for building the graph (code-only).

## Current State

Baseline: repository `E:\personal\base-harness-repo`, branch `main`, revision `62b7295`;
untracked `R&D/graphify-research/` (the research behind this record). The Harness has no
code-navigation capability beyond grep and file reads.

Evidence (R&D report, 2026-11-23): Graphify `0.9.115` builds code graphs locally with
tree-sitter (`--code-only`, no LLM), serves them over a local stdio MCP server
(`graphify-mcp`), and its installer writes `AGENTS.md`/rules and hooks that exist only on
Claude Code and Gemini CLI. Benefit is unproven: the vendor reports 71x fewer tokens, an
independent 360-run test found no clear gain and 17% more tokens with the Claude Code hook;
code-review-graph (MIT) reports 6.65x against a grep baseline. Two high-severity
advisories, the latest fixed in `0.9.115`.

The User decided on 2026-11-23 to write this into the Harness first and to run the pilot
later, once they grant authority for it ("Viết vào harness trước rồi chạy Pilot sau (khi có
user authority)").

## Proposed Improvement

Add a backend-neutral `code-graph` skill (Graphify first, code-review-graph as the
fallback backend) with setup and pilot references, and a Graphify catalog page; list them
where the Harness lists skills and tool catalogs. `init-harness-repo` is left unchanged,
because its interview is owned by `docs/raw-requirements/skills/init-harness-repo.json`.

## Scope

May change: `.agents/skills/code-graph/` and its `.claude/skills/` mirror,
`docs/tools/graphify/README.md`, `docs/README.md`, the skill list in
`docs/tools/claude/README.md` section 7.3 and its derived `README.html`, this record and
its list entry. No install, no MCP or settings change in this repository, no pilot run.

## Progress

2026-11-23: record created. Added `.agents/skills/code-graph/` (`SKILL.md`,
`references/setup.md`, `references/pilot.md`) and its mirror, `docs/tools/graphify/README.md`,
the `docs/README.md` entry, and `code-graph` in the Claude catalog skill list (21 skills, 73
mirrored files) with `README.html` rebuilt. `init-harness-repo` left unchanged: its
interview is owned by `docs/raw-requirements/skills/init-harness-repo.json`.

## Validation

`harness_check.py` full run; mirror; links; a fresh replay that uses only the skill to
answer a setup question and a query question for a hypothetical large project.
Effectiveness needs the pilot in `references/pilot.md`.

## Risks

Graphify moves fast and its savings are unproven. Mitigation: pinned version, code-only,
local MCP only, graph treated as a hint with files read before edits, a backend-neutral
skill, and a pilot gate before any project relies on it.

## Decision and Result

Decision: remove the skill (2026-11-23, after the pilot); keep the catalog as reference.

Earlier decision, superseded: keep the written skill and catalog; pending the pilot.

Checks: `harness_check.py` full run `RESULT: clean (exit 0)` (94 IDs, 1115 links, 21 skills
and 73 files identical across the mirror); new files CRLF like their neighbours.

Fresh replay 1 (general-purpose subagent, skill files only, four scenarios: stale graph
query, set-up request, docs-only harness repo, a teammate proposing `graphify install`):
behaviour correct in all four. It listed twelve ambiguities; the revision defined freshness
and uncommitted edits, made the rebuild permission an explicit constraint answer, stated
that a set-up request is not install authority and that non-User suggestions grant none,
merged the install-or-pilot choice into one question, softened the Markdown rule to advice,
preferred project-scoped MCP files, and said where host catalogs live.

Fresh replay 2 (rerun of the affected cases): correct for a stale graph under "may not",
for the one set-up question, and for a global Codex config file. Its remaining notes were
applied: a stale graph may only suggest places to check, pin the latest release (at least
`0.9.115`), the User picks the rebuild trigger and the rebuild permission in one question,
and the query-log variable goes into each MCP entry and the CLI shell.

Not attempted: the pilot (`references/pilot.md`), which needs the User's authority and a
real large project; until it runs, Graphify's benefit, the exact `graphify-mcp` argument
for the graph path, whether `graphify update .` stays code-only, and Codex's project-scoped
`.codex/config.toml` stay unverified. Next case: the pilot on a project the User names;
owner: the primary session, once the User authorizes it. STATUS stays active until then.

Pilot round 1 (2026-11-23, ticket `tickets/active/TBD-code-graph-pilot-ygz/`): YGZ-Microservices-Multitenancy
(about 1,445 code files, C# and TS), `agy` `1.5.14` print mode with `claude-sonnet-5-5-medium`, 5
questions x 3 arms, prompts without any graph hint. All 15 runs found every expected file; no
run called the graph (shell search only, 2-4 calls); tokens in+out: baseline 125,772, Graphify
121,978, code-review-graph 118,678 (noise, the graph was not used). Under the pilot rule neither
backend passes for unprompted use on this host. Verified on the way: `graphify-mcp <graph.json>`
and `code-review-graph serve --repo <path>` work as MCP stdio servers in `agy` through the
workspace `.agents/mcp_config.json`; headless `agy` denies MCP calls without
`--dangerously-skip-permissions`; `graphify update` needs no LLM; the two packages conflict and
need separate environments. Pilot round 2 (same day, prompt carrying the constraint text, graph arms only): agents did call
the graph (Graphify 9 calls, code-review-graph 7) but spent more: on q1-q4, where every arm was
4/4 correct, tokens in+out were baseline 97,265, Graphify 195,676 (+101%), code-review-graph
163,909 (+69%); q5 failed in both arms on the `agy` third-party quota (HTTP 429). Under the pilot
rule the outcome for this project is drop (ticket decision `11-23-pilot-outcome.md`, proposed).
The User accepted drop and the cleanup on 2026-11-23 (venvs, clone, graphs and the tool caches
the pilot created removed; the logs kept at `E:\personal\pilots\results`). Next: the User
decided to remove the skill ("Gỡ skill", 2026-11-23).

Removal (2026-11-23, through `improve-harness`): deleted `.agents/skills/code-graph/` and its
`.claude/skills/` mirror (recoverable from commit `98a9842`); the Claude catalog skill list back to
20 skills and 70 mirrored files with `README.html` rebuilt; `docs/tools/graphify/README.md` now
opens with the pilot result and stays as reference for a later re-evaluation (multi-hop questions,
another host); the `docs/README.md` entry says the skill was removed; the ticket and its decisions
point to the skill's pilot protocol by path and commit instead of a link. The User's goal (code
navigation for projects with large codebases) stays open; on this evidence, shell search in the
agent is the cheaper path.
