# Onboarding Workspace (`docs-harness/onboarding/`)

This directory is the dedicated working space for onboarding and mapping brownfield projects, managed primarily by the `$onboarding` skill.

> [!IMPORTANT]
> **Top-Down Routing & Token Saving Rule**:
> - This directory is **NEVER** loaded entirely at Session Start.
> - When working with a specific data/business flow, load **ONLY** the relevant subfolder (e.g. `docs-harness/onboarding/<target-flow>/`).

> [!CAUTION]
> **User Authority Gate for Domain Knowledge**:
> - Artifacts in `onboarding/` are exploratory working materials.
> - The AI Agent **NEVER** automatically promotes or moves an onboarding flow to `docs-harness/domain/` without explicit **User Authority**.
> - Promotion occurs only when the User explicitly requests the AI Agent to synthesize the domain knowledge or manually moves/approves the flow.

---

## Directory Structure Pattern

Each data or business flow is isolated into its own subfolder:

```text
docs-harness/onboarding/
├── README.md                              <- This guide
├── <flow-name-1>/                         <- Example: user-authentication/
│   ├── README.md                          <- Flow overview & entry points
│   ├── activity-diagrams.md               <- Mermaid diagrams with file:line ranges
│   ├── data-flow-map.md                   <- Step-by-step transformation path
│   ├── entity-schemas.md                  <- Schemas & database models
│   ├── integration-points.md              <- External services & dependencies
│   └── quirks-and-gotchas.md              <- Undocumented legacy edge cases
└── <flow-name-2>/                         <- Example: payment-processing/
    └── ...
```

---

## Required Artifacts per Flow

1. **`activity-diagrams.md`**: Visual Mermaid activity/sequence diagram mapping the data flow. Every node must cite the related file path and code line ranges (e.g., `Node["Handler<br/>src/api/auth.ts:L20-L45"]`).
2. **`data-flow-map.md`**: Detailed prose trace of the end-to-end data transformation.
3. **`entity-schemas.md`**: Data models, schemas, and interface definitions.
4. **`integration-points.md`**: External services, queues, environment configs, and secrets.
5. **`quirks-and-gotchas.md`**: Edge cases, legacy workarounds, and implicit logic.

---

## Lifecycle: From Onboarding to Domain Knowledge

1. **Investigate**: Trace the codebase and populate all 5 artifacts within `onboarding/<flow-name>/`.
2. **User Authority Check**: Await explicit user command or manual user promotion.
3. **Synthesize**: Extract core concepts, business invariants, and terminology into `docs-harness/domain/`.
4. **Index**: Register the synthesized domain knowledge in `docs-harness/INDEX.md` under `## TAG: [DOMAIN]` (`[CONFIRMED]` or `[UNCERTAIN]`).
