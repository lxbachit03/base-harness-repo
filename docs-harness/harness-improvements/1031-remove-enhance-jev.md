# Harness Improvement Resource

ID: #052_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Remove the enhance-jev skill
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/JEV-AI.md
- docs-harness/harness-improvements/0927-dynamic-jev-manifest-and-enhance-skill.md
- docs-harness/harness-improvements/1031-retire-jev-skill-router.md
- docs/tools/claude/README.md

## Objective

Remove the enhance-jev skill from both repository skill trees and reconcile its
current direct consumers while retaining the generic TypeSafe integration.

## Purposes

- [x] Retire a skill the User no longer wants in this Harness.
- [x] Avoid routing future work to a skill that no longer exists.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, HEAD `1a72228`.
The worktree already contains the unstaged helper and router retirements #050
and #051 and an unrelated untracked #012 plan; preserve all of them. The User
explicitly requested removal of the `enhance-jev` skill. Its two tracked
SKILL.md files exist and match. The manifest, capability catalogs, and Claude
skill list still point to it. The jev-hook is unchecked.

## Proposed Improvement

Delete the two skill entry points and remove current references to them. Keep
the Jev manifest and transport as available integrations. Hypothesis: native
skill discovery and current documentation will no longer direct agents to the
retired skill. Contrary evidence would be a live reference, broken current
link, missing retained transport, or mismatched mirrors. The manifest and
capability catalogs own their respective current guidance; revisit only if a
new customization workflow is requested.

## Scope

The two skill directories, direct active consumers, this record, and its INDEX
route. Preserve historical experiment records and calibration data as history,
the User-owned raw requirements, and existing worktree changes. Do not stage,
commit, push, or make live Jev calls for this removal.

## Progress

- 2026-10-31: Inspected both skill copies, current references, authority,
  baseline status, raw requirements, and the existing Jev manifest.
- Removed both skill entry points and their empty directories. Updated the Jev
  manifest, both copies of four capability catalogs, the Claude skill list,
  and the historical #035 INDEX annotation.

## Validation

Inspect affected current routes and links, confirm both skill entries are
absent and mirrored catalogs agree, preserve the disabled hook and generic
transport, and replay a relevant scenario in a fresh read-only agent session.

2026-10-31 native proof: both skill directories are absent; the four modified
capability catalog pairs have identical SHA-256 hashes; the generic transport
exists in both trees with matching hashes and is unchanged against HEAD. The
hook remains unchecked. A targeted search found no current `enhance-jev`
references outside historical records, router datasets, the INDEX history
route, and User-owned raw requirements. All 112 local Markdown links in the
12 inspected changed documents resolve. INDEX has no missing folders or
duplicate numeric IDs; the pre-existing untracked #012 plan is not indexed.
`git diff --check` passed with line-ending warnings only.

Fresh read-only replay: for a synthetic Jev-customization request, the worker
found both retired directories absent, no current catalog or manifest pointer,
and the retained `typesafe-ai` skill, manifest, and transport. The hook was
unchecked; no clarification, Jev/API call, or filesystem mutation was needed.
The replay checked repository files, not whether a host refreshes a skill
catalog already loaded in an existing session.

## Risks

- User-owned `docs/raw-requirements/skills/enhance-jev-ai.json` still defines
  the removed skill. Mitigation: leave it unchanged and propose removing that
  exact requirement file and its directory entry in the raw-requirements README.
- Historical records and router calibration data name the former skill.
  Mitigation: retain and identify them as history, not current routing.
- The unrelated pre-existing #012 plan is present without an INDEX route.
  Mitigation: review its status separately and add a route if it should remain
  a current indexed resource; this task leaves the plan and route unchanged.

## Decision and Result

Keep the removal. Both copies and current direct references are gone, while
generic TypeSafe usage remains available. Structural checks and the fresh
read-only scenario passed. Host catalog refresh behavior was not tested.
