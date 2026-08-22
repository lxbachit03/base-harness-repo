# Harness Improvement Resource

ID: #010_IMPROVE_HARNESS_0822
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Standardize ticket evidence workspace and API/schema templates
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/tickets/README.md
- docs-harness/tickets/active/README.md
- docs-harness/tickets/completed/README.md
- docs-harness/templates/README.md
- docs-harness/templates/ticket.md
- docs-harness/templates/apis.md
- docs-harness/templates/entities.md
- docs-harness/templates/ticket-docs-README.md
- .agents/skills/ticket-solving/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md

## Objective

Give every ticket a stable, self-contained workspace with `ticket.md`,
`apis.md`, `entities.md`, and a `docs/` folder for ticket resources and
AI-created artifacts. Give every artifact a ticket owner, resolvable link, and
source or generator evidence, and require review date/evidence in both
inventory files. Use a direct `<ticket-number>-<single-ticket>/` folder for one
ticket and a `<sample-big-ticket>/` container with numbered child folders for a
multi-ticket source.

## Current State

Baseline:

- Repository root: `/Users/bale/Documents/Repositories/test-repo/test_custom_harness`
- Revision: `48757731b9e7295dd91ae4cd3d3ecb20ecd75ab8`
- Branch: `main`
- Initial worktree: clean.

The existing ticket contract required one `ticket.md` but placed source files,
supporting resources, and generated documents beside the record. It did not
provide standard API or database-schema inventories for User review, nor did it
require an artifact manifest, explicit owner/link, or review evidence. No real
ticket records require migration in the current workspace. The User-created
direct and batch folder examples now live under `docs-harness/templates/`, not
the active ticket route, and are persisted with README placeholders.

Naming-extension baseline:

- Repository revision: `0b5bd8510a9dc07f7dfe87b25f55a339a64a0e0e`
- Branch: `main`
- Worktree before this extension: clean.
- Observed friction: the ticket contract used uppercase acronym filenames
  `APIs.md` and `SCHEMAs.md`, while the service-flow contract already uses the
  lowercase `apis.md` and `entities.md` convention. The mismatch makes a fresh
  agent choose different names across adjacent ticket and domain workspaces and
  makes case-only paths harder to verify on case-insensitive filesystems.

## Proposed Improvement

If the ticket template, ticket-solving skill, and workspace README require one
`docs/` folder plus `ticket.md`, `apis.md`, and `entities.md`, and every current
pointer uses those lowercase names, then a fresh agent will keep ticket
evidence and generated artifacts co-located, expose verified API/seed-data
options, and document schema/field/enum meaning consistently, because the
folder contract, owner/link manifest, review record, and naming convention are
explicit and the direct-versus-batch naming rule is unambiguous.

Evidence that would weaken this:

- A fresh ticket intake omits one of the required files or the `docs/` folder.
- A single ticket is nested under a batch container, or a multi-ticket source
  creates ticket records at the batch root instead of numbered child folders.
- A ticket folder does not use `<ticket-number>-<lowercase-kebab-case-slug>`.
- Source or AI-created artifacts are placed outside the owning `docs/` folder.
- An artifact has no single ticket owner, resolvable link, purpose, source, or
  generator in the `docs/README.md` manifest.
- `apis.md` or `entities.md` invents facts instead of recording evidence or an
  explicit unknown marker.
- Either inventory lacks a real review date, evidence sources, or an evidence
  summary.
- A current Harness document or `$ticket-solving` instruction still points to
  `APIs.md` or `SCHEMAs.md`, or a fresh intake recreates either uppercase name.
- The fixed files add enough ceremony that ticket work becomes slower without
  improving User visibility or recovery.

Maintenance owner and removal condition:

- Owner: repository Harness maintainers and `$ticket-solving` maintainers.
- Revise the contract if fresh ticket reruns show redundant records, stale API
  or schema inventories, unclear ownership, or excessive context load.

## Scope

In scope:

- `docs-harness/templates/ticket.md`, `apis.md`, `entities.md`, and
  `ticket-docs-README.md`.
- The case-only rename of the canonical inventory templates from `APIs.md` to
  `apis.md` and from `SCHEMAs.md` to `entities.md`, plus all current references.
- `docs-harness/templates/<ticket-number>-<single-ticket>/` and
  `docs-harness/templates/<sample-big-ticket>/` layout examples.
- `docs-harness/tickets/README.md`, `tickets/active/README.md`, and
  `tickets/completed/README.md`.
- `.agents/skills/ticket-solving/SKILL.md` and relevant template/routing docs.
- This active improvement record and its INDEX/plan routing entries.

Out of scope:

- Creating a real ticket or migrating existing ticket data.
- Product code, API implementation, database migrations, seed execution, or
  build/test commands.
- Automatically discovering or claiming every API/schema in the repository;
  inventories remain ticket-relevant and evidence-backed.
- Moving this record to `plans/completed/` before a fresh rerun and decision.

## Validation

During work:

- Verify all four ticket templates have the required headings and unknown
  markers.
- Verify the ticket docs manifest requires owner, link, purpose, provenance, and
  status for every artifact.
- Verify the ticket workspace and skill diagrams agree on the folder shape.
- Verify direct and batch examples use the User-provided folder names and
  preserve the source ticket number prefix.
- Verify the placeholder layout folders are under `templates/` and absent from
  the active ticket route.
- Verify `apis.md` and `entities.md` require a non-placeholder review date and
  evidence record, including the `None found` empty-inventory path.
- Verify the canonical template files are exactly `apis.md` and `entities.md`
  and no current operational Harness/skill reference contains the former
  uppercase names. This active plan may mention them only as baseline evidence.
- Verify template links, INDEX routing, unique resource IDs, whitespace, and
  `git diff --check`.

Final proof:

- Run fresh equivalent single-ticket and multi-ticket intake prompts and
  confirm the agent creates the direct and batch-child layouts with
  `docs/README.md`, `docs/`, `ticket.md`, `apis.md`, and `entities.md`.
- Confirm a supplied source file and an AI-created artifact are placed under
  the ticket's `docs/` folder and both appear in the manifest with owner/link
  and source or generator evidence.
- Confirm API/seed-data and schema/field/enum facts are recorded with a review
  date, evidence, or explicit unknown markers.
- Record the comparison and choose `keep`, `revise`, or `remove` before moving
  this record to `plans/completed/`.

## Native Validation Result

- `git diff --check`: pass.
- `bash .agents/validators/sync-harness-index.sh --check`: pass.
- Required template paths and headings exist; real resource IDs are unique and
  no trailing whitespace was found in the changed files.
- Proposal implementation: `docs/README.md` is the required artifact
  owner/link/provenance manifest, and `apis.md`/`entities.md` require review date
  and evidence fields.
- User-provided direct/batch naming contract is represented in the ticket
  template, workspace guides, and `$ticket-solving` layout rules.
- Canonical filename normalization: `apis.md` and `entities.md` exist, the
  uppercase names are absent from current operational Harness/skill
  references, and the ticket template, layout examples, workspace guides,
  INDEX, and `$ticket-solving` skill agree. The old names remain only in this
  plan's baseline and negative-evidence record.
- Folder move: the single-ticket and batch layout examples are under
  `docs-harness/templates/` with README placeholders; the active route contains
  only its lifecycle guide.
- Targeted static contract check: pass for required paths, headings, owner/link
  markers, review fields, and changed-file whitespace.
- Build, test, lint, format, generation, installation, migration, and seed
  commands: not authorized and not run.
- Fresh equivalent rerun: not performed in this session; decision remains
  `pending fresh rerun`.

## Risks

`docs/` could become an unstructured dump of stale or unrelated artifacts.
Implemented proposal: require each artifact to have one ticket owner, a
resolvable link, purpose, source or generator, and status in `docs/README.md`;
keep shared resources at batch-level `docs/`.

API and schema inventories can become stale as code changes. Implemented
proposal: record a last-reviewed date and evidence path, mark uncertain facts
explicitly, and refresh the files when the ticket resumes after relevant code
changes. The templates and skill now make that proposal part of the contract.

Case-only renames can be hidden by case-insensitive filesystems. Implemented
proposal: perform the rename through a distinct temporary path and verify both
the filesystem names and the Git-visible path before claiming the convention is
updated.

## Current Decision

Decision: pending fresh rerun.

The workspace contract and templates are implemented, but the Harness must not
be claimed improved or moved to `plans/completed/` until a fresh ticket-intake
session exercises the required layout and evidence rules.
