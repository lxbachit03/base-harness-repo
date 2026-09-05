---
name: onboarding
description: Onboard and map brownfield repositories by isolating and investigating discrete business/data flows into dedicated subfolders (`docs-harness/onboarding/<flow-name>/`) and synthesizing domain knowledge for `docs-harness/domain/`.
---

# Onboarding Brownfield Flows

Turn an unfamiliar or complex brownfield codebase into clean, modular domain knowledge by investigating and isolating one discrete data or business flow at a time.

## Core Principle: Flow Isolation

Brownfield systems contain multiple overlapping data pipelines, legacy quirks, and business paths. Attempting to map the whole repository at once causes **context bloat** and **hallucinated assumptions**.

Instead, isolate each flow into its own dedicated workspace:
`docs-harness/onboarding/<flow-name>/`

> [!IMPORTANT]
> **Token & Context Constraint**:
> Never load or scan the entire `docs-harness/onboarding/` directory. When investigating or working with a specific flow, use **Top-Down Routing** to load **only** the target subfolder (`docs-harness/onboarding/<target-flow>/`).

---

## 4-Stage Onboarding Workflow

```text
1. Flow Discovery & Boundary Selection
   ↓
2. Dedicated Workspace Creation (`onboarding/<flow-name>/`)
   ↓
3. Deep Flow Tracing & Evidence Artifacts
   ↓
4. Domain Knowledge Synthesis (Evidence and Authority Gated)
```

### Stage 1: Flow Discovery & Boundary Selection

1. Identify the high-level boundaries of the target feature, data ingestion pipeline, or API workflow.
2. Choose a descriptive, kebab-case flow name (e.g., `user-authentication`, `order-fulfillment-pipeline`, `webhook-event-ingestion`).
3. Define the entry point (e.g., HTTP route, message queue consumer, CLI command) and terminal exit point (e.g., database commit, third-party webhook dispatch, response payload).

**Completion Criterion**: Target flow name and entry/exit boundaries explicitly agreed or identified.

---

### Stage 2: Dedicated Workspace Creation

1. Create the subfolder:
   `docs-harness/onboarding/<flow-name>/`
2. Initialize the flow index file:
   `docs-harness/onboarding/<flow-name>/README.md`
   - Document Flow Name, Purpose, Primary Entry Points, and Known Stakeholder Contracts.

**Completion Criterion**: Directory `docs-harness/onboarding/<flow-name>/README.md` exists and anchors the flow.

---

### Stage 3: Deep Flow Tracing & Artifact Generation

Within `docs-harness/onboarding/<flow-name>/`, create dedicated artifact files based on the nature of the flow:

- **`activity-diagrams.md`**: Visual activity / flow diagram using **Mermaid**. Every node, branch, and state transition **must explicitly contain the target file path and code line ranges** (e.g., `NodeA["Validate Request<br/>(src/api/auth.ts:L15-L42)"]`).
- **`data-flow-map.md`**: Step-by-step text trace of how data transforms from input to storage.
- **`entity-schemas.md`**: Key database models, DTOs, and interface contracts involved.
- **`integration-points.md`**: External APIs, message queues, environment secrets, and sidecars.
- **`quirks-and-gotchas.md`**: Legacy workarounds, undocumented edge cases, and failure modes observed in code.

**Rules for Tracing**:
- Cite concrete file paths and line ranges (e.g. `[src/auth/jwt.ts](file:///D:/repos/...#L20-L45)`).
- In Mermaid diagrams in `activity-diagrams.md`, ensure every execution step labels the exact `filename:L<start>-L<end>`.
- Distinguish between **Authoritative** (documented requirements) and **Observed** (current implementation facts).

**Completion Criterion**: All 5 artifact files created with verified citations and Mermaid line-level diagrams.

---

### Stage 4: Evidence-backed Domain Capture and Freshness

Run this stage after Stage 3 has complete, source-cited evidence. The explicit
`$onboarding` request is the workflow scope for creating a bounded domain
resource; it does not grant confirmation of business policy.

1. Check existing domain IDs in `docs-harness/` and determine `max(ID) + 1`.
2. Confirm the flow name is a non-colliding lowercase-kebab-case slug and use
   the date-prefixed path:
   `docs-harness/domain/<MMDD>-<flow-name>/README.md`.
3. Create the README from `docs-harness/templates/domain.md`. Record every
   claim with a repository path and line range, ticket/section reference, or
   Q&A decision. Keep contradictions and open questions visible, and use two
   independent sources when practical.
4. Use separate `TAG: [DOMAIN]` and `TAG: [UNCERTAIN]` lines by default. Change
   the state to `[CONFIRMED]` only when the User explicitly confirms the
   knowledge. Keep the onboarding artifacts in their flow workspace and link
   them from `REFERENCES` instead of copying the full transcript.
5. Record the capture scope and `Freshness: CURRENT`, then update
   `docs-harness/INDEX.md` under the `[UNCERTAIN]` or `[CONFIRMED]` route after
   the README exists.

**Completion Criterion**: An evidence-backed date-prefixed domain README
exists, carries complete metadata/references/freshness/open questions, remains
`[UNCERTAIN]` without explicit confirmation, and is indexed in the correct
classification route.

### Domain freshness after logic changes

When a runtime-logic, persistence, contract, or data-flow code change occurs,
compare changed paths with each domain resource's `REFERENCES`, evidence
citations, and linked service/data-flow dependencies. Include a domain when
impact is uncertain. Re-check every claim and line-range citation:

- record `Freshness: CURRENT`, validation date, scope, and result when claims
  still hold;
- record `STATUS: needs-review`, `Freshness: STALE`, the changed source, and the
  unresolved question, then pause when a citation or claim no longer holds;
- preserve `[CONFIRMED]` content during automatic maintenance; directly
  evidenced `[UNCERTAIN]` updates remain `[UNCERTAIN]`.

---

## Anti-Patterns & Guardrails

- **Never omit line-range citations in Mermaid diagrams in `activity-diagrams.md`.**
- Keep onboarding artifacts in their flow workspace and create only the
  source-backed domain README required by the capture gate.
- Keep `[UNCERTAIN]` and `[CONFIRMED]` states separate; explicit User
  confirmation is the promotion authority.
- Treat an affected domain as current only after its freshness result is
  recorded; stale or contradictory claims require `Needs review`/`STALE` and a
  pause.
- **Do not mix multiple flows in one folder**: Keep each flow cleanly isolated.
- **Do not invent product policy**: Mark unconfirmed business rules as `[UNCERTAIN]` in domain notes.
- **Do not scan all onboarding folders at once**: Always route directly to the active `<flow-name>/`.
