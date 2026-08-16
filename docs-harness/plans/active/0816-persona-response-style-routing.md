# Harness Improvement Resource

ID: #006_IMPROVE_HARNESS_0816
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Persona response style configuration and session start routing
CREATED: 2026-08-16
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/PERSONA.md
- README.md

## Objective

Introduce a dedicated persona configuration file (`docs-harness/PERSONA.md`) that allows the user to select an AI communication tone via a Markdown checklist (`- [x]`), and update `AGENTS.md` so the AI agent loads and adopts the selected tone at session start without altering code file editing standards.

## Current State

Baseline:

- Repository: `base-harness-repo`
- Communication style was previously implicit or guided only by general system prompt parameters, without a centralized user-configurable mechanism within the Harness repository.

Observed friction: Users desiring specific interaction styles (e.g., deeply analytical architecture advice vs. terse action-first responses) had to repeat prompting instructions in each session.

## Proposed Improvement

1. Create `docs-harness/PERSONA.md` with a clean Todo checklist defining:
   - Default (Standard technical & objective)
   - Senior Software Architect / Tech Lead
   - Minimalist / Action-First
   - Friendly Pair Programmer
2. Update `AGENTS.md` (under `### Session Context Loading`):
   - At the first prompt of a session, read `docs-harness/PERSONA.md` and adopt the selected tone (`- [x]`) for chat responses.
   - Establish fallback rule: Default tone if 0 or >1 options are checked.
   - Clarify safety boundary: Tone applies solely to chat dialogue, never to code files or commit messages.
3. Update `docs-harness/INDEX.md` and `README.md` to reference `PERSONA.md` and this improvement record (`#006_IMPROVE_HARNESS_0816`).

## Scope

In scope:
- `docs-harness/PERSONA.md`
- `AGENTS.md` session context loading guidance.
- `docs-harness/INDEX.md` root routing and improvement index.
- `README.md` overview.

Out of scope:
- Changing code file formatting rules or technical validation standards.

## Validation

During work:
- Verify that `#006_IMPROVE_HARNESS_0816` is unique and follows global sequence rules.
- Verify checklist formatting in `PERSONA.md`.

Final proof:
- Run `node .agents/validators/sync-harness-index.js` to ensure 100% synchronization.

## Risks

Ambiguous checklist state (multiple checked boxes or none checked).
- Proposal: Implement strict fallback to `Default` persona whenever checklist state is ambiguous.

Decision: pending fresh rerun.
