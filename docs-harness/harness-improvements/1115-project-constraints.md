# Harness Improvement Resource

ID: #057_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Load project constraints at every session start
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-constraints/README.md
- docs-harness/project-constraints/README.md
- docs-harness/project-constraints/1115-unit-test-authority.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- docs-harness/templates/constraint.md

## Objective

Create a project-constraints folder whose rules are read each session, beginning
with the User's unit-test authority constraint.

## Purposes

- [x] Give project-specific rules a discoverable home separate from Harness rules.
- [x] Prevent agents from writing unit tests without the User's authority.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at `f91a31f`, clean
worktree, one commit ahead of `origin/main`. There is no
`docs-harness/project-constraints/` folder or session-start route to it.
`AGENTS.md` authorizes routine focused tests as local verification; it does not
distinguish writing unit tests from running existing ones. The User explicitly
requested the new folder, session-wide retrieval, and the first constraint.
The Jev hook is disabled. The pre-existing unindexed `#012` plan is outside
this task.

## Proposed Improvement

Add one canonical project constraint, load project rules at every session start,
and reconcile the direct authority, routing and verification guidance. Treat
specific User authorization to write or update unit tests as sufficient for
that task; a generic implementation or verification request alone is not.
Running existing tests remains governed by the existing operation authority.

Hypothesis: a fresh agent retrieves the rule before task work and distinguishes
writing unit tests from other authorized verification. Contrary evidence would
be an agent that skips a rule, writes unit tests without specific authorization,
or treats running an existing test as writing one. INDEX and the project
constraint guide own routing and maintenance; revisit if a fresh session
cannot apply the rule or the User changes the desired policy.

## Scope

The new project-constraints folder and its initial rule, session retrieval,
direct authority/verification consumers, necessary hook retrieval exemption,
and this improvement record. Preserve user-owned raw requirements and
unrelated work. Do not stage, commit, push, or perform external operations.

## Progress

- 2026-11-15: Recorded the baseline and intended intervention before changing
  routing or policy.
- Created the project constraint guide and `#058_CONSTRAINTS_1115`, routed all
  Markdown rules for session-start retrieval, and reconciled the direct
  authority, workflow, README and dormant Jev-hook retrieval instructions.
- A fresh worker read the entry and project-constraint files, edited one
  fictional JSON fixture, checked its contents, and answered the three
  authority cases. The primary agent independently inspected the fixture and
  deleted its file; its empty operating-system temporary directory remains.

## Validation

Inspect affected routes, links, IDs, metadata, policy owners and final diff.
Exercise a fresh bounded session for session-start retrieval and the distinction
between unauthorized unit-test writing, explicit authorization, and running
existing tests. No unit tests are authorized by this improvement request.

Native inspection found 58 ID-bearing resources with unique numeric sequences,
an INDEX folder tree matching the filesystem, and 130 resolving local links
across ten affected documents, including all 109 local INDEX links. The new
resource metadata and trailing whitespace were checked, and `git diff --check`
passed. The unrelated `#012` route drift existed at baseline and remains
unchanged.

The fresh worker reported loading `AGENTS.md`, INDEX, the persona, layer and
hook guides, the project-constraint guide and `#058` before its assigned work.
It changed only `retry_limit` from 2 to 3 in a fictional JSON fixture, then
parsed and inspected the result. The primary agent confirmed the expected three
properties and that the fixture directory contained only that one file.
The worker correctly distinguished a general fix/verify request, an explicit
test request within scope, and an authorized run of existing tests. The latter
two are hypothetical authority judgments, not actual test execution or writing;
no unit tests were created or run. This bounded replay does not establish
effectiveness for every future agent or project.

## Risks

- A weak session-start pointer could leave a project rule unread. Mitigation:
  require discovery of every Markdown rule recursively and verify a fresh session.
- A broad test ban could prevent permitted verification. Mitigation: separate
  writing unit tests from running existing tests and other checks.
- The existing `#012` resource remains absent from INDEX. Proposed investigation:
  review its provenance and routing separately before changing either.
- An empty task-owned fixture directory remains in the operating-system temp
  folder. Mitigation: allow normal temporary-directory cleanup.

## Decision and Result

Decision: keep. The folder, initial active rule and session-start route are in
place; the native checks and bounded fresh replay support the intended behavior.
The replay covers one local fixture and simulated authority choices, not
production behavior or actual unit-test writing.
