# Harness Improvement Resource

ID: #005_IMPROVE_HARNESS_0816
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Filesystem and INDEX synchronization check at session start
CREATED: 2026-08-16
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- README.md

## Objective

Establish an explicit instruction in `AGENTS.md` and `docs-harness/INDEX.md` requiring the AI agent to perform a lightweight filesystem-to-INDEX synchronization check at session start, ensuring the routing index accurately reflects current canonical resources without token bloat.

## Current State

Baseline:

- Repository: `base-harness-repo`
- Working tree: contains core Harness structure (`docs-harness/`, `.agents/`, `AGENTS.md`).

Previously, `AGENTS.md` required reading `INDEX.md` and loading active resources, but lacked an explicit instruction to check whether any newly created, renamed, or removed canonical files in `docs-harness/` were missing from or misaligned with `INDEX.md`.

Observed friction / risk: When resources are added or modified out-of-band, an agent relying solely on `INDEX.md` could encounter broken routes or fail to discover newly added active resources.

## Proposed Improvement

1. Update `AGENTS.md` (under `### Session Context Loading`):
   - At the first prompt of a session, when inspecting the `docs-harness/` folder tree, perform a lightweight consistency check between filesystem entries and `INDEX.md`.
   - If an unindexed canonical resource is found, synchronize `INDEX.md` before proceeding with Top-Down routing.
2. Update `docs-harness/INDEX.md` (under `### Top-Down (Default)` and `## INDEX Synchronization`):
   - Reaffirm that filesystem structure is authoritative and agents must verify alignment at session start.
3. Index this improvement record under `TAG: [IMPROVE_HARNESS]` and `plans/active/` in `docs-harness/INDEX.md`.

## Scope

In scope:
- Updating `AGENTS.md` session context loading guidance.
- Updating `docs-harness/INDEX.md` routing and synchronization rules.
- Indexing this active improvement record (`#005_IMPROVE_HARNESS_0816`).

Out of scope:
- Deep recursive scanning of non-Harness repository source code.
- Auto-loading archived/completed records.

## Validation

During work:
- Verify that `#005_IMPROVE_HARNESS_0816` is unique and matches global sequence rules.
- Verify that date prefix `0816` matches `CREATED: 2026-08-16`.
- Verify reciprocal links across `AGENTS.md`, `INDEX.md`, and this resource.

Final proof:
- Run `git diff` to ensure clean, minimal, non-conflicting edits.
- Validate that `docs-harness/INDEX.md` correctly indexes the new resource.

## Risks

Performing a synchronization check on every prompt could waste tokens and time.
- Proposal: Restrict the synchronization check strictly to the first prompt of a session (Session Start) and limit it to canonical resource folders under `docs-harness/`.

Decision: pending fresh rerun.
