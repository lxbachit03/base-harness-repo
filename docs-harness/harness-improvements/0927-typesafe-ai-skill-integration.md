# Harness Improvement Resource

ID: #033_IMPROVE_HARNESS_0927
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Integrate TypeSafe Jev semantic primitives and native PowerShell helper with graceful fallback
CREATED: 2026-09-27
STATUS: completed
REFERENCES:
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- .agents/skills/utilizing-tools-agy/SKILL.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/utilizing-tools-codex/SKILL.md
- .agents/skills/utilizing-tools-opencode/SKILL.md
- docs-harness/WORKFLOW.md
- docs-harness/INDEX.md

## Objective

Integrate TypeSafe Jev as a System One semantic decision primitive into the Harness repository, providing zero-dependency native PowerShell helper scripts (`invoke-typesafe.ps1`, `suggest-skill.ps1`), graceful fallback policy for offline/unauthenticated environments, capability router registration across all `utilizing-tools-*` skills, and official repository index routing.

## Purposes

- [x] Provide fast (<500ms) semantic evaluation primitives (Choice, Score, Noul) for ticket triage, smart skill routing, and agent guardrails without launching heavy reasoning sessions.
- [x] Ensure zero-dependency operation via native Windows PowerShell helpers with UTF-8 encoding support.
- [x] Enforce graceful fallback and robust error handling so CI runners and offline environments do not abort repository operations when API keys are absent.
- [x] Maintain credential security by dynamically discovering keys from process environment or host registry without hardcoding or tracking secrets.
- [x] Register `typesafe-ai` capability into Phase 1 of `utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`, and `utilizing-tools-opencode`.

## Current State

Previously, the repository lacked structured semantic decision primitives for fast triage or classification. While full-reasoning agent models (Bale, Herdr workers, Codex, Antigravity) are available, using them for atomic classifications is token-heavy and slow. Furthermore, the `typesafe-ai` skill existed only as an untracked draft in `.agents/skills/typesafe-ai/` with formatting inconsistencies and lacked a shared native execution helper, skill suggestion mechanism, capability router entries, index routing, and offline fallback guidance in `docs-harness/WORKFLOW.md`.

## Proposed Improvement

1. Provide `.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1` with dynamic credential discovery (environment and Windows User/Machine registry), proper UTF-8 byte serialization, and non-terminating graceful fallback.
2. Provide `.agents/skills/typesafe-ai/scripts/suggest-skill.ps1` as a smart router leveraging Jev Choice primitive over the 17-skill catalog, with heuristic fallback.
3. Register `typesafe-ai` into the Phase 1 capability table of `utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`, and `utilizing-tools-opencode`.
4. Update `docs-harness/WORKFLOW.md` to document the graceful fallback requirement and credential safety rules for external semantic judgment primitives.
5. Record this improvement under `docs-harness/harness-improvements/0927-typesafe-ai-skill-integration.md`, add it to `.gitignore`, and route it in `docs-harness/INDEX.md`.

## Scope

- In scope: `.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1`, `.agents/skills/typesafe-ai/scripts/suggest-skill.ps1`, `utilizing-tools-*` router tables, `docs-harness/WORKFLOW.md`, `docs-harness/harness-improvements/0927-typesafe-ai-skill-integration.md`, `docs-harness/INDEX.md`, and `.gitignore`.
- Out of scope: Modifying unrelated skills, hardcoding credentials, or auto-committing without user authority.

## Progress

- 2026-09-27: Created `.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1` with dynamic key discovery and graceful fallback.
- 2026-09-27: Verified live API execution (`jev-1.13.0` responded in <1s) and verified graceful fallback on missing key (`Error: MissingApiKey`) and network/auth errors (`Error: NetworkOrApiError`).
- 2026-09-27: Updated `docs-harness/WORKFLOW.md` with graceful fallback and credential safety guidance.
- 2026-09-27: Created `.agents/skills/typesafe-ai/scripts/suggest-skill.ps1` smart router and verified live choice accuracy on sample prompts.
- 2026-09-27: Registered `typesafe-ai` in Phase 1 table across `utilizing-tools-agy`, `utilizing-tools-claude`, `utilizing-tools-codex`, and `utilizing-tools-opencode`.
- 2026-09-27: Created canonical improvement record, updated `INDEX.md` and `.gitignore`.

## Validation

- Live Test: Invoked `invoke-typesafe.ps1` with Vietnamese state and Noul question; verified `Success: True`, `Fallback: False`, `Model: jev-1.13.0`.
- Skill Router Test: Invoked `suggest-skill.ps1` with agent documentation prompt -> picked `writing-for-agents` (`confidence: 1.0`); with classification prompt -> picked `typesafe-ai` (`confidence: 1.0`).
- Offline/Fallback Test: Simulated missing/invalid key -> returned non-terminating `Fallback: True`, `Mode: HeuristicFallback` without unhandled errors.
- Router Parity: Verified Phase 1 tables across all 4 capability routers contain `typesafe-ai` entry.
- Repository Integrity: Verified `git status` shows zero staged files (preserving user authority over commits).

## Risks

- Risk: API credentials could accidentally leak into logs or git commits if hardcoded.
  - Mitigation: The scripts dynamically retrieve credentials at runtime from process environment or Windows registry; no key is stored in scripts or git history.
- Risk: CI pipelines or offline machines fail due to unreachability of external API.
  - Mitigation: The helper scripts default to graceful fallback (`Fallback: $true`), allowing workflows to fall back to heuristics without crashing.

## Decision and Result

Keep. The TypeSafe Jev integration provides a reliable, zero-dependency System One evaluation primitive and smart router for the repository with proven live accuracy and robust offline resilience.
