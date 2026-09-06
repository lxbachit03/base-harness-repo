# Onboarding Workspace

This folder owns exploratory evidence for named business/data flows.
docs-harness/domain/README.md owns subsequent domain capture and confirmation.

Read only the target flow and its relevant dependencies. Discover flow names
without loading every flow body at session start. Keep different flows in
separate lowercase-kebab-case folders with a README that names entry, exit,
purpose, contracts, and evidence.

For a small flow, the README may contain the trace and explicit coverage of
models, integrations, and edge cases. For a multi-step E2E investigation, use
the standard supporting artifacts:

- activity-diagrams.md: Mermaid with source evidence for each implementation step;
- data-flow-map.md: input-to-output transformations;
- entity-schemas.md: relevant models and contracts;
- integration-points.md: external dependencies and configuration names, never secrets;
- quirks-and-gotchas.md: observed exceptions and failure paths.

Use docs-harness/templates/activity-diagram.md when a diagram clarifies the flow. An external
actor without local implementation should be marked external, not assigned an
invented source range.

The authorized onboarding flow may capture a source-backed UNCERTAIN domain
once the relevant evidence is complete, following docs-harness/domain/README.md. Preserve
exploration artifacts here; confirmation of domain policy is a separate User
decision. A directory or an artifact count does not prove the flow is understood.
