---
id: WT-007
type: ticket
title: Define Artifact-Creation Authorization Boundary
status: closed
labels:
  - wayfinder:grilling
mode: HITL
parent: WT-004
blocked_by: []
assignee: codex
claimed_at: 2026-08-10
resolved_at: 2026-08-10
---

## Question

Under which prompt and permission boundaries may the agent create or update the
paired risk/proposal resources and the risk-only `INDEX.md` entry? Reconcile
the mandatory same-change workflow with the read-only rule for answers,
reviews, diagnoses, plans, and status reports.

## Resolution comment

Accepted after HITL grilling and domain-modeling.

Authorization boundary:

- Creating or updating risk, proposal, and risk-only `INDEX.md` artifacts is a
  repository mutation. It is authorized only by the current prompt when the
  User requests an implementation/bounded change or explicitly requests that
  the resource be recorded.
- Read-only answers, reviews, diagnoses, explanations, plans, and status
  reports may report the finding and suggest a draft proposal in the response,
  but may not create or update canonical files.
- When an authorized bounded code change discovers a qualifying risk, the
  paired risk/proposal artifacts and the risk-only INDEX update are part of the
  same bounded change; no separate per-risk approval is needed to create the
  artifacts.
- The agent may create a risk as `OPEN` and a proposal as `PROPOSED`. User
  authority is still required for the proposal recommendation, mitigation,
  or final decision.

Scope and lifetime:

- An explicit User instruction such as “only change code” or “do not edit
  docs-harness” overrides the artifact policy. The agent must not write the
  artifacts, must report the missing canonical records, and must not claim
  completion if the requested outcome requires those records.
- Authority applies only to the current prompt/bounded change and does not
  carry across prompts or sessions.
- A later prompt may grant fresh write authority; it must not retroactively
  mutate a preceding read-only task.

Safety:

- If authority, scope, or resource ownership is unclear, pause before writing
  and ask the User.
- Preserve unrelated or concurrent changes; do not overwrite a collision.
