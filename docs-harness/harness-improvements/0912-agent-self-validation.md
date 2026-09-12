# Harness Improvement Resource

ID: #017_IMPROVE_HARNESS_0912
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Replace repository validator scripts with agent self-validation
CREATED: 2026-09-12
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- README.md
- docs/WORKFLOWS.md
- docs/AI_PROBLEMS.md
- .agents/skills/domain-audit/SKILL.md
- .agents/skills/onboard-repository/SKILL.md
- .agents/skills/audit-onboarding-proposal/SKILL.md
- .harness-core/base/.agents/skills/onboard-repository/SKILL.md
- .harness-core/base/.agents/skills/audit-onboarding-proposal/SKILL.md
- docs-harness/plans/active/0906-behavior-parity-audit.md
- .gitignore

## Objective

Make the AI agent's evidence-backed inspection the default Harness validation
path, retire the repository-local `.agents/validators/` tree, and require
explicit User authority before creating or invoking a validation script for a
Harness check.

## Current State

- Repository: `D:/repos/base-harness-repo`, branch `main`.
- Baseline revision: `0ba9d2188729c4911ef8a16427645d5c41003ed3`.
- Baseline worktree: clean under normal Git status; no unrelated edits were
  present before this intervention.
- Baseline before intervention: `.agents/validators/` contained `README.md`,
  `sync-harness-index.js`, and `sync-harness-index.test.js`.
- Before intervention, `README.md`, `docs-harness/INDEX.md`, `.gitignore`, and
  several agent-facing or team-facing documents pointed to that tree or
  prescribed its scripts as a structural proof path.
- Active and completed plans retain validator paths and commands as historical
  evidence. Those records must remain understandable without making the old
  scripts a current dependency.

## Proposed Improvement

Delete `.agents/validators/`, remove its current routing and ignore exceptions,
and update the owning guidance and direct consumers to require manual
agent-led inspection of the affected tree, metadata, links, diff, and behavior.
State that creating or invoking a repository validation script needs explicit
User authority; ordinary Harness work reports any script proof as unattempted.
Keep historical evidence, but label references to the retired scripts as
historical rather than operational requirements.

## Scope

In scope:

- `.agents/validators/` and its current consumers.
- `AGENTS.md`, `docs-harness/INDEX.md`, `docs-harness/WORKFLOW.md`, the root
  `README.md`, and direct agent/team guidance that mandates the old validator.
- The INDEX entry for this improvement and its `.gitignore` exposure.
- A dated note in the active behavior-parity plan so its old validator evidence
  is not mistaken for current policy.

Out of scope:

- Product code, runtime behavior, external systems, commits, pushes, or other
  repository scripts that are not the retired `.agents/validators/` tree.
- Erasing historical plan/evidence prose that records checks performed before
  this policy change.
- Creating a replacement validation script without a later explicit User
  authorization.

## Progress

- 2026-09-12: Baseline captured and all direct references to the validator tree
  mapped. User authorized deletion and the manual-validation policy.
- 2026-09-12: Improvement record created before intervention edits.
- 2026-09-12: Deleted the three-file validator tree, removed its routing and
  ignore exceptions, and updated current policy owners and direct consumers.
- 2026-09-12: Manual reference scan found no live pointer to the retired tree;
  remaining mentions are labeled historical or describe this record.
- 2026-09-12: Fresh instruction replay remains pending.

## Validation

- Manual inspection confirmed that `.agents/validators/` and its three files are
  absent from the working tree.
- A repository-wide reference scan found no live operational pointer to the
  retired tree or `sync-harness-index`; remaining mentions are explicitly
  historical evidence or this record's scope/baseline.
- `docs-harness/INDEX.md` now routes this record and the manual self-validation
  policy; the changed owner files and referenced paths exist.
- `git diff --check` exited 0. Git emitted only its normal LF/CRLF conversion
  warnings for the touched files.
- No Harness validator script or replacement validation script was run or
  created.

Fresh replay is still required by `improve-harness`: a new agent session should
receive an equivalent request, choose manual self-validation, refuse to create
or invoke a validator script without User authority, and report the exact
manual evidence it inspected.

## Risks

- Manual inspection can miss a route or metadata inconsistency that a
  deterministic checker would have caught. Proposal: require an explicit
  self-review checklist covering tree shape, route links, IDs, metadata,
  affected behavior, and final diff; pause and ask for authority when a script
  would materially improve proof.
- Historical records may be mistaken for live instructions after deletion.
  Proposal: label old commands and paths as historical and remove them from
  current owner pointers and metadata references.
- A future task may need a script for high-volume or reproducible evidence.
  Proposal: obtain explicit User authority, record the scope and retention
  boundary, and keep the script task-local unless the User authorizes a
  repository capability.

## Decision and Result

Decision: pending fresh rerun. The requested implementation is bounded to the
retired validator tree and current guidance; effectiveness remains unverified
until the equivalent fresh agent scenario is exercised.
