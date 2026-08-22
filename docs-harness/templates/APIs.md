# APIs: <ticket-title>

This file inventories repository APIs that are relevant to this ticket. Record
verified facts for the User and agent; do not invent endpoints or request
contracts.

## Scope

- Ticket: <ticket-id-or-title>
- Ticket owner: <person-team-or-role>
- Canonical ticket record: [`ticket.md`](ticket.md)
- Artifact manifest: [`docs/README.md`](docs/README.md)
- Service or repository area: <service-or-area>

## Review Record

- Last reviewed: <YYYY-MM-DD>
- Evidence sources: <file paths, links, or commands inspected>
- Evidence summary: <what was verified, or what was checked before recording `None found`>

Replace every placeholder above with a real review date and evidence before
using this file as a ticket record. If no relevant API is found, record the
review date, the repository paths or commands checked, and `None found` rather
than omitting the review evidence.

Only APIs relevant to this ticket belong here. Use `TBD`, `Not found`, or
`Unverified` when the repository does not establish a fact.

## API Inventory

### `<HTTP-METHOD> <path>`

- Purpose: <what this API does for the ticket>
- Implementation/source: `<path>:<line>`
- Availability: <available, feature-gated, deprecated, or unverified>
- Authentication/authorization: <required identity, role, scope, or unknown>
- Request:
  - Path parameters: <name, type, meaning>
  - Query parameters: <name, type, requiredness, meaning>
  - Headers: <required headers>
  - Body: <shape or link to an example in docs/>
- Response:
  - Success: <status and response shape>
  - Errors: <status, error shape, and meaning>
- Side effects: <entities/data written or `None verified`>
- Data preparation: <use this API, seed data, or both>
- Seed-data alternative: <fixture/factory/script/path, or `None found`>
- Example: `<method> <path>` with `<docs/example-file>`

## Data Preparation Decision

- Recommended path: <API | seed data | either | blocked>
- Reason: <source-backed reason>
- Existing seed or fixture sources: <paths>
- Required User authority or command to run: <authority or `Not requested`>

Do not run an API call, seed command, build, or test from this template. Record
the command or request for a separately authorized execution.

## Missing or Unverified APIs

- <API or capability still needed, evidence checked, and next owner/action>
