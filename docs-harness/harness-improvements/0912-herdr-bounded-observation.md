# Harness Improvement Resource

ID: #019_IMPROVE_HARNESS_0912
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Receipt-first Herdr observation with bounded transcript fallback
CREATED: 2026-09-12
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0912-herdr-agent-catalog.md

## Objective

Make the normal Herdr completion path avoid loading a delegated agent's full
terminal transcript into BALE's context. Use a structured receipt and the
actual output diff as the primary evidence, with only a small bounded terminal
snapshot as a recovery fallback.

## Current State

- Baseline revision: `3437a159a06f649509ce8936b1d944239ea51e80` on `main`.
- Baseline worktree status: clean; branch is three commits ahead of
  `origin/main`.
- The practical calculator trial showed repeated context/tool reads and
  overlapping observations as avoidable coordinator overhead. The fresh lean
  replay used one prompt and zero pre-poll waits, but its receipt-path omission
  required a reconciliation observation; no orchestrator token telemetry was
  exposed.
- Current guidance already prefers receipt/output diff first, but its
  ambiguity fallback does not explicitly prohibit an unbounded/full transcript
  or require a line cap. The installed `herdr agent read --help` exposes
  `--source`, `--lines` and `--format`; `herdr agent prompt --help` exposes no
  `--quiet` option.
- The User explicitly authorized this Harness improvement. The scope is local
  guidance, contract and evidence records only; no provider/global settings,
  external account, pane, validator script or dispatch helper is authorized.

## Proposed Improvement

Strengthen the Herdr observation contract so a successful `tight` attempt uses
only lifecycle state, the matching receipt and output diff/hash plus one
proportional acceptance pass. BALE must not fetch a full terminal transcript
on the normal path. If state or receipt evidence is ambiguous, read a bounded
recent snapshot (maximum 80 lines, text format) and keep the attempt pending if
that cannot resolve the ambiguity; do not escalate to an unbounded transcript
automatically. The tight prompt must continue to require an absolute receipt
path and JSON receipt before the worker's final summary.

Smallest hypothesis: an explicit bounded fallback removes accidental transcript
loads while preserving enough recovery evidence for ordinary timeout or
missing-receipt cases. Contrary evidence would be a fresh bounded replay that
cannot establish delivery or acceptance without a full transcript. The
maintenance owner is the Herdr coordination skill and its two runtime/contract
references; remove the rule if Herdr exposes a structured receipt/status API
that makes the fallback obsolete, after a recorded replay.

## Scope

May change:

- direct Herdr observation/receipt guidance in the skill, runtime reference,
  task contract and `docs-harness/HERDR-AGENTS.md`;
- this improvement record and its `[IMPROVE_HARNESS]` INDEX entry.

Must not change:

- Herdr or provider installation, global settings, external accounts or
  unrelated panes;
- the selected worker model, effort/Fast settings, permission contract or
  default worker limit;
- worker acceptance requirements, except to make their receipt-first ordering
  explicit;
- the retired validator/script policy or any repository validation script.

## Progress

- 2026-09-12: Baseline captured from the clean post-catalog commit. The User
  accepted the receipt-first direction and requested the implementation.
- 2026-09-12: Created this record before intervention edits, as required by the
  Harness improvement lifecycle.
- 2026-09-12: Updated the Herdr skill, runtime reference, task contract and
  catalog to make receipt-first observation the normal path, cap ambiguity
  fallback at 80 recent text lines, and require explicit User authority for a
  full transcript. Added the record's INDEX and ignore entries.
- 2026-09-12: Native `herdr agent prompt --help` and `herdr agent read --help`
  checks confirmed the bounded wait/read syntax; the read command supports
  `--lines`, while prompt has no `--quiet` option. No worker transcript was
  loaded during this proof.
- 2026-09-12: A fresh live Herdr replay was not run. The catalog's selected
  Antigravity profile still lacks complete native permission/configuration
  proof, and existing idle workers are unrelated sessions that must remain
  untouched. The next fresh BALE session with a proven profile owns the replay.

## Validation

Targeted inspection verifies that all active Herdr consumers share the same
receipt-first rule, bounded fallback and no automatic full-transcript read; the
receipt path, line cap, links and metadata resolve; and no validator/dispatch
script is introduced. The live success-path scenario remains unattempted
because the selected provider cannot yet be safely replayed; this record stays
active with the concrete missing proof and owner above.

## Risks

- A receipt can be missing, stale or dishonest. Mitigation: match task and
  attempt IDs, inspect current artifact bytes/diff, run one independent
  acceptance check, and use the bounded snapshot only for ambiguity.
- An 80-line snapshot may omit the decisive error. Mitigation: keep the
  attempt pending and report the unresolved evidence; never silently accept or
  load an unbounded transcript.
- Suppressing transcript reads can hide a provider-specific UI state.
  Mitigation: preserve lifecycle/receipt/artifact reconciliation and require a
  fresh replay before marking this improvement complete.

## Decision and Result

Keep the intervention provisionally: targeted inspection and native CLI help
checks passed, and the active consumers now share the receipt-first/bounded
fallback rule. The fresh live success-path replay remains pending. Owner: the
next fresh BALE session with a proven Herdr worker profile. Keep the record
active until the receipt-only success path and ambiguity fallback have been
exercised.
