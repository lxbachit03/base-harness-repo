# Harness Improvement Resource

ID: #045_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Coordinate agents on the current branch without Git worktrees, for Herdr and Orca
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- .agents/skills/orca-ade-coordinate-agents/SKILL.md
- .agents/skills/orca-ade-coordinate-agents/references/coordination-protocol.md
- .agents/skills/utilizing-tools-orca-ade/SKILL.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- docs/tools/orca-ade/README.md
- docs/tools/claude/README.md
- docs-harness/harness-improvements/0919-herdr-shared-checkout.md
- docs-harness/harness-improvements/0926-utilizing-tools-orca-ade.md
- docs-harness/harness-improvements/0926-orca-ade-coordinate-agents.md
- docs-harness/harness-improvements/1003-group-d-policy-decisions.md

## Objective

No agent coordination creates or uses a Git worktree: both Herdr and Orca
coordination run every worker on the coordinator's current checkout and
branch, with the shared-checkout rules (owned paths, serialized writers,
parallel only for read-only or disjoint outputs). Orca coordination still runs
only when the User selects it. The Claude Code team doc reflects the Orca
route and the current skill list.

## Purposes

- [x] Apply one coordination rule to every runtime: work on the current
  branch, never in a worktree (User decision 2026-10-05).
- [x] Keep Orca as a User-selected control plane (panes, relay, diff review,
  browser) without branch or worktree management.

## Current State

Baseline (2026-10-05): `main` at `9b71345`. User decisions (2026-10-05):

| # | Decision |
| --- | --- |
| F6 | Option 1: whether Orca or Herdr, no Git worktree; coordinate agents on the current branch. Supersedes the "Orca coordination may use worktrees when the User selects it" part of D1 (#041) |
| F7 | `docs/tools/claude/README.md`: add the Orca route, update the skill list |
| F10 | Current-policy notice on #032 |

Before: `orca-ade-coordinate-agents` created a worktree per write-capable
worker and removed it with `--force`; `utilizing-tools-orca-ade`, the Herdr
skill, `suggest-skill.ps1` and `docs/tools/orca-ade/README.md` described Orca
worktrees as allowed when the User selects Orca.

## Proposed Improvement

Rewrite the Orca coordination skill and its protocol reference for the
current checkout; remove worktree permission from the other consumers; add
notices to #031, #032 and #041; update the Claude team doc.

## Scope

May change: files in REFERENCES, their `.claude/skills/` mirrors, this
record, its INDEX entry and `.gitignore` line (if still present).

Unchanged: Orca's generic worktree commands in tool catalogs (they stay
documented as Orca capabilities, not for coordination); Herdr launch rules.

## Progress

- 2026-10-05: Record created before edits.
- 2026-10-05: Rewrote `orca-ade-coordinate-agents` (SKILL.md and protocol) for
  the current checkout: record the starting state, assign owned paths,
  serialize writers, panes via `--worktree <current-checkout-selector>`
  (Orca's name for the checkout), no create/remove; teardown compares
  `git status` with the start. Removed worktree permission from
  `utilizing-tools-orca-ade`, the Herdr skill, `suggest-skill.ps1` and
  `docs/tools/orca-ade`; updated `docs/tools/claude` (Orca route,
  `isolation: "worktree"` ban, skill list); notices on #031, #032, #041.
- 2026-10-05: The combined replay passed and found `utilizing-tools-claude`
  still routing delegation only through Herdr with no worktree caveat, and
  no completion state for a reported out-of-scope change; both fixed.

## Validation

- Native: no current guidance permits a worktree for coordination; links
  resolve; mirror diff.
- Fresh replay: a fresh read-only worker answers how to coordinate two
  writing workers with Orca and with Herdr, and whether a worktree may be used.

## Risks

- Parallel writers on one checkout can conflict. Mitigation: owned paths and
  serialized writers, as Herdr already requires.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05): a sweep of AGENTS.md, `docs-harness/` (records
excluded), `.agents/skills` and `docs/tools` finds no text permitting a
worktree for coordination; Orca's generic worktree commands remain labelled
"User request only; never for agent coordination"; `.agents`/`.claude` differ
only by line endings.

Fresh replay (combined with #044; fresh native read-only worker): for two
writing agents it answered with owned paths and serialized or disjoint
writers on the shared checkout for both Herdr and Orca, "never" for a
worktree, detached checkout or `isolation: worktree`, and described the Orca
teardown (close terminals, compare `git status` with the starting state).
The two fixes after it were checked natively.
