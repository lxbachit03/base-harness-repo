# Onboarding Workspace

This folder owns exploratory evidence for named business/data flows.
docs-harness/domain/README.md owns subsequent domain capture and confirmation.

Read only the target flow and its relevant dependencies. Discover flow names
without loading every flow body at session start. Keep different flows in
separate lowercase-kebab-case folders with a README that names entry, exit,
purpose, contracts, and evidence.

## Ordered E2E walkthrough

For each named flow, create or reuse
`docs-harness/onboarding/<flow-name>/` with this layout:

```text
<flow-name>/
├── README.md
└── flows/
    ├── e2e-<flow-name>.md
    ├── s1-validate-request-activity.md
    ├── s2-save-record-activity.md
    └── ...
```

The workspace README names the flow's entry, exit, purpose, contracts and
evidence, and links to `flows/e2e-<flow-name>.md`. The separate E2E file holds
the plain-language overview, a `## Prerequisite` section, entry and terminal
outcomes, an overall Mermaid activity diagram, and ordered links to all step
files. Show how the steps connect, including material branches and external
actors. Keep links and diagrams aligned with the traced behavior. Express
branch predicates accurately in prose and diagrams: for example, a falsey-value
check is broader than an absence-only check.

In the E2E file's `## Prerequisite` section, use a list or table to explain
what data must be ready before the flow starts, for each relevant scenario:

- Required input fields or values, and any pre-existing entities or records,
  including supported states, relationships, and dependencies between them.
- Why and where each item is needed, and a source path with line range or
  stable symbol/revision. Separate initial data from records or identifiers
  produced later by the flow. A lookup requiring a result does not by itself
  prove a persisted record or storage type; state the evidenced lookup
  condition. Do not infer that pre-existing data is forbidden merely because
  the flow constructs a new object.
- A preparation path when supported by evidence, such as an existing fixture
  or documented API. Mark missing data, values, states, or preparation methods
  `Unverified` and name the next evidence needed. Use `Not applicable` with
  the inspected scope only when neither input data nor pre-existing data is
  required. A flow without pre-existing records may still need input data.

Label sample values as illustrative and do not record secrets or sensitive data.
Preparation instructions are not authority to run seeds, call live APIs,
query databases, or change real data; follow `docs-harness/SESSION.md` before
any such action.

Put every material step in its own `s<N>-<step-name>-activity.md` file in the
same `flows/` folder, with a lowercase-kebab-case step name and unpadded step
number starting at `s1`. Order and link by the numeric step number, so `s10`
comes after `s9`, not between `s1` and `s2`. Include non-API steps and relevant
branches; identify conditional, repeated, and unresolved paths rather than
presenting them as an unconditional sequence.

When reusing a workspace, inspect existing files and links first. Reuse a
compatible `e2e-...` or `s<N>-...` file for the same flow or step, preserving
its evidence and relevant edits. Keep earlier filenames, including `01-...`
step files, and their links; do not silently rename or delete them. Add the
missing E2E and numbered activity files for the requested flow using verified
existing evidence, and link the old artifacts without discarding their content.
Do not overwrite unrelated files or assign an occupied step number to a
different step. If a collision or ambiguous identity prevents a safe mapping,
pause that part, report the conflict, and continue independent work.

Each step file explains the following for a reader with no prior knowledge of
the step:

- **Purpose and position:** what happens, why it matters, the actor, inputs,
  prerequisites, and how this step connects to the previous and next steps.
- **Activity diagram:** a Mermaid activity diagram of the step's actions and
  material branches. Cite each implementation action and branch with a source
  path and line range or stable symbol/revision; mark external actors.
- **Expected API response:** for a relevant API, its method and route, known
  success and error status/body shape, and when each response applies. Label
  any unsupported method, route, or response detail `Unverified`.
- **Expected database record:** the relevant storage target and its type when
  known, read/write action, fields and expected state before/after when
  supported by evidence, including query conditions when they explain the result.
  Label unsupported storage or record details `Unverified`.
- **Evidence and open questions:** sources for the explanation, responses and
  data state; unresolved details and the next investigation needed.

Distinguish behavior observed in code or tests, a documented contract, and an
actual runtime observation. Label illustrative values as examples; never present
them as real observed records. A write-like call or its payload alone does not
prove a write occurred, the storage type, committed record, full schema, or final
database state. Describe the observed call and argument without claiming an
unsupported write. For both the API response and database record, use
`Not applicable` with the inspected scope when the step has no such outcome. Do not
invent missing endpoints, statuses, fields, records, or business policy. Record
no credentials or sensitive data. Inspecting a flow does not authorize calls to
live APIs or databases; follow docs-harness/SESSION.md for the operation boundary.

## Supporting evidence

The overview and step files cover models, integrations, and edge cases for a
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
