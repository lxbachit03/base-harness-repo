# Resource Templates

This folder contains stable system templates for creating supported Harness
resources. Templates are scaffolding, not canonical resources and not default
task instructions.

## Available Templates

- `activity-diagram.md`: Mermaid flow/activity diagrams with file and line range citations for onboarding flows.
- `constraint.md`: file, folder, or task constraints.
- `decision.md`: lasting product or architecture decisions.
- `domain.md`: confirmed or uncertain domain knowledge.
- `exec-plan.md`: durable execution plans.
- `harness-improvement.md`: bounded Harness improvement experiments.
- `plan.md`: plan resources requiring the common resource metadata.
- `proposal.md`: options and recommendations awaiting authority.
- `risk.md`: security, performance, and memory-leak risks.
- `ticket.md`: ticket records managed under `docs-harness/tickets/active/` or
  `docs-harness/tickets/completed/`.

## Usage Rules

- Read the matching template before creating a new supported resource.
- Preserve the required metadata, immutable IDs, dates, tags, priorities, and
  references defined by `AGENTS.md`.
- Replace placeholders with evidence; do not fabricate domain knowledge,
  priority, authority, or validation.
- Templates do not receive real resource IDs or date-prefixed filenames and
  should not be indexed as real resources.
- Update `docs-harness/INDEX.md` in the same task when a real resource or
  routing metadata changes.

## Skip When

Skip this folder when the task edits existing content only or does not create a
supported resource.
