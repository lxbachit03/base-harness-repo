# Harness Improvement Resource

ID: #091_IMPROVE_HARNESS_1122
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add a User-selectable /swarm dispatch option to agy-instructions/coding-subagent.md
CREATED: 2026-11-22
STATUS: completed
REFERENCES:
- docs-harness/agy-instructions/coding-subagent.md
- docs-harness/agy-instructions/README.md
- docs-harness/harness-improvements/1122-agy-instructions-folder.md
- docs/tools/antigravity/README.md

## Objective

`docs-harness/agy-instructions/coding-subagent.md` exposes a User-selectable `[x]`
dispatch-mode checklist letting the User choose between `invoke_subagent` (default,
fresh context via `TypeName: "self"` and 4-tier `Model`) and `/swarm` (swarm worker
via `swarm(action="add")`, supporting `fork: "coordinator"` to inherit parent
conversation history and a dedicated exact Gemini model checklist active **only** when
`/swarm` is marked), with clear steps for both branches and updated summary wording in
`docs-harness/agy-instructions/README.md`.

## Purposes

- [x] Let the User choose per repository checkout whether non-trivial Antigravity coding
  tasks dispatch through a fresh `invoke_subagent` (`self`) or a `/swarm` worker
  (which can fork parent conversation context via `fork: "coordinator"`), as requested
  by the User on 2026-11-22.
- [x] Keep `invoke_subagent` as the default (`[x]`) so existing behavior is preserved
  until the User marks `/swarm`, while requiring explicit User confirmation before
  spawning a `/swarm` worker.
- [x] Provide a dedicated exact Gemini model checklist under `## Model for /swarm`
  (plus `inherit`) that activates **only** when `/swarm` is checked under
  `## Dispatch mode` and is ignored when `invoke_subagent` is selected, as requested by
  the User on 2026-11-22.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `47285f0`, clean working
tree, synced with `origin/main`. `harness-check --quick` clean at 90 routed IDs
(`#001`–`#090`), 78 local INDEX links, 30 folders matching the Folder Tree.

Request: after asking whether an Antigravity coding subagent shares parent session
context and learning that `invoke_subagent` always starts fresh whereas `/swarm`
supports `fork: "coordinator"`, the User requested on 2026-11-22:
> "Ok, vậy thì trong file `coding-subagent.md`, hãy thêm một checkbox cho `/swarm` để cho User chọn theo cái hình thức mà họ muốn."

Gap: `docs-harness/agy-instructions/coding-subagent.md` currently only documents
`invoke_subagent` (`TypeName: "self"`, fresh context, 4-tier `Model`) and offers no
User-selectable option to dispatch coding work via `/swarm`.

## Proposed Improvement

Hypothesis: adding a concise `## Dispatch mode` checklist (`[x] invoke_subagent` and
`[ ] /swarm`) plus a clearly scoped `/swarm` branch in `coding-subagent.md` (and
aligning `agy-instructions/README.md`) will let fresh Antigravity sessions follow
whichever dispatch mode is checked without breaking `invoke_subagent` defaults or
calling `swarm` before the User opens `/swarm`. Maintenance owner: Harness maintainers
via `improve-harness`. Removal condition: remove or revise if Antigravity adds `fork`
to `invoke_subagent` or changes `/swarm` invocation rules.

1. Edit `docs-harness/agy-instructions/coding-subagent.md`:
   - Add `## Dispatch mode (select exactly one by marking [x])` with `[x] invoke_subagent`
     and `[ ] /swarm`, defaulting to `invoke_subagent` when none or several are marked.
   - Clarify that `## Model` applies to `invoke_subagent` (4 tiers); `/swarm` uses the
     coordinator's model or an exact model from `swarm(action="models")`.
   - Split `## Steps` cleanly into the `invoke_subagent` path, the `/swarm` path (asking
     the User to open `/swarm` if not already active, then confirming `fork: "coordinator"`
     vs fresh context, `workspace`, and `model` before `swarm(action="add")`), and the
     shared review gate.
2. Edit `docs-harness/agy-instructions/README.md` to include `swarm` in host-tool
   precedence, note `/swarm` exact-model exception in the model selection note, and
   update the `coding-subagent.md` bullet.
3. List `#091_IMPROVE_HARNESS_1122` in `docs-harness/harness-improvements/README.md`.

## Scope

May change: `docs-harness/agy-instructions/coding-subagent.md`,
`docs-harness/agy-instructions/README.md`, `docs-harness/harness-improvements/README.md`,
and this record.
Unchanged: `docs-harness/claude-instructions/*`, other files in `docs-harness/agy-instructions/`,
`docs-harness/INDEX.md` (folder/file tree unchanged), `docs/raw-requirements/*`, `#009`,
`#058`, `#074`, and `docs/tools/antigravity/README.md`.
Nothing is staged, committed, or pushed.

## Progress

- 2026-11-22: Record `#091_IMPROVE_HARNESS_1122` opened before intervention edits at
  baseline `47285f0` (clean working tree, 90 routed IDs) and listed in
  `docs-harness/harness-improvements/README.md`.
- 2026-11-22: Updated `docs-harness/agy-instructions/coding-subagent.md` with the
  `## Dispatch mode` checklist (`[x] invoke_subagent`, `[ ] /swarm`), scoped `## Model`
  to `invoke_subagent`, added the `/swarm` branch and shared review gate, and aligned
  `docs-harness/agy-instructions/README.md`.
- 2026-11-22: Full `harness-check` passed (`RESULT: clean`) and fresh read-only
  Antigravity replay #1 (`e5c96526-853b-4c25-97cc-675b622ddc1e`) verified schema alignment
  and all three scenario gates. Set `STATUS: completed` with `Decision: keep`.
- 2026-11-22 (continuation): At the User's follow-up request, added
  `## Model for /swarm` (16 Gemini exact model+effort choices with
  `[x] gemini-4-hydrogen-xhigh` plus `inherit`), explicitly scoped to apply only when
  `/swarm` is marked under `## Dispatch mode` and ignored when `invoke_subagent` is
  selected. Added `Role` to `invoke_subagent` Step 2 and added a `swarm(action="models",
  all=true)` mismatch fallback in `/swarm` Step 4. Re-ran full `harness-check`
  (`RESULT: clean`) and fresh read-only Antigravity replay #2
  (`a398546c-9369-4d6a-b11f-d7643ad2e9b9`). Kept `STATUS: completed` and `Decision: keep`.
  Nothing staged, committed, or pushed.

- 2026-11-22 (live `/swarm` verification & correction): At the User's explicit request,
  ran live `swarm(action="models", all=true)` and `swarm(action="status")` plus two live
  read-only swarm workers on `gemini-4-hydrogen-xhigh` (`swarm-check` with
  `fork: "coordinator"` and `swarm-fresh` without `fork`, coordinator running on
  `gemini-4-neon-high`). Live proof confirmed: (1) all 16 Gemini model IDs and display
  names match `swarm(action="models", all=true)` 100%; (2) `swarm(action="add")` starts a
  local swarm directly after User confirmation without requiring the User to type `/swarm`
  first; (3) `fork: "coordinator"` returned a transient `executor has not processed the
  previous input yet` error yet still created `swarm-check` (`state: "working"`), which
  ran on `gemini-4-hydrogen-xhigh`, recalled prior coordinator chat turns without reading
  `R&D/`, and posted board message `#3`; (4) `swarm-fresh` started cleanly with fresh
  context and posted `#4`. Updated `coding-subagent.md` to remove the overly strict
  "cannot open `/swarm`" gate, document direct confirmation + `open_board` link, and
  document the `fork: "coordinator"` status-check guard. Killed both test workers and
  re-ran full `harness-check` (`RESULT: clean`). Nothing staged, committed, or pushed.

## Validation

Results, 2026-11-22:
- `python -I .agents/skills/harness-check/scripts/harness_check.py` (full): `RESULT: clean`
  (exit 0) — 91 unique IDs (`#001`–`#091`), 91 routed resources, 78 local INDEX links, 30
  folders matching Folder Tree, 23 folders with `README.md`, 1,102 local links across 200
  Markdown files, 20 skills (70 files) identical.
- Fresh read-only Antigravity replay #1 (`e5c96526-853b-4c25-97cc-675b622ddc1e`,
  `TypeName: "self"`, `Model: "flash"`, zero file edits, zero subagents/workers spawned):
  verified initial dispatch-mode split and live tool schemas across Scenarios A–C.
- Fresh read-only Antigravity replay #2 (`a398546c-9369-4d6a-b11f-d7643ad2e9b9`,
  `TypeName: "self"`, `Model: "flash"`, zero file edits, zero subagents/workers spawned):
  verified all three `[x]` defaults (`invoke_subagent`, `pro`, `gemini-4-hydrogen-xhigh`),
  zero schema mismatches across `invoke_subagent` and `swarm`, and isolation between
  `## Model for invoke_subagent` and `## Model for /swarm`.
- Live `/swarm` verification (User-authorized, 2026-11-22, coordinator on
  `gemini-4-neon-high`, `workspace: "inherit"`, strictly read-only workers):
  - `swarm(action="models", all=true)`: returned 23 models; all 16 Gemini IDs and display
    names in `coding-subagent.md` matched 100% (`gemini-4-hydrogen-xhigh` quota `54%`).
  - `swarm(action="status")` before spawn: `{"status":"no swarm yet; add a worker to start one"}`.
  - `swarm(action="add", name="swarm-check", model="gemini-4-hydrogen-xhigh", fork="coordinator", workspace="inherit")`:
    returned transient tool error `executor has not processed the previous input yet`, yet
    `swarm(action="status")` showed `swarm-check` active on `gemini-4-hydrogen-xhigh`;
    `swarm-check` posted board message `#3` accurately recalling `DietrichGebert/ponytail`,
    `R&D/ponytail-deep-research.md`, and commit `47285f0` directly from forked parent
    context without reading `R&D/`, plus all three `[x]` items in `coding-subagent.md`.
  - `swarm(action="add", name="swarm-fresh", model="gemini-4-hydrogen-xhigh", workspace="inherit")`:
    returned `status: "added"` (`conversation_id: a425df06-1461-4c29-9ee3-e0144e539bcf`)
    and posted board message `#4` confirming fresh context (no prior coordinator chat
    visible), all three `[x]` items, and `harness_check.py --quick` clean.
  - Cleaned up both read-only test workers via `swarm(action="kill")`.

Unattempted proof:
- Live `/swarm` coding worker performing real file edits in `workspace: "share"` or
  `workspace: "branch"` and landing changes back before `swarm(action="kill")`.
- Re-running a fresh read-only subagent replay after the minor wording update in
  `### When /swarm is selected` (Steps 1–3).

## Risks

- `swarm(action="add", ..., fork="coordinator")` can emit a transient error
  (`executor has not processed the previous input yet`) while still creating and running
  the worker. Mitigation: Step 3 instructs checking `swarm(action="status")` before
  retrying so agents do not spawn duplicate workers.
- Users might expect the `## Model for /swarm` exact IDs to apply to `invoke_subagent`,
  or live `swarm(action="models", all=true)` IDs could drift over Antigravity releases.
  Mitigation: `## Model for /swarm` explicitly states it is ignored when `invoke_subagent`
  is selected, and Step 4 requires verifying against live `swarm(action="models", all=true)`
  and asking the User if an entry is unlisted or rejected.
- Extra checklist adds lines to an always-loaded file. Mitigation: keep wording tight and
  pruned per `writing-for-agents`.

## Decision and Result

Decision: keep. The dispatch-mode split, exact Gemini `/swarm` model list, and both live
`/swarm` context modes (`fork: "coordinator"` and fresh) were verified directly on
Antigravity (`swarm(action="models", all=true)`, live workers `swarm-check` `#3` and
`swarm-fresh` `#4` pinned to `gemini-4-hydrogen-xhigh`, plus fresh read-only replays
`e5c96526-853b-4c25-97cc-675b622ddc1e` and `a398546c-9369-4d6a-b11f-d7643ad2e9b9`), and
full `harness-check` passed (`RESULT: clean`).

Remaining limits / unattempted proof: live `/swarm` file-editing worker in `share`/`branch`
workspace with landing before `kill`, and a fresh replay on the updated direct-start
wording in `### When /swarm is selected`.
