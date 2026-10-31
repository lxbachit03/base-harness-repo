# Harness Improvement Resource

ID: #036_IMPROVE_HARNESS_0930
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Layer-2 hooks mechanism with jev-hook pre-action Jev gate
CREATED: 2026-09-30
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-2/hooks/README.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- docs-harness/JEV-AI.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- .agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1
- .agents/skills/typesafe-ai/scripts/precheck-authority.ps1

## Current policy notice (2026-10-05)

The shell gate no longer has a regex fast path ([#044](1005-gate-and-jev-decisions.md)):
every shell consult calls Jev and prints its request and response. The hook's
groups, exemptions and toggle location were also refined in #042 and #044.
This record retains its original scope, evidence and decision as history.

## Objective

Establish a hook mechanism at `docs-harness/layers/layer-2/hooks/`: user-toggled,
agent-facing pre-action gates that invoke runnable local tooling, loaded through
the session-start layers walk. Ship the first hook, `jev-hook.md`, which requires
every agent action group (file ops, shell/external, agent coordination, other
tool calls) to receive a TypeSafe Jev verdict before execution.

## Purposes

- [x] Give the User a checklist-based on/off switch for every hook; only the
  User toggles it, anytime, and file state is the only authority.
- [x] Require a Jev verdict before agent actions while the hook is enabled,
  per the User's explicit requirement (read, write, edit, web search, agent
  coordination, tool calls).
- [x] Reuse existing typesafe-ai scripts (precheck-authority.ps1 for shell
  commands; invoke-typesafe.ps1 default with intent-built state/questions)
  instead of inventing new scripts when existing ones fit.
- [x] Degrade safely when Jev cannot answer: bypass with a clear
  JEV GATE BYPASS warning, never lowering AGENTS.md authority.

## Current State

Baseline: branch main at 1f7c868; working tree carries the pending modified
record `0816-filesystem-index-sync-rule.md` (#005). `docs-harness/layers/` holds
only `layer-1/agents/` (model-matched add-on prompts). Jev tooling lives flatly
in `.agents/skills/typesafe-ai/scripts/` (invoke-typesafe.ps1,
precheck-authority.ps1, suggest-skill.ps1, triage-ticket.ps1,
check-domain-freshness.ps1) with manifest `docs-harness/JEV-AI.md`. No hook
mechanism exists; nothing gates every agent action behind a Jev consult.
TYPESAFE_API_KEY present in process environment and Windows User registry
(verified 2026-09-30, presence only, value not printed).

## Proposed Improvement

1. `docs-harness/layers/layer-2/hooks/README.md`: hook mechanism contract —
   loading via the session-start layers walk, activation checklist semantics
   (file state authoritative; agents read, never toggle), self-exemption rule,
   new-hook skeleton.
2. `docs-harness/layers/layer-2/hooks/jev-hook.md`: the Jev pre-action gate —
   action groups, script selection (precheck-authority.ps1 for bash commands;
   invoke-typesafe.ps1 default otherwise with self-built state/questions),
   verdict handling, unavailable-bypass default.
3. `docs-harness/layers/README.md`: extend the layer walk so `hooks/`
   subfolders are inspected per their own contract; hooks are not
   model-matched.
4. `docs-harness/INDEX.md`: folder tree gains `layer-2/hooks`; the layers
   routing section links the hooks README; this record is indexed under
   TAG: [IMPROVE_HARNESS].
5. `.gitignore`: extend the layers allow-list chain for
   `docs-harness/layers/layer-2/hooks/` and its two files.

No new PowerShell scripts are created: existing scripts fit the requirement,
so the default-path rule (invoke-typesafe.ps1 with self-built state/questions)
covers the remainder. `jev-hook.md` is instruction-level: the agent runs the
scripts; no runtime middleware forces tool calls. JEV-AI.md stays unchanged
because its catalog owns scripts, not consumers of them.

## Scope

In scope: the five paths above plus this record. Out of scope: product code,
JEV-AI.md script catalog, new Jev scripts, AGENTS.md authority policy,
git staging/commits, Herdr coordination, and record #005
(filesystem-index-sync rule, which remains pending its own User decision).

## Progress

- 2026-09-30: goal shaped with goal-griller; three User answers recorded —
  Jev-unavailable fallback = bypass with clear warning; scope = all action
  groups; placement = `docs-harness/layers/layer-2/hooks/` (layers-based, not
  a new top-level folder). Draft accepted; implementation started.
- 2026-09-30: implementation completed (all five paths). Live gate exercise
  passed: precheck-authority.ps1 fast-path `Get-Content README.md` →
  `Permitted=True`, `RegexFastPath`, 4ms; ambiguous sample
  `Set-Content ...` (not executed) → real Jev call to jev-1.13.0 →
  `local_routine_authorized`, risk 0.93, 1044ms, `SEMANTIC-PASS`;
  hook-contract consult via invoke-typesafe.ps1 → `gate_decision=proceed`
  (0.46 confidence), `risk_score=1.0`, 454ms, Success=True.
- 2026-09-30: dormant-path fresh replay (native read-only subagent,
  simulated fresh session — not a Herdr worker) passed: startup routine
  retrieved hook file layer-2/hooks/jev-hook.md through the layers walk,
  activation state `unchecked`, gate not applied, no Jev consult attempted,
  task answered correctly (9 plans/active files), no files modified.
- 2026-09-30: User checked the activation checkbox (verified in file:
  `- [x]`). Mid-session toggle reported → gate applied to the ongoing
  session. Enabled-path fresh replay (native read-only subagent) passed:
  hook retrieved, state `checked`, gate applied; for the gated file-ops
  group the subagent ran one real invoke-typesafe.ps1 consult (jev-1.13.0,
  `gate_decision=proceed` conf 0.99, risk 0.01, 530ms) and executed the
  reads only after the verdict; exemptions honored (session-start retrieval
  and the consult itself); no bypass announced; one locally failed consult
  attempt (bash quoting, no API call) was retried unchanged; task answered
  correctly (9 files); no mutations. In-session gates also observed: two
  invoke-typesafe.ps1 consults by the primary session (coordination
  `proceed` 0.96/921ms; record edit `proceed` 0.98/440ms).
- 2026-09-30 (revision): User reported that Jev request/response logs were
  missing in the main session. Root cause: the original request contained no
  explicit logging clause and the hook contract did not forbid `-Quiet`, so
  the primary session's direct consults ran quiet and showed only one-line
  summaries (full payloads appeared only in the precheck-authority.ps1
  semantic run). Fix: `jev-hook.md` gains a `Consult observability` rule —
  every consult must run without `-Quiet` so the full request payload,
  response answers, model, and latency appear in session output. Verified by
  the two revision consults themselves (non-quiet, full payloads visible:
  `proceed` 0.89/535ms and `proceed` 0.99/458ms, jev-1.13.0). Optional
  follow-up proposal, not implemented: durable file logging would need a
  `-LogPath` parameter on invoke-typesafe.ps1 plus a JEV-AI.md manifest
  sync.
- 2026-10-03: STATUS normalized from "completed (revised 2026-09-30: consult
  observability rule)" to "completed" by #040; the revision is recorded in the
  entry above.

## Validation

- `git check-ignore -v`: planned hook paths are not ignored after the
  .gitignore chain change (before: both blocked by `docs-harness/layers/*`).
- INDEX self-review: tree, routes, links, ID uniqueness (#036, max prior
  #035), final diff inspection.
- Live gate exercise: run precheck-authority.ps1 fast-path on a read-only
  sample, its ambiguous-command path through Jev, and one invoke-typesafe.ps1
  consult built per the hook contract; record verdicts and latency.
- Fresh replay (bounded, simulated session via native read-only subagent):
  startup routine plus a read-only task; expect hooks retrieval and dormant
  behavior (checkbox unchecked → gate not applied, no Jev call).
- Pending next case: a fresh session with the hook enabled (User-checked)
  verifying consult-per-action-group before execution.

## Risks

- Over-gating latency: one Jev round trip per action group slows heavy
  sessions. Proposal (implemented): batch same-intent actions into one
  consult per turn; the User can disable via the checklist.
- Instruction-level enforcement: the gate is prompt-mediated; a
  non-compliant agent could skip consults. Proposal: verdicts and bypasses
  are reported in session outcome summaries so omission is observable.
- Prose-only activation: agents must not infer activation from User
  conversation; only the file checkbox applies.

## Decision and Result

Keep. Both replay paths and the live tool path passed; the mechanism is
retained as the repository hook contract.

Observed result:

- Mechanism: hooks README + jev-hook.md exist and are allow-listed; INDEX
  routes layer-2/hooks and this record; layers walk loads hooks per
  checklist.
- Dormant path replay: PASS (receipt in Progress, 2026-09-30).
- Enabled path replay: PASS (consult-per-action-group observed before
  execution; receipts in Progress, 2026-09-30).
- Live gate exercise: PASS (fast-path, Jev semantic, hook-contract consult;
  receipts in Progress, 2026-09-30).

STATUS set to completed. Remaining limits: instruction-level enforcement
(prompt-mediated, not runtime middleware) and simulated fresh sessions via
native subagents rather than Herdr workers; both stay recorded under Risks.
No external actions beyond the Jev eval API calls used by the repository's
established scripts; no commits or staging were performed.
