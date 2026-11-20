# Claude Instructions

Instructions written for working with Claude. A session that runs a Claude model or
a Claude platform reads this file and every Markdown file under this folder at
session start, after the layers step and before task work.

A session counts as Claude when its resolved model ID contains `claude`, or its host
is a Claude platform: Claude Code (CLI, desktop app, IDE extension), claude.ai, or the
Claude Agent SDK. Any other session skips this folder. Reload it after a workspace
switch or a User-reported change.

These instructions change how to work with Claude. They do not change task authority
or the session role ([#009](../harness-constraints/0822-user-authority-operation-gate.md),
[#074](../harness-constraints/1120-session-role-and-judgment.md)).

## Adding an instruction

One topic per file, a lowercase-kebab-case name, as short as the topic allows: every
file loads in every Claude session. Instruction files are not canonical resources and
take no ID. An instruction for one exact model and effort belongs in
[layers/layer-1/agents/](../layers/layer-1/agents/README.md) instead.

## Existing Claude material (not loaded by this folder)

- [docs/tools/claude/README.md](../../docs/tools/claude/README.md): the Claude Code
  catalog.
- `.agents/skills/utilizing-tools-claude/SKILL.md`: the capability routing skill.

## Instruction files

- [prd-research-sub-session.md](prd-research-sub-session.md): run `prd-research` in a
  new Opus 5.5 high-effort session.
- [coding-sub-session.md](coding-sub-session.md): run a coding task in a new Sonnet 5.5
  session, with a checklist for its effort and an optional Opus 5.5 advisor (on/off
  checkbox, effort checklist).
- [research-subagents.md](research-subagents.md): run code research in Haiku 5.5
  subagents, with a checklist for their effort.
- [compact-before-task.md](compact-before-task.md): above 50% context, ask the User about
  `/compact` before a task and write the prompt for it.
