# Harness Improvement Resource

ID: #090_IMPROVE_HARNESS_1122
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add an agy-instructions folder with four Antigravity operational guides read at session start
CREATED: 2026-11-22
STATUS: completed
REFERENCES:
- docs-harness/agy-instructions/README.md
- docs-harness/agy-instructions/research-subagents.md
- docs-harness/agy-instructions/compact-before-task.md
- docs-harness/agy-instructions/prd-research-subagent.md
- docs-harness/agy-instructions/coding-subagent.md
- docs-harness/INDEX.md
- docs-harness/README.md
- docs-harness/layers/README.md
- docs-harness/harness-constraints/1120-session-role-and-judgment.md
- docs-harness/claude-instructions/README.md
- docs/tools/antigravity/README.md

## Objective

`docs-harness/agy-instructions/` exists with a `README.md` and four Antigravity-adapted
instruction files (`research-subagents.md`, `compact-before-task.md`,
`prd-research-subagent.md`, `coding-subagent.md`), each subagent instruction carrying
its own selectable Gemini model-tier checklist (`[x]`). `docs-harness/INDEX.md` routes the
folder so Antigravity sessions read `agy-instructions/README.md` and every Markdown file
under it at session start after the layers step, while non-Antigravity sessions skip it.
`docs-harness/claude-instructions/` remains unchanged, and `agy-instructions/README.md`
states that Antigravity host tools take precedence when a `claude-*` model runs inside
Antigravity.

## Purposes

- [x] Give Antigravity-specific operational instructions one session-start home parallel to
  `claude-instructions/`, as requested by the User on 2026-11-22.
- [x] Port all four workflows from `claude-instructions/` to Antigravity's native primitives
  (`invoke_subagent`, `ask_question`, `run_workflow`, `/compact`) while giving each subagent
  instruction its own User-selectable Gemini model-tier checklist.
- [x] Leave `claude-instructions/` unmodified and resolve `claude-*`-on-Antigravity overlap
  via an explicit host-tool precedence rule in `agy-instructions/README.md`.
- [ ] Candidate, awaiting the User: verify live `/compact <prompt>` retention behavior on
  Antigravity App 2.0 and CLI and refine `compact-before-task.md` if needed.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `421b386` (one local commit
ahead of `origin/main`), working tree clean. `harness-check --quick` clean at 89 routed IDs
(`#001`–`#089`), 75 INDEX links, 29 folders matching the Folder Tree.

Request: after a read-only comparison of `docs-harness/claude-instructions/` against
Antigravity capabilities, the User asked on 2026-11-22 to implement an Antigravity
instructions folder via `improve-harness`, choosing:
- folder name: `docs-harness/agy-instructions/`;
- initial files: all four adapted guides (`research-subagents.md`, `compact-before-task.md`,
  `prd-research-sub-session.md`, `coding-sub-session.md`), with independent Gemini model
  selection per instruction;
- overlap handling: leave `docs-harness/claude-instructions/` unchanged and declare
  Antigravity host-tool precedence inside `agy-instructions/README.md`.

Gap: Antigravity sessions currently skip `claude-instructions/` and have no platform-wide
session-start home for subagent delegation or pre-task compaction rules (`layers/` only
matches exact `model+effort` identifiers per the 2026-09-26 User decision). In addition,
`#074_CONSTRAINTS_1120` currently grants the worker research-subagent exception only to
`claude-instructions/research-subagents.md`.

## Proposed Improvement

Hypothesis: adding `docs-harness/agy-instructions/` with concise, AGY-native guides and
wiring it into `INDEX.md`, `docs-harness/README.md`, `layers/README.md`, and `#074` will
cause fresh Antigravity sessions to retrieve and apply the four workflows without invoking
Claude-only tools or breaking `harness-check`. Maintenance owner: Harness maintainers via
`improve-harness`. Removal condition: remove or trim if Antigravity sessions stop using
these workflows or platform primitives supersede them.

1. Create `docs-harness/agy-instructions/README.md` with platform trigger signals
   (Antigravity App 2.0, CLI `agy`, Antigravity IDE, Antigravity SDK), host-tool precedence
   rule when running a `claude-*` model on Antigravity, model-tier note, authoring rules,
   existing AGY references, and the four-file list.
2. Create the four instruction files under `docs-harness/agy-instructions/`:
   - `research-subagents.md` (`TypeName: "research"`, `[x]` model-tier checklist defaulting
     to `flash`);
   - `compact-before-task.md` (>50% context gate and English `/compact` prompt block);
   - `prd-research-subagent.md` (`TypeName: "self"`, `Workspace: "inherit"`, `[x]`
     model-tier checklist defaulting to `pro`);
   - `coding-subagent.md` (`TypeName: "self"`, `Workspace: "inherit"`, Orchestrator
     skip rule, `[x]` model-tier checklist defaulting to `pro`, no `effort`/advisor tool).
3. Update `docs-harness/INDEX.md` (Session retrieval, Folder Tree, Supporting Folders).
4. Update `docs-harness/README.md` (Local Folder Guide) and `docs-harness/layers/README.md`
   (pointer alongside `claude-instructions/`).
5. Update `docs-harness/harness-constraints/1120-session-role-and-judgment.md` (`#074`) so
   the worker research-subagent exception covers `agy-instructions/research-subagents.md`.
6. List `#090_IMPROVE_HARNESS_1122` in `docs-harness/harness-improvements/README.md`.

## Scope

May change: the new `docs-harness/agy-instructions/` files, this record, and the five
routing/consumer files listed above.
Unchanged: `docs-harness/claude-instructions/*`, `docs/raw-requirements/*`,
`docs-harness/layers/layer-1/agents/*`, `#009` task authority, `#058` unit-test authority,
`docs/tools/antigravity/README.md`, and `.agents/skills/utilizing-tools-agy/SKILL.md`.
Instruction files under `agy-instructions/` are not canonical resources and take no ID.
Nothing is staged, committed, or pushed.

## Progress

- 2026-11-22: Record `#090_IMPROVE_HARNESS_1122` opened before intervention edits; baseline
  captured at revision `421b386` (clean working tree, 89 routed IDs).
- 2026-11-22: Created `docs-harness/agy-instructions/README.md` and four guides
  (`research-subagents.md`, `compact-before-task.md`, `prd-research-sub-session.md`,
  `coding-sub-session.md`); updated `INDEX.md`, `docs-harness/README.md`,
  `layers/README.md`, `harness-constraints/1120-session-role-and-judgment.md`, and
  `harness-improvements/README.md`. Left `docs-harness/claude-instructions/` untouched.
- 2026-11-22: Full `harness-check` passed (`RESULT: clean`) and fresh Antigravity replay
  (`082fd293-8efb-4883-92b6-1098a95bf2da`) succeeded across all five check items. Set
  `STATUS: completed` with `Decision: keep`. Nothing staged, committed, or pushed.
- 2026-11-22 (continuation): The User edited the three subagent checklists to exact
  model+effort IDs (`gemini-4-hydrogen-high`, `gemini-4-neon-high`,
  `gemini-4-hydrogen-xhigh`). Fresh replay #2 (`e7f02911-799e-469b-8415-13393d9ddd07`)
  exposed the schema mismatch between exact IDs and `invoke_subagent`'s 4-tier `Model`
  enum (`inherit`, `flash_lite`, `flash`, `pro`). After review, the User chose Option 2
  (keep native `invoke_subagent` with the 4-tier checklists). Restored the 4-tier
  checklists across the three files (noting `inherit` keeps the parent session's exact
  model and effort in fresh context), re-ran full `harness-check` (`RESULT: clean`), and
  confirmed zero mismatches in fresh replay #3 (`781c4e8c-d430-4e4a-a214-be55501f802c`).
  Nothing staged, committed, or pushed.
- 2026-11-22 (rename for AGY terminology): At the User's request, renamed
  `prd-research-sub-session.md` → `prd-research-subagent.md` and
  `coding-sub-session.md` → `coding-subagent.md` (with matching `# ... in a subagent`
  headings and updated `agy-instructions/README.md` links) to match Antigravity's native
  `subagent` terminology instead of Claude's `sub-session` wording. Re-ran full
  `harness-check` (`RESULT: clean`). Nothing staged, committed, or pushed.

## Validation

Results, 2026-11-22:
- `python -I .agents/skills/harness-check/scripts/harness_check.py` (full): `RESULT: clean`
  (exit 0) — 90 unique IDs (`#001`–`#090`), 90 routed resources, 78 local INDEX links, 30
  folders matching Folder Tree, 23 folders with `README.md`, 1,100 local links across 198
  Markdown files, 20 skills (70 files) identical.
- `git diff --stat`: 5 tracked files modified (`INDEX.md`, `docs-harness/README.md`,
  `layers/README.md`, `harness-constraints/1120-session-role-and-judgment.md`,
  `harness-improvements/README.md`; +30/-4 lines), plus `docs-harness/agy-instructions/`
  (5 new files) and this record. `docs-harness/claude-instructions/` shows zero diff.
- Fresh Antigravity replay #1 (`082fd293-8efb-4883-92b6-1098a95bf2da`, `TypeName: "self"`,
  `Model: "flash"`, read-only, no folder name hint in prompt): retrieved `agy-instructions/`
  autonomously at session start, skipped `claude-instructions/`, read all three `[x]` model
  tiers accurately (`flash`, `pro`, `pro`), produced exact first gates for all four
  scenarios (including `#074` worker distinctions), and cited `agy-instructions/README.md`
  host-tool precedence. Zero file edits and zero subagents spawned.
- Fresh Antigravity replay #2 (`e7f02911-799e-469b-8415-13393d9ddd07`, `TypeName: "self"`,
  `Model: "flash"`, read-only, after User edited checklists to exact model+effort IDs):
  detected that exact IDs (`gemini-4-hydrogen-high`, `gemini-4-neon-high`,
  `gemini-4-hydrogen-xhigh`) are invalid enum values for `invoke_subagent`'s `Model`
  parameter and conflict with Steps 1, 2, and 4.
- Fresh Antigravity replay #3 (`781c4e8c-d430-4e4a-a214-be55501f802c`, `TypeName: "self"`,
  `Model: "flash"`, read-only, after Option 2 restored the 4-tier checklists): loaded all
  five `agy-instructions/` files, skipped `claude-instructions/`, verified zero mismatches
  between all checklist options and `invoke_subagent`'s `Model` enum (`flash`, `pro`,
  `pro` marked `[x]`), and produced exact first gates for all four scenarios with zero file
  edits and zero subagents spawned.

Unattempted proof:
- A non-Antigravity host session verifying that it skips `agy-instructions/`.
- An Antigravity session running a `claude-*` model exercising live host-tool precedence
  when both folders load.
- Live `/compact <prompt>` execution on Antigravity App 2.0 / CLI verifying how trailing
  prompt text is handled during compaction.

## Risks

- Antigravity's `invoke_subagent` accepts only four model tiers (`flash_lite`, `flash`,
  `pro`, `inherit`) and has no exact-model or `effort` argument. Mitigation: each subagent
  instruction uses a real tier checklist and explicitly documents the tier-only limit so
  agents never pass invalid schema values.
- A session running a `claude-*` model inside Antigravity matches both
  `claude-instructions/` and `agy-instructions/`. Mitigation: `agy-instructions/README.md`
  explicitly gives Antigravity host tools and rules precedence on Antigravity hosts while
  respecting the User's choice not to edit `claude-instructions/`.
- `/compact <prompt>` retention behavior on Antigravity App 2.0 / CLI has not yet been
  tested live (docs describe trailing text as a next-step message). Mitigation: the prompt
  block states both context to retain and the next task, and live testing is tracked as an
  open verification item.
- Loading four instruction files at every Antigravity session start adds context load.
  Mitigation: keep every file short, single-topic, and pruned per `writing-for-agents`.

## Decision and Result

Decision: keep. The intervention was available, retrieved without hinting, and exercised
correctly up to every simulated gate across fresh read-only Antigravity replays
(`082fd293-8efb-4883-92b6-1098a95bf2da`, defect-finding replay
`e7f02911-799e-469b-8415-13393d9ddd07`, and post-fix verification replay
`781c4e8c-d430-4e4a-a214-be55501f802c`; all `Model: "flash"`, baseline `421b386` +
working-tree edits, zero file edits, zero subagents spawned). Token cost was not measured.

Observed: the fresh Antigravity session loaded `agy-instructions/README.md` and all four
instruction files after the layers step, skipped `claude-instructions/`, accurately read all
three independent `[x]` Gemini model-tier checklists (`flash`, `pro`, `pro`), stated the
exact first gate for all four workflows (`research-subagents`, `prd-research-sub-session`,
`coding-sub-session`, `compact-before-task`), and cited `agy-instructions/README.md` for
host-tool precedence on `claude-*`-in-Antigravity sessions.

Remaining limits / unattempted proof: non-Antigravity skip behavior, live `claude-*`-on-AGY
dual-load run, and live `/compact <prompt>` retention behavior on Antigravity App 2.0 / CLI.
