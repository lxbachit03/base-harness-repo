# Harness Improvement Resource

ID: #035_IMPROVE_HARNESS_0927
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Dynamic Jev manifest (JEV-AI.md) and enhance-jev skill for project-specific customization
CREATED: 2026-09-27
STATUS: completed
REFERENCES:
- docs-harness/JEV-AI.md
- .agents/skills/enhance-jev/SKILL.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md

## Objective

Establish `docs-harness/JEV-AI.md` as the dynamic declarative manifest and single source of truth for all TypeSafe Jev System One integrations, and introduce the `$enhance-jev` skill to dynamically adapt, update, add, or prune PowerShell semantic scripts based on project-specific requirements and user intent.

## Purposes

- [x] Enable seamless adaptation of Jev semantic primitives across diverse real-world software projects without hardcoded repository assumptions.
- [x] Maintain a declarative, human-readable, and agent-inspectable manifest (`docs-harness/JEV-AI.md`) documenting all active scripts, state payloads, and criteria.
- [x] Enforce an explicit intent clarification gate in `$enhance-jev` when user requests are ambiguous or underspecified before mutating scripts.
- [x] Standardize script synchronization to maintain flat placement under `.agents/skills/typesafe-ai/scripts/`, reusing `invoke-typesafe.ps1`.

## Current State

In `#033` and `#034`, TypeSafe Jev primitives were integrated into the Harness repository with 4 fixed scripts (`precheck-authority.ps1`, `suggest-skill.ps1`, `triage-ticket.ps1`, `check-domain-freshness.ps1`).
However, when porting this harness or adopting Jev in specific business projects (e.g. e-commerce backend, fintech, gRPC microservices, mobile apps), developers need a straightforward mechanism to customize question criteria, state schemas, and add domain-specific semantic evaluators without manually writing boilerplate code.

## Proposed Improvement

1. **Jev Manifest (`docs-harness/JEV-AI.md`)**:
   - Create a central markdown document detailing project context, active script catalog, input state shapes, questions (Choice, Score, Noul), and thresholds.
2. **Dynamic Enhancement Skill (`.agents/skills/enhance-jev/SKILL.md`)**:
   - Provide an autonomous workflow: Intent Clarification -> Manifest Evolution -> Script Synchronization -> Local Routine Verification.
3. **Skill Catalog & Router Integration**:
   - Register `enhance-jev` in `suggest-skill.ps1`, `WORKFLOW.md`, `INDEX.md`, `.gitignore`, and the `utilizing-tools-*` catalog tables.

## Scope

- May create `docs-harness/JEV-AI.md` and `.agents/skills/enhance-jev/SKILL.md`.
- May update `docs-harness/INDEX.md`, `docs-harness/WORKFLOW.md`, `.gitignore`, and router scripts.
- May NOT commit or stage changes without explicit User authority.

## Progress

- 2026-09-27: Completed goal grill and architectural calibration with User: selected flat script placement (Option A) and mandatory clarification gate for ambiguous intent.
- 2026-09-27: Created `docs-harness/JEV-AI.md` manifest with complete catalog and specifications of the 4 active Jev scripts.
- 2026-09-27: Created `.agents/skills/enhance-jev/SKILL.md` defining the 4-phase synchronization lifecycle with intent clarification gate.
- 2026-09-27: Registered `enhance-jev` in `suggest-skill.ps1` router and verified live recognition (98% confidence, 515ms latency).
- 2026-09-27: Updated `WORKFLOW.md`, `INDEX.md`, `.gitignore`, and `utilizing-tools-*` catalog tables.

## Validation

- `docs-harness/JEV-AI.md` verified with full specifications of all 4 active semantic scripts.
- `suggest-skill.ps1` live test: prompt about customizing Jev manifest correctly routed to `enhance-jev` (98% probability, confidence 0.98, latency 515ms).
- Explicit bypass verified: `$enhance-jev` returns instantly in 0ms without network call.
- Git status verified: working tree clean of accidental staged/committed files.

## Risks

- Risk: User intent is too vague, leading to generated scripts with ineffective criteria.
  - Mitigation: Phase 1 includes a mandatory clarification gate to pause and ask clarifying questions before script mutations.

## Decision and Result

Keep. `docs-harness/JEV-AI.md` and `.agents/skills/enhance-jev/` provide an autonomous, safe, and verifiable mechanism to dynamically customize TypeSafe Jev primitives for real-world projects.
