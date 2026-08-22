---
ticket_id: <stable-ticket-id-or-TBD>
title: <ticket-title>
status: intake
created: <YYYY-MM-DD>
owner: <person-team-or-role>
source: <docs/source-file-name-or-location-or-User-prompt>
---

# Ticket: <ticket-title>

## Workspace

Every ticket folder contains this fixed working set:

```text
<ticket-slug>/
├── docs/
│   ├── README.md
│   └── <source-files-supporting-resources-and-AI-artifacts>
├── ticket.md
├── APIs.md
└── SCHEMAs.md
```

- `docs/`: ticket-specific PDFs, JavaScript, HTML, logs, screenshots, source
  files, and artifacts created by the AI agent. Its `README.md` is the required
  manifest: every other item must have one ticket owner, a purpose, a source or
  generator, and a link from the manifest or an applicable ticket record. Do
  not place unrelated files here.
- `APIs.md`: verified repository APIs relevant to this ticket, including
  whether an API or seed-data path is the better way to prepare data.
- `SCHEMAs.md`: verified database entities/schemas, field meanings,
  relationships, and enum meanings relevant to this ticket.

Keep unknown facts as `TBD`, `Not found`, or `Unverified`; do not invent API,
schema, field, or enum details.

## Ownership

- Ticket owner: <person-team-or-role>
- Canonical ticket record: this file
- Artifact manifest: [`docs/README.md`](docs/README.md)

Keep the owner consistent with the ticket frontmatter and the artifact
manifest. Do not claim an artifact is ticket-owned when its owner or link is
unknown.

## Original ticket

<!-- Preserve the source wording here. Put a file source under docs/. -->

<paste-or-transcribe-the-ticket-verbatim>

## Summary

<one-paragraph source-backed summary>

## Context and evidence

- Source:
- Relevant files, links, logs, or screenshots:
- Known constraints:
- API inventory: `APIs.md`
- Schema inventory: `SCHEMAs.md`

## Expected outcome

<what should be true when this ticket is resolved>

## Acceptance criteria

- [ ] <observable criterion>
- [ ] <observable criterion>

## Scope

### In scope

- <change or investigation covered by this ticket>

### Out of scope

- <explicitly excluded work>

## Plan and decisions

1. <step>

Decision log:

- <YYYY-MM-DD>: <decision and reason>

## Implementation or resolution

<changed files, commands, explanation, or link to a companion document>

## Validation

- Command/check:
  - Result:
- Manual or runtime proof:
  - Result:

## Risks and open questions

- Risk:
  - Proposal or mitigation:
- Open question:
  - Owner/next action:

## Artifacts

- Manifest: [`docs/README.md`](docs/README.md)
- `docs/<filename>` — <purpose>

The manifest must list every file or folder under `docs/` other than itself,
including source material and AI-created artifacts. Each entry records the
ticket owner, a resolvable artifact link, purpose, source or generator, the
record that links to it, and its status.
