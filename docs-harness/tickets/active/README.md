# Active Tickets

This folder is the default working area for `$ticket-solving`.

Create each in-progress ticket under its own stable slug:

```text
docs-harness/tickets/active/<ticket-slug>/
├── <source-file>
├── ticket.md
└── <supporting-or-generated-documents>
```

Keep a ticket here while intake, investigation, implementation, validation, or
User review remains in progress. Passing acceptance criteria is evidence for
completion; it does not by itself authorize the lifecycle move.

Move a ticket to `../completed/` only after the User authorizes completion or
explicitly moves the ticket. Preserve the ticket history and update its
metadata to `status: completed` during that move.
