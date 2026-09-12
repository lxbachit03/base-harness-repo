# Harness Improvement Resource

ID: #020_IMPROVE_HARNESS_0913
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Bale review gate for delegated code quality and resource efficiency
CREATED: 2026-09-13
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- README.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0912-herdr-bounded-observation.md

## Objective

Require Bale/orchestrator to review code or runtime-affecting assets produced or
modified by a delegated worker before accepting them, covering clean code,
correctness risks, CPU and I/O efficiency, memory lifetime/allocation patterns
and maintainability. Keep the review proportional and distinguish static
inspection from measured runtime performance.

## Current State

- Baseline revision: `44e545b702f43649985499e07ff3706f74af4656` on `main`.
- Baseline worktree status: clean; branch is four commits ahead of
  `origin/main`.
- The Herdr contract requires Bale to inspect the diff and run task acceptance
  checks, but it does not yet define a mandatory, reusable code-review gate or
  a structured review verdict before acceptance.
- The calculator replay had syntax, arithmetic and static accessibility checks,
  but no persisted review covering complexity, memory lifetime, CPU/I/O cost or
  the limits of performance evidence. No production workload or orchestrator
  performance telemetry was captured.
- The User explicitly authorized this local Harness improvement. No provider,
  global setting, external account, unrelated pane or validation script is in
  scope.

## Proposed Improvement

Add a Bale-owned review gate after receipt/output reconciliation and before
acceptance for every delegated task that creates or modifies executable code,
runtime-affecting assets or runtime configuration. The minimum review inspects
the changed diff and its affected call paths for correctness/edge cases, clean
code and duplication,
complexity/hot loops, redundant CPU/I/O work, allocation and lifetime/leak
patterns, error/resource handling and compatibility. It records a compact
verdict (`passed`, `changes_requested`, `blocked` or `not_applicable`) and only
the findings needed to act.

Use existing tests, benchmarks or profilers when they are available and
authorized; otherwise classify CPU/memory claims as static evidence or unknown
instead of claiming measured performance. Do not add a repository validator or
benchmark script solely for this gate. A high-severity finding blocks
acceptance; a correction gets a new attempt ID and a fresh review of the
changed diff. If the task declares a CPU, memory or latency target, static or
unknown evidence blocks claiming that target is met until an authorized
measurement exists or the User accepts the limitation. Documentation-only
output records `not_applicable` with a reason.

Smallest hypothesis: an explicit, diff-scoped review gate catches resource and
maintainability regressions that a worker receipt and syntax check miss without
reloading the full repository or terminal transcript. Contrary evidence would
be a bounded replay where the checklist causes broad, duplicate work or cannot
produce an actionable verdict. The maintenance owner is the Herdr coordination
skill and its task contract; remove or revise the gate if a proven provider
review service supplies equivalent evidence with lower context cost.

## Scope

May change:

- delegated-task acceptance and review guidance in the Herdr skill, task
  contract, runtime reference, `docs-harness/HERDR-AGENTS.md` and `README.md`;
- this improvement record, its INDEX entry and the narrow ignore exception
  needed to track it.

Must not change:

- Herdr/provider installation, global settings, external accounts or unrelated
  worker panes;
- worker model, effort/Fast, permission/capability or timeout contracts;
- the receipt-first transcript policy, retired validator/script policy or
  existing product files;
- performance claims beyond the evidence actually available.

## Progress

- 2026-09-13: Baseline captured from the clean receipt-first commit. The User
  requested a mandatory Bale review of delegated code for performance, memory,
  CPU efficiency and code cleanliness.
- 2026-09-13: Created this record before intervention edits, as required by the
  Harness improvement lifecycle.
- 2026-09-13: Added the Bale code-review gate to the Herdr skill, task contract,
  runtime reference and worker catalog. The contract is receipt-first,
  diff-scoped and requires explicit static/measured/unknown evidence plus a
  compact verdict before code acceptance.
- 2026-09-13: Added the #020 INDEX and ignore entries. Targeted inspection found
  no contradictory active Herdr rule and no validator, benchmark or dispatch
  script was introduced.
- 2026-09-13: A fresh live worker replay remains pending. The selected
  Antigravity profile still lacks complete native permission/configuration
  proof, and existing idle workers are unrelated sessions that must remain
  untouched. The next fresh BALE session with a proven profile owns the replay.
- 2026-09-13: A fresh bounded native-worker replay exercised the gate without
  loading a terminal transcript. Bale marked `replay-01` `changes_requested`
  after finding that `every()`/`reduce()` skipped sparse holes and traversed the
  input twice. The worker preserved the first attempt and produced `replay-02`
  with one indexed pass; Bale's independent syntax/behavior checks passed.

## Validation

Targeted inspection verifies one consistent review gate across active Herdr
consumers (including `README.md`), explicit static-versus-measured evidence, severity/verdict and
correction rules, receipt-first ordering and no validator/benchmark script. The
native replay produced the following coordinator review entry:

```json
{
  "task_id": "bale-code-review-replay",
  "attempts": [
    {"attempt_id": "replay-01", "status": "changes_requested", "finding": "sparse-array holes were skipped and input was traversed twice"},
    {"attempt_id": "replay-02", "status": "passed", "evidence": ["static: one bounded indexed pass", "static: no retained state, listener or unbounded loop"], "limitations": ["runtime CPU/memory workload not measured"]}
  ],
  "bale_checks": ["node --check worker-code-v2.js", "focused normal/empty/invalid/sparse smoke"],
  "transcript_read": false
}
```

The selected Antigravity provider still cannot be safely replayed because its
native permission/configuration proof is incomplete; the record stays active
with that missing proof and the next fresh BALE owner above.

## Risks

- A static review can miss workload-dependent CPU or memory regressions.
  Mitigation: label evidence as static or unknown and run an existing targeted
  benchmark/profile only when available and authorized.
- A broad checklist can erase the token savings from the tight path.
  Mitigation: review the worker diff and affected paths only, keep findings
  compact, and escalate scope only for runtime-critical or high-risk changes.
- BALE may overrule a valid worker result on a subjective style preference.
  Mitigation: require an evidence-backed finding, severity and actionable
  recommendation; do not block on taste alone.
- A correction loop can create duplicate work. Mitigation: preserve the prior
  receipt/review, use a new attempt ID only after the prior attempt settles, and
  re-review only the changed diff.

## Decision and Result

Keep the intervention provisionally: targeted inspection passed and the native
replay exercised both the `changes_requested` correction path and a passing
diff-scoped review without a transcript read. The provider-specific Herdr replay
remains pending. Owner: the next fresh BALE session with a proven Herdr worker
profile. Keep the record active until that replay is exercised.
