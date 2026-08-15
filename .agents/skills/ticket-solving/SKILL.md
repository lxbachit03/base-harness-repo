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
4. Read `docs-harness/tickets/README.md` and
   `docs-harness/templates/ticket.md` before creating ticket records.
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
and record template have been read, or a missing required input is reported.

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

For an inline source, record `User prompt` as the source and preserve the exact
ticket text in `ticket.md`; do not manufacture a source file.

Done when every ticket has an identifiable source, title, boundary, and
attachment ownership, with missing authority or information marked explicitly.

## Workspace layout

Create or reuse the `docs-harness/tickets/active/` workspace described by its
README. Use a stable lowercase-kebab-case slug, preferring a source-provided
ticket ID as a slug prefix when it can be represented safely.

For one ticket:

```text
docs-harness/tickets/active/<ticket-slug>/
├── <source-file>          # only when the source is a file
└── ticket.md
```

For multiple tickets from one source:

```text
docs-harness/tickets/active/<batch-slug>/
├── <source-file>          # shared source, when the source is a file
├── <ticket-a-slug>/ticket.md
└── <ticket-b-slug>/ticket.md
```

Place a ticket-specific PDF or other artifact beside that ticket's
`ticket.md`. Place an artifact shared by several tickets at the batch root.
Keep generated documents beside the record and avoid `input/` or `output/`
subfolders unless the User requests them.

Start records from `docs-harness/templates/ticket.md`. Reuse an existing active
ticket folder only when its identity matches the intake result. Preserve
existing files and pause on an ambiguous collision; never overwrite a user's
source or artifact.

Done when the folder shape matches the parsed ticket count, every active ticket
folder has one canonical `ticket.md`, and each source or artifact has one clear
owner.

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
- source location and original ticket text;
- summary, context, evidence, and expected outcome;
- explicit acceptance criteria;
- in-scope and out-of-scope boundaries;
- plan, implementation or resolution notes, and decisions;
- validation commands and results;
- risks, proposals or mitigations, open questions, and artifact links.

Use the source's ticket ID when one exists. A slug is a filesystem key, not a
replacement business ID. Use `TBD` for an absent field rather than guessing.
Keep `status: resolved` distinct from lifecycle completion: a resolved record
stays under `active/` until the User authorizes or performs the move.
Add a separate Markdown document beside `ticket.md` only when the analysis,
plan, resolution, or validation is large enough to review independently, and
link it from the record.

When a risk appears in the response or ticket record, include at least one
explicit proposal or mitigation for it. Treat that proposal as a suggestion
until the User gives authority to apply it. Persist a canonical resource under
`docs-harness/risks/` or `docs-harness/proposals/` only when explicitly
authorized, and then follow `AGENTS.md` for reciprocal `REFERENCES:` links.

Done when a reviewer can trace every proposed action to the source, an
acceptance criterion, evidence, or an explicitly marked open question.

## Solve

1. Read the active ticket's `ticket.md` and all files in its folder before
   proposing or implementing a solution. Read a completed ticket only through
   the explicit history/dependency branch described above.
2. Work on one ticket at a time and keep its status current. Use
   `intake`, `ready`, `in-progress`, `blocked`, or `resolved`, unless the User
   supplies another vocabulary.
3. Implement only work authorized by the User and repository instructions.
   Record changed paths, decisions, validation results, and remaining risks in
   the ticket record or a linked document after each meaningful action.
4. Keep AI-created documents in the owning ticket folder so the folder remains
   the ticket's complete working set.
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
- confirm each active ticket folder contains exactly one canonical `ticket.md`;
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
   `docs-harness/tickets/completed/`; confirm the single-ticket or batch layout.
2. Check every acceptance criterion as satisfied, unsatisfied, or explicitly
   blocked, and separate that proof from User authority to complete.
3. Confirm every ticket in `completed/` has `status: completed`.
4. Run relevant focused repository checks and record their exact results. If a
   requested tool is unavailable, report it separately from a test failure.
5. Run `git diff --check` and verify that changes stay within the authorized
   scope.
6. Report the outcome, changed files, validation evidence, and unresolved
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
