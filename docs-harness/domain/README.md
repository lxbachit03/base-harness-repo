# Domain Knowledge

This folder contains source-backed project or domain knowledge that the agent
may need to understand vocabulary, behavior, ownership, or accepted context. It
is not a place to invent business rules or replace product-owned source of
truth.

## Knowledge states and layout

- `TAG: [DOMAIN]` plus `TAG: [CONFIRMED]`: supported by an authoritative source
  or explicit User confirmation.
- `TAG: [DOMAIN]` plus `TAG: [UNCERTAIN]`: useful evidence-backed context that
  still requires confirmation before it becomes policy.

Keep the state visible. New knowledge from a qualifying workflow starts as
`[UNCERTAIN]`; only explicit User confirmation can make it `[CONFIRMED]`.

Every canonical domain resource uses a date-prefixed folder:

```text
docs-harness/domain/
└── <MMDD>-<lowercase-kebab-case-name>/
    ├── README.md
    ├── data-flows/       # optional, when the evidence covers an E2E flow
    └── schemas/          # optional, subject to the schema gate below
```

`<MMDD>` is the zero-padded month and day in `Asia/Bangkok`. The folder's
`README.md` is the canonical summary, metadata, evidence, authority,
confidence, freshness, references, and open questions. Keep ticket or
onboarding artifacts in their owning workspace and link them from the domain
README rather than copying the entire transcript.

## Read When

Read this folder when the task depends on project vocabulary, domain behavior,
User-confirmed context, or the freshness of an existing domain resource.
Follow only the classification route selected in `docs-harness/INDEX.md`.

## Capture gate

Capture a domain resource only in one of these explicitly scoped workflows:

1. an active `$onboarding` flow after its evidence artifacts are complete;
2. a ticket-solving run with an active ticket workspace; or
3. a Q&A explicitly marked as domain discovery.

Ordinary Q&A and unsupported inference do not create domain resources. Before
creating a resource, confirm all of the following:

1. The domain scope and lowercase-kebab-case name are clear and the
   `<MMDD>-<name>` folder does not collide with an existing resource.
2. Every claim has a concrete source: repository path and line range,
   ticket/section, or recorded Q&A decision.
3. Contradictions and open questions are recorded instead of resolved by
   guesswork; corroborate with two independent sources when practical.
4. `docs-harness/templates/domain.md` supplies the metadata and README
   structure.
5. The new resource is indexed under the correct `[UNCERTAIN]` or `[CONFIRMED]`
   route after the file exists.

For Q&A evidence, record the date, scope, User answer or decision, state, and a
link to the ticket or exploration workspace when one exists. Keep a new
resource `[UNCERTAIN]` unless the User explicitly confirms the knowledge.

## Freshness contract

Treat a runtime-logic, persistence, contract, or data-flow code change as a
freshness trigger. Compare changed paths with every domain resource's
`REFERENCES`, evidence citations, and linked service/data-flow dependencies.
An uncertain overlap is enough to include a domain in the re-validation set;
only clear non-overlap can exclude it.

For each affected resource, inspect the current source and re-check every
claim and line-range citation:

- If the claims still hold, record `Freshness: CURRENT`, the validation date,
  scope, and result in the domain README.
- If a source changed, a citation no longer resolves, or claims conflict,
  record `STATUS: needs-review`, `Freshness: STALE`, the changed source, and
  the unresolved question, then pause.
- Preserve `[CONFIRMED]` knowledge during automatic maintenance. A directly
  evidenced `[UNCERTAIN]` resource may be updated with the new evidence, but it
  remains `[UNCERTAIN]` until User confirmation.

Documentation-only changes with no runtime or domain-contract effect do not
by themselves trigger a domain re-validation, but any uncertain impact is
handled conservatively as affected.

## Service flows and schema gate

Use `docs-harness/templates/{service-name}/` for the optional service-level E2E
flow structure. A qualifying evidence-backed workflow may instantiate its
README and flow artifacts inside the date-prefixed domain folder; the template
itself is never domain truth.

Create a concrete schema file from
`docs-harness/templates/domain-entity.md` only when the named schema and scope
are authorized or directly supported by the workflow's evidence. Detailed
field explanation is a separate authority boundary: the User must explicitly
authorize codebase tracing before explaining assignment, transformation,
reads, serialization, or `WHERE`/`JOIN`/filter/query usage. Without that
authority, keep those sections as `Pending User authority` or `Unverified` and
do not infer field behavior.

## Skip When

Skip this folder when the task is independent of product/domain knowledge or
can be answered from repository structure and executable proof alone.
