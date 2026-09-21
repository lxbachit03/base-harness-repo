# Harness Improvement Resource

ID: #026_IMPROVE_HARNESS_0921
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Claude Code capability routing skill and team catalog
CREATED: 2026-09-21
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-improvements/README.md
- docs-harness/templates/harness-improvement.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/utilizing-tools-opencode/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- docs/tools/claude/README.md
- docs/README.md
- .gitignore

## Objective

Give Claude Code the same capability-routing contract the Harness already
provides for Antigravity, Codex, and OpenCode: one model-invoked
`utilizing-tools-claude` skill mirrored into `.claude/skills/`, and one
team-facing catalog at `docs/tools/claude/README.md` indexed from `docs/README.md`.

## Purposes

- [x] Close the runtime gap: Claude Code is the runtime this repository is
  driven from, yet it was the only one of four with no capability-routing skill.
- [x] Keep the declaration-before-execution contract identical across all four
  runtimes so the process does not change when the User switches tools.
- [x] Make Claude Code's non-obvious mechanics retrievable instead of rediscovered
  per session: deferred tools behind `ToolSearch`, permission modes, the
  connector/plugin/skill layering, and the delegation route through Herdr.
- [x] Record the local capability surface as dated evidence with an explicit
  version boundary, so a later session can tell stale claims from current ones.

## Current State

Baseline: repository `D:/repos/base-harness-repo`, branch `main`, revision
`3570bea`, worktree clean, ahead of `origin/main` by one commit.

Observed gap:

- `.agents/skills/` holds `utilizing-tools-agy`, `utilizing-tools-codex`, and
  `utilizing-tools-opencode`, but no equivalent for Claude Code.
- `docs/tools/` holds `antigravity/`, `codex/`, and `opencode/` catalogs, but no
  `claude/` catalog.
- `docs/README.md` indexes only `AI_PROBLEMS.md`, `WORKFLOWS.md`,
  `tools/antigravity/README.md`, and `tools/codex/README.md`; the existing
  `tools/opencode/README.md` is already missing from that index.

Local runtime evidence captured for this record (2026-09-21):

- `claude --version` → `2.1.278 (Claude Code)`.
- Repository `.claude/` contains only `skills/`; no project settings file.
- User settings keys: `model`, `statusLine`, `effortLevel`, `modelSettings`,
  `autoUpdatesChannel`, `skipDangerousModePermissionPrompt`, `theme`.
- One marketplace registered: `claude-plugins-official`
  (`anthropics/claude-plugins-official`, 310 plugins in catalog).
- One plugin installed: `productivity`, shipping four skills and a `.mcp.json`
  declaring `slack`, `notion`, `asana`, `linear`, `atlassian`, `monday`,
  `clickup`, `google calendar`, `gmail`. Its `manifest.json` records
  `version: "0039"`; `claude plugin list` displays `v1.3.1`.
- Session evidence: `plugin:productivity:asana` failed to connect with
  `Incompatible auth server: does not support dynamic client registration`.

Authority: the User requested the new skill, the `.claude/skills` sync, the
`docs/tools/claude` catalog, and an `improve-harness` pass over the result.

## Proposed Improvement

Add `utilizing-tools-claude` as a model-invoked skill under `.agents/skills/`,
mirrored byte-for-byte into `.claude/skills/`. Keep the sibling skills' shape —
declaration table, three phases, completion criteria, anti-patterns — and carry
only the mechanics that are specific to Claude Code. Add the team-facing catalog
under `docs/tools/claude/README.md`, repair the `docs/README.md` index to cover
both the new catalog and the already-missing OpenCode one, index this record in
`docs-harness/INDEX.md`, and allowlist it in `.gitignore`.

## Scope

In scope:

- `.agents/skills/utilizing-tools-claude/SKILL.md` and its `.claude/` mirror.
- `docs/tools/claude/README.md`.
- `docs/README.md` index entries for the Claude and OpenCode catalogs.
- This record, its INDEX entry, and its `.gitignore` allowlist line.

Out of scope:

- Rewriting `utilizing-tools-agy`, `-codex`, or `-opencode`.
- Resolving the dangling `#012` INDEX links or the deny-all `.gitignore` shape;
  both are reported under Risks as separate decisions.
- Installing, authenticating, or configuring any plugin, MCP server, or connector.

## Progress

2026-09-21: record created before intervention edits. Local capability evidence
captured. Applied, in order:

1. `.agents/skills/utilizing-tools-claude/SKILL.md` (173 lines) — model-invoked,
   same contract shape as the three sibling skills.
2. `.claude/skills/utilizing-tools-claude/SKILL.md` — byte-identical mirror.
3. `docs/tools/claude/README.md` (482 lines, 13 sections).
4. `docs/README.md` — added the Claude catalog entry and the OpenCode entry that
   was already missing from the index.
5. `docs-harness/INDEX.md` — indexed this record under TAG: [IMPROVE_HARNESS].
6. `.gitignore` — allowlisted this record so it is tracked.

Structural self-review results: frontmatter `name` matches the directory name in
both skill locations; the two copies are identical ignoring line endings;
`#026` is unique across `docs-harness/` outside `templates/`; `git check-ignore`
reports all four new paths as tracked; 100 relative links across the new and
edited files resolve on disk except the two pre-existing `#012` links reported
under Risks; 19 Markdown tables in the catalog have consistent column counts and
its 10 code fences are balanced; all 11 REFERENCES paths exist.

2026-09-21, fresh replay: a subagent session in this repository received a
read-only task phrased in the User's natural terms ("tận dụng hiệu quả các tool,
MCP và skill của Claude Code" plus a question about the repository's skills).
The skill name was not mentioned in the task.

2026-09-21, continuation after User review: the catalog listed the session's
tool, MCP, plugin, and skill surface but omitted the CLI surface that the
Antigravity and OpenCode catalogs both cover. Ran `claude --help`,
`claude mcp --help`, `claude plugin --help`, `claude mcp list`,
`claude plugin list`, `claude plugin marketplace list`, and
`claude plugin details productivity`, then added section 9 (18 subcommands,
11 `mcp` subcommands, 14 `plugin` subcommands, notable flags, slash-command
mechanics, and a read-only-discovery versus mutation split), renumbering the
later sections. The skill gained the matching discovery commands and one
anti-pattern against using install/login/eval as a capability probe.

That run also **corrected two claims** first written from session evidence alone:

- MCP state: `claude mcp list` reports 25 servers — 16 claude.ai connectors of
  which Claude Docs, Google Drive, and Gmail are `✔ Connected` and 13 need
  authentication, plus 9 plugin servers of which 6 need authentication, `asana`
  failed, and 2 are unconfigured. The earlier table claimed 14 unauthenticated
  connectors, wrongly including Gmail and Google Drive and omitting Notion.
- Plugin version: `claude plugin list` displays `v1.3.1`, not the `0039` build
  number in `manifest.json`.

Recorded as an open discrepancy: Gmail and Google Drive report `✔ Connected` in
the CLI while the session exposed only their `authenticate` tools. Cause
unverified; the catalog states the CLI as the connection authority.

## Validation

Targeted agent self-review, no repository validator script:

- Frontmatter `name` matches the skill directory name in both skill locations.
- `.agents` and `.claude` copies compare identical ignoring line endings.
- Every relative Markdown link in the new and edited files resolves on disk.
- The new record's ID is unique across `docs-harness/` outside `templates/`.
- `git check-ignore` confirms the new record is tracked rather than ignored.
- Every capability named in the catalog traces to captured local output or to
  this session's exposed tool, skill, agent, and MCP declarations.

## Risks

- Capability drift: the catalog is dated `2026-09-21` against Claude Code
  `2.1.278`. Mitigation: the version boundary and evidence-class table are stated
  in the document, and the session's exposed definitions are declared the runtime
  authority over the document.
- `docs-harness/*` is ignored by default with a per-file allowlist, so any future
  record is silently untracked unless someone remembers to allowlist it.
  Mitigation proposal (suggestion until authorized): replace the deny-all block
  with targeted ignores for genuinely local-only paths, in a separate improvement.
- `docs-harness/INDEX.md` carries two links to
  `plans/completed/0902-evidence-backed-domain-freshness.md` (`#012`), a file that
  does not exist and has no git history. Mitigation proposal (suggestion until
  authorized): either recreate the record from `templates/plan.md` or retire
  `#012` and drop both entries; the choice is the User's.
- `.gitignore` allowlists `docs-harness/plans/completed/0906-behavior-parity-audit.md`,
  a path that does not exist (the plan is under `plans/active/`). Mitigation
  proposal: drop the stale line with the same authority that fixes the block above.

## Decision and Result

Decision: **keep**.

Replay outcome (2026-09-21, fresh subagent session, read-only task, skill name
withheld from the task text):

- **Available**: the skill was present in the fresh session's skill listing, so
  the model-invoked frontmatter and the `.claude/` mirror both resolved.
- **Retrieved**: the session invoked `utilizing-tools-claude` through the `Skill`
  tool on its own, before any other tool call.
- **Exercised**: it printed the `### Selected Claude Code Capabilities` table
  before calling tools, then executed, so the mandatory response contract was
  followed rather than merely loaded.
- **Proportionate selection**: it declared and used two capabilities (`Skill`,
  `Bash`) instead of the full catalog, which is the behavior the declaration
  section asks for.
- **Scope respected**: the read-only boundary held; no file was created,
  modified, or deleted.
- **Answer correctness**: it reported 14 repository-owned skills with
  `domain-audit` and `ticket-solving` as the two `disable-model-invocation: true`
  entries, matching this session's independent inspection, and separated
  repository skills from plugin and built-in skills — the distinction the catalog
  teaches in its Skills section.

Observed limits:

- One replay in one repository on Claude Code `2.1.278`. This establishes
  instruction routing and contract compliance; it measures nothing about
  production speed or productivity.
- The replay exercised the discovery and declaration path only. The permission
  ladder, MCP authentication, deferred-tool loading, and Artifact boundaries in
  the skill were not exercised, because the task needed none of them.
- The replay ran with bypass permissions active, so the session used `Bash` for
  inspection rather than `Grep`/`Glob`. That follows the active session guidance
  and is not a contract violation; the tool-preference rule remains unexercised
  under a normal permission mode.

Remaining proof, when a later task naturally reaches them: a run that must load a
deferred tool through `ToolSearch`, and a run that meets an unauthenticated MCP
server and has to report the missing rung of the connection ladder.
