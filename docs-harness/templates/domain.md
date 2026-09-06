# Domain Knowledge Resource

Use the capture, confirmation, tracing, and freshness contract in
docs-harness/domain/README.md. This is a template, not a domain fact.

ID: #<next-sequence>_<creation-kind>_<MMDD>
TAG: [DOMAIN]
TAG: [UNCERTAIN]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <title>
CREATED: <YYYY-MM-DD>
STATUS: active
REFERENCES:
- <source-path-or-resource-id>

## Domain Statement

<Source-backed claims; distinguish observed behavior from accepted policy.>

## Evidence/Authority

<For each claim: path and line range or symbol/revision, ticket section, or
recorded User decision. Include dependency links used for impact selection.>

## Freshness

Last validated: <YYYY-MM-DD>
Validation scope: <initial capture or affected claims and changed paths>
Freshness: CURRENT
Validation result: <what was checked and observed>
Changed sources: <None or paths/symbols that triggered review>

## Confidence

<Why this remains uncertain, or the explicit User confirmation and date.
Confirmation preserves the ID, including its creation-kind component.>

## Q&A Evidence

<Date, scope, answer/decision, state, and source; None when inapplicable.>

## Open Questions

<Contradictions, unknowns, and the next verification/decision; or None.>
