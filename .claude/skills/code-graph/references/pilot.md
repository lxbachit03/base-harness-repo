# Pilot a code graph in a project

Measures whether a code graph saves tokens and keeps accuracy for one real project. Run it
only with the User's authority for this project: it installs a pinned tool and spends
tokens on repeated agent runs.

## 1. Prepare

1. Work in a throwaway git worktree of the project, read-only for the code.
2. Do steps 2 to 4 of [setup.md](setup.md) there, then register the MCP server for one host
   only.
3. Install code-review-graph the same way, pinned, as the second backend.
4. Write 15 to 20 questions a teammate really asks in this codebase: callers of a function,
   impact of changing a type, the path from an entry point to a module, where a concept
   lives. Write the expected files for each before running anything.

Done when both graphs are built, the questions and their expected files are saved, and
build time and size are recorded.

## 2. Run three arms

For every question, start a fresh agent session with the same model and effort:

- **Baseline:** no graph; grep and file reads only.
- **Graphify:** the `code-graph` MCP server, Graphify backend.
- **code-review-graph:** its own local MCP server, registered for the same host.

Record per run: total tokens, tool calls, wall time, whether the agent called the graph
unprompted, and correctness against the expected files (correct, partial, wrong).

Done when every question has three runs recorded.

## 3. Decide

- **Keep Graphify** when it uses at least 30% fewer tokens than the baseline with no drop
  in correct answers, and agents call the graph without being told.
- **Switch backend** when code-review-graph meets that bar and Graphify does not.
- **Drop** when neither does; record why.

Write the table and the decision into the Harness improvement record or ticket that
authorized the pilot. Remove the worktree and uninstall both tools unless the decision is
keep.

Done when the decision and its table are recorded and the cleanup state is reported.
