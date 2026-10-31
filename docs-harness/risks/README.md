# Risks

This folder contains security, performance, and memory-leak risk records. A
risk record describes an evidenced exposure or failure mode; it does not by
itself approve a mitigation or close the risk.

## Read When

Read this folder when the task could introduce, assess, mitigate, or validate a
security, performance, or memory-leak concern. Prefer first-party repository
evidence over assumptions.

## Create And Maintain

- Use `docs-harness/templates/risk.md`.
- Record the risk, evidence, impact, indicators, mitigation status, and
  verification path.
- Risk/proposal pairing (inline proposal; persisted pair with reciprocal links)
  follows [#001_CONSTRAINTS_0812](../harness-constraints/0812-risk-proposal-suggestion-cross-link.md).
- Keep a risk open until its durable acceptance evidence passes; mitigation is
  not automatically resolution.

## Skip When

Skip this folder when no security, performance, or memory-leak concern is in
scope.
