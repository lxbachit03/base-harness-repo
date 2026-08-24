---
name: utilizing-tools-codex
description: Select and execute effective combinations of Codex built-in tools, MCP servers, plugins, and specialized skills for a task. Use when asked to leverage Codex tools, MCPs, plugins, or skills effectively, with a mandatory tool declaration table and seamless execution.
---

# Utilizing Codex Tools, MCPs & Skills

Select the smallest effective combination of Codex capabilities, declare it,
execute it, and leave observable proof. Treat the current session's exposed
tool and skill definitions as the runtime authority; this skill is a routing
guide, not a promise that every capability is enabled in every session.

## Mandatory Response Contract

Whenever this skill is triggered, begin the response with a concise Markdown
table before calling tools, then continue directly into execution:

```markdown
### Selected Codex Tools & MCPs
| Tool / MCP / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, services, or user-visible scope>` |
```

Use actual exposed names. If a skill is selected, name the skill as well as
the concrete tool it enables. If no external capability is needed, declare the
native inspection or editing tool that will carry the task. Do not invent a
tool, MCP server, plugin, connection, or permission.

## 3-Phase Execution Workflow

```text
1. Classify the task and inspect the available runtime capabilities
   ↓
2. Declare the selected Codex tools, MCPs, plugins, and skills
   ↓
3. Execute the smallest useful sequence and verify the result
```

### Phase 1: Task Classification & Capability Selection

Classify the task before choosing tools. The selected set must have a concrete
purpose and a bounded target.

#### Codex built-in tools

- **Filesystem and code**: `shell_command` for PowerShell inspection or
  explicitly authorized commands; `apply_patch` for precise file edits;
  `view_image` for local image inspection.
- **Web and visual work**: `web__run` for current web research, official docs,
  URLs, screenshots, and other supported lookups;
  `image_gen__imagegen` for new or edited raster images.
- **JavaScript runtime**: `mcp__node_repl__js`,
  `mcp__node_repl__js_add_node_module_dir`, and
  `mcp__node_repl__js_reset` for persistent JavaScript work when the task or a
  selected skill requires it.
- **Multi-agent orchestration**: `multi_agent_v1__spawn_agent`,
  `multi_agent_v1__wait_agent`, `multi_agent_v1__send_input`,
  `multi_agent_v1__resume_agent`, and `multi_agent_v1__close_agent`.
- **Goals and plans**: `create_goal`, `get_goal`, `update_goal`, and
  `update_plan`. Do not create or change autonomous goal state unless the User
  explicitly requests it.
- **MCP introspection**: `list_mcp_resources`,
  `list_mcp_resource_templates`, and `read_mcp_resource` when the task needs
  to inspect available MCP-provided resources.

#### Codex Apps MCP surface

Use only the concrete `mcp__codex_apps__*` tools exposed in the current
session. The current families are:

- **Sites**: create, save, deploy, inspect, version, domain, environment,
  access-control, worker-log, and site-database operations. Read
  `.openai/hosting.json` first when present and preserve its project identity.
- **Document Control**: connected Excel, PowerPoint, or Google Sheets
  sessions. Discover a session first, fetch the selected tool schema second,
  then execute with a stable idempotency key.
- **Plugin Management**: inspect one named plugin's permissions or
  dependencies; uninstall or change permissions only for an explicit,
  unambiguous User request.
- **Safety settings**: read or prepare the applicable parental-control or
  trusted-contact state, and require the connector's approval boundary before
  updates.
- **Local hotline**: use only when the User needs location-specific hotline
  information; never infer hotline details.

#### Specialized skills

Select a skill when it supplies task-specific procedure or quality gates:

- `browser:control-in-app-browser` for opening, navigating, inspecting,
  clicking, typing, or screenshotting local or in-app web targets.
- `documents:documents`, `pdf:pdf`, `presentations:Presentations`, and
  `spreadsheets:Spreadsheets` for durable document artifacts; use
  `spreadsheets:excel-live-control` for an already-connected live Excel
  session.
- `sites:sites-building` and `sites:sites-hosting` for local site work and
  hosting/deployment operations.
- `visualize:visualize` for interactive charts, maps, diagrams, simulations,
  and exploratory visual tools.
- `template-creator:template-creator` for reusable artifact templates.
- `plugin-management:plugin-management` for plugin discovery, permissions,
  dependencies, and connection decisions.
- `imagegen`, `openai-docs`, `plugin-creator`, `skill-creator`, or
  `skill-installer` when the task matches their stated scope.
- Repository workflow skills such as `goal-griller`, `onboarding`,
  `prompt-leverage`, `sequence-execution-plan`, `ticket-solving`,
  `utilizing-tools-agy`, `writing-for-agents`, and `xia` when their routing
  conditions are met.

**Selection criterion**: the exact set of selected tools, MCPs, plugins, and
skills is named, each item has a target scope, and every selected capability is
actually available or its absence is reported before execution.

### Phase 2: Mandatory Tool Declaration

Render the declaration table at the top of the response before tool calls.
Keep it small: prefer one native tool over several overlapping tools, and one
specialist skill over a bundle of unrelated skills.

**Completion criterion**: every row has a real capability name, a task-specific
purpose, and a bounded target scope.

### Phase 3: Seamless Execution & Proof

1. Execute the declared read-only inspection first when the target, connection,
   or authority is not yet established.
2. Perform only the User-authorized mutations or side-effecting commands. Use
   `apply_patch` for repository file edits and preserve unrelated worktree
   changes.
3. Verify each meaningful result using an executable check, tool response,
   rendered artifact, screenshot, deployment status, or other observable proof.
4. Report selected capabilities, changed paths or external targets, validation
   evidence, and any unattempted checks.

**Completion criterion**: the task has an observable result and the final
report ties that result to the declared tools and proof.

## Tool-Specific Guardrails

- **Authority**: reading is the default. File mutations, deployment, permission
  changes, uninstall, build, test, lint, format, generation, installation,
  migration, and package commands require explicit User authority for the
  named scope. A goal, plan, skill invocation, or acceptance criterion does
  not grant that authority.
- **Freshness**: use `web__run` for facts that may have changed. For OpenAI
  product or Codex questions, use `openai-docs` and official OpenAI sources.
- **Connected apps**: a tool being exposed does not prove that an account,
  document session, site, or permission is connected. Discover and report the
  connection state before relying on it.
- **Sites**: never invent project IDs, site IDs, cursors, commit SHAs, or
  deployment state. Read the project configuration and copy opaque IDs exactly
  from configuration or tool responses.
- **Document Control**: call session discovery, schema discovery, and command
  execution in that order. Reuse an idempotency key only when retrying the same
  logical command.
- **Plugins**: do not claim a plugin is installed or connected without
  verification. Do not suggest or use an external integration when an enabled
  native capability already solves the task.
- **Subagents**: delegate only bounded, non-overlapping work with a clear
  return artifact. Review returned changes before claiming completion.
- **Scope**: do not expand from local work to external deployment, account
  changes, or unrelated repository cleanup without pausing for User input.

## Anti-Patterns

- Executing tools before declaring the selected set.
- Listing every available tool when only one or two are relevant.
- Guessing a tool name, plugin status, app connection, or external identifier.
- Using web search for a task that local files or a native tool can answer.
- Running a build/test/lint/format/generation command without command-level
  authority.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, validation check, or User
  decision remains unresolved.
