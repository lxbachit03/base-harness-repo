# Layer-Based Model-Specific Add-On Prompts

This folder owns model-specific add-on prompts that extend the current
session's instructions. docs-harness/INDEX.md triggers this contract at session
start. Add-ons are selected by the session's exact AI model, not by its
Bale/worker role, so they apply the same way to both.

## Structure

```text
docs-harness/layers/
└── layer-<N>/
    └── agents/
        ├── <exact-model-identifier>.md   (loads only for that exact model)
        ├── <exact-model-identifier-2>.md
        └── reasons-and-purposes.md       (rationale log; never auto-loaded)
```

- `layer-<N>` folders are stages applied in ascending order. Add a new layer
  only for a separately ordered stage; otherwise add files to an existing
  layer's `agents/` folder.
- `agents/` is flat: every model's file sits directly in it, with no
  per-provider subfolder (User decision 2026-09-26).
- A layer may also contain a `hooks/` subfolder; hooks are not model-matched
  and load per its `hooks/README.md`.

## Model-specific file matching

A file directly under `agents/` loads only when its basename (without
extension) exactly equals the session's resolved model+effort identifier — the
model ID plus the effective Effort value in kebab-case, as HERDR-AGENTS.md's
"Resolved worker evidence" records it (for example `gemini-3.8-flash-high`).
When the runtime exposes no effort value, the identifier is the model ID alone
(for example `claude-opus-5-5`). This exact match is the only filter; supporting files such as
`reasons-and-purposes.md` never match a model identifier and never load.

There is no family-wide tier that loads for every model of one provider
(User decision 2026-09-26); do not add one.

## Loading procedure

Run once per session at the point INDEX's Session retrieval reads PERSONA.md,
and again after a workspace switch or a compaction that loses routing context.

1. Read the session's own exact model+effort identifier from the environment
   (announced model ID and effort, or the host's startup/status output). Do not
   ask the User for it.
2. Walk `layer-<N>/` folders in ascending order. In each:
   1. If `agents/` holds a file named exactly after the identifier, announce
      its path to the User (for example `Loading layer add-on:
      docs-harness/layers/layer-1/agents/<identifier>.md`), then read and apply
      it for the rest of the session. Otherwise skip silently; no match is the
      normal outcome.
   2. If the layer has `hooks/`, read each hook file and apply the checked
      ones per `hooks/README.md`.
3. If the identifier cannot be determined, skip add-on matching and continue;
   note the gap only when the task depends on a specific model's add-on.
4. Layers apply cumulatively; a later layer may refine an earlier one, and any
   conflict between them is reported, not silently resolved.

## Adding a model-specific add-on prompt

1. Determine the identifier the runtime actually resolves for the target model
   (model ID plus effective Effort, kebab-case, or the model ID alone when no
   effort is exposed); confirm it natively rather than guessing a suffix.
2. Create `docs-harness/layers/<layer>/agents/<identifier>.md` directly under
   that `agents/` folder.
3. Optionally record the reason in the layer's `agents/reasons-and-purposes.md`.
   Never name a supporting file after a resolvable model identifier.
