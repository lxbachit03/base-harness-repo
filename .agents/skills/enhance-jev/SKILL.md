---
name: enhance-jev
description: Customize and synchronize TypeSafe Jev semantic scripts with project-specific requirements based on docs-harness/JEV-AI.md. Use when adapting Jev primitives for real-world projects, adding new semantic evaluations, or tuning criteria.
---

# Enhance Jev

Use this skill to adapt and customize TypeSafe Jev System One semantic primitives for target applications and real-world project domains.
[`docs-harness/JEV-AI.md`](../../../docs-harness/JEV-AI.md) is the single source of truth (manifest). This skill keeps that manifest and the executable PowerShell scripts under `.agents/skills/typesafe-ai/scripts/` synchronized.

## Workflow Phases

### Phase 1: Clarification Gate & Manifest Evolution

1. **Read Existing Manifest**: Read [`docs-harness/JEV-AI.md`](../../../docs-harness/JEV-AI.md) to understand current active scripts, criteria, thresholds, and project context.
2. **Intent Clarification Gate**:
   - If the user's prompt is underspecified, ambiguous, or lacks key domain facts (e.g. tech stack, error shapes, or evaluation dimensions), **PAUSE and ask the user clarifying questions immediately**.
   - Do NOT guess project-specific schemas or mutate scripts on speculative intent.
3. **Update Manifest**: Once intent is clear, edit [`docs-harness/JEV-AI.md`](../../../docs-harness/JEV-AI.md):
   - Update **Section 1 (Project Context & Environment)** with the target domain facts.
   - Update **Section 2 (Active Semantic Scripts Catalog)** with any added, modified, or retired scripts.
   - Detail the input state shapes, question types (`Choice`, `Score`, `Noul`), and criteria in **Section 3**.

### Phase 2: Script Synchronization

Synchronize the executable scripts in `.agents/skills/typesafe-ai/scripts/` to match the manifest:

- **Script Placement**: All scripts must reside flatly directly under `.agents/skills/typesafe-ai/scripts/<script-name>.ps1`.
- **Infrastructure Reuse**: Call [`invoke-typesafe.ps1`](../typesafe-ai/scripts/invoke-typesafe.ps1) for all API transport. Do not duplicate HTTP logic, credential discovery, or UTF-8 serialization.
- **Observability Contract**: Include real-time console notification (`Write-Host`) for evaluated state and decision results.
- **Graceful Fallback**: Implement non-terminating fallback when offline or when credentials are unavailable.
- **Mirror**: Copy each added or changed script to `.claude/skills/typesafe-ai/scripts/` with the same content.

### Phase 3: Local Routine Verification

Verify each added or modified script locally before claiming completion. A live
TypeSafe test call is routine local verification (User decision 2026-10-05):
1. Run a test invocation with the shell tool (PowerShell).
2. Inspect latency (target: sub-second execution ~450ms - 550ms for live API calls).
3. Validate output schema and verify that decisions match the defined criteria.

## Completion Criteria

- [ ] [`docs-harness/JEV-AI.md`](../../../docs-harness/JEV-AI.md) reflects the updated project context, script catalog, and questions.
- [ ] All new/modified scripts in `.agents/skills/typesafe-ai/scripts/` have been created or updated and mirrored to `.claude/skills/typesafe-ai/scripts/`.
- [ ] Local verification commands executed with observable proof.
- [ ] Working tree remains unstaged and uncommitted (strictly honoring User Authority).
