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
3. Launch with `agent start <unique-name> --kind codex --pane <returned-id>`.
   Pass Codex options after `--`. Required per-process overrides are:

   ```text
   -m gpt-5.6-luna
   -c model_reasoning_effort="max"
   -c service_tier="fast"
   -c features.fast_mode=true
   -c developer_instructions="HARNESS_ROLE=worker. Execute the assigned bounded task. Do not spawn agents or claim Bale. Return evidence to the coordinator."
   ```

   Use an argument array, not a shell-built string containing a prompt. Match
   sandbox and approval options to the task's inherited authority; model/role
   overrides are not permission to bypass approvals. Keep global config intact.
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
   Before work, capture the real session's `/status` and `/fast status` or an
   equivalent runtime configuration view. Check model, effort and Fast are
   effective, rather than merely present in a requested command. Record native
   session ID where available. If output cannot establish the requested settings,
   pause task submission and report the missing proof. Do not ask the model to
   infer its own configuration as evidence.

## Read and wait

`agent prompt` accepts text and presses Enter. `agent read` returns terminal text,
while creation/get/wait operations return JSON. `agent wait --timeout 30000`
is bounded; repeat observations of the same handle after a timeout. `blocked`
means a recognized input UI, not permission to approve it. Inspect the dialog
and resolve only already-authorized operations; otherwise preserve the session
and ask for the missing decision. Use deliberate keys only after that inspection.

Herdr does not identify individual turns. A wait may be satisfied by earlier work;
matching task/attempt receipts and actual acceptance checks establish completion.
`pane wait-output` may match old text immediately. An unknown state or a read
error is not terminal failure. Large transcript reads may be unavailable while
working; use a visible snapshot, then the worker's result file after it settles.

On the tested Windows preview, `agent prompt` sometimes left the exact text in
Codex's input composer without starting a turn. After passively confirming that
the intended prompt is still in the composer, the agent is idle, and no dialog
is present, record and send one deliberate `agent send-keys <target> enter`.
This submits the existing input; do not send the prompt again. Reobserve the
same handle. If input or delivery is ambiguous, pause input and investigate.
The helper checks caller ownership and target identity and sends to the recorded
pane, then checks the returned terminal identity. Herdr has no demonstrated
atomic compare-and-send lease: retain exclusive control of owned worker panes
and reconcile any identity change as uncertain delivery, not successful work.

## Version and platform evidence

The initial trial environment was Windows PowerShell, Herdr
0.7.5-preview.2026-07-21-0f10e1453a7f and Codex CLI 0.153.4. This is a tested
baseline only after the linked improvement record contains successful proof;
recheck commands and configuration in a different environment.

- [Herdr automation](https://herdr.dev/docs/agent-automation/)
- [Upstream skill v0.8.2](https://github.com/herdrdev/herdr/blob/v0.8.2/skills/herdr/SKILL.md)
- [Windows support](https://herdr.dev/docs/windows-beta/)
- [Codex Fast mode](https://learn.chatgpt.com/docs/agent-configuration/speed)
- [Luna model](https://developers.openai.com/api/docs/models/gpt-5.6-luna)

Upstream docs are references, not a reason to upgrade a running server. Changes
to installation, global config or unrelated panes need their own authority.
