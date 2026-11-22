# Coding in a subagent

Applies to a non-trivial task that writes or changes code. Small edits, reading, review,
and questions stay in this session, as `#074` requires. Skip spawning a coding subagent
when this session already runs an Antigravity Orchestrator model (built-in two-phase
planner/executor), unless the User asks to isolate the task. A subagent started by this
rule codes itself and starts no coding subagent.

## Model (select exactly one by marking `[x]`)

If none or several are marked, use `pro`. `invoke_subagent` selects by model tier only
(no exact model ID, `effort` argument, or built-in advisor tool).

- [ ] `flash_lite` (lightest, fastest Gemini tier)
- [ ] `flash` (fast Gemini tier)
- [x] `pro` (larger Gemini tier for complex coding)
- [ ] `inherit` (parent session's exact model and effort, fresh context)

## Steps

1. Ask the User before launching, in one question (or `ask_question`) that names the
   `self` subagent, offers the model tiers with the marked one first, and confirms the
   workspace mode (`inherit` by default so edits land in this checkout, or `share`/`branch`
   for isolation). Launch only after confirmation; if declined, code in this session.
2. Launch a fresh subagent with `invoke_subagent`:
   - `TypeName`: `"self"`.
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
5. When the subagent reports back, inspect the changed files (`git diff`) and the checks it
   names before telling the User the task is done.
