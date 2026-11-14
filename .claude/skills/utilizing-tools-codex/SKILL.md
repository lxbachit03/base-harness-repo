---
name: utilizing-tools-codex
description: Select Codex tools, MCPs, apps, plugins, skills, or subagents when asked to use them effectively; read AGENTS.md then docs-harness/INDEX.md before repo skills, and declare capabilities in a table before task tools.
---

# Utilizing Codex Tools, MCPs & Skills

Select the smallest effective combination of Codex capabilities, declare it,
execute it, and leave observable proof. The current session's exposed tool and
skill definitions are the runtime authority; this skill routes to them and never
promises that a documented capability is enabled here.

docs-harness/SESSION.md owns task authority, including routine local proof. The workflow name
is not a grant for external writes.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table of
known capabilities before task tool calls, then continue directly into execution:

```markdown
### Selected Codex Capabilities
| Tool / MCP / Plugin / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, services, or user-visible scope>` |
```

Follow the repository's AGENTS.md → docs-harness/INDEX.md retrieval order before
reading this skill or other repository documentation. Required session-start
retrieval may precede the table when the runtime needs it. Include the bootstrap
tool in the first table if it was used; this exception does not cover task
inspection, capability discovery, or execution.

Use names actually exposed by the current session, including tool namespaces.
Name each selected skill and the concrete tool used for its work when applicable.
If discovery is needed, declare the available discovery tool and its scope in
the first table; after discovery, update the table before using a newly selected
capability. Declare discovery first; declare newly found capabilities before
using them. Never invent a tool, MCP server, plugin, connection, or permission.

## Workflow

```text
1. Classify the task and identify capabilities already exposed
   ↓
2. Declare those selected, including any needed discovery capability
   ↓
3. Discover missing capabilities; update the declaration before using them
   ↓
4. Execute the smallest useful sequence and verify with observable proof
```

### Phase 1: Classify & Discover

Classify before selecting; every selected capability needs a concrete purpose
and a bounded target.

| Task type | Preferred Codex capability |
| :--- | :--- |
| Inspect files, search, run commands | the exposed shell or file-inspection tool, within task authority |
| Edit repository files | the exposed patch or file-editing tool |
| Inspect a local image | the exposed local image-viewing tool |
| Current web facts, docs, URLs | the exposed web search and retrieval tool |
| Create or edit a raster image | the exposed image-generation tool and relevant skill |
| Persistent JavaScript work | the session's persistent JavaScript tool, when available |
| Bounded independent investigation | exposed subagent tools only when delegation is permitted; otherwise work locally |
| Track a multi-step task | an exposed task-tracking tool, or a concise response-local plan |
| Autonomous goal state | the session's goal controls, only on an explicit User request |
| Inspect MCP-provided resources | exposed MCP resource listing and read tools for the relevant server |
| Site build, deploy, or hosting | the Codex Apps site tools, with the sites skills |
| Connected spreadsheet, slides, or docs session | the Codex Apps Document Control tools |
| Durable document artifact | the documents, pdf, presentations, or spreadsheets skill |
| Browser interaction on a local or in-app target | the browser control skill |
| Interactive chart, map, or simulation | the visualize skill |
| Plugin discovery, permissions, dependencies | the plugin management skill |
| Semantic judgment, fast classification, Jev primitives | `typesafe-ai` (`.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1`) |
| Repository procedure | the matching repository workflow skill |

Capability discovery rules:

- **Built-in tools**: trust the session's exposed tool definitions rather than a
  remembered catalog. Availability differs by session and account.
- **Deferred tools**: use the session's supported search or inventory mechanism,
  when available, to discover relevant tools and read their schemas before use.
- **Codex Apps**: use only the concrete app tools exposed now. A tool being
  exposed does not prove that an account, document session, site, or permission
  is connected. Use app-specific discovery for apps; MCP resource and template
  listings are for MCP resources, not app discovery.
- **Plugins**: discover status through the plugin management surface. Do not
  claim a plugin is installed or connected without verification.
- **Skills**: discover from the session's skill list, and prefer one specialist
  skill over a bundle of unrelated ones.
- **Unavailable capability**: use an authorized native fallback when it fits;
  otherwise report the missing capability and the work it blocks.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before task tool calls,
after any necessary bootstrap retrieval described above. Keep it small: prefer
one native tool over several overlapping tools, and one
specialist skill over a bundle of unrelated skills. Declare a discovery tool
before using it, and update the table before calling any tool discovered later.

**Completion criterion**: every row has a real capability name, a task-specific
purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Execute the declared read-only inspection first when the target, connection,
   or authority is not yet established.
2. Perform only authorized mutations. Use the exposed patch or file-editing
   tool for repository edits and preserve unrelated worktree changes.
3. Verify with an observable check: executable result, tool response, rendered
   artifact, screenshot, or deployment status.
4. Report selected capabilities, changed paths or external targets, validation
   evidence, and unattempted checks.

**Completion criterion**: the result is observable and every declared row maps
to executed work or a reported gap.

## Loading Model: Tool vs MCP vs Plugin vs Skill vs Subagent

| Layer | What it is | How it loads | Availability proof |
| :--- | :--- | :--- | :--- |
| Built-in tool | Native inspection, editing, or execution capability | Exposed in the session | Tool schema present in session |
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
- **Freshness**: use an exposed web-retrieval capability for facts that may have
  changed. For product questions, prefer local evidence and an
  official-documentation skill over memory.
- Delegate only when the session's instructions and role permit it. Give bounded,
  non-overlapping work a clear return artifact, and review the result before
  claiming completion.
- Do not expand from local work to external deployment, account changes, or
  unrelated repository cleanup without pausing for User input.

## Anti-Patterns

- Calling a task or discovery tool before declaring it.
- Treating an example tool name as available without checking the current session.
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
