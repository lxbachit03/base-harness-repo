---
id: WT-009
type: ticket
title: Define Proposal Handling When Mitigation Is Unknown
status: closed
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by:
  - WT-005
  - WT-006
assignee: codex
claimed_at: 2026-08-10
resolved_at: 2026-08-10
---

## Question

How must a proposal represent a risk for which no safe mitigation is known,
or where multiple options remain open? Decide the minimum options,
investigation, residual-risk, decision, and rollback content without allowing
the agent to invent a mitigation or auto-close the risk.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Unknown-mitigation contract:

- Keep the risk `STATUS: OPEN` and the proposal `STATUS: PROPOSED` while no
  safe mitigation has been selected and verified.
- In `Options`, explicitly state `No safe mitigation identified` when
  appropriate, then list investigation or escalation paths instead of
  inventing a solution.
- `Recommendation` may be `Investigate before selecting mitigation`; it must
  identify the evidence gap or investigation required.
- Add `## Residual Risk` to the proposal template and record the remaining
  exposure, uncertainty, and conditions needed to reduce it.
- `Rollback` states `No mitigation deployed; rollback not applicable` when
  nothing has been applied; prototypes or experiments require their own
  recovery/rollback instructions.
- One proposal may contain multiple options, each with tradeoffs and required
  evidence or investigation. The User selects the final recommendation and
  decision.

Lifecycle edge cases:

- If the User rejects every option, the proposal may become `REJECTED` while
  the risk remains `OPEN`; a later distinct approach may use a new proposal.
- If a mitigation is selected but not implemented or verified, the proposal
  may become `ACCEPTED` while the risk remains `OPEN`.
- Acceptance of residual risk is recorded in `Decision` and `Consequences`,
  but does not by itself mark the risk mitigated or closed.
- Investigations record the hypothesis/evidence gap, next action, owner when
  known, and exit criteria; a due date is optional and requires authority.
- A proposal remains canonical and linked/indexed even while mitigation is
  unknown; it is not complete merely because the artifact exists.
