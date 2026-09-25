# Layer-Based Model-Family Add-On Prompts

This folder owns dynamically loaded, model-family-specific add-on prompts that
extend the current session's instructions. AGENTS.md owns task authority and
session role; docs-harness/INDEX.md triggers this contract at session start.
This mechanism is orthogonal to the Bale/worker role in AGENTS.md's Session
role section: it selects add-on content by which AI model/runtime is currently
active, not by task role. It applies the same way whether the current session
is Bale or a delegated worker.

## Structure

```text
docs-harness/layers/
└── layer-<N>/
    └── agents/
        └── <family>/
            ├── <exact-model-identifier>.md   (loads only for that exact model)
            ├── <exact-model-identifier-2>.md
            └── reasons-and-purposes.md       (rationale log; never auto-loaded)
```

- `layer-<N>` folders are numbered stages (`layer-1`, `layer-2`, ...), applied
  in ascending numeric order. Add a new layer only when its add-on prompts
  must apply as a distinct, separately ordered stage; otherwise add files to
  an existing layer's family folder.
- `agents/<family>/` holds add-on prompt files for one AI model family, but a
  file inside it only loads for the one exact model it is named after — see
  Model-specific file matching below. Each model family evolves differently
  after release, so a single family-wide prompt is not assumed to fit every
  model/effort combination in that family.

## Family matching table

This table is the single place that maps a family folder name to the
model/runtime identity that selects it. Adding a new AI model family requires
only a new `agents/<family>/` folder plus one row here — no other Harness file
needs to change.

| Folder (`agents/<family>/`) | Matches when the current session's model/runtime identity is |
| :--- | :--- |
| `gemini` | A Google Gemini model (model ID/name containing `gemini`), or the current session is itself running as the Antigravity product/runtime (Herdr kind `agy`), regardless of which model Antigravity is hosting |
| `claude` | *(reserved for when a Claude-family add-on is authored)* An Anthropic Claude model (model ID/name containing `claude`), or the Claude Code product/runtime |
| `chatgpt` | *(reserved for when a ChatGPT/Codex-family add-on is authored)* An OpenAI GPT/ChatGPT model, or the Codex product/runtime (Herdr kind `codex`) |
| `opencode` | *(reserved for when an OpenCode-family add-on is authored)* The OpenCode product/runtime (Herdr kind `opencode`), regardless of which underlying model OpenCode is hosting |

A reserved row records an intended mapping ahead of content; it does not load
anything until a matching `agents/<family>/` folder actually exists on disk.
Only `gemini` currently has a folder under `layer-1/`.

## Model-specific file matching

A model family's own folder narrows further to the exact model. A file
directly under `agents/<family>/` loads only when its basename (without
extension) exactly equals the current session's own resolved exact
model+effort identifier — the same value HERDR-AGENTS.md's "Resolved worker
evidence" records as the model ID plus the effective Effort value, in
kebab-case (for example `gemini-3.8-flash-high`).

This exact-match rule is the only filter: it needs no separate exception list
for non-prompt files. A rationale log (`reasons-and-purposes.md`), a README,
or any other supporting file simply never matches a real resolved model
identifier, so it is never loaded — its content stays documentation only.

There is no family-wide tier (a prompt that loads for every model in a family
regardless of its exact identifier); every loadable file is model-specific.
This is a deliberate User decision (2026-09-26), not a pending gap — do not
add a family-wide tier speculatively.

## Loading procedure

Perform this once per session, at the same session-start point where
docs-harness/INDEX.md's Session retrieval section reads PERSONA.md. Re-run it
after a workspace switch or a compaction that loses routing context, same as
INDEX itself.

1. Determine the current session's own model/runtime identity from the
   environment context already available at session start: both the broad
   family signal (for the Family matching table) and, when resolvable, the
   exact model+effort identifier used for Model-specific file matching (an
   announced model ID/name, the hosting product/runtime, or the Herdr `--kind`
   when running as a delegated worker). This is read from the running session
   itself, not a product decision, so do not ask the User for it.
2. Walk `docs-harness/layers/layer-<N>/` folders in ascending numeric order.
   For each one that exists:
   1. Match the family signal from step 1 against the Family matching table to
      find at most one `agents/<family>/` folder that both has a matching
      table row and actually exists under this layer.
   2. If a family folder matches, apply Model-specific file matching: look
      for a file directly under it whose basename exactly equals the exact
      model identifier from step 1. If one exists, announce its path to the
      User (for example: `Loading layer add-on:
      docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md`),
      then read it and apply its content as additional instructions for the
      rest of the session. Announcing the path satisfies the notification
      requirement; no content preview is required.
   3. If no family folder matches, the family folder has no file matching the
      exact model identifier, or the exact model identifier could not be
      resolved, skip that layer with no notification. This is the normal
      outcome whenever no add-on has been authored for the current exact
      model yet, not an error.
3. If the family signal itself cannot be determined or is ambiguous, skip
   layer loading entirely and continue the task unaffected; note the gap only
   if the task directly depends on a specific family's add-on.
4. Layers apply cumulatively in ascending order. A later layer's file may
   extend or refine an earlier one; do not let one silently contradict another
   without noting the conflict.

## Adding a new AI model family

1. Create `docs-harness/layers/<layer>/agents/<family>/` (an existing layer or
   a new one) and add the add-on prompt file(s) inside it.
2. Add or update the one row in the Family matching table above that maps
   `<family>` to its identity signal(s) (model ID/name substring, hosting
   product/runtime name, or Herdr kind).
3. Add matching `!docs-harness/layers/...` allow lines to the repository root
   `.gitignore`, mirroring the nested allow/deny chain already used for this
   folder and for `docs-harness/plans/active/`. The repository ignores new
   `docs-harness/` content by default; without this step the new folder/file
   would never appear in `git status` or become committable.
4. No change to AGENTS.md, docs-harness/INDEX.md, or this file's Loading
   procedure is needed; the next session picks up the new folder and row
   automatically once step 3 makes it trackable.

## Adding a model-specific add-on prompt

1. Determine the exact model+effort identifier the runtime actually resolves
   for the target model (the value HERDR-AGENTS.md's "Resolved worker
   evidence" would record as the model ID plus effective Effort, in
   kebab-case). Confirm it natively where possible; do not guess a suffix
   the runtime does not expose.
2. Create `docs-harness/layers/<layer>/agents/<family>/<identifier>.md` with
   the add-on instructions, inside an existing family folder (create one per
   "Adding a new AI model family" above if it does not exist yet).
3. Add the matching `!docs-harness/layers/...` allow line(s) to the
   repository root `.gitignore`, following the existing nested chain for that
   family folder.
4. Optionally record the reason and purpose for the add-on in that family
   folder's `reasons-and-purposes.md` (create it if it does not exist). Never
   name that file, or any other supporting file, after a resolvable model
   identifier — Model-specific file matching would otherwise treat it as a
   prompt to load.
