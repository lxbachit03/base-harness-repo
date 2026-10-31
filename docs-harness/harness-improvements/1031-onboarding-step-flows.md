# Harness Improvement Resource

ID: #054_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Explain onboarding E2E flows one step at a time
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- .agents/skills/onboarding/SKILL.md
- .claude/skills/onboarding/SKILL.md
- docs-harness/onboarding/README.md
- docs-harness/templates/activity-diagram.md
- docs-harness/domain/README.md
- docs-harness/INDEX.md

## Objective

Make onboarding produce a source-backed, beginner-readable E2E walkthrough
with a separate Markdown file for each step, including its activity diagram,
expected API response, and expected database record or explicit uncertainty.

## Purposes

- [x] Help a reader unfamiliar with a flow understand each step in order.
- [x] Connect each step's expected responses and data state to evidence.

## Current State

Baseline: `D:/repos/base-harness-repo`, `main` at `ba9fcc8`, clean worktree.
The onboarding skill and its Claude mirror match. The workspace guide permits a
compact trace or five overall E2E artifacts but has no ordered per-step file
contract. The User requested that contract and asked for Jev and prompt-leverage
to select skills and prepare the implementation prompt.

The existing unindexed `#012` completed plan predates this task and is outside
scope. The Jev hook is disabled. A direct requested Jev consult returned model
`jev-1.14.0`; onboarding was the named target, while improve-harness and
writing-for-agents apply to the change and prompt-leverage prepares the prompt.

## Proposed Improvement

Put the per-step artifact contract in the onboarding workspace guide and point
both onboarding skill copies to it. Hypothesis: a fresh agent can trace a named
flow into ordered, linked step files with source-backed expected response and
database information, including `Not applicable` and `Unverified` cases.
Contrary evidence is a missing step, an invented contract, a broken link, or an
unexplained expected outcome. The workspace guide owns this contract; revisit it
if fresh authoring shows it obscures the flow or creates unsupported claims.

## Scope

The two onboarding skill copies, onboarding workspace guide, this record, and
its INDEX route. Preserve existing unrelated resources, user-owned raw
requirements, domain policies, and service-flow templates. This task does not
onboard a real flow or query a live API or database.

## Progress

- 2026-10-31: Captured baseline, inspected the skill and workspace owners, and
  consulted Jev. Created this record before changing the guidance.
- Updated the workspace contract and both onboarding skill copies. In an
  initial fresh, read-only replay over a synthetic create-order excerpt, the
  worker found the revised guidance and produced an ordered overview and two
  step documents with diagrams and response/data sections. It inferred that an
  unspecified storage target was a table and proposed a domain capture from
  example-only evidence. Clarified storage-type/commit uncertainty and kept
  synthetic examples out of real-project domain facts before rerunning.
- A second fresh worker used the revised guidance to onboard a fictional
  create-order application in a disposable copy of the repository. It created an
  E2E overview, three ordered step files, supporting evidence, and an UNCERTAIN
  domain explicitly labeled fictional. The storage type and committed state
  remained unverified. No live system was contacted, and no repeated question
  or source change was reported.
- Before committing, the fixture path was checked again and was absent. Who
  removed it and how were not established.

## Validation

Native inspection: the skill copies have identical SHA-256 hashes; the new
record and its INDEX route have matching ID and priority; all 110 local INDEX
links resolve, folder-tree entries match, and resource ID sequences are unique.
The pre-existing unindexed `#012` plan remains outside this task. `git diff
--check` passed with line-ending warnings. The real domain tree is unchanged.

Fresh behavioral replay: the second worker wrote three ordered step files in a
synthetic workspace. Each included a Mermaid diagram, API response, database
record section, citations, and applicable uncertainty markers; the overview
linked all three. Independent inspection found all 148 checked local links in
the generated overview, steps, example domain and INDEX resolved. The fixture
domain was explicitly synthetic and UNCERTAIN. This exercises one fictional
case without establishing live API, database, or general production behavior.

## Risks

- Per-step detail could imply that inferred API responses, storage types, or
  database values were observed. Mitigation: require evidence labels and retain
  unknowns, including the difference between a write call and a committed row.
- A step may have no API response or database interaction. Mitigation: allow
  evidence-backed `Not applicable` rather than inventing either outcome.
- A synthetic demonstration could be mistaken for real domain knowledge.
  Mitigation: label it as an example and do not promote it as a project fact.
- Automatic approval review initially blocked recursive cleanup of the
  task-owned `.onboarding-replay-temp/` fixture. Mitigation at the time: report
  its exact path to the User without using a workaround. A later pre-commit
  check found the path absent.

## Decision and Result

Decision: keep. The requested onboarding guidance is implemented, mirrored,
and exercised in the bounded fresh scenario described above. Effectiveness on a
real business flow and live service behavior remain untested. The verified
task-owned fixture was later absent at the pre-commit check. Automatic approval
review had returned `blocked by policy` for the original cleanup attempt; the
actor and method of its eventual removal are unknown.
