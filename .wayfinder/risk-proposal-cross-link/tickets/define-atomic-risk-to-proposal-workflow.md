---
id: WT-008
type: ticket
title: Define Atomic Risk-to-Proposal Creation and Failure Recovery
status: closed
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by:
  - WT-005
  - WT-006
  - WT-007
assignee: codex
claimed_at: 2026-08-10
resolved_at: 2026-08-10
---

## Question

Given the evidence, link schema, and authorization boundary, what exact sequence
does the agent follow from codebase detection through risk creation, proposal
creation, reciprocal links, and the risk-only index update? Decide permitted
partial states, failure recovery, and when completion may be claimed.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Happy-path sequence:

1. Confirm that the finding meets the evidence/promotion rule and that the
   current prompt authorizes repository/Harness mutations.
2. Scan all existing Harness resource IDs and filenames; allocate immutable
   IDs and date-prefixed filenames without overwriting anything.
3. Render the complete risk and proposal resources in memory, including their
   reciprocal links and all required metadata.
4. Reuse an existing proposal when it addresses the same risk/solution;
   create a new proposal only when its solution or context is materially
   distinct.
5. Write the risk and proposal resources with their reciprocal relationship.
6. Update `INDEX.md` with the risk item and its proposal links, without adding
   proposal items as independent INDEX entries.
7. Run the relationship, ID, path, metadata, and risk-only INDEX validation.
8. Claim completion only after every check passes.

Atomicity and recovery:

- Atomicity is a completion contract: no risk/proposal/index partial state is
  accepted at the task boundary.
- If a write or validation fails, continue repairing within the same bounded
  change when safe.
- If safe repair is impossible, roll back only newly created files and INDEX
  changes from this task, preserve unrelated/pre-existing changes, and report
  the blocker; do not claim completion.
- A risk without its required proposal, a one-way relationship, an unindexed
  risk, or a proposal/index update that is only partially applied is not a
  valid completed state.

Concurrency and shared proposals:

- Re-scan before writing if concurrent changes are detected; pause on unclear
  ownership or collision rather than overwrite.
- When one proposal addresses multiple risks, update the reciprocal link set
  for every affected risk in the same bounded change.
