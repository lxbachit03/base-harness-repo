---
name: utilizing-tools-agy
description: Select and execute effective combinations of Antigravity (AGY) built-in tools, MCP plugins, skills, and subagents for a task. Use when asked to leverage AGY tools, MCPs, plugins, or skills effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Antigravity (AGY) Tools, MCPs & Skills

Select the smallest effective combination of Antigravity capabilities, declare
it, execute it, and leave observable proof. The current session's exposed tool
and skill definitions are the runtime authority; this skill routes to them and
never promises that a documented capability is enabled here.

AGENTS.md owns task authority and persistent permissions. Inspect the effects of
an unfamiliar command before running it.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected AGY Capabilities
| Tool / MCP / Plugin / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, endpoints, or user-visible scope>` |
```

Use actual exposed names. A plugin skill carries its `<plugin>:<skill>` name. If
a skill is selected, name the skill and the concrete tool it enables. If no
external capability is needed, declare the native tool that carries the task.
Never invent a tool, MCP server, plugin, skill, connection, or permission.

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

| Task type | Preferred AGY capability |
| :--- | :--- |
| Read a known file | `view_file` with a line range |
| Inspect directory layout | `list_dir` |
| Search content across files | `grep_search` |
| Edit an existing file | `replace_file_content` |
| Create a file or persist an artifact | `write_to_file` |
| Shell, build, test, git | `run_command`, within task authority |
| Long-running process | `manage_task` (`list`, `status`, `send_input`, `kill`) |
| Deferred or recurring wakeup | `schedule` (one-shot timer or cron) |
| Bounded independent investigation | `invoke_subagent`; `define_subagent` for a reusable role |
| Coordinate running subagents | `manage_subagents`, `send_message` |
| Current web facts | `read_url_content` for a known URL, `search_web` for discovery |
| Visual asset or mockup | `generate_image` |
| A decision only the User can make | `ask_question` |
| Browser automation or web debugging | `chrome-devtools-plugin` skills |
| Modern web platform guidance | `modern-web-guidance-plugin` skills |
| AGY configuration or SDK work | `builtin` and SDK skills |
| Repository procedure | the matching repository workflow skill |

Capability discovery rules:

- **Built-in tools**: trust the session's exposed tool definitions. Configuration
  can gate a tool the release ships.
- **Plugins and their skills**: discover from the session's exposed skill list,
  not from memory of what a plugin usually provides. A plugin being known is not
  a plugin being enabled in this workspace.
- **MCP**: an MCP-backed plugin needs a reachable server and, where applicable,
  an authenticated account before its tools do real work.
- **Repository skills**: read the repository's own routing before selecting one,
  so the skill and the task's authority agree.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before tool calls. Keep
it small: prefer one native tool over several overlapping tools, and one
specialist skill over a bundle of unrelated skills.

**Completion criterion**: every row has a real capability name, a task-specific
purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Inspect the target, connection, and permission state first when they are not
   already established.
2. Perform only authorized mutations; preserve unrelated worktree changes.
3. Verify with an observable check: tool response, file diff, command output,
   screenshot, or rendered artifact.
4. Report selected capabilities, changed paths, validation evidence, and
   unattempted checks.

**Completion criterion**: the result is observable and every declared row maps
to executed work or a reported gap.

## Loading Model: Tool vs Plugin vs Skill vs Subagent

| Layer | What it is | How it loads | Availability proof |
| :--- | :--- | :--- | :--- |
| Built-in tool | Native function (`view_file`, `run_command`, ...) | Exposed in the session | Tool schema present in session |
| MCP plugin | External server contributing tools and skills | Plugin configuration for the workspace | Reachable server plus callable tools |
| Plugin skill | Procedure shipped by a plugin, named `<plugin>:<skill>` | Loaded with its plugin | Entry in the session's skill list |
| Repository skill | Workflow procedure owned by this repository | Repository skill directories | Entry in the session's skill list |
| Subagent | Isolated agent run with its own context | `invoke_subagent`, optionally `define_subagent` | Subagent starts and returns work |

## Permission & Connection Boundaries

- Read-only inspection is the default for investigation. Mutating files,
  installing or enabling a plugin, changing configuration, and any external or
  destructive action need authority for that specific target.
- Connection state is a ladder, not a boolean: configured plugin → reachable
  server → authenticated account → permitted tool → authorized action. Report the
  missing rung rather than the top one.
- When a capability is missing or unauthenticated, name the missing layer,
  propose the smallest User-authorized step, and continue with the closest
  available native capability when the task permits. Never simulate a tool's
  output or claim its effects.
- Delegate only bounded, non-overlapping work with a clear return artifact, and
  review what a subagent returns before claiming completion.

## Anti-Patterns

- Executing tools before declaring the selected set.
- Stopping after the declaration table instead of continuing into execution.
- Listing every available capability when one or two are relevant.
- Guessing a tool name, plugin status, connection state, or opaque identifier.
- Dumping a whole large file when a line range or `grep_search` answers the task.
- Asserting implementation details instead of inspecting them with `view_file` or
  `run_command`.
- Using `run_command` to sleep when `schedule` expresses the wait.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, proof, or decision remains
  missing.
