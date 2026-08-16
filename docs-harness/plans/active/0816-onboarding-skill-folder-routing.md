# Harness Improvement Resource

ID: #007_IMPROVE_HARNESS_0816
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Onboarding skill and flow-based workspace routing
CREATED: 2026-08-16
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/onboarding/README.md
- .agents/skills/onboarding/SKILL.md
- README.md

## Objective

Introduce a dedicated brownfield onboarding skill (`$onboarding`) and establish a structured working directory (`docs-harness/onboarding/`) in the Harness repository for isolating and investigating complex data/business flows without causing context bloat, serving as the feeder for `docs-harness/domain/`.

## Current State

Baseline:

- Repository: `base-harness-repo`
- Previously, brownfield investigations lacked a standardized folder structure for breaking down large codebases into modular flows. Agents risked loading too much context simultaneously or producing scattered ad-hoc notes.

Observed friction: When mapping multi-layered brownfield applications, lack of per-flow isolation led to context window exhaustion and difficulty synthesizing clean domain knowledge.

## Proposed Improvement

1. Create `.agents/skills/onboarding/SKILL.md` following `writing-for-agents` principles (Flow Isolation, 4-stage lifecycle, progressive disclosure, strict token bounds).
2. Create `docs-harness/onboarding/` with `README.md` defining the flow-based workspace layout (`onboarding/<flow-name>/`) containing 5 core artifacts including `activity-diagrams.md` (Mermaid diagrams with mandatory file and line-range citations).
3. Update `docs-harness/INDEX.md` to add `docs-harness/onboarding/` to the Folder Tree and Supporting Folders routing, explicitly specifying that `onboarding/` is loaded on-demand per flow and never globally at Session Start.
4. Establish strict User Authority gate: The AI Agent must never automatically promote an onboarding flow to `docs-harness/domain/` without explicit User approval or command.
5. Update `AGENTS.md` and `README.md` to document the new onboarding capability, Top-Down constraints, and domain synthesis workflow.

## Scope

In scope:
- `.agents/skills/onboarding/SKILL.md`
- `docs-harness/onboarding/README.md`
- `docs-harness/INDEX.md`
- `AGENTS.md`
- `README.md`

Out of scope:
- Mutating product code or altering completed ticket history.

## Validation

During work:
- Verify `#007_IMPROVE_HARNESS_0816` ID uniqueness and template conformance.
- Verify YAML frontmatter in `.agents/skills/onboarding/SKILL.md`.

Final proof:
- Run `node .agents/validators/sync-harness-index.js` to ensure 100% synchronization.

## Risks

Context sprawl if an agent scans all subfolders in `docs-harness/onboarding/` simultaneously.
- Proposal: Mandate Top-Down routing to specific flow subfolders (`docs-harness/onboarding/<target-flow>/`) in both `INDEX.md` and `SKILL.md`, prohibiting bulk directory scans.

Decision: pending fresh rerun.
