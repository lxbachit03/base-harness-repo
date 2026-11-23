---
name: utilizing-tools-agy
description: Select and execute effective combinations of Antigravity (AGY) built-in tools, MCP plugins, skills, and subagents for a task. Use when asked to leverage AGY tools, MCPs, plugins, or skills effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Antigravity (AGY) Tools, MCPs & Skills

Select the smallest effective combination of Antigravity capabilities, declare
it, execute it, and leave observable proof. The current session's exposed tool
and skill definitions are the runtime authority; this skill routes to them and
never promises that a documented capability is enabled here.

docs-harness/harness-constraints/0822-user-authority-operation-gate.md owns task authority and persistent permissions. Inspect the effects of
an unfamiliar command before running it.

Tool names differ by surface and release. Checked on 2026-11-21 in five `agy`
1.5.14 CLI sessions (docs/tools/antigravity/README.md holds the evidence): the
names below were exposed in every one. The older and IDE names `view_file`,
`write_to_file`, `replace_file_content`, `list_dir`, `grep_search`,
`read_url_content` and `generate_image` were exposed in none. Use the name in
your own session's tool schema when it differs.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected AGY Capabilities
| Tool / MCP / Plugin / Skill | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_name>` | `<concise rationale>` | `<files, endpoints, or user-visible scope>` |
```

Use actual exposed names. A plugin skill carries the name the session's skill
list shows: bare in `agy` 1.5.14, or `<plugin>:<skill>` where the list
qualifies it (the User's `/` menu always shows the qualified form). If a skill is selected, name the skill and the concrete tool it
enables. If no external capability is needed, declare the native tool that
carries the task. Never invent a tool, MCP server, plugin, skill, connection,
or permission.

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
| Read a known file | `read_file` with `StartLine`/`EndLine` (at most 800 lines or 46,080 bytes per call) |
| Inspect directory layout, search content across files | `run_command` (`Get-ChildItem`, `rg`, `Select-String`); no dedicated list or grep tool |
| Edit an existing file | `edit_file` (`Target` → `Replacement`; replaces every match) |
| Create a file or persist an artifact | `write_file` (`Overwrite` or `Append`, never both) |
| Shell, build, test, git | `run_command`, within task authority; sandboxed by default (workspace only, no network), `BypassSandbox: true` needs User approval |
| Long-running process | `manage_task` (`list`, `status`, `send_input`, `kill`) |
| Deferred or recurring wakeup | `schedule` (one-shot timer or 5-field cron) |
| Bounded independent investigation | `invoke_subagent` (types `self`, `research` read-only, `image-generator`; `Workspace` `inherit`/`branch`/`share`; `Model` `inherit`/`flash_lite`/`flash`/`pro`); `define_subagent` for a reusable role |
| Coordinate running subagents | `manage_subagents`, `send_message` |
| Scripted fan-out or pipeline of agents and tools | `run_workflow` (Python script; the `run-workflow` skill explains it) |
| Shared-board agent swarm | `swarm`, only after the User runs `/swarm` |
| Current web facts | `search_web` (summary with source URLs); no dedicated URL reader in `agy` 1.5.14 sessions |
| Image asset or mockup | `invoke_subagent` with the `image-generator` type |
| A decision only the User can make | `ask_question` |
| Hand a plan to the execution model | `exit_plan_mode`, present only in plan-mode (Orchestrator) sessions |
| Browser automation or web debugging | `playwright-cli` through `run_command` (browser note below); `chrome-devtools-plugin` skills and `/browser` only where Google Chrome runs with remote debugging |
| Modern web platform guidance | `modern-web-guidance-plugin` skills (`modern-web-guidance`, `chrome-extensions`) |
| AGY configuration or SDK work | `agy-customizations`, `antigravity-guide`, `google-antigravity-sdk` skills |
| Semantic judgment, fast classification, Jev primitives | `typesafe-ai` (`.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1`) |
| Repository procedure | the matching repository workflow skill |

Browser note: on this machine Google Chrome is absent, so `/browser` and the
Chrome DevTools route cannot connect; drive the browser with `playwright-cli`.
1. `playwright-cli --version` (0.1.25). When it is missing, report it to the
   User; installing it needs the User's authority.
2. Read its agent skill at
   `Join-Path (npm root -g) '@playwright\cli\node_modules\playwright-core\lib\tools\skills\playwright-cli\SKILL.md'`;
   `--help` names that file only under Claude Code or Copilot CLI.
3. The browser closes when the `run_command` shell that opened it exits, so
   one `run_command` carries a whole flow. Start it with
   `New-Item -ItemType Directory -Force "$env:TEMP\agy-playwright" | Set-Location`
   so the `.playwright-cli/` output stays out of the repository even when the
   folder is new, then `open` with `-s=<name>` and
   `--browser msedge` (add `--headed` when the User wants to watch), the
   actions, the reads, and `playwright-cli -s=<name> close` last. Plan the
   refs from a first `snapshot` run, then run the flow. When `run_command`
   offers `BypassSandbox`, set it to `true`; the browser needs it.
   PowerShell strips double quotes inside single-quoted arguments: wrap an
   `eval` function in double quotes and use single quotes inside it.
4. Observe text-first: `snapshot`, `find`, `eval`. A screenshot the model sees
   costs about 1.3k prompt tokens whatever its size, and one over about 10 KB
   stays a file the model never sees; take one only for a visual check, of an
   element (`screenshot <ref>`) rather than the page.
5. Refs go stale when the page changes; take a fresh `snapshot` before reusing
   one.

Capability discovery rules:

- **Built-in tools**: trust the session's exposed tool definitions. Configuration
  and the session mode can gate a tool the release ships (`swarm` needs
  `/swarm`; `exit_plan_mode` needs plan mode).
- **Plugins and their skills**: discover from the session's exposed skill list,
  not from memory of what a plugin usually provides. A plugin being known is not
  a plugin being enabled in this workspace, and an enabled plugin is not an MCP
  tool: no enabled plugin contributed an MCP tool in the checked sessions. An
  `agy` update can reset the installed plugins (2026-11-23: `agy plugin list`
  went from three to none); `agy plugin list --json` is the current state.
- **MCP**: an MCP-backed plugin needs a reachable server and, where applicable,
  an authenticated account before its tools do real work. Configuration lives in
  `~/.gemini/config/mcp_config.json`, `.agents/mcp_config.json` or a plugin's
  `mcp_config.json`.
- **Repository skills**: read the repository's own routing before selecting one,
  so the skill and the task's authority agree. Some skills are hidden from the
  model (`disable-model-invocation`) and run only when the User names them.

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
| Built-in tool | Native function (`read_file`, `run_command`, ...) | Exposed in the session | Tool schema present in session |
| MCP plugin | External server contributing tools and skills | `mcp_config.json` for the workspace or plugin | Reachable server plus callable tools |
| Plugin skill | Procedure shipped by a plugin | Loaded with its plugin | Entry in the session's skill list |
| Builtin skill | Procedure shipped with `agy` (`agy-customizations`, `antigravity-guide`, `run-workflow`) | Exposed in the session | Entry in the session's skill list |
| Repository skill | Workflow procedure owned by this repository | Repository skill directories | Entry in the session's skill list |
| Subagent | Isolated agent run with its own context | `invoke_subagent`, optionally `define_subagent` | Subagent starts and returns work |

## Permission & Connection Boundaries

- Read-only inspection is the default for investigation. Mutating files,
  installing or enabling a plugin, changing configuration, and any external or
  destructive action need authority for that specific target.
- Reading a file outside the workspace, or running a command with
  `BypassSandbox: true`, raises a permission dialog that only the User answers.
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
- Guessing a tool name, plugin status, connection state, or opaque identifier,
  including a tool name remembered from older or IDE documentation.
- Dumping a whole large file when a line range or `rg` answers the task.
- Asserting implementation details instead of inspecting them with `read_file` or
  `run_command`.
- Using `run_command` to sleep when `schedule` expresses the wait.
- Opening a swarm the User did not ask for.
- Treating a successful tool call as proof without inspecting its result.
- Claiming completion while a required connection, proof, or decision remains
  missing.
