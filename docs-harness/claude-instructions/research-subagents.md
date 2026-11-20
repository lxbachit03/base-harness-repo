# Code research in subagents

Applies to a task that researches code: searching it, tracing a flow, finding callers or
where something happens. A direct read of one or two files stays in the session, as small
work. The main session and a session started by another instruction here may both spawn
these subagents; a subagent spawns none.

## Effort (select exactly one by marking `[x]`)

If none or several are marked, use high.

- [x] Haiku 5.5, effort: high
- [ ] Haiku 5.5, effort: extra

## Steps

1. Ask the User before the first spawn for a task, in one question that names the model,
   offers the two efforts with the marked one first, and states how many subagents you plan.
   The answer covers the subagents that task needs. If the User declines, search here.
2. Spawn each subagent with the Agent tool:
   - `subagent_type`: `Explore`, a read-only search agent.
   - `model`: `haiku`, which the host resolves to its current Haiku; say so if the User asks
     which version ran.
   - `effort`: `high`, or `xhigh` for "extra".
3. Give each subagent one question, with everything it needs in that one prompt, so it
   finishes without asking anything: it cannot ask you or the User. Include:
   - the question and why it matters to the task;
   - the repository root, and the paths, symbols, terms and names already known;
   - what is already established or ruled out;
   - the limits: read-only, no file written, and what to assume where something is unclear;
   - what to return: the findings with file paths and line numbers, short, to you as its
     result, addressed to no one else.
4. When the host refuses the model or effort, say so and ask whether to search here or
   choose the other effort.
5. Read the results yourself before relying on them, and open the cited lines for any claim
   that decides the task.
