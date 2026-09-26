# Harness Improvement Resource

ID: #030_IMPROVE_HARNESS_0926
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Model-specific add-on prompt layers under docs-harness/layers/
CREATED: 2026-09-26
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/PERSONA.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-1/agents/gemini-3.8-flash-high.md
- docs-harness/layers/layer-1/agents/deepseek-v4.1-flash-max.md
- docs-harness/layers/layer-1/agents/reasons-and-purposes.md
- .gitignore

## Objective

Add a `docs-harness/layers/` mechanism that lets the current session load
extra, model-family-specific add-on prompt files (starting with a
Gemini/Antigravity folder), announce every loaded file's path to the User, and
extend to future AI model families (ChatGPT, OpenCode, Claude, ...) without
further routing edits, indexed from `docs-harness/INDEX.md`. Continuation
(2026-09-26, same day): narrow matching from whole-family to exact
model+effort identifier, since models in the same family behave differently
after release, and author the first real add-on
(`gemini-3.8-flash-high.md`) plus its rationale log. Corrected 2026-09-26:
the User's actual effort value is `high`, not `max`; the file was authored
and then renamed within this same continuation before being validated.
Further continuation (2026-09-26, same day): the User moved both files out of
the `gemini/` subfolder directly into `agents/` and decided against wrapping
model files in any provider/family subfolder going forward — collapsing the
mechanism from two tiers (family folder, then exact model file) to one flat
tier (exact model file directly under `agents/`). Second real add-on
(2026-09-26, same day): author `deepseek-v4.1-flash-max.md` for DeepSeek V4.1
Flash (effort max, OpenCode Go) with the same reason and purpose as
`gemini-3.8-flash-high.md`, then verify with a live Herdr `--kind opencode`
worker — the first cross-provider proof that the flat, exact-match mechanism
generalizes beyond Antigravity.

## Purposes

- [x] Let the User author add-on instructions scoped to one AI model family
  instead of one instruction set that has to fit every runtime.
- [x] Guarantee visibility: the User always sees which layer file path was
  loaded, satisfying the User's explicit notify requirement.
- [x] Make adding a new model family a data-only change (new folder + one
  table row), not a new routing/instruction edit in AGENTS.md or INDEX.md.
- [x] Let the User scope an add-on to one exact model+effort identifier
  (not the whole family), since models diverge in behavior after release and
  a family-wide prompt would either under- or over-apply.
- [x] Bias `gemini-3.8-flash-high` toward thoroughness (deep reasoning, tool
  use for research, post-write self-review, CPU/memory awareness) over
  response speed, per the User's observed friction with that model/effort
  combination.
- [x] Keep `agents/` flat (no provider/family subfolder), per the User's
  explicit later decision, so a new model's add-on is always exactly one file
  at one predictable path regardless of which provider it comes from.
- [x] Bias `deepseek-v4.1-flash-max` toward the same thoroughness-over-speed
  behavior as `gemini-3.8-flash-high`, per the User's explicit instruction to
  reuse the same reason and purpose for a second, different-provider model.

## Current State

Before this change, `docs-harness/` had no per-model-family instruction
mechanism. The only per-session conditional read was `docs-harness/PERSONA.md`
(response-style selection, read at session start per INDEX's Session
retrieval section). There was no folder, routing entry, or matching rule for
model/runtime-specific add-on prompts, and no `docs-harness/layers/` path
existed.

## Proposed Improvement

- Created `docs-harness/layers/README.md` as the owning contract: folder
  structure (`layer-<N>/agents/<family>/`), a Family matching table mapping a
  folder name to the model/runtime identity signal(s) that select it, and a
  numbered loading procedure (identify own identity from session context,
  walk layers ascending, find at most one matching family folder per layer,
  announce each file's path before loading it, skip silently on no match).
- Created `docs-harness/layers/layer-1/agents/gemini/PLACEHOLDER.md` as the
  requested Gemini/Antigravity folder; it is an inert placeholder since no
  real add-on prompt content was supplied, so no product intent is invented.
- Added `claude`, `chatgpt`, and `opencode` as *reserved* (folder-less) rows in
  the Family matching table so the extension pattern for future families is
  documented without fabricating folders/content the User has not authored.
- Continuation: replaced the whole-family "every file in the folder loads"
  rule with a two-tier scheme — the Family matching table still selects the
  `agents/<family>/` folder (tier 1), but a file inside it now loads only
  when its basename exactly equals the session's resolved exact model+effort
  identifier (tier 2, new "Model-specific file matching" section). This is
  the exact-match rule alone; no exception list is needed for supporting
  files like a rationale log, because a non-model filename structurally never
  matches a real model identifier.
- Removed `docs-harness/layers/layer-1/agents/gemini/PLACEHOLDER.md` now that
  real content exists in that folder (it would never have matched the new
  exact-match rule anyway, since its name is not a model identifier).
- Authored `docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md`
  (initially created as `-max.md`, then renamed to `-high.md` per the User's
  correction in the same continuation): a real add-on prompt for that exact
  model/effort, instructing it to think through the approach and use
  available tools/MCPs/plugins for research before writing code, and to
  self-review for correctness and CPU/memory cost after writing code —
  prioritizing thoroughness over response speed, per the User's stated reason
  and purpose.
- Authored `.../gemini/reasons-and-purposes.md` as an append-only rationale
  log (one dated entry per model-specific add-on file), per the User's
  explicit request to record why each customization was made.
- Documented "Adding a model-specific add-on prompt" in `layers/README.md`
  alongside the existing "Adding a new AI model family" section.
- Wired the mechanism into `docs-harness/INDEX.md`: a Session retrieval
  sentence pointing to `layers/README.md` (same session-start step as
  PERSONA.md), a new `### layers/` Supporting Folders route, the folder tree,
  and an `IMPROVE_HARNESS` index entry for this record.
- Deliberately did not edit AGENTS.md: INDEX.md's own Session retrieval
  section is already the established session-start hook (it is where
  PERSONA.md is wired in), so adding the layers check there is consistent and
  sufficient; the User only asked for an INDEX.md entry.
- Discovered mid-task that `.gitignore` allowlists `docs-harness/` content
  path-by-path (`docs-harness/*` then `docs-harness/harness-improvements/*`
  are re-ignored, with every real file explicitly un-ignored by an exact
  `!docs-harness/...` line); without a matching entry, new files under
  `docs-harness/layers/` and the new improvement record would never appear in
  `git status`/`git add`, unlike every other existing improvement record.
  Added the same nested allow/deny chain used by `docs-harness/plans/active/`
  for `docs-harness/layers/layer-1/agents/gemini/PLACEHOLDER.md`, plus one
  line for this record, so both are now visible to git like their siblings.
- Further continuation: removed the Family matching table and the
  `agents/<family>/` folder tier entirely from `layers/README.md`. The
  User manually moved `gemini-3.8-flash-high.md` and
  `reasons-and-purposes.md` out of `agents/gemini/` directly into `agents/`
  and decided every model's add-on lives flat there from now on, regardless
  of provider. Rewrote Structure, replaced "Family matching table" +
  "Model-specific file matching" with a single "Model-specific file
  matching" section describing one exact-match tier, rewrote the Loading
  procedure to a single walk-and-match step, replaced "Adding a new AI model
  family" (now moot) with the existing "Adding a model-specific add-on
  prompt" section pointed at the flat path, removed the empty leftover
  `agents/gemini/` directory, and updated `docs-harness/INDEX.md` (folder
  tree, Session retrieval wording, Supporting Folders route, IMPROVE_HARNESS
  title) and `.gitignore` (flat allow lines) to match.
- Second real add-on: authored
  `docs-harness/layers/layer-1/agents/deepseek-v4.1-flash-max.md`, content
  mirroring `gemini-3.8-flash-high.md` exactly (same Why/Before/After
  structure and wording) per the User's explicit instruction to reuse the
  same reason and purpose for a different model. Added a matching
  `deepseek-v4.1-flash-max.md` entry to the shared
  `agents/reasons-and-purposes.md` and generalized that file's own title from
  "Gemini / Antigravity add-on prompt rationale" to "Layer add-on prompt
  rationale", since it now documents more than one provider. Re-selected the
  Herdr worker catalog in `docs-harness/HERDR-AGENTS.md`: unchecked
  `antigravity-gemini-3.8-flash` (model/effort/Fast), checked
  `opencode-go-deepseek-v4.1-flash` with effort `max`, to dispatch the
  matching live worker for verification. Added the new file's
  `!docs-harness/layers/...` line to `.gitignore`.

## Scope

In scope: `docs-harness/layers/README.md` (owning contract, now single-tier
exact-model matching, no family layer), `docs-harness/layers/layer-1/agents/gemini-3.8-flash-high.md`,
`docs-harness/layers/layer-1/agents/deepseek-v4.1-flash-max.md`, and
`docs-harness/layers/layer-1/agents/reasons-and-purposes.md` (rationale log
for both), `docs-harness/INDEX.md` (wording/paths), `docs-harness/HERDR-AGENTS.md`
(worker catalog selection), and `.gitignore` (flat allow lines).

Out of scope: AGENTS.md (no session-role or task-authority change needed);
authoring add-on content for any other specific model beyond the two the User
named (`gemini-3.8-flash-high`, `deepseek-v4.1-flash-max`); a family-wide
(non-model-specific)
loading tier — the User explicitly confirmed this is not needed, so it is a
settled decision, not an open gap; any provider/family subfolder — the User
explicitly decided against ever introducing one.

## Progress

2026-09-26 (initial): Created the layers folder, its owning README (structure,
Family matching table, loading procedure, extension steps), the placeholder
Gemini folder, and the four INDEX.md edits. Ran a fresh-agent replay (see
Validation) using a disposable `claude` family fixture to prove the positive
match/announce/load path, then removed the disposable fixture, leaving only
the requested `gemini` placeholder in the tree. Discovered and fixed a
`.gitignore` allowlist gap in the same session (see Proposed Improvement).

2026-09-26 (continuation, same day): User reported `gemini-3.8-flash-max`
(Antigravity) responding fast but not thoroughly, and asked for (a) a
model-specific add-on prompt for that exact model, (b) a rationale log for
it, and (c) generalizing the mechanism to per-exact-model files under
`agents/<family>/`, since models diverge after release. Revised
`layers/README.md`'s matching rule from whole-family to exact-model
(Model-specific file matching), removed the now-obsolete placeholder,
authored the real `gemini-3.8-flash-max.md` and `reasons-and-purposes.md`,
and ran a second fresh-agent replay proving the exact-match/decoy-skip
behavior before removing that replay's disposable fixtures.

2026-09-26 (correction, same day): User corrected the effort value — Gemini
3.8 Flash has no `max` effort; the intended value is `high` (matching
`docs-harness/HERDR-AGENTS.md`'s already-documented
`antigravity-gemini-3.8-flash` effort checklist, which lists `high` and has
it checked). Renamed `gemini-3.8-flash-max.md` to `gemini-3.8-flash-high.md`
and fixed its internal "effort max" wording, and the corresponding
`reasons-and-purposes.md` heading/text, to `high`; updated `.gitignore` and
`layers/README.md`'s examples to match. The User also confirmed no
family-wide loading tier is needed, settling that open question from the
prior Risks entry. No mechanism/logic change was required for either
correction — only naming and one settled decision — so no new replay was run;
the exact-match matching logic itself was already proven against the
`claude-sonnet-5`/`claude-opus-5` decoy pair in the prior replay.

2026-09-26 (live Herdr validation, User-requested "test hiệu quả xem có load
được không"): dispatched a real `--kind agy` Antigravity worker (not a
simulated Claude fixture) running the exact target model/effort to prove the
`gemini-3.8-flash-high.md` add-on loads for a genuine Gemini/Antigravity
session, per `.agents/skills/herdr-coordinate-agents/SKILL.md`. See Validation
for the full attempt record.

2026-09-26 (flatten, same day): User manually moved
`gemini-3.8-flash-high.md` and `reasons-and-purposes.md` out of
`docs-harness/layers/layer-1/agents/gemini/` directly into
`docs-harness/layers/layer-1/agents/` and stated models will never be
wrapped in a provider/family subfolder again. Removed the Family matching
table and the `agents/<family>/` tier from `layers/README.md` entirely,
collapsing the design to one flat exact-model-match tier; removed the
now-empty `agents/gemini/` directory; updated `docs-harness/INDEX.md`
(folder tree, session-retrieval and Supporting Folders wording, IMPROVE_HARNESS
title) and `.gitignore` (flat allow lines replacing the nested
`gemini/`-scoped ones) to match. No new fresh-agent or live-Herdr replay was
run for this step: it removes one level of directory indirection without
changing the exact-match rule itself, which the prior fresh-agent replays and
the live `--kind agy` Antigravity trial already proved; verification here was
a targeted self-review of the edited files instead (see Validation).

2026-09-26 (second model, same day): User asked for the same treatment for
DeepSeek V4.1 Flash (effort `max`), explicitly reusing the same reason and
purpose as `gemini-3.8-flash-high.md`, then to verify with
`herdr-coordinate-agents`. Authored `deepseek-v4.1-flash-max.md` (mirrored
content), added its entry to `agents/reasons-and-purposes.md` and generalized
that file's title (no longer Gemini-specific), re-selected the Herdr catalog
in `HERDR-AGENTS.md` to `opencode-go-deepseek-v4.1-flash`/`max`, and dispatched
a live `--kind opencode` worker to prove the flat mechanism also works for a
second, different provider. See Validation for the full attempt record.

## Validation

Native/static checks:
- Re-read `docs-harness/INDEX.md` after editing: folder tree lists `layers/`
  with its `layer-1/agents/` descendant (no `gemini/` subfolder); Session
  retrieval references `layers/README.md`; a `### layers/` Supporting Folders
  route exists with a working relative link; the `IMPROVE_HARNESS` list
  carries this record's entry with matching ID/priority.
- Confirmed `#030_IMPROVE_HARNESS_0926` is the next unused ID (highest prior
  ID in `docs-harness/` was `#029_IMPROVE_HARNESS_0922`, found by scanning all
  `#NNN_TAG_MMDD` occurrences under `docs-harness/`).
- Confirmed `docs-harness/layers/README.md` and
  `docs-harness/layers/layer-1/agents/gemini/PLACEHOLDER.md` exist on disk at
  the paths INDEX.md and this record reference.
- Found and removed an unexplained, empty (0-byte), untracked
  `docs-harness/layers/layer-1/agents/gemini/README.md` that predated this
  task's own edits and had no git history, stash, or reflog trace (it was
  invisible to `git status` before the `.gitignore` fix below, consistent
  with having been created and abandoned by an earlier uncommitted attempt).
  It carried no content to preserve; removing it left only the intended
  `PLACEHOLDER.md` in that folder.
- After the `.gitignore` fix, confirmed with `git status -s` that
  `docs-harness/layers/` and
  `docs-harness/harness-improvements/0926-model-family-layer-prompts.md` now
  appear as untracked/addable, matching how every prior improvement record
  and plan file is tracked.

Fresh-agent replay (instruction-routing behavior, per improve-harness step 3):
- Added a disposable `docs-harness/layers/layer-1/agents/claude/0001-test.md`
  fixture (a one-line marker file) and a temporary `claude` row was already
  present in the Family matching table (reserved row, matches the Claude Code
  runtime this session runs as).
- Launched a fresh general-purpose agent with no memory of this conversation
  and asked it to run the session-start procedure exactly as
  `docs-harness/INDEX.md` and `docs-harness/layers/README.md` describe it, and
  report what it announced and loaded.
- Observed result: the fresh agent identified itself as a Claude Code session,
  matched the `claude` row, walked `layer-1`, found `agents/claude/` present,
  announced the path
  `docs-harness/layers/layer-1/agents/claude/0001-test.md` to the user before
  reading it, and correctly reported skipping `agents/gemini/` (no identity
  match) with no notification for that skip.
- Removed the disposable `agents/claude/0001-test.md` fixture afterward, since
  the User's request only authorized the `gemini` folder now; the `claude` row
  remains in the table as a reserved (folder-less) mapping.

Second fresh-agent replay (two-tier model-specific matching, continuation):
- Added disposable fixtures under `docs-harness/layers/layer-1/agents/claude/`:
  `claude-sonnet-5.md` (matches this session's real resolved identity),
  `claude-opus-5.md` (decoy: a different model's filename), and
  `reasons-and-purposes.md` (decoy: a non-model-identifier supporting file).
- Launched a fresh general-purpose agent with no memory of this conversation
  and asked it to resolve its own identity, apply the revised two-tier
  procedure from `layers/README.md`, and report which file it loaded versus
  skipped and why.
- Observed result: the agent resolved itself as `claude-sonnet-5`, matched
  `agents/claude/` (tier 1), announced and loaded only
  `docs-harness/layers/layer-1/agents/claude/claude-sonnet-5.md` (tier 2 exact
  match), and correctly reported *not* loading `claude-opus-5.md` (wrong
  model identifier) or `reasons-and-purposes.md` (not a model identifier at
  all) — with no notification for either skip. It also confirmed
  `agents/gemini/` was considered and correctly skipped as the wrong family.
- Removed all three disposable fixtures afterward, leaving only the real
  `gemini-3.8-flash-high.md` (named `-max.md` at replay time, renamed after)
  and `reasons-and-purposes.md` in the tree.

Live Herdr `--kind agy` validation (real Antigravity worker, not a fresh
Claude simulation), per `herdr-coordinate-agents`:
- Verified Herdr runtime (`HERDR_ENV=1`, `HERDR_PANE_ID=w2B:p1`) and bound
  Bale's alias to this pane (`herdr agent rename w2B:p1 bale`; `bale` was
  previously unbound).
- Resolved the exact provider model ID natively before launch: `agy models`
  listed `gemini-3.8-flash-high  Gemini 3.8 Flash (High)` — an exact string
  match for this record's filename, confirming the effort correction was
  right.
- Created an owned pane (`herdr tab create --workspace w2B --cwd
  D:\repos\base-harness-repo --no-focus --env HARNESS_ROLE=worker`, pane
  `w2B:p2`) and launched `herdr agent start layer-test-agy-01 --kind agy
  --pane w2B:p2 -- --dangerously-skip-permissions --model
  gemini-3.8-flash-high --effort high`.
- Post-launch check (native TUI header, read passively before any input):
  account `lxbach1608@gmail.com` (Google AI Pro), model `Gemini 3.8 Flash
  (High)`, cwd `D:/repos/base-harness-repo`; no trust/onboarding dialog.
- Sent a tight task packet (`.herdr-runtime/layer-load-verify-01/`: job.json,
  prompt.txt, dispatch.json, configuration-evidence.txt) asking the worker to
  run its own real session-start routing and report, via a receipt file, its
  resolved identity and whether `docs-harness/layers/README.md`'s procedure
  matched and loaded a layer file for it.
- `herdr agent prompt ... --wait --until done` returned `done` after a few
  seconds with no `receipt.json` yet — the same `agy` false-done pattern
  documented in `#029_IMPROVE_HARNESS_0922`. Did not resend; a bounded recent
  snapshot showed the worker still actively reading files and editing the
  receipt. Reobserved with `herdr agent wait --timeout 30000`, which then
  returned `idle` with a completed `receipt.json` present.
- Receipt content: `resolved_identity: "gemini-3.8-flash-high"`,
  `layer_file_matched:
  "docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md"`,
  `layer_file_announced: true`, `status: "completed"`.
- Terminal transcript independently confirms the same result in the worker's
  own words: it read `INDEX.md`, `layers/README.md`, `HERDR-AGENTS.md`, then
  `gemini-3.8-flash-high.md` itself, printed `Loading layer add-on:
  docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md`, and
  stated it would apply all four documented behaviors (thoroughness over
  speed, tool use for research, self-review, CPU/memory attention).
- `git status -s` after the run showed no unintended repository changes; the
  worker touched only its own receipt file under the disposable
  `.herdr-runtime/` attempt directory, which was removed after this record
  captured the evidence above. The worker's tab (`w2B:t2`) was closed after
  evidence collection.
- Bale code review gate: `not_applicable` — the only artifact produced was a
  disposable JSON receipt in a runtime-scratch directory, not executable code,
  a runtime-affecting asset, or runtime configuration.

Not attempted (at this point in the record): no repository validator script
was created or invoked (not authorized); no live replay across ChatGPT or a
second OpenCode Go model was run yet (the `chatgpt` case remains reserved,
folder-less; a live OpenCode Go trial for `deepseek-v4.1-flash-max` follows
below).

Flatten self-review (targeted, per AGENTS.md's manual self-validation
policy, no new replay):
- Confirmed on disk that only `docs-harness/layers/layer-1/agents/` exists
  (no `gemini/` subfolder, no stray files left behind) and that
  `gemini-3.8-flash-high.md`/`reasons-and-purposes.md` sit directly in it.
- Re-read the rewritten `layers/README.md` end to end: Structure, Model-
  specific file matching, Loading procedure, and "Adding a model-specific
  add-on prompt" are internally consistent with the flat layout and contain
  no remaining `<family>`/family-folder reference.
- Grepped the repository for `agents/gemini`, `Family matching`, `model-
  family`, and `agents/<family>` after all edits: matches remain only in this
  record's own historical Progress/Validation narrative (accurately
  describing what was true before the flatten) and in the unrelated
  `docs-harness/harness-improvements/0922-opencode-go-tight-handoff-wait-timeout.md`
  (a different model's `effort max`, not this record's topic).
- Confirmed `.gitignore`'s allow chain now ends at
  `!docs-harness/layers/layer-1/agents/gemini-3.8-flash-high.md` and
  `!docs-harness/layers/layer-1/agents/reasons-and-purposes.md` with no
  `gemini/`-scoped lines remaining, and that `git status -s` shows the two
  files as renames/moves, not new untracked content.

Live Herdr `--kind opencode` validation (DeepSeek V4.1 Flash, effort `max`),
per `herdr-coordinate-agents`:
- Re-selected `docs-harness/HERDR-AGENTS.md`'s catalog: unchecked
  `antigravity-gemini-3.8-flash` (model/effort `high`/Fast `standard`),
  checked `opencode-go-deepseek-v4.1-flash` with effort `max`.
- Resolved the exact provider model ID natively before launch:
  `opencode models opencode-go` listed `opencode-go/deepseek-v4.1-flash`.
- Ran `.agents/skills/herdr-coordinate-agents/scripts/prepare-opencode-windows.ps1`
  for a task-local `opencode.cmd` shim (global wrapper untouched), created an
  owned pane (`herdr tab create --workspace w2B --cwd D:\repos\base-harness-repo
  --no-focus --env HARNESS_ROLE=worker --env PATH=<shim-path>`, pane
  `w2B:p3`), and launched `herdr agent start deepseek-layer-verify-01 --kind
  opencode --pane w2B:p3 -- --auto -m opencode-go/deepseek-v4.1-flash`.
- Post-launch check (native status bar, read passively before any input):
  `Build auto · DeepSeek V4.1 Flash OpenCode Go · max` — effort `max` was
  already the effective variant (carried over from the 2026-09-22 OpenCode Go
  trial's persisted state), so no manual TUI variant reselection was needed;
  cwd and no dialog also confirmed.
- Sent the same-shaped tight task packet
  (`.herdr-runtime/layer-load-verify-deepseek-01/`) asking the worker to run
  its own real session-start routing against the new flat `agents/` layout
  and report via receipt.
- `herdr agent prompt ... --wait --until done` exceeded the Bash tool's own
  180s call timeout and was auto-backgrounded (the documented non-killing
  behavior) rather than treated as a failure; a passive `agent read` while it
  ran showed the worker actively resolving its identity, reading
  `model.json`/`opencode.jsonc`/`kv.json`, printing `Loading layer add-on:
  docs-harness/layers/layer-1/agents/deepseek-v4.1-flash-max.md`, reading that
  file, and stating it would apply its guidance — genuinely working, not a
  false-done case this time.
- Settled result (`agent get` returned `idle`; total build time ~52.5s):
  receipt `resolved_identity: "deepseek-v4.1-flash-max"`,
  `layer_file_matched:
  "docs-harness/layers/layer-1/agents/deepseek-v4.1-flash-max.md"`,
  `layer_file_announced: true`, `status: "completed"`, with a summary
  confirming end-to-end success and no other file edited.
- The worker's own resolved-identity evidence, quoted from its transcript:
  "system prompt reports model ID opencode-go/deepseek-v4.1-flash; process
  command line is opencode --auto -m opencode-go/deepseek-v4.1-flash; opencode
  state (model.json) records variant max for that model" — an independent,
  native confirmation of the `deepseek-v4.1-flash-max` filename, mirroring how
  `agy models` independently confirmed `gemini-3.8-flash-high` earlier.
- `git status -s` after the run showed no unintended repository changes
  beyond this task's own intended edits; the worker touched only its own
  receipt file under the disposable `.herdr-runtime/` directory, removed
  after this record captured the evidence above. The worker's tab
  (`w2B:t3`) was closed after evidence collection.
- Bale code review gate: `not_applicable` — the only artifact produced was a
  disposable JSON receipt in a runtime-scratch directory.

This is the first cross-provider proof for the flattened mechanism: the same
`layers/README.md` procedure, unmodified, correctly matched two different
providers' sessions (Antigravity/Gemini and OpenCode Go/DeepSeek) purely by
exact filename, with no per-provider branching in the instructions.

## Risks

- Obsolete (2026-09-26): the Family matching table's identity signals (e.g.,
  "model ID/name containing gemini") were heuristic text matches, not a
  verified API. The table was removed entirely in the flattening
  continuation; matching is now a single exact-string comparison against the
  resolved model+effort identifier, which is precise by construction rather
  than a substring heuristic, so this risk no longer applies.
- Per-session file announcements add small, bounded token/latency overhead
  proportional to the number of files directly under a layer's `agents/`
  folder. Mitigation: the procedure explicitly skips a non-matching layer
  with no notification, keeping the no-match case (today's default, since
  only one model has content) effectively free.
- Obsolete (2026-09-26): the prior `gemini` row's "regardless of which model
  Antigravity is hosting" grouping clause no longer exists — there is no
  Family matching table or per-provider row to split; each model, including
  any future Antigravity-hosted Claude/GPT-OSS preset, gets its own flat file
  named after its own exact resolved identifier.
- A future contributor could add a new `agents/<identifier>.md` file and
  forget the required `.gitignore` allowlist line, silently leaving the new
  add-on uncommitted (this happened during this task's own implementation,
  for the original nested `gemini/` path). Mitigation:
  `docs-harness/layers/README.md`'s "Adding a model-specific add-on prompt"
  steps explicitly call out the `.gitignore` allowlist as step 3.
- Resolved (2026-09-26): the file was initially named `-max.md`, an effort
  value `docs-harness/HERDR-AGENTS.md`'s catalog does not document for
  `antigravity-gemini-3.8-flash` (only `low`/`medium`/`high`). The User
  corrected this to `high`, which matches the catalog's already-checked
  entry; the file is renamed to `gemini-3.8-flash-high.md` accordingly.
  Fully resolved by the live Herdr `--kind agy` validation in this same day's
  Progress/Validation: native `agy models` and the live worker's own
  self-reported identity both independently confirmed the resolved model ID
  string is exactly `gemini-3.8-flash-high`, matching this file's name.
- Settled (2026-09-26): a family-wide (all-models) loading tier was
  considered as a possible gap but the User explicitly confirmed it is not
  needed. `layers/README.md` now states this as a deliberate decision rather
  than an open question; no further action is expected here.

## Decision and Result

Keep. The mechanism, now with exact-model-identifier matching, is
implemented, indexed, and exercised end-to-end by two fresh-agent replays
(family-level match, then the exact-match/decoy-skip behavior) plus one live
`--kind agy` Herdr trial dispatching the real `gemini-3.8-flash-high`
Antigravity worker, which independently confirmed the resolved model ID,
the exact-match, the required path announcement, and the receipt contract —
with no unintended repository changes. The `.gitignore` allowlist gap found
in the initial pass was fixed and is now documented as an explicit step for
future model additions. The real `gemini-3.8-flash-high.md` add-on (corrected
from an initial `-max.md` per the User's own correction) and its
`reasons-and-purposes.md` rationale entry are in place and now natively
proven to load; the family-wide-tier question is settled (not needed) rather
than left open. No open limitations remain for the `gemini-3.8-flash-high`
case.

Flatten continuation (2026-09-26): the User decided against any
provider/family subfolder at all — `docs-harness/layers/layer-1/agents/`
is now flat, one file per exact model. The Family matching table and its
reserved `claude`/`chatgpt`/`opencode` rows are removed along with the tier
they supported; a future model of any provider is simply a new file named
after its own resolved identifier, directly under `agents/`, with no
provider grouping to choose or maintain. This is a strict simplification of
already-proven matching logic (one exact-match tier instead of two), verified
by targeted self-review rather than a new replay; the underlying exact-match
behavior itself remains covered by the prior fresh-agent replays and the live
Herdr `--kind agy` trial.

Final continuation (2026-09-26): added `deepseek-v4.1-flash-max.md` for
DeepSeek V4.1 Flash (effort `max`, OpenCode Go), mirroring
`gemini-3.8-flash-high.md`'s reason and purpose exactly per the User's
instruction, and verified it with a live Herdr `--kind opencode` worker —
independently confirming the flat, exact-match mechanism generalizes across
providers (Antigravity and OpenCode Go so far) with zero mechanism changes,
only a new data file and one new catalog selection. `agents/reasons-and-purposes.md`
now documents both models and no longer reads as Gemini-specific. No open
limitations remain for either `gemini-3.8-flash-high` or
`deepseek-v4.1-flash-max`; `chatgpt` remains reserved, folder-less, pending
its own request.
