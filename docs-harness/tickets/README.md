# Tickets

This folder is the Harness working area for `$ticket-solving`. Its lifecycle is
split between current work and historical work.

## Layout

One ticket is placed directly under `active/` while it is being worked:

```text
docs-harness/tickets/active/
└── <ticket-number>-<single-ticket>/
    ├── docs/
    │   ├── README.md
    │   └── <source-files-supporting-resources-and-AI-artifacts>
    ├── ticket.md
    ├── apis.md
    └── entities.md
```

When one source contains multiple tickets, create one batch container and put
each ticket in its own child folder:

```text
docs-harness/tickets/active/
└── <sample-big-ticket>/
    ├── <ticket-number>-<ticket-1>/
    │   ├── docs/
    │   │   ├── README.md
    │   │   └── <ticket-1-specific-resources-and-artifacts>
    │   ├── ticket.md
    │   ├── apis.md
    │   └── entities.md
    ├── <ticket-number>-<ticket-2>/
    │   ├── docs/
    │   │   ├── README.md
    │   │   └── <ticket-2-specific-resources-and-artifacts>
    │   ├── ticket.md
    │   ├── apis.md
    │   └── entities.md
    └── <ticket-number>-<ticket-n>/
        ├── docs/
        │   ├── README.md
        │   └── <ticket-n-specific-resources-and-artifacts>
        ├── ticket.md
        ├── apis.md
        └── entities.md
```

The batch folder is only a container, not a ticket record. If the source or an
artifact is shared by several child tickets, add an optional
`<sample-big-ticket>/docs/README.md` manifest and place the shared resources
there. The default batch shape does not require that folder.

`<ticket-number>` comes from the source. `<single-ticket>`, `<ticket-1>`, and
`<sample-big-ticket>` are stable lowercase-kebab-case slugs. Use `TBD` when a
source has no ticket number and record the missing identity; never invent or
reuse a business number.

Files that apply to one ticket belong in its `docs/` folder. This includes
source files, PDFs, JavaScript, HTML, logs, screenshots, and artifacts created
by the AI agent while working the ticket. Files shared by several tickets
belong in the batch `docs/` folder, whose manifest records the shared artifact
owner and links. Each ticket `docs/` folder must contain a `README.md` manifest;
every other artifact must have one ticket owner, a resolvable link, a purpose,
and source or generator evidence. Keep exactly three ticket records at the
ticket-folder root: `ticket.md`, `apis.md`, and `entities.md`. Use the canonical
templates at
`docs-harness/templates/ticket.md`, `docs-harness/templates/apis.md`,
`docs-harness/templates/entities.md`, and
`docs-harness/templates/ticket-docs-README.md` for the manifest.

`apis.md` lists only verified APIs relevant to the ticket and records whether
API calls or seed data are the appropriate preparation path. Both inventory
files must record a real last-reviewed date, evidence sources, and an evidence
summary; an empty inventory must state what was checked and `None found`.
`entities.md` lists relevant entities, fields, relationships, and enum meanings
with evidence. Unknown facts remain explicitly marked; they are not inferred
into the record.

The placeholder folder examples are stored under
`docs-harness/templates/<ticket-number>-<single-ticket>/` and
`docs-harness/templates/<sample-big-ticket>/`; they are layout templates, not
active tickets.

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

Ticket folder names use `<ticket-number>-<lowercase-kebab-case-slug>`. A
multi-ticket source uses a lowercase-kebab-case batch container and one such
child folder per ticket. Existing user files are preserved; ambiguous folder
collisions require clarification before work continues.
