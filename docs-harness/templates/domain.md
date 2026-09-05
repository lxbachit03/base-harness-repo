# Domain Knowledge Resource

> Template-only: this file is not a domain resource or domain truth. A
> qualifying evidence-backed workflow may instantiate it as
> `docs-harness/domain/<MMDD>-<name>/README.md` with `[UNCERTAIN]` state; an
> explicit User confirmation is still required for `[CONFIRMED]`.

ID: #<next-sequence>_<PRIMARY_CLASSIFICATION>_<MMDD>
TAG: [DOMAIN]
TAG: [<CONFIRMED|UNCERTAIN>]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <title>
CREATED: <YYYY-MM-DD>
STATUS: <status>
REFERENCES:
- <path-or-resource-id>

## Domain Statement

<State the project/domain knowledge.>

## Evidence/Authority

<Record repository paths and line ranges, ticket/section references, or the
recorded Q&A decision. Separate observed facts from User-confirmed authority.>

## Capture and Confirmation Gate

Before creating a real domain resource from this template:

1. Confirm that the current workflow is an active `$onboarding` flow, a ticket
   workspace, or Q&A explicitly marked as domain discovery.
2. Confirm a non-colliding `<MMDD>-<lowercase-kebab-case-name>` folder and a
   complete evidence set for every claim.
3. Record contradictions and open questions; use `[UNCERTAIN]` unless the User
   explicitly confirms the knowledge.
4. Add the canonical `README.md` to `docs-harness/INDEX.md` only after it
   exists under `docs-harness/domain/<MMDD>-<name>/`.

If evidence, scope, or the collision check is unresolved, stop at the template
and report the missing input. Do not turn a plan or inference into domain truth.

## Freshness

Last validated: <YYYY-MM-DD>
Validation scope: <changed paths or initial capture scope>
Freshness: <CURRENT|STALE>
Validation result: <summary and source references>
Changed sources: <None or paths that triggered review>

After a runtime-logic, persistence, contract, or data-flow code change, compare
changed paths with this resource's references, citations, and linked
dependencies. Re-validate uncertain overlaps. If claims no longer hold, set
`STATUS: needs-review` and `Freshness: STALE`, record the changed source and
pause. Do not rewrite `[CONFIRMED]` knowledge automatically. Directly
evidenced `[UNCERTAIN]` updates remain `[UNCERTAIN]`.

## Confidence

<Explain why this is CONFIRMED or UNCERTAIN.>

## Q&A Evidence

Date: <YYYY-MM-DD or None>
Scope: <question scope or None>
User answer/decision: <answer or None>
State: <CONFIRMED|UNCERTAIN|None>
Source: <ticket, onboarding flow, or Q&A reference>

## Open Questions

<List unresolved questions requiring confirmation, or state none.>
