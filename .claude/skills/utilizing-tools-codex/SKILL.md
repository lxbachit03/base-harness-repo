---
name: utilizing-tools-codex
description: Select and execute effective combinations of Codex built-in tools, MCP servers, Codex Apps, plugins, skills, and subagents for a task. Use when asked to leverage Codex tools, MCPs, plugins, or skills effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Codex Tools, MCPs & Skills

Select the smallest effective combination of Codex capabilities, declare it,
execute it, and leave observable proof. The current session's exposed tool and
skill definitions are the runtime authority; this skill routes to them and never
promises that a documented capability is enabled here.

AGENTS.md owns task authority, including routine local proof. The workflow name
is not a grant for external writes.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected Codex Capabilities
| Tool / MCP / Plugin / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, services, or user-visible scope>` |
```

Use actual exposed names. MCP tools carry their full prefix. If a skill is
selected, name the skill and the concrete tool it enables. If no external
capability is needed, declare the native inspection or editing tool that will
carry the task. Never invent a tool, MCP server, plugin, connection, or
permission.

## Workflow

```text
1. Classify the task and discover what the session actually exposes
   ↓
2. Declare the selected capabilities
   ↓
3. Execute the smallest useful sequence and verify with observable proof
```

### Phase 1: Classify & Discover

Classify before selecting; every selected capability needs a concrete purpose
and a bounded target.

| Task type | Preferred Codex capability |
| :--- | :--- |
| Inspect files, search, run commands | `shell_command`, within task authority |
| Edit repository files | `apply_patch` |
| Inspect a local image | `view_image` |
| Current web facts, docs, URLs | `web__run` |
| Create or edit a raster image | `image_gen__imagegen` |
| Persistent JavaScript work | the `node_repl` MCP tools |
| Bounded independent investigation | the `multi_agent_v1` spawn and wait tools |
| Track a multi-step task | `update_plan` |
| Autonomous goal state | `create_goal`, `get_goal`, `update_goal` — only on an explicit User request |
| Inspect MCP-provided resources | the MCP resource listing and read tools |
| Site build, deploy, or hosting | the Codex Apps site tools, with the sites skills |
| Connected spreadsheet, slides, or docs session | the Codex Apps Document Control tools |
| Durable document artifact | the documents, pdf, presentations, or spreadsheets skill |
| Browser interaction on a local or in-app target | the browser control skill |
| Interactive chart, map, or simulation | the visualize skill |
| Plugin discovery, permissions, dependencies | the plugin management skill |
| Repository procedure | the matching repository workflow skill |

Capability discovery rules:

- **Built-in tools**: trust the session's exposed tool definitions rather than a
  remembered catalog. Availability differs by session and account.
- **Codex Apps**: use only the concrete app tools exposed now. A tool being
  exposed does not prove that an account, document session, site, or permission
  is connected.
- **Plugins**: discover status through the plugin management surface. Do not
  claim a plugin is installed or connected without verification.
- **Skills**: discover from the session's skill list, and prefer one specialist
  skill over a bundle of unrelated ones.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before tool calls. Keep
it small: prefer one native tool over several overlapping tools, and one
specialist skill over a bundle of unrelated skills.

**Completion criterion**: every row has a real capability name, a task-specific
purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Execute the declared read-only inspection first when the target, connection,
   or authority is not yet established.
2. Perform only authorized mutations. Use `apply_patch` for repository file
   edits and preserve unrelated worktree changes.
3. Verify with an observable check: executable result, tool response, rendered
   artifact, screenshot, or deployment status.
4. Report selected capabilities, changed paths or external targets, validation
   evidence, and unattempted checks.

**Completion criterion**: the result is observable and every declared row maps
to executed work or a reported gap.

## Loading Model: Tool vs MCP vs Plugin vs Skill vs Subagent

| Layer | What it is | How it loads | Availability proof |
| :--- | :--- | :--- | :--- |
| Built-in tool | Native function (`shell_command`, `apply_patch`, ...) | Exposed in the session | Tool schema present in session |
| MCP server | External process exposing a prefixed tool family | Session MCP configuration | Callable tool plus a reachable server |
| Codex App | Connected service surface (sites, document control, plugins) | Account and connector state | A discovery call that returns a live session |
| Plugin | Installed capability bundle | Plugin installation for the account | Plugin management reports it installed |
| Skill | On-demand procedure | Session skill list | Entry in the session's skill list |
| Subagent | Isolated agent run with its own context | The multi-agent spawn tools | Subagent starts and returns work |

## Permission & Connection Boundaries

- Carry existing task permissions across turns. Inspect command effects, and use
  the specific boundary for external or destructive actions.
- Connection state is a ladder, not a boolean: configured service → reachable
  server → authenticated account → live session → permitted tool → authorized
  action. Report the missing rung rather than the top one.
- **Opaque identifiers**: never invent a project id, site id, cursor, commit SHA,
  or deployment state. Read the project configuration and copy identifiers
  exactly from configuration or tool responses. Read `.openai/hosting.json` first
  when it exists and preserve its project identity.
- **Document Control**: call session discovery, schema discovery, and command
  execution in that order. Reuse an idempotency key only when retrying the same
  logical command.
- **Freshness**: use `web__run` for facts that may have changed. For product
  questions, prefer local evidence and an official-documentation skill over
  memory.
- Delegate only bounded, non-overlapping work with a clear return artifact, and
  review what a subagent returns before claiming completion.
- Do not expand from local work to external deployment, account changes, or
  unrelated repository cleanup without pausing for User input.

## Anti-Patterns

- Executing tools before declaring the selected set.
- Listing every available capability when one or two are relevant.
- Guessing a tool name, plugin status, app connection, or external identifier.
- Treating "documented" or "configured" as "available and authenticated".
- Using web search for a task that local files or a native tool can answer.
- Asking again for routine local verification already covered by task authority,
  or treating a command name as permission for external effects.
- Creating or changing autonomous goal state the User did not request.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, proof, or decision remains
  missing.
