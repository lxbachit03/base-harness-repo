# Herdr runtime

Use installed `herdr --version`, `herdr --help` and relevant `--help` output as
the syntax authority. Do not invoke bare `herdr` or an incomplete mutation for
discovery. Herdr is a terminal transport, not an authorization or task scheduler.

## Bind and launch

1. Check HARNESS_ROLE and the explicit session role first. Workers do not bind
   Bale. For a primary session require HERDR_ENV=1 and HERDR_PANE_ID; query
   `herdr agent get <current-pane>` and verify its cwd/identity. Query `agent get
   bale`; rename only the current agent when that name is free, or retain it when
   already bound to the same terminal. Do not take another terminal's alias.
2. Record the current pane/terminal, repo baseline and owned trial paths. Create
   each worker workspace with explicit cwd and `--no-focus --env HARNESS_ROLE=worker`.
   Parse the returned root pane ID; never predict IDs. Record creation output
   before the next mutation. On Windows verify cwd at launch; later shell `cd`
   tracking may be incomplete. Use a task-owned directory/worktree for writers.
   For full-access workers, prefer a task-owned detached worktree when the scope
   is broader than an explicitly authorized output root; a narrowly scoped main
   checkout may be reused only with User authority for that write boundary.
   Keep product output roots separate from coordinator packet and receipt files.
3. For a new launch or worker-model change, read
   [`docs-harness/HERDR-AGENTS.md`](../../../../docs-harness/HERDR-AGENTS.md)
   and select exactly one model. For an unchanged reassignment, use the
   recorded catalog hash and configuration evidence and reread only on drift.
   Then use only the effort and Fast checklists
   nested under that model, selecting one value in each checklist that exists.
   Omit unsupported settings when the catalog explicitly omits that section.
   If a catalog entry lists multiple provider model IDs, resolve and record the
   exact ID in the attempt packet; do not infer an ID from the selected effort
   unless the catalog explicitly maps them.
   Launch with the resulting configuration's verified Herdr adapter. The
   current repository path is
   `herdr agent start <unique-name> --kind codex --pane <returned-id>`; profiles using
   another provider are not dispatchable through that command unless a
   compatible adapter has been proven. For a Codex profile, pass its exact
   values after `--`, including the User-authorized full-access form, using
   this shape (replace every placeholder from the selected profile):

   ```text
   herdr agent start <unique-name> --kind codex --pane <returned-id> -- \
     --dangerously-bypass-approvals-and-sandbox \
     -m <selected-model-id> \
     -c developer_instructions="HARNESS_ROLE=worker. Execute the assigned bounded task. Do not spawn agents or claim Bale. Return evidence to the coordinator."
   ```

   The arguments after Herdr's `--` are passed unchanged to Codex. The
   full-access YOLO flag is intentionally process-scoped:

   ```text
   --dangerously-bypass-approvals-and-sandbox
   --yolo                         # alias only when local `codex --help` exposes it; choose one form
   ```

   The equivalent auditable pair is also process-scoped:

   ```text
   --sandbox danger-full-access
   --ask-for-approval never
   ```

   Add the model and worker instructions as normal Codex arguments:

   ```text
   -m <selected-model-id>
   -c developer_instructions="HARNESS_ROLE=worker. Execute the assigned bounded task. Do not spawn agents or claim Bale. Return evidence to the coordinator."
   ```

   When the selected model has an effort checklist, add its checked value:

   ```text
   -c model_reasoning_effort="<selected-effort>"
   ```

   When the selected model has a Fast mode checklist, add the provider's
   service-tier and Fast-mode settings:

   ```text
   -c service_tier="<selected-service-tier>"
   -c features.fast_mode=<selected-fast-mode>
   ```

   Omit or translate settings only when the selected provider's documented
   adapter requires a different form, and record the equivalent effective
   values. Never pass a non-Codex model ID to `--kind codex`. Use exactly one
   Codex full-access form (YOLO or the equivalent pair); do not pass both.
   Record the trusted task worktree or external sandbox because YOLO removes
   the local filesystem/network boundary.
   Before submission, run `codex plugin list` and `codex mcp list` in the same
   `CODEX_HOME` context and record the redacted capability inventory. Full
   local access does not install or authenticate plugins/MCP servers.

   For Antigravity, record the native execution mode, the Fast/standard
   indicator, terminal-sandbox setting, `allowNonWorkspaceAccess`, and the
   applicable deny/managed rules once in configuration evidence. Treat a status
   label such as `OFF` as standard only when the installed CLI/version mapping
   proves that interpretation. A reused worker may carry forward this evidence
   only when its pane/process, cwd/worktree and configuration hash are unchanged.

   Provider-specific permission adapters are only provisional until the
   dispatcher accepts that provider and native proof is captured:

   ```text
   herdr agent start <unique-name> --kind agy --pane <returned-id> -- \
     --dangerously-skip-permissions \
     --model <selected-model-id> \
     --effort <selected-effort>

   herdr agent start <unique-name> --kind claude --pane <returned-id> -- \
     --dangerously-skip-permissions \
     --model <selected-model-id> \
     --effort <selected-effort>
   ```

   For Antigravity, omit `--sandbox` and ensure its settings do not enable the
   terminal sandbox when host-level access is intended; `allowNonWorkspaceAccess`
   and deny/managed rules must also permit the scope. For Claude,
   `--permission-mode bypassPermissions` is the equivalent explicit form, but a
   Claude OS sandbox still remains a separate boundary. Neither request
   overrides provider deny/managed rules, authentication, or MCP policy. Do not
   use `--bare` for Claude when inheriting plugins, skills or MCP is required.
   The current repository's complete permission/capability proof is Codex-only;
   a bounded Antigravity calculator task has exercised the local transport, but
   its provider settings proof is still incomplete. Do not dispatch another
   Antigravity profile until its adapter and capability inventory are independently
   proven. Record the attempt and target identity manually in the coordinator
   task record; no repository helper enforces this boundary.
   Use an argument array, not a shell-built string containing a prompt. Match
   the task-owned worktree and inherited authority; keep global config intact.
   `agent start` requires an available shell pane. Inspect a startup failure in
   that same pane before deciding whether another launch is safe.
   Include the absolute task cwd in the worker's launch instructions. Require
   explicit tool working-directory arguments for shell calls and a first-call
   cwd check; shell profiles can otherwise start tools outside the advertised
   agent cwd. Correct that mismatch before file searches or writes.
4. After start, passively read the visible screen and requery lifecycle before
   sending input. The tested preview can report ready before Codex's trust UI
   appears. Never use a prompt (even `/status`) to probe an uninspected startup
   screen: its Enter can confirm a dialog. Inspect trust effects first; when
   global changes are excluded, use an isolated worktree of an already-trusted
   repository or pause. Per-process trust overrides did not suppress onboarding
   in the initial trial and are not a verified workaround.
   Before work, capture the real session's `/status`, `/permissions`, and
   `/fast status` (when Fast exists), or equivalent native configuration views.
   An unchanged reused worker may carry forward those captured views after a
   lifecycle, identity and cwd/worktree check; recapture on process or config drift.
   Check the selected model, any scoped effort/speed values, full-access mode,
   and approval policy are effective rather than merely present in a requested
   command. Record native session ID where available. If output cannot establish
   the selected settings, permission state, capability inventory, or adapter,
   pause task submission and report the missing proof. Do not ask the model to
   infer its own configuration as evidence. The first worker call must also
   report its effective `HARNESS_ROLE` and cwd. For a tight handoff, do not
   reread the full catalog or repeat unchanged capability discovery; the
   coordinator's resolved configuration evidence is the source of truth.

## Read and wait

`agent prompt` accepts text and presses Enter. `agent read` returns terminal text,
while creation/get/wait operations return JSON. For a tight handoff, use one
bounded `agent prompt ... --wait --until done --timeout 60000` call after startup
proof. `agent wait --timeout 30000` is bounded; repeat observations of the same
handle only after a timeout or ambiguous result. `blocked`
means a recognized input UI, not permission to approve it. Inspect the dialog
and resolve only already-authorized operations; otherwise preserve the session
and ask for the missing decision. Use deliberate keys only after that inspection.

Herdr does not identify individual turns. A wait may be satisfied by earlier work;
matching task/attempt receipts and actual acceptance checks establish completion.
`pane wait-output` may match old text immediately. An unknown state or a read
error is not terminal failure. Use receipt-first observation: on a settled success,
inspect the matching receipt and output files, then finish the proportional
acceptance check without calling `agent read`. When the receipt, lifecycle state
or artifacts are ambiguous, fetch one bounded recent snapshot instead:

```text
herdr agent read <TARGET> --source recent --lines 80 --format text
```

If that snapshot cannot resolve the ambiguity, keep the attempt pending and
report the missing evidence. Full or unbounded transcript reads are
incident-only and require explicit User authority. The installed `agent prompt
--help` has no `--quiet` option, so retain only its state/exit evidence in the
coordinator ledger and do not replay terminal prose into the context. Large
transcript reads may be unavailable while working.

On the tested Windows preview, `agent prompt` sometimes left the exact text in
Codex's input composer without starting a turn. After passively confirming that
the intended prompt is still in the composer, the agent is idle, and no dialog
is present, record and send one deliberate `agent send-keys <target> enter`.
This submits the existing input; do not send the prompt again. Reobserve the
same handle. If input or delivery is ambiguous, pause input and investigate.
Before sending, Bale checks caller ownership and target identity, records the
intended pane, and then verifies the returned terminal identity. Herdr has no
demonstrated atomic compare-and-send lease: retain exclusive control of owned
worker panes and reconcile any identity change as uncertain delivery, not
successful work. No repository helper performs these checks.

## Version and platform evidence

The initial trial environment was Windows PowerShell, Herdr
0.7.5-preview.2026-07-21-0f10e1453a7f and Codex CLI 0.153.4. This is a tested
baseline only after the linked improvement record contains successful proof;
recheck commands and configuration in a different environment.

- [Upstream skill v0.8.2](https://github.com/herdrdev/herdr/blob/v0.8.2/skills/herdr/SKILL.md)
- [Windows support](https://herdr.dev/docs/windows-beta/)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)
- [Codex permissions](https://learn.chatgpt.com/docs/permissions)
- [Codex sandboxing](https://learn.chatgpt.com/docs/sandboxing)
- [Codex agent approvals and security](https://learn.chatgpt.com/docs/agent-approvals-security)
- [Codex MCP](https://learn.chatgpt.com/docs/extend/mcp)
- [Codex plugins](https://learn.chatgpt.com/docs/plugins)
- [Codex Fast mode](https://learn.chatgpt.com/docs/agent-configuration/speed)
- [OpenAI model catalog](https://developers.openai.com/api/docs/models)
- [Antigravity permissions](https://antigravity.google/docs/cli/permissions/)
- [Antigravity sandbox](https://antigravity.google/docs/cli/sandbox/)
- [Antigravity headless CLI](https://antigravity.google/docs/cli/headless/)
- [Claude Code CLI](https://code.claude.com/docs/en/cli-usage)
- [Claude Code permissions](https://code.claude.com/docs/en/permissions)

Upstream docs are references, not a reason to upgrade a running server. Changes
to installation, global config or unrelated panes need their own authority.
