# Onboarding Workspace

This folder owns exploratory evidence for named business/data flows.
docs-harness/domain/README.md owns subsequent domain capture and confirmation.

Read only the target flow and its relevant dependencies. Discover flow names
without loading every flow body at session start. Keep different flows in
separate lowercase-kebab-case folders with a README that names entry, exit,
purpose, contracts, and evidence.

## Ordered E2E walkthrough

For each named flow, create or reuse
`docs-harness/onboarding/<flow-name>/flows/` and put each material step in its
own Markdown file, named in execution order such as `01-validate-request.md`
and `02-save-record.md`. Include non-API steps and relevant branches; identify
conditional, repeated, and unresolved paths rather than presenting them as an
unconditional sequence.

The flow README provides a plain-language E2E overview, entry and terminal
outcomes, an overall Mermaid activity diagram, and ordered links to all step
files. Show how the steps connect, including material branches and external
actors. Keep the links and diagrams aligned with the traced behavior.

Each step file explains the following for a reader with no prior knowledge of
the step:

- **Purpose and position:** what happens, why it matters, the actor, inputs,
  prerequisites, and how this step connects to the previous and next steps.
- **Activity diagram:** a Mermaid activity diagram of the step's actions and
  material branches. Cite each implementation action and branch with a source
  path and line range or stable symbol/revision; mark external actors.
- **Expected API response:** for a relevant API, its method and route, known
  success and error status/body shape, and when each response applies.
- **Expected database record:** the relevant storage target and its type when
  known, read/write action, fields and expected state before/after when
  supported by evidence, including query conditions when they explain the result.
- **Evidence and open questions:** sources for the explanation, responses and
  data state; unresolved details and the next investigation needed.

Distinguish behavior observed in code or tests, a documented contract, and an
actual runtime observation. Label illustrative values as examples; never present
them as real observed records. A write call or its payload alone does not prove
the storage type, committed record, full schema, or final database state; mark
unsupported details `Unverified`. For both the API response and database record,
use `Not applicable` with the inspected scope when the step has no such outcome;
use `Unverified` when the outcome or its values cannot be established. Do not
invent missing endpoints, statuses, fields, records, or business policy. Record
no credentials or sensitive data. Inspecting a flow does not authorize calls to
live APIs or databases; follow AGENTS.md for the operation boundary.

## Supporting evidence

The README and step files cover models, integrations, and edge cases for a
small flow. When a multi-step E2E investigation benefits from more detail, add
the standard supporting artifacts:

- activity-diagrams.md: Mermaid with source evidence for each implementation step;
- data-flow-map.md: input-to-output transformations;
- entity-schemas.md: relevant models and contracts;
- integration-points.md: external dependencies and configuration names, never secrets;
- quirks-and-gotchas.md: observed exceptions and failure paths.

Use docs-harness/templates/activity-diagram.md for the overview and step
diagrams. An external actor without local implementation should be marked
external, not assigned an invented source range.

The authorized onboarding flow may capture a source-backed UNCERTAIN domain
once the relevant evidence is complete, following docs-harness/domain/README.md.
Keep explicitly synthetic examples identified as examples, not real project
domain facts. Preserve exploration artifacts here; confirmation of domain policy
is a separate User decision. A directory or an artifact count does not prove
the flow is understood.
