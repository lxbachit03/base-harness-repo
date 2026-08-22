# Domain Knowledge Resource

> Template-only: this file is not a domain resource or domain truth. Creating
> a real domain resource from it requires an explicit current User request that
> names the scope and authorizes the write under `docs-harness/domain/`.

ID: #<next-sequence>_<PRIMARY_CLASSIFICATION>_<MMDD>
TAG: [DOMAIN] [<CONFIRMED|UNCERTAIN>]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <title>
CREATED: <YYYY-MM-DD>
STATUS: <status>
REFERENCES:
- <path-or-resource-id>

## Domain Statement

<State the project/domain knowledge.>

## Evidence/Authority

<Record the authoritative source or User confirmation.>

## Promotion Gate

Before creating a real domain resource from this template:

1. Confirm that the current User explicitly authorized the named domain scope.
2. Record the authoritative source or the User confirmation; do not promote
   agent inference, a plan, or this template's placeholders.
3. Mark the resource `[CONFIRMED]` only when its authority is explicit;
   otherwise use `[UNCERTAIN]` and preserve the open question.
4. Add the canonical resource to `docs-harness/INDEX.md` only after the real
   file exists under `docs-harness/domain/`.

If any gate item is unresolved, stop at the template and report the missing
authority or evidence instead of creating the domain resource.

## Confidence

<Explain why this is CONFIRMED or UNCERTAIN.>

## Open Questions

<List unresolved questions requiring confirmation, or state none.>
