# Harness Improvement Resource

ID: #030_IMPROVE_HARNESS_0926
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Model-family add-on prompt layers under docs-harness/layers/
CREATED: 2026-09-26
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/PERSONA.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/layers/README.md
- docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md
- docs-harness/layers/layer-1/agents/gemini/reasons-and-purposes.md
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

## Scope

In scope: `docs-harness/layers/` (structure and content), `docs-harness/layers/README.md`
(owning contract, including the model-specific matching tier added in this
continuation), `docs-harness/layers/layer-1/agents/gemini/gemini-3.8-flash-high.md`
(real add-on content) and `.../reasons-and-purposes.md` (rationale log), and
`docs-harness/INDEX.md` (session retrieval, folder tree, Supporting Folders
route, IMPROVE_HARNESS index entry).

Out of scope: AGENTS.md (no session-role or task-authority change needed);
authoring add-on content for any other specific model (only
`gemini-3.8-flash-high` was requested); the `claude`/`chatgpt`/`opencode`
family folders themselves (reserved as table rows only, per the User's
"later" framing); a family-wide (non-model-specific) loading tier — the User
explicitly confirmed this is not needed, so it is a settled decision, not an
open gap.

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

## Validation

Native/static checks:
- Re-read `docs-harness/INDEX.md` after editing: folder tree lists `layers/`
  with its `layer-1/agents/gemini/` descendant; Session retrieval references
  `layers/README.md`; a `### layers/` Supporting Folders route exists with a
  working relative link; the `IMPROVE_HARNESS` list carries this record's
  entry with matching ID/priority.
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

Not attempted: no repository validator script was created or invoked (not
authorized); no multi-model production replay across ChatGPT or OpenCode-
hosted sessions was run (those rows remain reserved, folder-less; no adapter
proof exists for them yet).

## Risks

- The Family matching table's identity signals (e.g., "model ID/name
  containing gemini") are heuristic text matches, not a verified API; a future
  model naming change could silently stop matching. Mitigation: the table is
  the single edit point, so a mismatch is a one-row fix, not a multi-file
  routing change.
- Per-session file announcements add small, bounded token/latency overhead
  proportional to the number of files in a matching family folder. Mitigation:
  the procedure explicitly skips non-matching layers/families with no
  notification, keeping the no-match case (today's default, since only
  `gemini` has content and no session here is Gemini/Antigravity) effectively
  free.
- The `gemini` row's "regardless of which model Antigravity is hosting"
  clause groups Antigravity-as-runtime with Gemini-as-model per the User's own
  grouping; if the User later wants per-model granularity inside Antigravity
  (e.g. a separate folder for `antigravity-claude-*` presets), the row will
  need splitting. Mitigation: flagged here for the User's awareness; not
  blocking since it matches the literal request.
- A future contributor could add a new `agents/<family>/` folder/file and
  forget the required `.gitignore` allowlist lines, silently leaving the new
  add-on uncommitted (this happened during this task's own implementation).
  Mitigation: `docs-harness/layers/README.md`'s "Adding a new AI model family"
  steps now explicitly call out the `.gitignore` allowlist as step 3.
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
future family/model additions. The real `gemini-3.8-flash-high.md` add-on
(corrected from an initial `-max.md` per the User's own correction) and its
`reasons-and-purposes.md` rationale entry are in place and now natively
proven to load; the family-wide-tier question is settled (not needed) rather
than left open. No open limitations remain for the `gemini-3.8-flash-high`
case; `chatgpt`/`opencode` rows remain reserved pending their own adapter
proof and add-on content, not requested yet.
