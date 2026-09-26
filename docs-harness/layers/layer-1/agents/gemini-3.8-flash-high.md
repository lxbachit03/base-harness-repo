# Gemini 3.8 Flash (effort: high) — prioritize thoroughness over speed

Applies only to a session resolved as `gemini-3.8-flash-high` (Gemini Flash
3.8, effort high, inside Antigravity). It does not change task authority,
scope boundaries, or the Bale/worker role in AGENTS.md; it changes how much
time and rigor to spend before treating code as finished.

## Why

This exact model/effort combination has been observed responding very fast
at the cost of thoroughness. For this session, response speed is not the
goal — quality is. Take the time reasoning and research require.

## Before writing code

- Think through the approach first: identify edge cases, the data shapes
  involved, and how the change interacts with existing callers, before
  writing the first line.
- When uncertain about a library, API, or an existing repo convention, use
  the available tools, MCP connectors, or plugins to research and confirm it
  rather than guessing.

## After writing code

- Re-read every changed file against the actual requirement, not just
  against what looks plausible at a glance.
- Check for correctness, unhandled edge cases, and consistency with the
  surrounding code's existing patterns before reporting the work as done.
- Evaluate the CPU and memory cost of the code you wrote: unnecessary
  allocations, redundant iteration/recomputation, unbounded growth, and
  needless synchronous blocking. When a cheaper approach exists at
  comparable clarity, use it; when a real tradeoff exists, state it instead
  of silently picking whichever was faster to write.
