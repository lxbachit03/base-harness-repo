# Orca ADE Coordination Protocol Reference

Technical reference for multi-agent coordination via Orca ADE CLI (`orca.exe`), calibrated to v1.4.212 on Windows. All coordination runs on the coordinator's current checkout and branch; never create or select a Git worktree, detached checkout or clone for coordination.

## 1. Current Checkout Selector

### Inspection (read-only)
```bash
orca worktree current --json
orca worktree list --json
```
- Orca addresses the checkout itself as a worktree; use the current one's selector for terminals.
- `<selector>` can be `name:<displayName>`, `branch:<branch>`, `path:<path>`, or `id:<repo-id>::<path>`.
- Always pass `--json` for machine-readable output.

---

## 2. Terminal Multiplexing Operations

### Creation
```bash
orca terminal create --worktree <current-checkout-selector> --title "<label>" --json
```
- Spawns a PTY terminal tab on the current checkout.
- On Windows, default shell is PowerShell (`powershell.exe`). Use `--shell cmd.exe` or `--shell pwsh.exe` when needed.
- Capture `result.terminal.handle` (e.g. `term_xxx`).

### Input Delivery
```bash
orca terminal send --terminal <handle> --text "<command>" --enter --json
```
- `--enter` automatically appends carriage return.
- **PTY Formatting Warning**: Avoid streaming large multiline blocks with nested double quotes directly into PowerShell PTY prompts. Instead:
  1. Use single-quoted one-liners with escaped quotes; or
  2. Write commands to a temporary script file in the worker's owned paths and execute the script.
- Send `--interrupt` to cancel long-running foreground commands.

### Observation & Buffer Reading
```bash
orca terminal read --terminal <handle> --limit 100 --json
```
- Returns `result.terminal.tail` as an array of recent output lines.
- `result.terminal.status` reports `running` or terminal lifecycle.

### Turn Synchronization
```bash
orca terminal wait --terminal <handle> --for exit --timeout-ms 60000 --json
orca terminal wait --terminal <handle> --for tui-idle --timeout-ms 60000 --json
```
- `--for exit`: wait for background build/test scripts to terminate.
- `--for tui-idle`: wait for interactive AI agent TUIs to settle after processing a turn.

### Termination
```bash
orca terminal close --terminal <handle> --tab --json
```
- Closes the terminal pane and durable UI tab.

---

## 3. Hub-and-Spoke Relay Architecture

Workers do not have inter-process communication channels or shared memory. All cross-worker communication follows the Hub-and-Spoke topology:

```text
               +-----------------------------+
               |         COORDINATOR         |
               | (Bale / Native AI Assistant)|
               +-----------------------------+
                   /                       \
        1. Dispatch task               3. Relay artifact
        2. Read artifact               4. Await result
                 /                           \
                v                             v
+-------------------------------+   +-------------------------------+
|     Worker 1 (shared checkout)|   |     Worker 2 (shared checkout)|
| Owned path: out/worker-1/     |   | Owned path: out/worker-2/     |
| Terminal: term_1              |   | Terminal: term_2              |
| Artifact: producer-data.json  |   | Artifact: consumer-report.md  |
+-------------------------------+   +-------------------------------+
```

### Protocol Steps:
1. **Task Dispatch**: Coordinator issues task packet to Worker 1 in `term_1`.
2. **Artifact Generation**: Worker 1 finishes and writes a verifiable JSON artifact inside its owned path.
3. **Artifact Ingestion**: Coordinator reads the artifact from that path.
4. **Context Transformation**: Coordinator parses, validates, and incorporates Worker 1's data into Worker 2's prompt/script.
5. **Downstream Delivery**: Coordinator sends the transformed task packet to Worker 2 in `term_2`.
6. **Downstream Verification**: Worker 2 reads the input and produces the final deliverable in its owned path.

Writers that share files run one after another; parallel workers need read-only work or disjoint owned paths.

---

## 4. Visual Review & Browser Gates

### Monaco Diff Review
```bash
orca file open-changed --mode diff --json
```
- Opens modified files in Orca's integrated Monaco editor in `diff` mode.
- Inspect `result.opened` to verify modified files match the workers' owned paths.

### Embedded Chromium Browser Verification
```bash
orca tab create --url "<url>" --json
```
- Returns `result.browserPageId`.
- To evaluate client-side JavaScript or DOM state:
  ```bash
  orca eval --page <browserPageId> --expression "<js-expression>" --json
  ```
- To capture the accessibility tree:
  ```bash
  orca snapshot --page <browserPageId>
  ```
- To close the tab:
  ```bash
  orca tab close --page <browserPageId> --json
  ```

---

## 5. Error Recovery & Edge Cases

| Error / Failure State | Root Cause | Recovery Procedure |
| :--- | :--- | :--- |
| `invalid_argument: Unknown command` | Space/quote splitting in CLI shell arguments | Wrap `--text` in outer double quotes and use simple single-quoted strings inside. |
| Terminal buffer output truncated | Output exceeded default buffer limit | Use `orca terminal read --limit 200` or pipe long output to a file. |
| Browser `eval` timeout on `file://` | Local file URL security boundary in Chromium host | Serve via local HTTP server (e.g. `npx serve`) or evaluate DOM on served URLs. |
| Change outside a worker's owned paths | Worker wrote beyond its assignment | Stop dispatching to that worker, report the change, and leave it for the User or a correction; do not discard it silently. |
| Orphaned terminal processes | Session ended before closing terminals | Always call `orca terminal close --tab` before ending the coordination. |
