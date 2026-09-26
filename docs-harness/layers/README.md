# Layer-Based Model-Specific Add-On Prompts

This folder owns dynamically loaded, model-specific add-on prompts that
extend the current session's instructions. AGENTS.md owns task authority and
session role; docs-harness/INDEX.md triggers this contract at session start.
This mechanism is orthogonal to the Bale/worker role in AGENTS.md's Session
role section: it selects add-on content by which exact AI model the current
session is running as, not by task role. It applies the same way whether the
current session is Bale or a delegated worker.

## Structure

```text
docs-harness/layers/
└── layer-<N>/
    └── agents/
        ├── <exact-model-identifier>.md   (loads only for that exact model)
        ├── <exact-model-identifier-2>.md
        └── reasons-and-purposes.md       (rationale log; never auto-loaded)
```

- `layer-<N>` folders are numbered stages (`layer-1`, `layer-2`, ...), applied
  in ascending numeric order. Add a new layer only when its add-on prompts
  must apply as a distinct, separately ordered stage; otherwise add files to
  an existing layer's `agents/` folder.
- `agents/` is flat: every model's add-on file sits directly in it, named
  after the exact model it applies to. There is no per-provider/family
  subfolder (for example no `gemini/`) — a Gemini file, a Claude file, and a
  ChatGPT file all live side by side in the same `agents/` folder, each
  distinguished only by its own filename. This was a deliberate User decision
  (2026-09-26): the flat layout was chosen over grouping by provider.

## Model-specific file matching

A file directly under `agents/` loads only when its basename (without
extension) exactly equals the current session's own resolved exact
model+effort identifier — the same value HERDR-AGENTS.md's "Resolved worker
evidence" records as the model ID plus the effective Effort value, in
kebab-case (for example `gemini-3.8-flash-high`).

This exact-match rule is the only filter, and it is the single mechanism —
there is no separate provider/family pre-selection step, and no exception
list is needed for non-prompt files. A rationale log
(`reasons-and-purposes.md`), a README, or any other supporting file simply
never matches a real resolved model identifier, so it is never loaded — its
content stays documentation only.

There is no family-wide tier (a prompt that loads for every model from one
provider regardless of its exact identifier); every loadable file is
model-specific. This is a deliberate User decision (2026-09-26), not a
pending gap — do not add a family-wide tier speculatively.

## Loading procedure

Perform this once per session, at the same session-start point where
docs-harness/INDEX.md's Session retrieval section reads PERSONA.md. Re-run it
after a workspace switch or a compaction that loses routing context, same as
INDEX itself.

1. Determine the current session's own exact resolved model+effort identifier
   from the environment context already available at session start (an
   announced model ID/name plus effort, or the value the hosting product's
   own startup/status output reports). This is read from the running session
   itself, not a product decision, so do not ask the User for it.
2. Walk `docs-harness/layers/layer-<N>/` folders in ascending numeric order.
   For each one that exists:
   1. Look directly under its `agents/` folder for a file whose basename
      exactly equals the identifier from step 1.
   2. If one exists, announce its path to the User (for example: `Loading
      layer add-on: docs-harness/layers/layer-1/agents/<identifier>.md`),
      then read it and apply its content as additional instructions for the
      rest of the session. Announcing the path satisfies the notification
      requirement; no content preview is required.
   3. If no file matches, or the layer has no `agents/` folder, or the exact
      identifier could not be resolved, skip that layer with no notification.
      This is the normal outcome whenever no add-on has been authored for the
      current exact model yet, not an error.
3. If the identifier itself cannot be determined, skip layer loading entirely
   and continue the task unaffected; note the gap only if the task directly
   depends on a specific model's add-on.
4. Layers apply cumulatively in ascending order. A later layer's file may
   extend or refine an earlier one; do not let one silently contradict another
   without noting the conflict.

## Adding a model-specific add-on prompt

1. Determine the exact model+effort identifier the runtime actually resolves
   for the target model (the value HERDR-AGENTS.md's "Resolved worker
   evidence" would record as the model ID plus effective Effort, in
   kebab-case). Confirm it natively where possible; do not guess a suffix the
   runtime does not expose.
2. Create `docs-harness/layers/<layer>/agents/<identifier>.md` with the
   add-on instructions, directly under an existing or new layer's `agents/`
   folder — do not wrap it in a provider/family subfolder.
3. Add the matching `!docs-harness/layers/...` allow line(s) to the
   repository root `.gitignore`, following the existing nested chain for that
   layer's `agents/` folder.
4. Optionally record the reason and purpose for the add-on in that layer's
   shared `agents/reasons-and-purposes.md` (create it if it does not exist).
   Never name that file, or any other supporting file, after a resolvable
   model identifier — Model-specific file matching would otherwise treat it
   as a prompt to load.
