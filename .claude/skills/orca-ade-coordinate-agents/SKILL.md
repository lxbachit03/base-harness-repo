---
name: orca-ade-coordinate-agents
description: Coordinate independent coding agent sessions through Orca ADE as the control plane, using terminal panes on the current checkout and Hub-and-Spoke artifact relay. Use when the User explicitly selects Orca coordination for multiple agents, workers, or parallel tasks.
---

# Orca ADE Agent Coordination

Coordinate independent AI worker sessions through the Orca ADE control plane (`orca.exe`). AGENTS.md owns task authority and session boundaries. This skill owns Orca ADE multi-agent orchestration without Herdr dependencies.
Use it only when the User explicitly selects Orca coordination for the task;
otherwise coordination follows `herdr-coordinate-agents`.

Every worker runs on the coordinator's current checkout and branch. Never
create or select a Git worktree, detached checkout, or clone for coordination
(User decision 2026-10-05).

When coordinating workers:
- **Shared checkout**: Give each worker explicit allowed paths. Serialize write-capable workers; run workers in parallel only for read-only work or provably disjoint output paths.
- **Hub-and-Spoke Communication**: Workers operate independently in their own PTY terminals and do not communicate peer-to-peer. The Coordinator dispatches tasks, reads outputs/receipts, and relays context between workers.
- **Terminal Multiplexing**: Workers and background tasks run in dedicated PTY panes created via `orca terminal create`, monitored via `orca terminal read` and `orca terminal wait`.
- **Visual Review Gate**: Review changes through Orca's Monaco Diff editor (`orca file open-changed --mode diff`) and test web outputs in Orca's Chromium browser (`orca tab create`).
- **Settlement & Teardown**: Upon task completion, terminals are closed and the checkout's `git status` is compared with its starting state.

For exact CLI arguments, JSON payload schemas, and error handling, consult [`references/coordination-protocol.md`](references/coordination-protocol.md).

## Workflow

### 1. Record the starting state and assign ownership

Record the current branch and `git status` of the checkout, and resolve its
Orca selector with `orca worktree current --json` (inspection only). Assign
each worker its allowed output paths and decide which writers run in sequence.

**Completion criterion**: The starting state, the checkout selector, and every worker's owned paths and order are recorded.

### 2. Spawn Multiplexer Terminal Panes

Create dedicated terminal panes on the current checkout:

```bash
orca terminal create --worktree <current-checkout-selector> --title "<worker-name>" --json
```

Record the returned `result.terminal.handle` (e.g. `term_xxx`). Use this handle for all subsequent command delivery and observation.

**Completion criterion**: A live, writable PTY terminal handle on the current checkout is recorded for each worker.

### 3. Dispatch Tasks & Observe

Deliver structured tasks to the worker terminal:

```bash
orca terminal send --terminal <handle> --text "<command-or-prompt>" --enter --json
```

Observe progress without blocking the coordinator:
- Read recent output: `orca terminal read --terminal <handle> --json`
- Wait for process or turn completion: `orca terminal wait --terminal <handle> --for exit --timeout-ms <ms> --json` (or `--for tui-idle` for interactive agents).

Require each worker to emit a structured artifact (e.g. `receipt.json` or task output) inside its owned paths upon finishing its turn.

**Completion criterion**: Worker execution finishes cleanly, confirmed by terminal output and artifact presence on disk.

### 4. Hub-and-Spoke Relay

When Worker B requires context or artifacts produced by Worker A:
1. The Coordinator inspects Worker A's artifact in Worker A's owned paths.
2. The Coordinator packages the necessary data payload into Worker B's task packet.
3. The Coordinator delivers the packet to Worker B's terminal handle via `orca terminal send`.

Workers never communicate directly; the Coordinator enforces contract boundaries, data validation, and task sequencing.

**Completion criterion**: Worker B receives verified context from Worker A through the Coordinator and successfully consumes it.

### 5. Visual Review & Browser Verification

Apply the review gate before accepting worker outputs:
- **Code & Text Changes**: Open Monaco Diff viewer in Orca and check every change against the worker's owned paths:
  ```bash
  orca file open-changed --mode diff --json
  ```
- **Web Applications & UIs**: Test live in Orca's embedded Chromium browser:
  ```bash
  orca tab create --url "<preview-url>" --json
  ```
  Verify DOM elements via `orca eval` or inspect UI state via `orca snapshot`. Close the tab when finished: `orca tab close --page <id> --json`.

**Completion criterion**: All worker diffs and rendered artifacts are visually inspected and verified against the task specification and owned paths.

### 6. Settlement & Teardown

After accepted changes are verified:
1. Terminate all worker terminal tabs:
   ```bash
   orca terminal close --terminal <handle> --tab --json
   ```
2. Compare the checkout's `git status` with the starting state: only accepted changes inside owned paths may remain. Staging and commits follow AGENTS.md task authority.

**Completion criterion**: All worker terminals are closed and every change in the checkout is either an accepted change inside an owned path or an out-of-scope change reported to the User and left for their decision.
