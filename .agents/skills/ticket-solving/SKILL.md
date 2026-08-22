---
name: ticket-solving
description: Organize and solve tickets supplied in a prompt, file, or attachment in the repository's docs-harness/tickets workspace.
disable-model-invocation: true
---

# Ticket Solving

Use this skill after the User explicitly invokes `$ticket-solving`. It turns one
ticket source into a stable, reviewable workspace under `docs-harness/tickets/`,
then solves the tickets one at a time when the User asks for resolution.

## Repository context

Load repository context before ticket intake:

1. Read `AGENTS.md`.
2. Read `docs-harness/INDEX.md`.
3. Follow only the routed resources relevant to the ticket's intent.
4. Read `docs-harness/tickets/README.md` and the ticket templates
   `docs-harness/templates/ticket.md`, `APIs.md`, `SCHEMAs.md`, and
   `ticket-docs-README.md` before creating ticket records.
5. Read `docs-harness/tickets/active/README.md` for the default intake and
   execution lifecycle. Read `docs-harness/tickets/completed/README.md` only
   when the User names completed history or the ticket has an explicit
   dependency on it.

`docs-harness/` is the canonical context for the AI agent and Harness repo.
`docs-harness/tickets/` is the Harness ticket workspace. Ticket records are
task artifacts, not canonical Harness resources by default: do not assign them
Harness resource IDs or list them in classification sections. New and
in-progress tickets belong under `docs-harness/tickets/active/`; completed
history belongs under `docs-harness/tickets/completed/` and is outside the
default context route. If the User explicitly requests promotion of a ticket
to a canonical resource, follow the resource template and cross-link rules in
`AGENTS.md`.

If `docs-harness/tickets/README.md` or
`docs-harness/templates/ticket.md` is missing, pause before inventing the
workspace contract. Bootstrap it only with explicit User authority.

Done when the repository instructions, routed context, ticket workspace guide,
and all four ticket templates have been read, or a missing required input is
reported.

## Intake

1. Locate exactly one ticket source supplied in the User prompt, an attachment,
   or an explicitly named repository path. Treat inline ticket text as the
   source when no file is supplied. Pause when multiple candidate sources
   conflict.
2. Read the complete source before creating ticket folders.
3. Identify each ticket from its explicit ID, heading, or clearly separated
   block. Preserve the original wording and do not invent requirements,
   acceptance criteria, or ticket IDs.
4. Record the ticket count, identity, title, source location, and shared versus
   ticket-specific attachments before layout work begins.
5. Use `TBD` for absent information and pause when the ticket boundary or
   identity cannot be established from the source.
6. For one ticket, choose the direct `<ticket-number>-<single-ticket>/` layout.
   For multiple tickets from one source, choose a `<sample-big-ticket>/`
   container and create one `<ticket-number>-<ticket-name>/` child per ticket.
   Do not put a ticket record directly at the batch-container root.

For an inline source, record `User prompt` as the source and preserve the exact
ticket text in `ticket.md`; do not manufacture a source file.

Done when every ticket has an identifiable source, title, boundary, and
attachment ownership, with missing authority or information marked explicitly.

## Workspace layout

Create or reuse the `docs-harness/tickets/active/` workspace described by its
README. Use the source-provided ticket number as the folder prefix and a stable
lowercase-kebab-case slug for the title. If the source has no ticket number, use
`TBD` explicitly and record the missing identity; never invent or reuse a
business number.

For one ticket, use a direct ticket folder:

```text
docs-harness/tickets/active/<ticket-number>-<single-ticket>/
├── docs/                  # manifest, source, support files, and AI artifacts
│   ├── README.md          # owner/link/provenance manifest
│   └── <ticket-artifacts>
├── ticket.md              # canonical ticket record
├── APIs.md                # relevant API inventory
└── SCHEMAs.md             # relevant schema and enum inventory
```

For multiple tickets from one source, use a batch container with one child
folder per ticket:

```text
docs-harness/tickets/active/<sample-big-ticket>/
├── <ticket-number>-<ticket-1>/
│   ├── docs/
│   │   ├── README.md
│   │   └── <ticket-artifacts>
│   ├── ticket.md
│   ├── APIs.md
│   └── SCHEMAs.md
└── <ticket-number>-<ticket-2>/
    ├── docs/
    │   ├── README.md
    │   └── <ticket-artifacts>
    ├── ticket.md
    ├── APIs.md
    └── SCHEMAs.md
```

The batch folder is a container, not a ticket record. Create an optional
`<sample-big-ticket>/docs/README.md` only when the source or an artifact is
shared by multiple child tickets; do not create a batch `docs/` folder for
ticket-specific resources.

Place a ticket-specific source file, PDF, JavaScript, HTML, log, screenshot, or
other resource under that ticket's `docs/`. Put a shared source or artifact in
the optional batch-level `docs/`. Put every artifact created by the AI agent
while working the ticket under the owning `docs/` folder. Start each `docs/`
folder from `docs-harness/templates/ticket-docs-README.md` as `README.md`; list
every other file or folder there exactly once with its ticket owner, resolvable
link, purpose, source or generator, and status. Keep the three Markdown records
at each ticket-folder root and do not create `input/` or `output/` subfolders
unless the User requests them.

Start records from `docs-harness/templates/ticket.md`. Reuse an existing active
ticket folder only when its identity matches the intake result. Preserve
existing files and pause on an ambiguous collision; never overwrite a user's
source or artifact.

Done when one parsed ticket is a direct `<ticket-number>-<single-ticket>/`
folder, or multiple parsed tickets are child folders under one batch container;
every active ticket folder has exactly one `ticket.md`, one `APIs.md`, one
`SCHEMAs.md`, and one `docs/README.md` manifest, and every source or artifact
has one clear owner and a resolvable link.

## Lifecycle

Keep new, in-progress, blocked, and User-review tickets under
`docs-harness/tickets/active/`. Passing acceptance criteria proves the ticket's
outcome but does not by itself authorize the lifecycle transition.

Treat a ticket as completed only when the User authorizes completion or
explicitly moves its folder from `active/` to `completed/`. Preserve the
decision log and update its metadata to `status: completed` during the move.

Skip `docs-harness/tickets/completed/` during default intake and execution. Read
it when the User names a completed ticket, requests historical context, or the
current ticket has an explicit dependency on it.

When a ticket is found under `completed/` with `status: active`, treat the
folder location as the lifecycle authority: normalize its metadata to
`status: completed`, preserve the history, and report the normalization. Do not
move it back to `active/` merely because the metadata is stale.

Done when each ticket's folder and metadata express the same lifecycle, or a
missing User authority for the transition is recorded.

## Ticket record

Start each record from `docs-harness/templates/ticket.md`. Keep source text
separate from the agent's interpretation. A record contains, as applicable:

- ticket ID and title from the source;
- ticket owner and canonical ticket link;
- source location and original ticket text;
- summary, context, evidence, and expected outcome;
- the ticket-local `APIs.md` inventory and data-preparation decision;
- the ticket-local `SCHEMAs.md` entity, field, relationship, and enum inventory;
- the ticket-local `docs/README.md` artifact manifest;
- explicit acceptance criteria;
- in-scope and out-of-scope boundaries;
- plan, implementation or resolution notes, and decisions;
- validation commands and results;
- risks, proposals or mitigations, open questions, and artifact links.

Keep API and schema facts source-backed. `APIs.md` must identify relevant
endpoints and whether seed data is a better preparation path. `SCHEMAs.md` must
explain relevant entity fields, relationships, and every relevant enum value.
Both files must contain a real `Last reviewed` date, `Evidence sources`, and an
evidence summary. If no relevant API or schema is found, record the checked
scope and `None found`; never omit the review record. Use `TBD`, `Not found`, or
`Unverified` instead of guessing.

Use the source's ticket ID when one exists. A slug is a filesystem key, not a
replacement business ID. Use `TBD` for an absent field rather than guessing.
Keep `status: resolved` distinct from lifecycle completion: a resolved record
stays under `active/` until the User authorizes or performs the move.
Keep ticket-specific source and AI-created documents under `docs/`. Add each
file or folder to `docs/README.md` with its owner, resolvable link, purpose,
source or generator, and status. Keep the three ticket records at the folder
root; use the manifest to link larger analysis, plan, resolution, or validation
artifacts.

When a risk appears in the response or ticket record, include at least one
explicit proposal or mitigation for it. Treat that proposal as a suggestion
until the User gives authority to apply it. Persist a canonical resource under
`docs-harness/risks/` or `docs-harness/proposals/` only when explicitly
authorized, and then follow `AGENTS.md` for reciprocal `REFERENCES:` links.

Done when a reviewer can trace every proposed action to the source, an
acceptance criterion, evidence, or an explicitly marked open question.

## Solve

1. Read the active ticket's `ticket.md`, `APIs.md`, `SCHEMAs.md`, its
   `docs/README.md`, and the relevant readable resources in its `docs/` folder
   before proposing or implementing a solution. Read a completed ticket only
   through the explicit history/dependency branch described above.
2. Work on one ticket at a time and keep its status current. Use
   `intake`, `ready`, `in-progress`, `blocked`, or `resolved`, unless the User
   supplies another vocabulary.
3. Implement only work authorized by the User and repository instructions.
   Record changed paths, decisions, validation results, and remaining risks in
   the ticket record or a linked document after each meaningful action.
4. Keep AI-created documents in the owning ticket's `docs/` folder and update
   its manifest immediately so the owner, link, purpose, generator, and status
   remain visible.
5. For a batch, mark a blocked ticket with the missing authority or evidence;
   continue another ticket only when its scope is independent and the User
   requested multi-ticket solving.

Stop after workspace preparation when the User requested intake or
organization only. Resolve a ticket only when its acceptance criteria are
proven; otherwise record the blocker and keep the status `blocked`. Keep a
resolved ticket in `active/` until the User authorizes the completed move.

Done when every requested ticket is either resolved with evidence or blocked
with the missing authority, dependency, recovery step, or validation evidence
recorded, and any completed lifecycle transition has User authority or an
explicit active-to-completed move.

## Validation and handoff

During the work:

- compare the parsed ticket count with the created active ticket folders;
- confirm one ticket uses the direct `<ticket-number>-<single-ticket>/` layout;
- confirm multiple tickets use one `<sample-big-ticket>/` container with one
  `<ticket-number>-<ticket-name>/` child per ticket and no root ticket record;
- confirm each active ticket folder contains exactly one `ticket.md`, one
  `APIs.md`, one `SCHEMAs.md`, and one `docs/` folder with `README.md`;
- confirm every ticket-specific source and AI-created artifact is under `docs/`
  and appears exactly once in the manifest with one owner and a resolvable link;
- confirm `APIs.md` and `SCHEMAs.md` contain a real review date, evidence
  sources, and an evidence summary, plus explicit unknown markers where needed;
- confirm completed folders are excluded from default intake and read only
  through the explicit history/dependency branch;
- normalize any `status: active` record found under `completed/` to
  `status: completed` and record the normalization;
- resolve source, attachment, and generated-document links;
- verify that no existing user file was replaced and that ownership is
  unambiguous;
- keep status, acceptance criteria, and artifact links current.

Before claiming completion:

1. Inspect the final tree under `docs-harness/tickets/active/` and
   `docs-harness/tickets/completed/`; confirm single tickets are direct
   `<ticket-number>-<single-ticket>/` folders and batch tickets are children of
   one `<sample-big-ticket>/` container, with every ticket folder carrying the
   required three Markdown records and a `docs/README.md` manifest.
2. Check every acceptance criterion as satisfied, unsatisfied, or explicitly
   blocked, and separate that proof from User authority to complete.
3. Confirm every ticket in `completed/` has `status: completed`.
4. Confirm every artifact has one ticket owner, a resolvable link, source or
   generator evidence, and a current status in the manifest; confirm both
   inventories carry their review date and evidence.
5. Run relevant focused repository checks and record their exact results. If a
   requested tool is unavailable, report it separately from a test failure.
6. Run `git diff --check` and verify that changes stay within the authorized
   scope.
7. Report the outcome, changed files, validation evidence, and unresolved
   questions separately.

Update `docs-harness/INDEX.md` when the ticket workspace, lifecycle folders,
template, or a canonical ticket route changes. Keep the stable active and
completed folder routes there without duplicating ordinary ticket records in a
classification section. If the User asks to promote a ticket record into
canonical Harness context, pause and apply the resource ID, template, priority,
and reciprocal-link rules before making that change.

Do not claim resolution from folder creation alone. A prepared workspace is
the completion state for intake-only work; evidence-backed acceptance is the
completion state for solving work.

## Pause rules

Pause for User input when any of these conditions holds:

- the source is missing, unreadable, conflicting, or has unclear ticket
  boundaries;
- ticket identity, authority, acceptance criteria, or scope is materially
  ambiguous;
- the required ticket README or template is missing;
- the User's authority to move a ticket from `active/` to `completed/` is
  unclear;
- an existing folder or filename collision cannot be resolved safely;
- a dependency, destructive move/deletion, external communication, credential,
  or recovery path is outside the authorized scope;
- validation cannot establish whether the acceptance criteria are satisfied.

Preserve the existing workspace while paused and report the exact decision or
input needed to continue.
