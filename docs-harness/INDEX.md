# Harness Index

`docs-harness/` is the Harness context workspace. This file is the navigation
hub: it routes the agent to canonical resources without copying their contents.
Start here after `AGENTS.md` and before reading other repository documentation.

## Folder Tree

```text
docs-harness/
├── constraints/
├── domain/
├── harness-improvements/
├── plans/
│   ├── active/
│   └── completed/
├── proposals/
├── risks/
└── templates/
```

The filesystem is authoritative for this tree. Update this block when a folder
is created, moved, renamed, or deleted.

## Routing Modes

### Top-Down (Default)

Start from this tree, select a folder from the User intent, classification, and
priority, read its routing metadata, and follow only the relevant `Resources`
links. Read `docs/WORKFLOW.md`, product docs, code, or validation files only
after the relevant Harness context is selected.

### Bottom-Up (Explicit Deep Dive Only)

Use Bottom-Up only when the User explicitly requests `deep dive`, `tìm hiểu
sâu`, `phân tích chuyên sâu`, `đọc sâu`, `investigate thoroughly`, or `audit
comprehensively`. Begin from the Top-Down-routed folder/resource, then expand
only through canonical links, `REFERENCES`, relevant dependencies, and related
child resources. Do not scan unrelated folders.

Before expanding, state the deep-dive scope. Stop when the User intent has
enough evidence or no related dependency remains, then report the paths read
and why each expansion was needed.

## Root Routing

Folder: [docs-harness/](./)

Purpose: the top-level Harness context and routing boundary.

Read when: every User prompt, before selecting deeper context.

Skip when: never; this is the entry point.

Resources:

- [INDEX.md](INDEX.md)

## TAG: [IMPROVE_HARNESS]

Folder: [harness-improvements/](harness-improvements/)

Purpose: resources that improve the Harness repo or agent workflow.

Read when: the User intent changes Harness guidance, tooling, routing, or agent
workflow.

Skip when: the intent concerns only product behavior or unrelated domain work.

Resources:

No canonical resources are indexed yet.

## TAG: [CONSTRAINTS]

Folder: [constraints/](constraints/)

Purpose: rules that constrain files, folders, or a specific task.

Read when: the intent creates, edits, moves, or validates files/folders under a
known constraint.

Skip when: no repository or task constraint is relevant.

Resources:

No canonical resources are indexed yet.

## TAG: [DOMAIN]

Folder: [domain/](domain/)

Purpose: project/domain knowledge marked as confirmed or uncertain.

Read when: the intent depends on project vocabulary, domain behavior, or
User-confirmed context.

Skip when: the task is independent of project/domain knowledge.

Resources:

### [CONFIRMED]

No confirmed domain resources are indexed yet.

### [UNCERTAIN]

No uncertain domain resources are indexed yet.

## TAG: [RISK]

Folder: [risks/](risks/)

Purpose: security, performance, and memory-leak risk records.

Read when: the intent could introduce, assess, mitigate, or validate one of
those risks.

Skip when: no security, performance, or memory-leak concern is in scope.

Resources:

No risk resources are indexed yet.

## Supporting Folders

### plans/

Folder: [plans/](plans/)

Purpose: durable execution-plan resources and lifecycle routing.

Read when: the task spans sessions, contributors, dependencies, recovery, or
other durable planning needs.

Skip when: the task is bounded and needs no durable recovery context.

Resources:

See the dedicated `plans/active/` and `plans/completed/` routing sections
below; do not duplicate their resource links here.

### plans/active/

Folder: [plans/active/](plans/active/)

Purpose: plans for work currently in progress.

Read when: resuming or coordinating an unfinished durable task.

Skip when: no active plan is related to the current intent.

Resources:

No active plan resources are indexed yet.

### plans/completed/

Folder: [plans/completed/](plans/completed/)

Purpose: completed execution history that remains useful context.

Read when: prior execution history is directly relevant to the current intent.

Skip when: the task has no dependency on completed work.

Resources:

No completed plan resources are indexed yet.

### proposals/

Folder: [proposals/](proposals/)

Purpose: options, recommendations, and decisions awaiting or recording User
authority.

Read when: the intent evaluates alternatives or requires a documented decision.

Skip when: no proposal or decision context is relevant.

Resources:

No proposal resources are indexed yet.

### templates/

Folder: [templates/](templates/)

Purpose: stable system templates for creating canonical resources.

Read when: creating a new resource in a supported resource folder.

Skip when: no new resource is being created.

Resources:

- [Harness improvement template](templates/harness-improvement.md)
- [Constraint template](templates/constraint.md)
- [Domain template](templates/domain.md)
- [Risk template](templates/risk.md)
- [Proposal template](templates/proposal.md)
- [Plan template](templates/plan.md)

Templates do not receive resource IDs or date-prefixed filenames.

## Resource Routing Rules

When canonical resources are added, list each resource under every applicable
classification section using a relative link. Do not duplicate the resource
file. Each real resource entry must include one `PRIORITY: [CRITIAL]`,
`PRIORITY: [MEDIUM]`, or `PRIORITY: [NORMAL]` line.

Update this file in the same task when filesystem structure or routing metadata
changes. Do not invent routes, resources, domain knowledge, or priorities.
