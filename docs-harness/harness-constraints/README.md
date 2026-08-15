# Harness Constraints

This folder contains rules that constrain files, folders, or a specific task.
Constraints describe boundaries that future work must preserve; they are not
implementation plans or accepted product decisions.

## Read When

Read this folder when a task creates, edits, moves, renames, deletes, or
validates repository paths under a known constraint. Start with the resource
linked from `docs-harness/INDEX.md`.

## Create And Maintain

- Use `docs-harness/templates/constraint.md` for a new constraint resource.
- Record the scope, authority, status, and references that establish the rule.
- Keep one canonical resource and index it from every applicable classification
  section; do not duplicate its contents in `INDEX.md`.
- Keep task-local implementation choices in the plan or change, not in a
  generic constraint record.

For the risk-to-proposal constraint, a detected risk still needs an inline
proposal or solution, while persisted risk and proposal resources require
reciprocal references when the User authorizes persistence.

## Skip When

Skip this folder when the task has no file/folder boundary or other explicit
repository constraint in scope.
