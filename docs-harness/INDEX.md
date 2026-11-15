# Harness Index

`docs-harness/` is the Harness context workspace. This file is the navigation
hub: it routes the agent to canonical resources without copying their contents.
Start here after `AGENTS.md` and before reading other repository documentation.

## Session retrieval

Immediately after this INDEX, before task work or other repository
documentation, read and apply the entire [SESSION.md](SESSION.md) policy. This
is mandatory for every session, including delegated workers. If the policy
cannot be read, report the gap and pause work whose rules cannot be established.
Reload it after a workspace switch, loss of its context, or a User-reported
change to the policy.

At session start, without changing files, list the folder and file names under
docs-harness/ (templates/ excluded) and compare them with INDEX in both
directions: report every resource file with an ID that INDEX does not route,
every INDEX link whose target is missing, and every folder missing from the
Folder Tree. Read PERSONA.md and use the single selected style, or Default when the
selection is empty or ambiguous. Apply persona to conversation only.

Then follow [layers/README.md](layers/README.md) to load any add-on prompt
layer matching the current session's exact resolved model, announcing each
loaded file's path to the User before applying it, and to apply every hook
whose activation checklist is checked.

Before task work, read [project-constraints/README.md](project-constraints/README.md)
and every Markdown file recursively under `project-constraints/`, including unindexed
files; apply active constraints as the guide directs. This applies to every
session, including workers. Reload after a workspace switch, lost routing
context, or a User-reported change to a project constraint.

Discover current work by metadata, not by loading every body:

- plans/active/: ID, title, status, priority, references;
- tickets/active/: discover nested ticket.md files and read identity/status.

Read only other records relevant to the task and applicable critical constraints.
Retrieve completed history for a named request or dependency; read task-local
proposals with their ticket or plan.
Historical and pending experiment text does not override the current policy
owner. Read the recorded scope and decision before resuming an experiment.

For later prompts, use the already loaded INDEX while unchanged; reread it
after changes, a workspace switch, or a compaction that loses routing context.

## Folder Tree

```text
docs-harness/
├── harness-constraints/
├── domain/
├── harness-improvements/
├── layers/
│   ├── layer-1/
│   │   └── agents/
│   └── layer-2/
│       └── hooks/
├── onboarding/
├── plans/
│   ├── active/
│   └── completed/
├── project-constraints/
├── tickets/
│   ├── active/
│   └── completed/
└── templates/
    ├── {sample-big-ticket}/
    │   ├── {ticket-number}-{ticket-1}/
    │   └── {ticket-number}-{ticket-2}/
    ├── {service-name}/
    │   ├── data-flows/
    │   │   └── {data-flow-name}/
    │   └── schemas/
    └── {ticket-number}-{single-ticket}/
```

Filesystem folder paths are authoritative; order in this display is immaterial.
Keep every descendant folder represented, including template scaffolds.

## Routing and maintenance

Start from the folder and its Purpose, Read when, Skip when, and Resources.
Follow relevant references and code dependencies until evidence answers the
task. A missing route may be reported while following an explicitly named path
or the nearest relevant owner; it does not block safe read-only discovery.
A broad unrelated survey needs a separate scope. For a requested deep dive,
state the scope and report why each dependency expansion was necessary.

INDEX links to policy owners instead of repeating their contracts. Update the
tree and canonical routes in the same task when their structure, classification,
priority, or links change. Content-only edits need no routing rewrite.
In read-only work report drift without repairing it.

Before claiming routing consistency, the AI agent must inspect the relevant
folder tree, route metadata, links, IDs, domain state, and final diff and report
the evidence and any unattempted proof.

## WARNING: User-owned raw requirements

When the repository has `docs/raw-requirements/`, that folder is the User's
single source of truth for what they want from the repository and its Harness.
Read [its README](../docs/raw-requirements/README.md) when a task creates or
changes something a requirement there describes, or when the User asks whether
the repository meets their requirements. Do not create, edit, rename, move or
delete files there, even when a task asks to fix, update or improve; propose
the exact change in the reply and let the User edit the file. The only
exception is a User request that spells out the exact result (the text to
write, or the file to add, rename or delete). A mismatch found there does not
by itself authorize changing code.

## Root Routing

Folder: [docs-harness/](./)

Purpose: the top-level Harness context and routing boundary.

Read when: every User prompt, before selecting deeper context.

Skip when: never; this is the entry point.

Resources:

- [README.md](README.md)
- [INDEX.md](INDEX.md)
- [SESSION.md](SESSION.md): mandatory session role, task authority, judgment,
  documentation, and completion policy.
- [WORKFLOW.md](WORKFLOW.md)
- [PERSONA.md](PERSONA.md)
- [Self-review policy](SESSION.md#completion): inspect affected routes,
  metadata, links, and diff; disclose unattempted proof.
- [Historical Herdr worker catalog](HERDR-AGENTS.md): retained for past
  coordination evidence after removal of the coordination skills; consult only
  when investigating that history.
- [Jev System One configuration manifest](JEV-AI.md): declarative manifest for
  project context, semantic scripts catalog, and dynamic criteria.

## TAG: [IMPROVE_HARNESS]

Folder: [harness-improvements/](harness-improvements/)

Purpose: resources that improve the Harness repo or agent workflow.

Read when: the User intent changes Harness guidance, tooling, routing, or agent
workflow.

Skip when: the intent concerns only product behavior or unrelated domain work.

Resources:

- [Harness improvement guide](harness-improvements/README.md)

Legacy improvement plans (`#002`–`#014`) are routed in the `plans/completed/`
section below.

- [One record per improvement](harness-improvements/0906-per-improvement-records.md) — `#015_IMPROVE_HARNESS_0906`, `PRIORITY: [MEDIUM]`
- [Bale orchestration through independent Herdr agents](harness-improvements/0907-bale-herdr-orchestration.md) — `#016_IMPROVE_HARNESS_0907`, `PRIORITY: [MEDIUM]` — historical skill-creation record
- [Agent self-validation and validator retirement](harness-improvements/0912-agent-self-validation.md) — `#017_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [User-selected Herdr worker model catalog](harness-improvements/0912-herdr-agent-catalog.md) — `#018_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [Receipt-first Herdr observation with bounded transcript fallback](harness-improvements/0912-herdr-bounded-observation.md) — `#019_IMPROVE_HARNESS_0912`, `PRIORITY: [MEDIUM]`
- [Bale review gate for delegated code quality and resource efficiency](harness-improvements/0913-herdr-bale-code-review.md) — `#020_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [OpenCode Go worker model catalog](harness-improvements/0913-opencode-go-model-catalog.md) — `#021_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Windows OpenCode launch and lean Herdr dispatch](harness-improvements/0913-opencode-windows-launch-and-lean-herdr.md) — `#022_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Remove strict onboarding and audit skills](harness-improvements/0913-remove-strict-onboarding-skills.md) — `#023_IMPROVE_HARNESS_0913`, `PRIORITY: [MEDIUM]`
- [Keep Herdr coordination in the current Git checkout](harness-improvements/0919-herdr-shared-checkout.md) — `#024_IMPROVE_HARNESS_0919`, `PRIORITY: [MEDIUM]`
- [Preserve improvement purposes as a checklist](harness-improvements/0919-improvement-purpose-checklist.md) — `#025_IMPROVE_HARNESS_0919`, `PRIORITY: [MEDIUM]`
- [Claude Code capability routing skill and team catalog](harness-improvements/0921-utilizing-tools-claude-capability-catalog.md) — `#026_IMPROVE_HARNESS_0921`, `PRIORITY: [MEDIUM]`
- [Converge the utilizing-tools skills on the routing pattern](harness-improvements/0921-utilizing-tools-skill-parity.md) — `#027_IMPROVE_HARNESS_0921`, `PRIORITY: [MEDIUM]`
- [Tune tight-handoff wait/observation timeout guidance for OpenCode Go workers](harness-improvements/0922-opencode-go-tight-handoff-wait-timeout.md) — `#028_IMPROVE_HARNESS_0922`, `PRIORITY: [MEDIUM]`
- [Document Herdr `--kind agy` (Antigravity) done-signal unreliability as expected, not exceptional](harness-improvements/0922-agy-done-signal-reliability.md) — `#029_IMPROVE_HARNESS_0922`, `PRIORITY: [MEDIUM]`
- [Model-specific add-on prompt layers](harness-improvements/0926-model-family-layer-prompts.md) — `#030_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]`
- [Orca ADE documentation, capability routing skill, and Herdr coordination](harness-improvements/0926-utilizing-tools-orca-ade.md) — `#031_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]`
- [Pure Orca ADE multi-agent coordination skill and Claude sync](harness-improvements/0926-orca-ade-coordinate-agents.md) — `#032_IMPROVE_HARNESS_0926`, `PRIORITY: [MEDIUM]` — historical skill-creation record
- [TypeSafe Jev semantic primitives and native PowerShell helper with graceful fallback](harness-improvements/0927-typesafe-ai-skill-integration.md) — `#033_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]`
- [TypeSafe Jev best practices implementation for task authority, selective routing, ticket triage, and domain freshness](harness-improvements/0927-typesafe-best-practices-integration.md) — `#034_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]` — historical; helpers retired in #050 and #051
- [Dynamic Jev manifest and enhance-jev skill for project-specific customization](harness-improvements/0927-dynamic-jev-manifest-and-enhance-skill.md) — `#035_IMPROVE_HARNESS_0927`, `PRIORITY: [MEDIUM]` — skill removal recorded in #052
- [Layer-2 hooks mechanism with jev-hook pre-action Jev gate](harness-improvements/0930-layer-2-hooks-and-jev-gate.md) — `#036_IMPROVE_HARNESS_0930`, `PRIORITY: [MEDIUM]`
- [Retire the missing #012 plan route from INDEX](harness-improvements/1003-retire-missing-012-plan-route.md) — `#037_IMPROVE_HARNESS_1003`, `PRIORITY: [NORMAL]`
- [User-invoked init-harness-repo skill for scaffolding a minimal Harness](harness-improvements/1003-init-harness-repo-skill.md) — `#038_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Correctness fixes from the 2026-10-03 optimization review (group A)](harness-improvements/1003-optimization-review-correctness-fixes.md) — `#039_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Record metadata cleanup from the 2026-10-03 optimization review (group E)](harness-improvements/1003-record-metadata-cleanup.md) — `#040_IMPROVE_HARNESS_1003`, `PRIORITY: [NORMAL]`
- [Apply the User's group D policy decisions from the 2026-10-03 optimization review](harness-improvements/1003-group-d-policy-decisions.md) — `#041_IMPROVE_HARNESS_1003`, `PRIORITY: [MEDIUM]`
- [Apply the User's group B decisions to reduce always-loaded Harness context](harness-improvements/1005-group-b-context-load-reduction.md) — `#042_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Apply the User's group C decisions to remove duplicated on-demand guidance](harness-improvements/1005-group-c-deduplication.md) — `#043_IMPROVE_HARNESS_1005`, `PRIORITY: [NORMAL]`
- [Make the shell gate always consult Jev and apply the User's Jev guidance decisions](harness-improvements/1005-gate-and-jev-decisions.md) — `#044_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]` — historical gate behavior superseded in #050
- [Coordinate agents on the current branch without Git worktrees, for Herdr and Orca](harness-improvements/1005-coordination-without-worktrees.md) — `#045_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Apply the User's repository, record and template decisions from the optimization review](harness-improvements/1005-repo-and-record-decisions.md) — `#046_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [User-owned raw requirements folder with an INDEX warning](harness-improvements/1005-raw-requirements-source.md) — `#047_IMPROVE_HARNESS_1005`, `PRIORITY: [MEDIUM]`
- [Remove the Herdr and Orca ADE coordination skills](harness-improvements/1031-remove-coordination-skills.md) — `#048_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Improve TypeSafe Jev integration reliability](harness-improvements/1031-jev-integration-reliability.md) — `#049_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]` — historical helper coverage superseded in part by #050 and #051
- [Retire three Jev helper scripts](harness-improvements/1031-retire-jev-helpers.md) — `#050_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]` — retained router subsequently retired in #051
- [Retire the Jev skill router](harness-improvements/1031-retire-jev-skill-router.md) — `#051_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Remove the enhance-jev skill](harness-improvements/1031-remove-enhance-jev.md) — `#052_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Make Codex capability discovery work across sessions](harness-improvements/1031-codex-capability-discovery.md) — `#053_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Explain onboarding E2E flows one step at a time](harness-improvements/1031-onboarding-step-flows.md) — `#054_IMPROVE_HARNESS_1031`, `PRIORITY: [MEDIUM]`
- [Keep decision history inside each ticket](harness-improvements/1114-ticket-decision-history.md) — `#055_IMPROVE_HARNESS_1114`, `PRIORITY: [MEDIUM]`
- [Remove the product, risks and proposals folders](harness-improvements/1114-remove-product-risk-proposal-folders.md) — `#056_IMPROVE_HARNESS_1114`, `PRIORITY: [MEDIUM]`
- [Load project constraints at every session start](harness-improvements/1115-project-constraints.md) — `#057_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Route session policy through the Harness index](harness-improvements/1115-session-policy-routing.md) — `#059_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Name onboarding E2E and activity step files](harness-improvements/1115-onboarding-e2e-activity-files.md) — `#060_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`
- [Document prerequisite data in onboarding E2E overviews](harness-improvements/1115-onboarding-e2e-prerequisites.md) — `#061_IMPROVE_HARNESS_1115`, `PRIORITY: [MEDIUM]`

Coordination-skill references in earlier records are historical, including
records with a pending experiment status. Their deleted paths remain available
at revision `6b1bd92`; they are not current skill entry points.

## TAG: [CONSTRAINTS]

### harness-constraints/

Folder: [harness-constraints/](harness-constraints/)

Purpose: rules that constrain files, folders, or a specific task.

Read when: the intent creates, edits, moves, or validates files/folders under a
known constraint.

Skip when: no repository or task constraint is relevant.

Resources:

- [Constraint guide](harness-constraints/README.md)
- [Risk and proposed response constraint](harness-constraints/0812-risk-proposal-suggestion-cross-link.md) — `#001_CONSTRAINTS_0812`, `PRIORITY: [MEDIUM]`
- [Task authority for local work and explicit external boundaries](harness-constraints/0822-user-authority-operation-gate.md) — `#009_CONSTRAINTS_0822`, `PRIORITY: [CRITIAL]`

### project-constraints/

Folder: [project-constraints/](project-constraints/)

Purpose: User-authorized constraints on work in the project using this Harness.

Read when: every session, before task work, following the session retrieval rule.

Skip when: never; read all Markdown files, then apply active constraints.

Resources:

- [Project constraint guide](project-constraints/README.md)
- [User authority for writing unit tests](project-constraints/1115-unit-test-authority.md) — `#058_CONSTRAINTS_1115`, `PRIORITY: [MEDIUM]`

## TAG: [DOMAIN]

Folder: [domain/](domain/)

Purpose: project/domain knowledge marked as confirmed or uncertain. Canonical
resources live in date-prefixed folders as
`domain/<MMDD>-<lowercase-kebab-case-name>/README.md`; the domain README owns
the capture and freshness contract.

Read when: the intent depends on project vocabulary, domain behavior, or
User-confirmed context.

Skip when: the task is independent of project/domain knowledge.

Resources:

- [Domain capture and freshness contract](domain/README.md)

### [CONFIRMED]

Resources:

No confirmed domain resources are indexed yet.

### [UNCERTAIN]

Resources:

No uncertain domain resources are indexed yet.

## Supporting Folders

### plans/

Folder: [plans/](plans/)

Purpose: durable execution-plan resources and lifecycle routing.

Read when: the task spans sessions, contributors, dependencies, recovery, or
other durable planning needs.

Skip when: the task is bounded and needs no durable recovery context.

Resources:

- [Durable plan lifecycle](plans/README.md)

See the dedicated `plans/active/` and `plans/completed/` routing sections
below; do not duplicate their resource links here.

### plans/active/

Folder: [plans/active/](plans/active/)

Purpose: plans for work currently in progress.

Read when: resuming or coordinating an unfinished durable task.

Skip when: no active plan is related to the current intent.

Resources:

- [Active plans folder guide](plans/active/README.md)

No active plans are indexed.

### plans/completed/

Folder: [plans/completed/](plans/completed/)

Purpose: completed execution history that remains useful context.

Read when: prior execution history is directly relevant to the current intent.

Skip when: the task has no dependency on completed work.

Resources:

- [Goal-griller specialist routing improvement](plans/completed/0812-harness-improvement-goal-routing.md) — `#002_IMPROVE_HARNESS_0812`, `PRIORITY: [MEDIUM]`
- [Writing-for-agents routing improvement](plans/completed/0815-writing-for-agents-routing.md) — `#003_IMPROVE_HARNESS_0815`, `PRIORITY: [MEDIUM]`
- [Ticket lifecycle improvement](plans/completed/0815-ticket-lifecycle-routing.md) — `#004_IMPROVE_HARNESS_0815`, `PRIORITY: [MEDIUM]`
- [Filesystem and INDEX synchronization check at session start](plans/completed/0816-filesystem-index-sync-rule.md) — `#005_IMPROVE_HARNESS_0816`, `PRIORITY: [MEDIUM]`
- [Persona response style configuration and session start routing](plans/completed/0816-persona-response-style-routing.md) — `#006_IMPROVE_HARNESS_0816`, `PRIORITY: [MEDIUM]`
- [Onboarding skill and flow-based workspace routing](plans/completed/0816-onboarding-skill-folder-routing.md) — `#007_IMPROVE_HARNESS_0816`, `PRIORITY: [MEDIUM]`
- [User authority operation gate](plans/completed/0822-user-authority-operation-gate.md) — `#008_IMPROVE_HARNESS_0822`, `PRIORITY: [MEDIUM]`
- [Ticket evidence workspace templates](plans/completed/0822-ticket-evidence-workspace.md) — `#010_IMPROVE_HARNESS_0822`, `PRIORITY: [MEDIUM]`
- [Service E2E domain-flow template improvement](plans/completed/0822-domain-e2e-flow-template.md) — `#011_IMPROVE_HARNESS_0822`, `PRIORITY: [MEDIUM]`
- [Task authority and policy consistency](plans/completed/0906-task-authority-and-policy-consistency.md) — `#013_IMPROVE_HARNESS_0906`, `PRIORITY: [MEDIUM]`
- [Behavior parity audit and regression repair](plans/completed/0906-behavior-parity-audit.md) — `#014_IMPROVE_HARNESS_0906`, `PRIORITY: [MEDIUM]`

### tickets/

Folder: [tickets/](tickets/)

Purpose: ticket intake, working records, attachments, and generated resolution
artifacts managed by `$ticket-solving`, with active and completed lifecycle
folders.

Read when: the User invokes `$ticket-solving` or supplies a ticket source for
intake, organization, or resolution. Read `active/` by default; read
`completed/` only for explicit history or dependency context.

Skip when: the intent does not concern ticket work.

Resources:

- [Ticket layout and lifecycle contract](tickets/README.md)

See the dedicated `tickets/active/` and `tickets/completed/` routing sections
below; ticket templates are listed under `templates/`.

### tickets/active/

Folder: [tickets/active/](tickets/active/)

Purpose: current ticket intake, investigation, implementation, validation, and
User review.

Read when: creating, resuming, or solving a ticket.

Skip when: the current intent has no ticket work.

Resources:

- [Active ticket workspace guide](tickets/active/README.md)

### tickets/completed/

Folder: [tickets/completed/](tickets/completed/)

Purpose: User-authorized completed ticket history.

Read when: the User names completed history or the current ticket has an
explicit dependency on it.

Skip when: performing default ticket intake or solving current work without a
history dependency.

Resources:

- [Completed ticket workspace guide](tickets/completed/README.md)

### layers/

Folder: [layers/](layers/)

Purpose: model-specific add-on prompt layers that extend the current
session's instructions based on the exact AI model it is running as.

Read when: every session, at the same session-start point PERSONA.md is read,
to load any add-on layer matching the current session's exact resolved
model.

Skip when: never skip the check itself; skip loading a layer's `agents/`
files only when none matches the current session's identity. Hooks are read
in every session and apply per their own activation checklist.

Resources:

- [Layer loading contract and model matching rule](layers/README.md)
- [Hook mechanism and activation contract](layers/layer-2/hooks/README.md)

### onboarding/

Folder: [onboarding/](onboarding/)

Purpose: brownfield data and business flow investigation workspaces managed by
`$onboarding`, used to discover, map, and synthesize persistent domain knowledge.

Read when: the User invokes `$onboarding` or a task targets a specific isolated
flow workspace (e.g. `docs-harness/onboarding/<target-flow>/`).

Skip when: the intent does not require onboarding context or concerns unrelated
bounded work. Do not scan or load the entire parent directory at once.

Resources:

- [Onboarding workspace guide](onboarding/README.md)

### templates/

Folder: [templates/](templates/)

Purpose: stable templates for canonical resources and task-local artifacts.

The folder-layout examples under `templates/` are scaffolding only and are not
active ticket records.

Read when: creating a new resource in a supported resource folder.

Skip when: no new resource is being created.

Resources:

- [Template catalog, resource IDs and metadata](templates/README.md)
- [Activity diagram template](templates/activity-diagram.md)
- [Harness improvement template](templates/harness-improvement.md)
- [Constraint template](templates/constraint.md)
- [Ticket decision template](templates/decision.md)
- [Domain template](templates/domain.md)
- [Domain entity/schema template](templates/domain-entity.md)
- [Legacy execution-plan pointer](templates/exec-plan.md)
- [Inline risk template](templates/risk.md)
- [Inline proposal template](templates/proposal.md)
- [Canonical plan template](templates/plan.md)
- [Ticket template](templates/ticket.md)
- [API inventory template](templates/apis.md)
- [Schema inventory template](templates/entities.md)
- [Ticket docs manifest template](templates/ticket-docs-README.md)

Templates do not receive resource IDs or date-prefixed filenames.

## Resource Routing Rules

Resource metadata and IDs are owned by [the template catalog](templates/README.md).
List each canonical resource once per applicable classification and lifecycle
section; legacy improvement plans under plans/ are listed only in their
lifecycle section. A link in two different routes is intentional; duplicate
entries in the same route are not. Every resource entry carries its ID and current priority.
Ordinary tickets and supporting artifacts are reached through their owner.
