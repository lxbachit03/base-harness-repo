---
name: utilizing-tools-opencode
description: Select and execute effective combinations of OpenCode built-in tools, MCP servers, plugins, skills, and agents for a task. Use when asked to leverage OpenCode tools, MCPs, plugins, or skills effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing OpenCode Tools, MCPs, Skills & Agents

Select the smallest effective combination of OpenCode capabilities, declare it,
execute it, and leave observable proof. The current session's exposed tool and
skill definitions are the runtime authority; this skill routes to them and never
promises that a documented capability is enabled in the current session.

Version boundary: calibrated to OpenCode `1.18.30` local runtime evidence plus
current official docs. When local CLI behavior differs from newer docs, the
local runtime wins for this machine; report the gap instead of silently
following either.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected OpenCode Capabilities
| Tool / MCP / Plugin / Skill / Agent | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, services, or user-visible scope>` |
```

Use actual exposed names. MCP tools carry their server prefix
(`<server>_<tool>`). If a skill is selected, name the skill and the concrete
tool it enables. If no external capability is needed, declare the native tool
that carries the task. Never invent a tool, MCP server, plugin, agent,
connection, or permission.

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

| Task type | Preferred OpenCode capability |
| :--- | :--- |
| Read/search/edit repo files | `read`, `grep`, `glob`, `edit`, `write`; `apply_patch` when exposed |
| Shell, build, test, git | `bash` (only within the task's authority) |
| Code intelligence | `lsp` (experimental; only when explicitly enabled) |
| Current web facts | `webfetch` for a known URL; `websearch` for discovery (provider-gated) |
| Multi-step tracking | `todowrite` |
| Delegate bounded work | `task` (subagents: `general`, `explore`, `scout` by default) |
| User decision | `question` |
| Load a procedure | `skill` |
| External service | MCP tools from a configured, authenticated server |
| Lifecycle hooks or custom tools | OpenCode plugins (JS/TS modules) |

Capability discovery rules:

- **Built-ins**: trust the session's exposed tool definitions. Config can deny
  or gate a tool even when OpenCode ships it.
- **MCP**: run `opencode mcp list` (read-only) for configured servers and auth
  status. A configured server is not proof of connection, authentication, or
  permission.
- **Plugins**: discover from the `plugin` config key and the plugin directories
  `.opencode/plugins/` and `~/.config/opencode/plugins/`. In `1.18.30`,
  `opencode plugin --help` exposes only `plugin <module>`, which installs a
  module and mutates config. Never run `opencode plugin list` for discovery on
  this version: `list` is parsed as a module name.
- **Skills**: discover from the session's `<available_skills>` entries and load
  content with the `skill` tool. OpenCode supporting the skill mechanism does
  not mean a given skill is installed in this repository.
- **Agents**: discover the selectable primary agents and subagents in the
  session; delegation needs a bounded task, write set, and stop condition.

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
   or rendered artifact.
4. Report selected capabilities, changed paths, validation evidence, and
   unattempted checks.

**Completion criterion**: the result is observable and every declared row maps
to executed work or a reported gap.

## Loading Model: Tool vs MCP vs Plugin vs Skill vs Agent

| Layer | What it is | How it loads | Availability proof |
| :--- | :--- | :--- | :--- |
| Built-in tool | Native function (`bash`, `edit`, `read`, ...) | Exposed in the session; gated by `permission`/`tools` | Tool schema present in session |
| MCP server | External local/remote process exposing `<server>_*` tools | Declared under `mcp` in `opencode.json`; started for the session | `opencode mcp list` plus callable tools |
| Plugin | JS/TS module hooking events or adding tools | `.opencode/plugins/`, global plugin dir, or npm `plugin` config | Loaded at startup; hook or tool effects observable |
| Skill | On-demand `SKILL.md` procedure | `.opencode/skills/`, `.claude/skills/`, `.agents/skills/`, global equivalents | Entry in `<available_skills>` |
| Agent | Primary persona or subagent | Session selection (Tab, `@`), or `task` invocation | Agent visible or invocable in session |

## Permission & Connection Boundaries

- Permissions are `allow`, `ask`, or `deny`, matched as wildcard patterns
  against tool names. `edit` gates `write`, `edit`, and `apply_patch`. `bash`
  accepts per-command globs. An MCP server can be gated as `<server>_*`.
  `external_directory` gates reads and writes outside the project worktree.
- `ask` is a pause for user approval, not a failure. A `deny` removes the tool;
  do not retry the same effect through an unapproved workaround path.
- Connection state is a ladder, not a boolean: configured server → reachable
  server → authenticated account → permitted capability → authorized action.
  Report the missing rung.
- Remote MCP servers may use OAuth (`opencode mcp auth <name>`) or headers
  (`{env:...}` values). A credential in config proves configuration, not a live
  authenticated session.
- **Unavailable or unauthenticated handling**: name the missing layer, propose
  the smallest user-authorized step (for example `opencode mcp auth <name>` or
  a config change), and continue with the closest available native capability
  when the task permits. Never simulate a tool's output or claim its effects.
- Installing or upgrading plugins, adding MCP servers, or changing config is a
  mutation; do it only with explicit authority for that target.

## Anti-Patterns

- Executing tools before declaring the selected set.
- Listing every documented capability when one or two are relevant.
- Guessing a tool name, MCP prefix, plugin status, auth state, or opaque ID.
- Treating "documented" or "configured" as "available and authenticated".
- Running `opencode plugin list` on `1.18.30`, or using any install command as
  a probe.
- Using web search for a task that local files or a native tool can answer.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, proof, or decision remains
  missing.
