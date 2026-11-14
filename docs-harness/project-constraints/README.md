# Project Constraints

This folder contains User-authorized rules for work in the project using this
Harness. Harness-specific rules remain in [harness-constraints/](../harness-constraints/README.md).

## Retrieval

At every session start, including delegated worker sessions, read this guide
and every Markdown file recursively under this folder before task work. Read
each file even if it is missing from [INDEX.md](../INDEX.md); report routing drift and
apply each constraint whose status is `active`. Reload after a workspace
switch, lost routing context, or a User-reported change to a project constraint.

If the folder or a rule cannot be read, or a rule's status or meaning is
unclear, report the gap and pause actions whose constraints cannot be
established. Continue demonstrably independent work, including authorized
repairs. Do not invent a replacement or create missing structure during
read-only work.

## Maintenance

- Keep one constraint per resource, using the [constraint template](../templates/constraint.md)
  and the [identity and metadata rules](../templates/README.md).
- State scope, User authority, status, enforcement, and observable validation.
  An `active` rule applies; change a rule or its status only with User authority.
- Index each constraint under `project-constraints/` in `../INDEX.md` and keep
  the folder tree current. Loading all Markdown files remains mandatory even
  when the index has drifted.
- Resolve conflicts with higher-priority instructions or ambiguous User intent
  before dependent action; keep unrelated authorized work moving.
