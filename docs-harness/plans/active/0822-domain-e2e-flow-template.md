# Harness Improvement Resource

ID: #011_IMPROVE_HARNESS_0822
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Standardize service E2E domain-flow template
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/domain/README.md
- docs-harness/templates/README.md
- docs-harness/templates/domain.md
- docs-harness/templates/domain-entity.md
- docs-harness/templates/activity-diagram.md
- docs-harness/templates/<service-name>/README.md
- docs-harness/templates/<service-name>/data-flows/<data-flow-name>/apis.md
- docs-harness/templates/<service-name>/data-flows/<data-flow-name>/entities.md
- docs-harness/templates/<service-name>/data-flows/<data-flow-name>/prerequisite.md
- docs-harness/templates/<service-name>/data-flows/<data-flow-name>/data-flow.md
- .agents/skills/goal-griller/SKILL.md
- .agents/skills/improve-harness/SKILL.md

## Objective

Move the user-created `<service-name>` scaffold out of canonical domain
knowledge and turn it into a reusable Harness template for service-level E2E
data flows. Each flow must have API, entity, prerequisite, and Mermaid data-flow
artifacts, with the first diagram showing the complete E2E path and subsequent
diagrams showing one API at a time. Add a reusable `domain-entity.md` contract
for schema files, including source-backed field code-usage and query tracing
that is blocked until explicit User authority is present.

## Current State

Baseline:

- Repository revision: `dde673d9c0d9611d752fdabd790c641f943ff305`
- Branch: `main`
- Initial worktree: `?? docs-harness/domain/<service-name>/`
- The scaffold contains `data-flows/<data-flow-name>/` with four empty files and
  `schemas/<schema-name>.md`.

Observed friction: a reusable template scaffold is placed under `domain/`, so
the domain route can be mistaken for real domain knowledge. The four flow files
have no contract describing API inventory, entity scope, prerequisite order, or
the required overall-versus-per-API Mermaid diagram sequence. The schema
placeholder is empty and has no contract for schema meaning, field lifecycle,
enum semantics, or codebase usage. The authority boundary for detailed field
tracing is also not represented in the template surface.

API-detail extension baseline:

- Repository revision: `5ad6dc70f7de8f6881f923513445052c99793d76`
- Branch: `main`
- Worktree before this extension: clean.
- Observed friction: the per-API template had request/response and side-effect
  fields but no explicit sections for input provenance, execution context,
  output semantics, domain logic, or database entity/component impact.

## Proposed Improvement

If the scaffold is owned by `templates/<service-name>/`, explicitly labels
itself as template-only, requires current User authority before promotion, and
uses `domain-entity.md` for schema resources with a separate field-analysis
gate, a fresh agent will discover the template without loading it as domain
truth and will produce consistent E2E flow evidence and schema traces because
the filesystem owner, authority gates, and artifact contracts are explicit. If
each API section also requires input, context, output, domain logic, entity
impact, query impact, and downstream-component evidence, a fresh agent will
produce API explanations that are useful for tracing behavior into persistence
and adjacent components instead of stopping at endpoint metadata.

## Scope

In scope:

- Move `docs-harness/domain/<service-name>/` to
  `docs-harness/templates/<service-name>/`.
- Add the service and data-flow template README/content for `apis.md`,
  `entities.md`, `prerequisite.md`, and `data-flow.md`.
- Add `docs-harness/templates/domain-entity.md` for detailed schema/entity
  documentation, including authority-gated field code-usage and query traces.
- Expand the per-API contract in
  `docs-harness/templates/<service-name>/data-flows/<data-flow-name>/apis.md`
  with input, context, output, domain logic, entity/database impact, query
  impact, downstream components, and evidence placeholders.
- Update `docs-harness/domain/README.md`, `docs-harness/templates/README.md`,
  `docs-harness/INDEX.md`, and this active improvement record.
- Preserve the existing `schemas/` folder and empty placeholder unchanged; the
  new contract describes how a future User-authorized real schema file must be
  authored.

Out of scope:

- Reading or modifying `.agents/skills/onboarding/SKILL.md` or
  `docs-harness/onboarding/`.
- Creating or populating a real domain schema resource, assigning domain IDs,
  or indexing a real schema.
- Editing `schemas/<schema-name>.md`; it remains an empty layout placeholder.
- Creating real domain knowledge, assigning domain IDs, or indexing a real
  service.
- Product code, API execution, database/seed operations, build, or test commands.

## Validation

During work:

- Verify the source folder is absent from `domain/` and the target exists under
  `templates/` without collision.
- Verify each data-flow template file has the required headings and placeholders.
- Verify the service, domain-resource, and data-flow templates state that they
  are not domain truth and require explicit current User authority before
  promotion.
- Verify `domain-entity.md` contains schema, field, enum, relationship,
  constraint, index, lifecycle, assignment, read, and query-trace sections.
- Verify detailed field/code usage is explicitly gated by User authority and
  that no real schema resource is created.
- Verify each per-API section in `apis.md` has Input, Context, Output, Domain
  Logic and Entity Impact, Downstream Components, and evidence fields.
- Verify the entity-impact table captures read/create/update/delete actions,
  affected fields, query/filter/join behavior, persistence impact, and evidence.
- Verify `data-flow.md` puts the overall E2E Mermaid diagram first and one API
  diagram in each subsequent API section.
- Verify `schemas/` content is byte-for-byte preserved across the move.
- Run INDEX synchronization, `git diff --check`, link/path, ID, and whitespace
  checks. Do not run build/test/seed commands.

Final proof:

- A fresh domain-template intake resolves `<service-name>` from `templates/`
  and does not treat it as active domain knowledge.
- A fresh data-flow authoring task creates all four flow files and follows the
  overall-first, one-API-per-following-diagram contract.
- A fresh schema-template intake uses `domain-entity.md`, requires schema
  authority before creating a real file, and leaves detailed field/code usage
  gated when that authority is absent.
- Record the fresh rerun comparison and choose `keep`, `revise`, or `remove`
  before moving this plan to `plans/completed/`.

## Native Validation Result

- Source/target tree boundary: pass; `<service-name>` is absent from `domain/`
  and present under `templates/`.
- Required template files and diagram order: pass.
- `domain-entity.md`: present with schema, field, enum, relationship,
  constraint, index, lifecycle, assignment, read, and query-trace sections.
- Schema and field-analysis authority gates: present in the domain template,
  service template, domain README, templates README, and active plan.
- `schemas/<schema-name>.md`: preserved as the empty placeholder; no real
  schema resource was created.
- Template/domain promotion gate: present in the service template, domain
  resource template, domain README, templates README, and all four data-flow
  templates; no real domain workspace was created.
- `bash .agents/validators/sync-harness-index.sh --check`: pass.
- `git diff --check`: pass.
- Required section, authority-language, template-link, schema-boundary, and
  scoped whitespace assertions: pass.
- Per-API input/context/output, domain-logic, entity-impact, query-impact, and
  downstream-component contract: added; structural assertions pass.
- No onboarding paths appear in the changed-file set; no real domain schema was
  created.
- Onboarding files, product code, build, test, seed, and Mermaid renderer:
  unchanged or not authorized and not run.
- Fresh equivalent authoring rerun: not performed; decision remains
  `pending fresh rerun`.

## Risks

The template could be mistaken for confirmed domain knowledge if it is copied
without evidence or User authority. Proposal: keep it under `templates/`, label
all placeholder files as template-only, and require a separate User-authorized
promotion before creating a real domain service resource.

The `schemas/` placeholder is intentionally empty. Proposal: preserve it as a
layout placeholder, use `domain-entity.md` for future schema resources, and
require explicit User authority before detailed field/code tracing instead of
inventing fields, IDs, or routing rules.

Detailed field tracing could expose unsupported domain meaning or sensitive
usage if performed without the named authority. Proposal: keep the separate
field-analysis gate and leave each unauthorized section as `Pending User
authority` or `Unverified`.

The expanded API contract may become too heavy for a simple endpoint. Proposal:
keep the sections mandatory but allow `None verified` or `Unverified` with
evidence instead of forcing speculative detail; revisit the weight after the
fresh equivalent authoring rerun.

## Current Decision

Decision: pending fresh rerun.

The bounded template intervention is implemented after User confirmation, but
the Harness improvement must not be claimed complete until an equivalent fresh
authoring rerun exercises the new template.
