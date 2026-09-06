# Harness Improvement Resource

ID: #013_IMPROVE_HARNESS_0906
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Consolidate task authority and proportional Harness workflows
CREATED: 2026-09-06
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/WORKFLOW.md
- docs-harness/INDEX.md
- docs-harness/domain/README.md
- docs-harness/tickets/README.md
- .agents/skills/improve-harness/SKILL.md
- .agents/validators/sync-harness-index.js

## Objective

Make the accepted rules consistent: preserve authority across a task, include
routine local verification with implementation, retrieve relevant context,
and keep domain/ticket maintenance proportional and evidence-backed.

## Current State

Baseline: D:/repos/base-harness-repo, main,
7cf83c11a714954af68d27d90aeff511636c2a5c; clean worktree, ahead of the locally
recorded origin/main by two commits. The previous staged domain changes are
already in this commit. No commit, push, external write, or installation is
part of this intervention.

The preceding conversation inspected the rules and found conflicting domain
capture and schema gates, two plan templates, unconditional ticket status
repair, broad session context loading, and a validator that passed a duplicate
Resources block and incomplete folder tree. The User then explicitly asked
to implement those recommendations, including repository skills as needed.
This accepted review is policy authority; it is not evidence of measured
future-agent speed or fewer interruptions.

## Proposed Improvement

If task authority is defined once in AGENTS.md and workflow-specific contracts
have one owner, then an agent can carry out an authorized local change and its
proof without repeat permission questions while keeping external actions and
product policy subject to the User's scope. Relevance-based retrieval and
optional ticket artifacts reduce unnecessary context and files.

Evidence against this: a read-only scenario writes state, an implementation
scenario still asks for routine local validation, a stale domain blocks
unrelated work, or a structural validator accepts a known counterexample.
Owner: Harness maintainers. Revise if those scenarios fail; remove redundant
instructions if they add no observable value.

## Scope

AGENTS.md, root README, current docs-harness guides/templates/INDEX, affected
repository skills, local Harness validators and their regression checks, and
exact .gitignore exceptions exposing this plan and its regression source.
Keep historical records, resource IDs, existing ticket/domain artifacts, and
consumer-owned documents. Old experiments retain their evidence and pending
status; a supersession pointer may identify replaced policy, not claim a rerun.

## Approach and Progress

- [x] Inspect current authority, skill mechanics, baseline, and conflicts.
- [x] Consolidate authority, retrieval, plan/resource identity, and workflow owners.
- [x] Align affected skills and templates; introduce optional ticket artifacts.
- [x] Strengthen structural validation with executable counterexamples.
- [x] Run native checks and a fresh instruction scenario review.
- [x] Record final evidence, limitations, and before/after comparison.

## Validation

- Node v24.18.0 syntax and working INDEX checks: pass.
- Node regression suite: 29/29 pass. Covers the previously missed tree/section
  cases, links, canonical routes, IDs, metadata, domain state, reciprocal risk
  references, safe/idempotent fix, read-only checks, and concurrent snapshot drift.
- Git Bash sync and risk/proposal wrappers: pass. Risk wrapper refuses --fix.
- git diff --check: pass; the index has no staged changes.
- Python wrapper execution: unattempted because the installed python commands
  resolve to the Windows Store stub. They are compatibility launchers for the
  tested Node engine; no Python runtime was installed.
- Skill metadata: 9/9 targeted Node checks pass for the inspected flat
  frontmatter, names, descriptions, scaffold markers, and unchanged invocation
  settings. skill-creator's Python quick_validate.py is unattempted for the same
  runtime limitation; this fallback is not a general YAML/runtime certification.
  Existing runtime-specific disable-model-invocation fields remain unchanged.
- Domain impact: no canonical domain resources exist; no source claims required
  a freshness update for the validator logic changes.
- Fresh /root/authority_replay session read current instructions, repaired an
  isolated total(subtotal, delivery) fixture from subtraction to addition, and
  ran its adjacent Node acceptance checks without requesting extra permission.
  Parent observed the initial failure (7 instead of 13) and verified final
  results 13, 10, and 3. Both task-owned fixture files were removed after proof.
- Independent /root/policy_review review resumed successfully after a usage-limit
  interruption. It found optional-manifest links, unqualified workspace pointers,
  and an overbroad authority paraphrase; those current consumers were corrected.
  Its bounded follow-up recheck confirmed all three findings resolved.
  Six read-only scenarios matched the intended contract: inspection cannot
  normalize a completed ticket; local isolated proof is authorized; follow-up
  status preserves prior task scope; shared staging writes need specific authority;
  unrelated work continues past stale domain claims; tiny inline intake needs
  only ticket.md. These are instruction decisions, not executions of external
  systems or exhaustive ticket workflows.
- Structural checks and one local replay do not measure production productivity,
  exhaustive schema tracing, long-running work, or external-system behavior.

## Risks and Recovery

- Broader implied local authority might be read as permission for external
  writes. Proposal implemented in this task: define the external and destructive
  boundary explicitly and test representative scenarios.
- Contract simplification may strand existing documents. Proposal: preserve
  compatibility pointers, IDs, historical records, and existing artifacts.
- Validator duplication can drift. Proposal: keep one executable check engine
  with documented compatibility entry points and negative regression cases.
- Recovery: review the diff against the baseline and selectively reverse this
  task's hunks if required; preserve any concurrent User changes.

## Result

Implementation completed on 2026-09-06. Decision: keep for the bounded task
authority and policy-consistency outcome demonstrated by native checks,
negative regression cases, one isolated execution replay, and independent
scenario review. Production productivity and token savings remain unmeasured.

| Boundary | Previous content | Current contract and expected effect |
| --- | --- | --- |
| Local authority | Per-command/current-message approval gate | Task-scoped edits and routine proof; fewer redundant approval requests in the tested replay |
| Policy ownership | Repeated rules across entrypoint, guides, and skills | One owner per contract, with direct consumers linked to it |
| Context retrieval | Load all active bodies and repeatedly read INDEX | Metadata discovery and relevant retrieval; less unnecessary context expected |
| Plans and IDs | Two plan templates and unclear supporting-resource identity | One plan template, immutable creation identity, collision checks |
| Domain and tickets | Broad revalidation and obligatory artifacts | Affected-claim checks and evidence-proportional artifacts; no invented confirmation |
| Structural proof | Missed folder/Resources counterexamples and duplicated engines | One Node engine, conservative fix planning, and 29 regression cases |

Nine repository skills were aligned without reinstalling global skills or
changing invocation settings. Existing experiment IDs, creation dates, and
pending historical reruns were preserved. No commit or push was performed.

For broader effectiveness evidence, replay a representative real ticket and
domain change in a separately scoped task; use a working Python runtime to
verify compatibility launchers and the stock skill checker when available.
