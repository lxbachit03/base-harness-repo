# Harness Constraints

This folder contains rules that constrain files, folders, or a specific task.
Constraints describe boundaries that future work must preserve; they are not
implementation plans or accepted product decisions.

Project-specific rules live in [project-constraints/](../project-constraints/README.md)
and are read at every session start through INDEX.

## Session-start constraints

At every session start, including delegated workers, read and apply these two
before task work, as [INDEX](../INDEX.md) requires. Reload them after a workspace
switch, lost routing context, or a User-reported change to one.

- [#009_CONSTRAINTS_0822](0822-user-authority-operation-gate.md): task authority.
- [#074_CONSTRAINTS_1120](1120-session-role-and-judgment.md): session role,
  evidence and judgment, documentation ownership.

Read [#075_CONSTRAINTS_1120](1120-work-shape-proof-completion.md) (work shape,
proof, completion) before changing anything and before reporting a result.

## Read When

Read the rest of this folder when a task creates, edits, moves, renames, deletes,
or validates repository paths under a known constraint. Start with the resource
linked from `docs-harness/INDEX.md`.

## Create And Maintain

- Use `docs-harness/templates/constraint.md` for a new constraint resource.
- Record the scope, authority, status, and references that establish the rule.
- Keep one canonical resource and index it from every applicable classification
  section; do not duplicate its contents in `INDEX.md`.
- Keep task-local implementation choices in the plan or change, not in a
  generic constraint record.

Risk reporting and task-local proposed responses follow
[#001_CONSTRAINTS_0812](0812-risk-proposal-suggestion-cross-link.md).

## Skip When

Skip this folder when the task has no file/folder boundary or other explicit
repository constraint in scope.
