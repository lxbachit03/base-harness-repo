# Tickets

This folder is the Harness working area for `$ticket-solving`. Its lifecycle is
split between current work and historical work.

## Layout

One ticket is placed under `active/` while it is being worked:

```text
docs-harness/tickets/
├── active/
│   └── <ticket-slug>/
│       ├── <source-file>
│       ├── ticket.md
│       └── <supporting-or-generated-documents>
└── completed/
    └── <ticket-slug>/ticket.md
```

When one source file contains multiple tickets, the source stays once in an
active batch folder and each ticket gets its own child folder:

```text
docs-harness/tickets/active/<batch-slug>/
├── <source-file>
├── <ticket-a-slug>/ticket.md
└── <ticket-b-slug>/ticket.md
```

Files that apply to one ticket and documents generated for that ticket belong
beside its `ticket.md`. Files shared by several tickets belong in the batch
folder. Use the canonical record template at
`docs-harness/templates/ticket.md` when creating a ticket.

## Lifecycle

`active/` is the default intake and execution route. Keep tickets there while
work, validation, or User review remains in progress.

`completed/` contains User-authorized history. The agent skips it by default and
reads it only when the User names a ticket, requests history, or declares a
dependency.

Acceptance criteria prove the outcome but do not authorize completion on their
own. A User-authorized move from `active/` to `completed/` is the lifecycle
transition. A record found in `completed/` with `status: active` is normalized
to `status: completed` while preserving its history.

Ticket folder names use lowercase kebab case. Existing user files are preserved;
ambiguous folder collisions require clarification before work continues.
