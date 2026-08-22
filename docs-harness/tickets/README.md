# Tickets

This folder is the Harness working area for `$ticket-solving`. Its lifecycle is
split between current work and historical work.

## Layout

One ticket is placed under `active/` while it is being worked:

```text
docs-harness/tickets/
├── active/
│   └── <ticket-slug>/
│       ├── docs/
│       │   ├── README.md
│       │   └── <source-files-supporting-resources-and-AI-artifacts>
│       ├── ticket.md
│       ├── APIs.md
│       └── SCHEMAs.md
└── completed/
    └── <ticket-slug>/
        ├── docs/
        │   └── README.md
        ├── ticket.md
        ├── APIs.md
        └── SCHEMAs.md
```

When one source file contains multiple tickets, the source stays once in an
active batch folder and each ticket gets its own child folder:

```text
docs-harness/tickets/active/<batch-slug>/
├── docs/
│   ├── README.md
│   └── <shared-source-and-resources>
├── <ticket-a-slug>/
│   ├── docs/
│   │   └── README.md
│   ├── ticket.md
│   ├── APIs.md
│   └── SCHEMAs.md
└── <ticket-b-slug>/
    ├── docs/
    │   └── README.md
    ├── ticket.md
    ├── APIs.md
    └── SCHEMAs.md
```

Files that apply to one ticket belong in its `docs/` folder. This includes
source files, PDFs, JavaScript, HTML, logs, screenshots, and artifacts created
by the AI agent while working the ticket. Files shared by several tickets
belong in the batch `docs/` folder, whose manifest records the shared artifact
owner and links. Each ticket `docs/` folder must contain a `README.md` manifest;
every other artifact must have one ticket owner, a resolvable link, a purpose,
and source or generator evidence. Keep exactly three ticket records at the
ticket-folder root: `ticket.md`, `APIs.md`, and `SCHEMAs.md`. Use the canonical
templates at
`docs-harness/templates/ticket.md`, `docs-harness/templates/APIs.md`,
`docs-harness/templates/SCHEMAs.md`, and
`docs-harness/templates/ticket-docs-README.md` for the manifest.

`APIs.md` lists only verified APIs relevant to the ticket and records whether
API calls or seed data are the appropriate preparation path. Both inventory
files must record a real last-reviewed date, evidence sources, and an evidence
summary; an empty inventory must state what was checked and `None found`.
`SCHEMAs.md` lists relevant entities, fields, relationships, and enum meanings
with evidence. Unknown facts remain explicitly marked; they are not inferred
into the record.

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
