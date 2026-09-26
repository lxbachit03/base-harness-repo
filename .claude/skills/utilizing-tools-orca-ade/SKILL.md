---
name: utilizing-tools-orca-ade
description: Select and execute effective combinations of Orca ADE CLI tools, browser automation, worktrees, terminal multiplexing, and Herdr worker coordination for a task. Use when asked to leverage Orca ADE tools, browser, worktrees, or terminals effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Orca ADE Tools, Browser Automation, Worktrees & Herdr Coordination

Select the smallest effective combination of Orca ADE capabilities, declare it,
execute it, and leave observable proof. The local Orca runtime and exposed CLI
commands (`orca.exe`) are the runtime authority; this skill routes to them and
never promises that a documented feature is enabled or running.

Version boundary: calibrated to Orca `1.4.212` local runtime evidence on
Windows. When local CLI behavior differs from newer docs, the local runtime wins
for this machine; report the gap instead of silently assuming either.

AGENTS.md owns task authority and persistent permissions. Inspect the effects
of an unfamiliar command before running it.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected Orca ADE Capabilities
| Tool / CLI / Browser / Worktree / Herdr | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_command_or_capability>` | `<concise rationale>` | `<urls, worktrees, terminals, or repo scope>` |
```

Use actual exposed commands and parameters. If an in-browser task is selected,
name the exact sub-commands (`orca tab`, `orca snapshot`, `orca click`, `orca eval`).
If an isolated worker coordination task is selected, declare the worktree and
terminal commands alongside the Herdr profile. If no external Orca capability is
needed, declare the native tool carrying the task. Never invent an Orca command,
worktree selector, terminal handle, or permission.

## Workflow

```text
1. Classify the task and discover what Orca runtime actually exposes
   ↓
2. Declare the selected capabilities
   ↓
3. Execute the smallest useful sequence and verify with observable proof
```

### Phase 1: Classify & Discover

Classify before selecting; every selected capability needs a concrete purpose
and a bounded target.

| Task type | Preferred Orca ADE capability |
| :--- | :--- |
| Verify Orca availability | `orca status --json` |
| Web exploration / SPA inspection | `orca tab create`, `orca eval --expression <js> --json` |
| Interactive web automation | `orca snapshot`, `orca click --element @e#`, `orca fill` |
| Visual UI evidence / screenshot | `orca screenshot --format png` |
| Browser session / persistent login | `orca tab profile list/set/create` |
| Isolated task sandbox | `orca worktree create --name <name> --json` |
| Inspect active checkouts | `orca worktree list --json`, `orca worktree ps --json` |
| Review visual diffs before merge | `orca file open-changed --mode diff`, `orca file diff <path>` |
| Clean up task workspace | `orca worktree rm --worktree <selector> --json` |
| Non-blocking process execution | `orca terminal create --command <cmd> --json` |
| Monitor long-running task | `orca terminal read --terminal <handle> --json` |
| Deliver input to interactive CLI | `orca terminal send --terminal <handle> --text <text> --enter` |
| Herdr worker containment | `orca worktree create` + `orca terminal create` for Herdr worker dispatch |
| Herdr visual review gate | `orca file diff` + `orca tab create` for artifact verification |

Capability discovery rules:
- **Runtime status**: Always check `orca status --json` before browser or terminal commands if the connection state is unverified.
- **Browser state**: Tab operations require an active tab or explicit `--page <id>`. Element refs (`@e1`, `@e2`) from `orca snapshot` expire upon page navigation; always take a fresh snapshot after clicks or URL changes.
- **Worktree hygiene**: An Orca worktree is a real Git checkout. Creating one creates an independent directory and branch; removing it without `--force` ensures uncommitted work is not accidentally destroyed.
- **Herdr alignment**: Coordination defaults to the current Git checkout unless the User authorizes an isolated Orca worktree sandbox for multi-worker parallel execution.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before executing commands.
Keep it small: declare only the specific Orca sub-commands and Herdr connections
relevant to the current turn.

**Completion criterion**: every row has a real Orca command or Herdr capability,
a task-specific purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Run pre-check: verify runtime connectivity (`orca status --json`) or tab state (`orca tab list --json`).
2. Execute the authorized command sequence with `--json` for structured output.
3. Verify with observable evidence: JSON status response, evaluated DOM value, snapshot diff, terminal buffer read, or file diff.
4. Clean up disposable resources (close temporary browser tabs, terminate stopped terminals, remove completed task worktrees).
5. Report executed commands, observed state, changed paths, and any limitations.

**Completion criterion**: the outcome is verified by observable runtime output
and every declared capability is accounted for.

## Loading Model: Native Tool vs Browser vs Worktree vs Herdr

| Layer | What it is | How it operates | Proof of readiness |
| :--- | :--- | :--- | :--- |
| Orca CLI Host | `orca.exe` process | Local CLI calling Orca local RPC socket | `orca status --json` returns `reachable: true` |
| Browser Engine | Embedded Chromium host | `orca tab`, `snapshot`, `click`, `eval` | Active tab listed in `orca tab list --json` |
| Worktree Sandbox | Isolated Git worktree | `orca worktree create/rm/set` | Worktree listed in `orca worktree list --json` |
| Terminal Multiplexer | Headless PTY terminal pane | `orca terminal create/read/send/wait` | Active terminal handle in `orca terminal list` |
| Herdr Coordination | Multi-agent dispatch | Herdr worker launched in Orca worktree/terminal | Settled worker receipt + `orca file diff` review |

## Herdr Worker Coordination via Orca ADE

When Bale coordinates independent Herdr workers within an Orca ADE environment:

1. **Sandbox Allocation**:
   - For complex, destructive, or competing multi-agent tasks, create an isolated worktree:
     ```bash
     orca worktree create --name herdr-<task-id> --json
     ```
   - This provides an isolated branch and directory, leaving the primary checkout untouched.
2. **Worker Launch**:
   - Spawn the Herdr worker inside an Orca terminal pane scoped to that worktree:
     ```bash
     orca terminal create --worktree <selector> --command "herdr launch --kind <kind> ..." --json
     ```
3. **Receipt-First Observation**:
   - Use `orca terminal read` or Herdr's native receipt checks to observe worker completion.
4. **Bale Visual Review**:
   - Inspect the worker's changes via `orca file open-changed --mode diff --worktree <selector>`.
   - If the worker created web assets, verify visually via `orca tab create --url <preview-url>`.
5. **Settlement & Cleanup**:
   - Merge or cherry-pick verified commits into the base branch, then safely prune the worktree:
     ```bash
     orca worktree rm --worktree <selector> --json
     ```

## Anti-Patterns

- Running `orca` sub-commands before declaring the `Selected Orca ADE Capabilities` table.
- Assuming an element ref (`@e1`, `@e2`) remains stable after a click, navigation, or form submission without taking a fresh `orca snapshot`.
- Failing to pass `--json` on Orca CLI calls, producing unstructured text that is difficult to parse reliably.
- Leaving temporary browser tabs or unused worktrees open after task completion.
- Launching an unconstrained Herdr worker into the primary checkout when the task required an isolated Orca worktree sandbox.
- Claiming web or browser automation success without inspecting the evaluated JS return value or snapshot output.
