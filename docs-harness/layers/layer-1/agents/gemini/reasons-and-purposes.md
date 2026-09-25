# Gemini / Antigravity add-on prompt rationale (layer-1)

This file records, per model-specific add-on prompt in this folder, why it
was added and what it is meant to achieve. It is documentation, not an
add-on prompt itself: its filename never matches a resolvable model
identifier, so docs-harness/layers/README.md's loading procedure never loads
it into a session.

## gemini-3.8-flash-high.md

Added: 2026-09-26

Reason: Gemini Flash 3.8 running at effort `high` inside Antigravity was
observed responding very quickly, at the cost of thoroughness — work
reported as done fast but not carefully checked.

Purpose: bias this exact model/effort combination toward quality over
response speed — deeper reasoning before coding, deliberate use of the
available tools/MCPs/plugins to research uncertain APIs/conventions instead
of guessing, a real self-review pass after writing code, and explicit
attention to the CPU/memory cost of the code it produces.
