---
name: utilizing-tools-claude
description: Select and execute effective combinations of Claude Code built-in tools, deferred tools, MCP connectors, plugins, skills, and subagents for a task. Use when asked to leverage Claude Code tools, MCPs, plugins, or skills effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Claude Code Tools, MCPs, Plugins & Skills

Select the smallest effective combination of Claude Code capabilities, declare
it, execute it, and leave observable proof. The current session's exposed tool,
skill, agent, and MCP declarations are the runtime authority; this skill routes
to them and never promises that a documented capability is enabled here.

Version boundary: calibrated to Claude Code `2.1.278` local runtime evidence.
Capability surfaces move with the release, the account, the marketplace, and the
plugin set. When this skill and the session disagree, the session wins; report
the gap instead of following either silently.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected Claude Code Capabilities
| Tool / MCP / Plugin / Skill / Agent | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, services, or user-visible scope>` |
```

Use actual exposed names. MCP tools carry their full `mcp__<server>__<tool>`
name; plugin skills carry their `<plugin>:<skill>` name. If a skill is selected,
name the skill and the concrete tool it enables. If no external capability is
needed, declare the native tool that carries the task. Never invent a tool, MCP
server, plugin, agent, connection, or permission.

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

| Task type | Preferred Claude Code capability |
| :--- | :--- |
| Read a known file | `Read` (`Glob` first when the path is unknown) |
| Search content across files | `Grep`; `Glob` for name and layout patterns |
| Edit or create files | `Edit` for exact replacement, `Write` for a new or fully replaced file |
| Shell, build, test, git | `Bash` (POSIX) or `PowerShell` (Windows-native), within task authority |
| Notebook cells | `NotebookEdit` (deferred) |
| Current web facts | `WebFetch` for a known URL, `WebSearch` for discovery (both deferred) |
| A decision only the User can make | `AskUserQuestion` |
| Plan before acting | `EnterPlanMode` / `ExitPlanMode` (deferred) |
| Isolated branch work | `EnterWorktree` / `ExitWorktree` (deferred) |
| Watch a long-running condition | `Monitor` (deferred); background `Bash` for detached commands |
| Recurring or scheduled work | `CronCreate` / `CronList` / `CronDelete` (deferred) |
| Load a repository procedure | `Skill` |
| Publish a page the User or team will use | `Artifact` |
| External service data | `mcp__<server>__<tool>` from a connected, authenticated server |
| Bounded independent investigation | `Agent`, only under the delegation rule below |

Capability discovery rules:

- **Built-in tools**: trust the session's exposed tool schemas. Settings,
  permission rules, and hooks can gate a tool the release ships.
- **Deferred tools**: a `<system-reminder>` names them without schemas, so they
  are not callable yet. Load with `ToolSearch` (`select:Name1,Name2` for exact
  names, keywords to search) and call only after the schema arrives.
- **MCP**: `claude mcp list` health-checks every server and is the authority on
  connection state; `claude mcp get <name>` details one. The session's tool
  surface is not that authority — a server can report `Connected` while the
  session exposes only its `authenticate` tools.
- **Plugins**: a plugin contributes skills (`<plugin>:<skill>`), MCP servers, and
  commands under its own namespace. `claude plugin list` shows what is installed
  and loaded; `claude plugin details <name>` shows its component inventory and
  token cost. Being in a marketplace is not being installed, and being installed
  is not being authenticated.
- **Skills**: discover from the session's available-skills listing. A skill with
  `disable-model-invocation: true` is absent from that listing and only the User
  can invoke it by name.
- **Agents**: use the session's available agent types. Delegation needs a bounded
  assignment, a write set, and a stop condition.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before tool calls. Keep
it small: prefer one native tool over several overlapping tools, and one
specialist skill over a bundle of unrelated skills.

**Completion criterion**: every row has a real capability name, a task-specific
purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Inspect the target, connection, and permission state first when they are not
   already established.
2. Perform only authorized mutations; preserve unrelated worktree changes. Run
   independent calls in one message so they execute in parallel.
3. Verify with an observable check: tool response, file diff, command output, or
   rendered artifact.
4. Report selected capabilities, changed paths, validation evidence, and
   unattempted checks.

**Completion criterion**: the result is observable and every declared row maps
to executed work or a reported gap.

## Loading Model: Tool vs MCP vs Plugin vs Skill vs Agent

| Layer | What it is | How it loads | Availability proof |
| :--- | :--- | :--- | :--- |
| Built-in tool | Native function (`Read`, `Bash`, `Edit`, ...) | Exposed at session start | Tool schema present in session |
| Deferred tool | Native function held back to save context | Named in a `<system-reminder>`; schema fetched by `ToolSearch` | Schema returned inside a `<functions>` block |
| MCP server | Local or remote process exposing `mcp__<server>__*` tools | Project `.mcp.json`, plugin `.mcp.json`, or account connector | Callable tool plus a connected, authenticated account |
| Plugin | Bundle of skills, MCP servers, and commands | Installed from a marketplace into the user plugin directory | Its namespaced skills or tools appear in the session |
| Skill | On-demand `SKILL.md` procedure | `.claude/skills/`, `.agents/skills/`, plugin skills, built-ins | Entry in the available-skills listing, or User invocation by name |
| Subagent | Isolated agent run with its own context | `Agent` tool with a `subagent_type` | Agent type listed in the session |

## Permission & Connection Boundaries

- Permission modes gate tool calls before they run. A denied call is the User
  declining: adjust the approach rather than retrying the same call. Hooks can
  intercept a call and return feedback; treat that feedback as the User's.
- `Bash` and `PowerShell` are distinct runtimes with distinct syntax on Windows.
  Choose one per command and write that shell's syntax, rather than mixing them.
- Connection state is a ladder, not a boolean: installed plugin → configured
  server → reachable server → authenticated account → permitted tool →
  authorized action. Report the missing rung instead of the top one.
- A failed MCP connection is a connection failure, not a missing capability. Name
  the server, quote the reported reason as diagnostic data, and say it needs a
  retry or a fix — never conclude the integration does not exist.
- Installing a plugin, authenticating a connector, or changing settings is a
  mutation; do it only with explicit authority for that target.
- Publishing an `Artifact` sends content out of the session and produces a
  shareable page. Treat it as an external action under the repository's task
  authority, not as an ordinary file write.
- When a capability is missing or unauthenticated, name the missing layer,
  propose the smallest User-authorized step, and continue with the closest
  available native capability when the task permits. Never simulate a tool's
  output or claim its effects.

## Delegation In This Repository

`AGENTS.md` owns the session role. The primary session is Bale and handles small
work directly; an explicitly delegated session is a worker that executes its own
bounded assignment and returns evidence.

Route delegation through `.agents/skills/herdr-coordinate-agents/SKILL.md` when
independent work, specialized context, or a separate review justifies it. Reach
for the native `Agent` or `Workflow` tool only when the User, a `CLAUDE.md`, or a
skill asks for it, and read the workflow authoring reference before writing a
workflow script.

## Anti-Patterns

- Executing tools before declaring the selected set.
- Listing every documented capability when one or two are relevant.
- Calling a deferred tool before `ToolSearch` has returned its schema.
- Guessing a tool name, MCP prefix, plugin status, auth state, or opaque ID.
- Treating "in the marketplace", "installed", or "configured" as "connected and
  authenticated".
- Reading a failed MCP connection as proof the capability is unavailable.
- Using an install, login, or eval command as a capability probe; discovery uses
  `claude mcp list`, `claude plugin list`, and `claude plugin details`.
- Using web search for a task that local files or a native tool can answer.
- Spawning a subagent for work the current session can finish directly, or
  spawning one the User did not authorize.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, proof, or decision remains
  missing.
