# Jev System One Configuration & Manifest

This document is the **canonical declarative manifest** for TypeSafe Jev System One integration in this repository.
It defines the active project context, catalog of semantic scripts, question criteria, and threshold rules.
AI agents invoking the `$enhance-jev` skill read, calibrate, and synchronize this file with local PowerShell scripts.

---

## 1. Project Context & Environment

- **Project Name**: Base Harness Repository (Adaptable for Target Applications)
- **Domain**: Agent Harness Infrastructure, Multi-Agent Orchestration, and Developer Tooling
- **Primary Languages**: PowerShell (zero-dependency local scripts), Markdown (agent instructions)
- **Host Platform**: Windows PowerShell 5.1+ / PowerShell Core (UTF-8 byte stream encoding)
- **Core Security Invariant**: 0822 User Authority Gate — Read-only by default. Routine local test/edits authorized for fix/build tasks. Git index staging (`git add`), commits (`git commit`), pushes (`git push`), credential access, and destructive file operations strictly require explicit User authorization. The Jev helpers' own API-key lookup and TypeSafe API calls are permitted by default (User decision 2026-10-05).
- **Model Resolution**: `jev-latest` (resolving to `jev-1.13.0` via `https://api.typesafe.ai/v1/systemone`)
- **Credential Storage**: Dynamic resolution via `$env:TYPESAFE_API_KEY`, Windows User Registry, or Machine Registry.

---

## 2. Active Semantic Scripts Catalog

All active Jev scripts reside flatly in `.agents/skills/typesafe-ai/scripts/` and share the underlying `invoke-typesafe.ps1` helper.

| Script Name | Jev Primitives | Purpose | Target Input | Status |
| :--- | :--- | :--- | :--- | :--- |
| [`invoke-typesafe.ps1`](../.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1) | Core Transport | Dynamic key discovery, UTF-8 payload encoding, timing, real-time observability, and graceful offline fallback | `$State`, `$Questions` hashtable | `CoreInfrastructure` |
| [`precheck-authority.ps1`](../.agents/skills/typesafe-ai/scripts/precheck-authority.ps1) | `Choice` + `Score` | Task Authority Gate: Jev evaluation for every command, with a quote-aware per-segment regex hard boundary that always requires User authority for staging, commits, pushes and destructive commands | Terminal command string, action description, target files | `Active` |
| [`suggest-skill.ps1`](../.agents/skills/typesafe-ai/scripts/suggest-skill.ps1) | `Choice` (Top-N) | Selective Smart Skill Router: explicit-mention bypass, on-demand Jev Choice, and Multi-Skill Chain routing | User prompt text | `Active` |
| [`triage-ticket.ps1`](../.agents/skills/typesafe-ai/scripts/triage-ticket.ps1) | `Choice` + `Score` + `Noul` | Automated ticket intake triage: category, severity, implementation complexity, and reproduction step verification | Raw ticket text or markdown file | `Active` |
| [`check-domain-freshness.ps1`](../.agents/skills/typesafe-ai/scripts/check-domain-freshness.ps1) | `Noul` + `Score` | Domain contract drift detection: verifies code diffs against domain specifications and schemas | Domain document markdown, code diff summary | `Active` |

Usage practices:

1. **Authority precheck** (`precheck-authority.ps1`): Jev classifies every
   shell command; a hard-boundary segment (staging, commit, push, destructive)
   always requires User authority.
2. **On-demand skill routing** (`suggest-skill.ps1`): call the router only when
   the prompt is ambiguous or names no skill; an explicit `$skill-name` bypasses
   it.
3. **Ticket triage** (`triage-ticket.ps1`): typed category, severity,
   complexity and reproducibility judgments standardize priority.
4. **Domain freshness** (`check-domain-freshness.ps1`): staleness judgments on
   code diffs flag contradicted claims per `docs-harness/domain/README.md`.
5. **Manifest synchronization** (`$enhance-jev`): adapting Jev to a project
   updates this manifest and the scripts together.

---

## 3. Script Specifications & Primitives Mapping

### 3.1. `precheck-authority.ps1`
- **Purpose**: Enforce the 0822 User Authority Gate before running shell commands.
- **Invocation** (run the script directly, without `-Quiet`; `-TargetFiles` is a string array):
  ```powershell
  & .\.agents\skills\typesafe-ai\scripts\precheck-authority.ps1 -Command '<exact command>' -ActionDescription '<why>' -TargetFiles @('<path>')
  ```
- **State Shape** (built by the script):
  ```json
  {
    "command": "<trimmed shell command>",
    "segments": ["<segments split outside quotes>"],
    "action_description": "<optional context>",
    "target_files": ["<file paths>"],
    "authority_policy": "0822 policy summary"
  }
  ```
- **Questions**:
  - `authority_classification` (`choice`):
    - `read_only_routine`: Zero mutations, file inspection, read-only tests.
    - `local_routine_authorized`: Routine local build/test/edits authorized by fix/build.
    - `critical_mutation_requires_permission`: Git add/commit/push or branch deletion, external requests or credential access (other than the Jev helpers' own TypeSafe calls and key lookup), permanent deletion.
  - `risk_score` (`score`):
    - Level 0: Safe (zero persistence).
    - Level 1: Low to Moderate (local file change, easily discarded).
    - Level 2: High (persistent external mutation, commit/push, destructive).
- **Decision Logic**:
  - The command is split into segments on `;`, `|`, `||`, `&&`, newlines, `$(` and backtick, ignoring separators inside quotes (substitution still splits inside double quotes).
  - Jev classifies every command (no regex fast path; User decision 2026-10-05), so each verdict prints its request and response.
  - Requires explicit User confirmation if Jev returns `critical_mutation_requires_permission`, `risk_score >= 1.4`, or any segment matches the hard boundary (`git add/commit/push/rebase/reset --hard/clean -f`, `rm -r`, recursive `Remove-Item`, format, drop database).
  - When Jev is unavailable, a conservative heuristic restricts any `git`, delete, write or web command.

### 3.2. `suggest-skill.ps1`
- **Purpose**: Select optimal skill(s) without context bloat.
- **State Shape**:
  ```json
  { "user_prompt": "<raw prompt>" }
  ```
- **Questions**:
  - `suggested_skill` (`choice`): Evaluates against the skill criteria listed in `suggest-skill.ps1`.
- **Decision Logic**:
  - Explicit-mention bypass: if prompt contains `$skill-name`, immediately return `ExplicitMention` (0ms API).
  - Ambiguous prompt: calls Jev; top skill is `PrimarySkill`; any skill with `probability >= 0.12` becomes `SupportingSkills`.
  - Sets `IsComposite = True` when multiple skills are active.

### 3.3. `triage-ticket.ps1`
- **Purpose**: Standardize ticket intake into `docs-harness/tickets/active/`.
- **State Shape**:
  ```json
  { "ticket_content": "<markdown or raw text>" }
  ```
- **Questions**:
  - `category` (`choice`): `bug_defect`, `feature_request`, `harness_refactor`, `domain_documentation`.
  - `severity` (`score`): 0 (Cosmetic), 1 (Degraded/Workaround), 2 (Blocking/Critical).
  - `reproducibility` (`noul`): Steps to reproduce present (prob >= 0.5).
  - `complexity` (`score`): 0 (Trivial), 1 (Moderate), 2 (Complex/Architectural).
- **Priority Mapping**: `Severity >= 1.4` -> `[CRITIAL]` (the catalog spelling in `templates/README.md`), `>= 0.7` -> `[MEDIUM]`, else `[NORMAL]`.

### 3.4. `check-domain-freshness.ps1`
- **Purpose**: Audit code changes against `docs-harness/domain/`.
- **State Shape**:
  ```json
  {
    "domain_specification": "<domain markdown>",
    "code_diff_summary": "<diff or modified code summary>"
  }
  ```
- **Questions**:
  - `is_domain_stale` (`noul`): Probability code invalidates domain specification.
  - `staleness_severity` (`score`): 0 (No impact), 1 (Minor drift), 2 (Breaking staleness).
- **Decision Logic**: If `is_domain_stale >= 0.5` -> flag the claim `STATUS: needs-review` and `Freshness: STALE` (`MarkStaleAndScheduleReview`); if `staleness_severity >= 1.4` -> `ImmediateDomainUpdateRequired`. Confirmation tags stay unchanged; only the User changes them (`docs-harness/domain/README.md`).

### 3.5. jev-hook generic consult (`invoke-typesafe.ps1`)
- **Purpose**: The gate consult that `layers/layer-2/hooks/jev-hook.md` requires for the file, web, coordination and other tool groups.
- **State Shape** (PowerShell hashtable passed as `-State`):
  ```powershell
  @{
    user_intent       = "<the User's current request>"
    action_group      = "<file_ops_read (includes Grep/Glob) | file_ops_write | web | coordination | other>"
    pending_action    = "<what will run, on which targets>"
    targets           = @("<paths or resources>")
    authority_excerpt = "<the applicable AGENTS.md Task authority lines>"
  }
  ```
- **Questions** (hashtable passed as `-Questions`; a `choice` takes a criteria hashtable, a `score` takes an ordered criteria array):
  ```powershell
  @{
    gate_decision = @{ type = "choice"; instructions = "<decide whether the pending action may run now>"
      criteria = @{ proceed = "<...>"; proceed_with_caution = "<...>"; pause_ask_user = "<...>"; veto = "<...>" } }
    risk_score    = @{ type = "score"; instructions = "<rate the risk>"
      criteria = @("Safe; read-only", "Local reversible change", "External or hard to undo") }
  }
  ```
- **Invocation** (run the script directly, without `-Quiet`):
  ```powershell
  $r = & .\.agents\skills\typesafe-ai\scripts\invoke-typesafe.ps1 -State $state -Questions $questions
  $r.Answers.gate_decision.choice
  ```
- **Decision Logic**: Act on `Answers.gate_decision.choice` per the hook's Verdict handling; `Fallback = $true` means the hook's bypass rule applies.

---

## 4. Customization

Adapt this manifest and its scripts to a project with the
[`enhance-jev`](../.agents/skills/enhance-jev/SKILL.md) skill, which owns the
procedure.
