# Coding in a subagent

Applies to a non-trivial task that writes or changes code. Small edits, reading, review,
and questions stay in this session, as `#074` requires. Skip delegating when this session
already runs an Antigravity Orchestrator model (built-in two-phase planner/executor),
unless the User asks to isolate the task. A coding subagent or swarm worker started by
this rule codes itself and starts no further coding subagent.

## Dispatch mode (select exactly one by marking `[x]`)

If none or several are marked, use `invoke_subagent`.

- [ ] `invoke_subagent` (fresh context via `TypeName: "self"`, uses the Model tier below)
- [x] `/swarm` (swarm worker via `swarm(action="add")`; supports `fork: "coordinator"` to
  inherit parent conversation history and the exact Gemini model checklist below)

## Model for `invoke_subagent` (select exactly one by marking `[x]`)

Applies only when `invoke_subagent` is marked above. If none or several are marked, use
`pro`. `invoke_subagent` selects by model tier only (no exact model ID, `effort` argument,
or built-in advisor tool).

- [ ] `flash_lite` (lightest, fastest Gemini tier)
- [ ] `flash` (fast Gemini tier)
- [x] `pro` (larger Gemini tier for complex coding)
- [ ] `inherit` (parent session's exact model and effort, fresh context)

## Model for `/swarm` (only when `/swarm` is marked above; select one `[x]`)

Applies **only** when `/swarm` is marked under `## Dispatch mode`; ignored when
`invoke_subagent` is selected. If none or several are marked, omit `model` to use the
coordinator's own model.

- [ ] `inherit`: coordinator's own model (omit `model`)
- [ ] `gemini-3.8-flash-low`: Gemini 3.8 Flash (Low)
- [ ] `gemini-3.8-flash-medium`: Gemini 3.8 Flash (Medium)
- [ ] `gemini-3.8-flash-high`: Gemini 3.8 Flash (High)
- [ ] `gemini-4-neon-low`: Gemini 4 Neon (Low)
- [ ] `gemini-4-neon-medium`: Gemini 4 Neon (Medium)
- [ ] `gemini-4-neon-high`: Gemini 4 Neon (High)
- [ ] `gemini-4-neon-xhigh`: Gemini 4 Neon (XHigh)
- [ ] `gemini-4-argon-low`: Gemini 4 Argon (Low)
- [ ] `gemini-4-argon-medium`: Gemini 4 Argon (Medium)
- [ ] `gemini-4-argon-high`: Gemini 4 Argon (High)
- [ ] `gemini-4-hydrogen-low`: Gemini 4 Hydrogen (Low)
- [ ] `gemini-4-hydrogen-medium`: Gemini 4 Hydrogen (Medium)
- [ ] `gemini-4-hydrogen-high`: Gemini 4 Hydrogen (High)
- [x] `gemini-4-hydrogen-xhigh`: Gemini 4 Hydrogen (XHigh)
- [ ] `gemini-pro-orchestrator-neon`: Orchestrator (Neon)
- [ ] `gemini-pro-orchestrator-g1-pro`: Orchestrator (Argon)

## Steps

### When `invoke_subagent` is selected

1. Ask the User before launching, in one question (or `ask_question`) that names the
   `self` subagent, offers the `## Model for invoke_subagent` tiers with the marked one
   first, and confirms the workspace mode (`inherit` by default so edits land in this
   checkout, or `share`/`branch` for isolation). Launch only after confirmation; if
   declined, code in this session.
2. Launch a fresh subagent with `invoke_subagent`:
   - `TypeName`: `"self"`.
   - `Role`: short task-specific role.
   - `Model`: the chosen tier (`flash_lite`, `flash`, `pro`, or `inherit`).
   - `Workspace`: `"inherit"` (or the User's chosen mode).
   Fresh context and completion notification to the parent are built in.
3. Write a self-contained `Prompt` (the subagent sees none of this conversation): the task
   in the User's own words and language, target files or area, decisions so far, done
   criteria, and User authority and limits (including `#058` unit-test authority). Leave
   the brief's files untouched in this session while the subagent runs. Instruct the
   subagent to message the parent via `send_message` if it hits an unresolved design
   question or blocker instead of guessing.
4. When the host rejects the chosen tier, report it and ask whether to code here or pick
   another tier.

### When `/swarm` is selected

1. Check `swarm(action="models", all=true)` if needed, then ask the User in one question
   (or `ask_question`) before spawning to confirm:
   - context: `fork: "coordinator"` (branch parent conversation history) or fresh context;
   - `workspace`: `"inherit"` by default, or `"share"`/`"branch"` for isolation;
   - `model`: the marked choice from `## Model for /swarm` listed first (or omit `model`
     for coordinator's own model).
   Spawn only after confirmation (calling `swarm(action="add")` starts a local swarm
   directly when none is open); if declined, code in this session.
2. Spawn the worker with `swarm(action="add", name=..., brief=..., workspace=..., ...)`
   passing `fork: "coordinator"` when chosen, and `model` matching `swarm(action="models",
   all=true)` (omit `model` when `inherit` is chosen). Instruct the worker to report back
   to `@coordinator`, and state what it owns, target files or area, done criteria, and
   User authority and limits (including `#058`) in `brief`, even when forked. Leave the
   brief's files untouched while the worker runs. End your reply to the User with the
   `open_board` link returned by `swarm` on its own line.
3. If `swarm(action="add", ..., fork="coordinator")` returns a transient error such as
   `executor has not processed the previous input yet`, check `swarm(action="status")`
   before retrying — the worker may already be created and `working`.
4. If the checked model is not listed by `swarm(action="models", all=true)` or rejected by
   the host, report it and ask the User to pick from the live `swarm(action="models",
   all=true)` list or omit `model`.

### After either mode reports back

Inspect the changed files (`git diff`) and the checks the worker names before telling the
User the task is done. For a `share` or `branch` swarm worker, land its edits before
calling `swarm(action="kill", ...)`.
