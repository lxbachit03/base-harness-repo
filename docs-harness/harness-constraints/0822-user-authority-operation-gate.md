# Constraint Resource

ID: #009_CONSTRAINTS_0822
TAG: [CONSTRAINTS]
PRIORITY: [CRITIAL]
TITLE: User authority for filesystem mutations and side-effecting commands
CREATED: 2026-08-22
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/WORKFLOW.md
- docs-harness/plans/active/0822-user-authority-operation-gate.md
- .agents/skills/goal-griller/SKILL.md
- .agents/skills/improve-harness/SKILL.md

## Constraint

The AI agent operates read-only by default. It may create, edit, delete, move,
rename, copy, or generate files and folders only when the current User request
explicitly authorizes the operation and its scope. It may run build, test, lint,
format, generation, installation, migration, or package commands that can
write artifacts or state only when the User explicitly authorizes the command
or command class.

## Applies To

- All repository files and folders.
- `AGENTS.md`, `docs-harness/WORKFLOW.md`, and agent skills that select or run
  repository operations.
- Filesystem mutations, generated output, build/test execution, and other
  commands with repository or environment side effects.

## Rationale

The User owns authority over repository changes and side-effecting validation.
Separating read-only inspection from authorized operations prevents a route,
skill invocation, implementation request, or validation step from silently
expanding into unrelated edits or command execution.

## Enforcement

1. Classify each proposed action as read-only inspection, filesystem mutation,
   or side-effecting command.
2. For a mutation, require explicit User authority for the target path and
   operation.
3. For build/test or another side-effecting command, require explicit User
   authority for the command or command class.
4. If authority or scope is missing, pause and report the exact operation or
   command needed.
5. When proof is unattempted because authority is missing, report it as
   unattempted rather than claiming success.

## Validation

Check that `AGENTS.md`, `WORKFLOW.md`, the goal front door, and the improvement
skill preserve this gate. A fresh equivalent session must demonstrate both a
pause/no-build-test path without authority and a scoped path with explicit User
authority.
