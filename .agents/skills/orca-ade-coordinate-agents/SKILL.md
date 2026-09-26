---
name: orca-ade-coordinate-agents
description: Coordinate independent coding agent sessions purely through Orca ADE as a control plane using Git worktree sandboxing, terminal multiplexing, and Hub-and-Spoke artifact relay. Use when orchestrating multiple agents, workers, or parallel tasks without Herdr.
---

# Orca ADE Agent Coordination

Coordinate independent AI worker sessions purely through the Orca ADE control plane (`orca.exe`). AGENTS.md owns task authority and session boundaries. This skill owns Orca ADE multi-agent orchestration without Herdr dependencies.

When coordinating workers:
- **Sandbox Isolation**: Every write-capable worker runs in an independent Git worktree created via `orca worktree create`. The coordinator's primary checkout stays untouched.
- **Hub-and-Spoke Communication**: Workers operate independently in their own PTY terminals and do not communicate peer-to-peer. The Coordinator dispatches tasks, reads outputs/receipts, and relays context between workers.
- **Terminal Multiplexing**: Background tasks run in dedicated PTY panes created via `orca terminal create`, monitored via `orca terminal read` and `orca terminal wait`.
- **Visual Review Gate**: Review changes through Orca's Monaco Diff editor (`orca file open-changed --mode diff`) and test web outputs in Orca's Chromium browser (`orca tab create`).
- **Settlement & Teardown**: Upon task completion, terminals are closed and worktree sandboxes are pruned safely via `orca worktree rm --force`.

For exact CLI arguments, JSON payload schemas, and error handling, consult [`references/coordination-protocol.md`](references/coordination-protocol.md).

## Workflow

```text
1. Allocate Worktree Sandboxes (`orca worktree create`)
   ↓
2. Spawn Terminal Panes (`orca terminal create`)
   ↓
3. Dispatch Tasks & Observe (`orca terminal send` / `read` / `wait`)
   ↓
4. Hub-and-Spoke Relay (Coordinator routes Worker 1 artifacts to Worker 2)
   ↓
5. Visual Review & Browser Verification (`orca file open-changed` / `orca tab create`)
   ↓
6. Settlement & Safe Teardown (`orca terminal close` / `orca worktree rm`)
```

### 1. Allocate Worktree Sandboxes

For every worker requiring write capabilities or experimental execution, create an isolated Git worktree:

```bash
orca worktree create --name <worker-task-id> --json
```

Capture the returned `result.worktree.path`, `id`, and `branch`. Confirm the primary working directory remains untouched.

**Completion criterion**: An isolated directory and branch exist for each worker, registered in `orca worktree list --json`.

### 2. Spawn Multiplexer Terminal Panes

Create dedicated terminal panes bound to the target worktree:

```bash
orca terminal create --worktree <selector> --title "<worker-name>" --json
```

Record the returned `result.terminal.handle` (e.g. `term_xxx`). Use this handle for all subsequent command delivery and observation.

**Completion criterion**: A live, writable PTY terminal handle is recorded for the target worktree.

### 3. Dispatch Tasks & Observe

Deliver structured tasks to the worker terminal:

```bash
orca terminal send --terminal <handle> --text "<command-or-prompt>" --enter --json
```

Observe progress without blocking the coordinator:
- Read recent output: `orca terminal read --terminal <handle> --json`
- Wait for process or turn completion: `orca terminal wait --terminal <handle> --for exit --timeout-ms <ms> --json` (or `--for tui-idle` for interactive agents).

Require each worker to emit a structured artifact (e.g. `receipt.json` or task output) upon finishing its turn.

**Completion criterion**: Worker execution finishes cleanly, confirmed by terminal output and artifact presence on disk.

### 4. Hub-and-Spoke Relay

When Worker B requires context or artifacts produced by Worker A:
1. The Coordinator inspects Worker A's artifact in Worker A's worktree sandbox.
2. The Coordinator packages the necessary data payload into Worker B's task packet.
3. The Coordinator delivers the packet to Worker B's terminal handle via `orca terminal send`.

Workers never communicate directly; the Coordinator enforces contract boundaries, data validation, and task sequencing.

**Completion criterion**: Worker B receives verified context from Worker A through the Coordinator and successfully consumes it.

### 5. Visual Review & Browser Verification

Apply the review gate before accepting worker outputs:
- **Code & Text Changes**: Open Monaco Diff viewer in Orca:
  ```bash
  orca file open-changed --worktree <selector> --mode diff --json
  ```
- **Web Applications & UIs**: Test live in Orca's embedded Chromium browser:
  ```bash
  orca tab create --url "<preview-url>" --json
  ```
  Verify DOM elements via `orca eval` or inspect UI state via `orca snapshot`. Close the tab when finished: `orca tab close --page <id> --json`.

**Completion criterion**: All worker diffs and rendered artifacts are visually inspected and verified against the task specification.

### 6. Settlement & Safe Teardown

After accepted changes are integrated or recorded:
1. Terminate all worker terminal tabs:
   ```bash
   orca terminal close --terminal <handle> --tab --json
   ```
2. Safely prune disposable worktrees:
   ```bash
   orca worktree rm --worktree <selector> --force --json
   ```
3. Verify that `orca worktree list --json` retains only the main repository checkout and `git status` on the primary checkout is clean.

**Completion criterion**: All temporary terminals and worktree sandboxes are pruned; no orphaned processes or stray branches remain.
