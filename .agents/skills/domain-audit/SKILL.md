---
name: domain-audit
description: Add one evidence-backed domain resource to this repository's Harness context when the User explicitly invokes `$domain-audit`; validate related existing domains after logic changes and pause on weak, conflicting, or stale evidence.
disable-model-invocation: true
---

# Domain Audit

When the User explicitly invokes `$domain-audit`, materialize one bounded,
evidence-backed domain resource in the Harness repository. This is a write
workflow: the invocation means “add this domain to Harness”, not “write a
read-only audit report”. Keep the resource useful, traceable, visibly
uncertain until confirmed, and current after related code changes.

## Outcome and boundary

Complete one domain addition only when all of these are true:

- `docs-harness/domain/<MMDD>-<lowercase-kebab-case-name>/README.md` exists;
- every claim has a resolvable evidence citation;
- the new resource has `TAG: [DOMAIN]` and `TAG: [UNCERTAIN]` by default;
- `docs-harness/INDEX.md` links the resource under the correct domain state;
- affected existing domains have a recorded freshness result; and
- the relevant Harness validator and diff checks pass.

The direct `$domain-audit` invocation authorizes the bounded domain mutation
and the required INDEX update. Keep the boundary to the domain resource,
affected-domain freshness records, and their routing links. Preserve product
code, existing `[CONFIRMED]` knowledge, ticket/onboarding transcripts, and
unrelated Harness resources. A new resource is one domain scope; split or
pause when the evidence covers materially different scopes.

## Read the authority first

Follow the repository entry order before editing:

1. Read `AGENTS.md`.
2. Read `docs-harness/INDEX.md`.
3. Read `docs-harness/domain/README.md` and
   `docs-harness/templates/domain.md`.
4. Route to the relevant active ticket or onboarding workspace from the INDEX.
   For domain-discovery Q&A, use the current conversation and record the
   question scope and User decision.

The domain README owns the capture gate, resource layout, freshness contract,
schema authority gate, and classification rules. This skill executes that
contract; it does not replace it with a second policy.

## 1. Establish the capture gate

The current evidence must come from one of these bounded contexts:

- an active `$onboarding` flow whose evidence artifacts are complete;
- an active ticket-solving workspace investigating domain behavior, ownership,
  or a data flow; or
- Q&A explicitly marked as domain discovery.

The User's `$domain-audit` invocation expresses the intent to persist the
domain. It does not turn an unsupported inference into evidence. Read the
complete source material before writing and establish:

- one domain boundary, title, and lowercase-kebab-case slug;
- the entry, exit, ownership, state, contract, or data-flow claims being
  captured;
- a source for every claim: repository path and inclusive line range,
  ticket/section, or recorded Q&A decision;
- contradictions, unknowns, and open questions; and
- two independent sources where practical.

Separate facts observed in code from User-confirmed authority. Do not infer a
business rule from naming, an adjacent implementation, or a single example.
If the source context, scope, or claim evidence is incomplete, pause and
report the exact missing input before creating a resource.

**Completion criterion:** the complete evidence set and one non-colliding
domain scope are written down before the first domain-file edit.

## 2. Run the freshness gate

Inspect the current worktree's changed paths whenever the task includes a
runtime-logic, persistence, contract, or data-flow change. Compare them with
every existing domain resource's `REFERENCES`, evidence citations, and linked
service/data-flow dependencies. Treat uncertain overlap as affected; only a
clear non-overlap excludes a domain.

For every affected resource, re-check each claim and line-range citation:

- If the claims still hold, record `Freshness: CURRENT`, the Asia/Bangkok
  validation date, validation scope, and result.
- If a source changed, a citation no longer resolves, or claims conflict,
  record `STATUS: needs-review`, `Freshness: STALE`, the changed source, and
  the unresolved question, then pause.
- Preserve `[CONFIRMED]` content during automatic maintenance. A directly
  evidenced `[UNCERTAIN]` resource may receive new evidence but remains
  `[UNCERTAIN]` until the User explicitly confirms it.

When no runtime or domain-contract code changed, record the initial capture
scope as current after the new claims are checked. Documentation-only changes
do not trigger revalidation by themselves unless their impact is uncertain.

**Completion criterion:** every affected existing domain has a current result
or an explicit stale result with a pause; no affected domain is silently
treated as current.

## 3. Create the canonical domain resource

Use `docs-harness/templates/domain.md` as the structure and preserve its
canonical headings. Before choosing metadata:

1. Scan all of `docs-harness/` for resource IDs and use one global
   `max(existing ID) + 1` sequence.
2. Use the zero-padded current month and day in `Asia/Bangkok` for `<MMDD>`.
3. Confirm that
   `docs-harness/domain/<MMDD>-<lowercase-kebab-case-name>/` does not collide.
4. Create the folder's `README.md` only after the evidence gate passes.

The new README must contain concrete metadata, including a unique ID,
priority, title, creation date, status, and `REFERENCES`. Its required state
is:

```text
TAG: [DOMAIN]
TAG: [UNCERTAIN]
```

Use `STATUS: active` and `Freshness: CURRENT` for a validated initial capture.
Record the validation date, capture scope, result, changed sources, confidence,
open questions, and any Q&A evidence. Link ticket or onboarding artifacts in
`REFERENCES`; keep their full transcript and supporting files in their owning
workspace.

Create a `[CONFIRMED]` resource or change `[UNCERTAIN]` to `[CONFIRMED]` only
when the User explicitly confirms the domain knowledge. The request to add a
domain is not itself confirmation. Use `STATUS: needs-review` and
`Freshness: STALE` when the freshness gate finds a contradiction; record the
source and pause rather than repairing the claim by guesswork.

The schema and field-tracing authority boundary remains active: create schema
content only when its scope is authorized or directly supported by evidence,
and explain field assignment, transformation, reads, serialization, or query
usage only with explicit User authority for codebase tracing.

**Completion criterion:** one source-backed date-prefixed README contains the
full metadata, evidence/authority, freshness, confidence, Q&A, and open-
question record without promoting uncertain knowledge.

## 4. Update routing after the file exists

After the canonical README exists, update `docs-harness/INDEX.md` in the same
task:

- list the resource under `[UNCERTAIN]` unless the User supplied explicit
  confirmation;
- use the canonical relative link to the nested `README.md` and its ID;
- keep `[CONFIRMED]` and `[UNCERTAIN]` entries separate; and
- keep the filesystem tree and INDEX resource links aligned without duplicate
  entries.

Do not create a direct Markdown resource at `docs-harness/domain/`; the nested
date-prefixed folder is the canonical layout. The root domain README remains
the contract, not a captured domain resource.

**Completion criterion:** the new README is resolvable from exactly the correct
INDEX classification section, and no duplicate resource link or ID exists.

## 5. Validate and hand off

Run repository-native, read-only checks relevant to the changed boundary:

- `node --check .agents/validators/sync-harness-index.js`;
- `node .agents/validators/sync-harness-index.js --check`;
- `git diff --check`; and
- targeted inspection of the final domain tree, metadata, references,
  freshness/status pair, INDEX link, and changed-path impact set.

Build, test, lint, format, generation, installation, migration, and package
commands require separate explicit User authority. If a required proof cannot
run, report it as unattempted rather than substituting a weaker proxy. Check
the final Git diff for unrelated edits and report any ignored domain files
explicitly; this repository may globally ignore `docs-harness/`, so commit
persistence requires a separate explicit request and narrowly scoped
`git add -f`.

Return the outcome, canonical path, evidence sources, state, freshness result
for each affected domain, validation results, unresolved questions, and any
pause condition. Do not claim completion from folder creation alone.

## Pause rules

Pause before or during mutation when:

- the capture context is not an active onboarding flow, active ticket
  workspace, or explicitly marked domain-discovery Q&A;
- the domain boundary, slug, global ID, or folder collision is ambiguous;
- a claim has no path/line, ticket/section, or Q&A decision;
- sources conflict and no User decision resolves the conflict;
- a changed path may affect an existing domain but the current claim cannot be
  revalidated;
- a `[CONFIRMED]` resource would need an unapproved rewrite;
- schema field tracing needs User authority;
- the required INDEX or validator proof is unavailable; or
- the requested work would touch product code, unrelated Harness guidance,
  external systems, credentials, or an irreversible recovery path.

When a risk is found, pair it with a proposal in the handoff. For weak or
noisy capture, the proposal is to strengthen the source map and keep the
resource `[UNCERTAIN]`; for indirect dependency risk, include the domain in
the affected set; for global-ignore risk, persist only after explicit Git
authority. Preserve all existing work while paused.
