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
- When a risk is identified in a response, include at least one proposal or
  solution inline.
- When persistence is authorized, create a corresponding proposal resource and
  keep reciprocal `REFERENCES:` and related-section links resolvable.
- Keep a risk open until its durable acceptance evidence passes; mitigation is
  not automatically resolution.

## Skip When

Skip this folder when no security, performance, or memory-leak concern is in
scope.
