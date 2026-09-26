# Orca ADE Coordination Protocol Reference

Technical reference for multi-agent coordination via Orca ADE CLI (`orca.exe`), calibrated to v1.4.212 on Windows.

## 1. Worktree Sandbox Management

### Allocation
```bash
orca worktree create --name <task-slug> --json
```
- Creates an isolated Git worktree under `%USERPROFILE%/orca/workspaces/<repo>/<task-slug>`.
- Creates a dedicated branch `refs/heads/<task-slug>` branched from the repository's base ref.
- Parse `result.worktree.path`, `result.worktree.id`, and `result.worktree.instanceId`.
- Always pass `--json` for machine-readable output.

### Inspection
```bash
orca worktree list --json
orca worktree show --worktree <selector> --json
```
- `<selector>` can be `name:<displayName>`, `branch:<branch>`, `path:<path>`, or `id:<repo-id>::<path>`.

### Teardown
```bash
orca worktree rm --worktree <selector> --force --json
```
- Always pass `--force` to remove experimental branches without blocking on merge state.
- If repo-defined archive hooks fail, specify `--allow-failed-archive-hook` only when authorized.

---

## 2. Terminal Multiplexing Operations

### Creation
```bash
orca terminal create --worktree <selector> --title "<label>" --json
```
- Spawns a PTY terminal tab within the specified worktree context.
- On Windows, default shell is PowerShell (`powershell.exe`). Use `--shell cmd.exe` or `--shell pwsh.exe` when needed.
- Capture `result.terminal.handle` (e.g. `term_xxx`).

### Input Delivery
```bash
orca terminal send --terminal <handle> --text "<command>" --enter --json
```
- `--enter` automatically appends carriage return.
- **PTY Formatting Warning**: Avoid streaming large multiline blocks with nested double quotes directly into PowerShell PTY prompts. Instead:
  1. Use single-quoted one-liners with escaped quotes; or
  2. Write commands to a temporary script file inside the worktree and execute the script.
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
|     Worker 1 Sandbox          |   |     Worker 2 Sandbox          |
| Worktree: orca-worker-1       |   | Worktree: orca-worker-2       |
| Terminal: term_1              |   | Terminal: term_2              |
| Artifact: producer-data.json  |   | Artifact: consumer-report.md  |
+-------------------------------+   +-------------------------------+
```

### Protocol Steps:
1. **Task Dispatch**: Coordinator issues task packet to Worker 1 in `term_1`.
2. **Artifact Generation**: Worker 1 finishes and writes a verifiable JSON artifact (e.g., `<worktree-1>/docs/evaluations/output.json`).
3. **Artifact Ingestion**: Coordinator reads the artifact from Worker 1's worktree filesystem.
4. **Context Transformation**: Coordinator parses, validates, and incorporates Worker 1's data into Worker 2's prompt/script.
5. **Downstream Delivery**: Coordinator sends the transformed task packet to Worker 2 in `term_2`.
6. **Downstream Verification**: Worker 2 reads the input and produces the final deliverable.

---

## 4. Visual Review & Browser Gates

### Monaco Diff Review
```bash
orca file open-changed --worktree <selector> --mode diff --json
```
- Opens modified files in Orca's integrated Monaco editor in `diff` mode.
- Inspect `result.opened` to verify modified files match the authorized scope.

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
| `worktree_archive_hook_failed` | Repo-defined archive hook failed on worktree removal | Pass `--allow-failed-archive-hook` with `--force` if the hook failure is non-blocking. |
| Browser `eval` timeout on `file://` | Local file URL security boundary in Chromium host | Serve via local HTTP server (e.g. `npx serve`) or evaluate DOM on served URLs. |
| Orphaned terminal processes | Workspace deleted before closing terminals | Always call `orca terminal close --tab` prior to `orca worktree rm`. |
