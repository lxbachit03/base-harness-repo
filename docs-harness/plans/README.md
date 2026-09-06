# Execution Plans

Use an ephemeral plan for a bounded, single-session task. A request to discuss
a plan does not create a file; a request to save one does.

## Durable plan contract

When authorized work spans sessions, coordinates contributors, has meaningful
dependencies, or needs recovery, maintain one plan under active/. Start from
docs-harness/templates/plan.md and use the metadata/ID rules in
docs-harness/templates/README.md. The former exec-plan.md path is a compatibility
pointer to that template.

Record outcome, context, scope, task authority, approach, progress, decisions,
risks/recovery, validation, and result. Keep task-local choices in this record.
Promote an accepted lasting decision into decisions/ only when future work
must inherit it.

Read current plans through docs-harness/INDEX.md; avoid maintaining a second active-plan list
here. Completed plans are historical evidence, not active policy. An older
active plan may describe a superseded policy; its baseline is not authority to
restore that policy.

## Lifecycle

Update progress as evidence changes. After the outcome and relevant proof are
recorded, move the plan from active/ to completed/ within the authorized task,
and update INDEX and current links. Preserve ID, creation date, and evidence.

New Harness improvement records live in docs-harness/harness-improvements/ and serve as their
working memory under docs-harness/harness-improvements/README.md, rather than
duplicating the same experiment as a plan. Legacy experiments already in plans/
retain the lifecycle above. For either location,
implementation can be finished while an explicitly recorded behavioral rerun
remains pending. Preserve a useful historical result rather than fabricating
proof to close a plan.
