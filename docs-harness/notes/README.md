# User-Authorized Notes

This folder stores concise context that the User explicitly asked Harness to
retain, such as an observed gap, a follow-up boundary, or a link to a decision
that still needs action.

## Read When

Read notes when the current task depends on prior User-authorized context, an
accepted gap, a follow-up, or an authority boundary recorded here. Skip this
folder for unrelated product work.

## Authority Boundary

- A note records User authority or an observation; it does not grant new
  authority by itself.
- A note does not replace a canonical risk, proposal, decision, plan, ticket,
  or constraint resource.
- Promote lasting policy, risk, proposal, decision, or durable execution work
  to its canonical folder and use the matching template when the User
  authorizes that promotion.
- Suggested actions in a note remain suggestions until the User separately
  authorizes them.

## Note Format

Use one Markdown file per note with a date-prefixed lowercase-kebab-case name:
`<MMDD>-<lowercase-kebab-case-meaning>.md`.

Each note should identify:

- the User authority or request being recorded;
- the creation date and current note status;
- the bounded subject and relevant references;
- observed facts separately from suggested follow-up; and
- the condition for resolution, supersession, or promotion.

Notes are supporting records, not resource records. They do not receive a
Harness resource ID, classification tag, or priority unless they are promoted
to a canonical resource type.

## Current Notes

- [Harness compatibility gaps](0815-harness-compatibility-gaps.md)
