# Harness Index

`docs-harness/` is the Harness context workspace. This file is the navigation
hub: it routes the agent to canonical resources without copying their contents.
Start here after `AGENTS.md` and before reading other repository documentation.

## Session retrieval

Immediately after this INDEX, before task work or other repository
documentation, read and apply
[task authority](harness-constraints/0822-user-authority-operation-gate.md) and
[session role and judgment](harness-constraints/1120-session-role-and-judgment.md).
This is mandatory for every session, including delegated workers. If one cannot
be read, report the gap and pause work whose rules cannot be established.
Reload them after a workspace switch, loss of their context, or a User-reported
change to one.

At session start, run the read-only alignment check
`python -I .agents/skills/harness-check/scripts/harness_check.py --quick`
from the repository root and report its RESULT line and any drift rows:
resources with an ID that INDEX and the folder READMEs it links leave
unrouted, INDEX links whose target is missing, and folders missing from the
Folder Tree. Without Python 3 or a shell, compare docs-harness/ folder and
file names (templates/ excluded) with those routes by hand. Read PERSONA.md and use the single selected style, or Default when the
selection is empty or ambiguous. Apply persona to conversation only.

Then follow [layers/README.md](layers/README.md) to load any add-on prompt
layer matching the current session's exact resolved model, announcing each
loaded file's path to the User before applying it, and to apply every hook
whose activation checklist is checked.

When the session runs a Claude model or a Claude platform, read
[claude-instructions/README.md](claude-instructions/README.md) and every Markdown
file under `claude-instructions/`, after the layers step. Other sessions skip it.

When the session runs on an Antigravity (AGY) host, read
[agy-instructions/README.md](agy-instructions/README.md) and every Markdown file
under `agy-instructions/`, after the layers step. Other sessions skip it.

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
├── agy-instructions/
├── harness-constraints/
├── claude-instructions/
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
│   │   ├── 01-sample-ticket/
│   │   │   └── docs/
│   │   │       └── prd-research/
│   │   └── TBD-code-graph-pilot-ygz/
│   │       └── decision/
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
- [Task authority](harness-constraints/0822-user-authority-operation-gate.md) and
  [session role and judgment](harness-constraints/1120-session-role-and-judgment.md):
  mandatory at session start.
- [Work shape, proof and completion](harness-constraints/1120-work-shape-proof-completion.md):
  read before changing anything and before reporting a result.
- [PERSONA.md](PERSONA.md)
- [Ubiquitous language](UBIQUITOUS-LANGUAGES.md): lookup of the shared terms and shorthand the User,
  agents and the Harness use (for example HDA = Herdr desktop app); read when a User's word or
  abbreviation is not defined in a loaded document.
- [Self-review policy](harness-constraints/1120-work-shape-proof-completion.md): inspect
  affected routes, metadata, links, and diff; disclose unattempted proof.
- [Harness status check](../.agents/skills/harness-check/SKILL.md): follow it
  for every User request to check the Harness status or whether the repository
  meets the User's requirements.
- [Jev System One configuration manifest](JEV-AI.md): declarative manifest for
  project context, semantic scripts catalog, and dynamic criteria.
- [Herdr TUI orchestration](HERDR-TUI.md): read only when the User asks for the Herdr TUI, a
  Herdr pane or the `herdr` command; other requests skip it. When the User names only
  "Herdr", ask whether they mean the TUI or the desktop app before reading either.
- [Herdr desktop app and `hc` orchestration](HERDR-APP.md): read only when the User asks
  for the Herdr app, the desktop app or `hc`; other requests skip it.

## TAG: [IMPROVE_HARNESS]

Folder: [harness-improvements/](harness-improvements/)

Purpose: resources that improve the Harness repo or agent workflow.

Read when: the User intent changes Harness guidance, tooling, routing, or agent
workflow, or names an improvement record.

Skip when: the intent concerns only product behavior or unrelated domain work.

Resources:

- [Harness improvement guide and record list](harness-improvements/README.md):
  every improvement record (`#015` onward) with its ID and priority. Legacy
  improvement plans (`#002`–`#014`) are listed in
  [plans/completed/README.md](plans/completed/README.md).

## TAG: [CONSTRAINTS]

### harness-constraints/

Folder: [harness-constraints/](harness-constraints/)

Purpose: rules that constrain files, folders, or a specific task.

Read when: every session for task authority and session role, and when the intent
creates, edits, moves, or validates files/folders under a known constraint.

Skip when: never for those two; otherwise when no repository
or task constraint is relevant.

Resources:

- [Constraint guide](harness-constraints/README.md)
- [Risk and proposed response constraint](harness-constraints/0812-risk-proposal-suggestion-cross-link.md) — `#001_CONSTRAINTS_0812`, `PRIORITY: [MEDIUM]`
- [Task authority for local work and explicit external boundaries](harness-constraints/0822-user-authority-operation-gate.md) — `#009_CONSTRAINTS_0822`, `PRIORITY: [CRITIAL]`
- [Session role, evidence and judgment, and documentation ownership](harness-constraints/1120-session-role-and-judgment.md) — `#074_CONSTRAINTS_1120`, `PRIORITY: [MEDIUM]`
- [Work shape, proof and completion](harness-constraints/1120-work-shape-proof-completion.md) — `#075_CONSTRAINTS_1120`, `PRIORITY: [MEDIUM]`

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

- [Completed plan list](plans/completed/README.md): every completed plan,
  legacy improvement plans included, with its ID and priority.

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
files only when none matches the current session's identity. Every session
reads each hook's Activation section; a hook applies per its own checklist.

Resources:

- [Layer loading contract and model matching rule](layers/README.md)
- [Layer 1 folder](layers/layer-1/README.md) and its
  [model add-on folder](layers/layer-1/agents/README.md)
- [Layer 2 folder](layers/layer-2/README.md)
- [Hook mechanism and activation contract](layers/layer-2/hooks/README.md)

### agy-instructions/

Folder: [agy-instructions/](agy-instructions/)

Purpose: instructions written for working on Google Antigravity (AGY).

Read when: the session runs on an Antigravity host, at session start, after the
layers step.

Skip when: the session does not run on an Antigravity host.

Resources:

- [Antigravity instructions guide](agy-instructions/README.md)

### claude-instructions/

Folder: [claude-instructions/](claude-instructions/)

Purpose: instructions written for working with Claude.

Read when: the session runs a Claude model or a Claude platform, at session
start, after the layers step.

Skip when: the session runs neither a Claude model nor a Claude platform.

Resources:

- [Claude instructions guide](claude-instructions/README.md)

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
- [Folder README template](templates/folder-readme.md)

Templates do not receive resource IDs or date-prefixed filenames.

## Resource Routing Rules

Resource metadata and IDs are owned by [the template catalog](templates/README.md).
List each canonical resource once per applicable classification and lifecycle
section. Improvement records are listed in
[harness-improvements/README.md](harness-improvements/README.md) and completed
plans, legacy improvement plans included, in
[plans/completed/README.md](plans/completed/README.md); INDEX routes those two
lists and lists every other canonical resource itself. A link in two different
routes is intentional; duplicate entries in the same route are not. Every
resource entry carries its ID and current priority.
Ordinary tickets and supporting artifacts are reached through their owner.
