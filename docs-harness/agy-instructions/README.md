# Antigravity (AGY) Instructions

Instructions written for working on Google Antigravity (AGY). A session running on an
Antigravity host reads this file and every Markdown file under this folder at session
start, after the layers step and before task work.

A session counts as Antigravity when its host is Antigravity App 2.0, Antigravity CLI
(`agy`), Antigravity IDE, or the Antigravity SDK (recognizable from AGY-native tools such
as `invoke_subagent`, `run_workflow`, or `swarm`). Non-Antigravity sessions skip this
folder. Reload after a workspace switch, context compaction, or a User-reported change.

## Host-tool precedence

When an Antigravity session runs a `claude-*` model and also reads
[claude-instructions/](../claude-instructions/README.md), this folder's Antigravity host
rules and tools (`invoke_subagent`, `ask_question`, `send_message`, `run_workflow`,
`/compact`) take precedence over Claude-only tools (`mcp__ccd_session__start_session`,
`Explore`, and the Claude advisor tool).

These instructions shape how to work on Antigravity. They preserve task authority and
session role ([#009](../harness-constraints/0822-user-authority-operation-gate.md),
[#074](../harness-constraints/1120-session-role-and-judgment.md)).

## Model selection note

Each subagent instruction below has its own `[x]` checklist so the User can pick a Gemini
model tier independently per workflow. `invoke_subagent` (and `run_workflow` `agent()`)
accepts four model tiers only: `flash_lite`, `flash`, `pro`, and `inherit` — it has no
exact model ID or per-subagent `effort` argument.

## Adding an instruction

One topic per file, lowercase-kebab-case name, as short as the topic allows: every file
loads in every Antigravity session. Instruction files are not canonical resources and take
no ID. An instruction for one exact model and effort belongs in
[layers/layer-1/agents/](../layers/layer-1/agents/README.md) instead.

## Existing Antigravity material (not loaded by this folder)

- [docs/tools/antigravity/README.md](../../docs/tools/antigravity/README.md): the
  Antigravity tool catalog.
- `.agents/skills/utilizing-tools-agy/SKILL.md`: the capability routing skill.

## Instruction files

- [research-subagents.md](research-subagents.md): run code research in `research`
  subagents, with a selectable Gemini model-tier checklist.
- [compact-before-task.md](compact-before-task.md): above 50% context, ask the User about
  `/compact` before a task and write the prompt for it.
- [prd-research-subagent.md](prd-research-subagent.md): run `prd-research` in a fresh
  `self` subagent, with a selectable Gemini model-tier checklist.
- [coding-subagent.md](coding-subagent.md): run non-trivial coding tasks in a fresh
  `self` subagent, with a selectable Gemini model-tier checklist.
