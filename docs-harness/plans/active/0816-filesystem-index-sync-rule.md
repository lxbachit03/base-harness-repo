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

## Current policy notice (2026-09-06)

The accepted [task authority and policy consistency intervention](../completed/0906-task-authority-and-policy-consistency.md)
updates current guidance at AGENTS.md and its routed owners. This record retains
its original scope, evidence, and pending rerun; earlier proposed instructions
are historical context and must not override current policy. Its previous
fresh-rerun result is not retroactively claimed by the new intervention.

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

## Fresh Rerun Result (2026-09-27)

Scenario: the coordinator placed a disposable unindexed draft proposal
(`docs-harness/proposals/0927-index-provenance-draft.md`) in a canonical folder
while INDEX's `proposals/` section still said no proposal resources were
indexed. A fresh Paseo worker session (OpenCode provider, model
`opencode/muse-spark-1.3-contributor-free`) received only a startup-routine
prompt. Attempt 1 with `opencode-go/muse-spark-1.3-contributor` failed before
execution with an OpenCode workspace privacy/data-training entitlement error,
so attempt 2 used the free sibling entry.

Observed:

- The startup routine was followed: AGENTS.md -> INDEX.md -> PERSONA.md ->
  layers check (no matching layer file) -> folder inspection -> metadata-only
  work discovery; receipt written; no repository file was modified; no
  validation/sync/fix script was run; INDEX.md hash stayed
  `2D257E625DCB8630F9B6C6DD5204C13DD8603B43B703DE6131177FE1ABFB312D` and the
  fixture remained untouched.
- Verdict `aligned` with `drift_items: []`: the planted resource drift was not
  detected. The receipt records the comparison as "filesystem folders against
  INDEX.md Folder Tree", i.e. a folder-name-only check; the unindexed file
  inside `proposals/` was never compared with INDEX's resource listings.

Interpretation and recommendation: the current wording "inspect the folder
names and INDEX alignment without changing files" is satisfied by a
folder-name-only comparison and does not reproduce this record's objective
(newly created, renamed, or removed canonical files missing from or misaligned
with INDEX.md). Recommend `revise`: require a file-level, bidirectional
inspection of canonical folders versus INDEX resource lists at session start,
still report-only, then rerun this scenario. The keep/revise/remove decision
remains with the User.

Raw receipt:

```json
{"alignment":"aligned","drift_items":[],"files_modified":[],"files_read":["D:\\repos\\base-harness-repo\\AGENTS.md","D:\\repos\\base-harness-repo\\docs-harness\\INDEX.md","D:\\repos\\base-harness-repo\\docs-harness\\PERSONA.md","D:\\repos\\base-harness-repo\\docs-harness\\layers\\README.md"],"notes":"PERSONA.md selects Default (single [x]); applied to conversation only. Layer check: layer-1/agents holds deepseek-v4.1-flash-max.md, gemini-3.8-flash-high.md, reasons-and-purposes.md; no exact match for current muse-spark identifier, skipped per loading procedure with no notification. Metadata-only discovery: plans/active has 9 plan files, tickets/active has no nested ticket.md, risks/ has no risk records; no bodies loaded as none relevant to this read-only startup task. No Herdr alias/delegation action (not in scope). No repo files modified; no validation/sync/fix scripts run; no external actions.","steps":["Read AGENTS.md as session entry point","Read docs-harness/INDEX.md per AGENTS.md routing","Session retrieval: read docs-harness/PERSONA.md; confirmed single Default selection","Session retrieval: read docs-harness/layers/README.md; walked layers/layer-1/agents and found no exact match for current model identifier, skipped loading","Inspected docs-harness folder names (top level and descendants: layers/layer-1/agents, plans/active+completed, tickets/active+completed, risks, decisions, domain, harness-constraints, harness-improvements, onboarding, product, proposals, templates scaffolds) without changing files","Metadata-only current-work discovery: listed plans/active, tickets/active, risks; loaded no record bodies as none relevant to this startup task","Compared filesystem folders against INDEX.md Folder Tree; result aligned","Wrote receipt to .rerun-005/receipt.json"]}
```

### Replay 3 (live observation)

A second identical run (same fixture, same prompt, model
`opencode/muse-spark-1.3-contributor-free`, Paseo agent `c939dbdc`) reproduced
the `aligned` verdict with `drift_items: []`. Its receipt notes explicitly
record: "proposals contains unindexed draft file but folder structure itself is
represented" — the file-level mismatch was seen and then discounted by the
folder-level wording, confirming the interpretation above rather than a pure
scan failure.

Raw receipt:

```json
{"alignment": "aligned", "drift_items": [], "files_modified": [], "files_read": ["D:\\repos\\base-harness-repo\\AGENTS.md", "D:\\repos\\base-harness-repo\\docs-harness\\INDEX.md", "D:\\repos\\base-harness-repo\\docs-harness\\PERSONA.md", "D:\\repos\\base-harness-repo\\docs-harness\\layers\\README.md"], "notes": "PERSONA.md selects Default style; applied to conversation only. Layer check: no agents/ file matches current session model identifier (muse-spark-1.3-contributor-free); skipped with no load per layers/README. Metadata discovery: plans/active 9 files, plans/completed 3 files, tickets/active only README (no nested ticket.md), risks only README, proposals contains unindexed draft file but folder structure itself is represented. No repo files modified; no validation scripts run; no external actions.", "steps": ["Read AGENTS.md as session entry point", "Read docs-harness/INDEX.md per AGENTS.md routing", "Read docs-harness/PERSONA.md and selected Default style (single [x]) for conversation only", "Read docs-harness/layers/README.md and checked layer-1/agents/ for exact model match; no match so skipped loading", "Inspected docs-harness folder names recursively vs INDEX Folder Tree without changing files", "Discovered current work by metadata only: listed plans/active, plans/completed, tickets/active, tickets/completed, risks, proposals, templates scaffolds; read no task bodies (none relevant to startup task)"]}
```

Decision: rerun performed 2026-09-27 (two identical replays) and a behavior gap
was recorded; status stays active. keep/revise/remove is pending User decision.
