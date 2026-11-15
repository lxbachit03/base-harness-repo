# Execution Plans

Use an ephemeral plan for a bounded, single-session task. A request to discuss
a plan does not create a file; a request to save one does.

## Durable plan contract

When authorized work spans sessions, coordinates contributors, has meaningful
dependencies, or needs recovery, maintain one plan under active/. Start from
docs-harness/templates/plan.md and use the metadata/ID rules in
docs-harness/templates/README.md.

Record outcome, context, scope, task authority, approach, progress,
risks/recovery, validation, and result. For ticket work, link the ticket's
decision history; do not create a separate decision record outside a ticket.
Record each risk and its proposed response together inline in the plan, keeping
suggestions distinct from accepted actions per the risk/proposal constraint.

Read current plans through docs-harness/INDEX.md; avoid maintaining a second active-plan list
here. Completed plans are historical evidence, not active policy. An older
active plan may describe a superseded policy; its baseline is not authority to
restore that policy.

## Lifecycle

Update progress as evidence changes. After the outcome and relevant proof are
recorded, move the plan from active/ to completed/ within the authorized task,
replace its INDEX entry with an entry in completed/README.md, and update
current links. Preserve ID, creation date, and evidence.

New Harness improvement records live in docs-harness/harness-improvements/ and serve as their
working memory under docs-harness/harness-improvements/README.md, rather than
duplicating the same experiment as a plan. Legacy experiments already in plans/
retain the lifecycle above. For either location,
implementation can be finished while an explicitly recorded behavioral rerun
remains pending. Preserve a useful historical result rather than fabricating
proof to close a plan.
