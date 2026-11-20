# Compacting before a task

Applies when this session is about to start a task, such as a new User request that needs
work or the next task of a plan, and its context is above 50% of the window. A question
that needs no work is not a task.

## Steps

1. Read the level: use the host's context figure when you can see it. Without one, estimate
   from the length of the conversation and say that the figure is an estimate. At 50% or
   below, do nothing here.
2. Ask the User once before the task, in one question: the context is about N%, and
   whether to run `/compact` first. A "no" closes the question for that task; start the
   task. A delegated worker reports the level to its coordinator instead of asking.
3. After a yes, write one prompt for the User to send, in English whatever language the
   User writes, as a code block that begins with `/compact`. After `/compact`, say what the
   compacted session must keep, so it can do the next task without this conversation:
   - the next task, quoted in the User's own words and language;
   - the files and area, and the state of the work, with what is done and what is open;
   - the decisions so far and why, and what is ruled out;
   - the User's authority and limits for the task;
   - exact paths, IDs, commands and results that the task relies on.
4. You cannot run `/compact`. Show the prompt, ask the User to send it, and start the task
   only after the User has, working from the compacted context. If the User declines
   after seeing the prompt, start the task here.
