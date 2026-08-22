# Batch Ticket Folder Template

This folder is a container example for one source that contains multiple
tickets. It is not a ticket record and must not be solved as work.

Expected shape:

```text
<sample-big-ticket>/
├── <ticket-number>-<ticket-1>/
└── <ticket-number>-<ticket-2>/
```

Each child is an independent ticket workspace. Add `<sample-big-ticket>/docs/`
only when the source or an artifact is shared by multiple child tickets.
