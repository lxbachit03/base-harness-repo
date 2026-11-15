# Harness Improvement Resource

ID: #061_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Document prerequisite data in onboarding E2E overviews
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- .agents/skills/onboarding/SKILL.md
- .claude/skills/onboarding/SKILL.md
- docs-harness/onboarding/README.md
- docs-harness/harness-improvements/1115-onboarding-e2e-activity-files.md
- docs-harness/INDEX.md

## Objective

Require each onboarding E2E overview to identify the data that must be prepared
before executing the flow.

## Purposes

- [x] Help readers prepare the inputs and existing data needed for the E2E flow.
- [x] Keep prerequisite claims traceable and distinguish unknowns from facts.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at `02758ac`, two commits
ahead of `origin/main`. Completed improvement `#060` is uncommitted in the two
onboarding skill copies, workspace guide, INDEX and its own record. Preserve
that work. The guide covers prerequisites for individual steps, but does not
require a prerequisite-data section in the separate E2E overview. The User
requested that section. The Jev hook is disabled and the unrelated `#012`
INDEX drift predates this task.

## Proposed Improvement

Make `## Prerequisite` mandatory in `e2e-<flow-name>.md`. Describe required
input and pre-existing data, states and relationships, scenario applicability,
and supporting evidence; mark missing information as unverified and avoid
inventing records or executing preparation steps without task authority.

Hypothesis: a fresh agent can identify source-backed starting data without
mistaking records produced during the flow for prerequisites. Contrary evidence
includes missing initial data, invented values, unmarked unknowns, or execution
of unauthorized setup. The onboarding workspace guide owns the section; revisit
it if a fresh scenario does not support the intended distinction.

## Scope

Both onboarding skill copies, the onboarding workspace guide, INDEX and this
record. Preserve the `#060` layout, its record, existing work, and user-owned
raw requirements. No real onboarding, live service or database access, unit-test
writing, staging, commit, or push is authorized by this task.

## Progress

- 2026-11-15: Recorded the baseline and intended change before editing the
  skill, guide, or routing.
- Added the E2E prerequisite-data section to the workspace guide and both
  onboarding skill copies. The copies match and the `#060` record remains
  byte-identical to its baseline. A bounded fictional replay is pending.
- The initial fictional prerequisite draft identified the required inputs and
  lookup conditions, but described lookup results as pre-existing records
  without proof and implied that an order could not already exist. Clarified
  both distinctions in the guide and requested a focused rerun of those claims.
- The worker reloaded the guide and corrected the fictional E2E file. A fresh
  read-only worker then independently identified the input and lookup conditions,
  marked missing preparation evidence `Unverified`, and distinguished the
  order produced by the flow. Its initial example of a wholly inapplicable
  prerequisite section considered only pre-existing records; the guide was
  clarified to include input data, and the affected case was rerun correctly.
- Removed both task-owned fixture files after review; empty temporary
  directories remain in the operating-system temp folder.

## Validation

Inspect the changed guidance, previous work, skill mirrors, INDEX tree, IDs,
links, metadata and final diff. Use a fresh worker on a fictional flow to
document an E2E prerequisite section, including required initial data, an
unknown, and an outcome created by the flow rather than pre-existing data.

Native review: both skill copies match by SHA-256, the `#060` record
is byte-identical to baseline, 61 resource ID sequences are unique, the INDEX
folder tree matches disk, and 114 local links across six affected documents
resolve. `git diff --check` passed with line-ending warnings. The pre-existing
`#012` routing drift remains outside scope.

Fresh behavioral evidence: a worker added `## Prerequisite` to a fictional E2E
overview, preserving its existing marker. After feedback it documented truthy
`customer_id` and `product_sku` inputs, source-backed customer and product
lookup-result conditions, and a truthy `active` condition without asserting
persisted records. It marked unknown values, storage and preparation methods
`Unverified`, and treated the constructed order as output rather than required
starting data. Independent inspection found one prerequisite heading, seven
source references within the fixture's line range, and illustrative values
explicitly labeled. A separate fresh worker reproduced the conditions from the
source and, after a guide clarification, correctly distinguished a flow with
required inputs from a wholly `Not applicable` prerequisite section.

The replay was limited to fictional source and an existing E2E file; no real
flow, live API or database, seed operation, or unit test was used. This does not
establish prerequisite completeness for every project or runtime.

## Risks

- A required starting record may be mistaken for an output produced by the
  flow. Mitigation: trace ordering and identify data needed before entry.
- A lookup result could be misrepresented as a persisted record, or a new
  object as a ban on existing data. Mitigation: state the evidenced lookup
  condition and leave storage and unsupported exclusions unverified.
- A suggested preparation action may be mistaken for authorization to access
  or modify real data. Mitigation: document evidence and authority boundaries.
- A required field, state or preparation method may be unsupported by sources.
  Mitigation: use `Unverified` and identify the next investigation.
- A flow with no pre-existing records could still need input data. Mitigation:
  reserve section-wide `Not applicable` for a scope requiring neither.
- The pre-existing `#012` plan is not routed in INDEX. Proposed follow-up:
  review its provenance before deciding whether to add a route.
- Empty task-owned fixture directories remain in the operating-system temp
  folder. Mitigation: allow normal temporary-directory cleanup.

## Decision and Result

Decision: keep. The prerequisite section and its evidence boundaries are in
the onboarding contract, and the bounded fresh replay passed after the observed
ambiguities were clarified. The earlier `#060` work is preserved.
