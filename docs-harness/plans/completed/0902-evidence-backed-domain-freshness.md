# Harness Improvement Resource

ID: #012_IMPROVE_HARNESS_0902
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Evidence-backed domain capture and freshness validation
CREATED: 2026-09-02
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/domain/README.md
- docs-harness/templates/domain.md
- docs-harness/templates/README.md
- docs-harness/templates/{service-name}/README.md
- .agents/skills/onboarding/SKILL.md
- .agents/skills/ticket-solving/SKILL.md
- .agents/validators/sync-harness-index.js
- .agents/validators/sync-harness-index.py
- docs-harness/plans/active/0822-domain-e2e-flow-template.md

## Objective

Make evidence-backed domain capture available during an explicitly scoped
ticket, onboarding, or domain-discovery Q&A workflow while keeping every
canonical domain resource traceable, visibly uncertain until confirmed, and
freshly validated after related logic changes.

## Current State

Baseline:

- Repository root: `D:/repos/base-harness-repo`
- Repository revision: `ceaf3d9e4b7b2918af6e4e7af79bfb710ccc74f2`
- Branch: `main`
- Initial worktree: clean; no unrelated changes observed.
- Branch relation: `main` is ahead of `origin/main` by one existing commit.

Observed repository contract gap:

- `docs-harness/domain/README.md`, `templates/domain.md`, and the onboarding
  skill currently require an explicit promotion request before creating domain
  knowledge.
- Onboarding still describes a flat
  `domain/<MMDD>-<flow-name>-domain.md` path, while the requested contract is a
  date-prefixed domain folder containing `README.md`.
- The service template still treats every domain workspace as requiring
  explicit promotion, and the ticket workflow has no evidence-backed domain
  capture or freshness handoff.
- The INDEX synchronizer discovers only direct Markdown files, so it cannot
  discover `domain/<MMDD>-<name>/README.md` resources.
- Existing plan `#011_IMPROVE_HARNESS_0822` records related template/domain
  ownership friction. This is a repository-contract baseline, not a diagnosis
  of a worker limitation from one run.

User steering for this intervention established the evidence gate, scoped
triggers, folder naming, uncertainty rules, Q&A evidence shape, conservative
affected-domain detection, and stale-domain handling.

## Proposed Improvement

If the central guidance, domain contract, ticket/onboarding workflows,
templates, INDEX route, and paired JavaScript/Python validators define one
evidence-backed capture and freshness contract, then a fresh agent will create
`docs-harness/domain/<MMDD>-<name>/README.md` only for a qualifying workflow,
keep new knowledge `[UNCERTAIN]` until User confirmation, and re-validate any
domain whose references or dependencies overlap a logic-code change because
the trigger, path contract, proof fields, and stale-state response are all
visible at the points where the agent makes those decisions.

Evidence that would weaken this:

- A fresh equivalent ticket, onboarding, or domain-discovery Q&A run has
  complete source evidence but does not create or index the uncertain domain
  resource.
- A logic-code change touching a domain reference or dependency does not cause
  the affected domain to be re-validated or marked `Needs review`/`STALE` when
  a contradiction is found.
- The validator misses a valid nested domain README, accepts an invalid domain
  folder shape, or allows duplicate resource IDs to pass unnoticed.

Maintenance owner and removal condition:

- Owner: repository Harness guidance, domain templates, and the paired INDEX
  synchronizers.
- Revisit or remove the intervention if a later canonical domain lifecycle,
  repository-wide index tool, or observed fresh rerun provides a clearer single
  owner and makes this contract redundant.

## Scope

In scope:

- Add the evidence-backed domain capture and freshness pointer to `AGENTS.md`.
- Update onboarding and ticket-solving workflow steps and completion criteria.
- Update the domain and service templates and the domain routing README.
- Support date-prefixed nested domain resource folders, classification routing,
  and duplicate-ID/layout checks in the JavaScript and Python synchronizers.
- Add this active improvement record and its INDEX entries.

Out of scope:

- Product code, product policy, external systems, credentials, or database work.
- Creating a real domain resource from this Harness-policy task.
- Rewriting or reclassifying any existing domain resource.
- Changing the `goal-griller` or `improve-harness` skill definitions.
- Build, test, lint, format, generation, installation, migration, or package
  commands.

## Validation

During work:

- Check all changed paths remain within the authorized Harness scope.
- Verify the new domain folder contract, evidence fields, uncertainty state,
  Q&A evidence shape, freshness state, and pause rules are represented once in
  their owning documents and pointed to from workflows.
- Verify INDEX has both the improvement classification and active-plan route,
  with no invented domain resource.
- Verify JavaScript and Python synchronizers implement equivalent nested-domain,
  layout, classification, stale-link, and duplicate-ID behavior.

Final native proof:

- `node --check .agents/validators/sync-harness-index.js`
- `node .agents/validators/sync-harness-index.js --check`
- `git diff --check`
- Targeted text/path assertions for folder naming, status transitions, source
  references, affected-domain detection, and pause rules.

Fresh equivalent rerun:

- A fresh agent session exercised an equivalent evidence-backed Q&A/domain-
  discovery capture. It created a date-prefixed `[UNCERTAIN]` README, indexed
  it under `[UNCERTAIN]`, and passed the JS synchronizer and diff proof.
- A second fresh agent session created a disposable source-backed domain,
  changed a directly referenced logic line, detected the affected domain, kept
  the claim unchanged, marked `STATUS: needs-review` and `Freshness: STALE`,
  recorded the changed source, and paused. Its JS synchronizer and diff proof
  passed.
- Parent inspection found that the agent tool's reported fork isolation was not
  reliable: the disposable artifacts appeared in this worktree. The exact
  README, fixture, INDEX links, and empty folders were removed after evidence
  capture; the parent domain tree returned to its pre-rerun state.
- The behavior reruns are accepted for the bounded intervention. Workspace
  isolation remains an environment follow-up, not a change to this Harness
  contract.

## Risks

Automatic uncertain capture could create noisy or weak domain records. Proposal:
require source-backed claims, explicit scope, contradiction/open-question
markers, conservative naming checks, and `[UNCERTAIN]` by default.

Freshness review could miss an indirect dependency. Proposal: match changed
paths against direct references, evidence citations, and linked data-flow or
service dependencies; when impact is uncertain, include the domain in the
re-validation set rather than declaring it unaffected.

Stale handling could silently change User-confirmed knowledge. Proposal: mark
the resource `STATUS: needs-review` with `Freshness: STALE`, record the changed
source, and pause; do not rewrite `[CONFIRMED]` content automatically.

The fresh-agent runner may not isolate its filesystem from the parent worktree.
Proposal: require a verified isolated checkout or an explicitly provided fresh
agent workspace before accepting a rerun as equivalent; clean any disposable
artifacts immediately when isolation is contradicted.

## Progress

- Baseline captured at revision `ceaf3d9e4b7b2918af6e4e7af79bfb710ccc74f2`.
- User confirmed the intervention scope and all domain capture/freshness
  decisions.
- Active plan created before implementation.
- Central guidance, domain contract, onboarding/ticket workflow, templates,
  INDEX route, and paired validator changes implemented.
- Both synchronizers now discover nested domain READMEs and validate domain
  folder naming, required metadata, concrete REFERENCES, canonical sections,
  freshness/status consistency, and duplicate resource IDs.
- `node --check .agents/validators/sync-harness-index.js`: pass.
- `node .agents/validators/sync-harness-index.js --check`: pass.
- `git diff --check`: pass.
- Targeted contract/path assertions: pass; no real domain resource was created.
- In-memory JavaScript validator proof: a valid nested domain README exited 0;
  an invalid `<MMDD>_<name>` folder exited 1; no fixture files were written.
- Fresh-agent rerun attempt: the agent created a disposable evidence-backed
  `[UNCERTAIN]` domain README and its INDEX/validator proof passed, confirming
  the capture path and uncertainty behavior. Parent inspection contradicted
  the reported fork isolation because the disposable folder appeared in the
  parent worktree; the link, README, and empty folder were removed and the
  parent returned to its pre-rerun domain tree.
- Fresh freshness rerun: the agent detected a direct REFERENCES overlap after
  a logic change, preserved the original claim, marked the resource
  `STATUS: needs-review`/`Freshness: STALE`, recorded the changed line, and
  paused. Its validator and diff proof passed; the disposable fixture was
  removed after inspection.
- Python syntax proof: unattempted because no Python runtime is installed in
  the environment; this is a tooling limitation, not a Python test failure.
- The new plan remains locally available but is covered by the intentional
  global `docs-harness/` ignore rule. Proposal: force-add only this plan (and
  future canonical resources) when the User explicitly requests Git
  persistence.
- The behavior reruns are accepted. The runner's filesystem isolation was not
  reliable, so a future tool-maintenance follow-up should use a verified
  isolated workspace before any non-disposable fresh experiment.
- Fresh rerun decision `keep` recorded; the plan is ready for the completed
  lifecycle route.

## Current Decision

Decision: keep.

Rationale: fresh agents exercised both the evidence-backed uncertain capture
path and the affected-domain stale/pause path with claim-matched proof. The
intervention is retained; unreliable runner isolation is recorded as an
environment risk with cleanup and is not evidence against the Harness rules.
