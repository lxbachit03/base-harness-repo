# Jev System One Configuration & Manifest

This document is the **canonical declarative manifest** for TypeSafe Jev System One integration in this repository.
It defines the active project context, semantic-script catalog, request handling, and fallback rules.
Keep this manifest aligned with changes to the local PowerShell scripts.

---

## 1. Project Context & Environment

- **Project Name**: Base Harness Repository (Adaptable for Target Applications)
- **Domain**: Agent Harness Infrastructure, Multi-Agent Orchestration, and Developer Tooling
- **Primary Languages**: PowerShell (zero-dependency local scripts), Markdown (agent instructions)
- **Host Platform**: Windows PowerShell 5.1+ / PowerShell Core (UTF-8 byte stream encoding)
- **Core Security Invariant**: 0822 User Authority Gate — Read-only by default. Routine local edits and verification for fix/build tasks follow `docs-harness/harness-constraints/0822-user-authority-operation-gate.md` and the project constraints. Git index staging (`git add`), commits (`git commit`), pushes (`git push`), credential access, and destructive file operations strictly require explicit User authorization. The Jev helpers' own API-key lookup and TypeSafe API calls are permitted by default (User decision 2026-10-05).
- **Model Resolution**: `jev-latest` is a moving alias. Record the model ID
  returned by each successful API response rather than assuming a fixed version.
- **Credential Storage**: Dynamic resolution via `$env:TYPESAFE_API_KEY`, Windows User Registry, or Machine Registry.

---

## 2. Active Semantic Scripts Catalog

The active Jev transport resides in `.agents/skills/typesafe-ai/scripts/`.

| Script Name | Jev Primitives | Purpose | Target Input | Status |
| :--- | :--- | :--- | :--- | :--- |
| [`invoke-typesafe.ps1`](../.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1) | Core Transport | Dynamic key discovery, UTF-8 payload encoding, timing, real-time observability, and graceful offline fallback | `$State`, `$Questions` hashtable | `CoreInfrastructure` |

The `jev-hook` checkbox controls automatic consultation. The User retired the
dedicated authority, ticket-triage, domain-freshness, and skill-routing Jev
helpers. Apply #009 task authority, use native agent skill selection, and follow
the relevant ticket/domain workflows directly. Beyond the jev-hook, consult
Jev only when the User asks for it, for example by naming Jev.

---

## 3. Script Specifications & Primitives Mapping

### 3.0. `invoke-typesafe.ps1`

- Preserve structured JSON within the API's documented nesting limit; treat
  serialization warnings or unsupported depth as an explicit fallback rather
  than sending truncated state.
- Require a model and one answer for every requested question. For supported
  Choice, Score, and Noul questions, validate the answer's type and required
  value, including numeric ranges, before returning `Success = true`.
- An invalid response returns `Success = false`, `Fallback = true`, and an
  `InvalidResponse` error (or throws in `-Strict` mode). Expose an HTTP status
  when available; retain full request/response observability and the existing
  graceful fallback for unavailable Jev.

### 3.1. Optional jev-hook generic consult (`invoke-typesafe.ps1`)
- **Purpose**: When `layers/layer-2/hooks/jev-hook.md` is enabled, the generic
  gate consult covers each listed action group. Check the hook's checkbox for
  its current activation state.
- **State Shape** (PowerShell hashtable passed as `-State`):
  ```powershell
  @{
    user_intent       = "<the User's current request>"
    action_group      = "<file_ops_read (includes Grep/Glob) | file_ops_write | shell | web | coordination | other>"
    pending_action    = "<what will run, on which targets>"
    targets           = @("<paths or resources>")
    authority_excerpt = "<the applicable #009 task authority and project constraints>"
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
