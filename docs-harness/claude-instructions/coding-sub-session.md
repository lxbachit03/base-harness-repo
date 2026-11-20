# Coding in a sub-session

Applies to a task that writes or changes code. Small work stays in this session, as the
session role says; reading, review and questions stay too. A session that this rule
started codes itself and starts no other session.

## Effort (select exactly one by marking `[x]`)

If none or several are marked, use high.

- [ ] Sonnet 5.5, effort: medium
- [x] Sonnet 5.5, effort: high
- [ ] Sonnet 5.5, effort: extra
- [ ] Sonnet 5.5, effort: max

## Steps

1. Ask the User before starting a session, in one question that offers the efforts
   with the marked one first and names the model. Start it only after an answer; if the
   User declines a session, do the task here.
2. Start a new session with the host's session tool (`mcp__ccd_session__start_session` in
   the Claude desktop app):
   - `model`: `claude-sonnet-5-5`, `effort`: the answer (`xhigh` for "extra").
   - `context`: `fresh`; a fork ignores model and effort.
   - `use_worktree`: `false`, so the changes land in this checkout.
   - `wake_when_done`: `true`.
   The host may ask the User again; follow its flow.
3. The new session has not seen this conversation. Write the brief from what this session
   knows: the task in the User's own words and language, the files or area, the decisions
   so far, what done looks like, and the User's authority and limits (for example whether
   unit tests may be written). Edit none of the brief's files here while it runs.
4. The host ignores a `model` above this session's own and an `effort` above it. When the
   new session cannot get the chosen model or effort, say so in the step 1 question and
   ask whether to run here or choose a lower effort.
5. When the new session reports, inspect the changes and the checks it names before telling
   the User the task is done.
