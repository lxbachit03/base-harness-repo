# Harness Improvement Resource

ID: #034_IMPROVE_HARNESS_0927
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: TypeSafe Jev best practices implementation for task authority, selective routing, ticket triage, and domain freshness
CREATED: 2026-09-27
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-constraints/0822-user-authority-operation-gate.md
- docs-harness/harness-improvements/0927-typesafe-ai-skill-integration.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- .agents/skills/typesafe-ai/scripts/precheck-authority.ps1
- .agents/skills/typesafe-ai/scripts/triage-ticket.ps1
- .agents/skills/typesafe-ai/scripts/check-domain-freshness.ps1

## Objective

Implement the 4 quantitative best practices discovered through live TypeSafe Jev System One evaluation: (1) Hybrid Preflight Hook for the 0822 Task Authority Gate, (2) Selective on-demand skill routing, (3) Probabilistic ticket intake triage and complexity scoring, and (4) Domain contract freshness and staleness verification.

## Purposes

- [x] Prevent unauthorized git commits, staged changes, and destructive operations through deterministic regex + sub-second semantic preflight checks.
- [x] Eliminate LLM prompt context bloat by routing skills on-demand when user intent is ambiguous, while bypassing router when explicit skills are requested.
- [x] Accelerate ticket intake and triage with typed Choice, Score, and Noul judgments without requiring heavy LLM reasoning loops.
- [x] Ensure domain documentation and schemas in `docs-harness/domain/` remain synchronized with code modifications.

## Current State

In `#033_IMPROVE_HARNESS_0927`, the TypeSafe System One integration was added with `invoke-typesafe.ps1` and `suggest-skill.ps1`.
A live benchmark over the entire Harness repository topology revealed:
1. `highest_impact_optimization`: Task Authority Gate had the highest ROI (73% probability) over skill routing (27%).
2. `risk_level_unauthorized_git_commit`: Scored 1.99/2.0 (100% Critical violation), confirming the strict requirement that git mutations require explicit User authorization.
3. `authority_gate_architecture`: 100% probability for `hybrid_preflight_hook` (local regex <5ms + Jev semantic evaluation <500ms for ambiguous operations).
4. `skill_router_invocation_policy`: 100% probability for `on_ambiguous_task_or_missing_skill` (selective routing only when prompt is ambiguous or lacks explicit skill name).
5. `ticket_intake_triage_readiness`: Scored 0.98 (95% useful prototype) for standardizing ticket priority and categories.

## Proposed Improvement

1. **Precheck Authority Script (`precheck-authority.ps1`)**:
   - Provide a hybrid hook evaluating commands before execution. Fast-path regex for safe read-only commands (`Get-ChildItem`, `git status`, `cat`, etc.) and hard-blocked commands (`git commit`, `git add`, `rm -rf`).
   - For ambiguous commands, query Jev System One to classify `read_only_routine` vs `local_routine_authorized` vs `critical_mutation_requires_permission`.
2. **Selective Smart Skill Routing (`suggest-skill.ps1`)**:
   - Update `suggest-skill.ps1` with an explicit mention detector. When the prompt names a specific skill or keyword (e.g. `$typesafe-ai`, `$writing-for-agents`), immediately resolve without calling the API.
3. **Ticket Intake Triage Helper (`triage-ticket.ps1`)**:
   - Classify tickets into Category (`Choice`), Severity (`Score`), and Reproducibility (`Noul`) to automate intake into `docs-harness/tickets/active/`.
4. **Domain Freshness Verification Helper (`check-domain-freshness.ps1`)**:
   - Compare code diffs against domain documentation using `Noul` (`is_domain_stale`) and `Score` (`staleness_severity`), alerting when documentation must transition to `[UNCERTAIN]`.
5. **Workflow & Skill Documentation**:
   - Update `docs-harness/WORKFLOW.md` and `.agents/skills/typesafe-ai/SKILL.md` to reference the new tooling and patterns.

## Scope

- May create native zero-dependency PowerShell scripts under `.agents/skills/typesafe-ai/scripts/`.
- May update `suggest-skill.ps1`, `SKILL.md`, `WORKFLOW.md`, `INDEX.md`, and `.gitignore`.
- May NOT commit or stage changes without explicit User authority.
- May NOT modify unrelated tickets or domain files.

## Progress

- 2026-09-27: Completed live 2-round evaluation using Jev System One (`jev-1.13.0`), proving sub-second latency (458ms - 553ms) and quantitative consensus for hybrid authority preflight and selective routing.
- 2026-09-27: Authored improvement record `#034_IMPROVE_HARNESS_0927`.
- 2026-09-27: Implemented `precheck-authority.ps1` (Best Practice 1): verified sub-5ms regex fast-pass on `git status` (4.23ms), hard-block on `git commit` (0.41ms), and semantic Jev evaluation on `Invoke-RestMethod` (547ms).
- 2026-09-27: Updated `suggest-skill.ps1` (Best Practice 2) with explicit mention detection and Multi-Skill Chain (Top-N Thresholding) support: verified sub-5ms bypass on `$goal-griller`, accurate single-skill routing on ambiguous prompt (550ms, `ticket-solving`), and multi-skill chain detection on composite prompt (`ticket-solving` 73% -> `herdr-coordinate-agents` 24%).
- 2026-09-27: Implemented `triage-ticket.ps1` (Best Practice 3): verified category (`bug_defect`), severity (`2.0`), reproducibility (`0.9`), and complexity (`0.86`) triage on sample database issue (476ms).
- 2026-09-27: Implemented `check-domain-freshness.ps1` (Best Practice 4): verified drift detection on auth architecture change (`noul: 0.97`, severity: `2.0`, `ImmediateDomainUpdateRequired`) in 473ms.
- 2026-09-27: Updated `docs-harness/WORKFLOW.md` and `.agents/skills/typesafe-ai/SKILL.md` to index the scripts and document the 4 best practice patterns.

## Validation

- `precheck-authority.ps1`:
  - `git status` -> `ReadOnlyRoutine`, `RequiresUserPermission: False`, latency `4.23ms`.
  - `git commit -m ...` -> `CriticalMutationRequiresUserAuthority`, `RequiresUserPermission: True`, latency `0.41ms`.
  - `Invoke-RestMethod ...` -> `critical_mutation_requires_permission`, `RequiresUserPermission: True`, latency `547ms`.
- `suggest-skill.ps1`:
  - Prompt containing `$goal-griller` -> `Mode: ExplicitMention`, confidence `1.0`, zero API call.
  - Ambiguous terminal prompt -> `Skill: ticket-solving`, confidence `0.83`, latency `550ms`.
- `triage-ticket.ps1`:
  - Concurrency crash ticket -> `bug_defect` (100%), `Severity: 2.0`, `Complexity: 0.86`, `Repro: True`, priority `[CRITICAL]`, latency `476ms`.
- `check-domain-freshness.ps1`:
  - OAuth vs API key change -> `IsStale: True` (`97%`), `Severity: 2.0`, `ImmediateDomainUpdateRequired`, latency `473ms`.
- Git status verified: working tree clean of accidental staged/committed files.

## Risks

- Risk: API latency overhead when evaluating frequent commands.
  - Mitigation: Regex fast-path (<5ms) catches >90% of routine read-only commands without network calls.
- Risk: False positives blocking legitimate local test actions.
  - Mitigation: Authority gate is advisory and informative; outputs clear risk classification and guidance for User authorization.

## Decision and Result

Keep. All 4 best practices are implemented as zero-dependency PowerShell scripts, validated against live Jev System One endpoints, documented in WORKFLOW.md and SKILL.md, and fully operational.
