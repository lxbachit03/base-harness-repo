# Risk-to-Proposal Suggestion and Cross-Link Constraint

ID: #001_CONSTRAINTS_0812
TAG: [CONSTRAINTS]
PRIORITY: [MEDIUM]
TITLE: Risk findings require linked proposal suggestions
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

If an authorized task persists a risk as a resource under
`docs-harness/risks/`, it must also persist a corresponding proposal resource
under `docs-harness/proposals/`. The two resources must cross-link in both
directions: each `REFERENCES:` section must include the other resource's
canonical relative path or immutable resource ID.

## Applies To

- AI agent answers, reviews, diagnoses, plans, implementations, and validation
  reports that identify a risk.
- Persisted resources under `docs-harness/risks/` and
  `docs-harness/proposals/` when the task is authorized to create or update
  Harness resources.
- The runtime guidance in `AGENTS.md` and the routing entry in
  `docs-harness/INDEX.md`.

## Rationale

The User confirmed that every detected risk must lead to at least one suggested
proposal/solution, while the proposal remains subject to User authority. A
persisted risk and its proposal must remain navigable as a pair so that the
suggested mitigation, decision status, and originating risk cannot become
orphaned.

## Enforcement

1. When a risk is detected, include the risk and at least one proposal/solution
   in the same response. State that the proposal is not applied or accepted
   without User authority.
2. For a read-only request, do not create resources; provide the proposal/
   solution inline and report any missing persisted cross-link as an unresolved
   gap.
3. When persistence is authorized, create the risk and proposal resources from
   their templates, then add reciprocal `REFERENCES:` entries using canonical
   relative paths or immutable resource IDs before claiming completion.
4. Pause when either resource is missing, a reference is one-sided or
   unresolved, an ID or path collides, or the proposal requires authority that
   has not been granted.

## Validation

- The response or report contains an explicit proposal/solution for every risk
  it identifies.
- A persisted risk has a corresponding persisted proposal, and both
  `REFERENCES:` sections point to the other resource with a resolvable path or
  matching immutable ID.
- The constraint is indexed from `docs-harness/INDEX.md`, and the runtime rule
  is present in `AGENTS.md`.
- Completion checks include the tree, folder-section, link, and duplicate-
  resource consistency checks required by the Harness instructions.
