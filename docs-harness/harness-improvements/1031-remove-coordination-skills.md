# Harness Improvement Resource

ID: #048_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Remove the Herdr and Orca ADE coordination skills
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- README.md
- docs-harness/INDEX.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/JEV-AI.md
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/utilizing-tools-orca-ade/SKILL.md

## Objective

Remove `herdr-coordinate-agents` and `orca-ade-coordinate-agents` from both
repository skill trees and stop current guidance and the Jev router from
selecting either removed skill.

## Purposes

- [x] Remove the two skills explicitly named by the User from the current repo.
- [x] Keep current routing usable after removal while preserving historical evidence.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, commit `6b1bd92`, clean
tracked working tree. The four skill directories contain 12 tracked files and
no untracked or ignored files. Nine unrelated ignored files elsewhere are
outside this change.

AGENTS.md, INDEX, README, Claude guidance and the Jev router select the Herdr
skill; the router also selects the Orca ADE coordination skill. The surviving
Orca tool-selection skill embeds the retired Herdr coordination workflow.

Remote `main` remains at `9651492`, ten commits ahead. Its resource sequence
already reaches #047, observed in the preceding status inspection; #048 avoids
reusing the upstream IDs #037 through #047. This task does not synchronize Git.

## Proposed Improvement

Remove the skill packages and their active consumers together. The hypothesis
is that eliminating all three router entry paths (explicit match, Jev choices,
offline heuristic) and current instruction pointers prevents selection of the
removed packages. Historical references are contrary evidence only if they are
presented as current instructions; label their retained scope explicitly.

The repository guidance and router remain the maintenance owners. Reintroducing
either package would require a new User request.

## Scope

Delete only the two named directories under `.agents/skills/` and their
`.claude/skills/` mirrors. Update direct routing consumers, annotate the retained
Herdr catalog and Orca integration history, and register this record in INDEX
and the existing Git ignore allowlist. Preserve other skills and experiment
histories. No staging, commits, pushes, dependency installation or global edits.

## Progress

- 2026-10-31: User explicitly requested removal of both skills. Inspected their
  tracked inventories, current consumers and applicable improvement workflow.
- Jev file-operations consult: `proceed_with_caution`; shell consult: `proceed`.
  Both used `jev-1.14.0`, with no fallback. Mitigation: verify absolute deletion
  targets, preserve unrelated files, and retain recovery through Git.
- Removed all 12 tracked files with explicit file patches, then removed only
  the verified empty directories. The first recursive-deletion command was
  rejected by automatic policy review before execution; the bounded file-patch
  and empty-directory method succeeded.
- Updated current instructions, router candidates and fallback, and mirrored
  the three changed skill files. Preserved historical records and marked the
  former Herdr catalog and Orca integration instructions as historical.
- Coordination consult: `proceed`, `jev-1.14.0`, no fallback. Started one fresh
  native read-only worker (`/root/removal_replay`) for the required replay.
- Reviewed the returned fresh-session evidence. Applied its clarity suggestion
  by labeling the two original skill-creation entries in INDEX as historical.

## Validation

- Native inspection: all four directories removed; both top-level skill trees
  now contain 16 skills. `git diff --check` passed. The native comparison
  `git -c core.autocrlf=false diff --no-index --stat -- .agents/skills .claude/skills`
  returned exit 0. The same nine unrelated ignored files remain.
- Current-reference search covered AGENTS.md, root README, INDEX, both skill
  trees and docs/. Its only remaining match for the removed skill names was
  the historical #032 record path in INDEX; the adjacent history notice names
  the retained baseline revision. Historical record bodies were preserved.
- Inspected the owner diffs, #048 metadata, allowlist entry, current links from
  INDEX/catalog/Orca documentation, and layer identity wording. No product or
  domain claims were changed; domain/ still contains only its guide.
- Explicit router call with `$ticket-solving`: `ExplicitMention`, chain
  `[ticket-solving]`, no fallback.
- Live router call mentioning both removed names: `JevCompositeDecision`,
  chain `[utilizing-tools-agy, utilizing-tools-orca-ade]`, model `jev-1.14.0`,
  750 ms, no fallback. Neither removed name appeared in the sent criteria or
  returned chain. This proves removal from candidates, not routing quality for
  every possible coordination request.
- Simulated offline call with `delegate a Herdr worker`: `HeuristicFallback`,
  chain `[typesafe-ai]`. A process-local HTTP function deliberately threw before
  network access; credentials and persistent configuration were unchanged.
  This was a fallback-path test, not a Jev outage or a gate bypass.
- Fresh read-only discovery replay: PASS for the requested routing outcome.
  The worker loaded AGENTS, INDEX, persona and layers/hooks, observed all four
  paths absent, read the router and affected Claude/Orca guidance, and correctly
  distinguished historical references from current capabilities. It selected
  the surviving `utilizing-tools-orca-ade` as the route for ordinary Orca tool
  use and found no live pointer to either removed package. No files were
  changed and no workers were launched by the replay worker.
- Replay limitation: the worker's own Jev consult returned HTTP 422 after
  3715 ms and used the hook's documented unavailable-consult bypass. Review of
  its exact payload found `question`/`options` fields instead of the required
  `instructions`/`criteria`; this was a malformed request, not evidence of a
  service outage. The parent session's three gate consults and live router call
  succeeded. No gate bypass occurred in the parent session. No repository
  validator script was created or invoked for guidance proof.

## Risks

- Historical records contain paths to deleted packages. Mitigation: mark the
  historical scope in INDEX and the retained catalog; retrieve original files
  with `git show 6b1bd92:<repository-relative-path>` when studying that history.
- Later upstream synchronization overlaps these routing files. Mitigation:
  preserve this diff and reconcile the explicit removal when synchronizing;
  do not restore the deleted packages implicitly.

## Decision and Result

Keep the scoped removal. Both packages and mirrors are removed, current
consumers no longer select them, and focused router checks plus the fresh
discovery replay establish the requested behavior. The follow-up historical
labels clarify an outcome the worker already interpreted correctly.

The remaining references preserve past evidence at `6b1bd92`. This result does
not claim an Orca/Herdr runtime integration test, exhaustive semantic routing
quality, or improved productivity. Existing upstream synchronization and
unrelated ignored files remain outside the task.
