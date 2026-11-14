---
name: utilizing-tools-orca-ade
description: Select and execute effective combinations of Orca ADE CLI tools, browser automation, worktrees, and terminal multiplexing for a task. Use when asked to leverage Orca ADE tools, browser, worktrees, or terminals effectively, with a mandatory capability declaration table and seamless execution.
---

# Utilizing Orca ADE Tools, Browser Automation, Worktrees & Terminals

Select the smallest effective combination of Orca ADE capabilities, declare it,
execute it, and leave observable proof. The local Orca runtime and exposed CLI
commands (`orca.exe`) are the runtime authority; this skill routes to them and
never promises that a documented feature is enabled or running.

Version boundary: calibrated to Orca `1.4.212` local runtime evidence on
Windows. When local CLI behavior differs from newer docs, the local runtime wins
for this machine; report the gap instead of silently assuming either.

docs-harness/SESSION.md owns task authority and persistent permissions. Inspect the effects
of an unfamiliar command before running it.

## Mandatory Response Contract

When this skill triggers, begin the response with a concise Markdown table
before calling tools, then continue directly into execution:

```markdown
### Selected Orca ADE Capabilities
| Tool / CLI / Browser / Worktree / Terminal | Purpose in this task | Target scope |
| :--- | :--- | :--- |
| `<actual_command_or_capability>` | `<concise rationale>` | `<urls, worktrees, terminals, or repo scope>` |
```

Use actual exposed commands and parameters. If an in-browser task is selected,
name the exact sub-commands (`orca tab`, `orca snapshot`, `orca click`, `orca eval`).
For a task using a worktree or terminal, declare its commands and target scope.
If no external Orca capability is
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
| Separate worktree (only on an explicit User request; never for agent coordination) | `orca worktree create --name <name> --json` |
| Inspect active checkouts | `orca worktree current --json`, `orca worktree list --json`, `orca worktree ps --json` |
| Review visual diffs | `orca file open-changed --mode diff`, `orca file diff <path>` |
| Remove a User-requested worktree | `orca worktree rm --worktree <selector> --json` |
| Non-blocking process execution | `orca terminal create --command <cmd> --json` |
| Monitor long-running task | `orca terminal read --terminal <handle> --json` |
| Deliver input to interactive CLI | `orca terminal send --terminal <handle> --text <text> --enter` |

Capability discovery rules:
- **Runtime status**: Always check `orca status --json` before browser or terminal commands if the connection state is unverified.
- **Browser state**: Tab operations require an active tab or explicit `--page <id>`. Element refs (`@e1`, `@e2`) from `orca snapshot` expire upon page navigation; always take a fresh snapshot after clicks or URL changes.
- **Worktree hygiene**: An Orca worktree is a real Git checkout. Creating one creates an independent directory and branch; removing it without `--force` ensures uncommitted work is not accidentally destroyed.

### Phase 2: Mandatory Declaration

Render the declaration table at the top of the response before executing commands.
Keep it small: declare only the specific Orca sub-commands and connections
relevant to the current turn.

**Completion criterion**: every row has a real Orca command or capability,
a task-specific purpose, and a bounded target scope.

### Phase 3: Execute & Verify

1. Run pre-check: verify runtime connectivity (`orca status --json`) or tab state (`orca tab list --json`).
2. Execute the authorized command sequence with `--json` for structured output.
3. Verify with observable evidence: JSON status response, evaluated DOM value, snapshot diff, terminal buffer read, or file diff.
4. Clean up disposable resources (close temporary browser tabs, terminate stopped terminals).
5. Report executed commands, observed state, changed paths, and any limitations.

**Completion criterion**: the outcome is verified by observable runtime output
and every declared capability is accounted for.

## Loading Model: Native Tool vs Browser vs Worktree vs Terminal

| Layer | What it is | How it operates | Proof of readiness |
| :--- | :--- | :--- | :--- |
| Orca CLI Host | `orca.exe` process | Local CLI calling Orca local RPC socket | `orca status --json` returns `reachable: true` |
| Browser Engine | Embedded Chromium host | `orca tab`, `snapshot`, `click`, `eval` | Active tab listed in `orca tab list --json` |
| Worktree Sandbox (User request only; never for agent coordination) | Isolated Git worktree | `orca worktree create/rm/set` | Worktree listed in `orca worktree list --json` |
| Terminal Multiplexer | Headless PTY terminal pane | `orca terminal create/read/send/wait` | Active terminal handle in `orca terminal list` |

## Anti-Patterns

- Running `orca` sub-commands before declaring the `Selected Orca ADE Capabilities` table.
- Assuming an element ref (`@e1`, `@e2`) remains stable after a click, navigation, or form submission without taking a fresh `orca snapshot`.
- Failing to pass `--json` on Orca CLI calls, producing unstructured text that is difficult to parse reliably.
- Leaving temporary browser tabs, terminals, or unused worktrees open after task completion.
- Claiming web or browser automation success without inspecting the evaluated JS return value or snapshot output.
