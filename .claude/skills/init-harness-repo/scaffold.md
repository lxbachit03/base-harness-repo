# Scaffold contents

Reference for [SKILL.md](SKILL.md) step 3. Create each file below at its path,
relative to the repository root, replacing every placeholder:

| Placeholder | Value |
| --- | --- |
| `{{HARNESS_DIR}}` | answer 1, e.g. `docs-harness` |
| `{{ORCHESTRATOR}}` | answer 2, e.g. `BALE` |
| `{{HARNESS_GOAL}}` | answer 3, as the User worded it |
| `{{ROUTING_FILE}}` | answer 4, e.g. `INDEX.md` |
| `{{TO_ROOT}}` | relative path from `{{HARNESS_DIR}}` back to the root: `..` for one segment, `../..` for two |

Write each file's content exactly as shown inside its fence, without the fence
lines.

## `AGENTS.md`

```markdown
# Agent Instructions

Harness repo: [`{{HARNESS_DIR}}/`]({{HARNESS_DIR}}/{{ROUTING_FILE}}). Whenever
the User says "harness repo", they mean this folder.

Harness goal: {{HARNESS_GOAL}}

Orchestrator: {{ORCHESTRATOR}}. When the User addresses {{ORCHESTRATOR}}, the
main agent of the current session coordinates other main agents for the task.

## Session start

1. Read [{{ROUTING_FILE}}]({{HARNESS_DIR}}/{{ROUTING_FILE}}) before any other
   repository documentation.
2. Load the enabled layer instructions per
   [layers/README.md]({{HARNESS_DIR}}/layers/README.md).
3. Apply every enabled constraint in
   [harness-constraints/]({{HARNESS_DIR}}/harness-constraints/README.md) for
   the whole session.

## Mindsets

- **Top-Down** (default): start from the routing file and load a routed
  resource only when the User's intent needs it, to save tokens.
- **Bottom-Up**: when Top-Down routing cannot answer, search files directly
  and accept the extra tokens for better retrieval. Use it only when you judge
  it necessary.

## Working rules

- **Clarify:** when the User's intent is unclear, ask the questions needed for
  a fitting result, one at a time (Meta-Prompting). When several options fit,
  recommend one, explain each option, and offer a free-text answer.
- **Status check:** when the User asks about the harness repo's status, read
  its state: the routing file, its folder tree against the routes, enabled
  layers, the toggle state of each constraint, and the status of each
  improvement record. Report drift with a proposed fix.
- **Templates first:** before creating a `.md` file in the harness repo, look
  for a matching template in
  [templates/]({{HARNESS_DIR}}/templates/README.md). If none exists, ask the
  User whether you should create one, and offer a free-text input for a custom
  template.
- **Improvements:** when the User asks to improve the harness repo or invokes
  an `improve-harness` skill, record the change in
  [harness-improvements/]({{HARNESS_DIR}}/harness-improvements/README.md).
```

## `CLAUDE.md`

Imports `AGENTS.md` for hosts that load only `CLAUDE.md`, so `AGENTS.md`
stays the single source.

```markdown
@AGENTS.md
```

## `{{HARNESS_DIR}}/{{ROUTING_FILE}}`

```markdown
# Harness Routing

Top-Down entry point of the harness repo. Back to [AGENTS.md]({{TO_ROOT}}/AGENTS.md).
Read this file first; open a routed resource only when the current intent
needs it.

## Maintenance

When you create, rename, or remove a file under a routed folder, update that
folder's Resources list here in the same task. Then verify that every link in
this file resolves and that each folder README still links back here.

## harness-improvements/

Purpose: audit trail of every improvement to the harness repo.

Read when: the User asks to improve the harness repo or invokes an
`improve-harness` skill.

Skip when: the task does not change the harness repo.

Resources:

- [harness-improvements/README.md](harness-improvements/README.md)

## layers/

Purpose: layered instructions loaded before the agent takes a task or checks
the harness repo's status.

Read when: every session start and every status check.

Skip when: never; the enabled layers decide what loads.

Resources:

- [layers/README.md](layers/README.md)
- [layers/layer-1/README.md](layers/layer-1/README.md)

## harness-constraints/

Purpose: constraints the agent follows for the whole session.

Read when: every session start and every status check.

Skip when: never; the toggle on each constraint decides whether it applies.

Resources:

- [harness-constraints/README.md](harness-constraints/README.md)

## templates/

Purpose: templates used before creating a `.md` file in the harness repo.

Read when: creating a new file in the harness repo.

Skip when: no file is being created.

Resources:

- [templates/README.md](templates/README.md)
```

## `{{HARNESS_DIR}}/harness-improvements/README.md`

```markdown
# Harness Improvements

Back to [{{ROUTING_FILE}}](../{{ROUTING_FILE}}).

Purpose: audit trail of every improvement to the harness repo.

Trigger: the User asks to improve the harness repo or invokes an
`improve-harness` skill.

Rules:

- Record each improvement in one file here named
  `MMDD-short-kebab-description.md`, created before the change is made.
- Use the matching template from `../templates/` when one exists; otherwise
  follow the templates-first rule in AGENTS.md.
- Each record states the objective, purpose, files changed, proof, and result.
  Continue the same improvement in its existing record.
- Add each record to the `harness-improvements/` Resources list in
  `../{{ROUTING_FILE}}`.
```

## `{{HARNESS_DIR}}/layers/README.md`

```markdown
# Layers

Back to [{{ROUTING_FILE}}](../{{ROUTING_FILE}}).

Purpose: layered instructions that the agent loads into context before it
takes a task from the User and when the User asks for the harness repo's
status. The User defines the instructions; this README holds the rules.

## Structure

- `layer-<N>/` folders are stages, loaded in ascending order (`layer-1`,
  `layer-2`, ...). A later layer may refine an earlier one; report any conflict
  between them to the User.
- Each instruction is one `.md` file directly in a `layer-<N>/` folder. A
  folder's `README.md` is documentation and is never loaded as an instruction.

## Toggle

Every instruction file starts, right below its title, with one checklist line
that works as the User's on/off switch:

    - [x] Enabled: <one-line summary of the instruction>

- `[x]`: load and apply the instruction.
- `[ ]`: skip the instruction.
- Only the User changes a toggle. Agents read its current state at each load
  point and leave the line as it is.

## Loading

At session start, and again when the User asks for the harness repo's status:

1. Walk the `layer-<N>/` folders in ascending order.
2. In each one, read the toggle line of every instruction file.
3. Load each enabled instruction and tell the User its path.

## Adding an instruction

Create the file in the right `layer-<N>/` folder, starting from a template in
`../templates/` when one exists. Begin it with the toggle line, then add it to
the `layers/` Resources list in `../{{ROUTING_FILE}}`.
```

## `{{HARNESS_DIR}}/layers/layer-1/README.md`

```markdown
# Layer 1

Back to [layers/README.md](../README.md) and
[{{ROUTING_FILE}}](../../{{ROUTING_FILE}}).

First instruction layer. Add instruction files here, each starting with the
toggle line defined in `../README.md`.
```

## `{{HARNESS_DIR}}/harness-constraints/README.md`

```markdown
# Harness Constraints

Back to [{{ROUTING_FILE}}](../{{ROUTING_FILE}}).

Purpose: constraints on the harness repo that the agent must follow for the
whole session.

## Toggle

Every constraint file starts, right below its title, with one checklist line
that works as the User's on/off switch:

    - [x] Enabled: <one-line summary of the constraint>

- `[x]`: the constraint applies for the rest of the session.
- `[ ]`: the constraint is dormant.
- Only the User changes a toggle. Agents read its current state at session
  start, at each status check, and when the User reports a change; they leave
  the line as it is.

## Rules

- One constraint per `.md` file in this folder; this README is documentation,
  not a constraint.
- If an enabled constraint conflicts with the User's request, pause and ask
  the User before acting.
- Add each constraint file to the `harness-constraints/` Resources list in
  `../{{ROUTING_FILE}}`, starting from a template in `../templates/` when one
  exists.
```

## `{{HARNESS_DIR}}/templates/README.md`

```markdown
# Templates

Back to [{{ROUTING_FILE}}](../{{ROUTING_FILE}}).

Purpose: templates the agent uses before creating a `.md` file in the
harness repo.

## Templates first

Before creating a file in the harness repo:

1. Look here for a template that matches the file's kind.
2. If one exists, start from it.
3. If none exists, ask the User whether you should create a template first.
   Offer the options (create a suggested template, create the file without a
   template) and a free-text input for the User's own template.

Templates hold placeholders, not facts. Add each new template to the
`templates/` Resources list in `../{{ROUTING_FILE}}`.
```
