# Active Tickets

This folder is the default working area for `$ticket-solving`.

Create a single in-progress ticket directly under `active/`:

```text
docs-harness/tickets/active/<ticket-number>-<single-ticket>/
├── docs/
│   ├── README.md
│   └── <source-files-supporting-resources-and-AI-artifacts>
├── ticket.md
├── apis.md
└── entities.md
```

For a source containing multiple tickets, use a batch container and one
workspace per child ticket:

```text
docs-harness/tickets/active/<sample-big-ticket>/
├── <ticket-number>-<ticket-1>/
│   ├── docs/README.md
│   ├── ticket.md
│   ├── apis.md
│   └── entities.md
└── <ticket-number>-<ticket-2>/
    ├── docs/README.md
    ├── ticket.md
    ├── apis.md
    └── entities.md
```

Keep a ticket here while intake, investigation, implementation, validation, or
User review remains in progress. Passing acceptance criteria is evidence for
completion; it does not by itself authorize the lifecycle move.

Every active ticket folder must keep `ticket.md`, `apis.md`, `entities.md`, and a
`docs/` folder containing `README.md`. Put ticket-specific source files,
supporting resources, and AI-created artifacts under `docs/`; keep the three
Markdown records at the ticket-folder root. The manifest must give every
artifact one ticket owner, a resolvable link, and source or generator evidence.
Shared batch resources belong under the batch-level `docs/` folder.
When that folder exists, initialize its `README.md` from the ticket docs
manifest template and record ownership and links for every shared artifact.

Use the source-provided number in `<ticket-number>`. Use a stable
lowercase-kebab-case slug for the ticket or batch name; use `TBD` when the
source does not provide a number instead of inventing one.

Placeholder layout folders live under `docs-harness/templates/`; this
`active/` folder contains only real in-progress ticket workspaces.

Move a ticket to `../completed/` only after the User authorizes completion or
explicitly moves the ticket. Preserve the ticket history and update its
metadata to `status: completed` during that move.
