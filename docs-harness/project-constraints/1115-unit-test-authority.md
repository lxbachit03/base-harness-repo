# Constraint Resource

ID: #058_CONSTRAINTS_1115
TAG: [CONSTRAINTS]
PRIORITY: [MEDIUM]
TITLE: User authority for writing unit tests
CREATED: 2026-11-15
STATUS: active
REFERENCES:
- docs-harness/SESSION.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md

## Constraint

Obtain User authority for test-writing in the current task before creating,
editing, or generating unit tests. A general request to implement, fix, build,
or verify does not by itself authorize writing unit tests.

## Applies To

All agent sessions working on this project, including delegated workers, and
unit tests produced by hand or by tools. Existing authority persists within the
task under `docs-harness/SESSION.md` until completed, revoked, or changed.

## Rationale

The User requested that agents not write unit tests without User authority.

## Enforcement

1. A direct User request or permission to add or update tests authorizes test
   writing within its stated scope. Respect any narrower scope the User gives.
2. Without that authority, continue other authorized work and choose available
   checks that do not write unit tests. If unit tests are needed, request
   authority before writing them; report any missing proof.
3. Running existing tests is distinct from writing tests and remains subject to
   `docs-harness/SESSION.md` authority and inspection of command effects. This rule does not
   itself prohibit other forms of verification.

## Validation

- A general implementation request does not cause new or modified unit tests.
- A direct request or permission to write applicable tests is recognized as
  authority for that task, including on a later turn while the task is active.
- An authorized run of existing tests is not mistaken for writing unit tests.
