# Harness Improvement Resource

ID: #031_IMPROVE_HARNESS_0926
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add Orca ADE documentation, capability routing skill, and Herdr coordination integration
CREATED: 2026-09-26
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/HERDR-AGENTS.md
- docs/tools/orca-ade/README.md
- .agents/skills/utilizing-tools-orca-ade/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- .agents/skills/improve-harness/SKILL.md

## Objective

Author comprehensive team-facing documentation for Orca ADE under `docs/tools/orca-ade/README.md`, create an agent capability routing skill `.agents/skills/utilizing-tools-orca-ade/SKILL.md` following the repository's `writing-for-agents` and `utilizing-tools-*` pattern (supporting both standalone Orca ADE power and Herdr worker coordination via Orca worktrees/terminals), update `docs-harness/HERDR-AGENTS.md` with Orca environment integration guidance, and synchronize repository index and routing.

## Purposes

- [x] Provide a single source of truth for Orca ADE architecture, CLI commands, browser automation, git worktree isolation, terminal multiplexing, MCP, plugins, and hooks under `docs/tools/orca-ade/`.
- [x] Create the agent capability routing skill `utilizing-tools-orca-ade` with the mandatory `Selected Orca ADE Capabilities` declaration table, 3-phase workflow, anti-patterns, and loading model.
- [x] Integrate Orca ADE with Herdr agent coordination in `docs-harness/HERDR-AGENTS.md`, allowing Herdr workers (Codex, OpenCode, Antigravity) to execute within isolated Orca worktrees and split-pane terminals.
- [x] Maintain routing, index, and `.gitignore` parity across all supported agent environments in the Harness repository.

## Current State

- `docs/tools/` houses technical guides for Antigravity (`docs/tools/antigravity/`), Claude (`docs/tools/claude/`), Codex (`docs/tools/codex/`), and OpenCode (`docs/tools/opencode/`). No guide exists yet for Orca ADE (`docs/tools/orca-ade/`).
- The repository has 4 capability routing skills: `utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`, and `utilizing-tools-opencode`. Orca ADE is installed locally (`C:\Users\BALE\AppData\Local\Programs\orca\resources\bin\orca.exe`, v1.4.212) but lacks an agent capability skill.
- `docs-harness/HERDR-AGENTS.md` defines worker models and launch kinds (`codex`, `agy`, `opencode`), but does not describe using Orca's isolated worktrees and terminal multiplexing for Herdr worker containment and monitoring.
- The User explicitly requested: (1) docs for Orca under `docs/tools/orca-ade/`, (2) the `utilizing-tools-orca-ade` skill using `writing-for-agents`, and (3) updating the Harness repo using `improve-harness`, with both standalone Orca capabilities and Herdr integration in scope.

## Proposed Improvement

1. Create `docs/tools/orca-ade/README.md` detailing Orca ADE architecture, core CLI commands (`worktree`, `tab`, `terminal`, `project`, `repo`, `file`, browser evaluation/snapshots), MCP/plugin system, hooks, and Herdr multi-agent orchestration.
2. Create `.agents/skills/utilizing-tools-orca-ade/SKILL.md` strictly adhering to `writing-for-agents` and converging on the `utilizing-tools-*` routing pattern:
   - Mandatory response contract: `### Selected Orca ADE Capabilities` table.
   - 3-Phase Workflow: Classify & Discover, Declare, Execute & Verify.
   - Capability matrix covering browser automation, worktrees, file diffs, terminals, and Herdr coordination.
   - Loading model (Native CLI vs Browser vs Worktree vs Herdr Worker).
   - Anti-patterns and permission boundaries.
3. Update `docs-harness/HERDR-AGENTS.md` to document Orca ADE as a host environment providing isolated Git worktrees and terminal multiplexing for Herdr workers.
4. Update `docs-harness/INDEX.md` under `## TAG: [IMPROVE_HARNESS]` and root resources, and update `.gitignore` allowlist.

## Scope

In scope:
- `docs-harness/harness-improvements/0926-utilizing-tools-orca-ade.md`
- `docs/tools/orca-ade/README.md`
- `.agents/skills/utilizing-tools-orca-ade/SKILL.md`
- `docs-harness/HERDR-AGENTS.md`
- `docs-harness/INDEX.md`
- `.gitignore`

Out of scope:
- Changes to other existing `utilizing-tools-*` skills.
- Modifying product source code outside harness documentation and skills.
- Running unverified external network operations or destructive commits.

## Progress

- 2026-09-26: Baseline captured; Orca CLI v1.4.212 verified on Windows runtime; user scope confirmed with both standalone capabilities and Herdr integration; improvement record created.
- 2026-09-26: Authored `docs/tools/orca-ade/README.md` with complete architecture, CLI commands, browser automation, worktrees, terminal multiplexing, and Herdr coordination.
- 2026-09-26: Authored `.agents/skills/utilizing-tools-orca-ade/SKILL.md` following `writing-for-agents` and converging on the `utilizing-tools-*` pattern.
- 2026-09-26: Updated `docs-harness/HERDR-AGENTS.md` with Orca ADE host environment integration for Herdr worker sandboxing and visual review gates.
- 2026-09-26: Updated `docs-harness/INDEX.md` with improvement `#031` routing and added allowlist entry to `.gitignore`.

## Validation

- Manual inspection: verified all created files exist, headers/frontmatter match conventions, and links resolve.
- Skill frontmatter and routing checks: verified `name: utilizing-tools-orca-ade` complies with agent discovery standards.
- Route consistency: verified `docs-harness/INDEX.md` routes `#031_IMPROVE_HARNESS_0926` to `harness-improvements/0926-utilizing-tools-orca-ade.md`.
- `git diff --check` passed with 0 errors.

## Risks

- Risk: Overlapping Orca worktree commands with Herdr checkout rules (Herdr standard guidance notes keeping coordination in the current Git checkout).
  - Mitigation / Proposal: Explicitly documented in both `utilizing-tools-orca-ade` and `HERDR-AGENTS.md` that Orca worktrees are optional execution sandboxes; Herdr can run directly in the current checkout or inside a dedicated task-local Orca worktree without mutating the primary workspace.
- Risk: Divergence in skill structure from other `utilizing-tools-*` skills.
  - Mitigation / Proposal: Enforced exact structural parity with `utilizing-tools-agy` and `utilizing-tools-opencode`.

## Decision and Result

Decision: Keep. Implementation complete; all 4 purposes verified and satisfied.

