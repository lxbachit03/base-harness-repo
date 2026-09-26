# Harness Improvement Resource

ID: #032_IMPROVE_HARNESS_0926
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Pure Orca ADE multi-agent coordination skill and Claude sync
CREATED: 2026-09-26
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs/tools/orca-ade/README.md
- .agents/skills/orca-ade-coordinate-agents/SKILL.md
- .agents/skills/orca-ade-coordinate-agents/references/coordination-protocol.md
- .agents/skills/writing-for-agents/SKILL.md
- .agents/skills/improve-harness/SKILL.md

## Objective

Author a specialized multi-agent coordination skill `orca-ade-coordinate-agents` under `.agents/skills/orca-ade-coordinate-agents/` following `writing-for-agents` principles (progressive disclosure via `references/coordination-protocol.md`), synchronize the skill to `.claude/skills/`, and update the Harness repository index and allowlist rules.

## Purposes

- [x] Provide an autonomous multi-agent coordination skill purely through the Orca ADE Control Plane (`orca.exe`), establishing how a Coordinator orchestrates independent AI workers without Herdr dependencies.
- [x] Document the Hub-and-Spoke communication pattern for Orca ADE workers, enforcing sandbox isolation via Git worktrees and artifact-based relay between workers.
- [x] Synchronize new skills (`orca-ade-coordinate-agents` and `utilizing-tools-orca-ade`) to `.claude/skills/` to maintain feature parity between agent environments.
- [x] Register the improvement and routing updates in `docs-harness/INDEX.md` and `.gitignore`.

## Current State

- Prior to this improvement, `herdr-coordinate-agents` was the sole multi-agent coordination skill, requiring Herdr's socket API and terminal workspaces (`herdr agent prompt/read`).
- While `utilizing-tools-orca-ade` (#031) introduced capability routing for single-session Orca CLI usage, there was no dedicated orchestration skill guiding agents on how to coordinate multiple concurrent workers, exchange context across isolated worktrees, and perform visual reviews purely through Orca ADE.
- A live real-world trial conducted on 2026-09-26 proved that Orca ADE successfully supports Hub-and-Spoke coordination across isolated Git worktrees (`orca-worker-1-producer` and `orca-worker-2-consumer`) using terminal multiplexing, Monaco diff reviews, and browser validation.
- The User explicitly requested: (1) synthesizing the trial findings into a new skill `orca-ade-coordinate-agents` using `writing-for-agents`, (2) synchronizing to `.claude/skills/`, and (3) updating the Harness repository using `improve-harness`.

## Proposed Improvement

1. Create `.agents/skills/orca-ade-coordinate-agents/SKILL.md`:
   - Structured 6-step workflow: Sandbox Allocation, Multiplexer Panes, Task Dispatch, Hub-and-Spoke Relay, Visual Review Gate, and Settlement/Teardown.
   - Clear completion criteria for each step.
2. Create `.agents/skills/orca-ade-coordinate-agents/references/coordination-protocol.md`:
   - Detailed CLI syntax, PTY quote escaping recommendations, Hub-and-Spoke architecture diagrams, and error recovery tables.
3. Synchronize `.agents/skills/orca-ade-coordinate-agents/` and `.agents/skills/utilizing-tools-orca-ade/` to `.claude/skills/`.
4. Update `docs-harness/INDEX.md` with the new skill and improvement resource.
5. Update `.gitignore` with the allowlist rule for this improvement record.

## Scope

In scope:
- `.agents/skills/orca-ade-coordinate-agents/SKILL.md`
- `.agents/skills/orca-ade-coordinate-agents/references/coordination-protocol.md`
- `.claude/skills/orca-ade-coordinate-agents/`
- `.claude/skills/utilizing-tools-orca-ade/`
- `docs-harness/harness-improvements/0926-orca-ade-coordinate-agents.md`
- `docs-harness/INDEX.md`
- `.gitignore`

Out of scope:
- Alterations to existing Herdr coordination contracts.
- Modifying product source code.

## Progress

- 2026-09-26: Conducted live trial validating 2-worker isolation (`orca worktree create`), PTY multiplexing (`orca terminal create/send/read`), artifact generation (`producer-metrics.json` and `dashboard.html`), Monaco Diff review (`orca file open-changed`), and clean teardown.
- 2026-09-26: Authored `orca-ade-coordinate-agents` skill and references following `writing-for-agents`.
- 2026-09-26: Synchronized `.claude/skills/` with `.agents/skills/`.
- 2026-09-26: Recorded improvement #032 and updated `docs-harness/INDEX.md` and `.gitignore`.

## Validation

Live trial validation results:
- **Isolation**: Created two concurrent worktrees (`orca-worker-1-producer` and `orca-worker-2-consumer`) on independent branches. Primary checkout remained 100% clean.
- **Relay**: Worker 1 generated `producer-metrics.json`. Coordinator ingested data and dispatched downstream prompt to Worker 2, which produced `dashboard.html`.
- **Review**: `orca file open-changed --worktree <selector> --mode diff` opened Monaco Diff editors for both workers without blocking the coordinator.
- **Teardown**: Both terminal tabs closed (`orca terminal close`) and both worktrees safely pruned (`orca worktree rm --force`), leaving zero residual artifacts on disk.
- **Self-Review**: Checked YAML frontmatter, markdown formatting, file link consistency (`file:///`), and git tracking.

## Risks

- **Risk**: PTY command delivery in Windows PowerShell can encounter syntax parsing issues if complex nested quotes are sent directly via `orca terminal send`.
- **Mitigation**: Documented in `references/coordination-protocol.md` to format commands with outer double quotes and single-quoted strings, or write task commands to temporary scripts before execution.

## Decision and Result

Decision: **Keep**. The pure Orca ADE coordination pattern is fully proven and documented as a first-class skill, expanding multi-agent orchestration beyond Herdr. STATUS set to `completed`.
