# Compacting before a task

Applies when this session is about to start a task — a new User request that requires work
or the next step of a plan — and context usage is above 50% of the window. A direct
question that requires no work is not a task.

## Steps

1. Assess the context level: use the host's reported figure when visible (CLI users can
   check `/context`). When unavailable, estimate from conversation length and state that
   the figure is an estimate. At 50% or below, proceed directly with the task.
2. Ask the User once before the task, in one question: context is about N%, and whether to
   run `/compact` first. A "no" closes the question for that task; start the task. A
   delegated worker reports the level to its coordinator instead of asking.
3. After a yes, write one English prompt as a code block beginning with `/compact` for the
   User to send, regardless of the User's conversation language. Include everything the
   compacted session must retain and act on without this history:
   - the next task, quoted verbatim in the User's own words and language;
   - the target files/area and current state (what is done and what remains open);
   - decisions made so far, why, and what is ruled out;
   - User authority and limits for the task (for example `#009` scope and `#058` unit-test
     authority);
   - exact paths, IDs, commands, and results the task relies on;
   - a reminder to rerun `docs-harness/INDEX.md` session retrieval after compaction.
4. You cannot execute `/compact`. Present the code block, ask the User to send it, and
   start the task only after compaction completes, working from the compacted context. If
   the User declines after seeing the prompt, start the task here.
