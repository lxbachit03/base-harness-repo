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
4. Domain Knowledge Synthesis (Gated by User Authority)
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

### Stage 4: Domain Knowledge Synthesis (Requires User Authority)

> [!CAUTION]
> **Strict User Authority Gate**:
> The AI Agent must **NEVER** automatically promote or move an onboarding flow to `docs-harness/domain/` on its own.
> Promotion occurs **ONLY** when explicitly authorized by the User through:
> 1. The User directly commanding the AI agent / Harness repo to promote the flow.
> 2. The User manually moving/approving the artifacts into `docs-harness/domain/`.

When authorized by User:
1. Check existing domain IDs in `docs-harness/` and determine `max(ID) + 1`.
2. Create a new domain resource using `docs-harness/templates/domain.md`:
   - Path: `docs-harness/domain/<MMDD>-<flow-name>-domain.md`
   - Classification:
     - `TAG: [DOMAIN] [CONFIRMED]` if verified by authoritative documentation or User confirmation.
     - `TAG: [DOMAIN] [UNCERTAIN]` if derived only from observed code facts pending human confirmation.
3. Update `docs-harness/INDEX.md` to link the new domain resource under `## TAG: [DOMAIN]`.

**Completion Criterion**: Domain knowledge resource persisted and indexed with verified User authority.

---

## Anti-Patterns & Guardrails

- **Never omit line-range citations in Mermaid diagrams in `activity-diagrams.md`.**
- **Never promote onboarding artifacts to `domain/` without explicit User authority.**
- **Do not mix multiple flows in one folder**: Keep each flow cleanly isolated.
- **Do not invent product policy**: Mark unconfirmed business rules as `[UNCERTAIN]` in domain notes.
- **Do not scan all onboarding folders at once**: Always route directly to the active `<flow-name>/`.
