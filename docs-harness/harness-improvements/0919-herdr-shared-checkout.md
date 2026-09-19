# Harness Improvement Resource

ID: #024_IMPROVE_HARNESS_0919
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Keep Herdr coordination in the current Git checkout
CREATED: 2026-09-19
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- .gitignore
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0907-bale-herdr-orchestration.md

## Objective

Make every Herdr coordination run in the coordinator's current Git checkout
instead of creating or selecting a separate Git worktree, detached checkout, or
clone. Preserve bounded ownership and acceptance checks while preventing
concurrent write workers from racing in the shared checkout.

## Current State

- Repository: `D:/repos/base-harness-repo`, branch `main`, revision
  `769858b69669061287ff7c5ee98096fc55a15c6d`.
- Baseline worktree: clean and synchronized with `origin/main`.
- `herdr` version: `0.7.5-preview.2026-07-21-0f10e1453a7f`.
- The current skill allows isolated worktrees for parallel writers and the
  runtime reference recommends a detached worktree for broad full-access work.
- The User explicitly requested that coordination never split into a Git
  worktree.

## Proposed Improvement

Update the Herdr coordination contract to use a Herdr terminal workspace with
the current checkout as its explicit `cwd`. State that a Herdr workspace/pane is
not a Git worktree and must not be implemented with `git worktree`, detached
checkout, or clone operations. Require serialized write-capable workers and
diff-scoped allowed paths when multiple workers share the checkout.

## Scope

In scope:

- `.agents/skills/herdr-coordinate-agents/SKILL.md`.
- Its `herdr-runtime.md` and `task-contract.md` references.
- `docs-harness/HERDR-AGENTS.md` where the full-access boundary describes the
  trusted checkout.
- This improvement record and its INDEX entry.

Out of scope:

- Herdr installation, server configuration, global Git settings, or provider
  permissions.
- Historical improvement evidence that records earlier isolated worktrees.
- Commits, pushes, or unrelated worker/session behavior.

## Progress

- 2026-09-19: Baseline captured, the User's no-worktree requirement recorded,
  and this improvement record created before intervention edits.
- 2026-09-19: Updated the Herdr skill, runtime reference, task contract,
  worker catalog, INDEX and ignore allowlist. The active contract now uses
  `shared-current-checkout`, explicit `--cwd`, serialized write workers and
  no Git worktree/detached-checkout path.

## Validation

- Native validation: inspect all changed coordination instructions and search
  the active Herdr contract for contradictory worktree creation guidance.
- Native result: `herdr --version` returned `0.7.5-preview.2026-07-21-0f10e1453a7f`;
  `herdr workspace create --help` exposes `--cwd`; `git diff --check` passed;
  and `git worktree list --porcelain` showed only the current `main` checkout.
- Targeted self-review found remaining `worktree` mentions only as explicit
  prohibitions in the active contract. Historical improvement evidence was left
  unchanged.
- Behavioral proof: pending a fresh bounded coordination replay whose worker
  uses the current checkout, with `git worktree list` checked before and after.
- No Herdr worker dispatch is performed during this intervention unless a
  separately authorized replay is run.

## Risks

- Shared-checkout write collisions: serialize write-capable workers, assign
  explicit allowed paths, and reject unexpected diff changes before acceptance.
- Full-access workers can alter unrelated files without Git isolation: retain
  the User authority gate, inspect the final diff, and pause on an unexpected
  path or missing checkout identity.

## Decision and Result

Implementation complete; fresh replay pending. The requested policy is
accepted by the User; effectiveness remains unverified until a bounded
no-worktree coordination case is run.
