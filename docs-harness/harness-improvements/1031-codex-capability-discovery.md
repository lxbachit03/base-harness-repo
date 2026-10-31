# Harness Improvement Resource

ID: #053_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Make Codex capability discovery work across sessions
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-improvements/0921-utilizing-tools-skill-parity.md
- .agents/skills/utilizing-tools-codex/SKILL.md
- .claude/skills/utilizing-tools-codex/SKILL.md
- https://developers.openai.com/codex/skills
- https://developers.openai.com/codex/mcp

## Objective

Improve the Codex capability-routing skill and its mirror so an agent can
declare and use capabilities exposed by the actual session, including deferred
discovery, while preserving the mandatory declaration and existing authority.

## Purposes

- [x] Avoid directing an agent toward tool names unavailable in its session.
- [x] Make discovery possible without omitting the User-facing capability table.
- [x] Keep skill selection, tool execution, permission, and verification aligned.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, HEAD `e62c2d9`; the only
unrelated worktree item is the untracked #012 plan. Both Codex skill copies are
byte-identical. This session exposes `functions.exec` with `exec_command`, and
`collaboration` subagent tools; the skill's preferred table instead names
`shell_command`, `multi_agent_v1`, and `update_plan`, none of which is exposed
under those names here. This demonstrates session-specific drift, not their
absence from every Codex host.

The skill also requires capability discovery before selection while forbidding
tool calls before the capability table, without describing how to declare a
discovery tool first and add later-discovered tools. The User explicitly asked
to review and enhance this skill using current runtime and OpenAI documentation.
The currently exposed tools contain no dedicated OpenAI documentation MCP; the
official documentation was read from the OpenAI site instead. The hook is off.

## Proposed Improvement

Replace brittle preferred tool names with capability roles resolved from the
session's exposed definitions; make deferred discovery and incremental table
updates explicit; and distinguish app discovery, MCP resources, and authority
to delegate. Keep actual tool names in the User-facing table once discovered.

Hypothesis: a session can use its own tool names, execute a discovery-first
task, and preserve the table and authority contract. Contrary evidence is a
replay that invokes an unavailable name, omits the declaration, guesses an app
connection, or treats tool availability as permission. The two skill copies
own this routing; revisit if an exposed host capability needs a more specific
documented route.

## Scope

The Codex skill and its `.claude` mirror, this record, and its INDEX route.
Preserve the User-owned raw requirements, other platform skills, existing
workspace changes, mandatory capability table, and AGENTS.md authority.
Do not stage, commit, push, install dependencies, or change global settings.

## Progress

- 2026-10-31: Inspected baseline, mirrored skill, session tool metadata, local
  `codex-cli 0.163.0`, prior #027 routing history, and official Codex skills and
  MCP documentation. Identified the two discovery and naming gaps above.
- Updated both skill copies to route by exposed capability, declare discovery
  before use, distinguish app discovery from MCP resources, and respect the
  session's delegation boundary. Kept the capability table contract in the
  description and body.
- The first fresh replay declared its table after mandatory session-start reads
  and before subsequent calls. Its initial discovery example did not use a
  newly discovered tool. A cold-start replay also retrieved instructions before
  its declaration. Clarified that required bootstrap retrieval may precede the
  table, while task inspection and discovery still require prior declaration.
- A further cold-start replay loaded this skill before INDEX, despite AGENTS.md
  requiring the opposite order. Added that retrieval order to the skill's
  description and bootstrap guidance. A fresh replay followed the repo-prescribed
  startup order and exercised the revised task workflow.

## Validation

Inspect the affected skill and mirror, route metadata and links; verify mirror
parity and the working-tree diff. In a fresh bounded agent session, replay a
read-only Codex capability-selection task and a discovery-first scenario. Verify
the worker read the modified body using a newly introduced discriminating
sentence, then report actual tool selection, declaration order, authority,
mistakes and limitations. Do not infer production effectiveness from the replay.

Native evidence: both mirrors matched by SHA-256; frontmatter, code fences,
declaration, goal-state and delegation boundaries passed targeted inspection.
All 109 relative links in the affected skill, INDEX and this record resolved;
no duplicate numeric IDs were found. `git diff --check` passed. An initial
inspection assertion assumed LF-only files and failed on CRLF; normalizing line
endings in the read-only checker resolved the checker issue.

The primary session declared `functions.exec` for inventory discovery, found
`clock__curr_time`, declared that tool, and called it successfully. In a fresh
read-only worker, the agent loaded the modified body from disk, confirmed the
unchecked hook using `functions.exec` and `exec_command`, and identified the
runtime inventory. In a second turn it declared the inventory before calling
tools and used a declared native JavaScript time fallback. Its first turn's
session-start reads preceded the capability table, and the second turn did not
call a newly discovered tool. The primary session could discover and call the
clock tool; the worker's inventory lacked it, so the worker correctly declined
to guess an alias. A further fresh worker confirmed the skill body and declared
the task tool before task work, but read the skill before INDEX; this exposed a
bootstrap-order mistake.

Final fresh replay: the worker was given the existing AGENTS → INDEX startup
order as a launch precondition. It retrieved INDEX and session context, read the
revised skill from disk (SHA-256
`b217fe8c98004e49fc7c6bed02e4ec0c7118ff7ce29f456667235e34fccc88f2`),
declared its capability table, discovered exposed tools, and then inspected
`JEV-AI.md` to identify the existing `invoke-typesafe.ps1` helper. It made no
Jev/API call, edits, staging, or commit. The launch precondition means this
replay does not establish whether a host automatically refreshes skill metadata
or whether an unprompted session follows the bootstrap order on its own.

## Risks

- Removing examples could make routing too abstract. Mitigation: retain a
  task-to-capability table and verify selection against actual session tools.
- A fresh agent may see a cached pre-edit skill. Mitigation: require evidence
  of the new file content and checksum in its replay before interpreting results.
- The final replay explicitly supplied the existing bootstrap order, so automatic
  skill-metadata refresh and unaided startup ordering remain unverified.
  Mitigation: on a separately started Codex session, repeat the task without a
  startup-order reminder and inspect the first retrieval and declaration.
- The unrelated #012 plan remains untracked and not indexed. Mitigation: leave
  it untouched and review its route separately if the User wants it retained.

## Decision and Result

Keep the improvement. Both skill mirrors route by available capability, retain
the declaration table, and describe bootstrap and deferred discovery. Native
checks and the bounded fresh replay passed under the stated startup precondition.
The replay does not establish production effectiveness or automatic metadata
refresh in an existing session.
