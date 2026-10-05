# Hooks

`docs-harness/layers/layer-<N>/hooks/` holds hook files: agent-facing
pre-action gates that may invoke runnable local tooling (PowerShell scripts,
CLIs, helpers) at defined session moments. Hooks are not model-matched; they
load through the same session-start layers walk that ../README.md describes.

## Loading

At the session-start layers walk (ascending `layer-<N>` order):

1. In every layer that contains `hooks/`, read each `*.md` hook file there.
2. Apply only hooks whose activation checklist is checked; an unchecked hook
   is dormant, so skip it and work normally. The hook file's current checkbox
   state is the only authority; User prose or conversation does not override
   it.
3. Agents never toggle a checklist. Only the User toggles, anytime; the
   change applies at the next load point — session start, post-compaction
   reload, a workspace switch, or when the User reports a toggle mid-session.

A hook's own tool invocations and the session-start retrieval are exempt
from the hook's gate, so a hook cannot deadlock on itself.

## Adding a hook

1. Create `layers/<layer>/hooks/<hook-name>.md` with an activation checklist
   block, its gate rule, script/tool selection, verdict handling, and an
   explicit default for when the invoked tooling cannot answer.
2. Exempt the hook's own tool invocations explicitly.
3. Add the hook path to the repository `.gitignore` allow-list chain.
4. Include the hook's verdicts and bypasses in session outcome summaries.

Hooks carry no global resource ID and no TAG; they are routed only through
this folder.
