# Coding in a sub-session

Applies to a task that writes or changes code. Small work stays in this session, as the
session role says; reading, review and questions stay too. A session that this rule
started codes itself and starts no other session; consulting the advisor below is not
starting one.

## Effort (select exactly one by marking `[x]`)

If none or several are marked, use high.

- [ ] Sonnet 5.5, effort: medium
- [x] Sonnet 5.5, effort: high
- [ ] Sonnet 5.5, effort: extra
- [ ] Sonnet 5.5, effort: max

## Advisor (add-on)

Mark the switch `[x]` to let the coding session consult Opus 5.5 as its advisor; leave it
`[ ]` for no advisor and skip every advisor line below.

- [x] Advisor on

Advisor effort (select exactly one by marking `[x]`). If none or several are marked, use
high. Ignored while the switch is off.

- [x] Opus 5.5, effort: medium
- [ ] Opus 5.5, effort: high

## Steps

1. Ask the User before starting a session, in one question that offers the efforts
   with the marked one first and names the model. With the advisor on, the same question
   names the advisor and offers its two efforts the same way, and the User may switch it
   off for this task. Start it only after an answer; if the User declines a session, do
   the task here. A host with no session tool (for example `claude` in a terminal) skips
   the question: say so in one line and do the task here.
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
   unit tests may be written). Edit none of the brief's files here while it runs. With
   the advisor on, the brief also says that the session may consult Opus 5.5 at the chosen
   effort through the host's advisor tool, sending it only what the question needs, and
   that the advice informs the work while the task, the User's limits and the project
   constraints decide.
4. The host ignores a `model` above this session's own and an `effort` above it. When the
   new session cannot get the chosen model or effort, say so in the step 1 question and
   ask whether to run here or choose a lower effort. When the new session has no advisor
   tool, or the tool cannot take the chosen model or effort, the brief tells it to say so
   in its report and continue alone.
5. When the new session reports, inspect the changes and the checks it names before telling
   the User the task is done.
