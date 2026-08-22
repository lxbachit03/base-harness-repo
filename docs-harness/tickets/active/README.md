# Active Tickets

This folder is the default working area for `$ticket-solving`.

Create each in-progress ticket under its own stable slug:

```text
docs-harness/tickets/active/<ticket-slug>/
├── docs/
│   ├── README.md
│   └── <source-files-supporting-resources-and-AI-artifacts>
├── ticket.md
├── APIs.md
└── SCHEMAs.md
```

Keep a ticket here while intake, investigation, implementation, validation, or
User review remains in progress. Passing acceptance criteria is evidence for
completion; it does not by itself authorize the lifecycle move.

Every active ticket folder must keep `ticket.md`, `APIs.md`, `SCHEMAs.md`, and a
`docs/` folder containing `README.md`. Put ticket-specific source files,
supporting resources, and AI-created artifacts under `docs/`; keep the three
Markdown records at the ticket-folder root. The manifest must give every
artifact one ticket owner, a resolvable link, and source or generator evidence.
Shared batch resources belong under the batch-level `docs/` folder.
When that folder exists, initialize its `README.md` from the ticket docs
manifest template and record ownership and links for every shared artifact.

Move a ticket to `../completed/` only after the User authorizes completion or
explicitly moves the ticket. Preserve the ticket history and update its
metadata to `status: completed` during that move.
