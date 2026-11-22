# Code research in subagents

Applies to a task that researches code: searching across files, tracing a flow, or finding
callers and ownership. Reading one or two known files stays in the current session as small
work. Both the main session and a subagent started by another instruction in this folder
may spawn `research` subagents; a `research` subagent spawns none.

## Model (select exactly one by marking `[x]`)

If none or several are marked, use `flash`. `invoke_subagent` selects by model tier only
(no exact model ID or `effort` argument).

- [ ] `flash_lite` (lightest, fastest Gemini tier)
- [ ] `flash` (fast Gemini tier)
- [x] `pro` (larger Gemini tier for complex tracing)
- [ ] `inherit` (parent session's exact model and effort, fresh context)

## Steps

1. Ask the User before the first spawn for a task, in one question (or `ask_question`) that
   names the `research` subagent, offers the model tiers with the marked one first, and
   states how many subagents you plan. One approval covers the research subagents that task
   needs. If the User declines, research in this session.
2. Spawn each subagent with `invoke_subagent`:
   - `TypeName`: `"research"` (read-only sandbox, no network).
   - `Model`: the chosen tier (`flash_lite`, `flash`, `pro`, or `inherit`).
   - `Workspace`: `"inherit"`.
   For high fan-out where orchestration is code, `run_workflow` with `parallel(...)` and
   the same `model` tier may be used instead.
3. Give each subagent one self-contained `Prompt` so it completes in one pass without
   round-trips. Include:
   - the question and why it matters to the task;
   - the repository root and already-known paths, symbols, terms, and names;
   - what is already established or ruled out;
   - read-only limits and what to assume when something is unclear;
   - expected output: concise findings with file paths and line numbers.
4. When the host rejects the chosen tier, report it and ask whether to search here or pick
   another tier.
5. Read the returned findings yourself, and open the cited lines before relying on any
   claim that decides the task.
