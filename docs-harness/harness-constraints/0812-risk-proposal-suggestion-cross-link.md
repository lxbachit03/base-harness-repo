# Risk and Proposed Response Constraint

ID: #001_CONSTRAINTS_0812
TAG: [CONSTRAINTS]
PRIORITY: [MEDIUM]
TITLE: Risk findings require proposed responses
CREATED: 2026-08-12
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/templates/risk.md
- docs-harness/templates/proposal.md

## Constraint

Whenever the AI agent identifies a risk in an answer, review, diagnosis, plan,
implementation, or validation, it must state at least one proposal/solution for
that risk in the same response. The proposal is a suggestion and must not be
applied or presented as accepted without User authority.

When authorized work uses a ticket or durable plan, record each risk and its
proposed response together inline in that ticket or plan. A Harness improvement
record serves as its task's plan. Include evidence, status, and the next
verification or investigation; distinguish a suggestion from an approved or
implemented action. Do not recreate dedicated risk or proposal folders for
routine tracking.

## Applies To

- AI agent answers, reviews, diagnoses, plans, implementations, and validation
  reports that identify a risk.
- Risk and proposal notes in a ticket or plan when the task authorizes writing
  that record.
- The runtime guidance in `AGENTS.md` and the routing entry in
  `docs-harness/INDEX.md`.

## Rationale

The User confirmed that every detected risk must lead to at least one suggested
proposal/solution, while the proposal remains subject to User authority. The
User chose to keep the risk and its proposed response together in the relevant
ticket or plan instead of dedicated folders.

## Enforcement

1. When a risk is detected, include the risk and at least one proposal/solution
   in the same response. State that the proposal is not applied or accepted
   without User authority.
2. For a read-only request, report the risk and response without creating or
   changing files.
3. When authorized work maintains a ticket or plan, keep the risk and response
   together there; the risk and proposal templates provide optional inline
   scaffolding. Record any unresolved evidence or authority explicitly.
4. If the task has no authorized ticket or durable plan, report the risk and
   response in the answer. Do not create a ticket or plan solely to store it.

## Validation

- The response or report contains an explicit proposal/solution for every risk
  it identifies.
- An authorized ticket or plan records each risk with its proposed response,
  evidence and status together, without implying the proposal was accepted.
- The constraint is indexed from `docs-harness/INDEX.md`, and the runtime rule
  is present in `AGENTS.md`.
- Completion checks include the tree, folder-section, link, and duplicate-
  resource consistency checks required by the Harness instructions.
