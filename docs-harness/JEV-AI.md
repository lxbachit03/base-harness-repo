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
- **Core Security Invariant**: 0822 User Authority Gate — Read-only by default. Routine local test/edits authorized for fix/build tasks. Git index staging (`git add`), commits (`git commit`), pushes (`git push`), credential access, and destructive file operations strictly require explicit User authorization.
- **Model Resolution**: `jev-latest` (resolving to `jev-1.13.0` via `https://api.typesafe.ai/v1/systemone`)
- **Credential Storage**: Dynamic resolution via `$env:TYPESAFE_API_KEY`, Windows User Registry, or Machine Registry.

---

## 2. Active Semantic Scripts Catalog

All active Jev scripts reside flatly in `.agents/skills/typesafe-ai/scripts/` and share the underlying `invoke-typesafe.ps1` helper.

| Script Name | Jev Primitives | Purpose | Target Input | Status |
| :--- | :--- | :--- | :--- | :--- |
| [`invoke-typesafe.ps1`](../.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1) | Core Transport | Dynamic key discovery, UTF-8 payload encoding, timing, real-time observability, and graceful offline fallback | `$State`, `$Questions` hashtable | `CoreInfrastructure` |
| [`precheck-authority.ps1`](../.agents/skills/typesafe-ai/scripts/precheck-authority.ps1) | `Choice` + `Score` | Hybrid Task Authority Gate: <5ms regex fast-pass for read-only / hard-blocked commands, Jev evaluation for ambiguous mutations | Terminal command string, action description, target files | `Active` |
| [`suggest-skill.ps1`](../.agents/skills/typesafe-ai/scripts/suggest-skill.ps1) | `Choice` (Top-N) | Selective Smart Skill Router: explicit-mention bypass, on-demand Jev Choice, and Multi-Skill Chain routing | User prompt text | `Active` |
| [`triage-ticket.ps1`](../.agents/skills/typesafe-ai/scripts/triage-ticket.ps1) | `Choice` + `Score` + `Noul` | Automated ticket intake triage: category, severity, implementation complexity, and reproduction step verification | Raw ticket text or markdown file | `Active` |
| [`check-domain-freshness.ps1`](../.agents/skills/typesafe-ai/scripts/check-domain-freshness.ps1) | `Noul` + `Score` | Domain contract drift detection: verifies code diffs against domain specifications and schemas | Domain document markdown, code diff summary | `Active` |

---

## 3. Script Specifications & Primitives Mapping

### 3.1. `precheck-authority.ps1`
- **Purpose**: Enforce the 0822 User Authority Gate before running shell commands.
- **State Shape**:
  ```json
  {
    "command": "<trimmed shell command>",
    "action_description": "<optional context>",
    "target_files": ["<file paths>"],
    "authority_policy": "0822 policy summary"
  }
  ```
- **Questions**:
  - `authority_classification` (`choice`):
    - `read_only_routine`: Zero mutations, file inspection, read-only tests.
    - `local_routine_authorized`: Routine local build/test/edits authorized by fix/build.
    - `critical_mutation_requires_permission`: Git add/commit/push, external requests, credentials, permanent deletion.
  - `risk_score` (`score`):
    - Level 0: Safe (zero persistence).
    - Level 1: Low to Moderate (local file change, easily discarded).
    - Level 2: High (persistent external mutation, commit/push, destructive).
- **Decision Logic**:
  - Fast regex clears read-only commands in <5ms.
  - Fast regex hard-blocks unapproved git commits/adds/pushes in <5ms.
  - Ambiguous commands: if Jev classifies as `critical_mutation_requires_permission` or `risk_score >= 1.4` -> Requires explicit User confirmation.

### 3.2. `suggest-skill.ps1`
- **Purpose**: Select optimal skill(s) without context bloat.
- **State Shape**:
  ```json
  { "user_prompt": "<raw prompt>" }
  ```
- **Questions**:
  - `suggested_skill` (`choice`): Evaluates against 17 skills catalog.
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
- **Priority Mapping**: `Severity >= 1.4` -> `[CRITICAL]`, `>= 0.7` -> `[MEDIUM]`, else `[NORMAL]`.

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
- **Decision Logic**: If `is_domain_stale >= 0.5` -> flag `[UNCERTAIN]`; if `staleness_severity >= 1.4` -> `ImmediateDomainUpdateRequired`.

---

## 4. Dynamic Customization & Enhancement Protocol (for `$enhance-jev`)

When the user invokes the `$enhance-jev` skill with a project intent:
1. **Clarification Gate**: If user intent is ambiguous, conflicting, or lacks required domain specifics, the agent **MUST pause and ask clarifying questions** before editing this file or mutating scripts.
2. **Manifest Evolution**: The agent updates sections 1, 2, and 3 of this file to reflect new project primitives (e.g., custom gRPC triage, SQL migration safety, API schema validation).
3. **Script Synchronization**: The agent creates, modifies, or removes PowerShell scripts under `.agents/skills/typesafe-ai/scripts/` to match the updated manifest. All new scripts must:
   - Reside flatly in `.agents/skills/typesafe-ai/scripts/<script-name>.ps1`.
   - Call `invoke-typesafe.ps1` for communication.
   - Include real-time observability (`Write-Host` logs and latency).
   - Implement graceful fallback when offline.
4. **Local Verification**: The agent runs live test calls for all created or modified scripts, verifying execution latency and correct object structures.
