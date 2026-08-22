# Completed Tickets

This folder stores ticket history after User-authorized completion.

Each completed ticket preserves the same self-contained workspace it had while
active:

```text
docs-harness/tickets/completed/<ticket-number>-<single-ticket>/
├── docs/
│   └── README.md
├── ticket.md
├── apis.md
└── entities.md
```

The `docs/` folder retains ticket-specific source files, supporting resources,
and artifacts created during resolution. Its `README.md` manifest preserves the
owner, link, purpose, and source or generator for each artifact. Do not delete
or move those artifacts merely because the ticket lifecycle changed.

For a multi-ticket batch, preserve the batch container and its
`<ticket-number>-<child-ticket>/` child folders when moving history here. The
folder naming convention is part of the ticket identity and is not normalized to
a generic slug.

Completed tickets are not part of the default `$ticket-solving` context. Read a
completed ticket only when the User names it, asks for historical context, or
the current ticket has an explicit dependency on it.

The folder location is the lifecycle authority. If a ticket under this folder
still declares `status: active`, normalize the record to
`status: completed`, preserve the decision history, and report the
normalization.
