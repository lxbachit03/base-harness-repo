# Harness Improvement Resource

ID: #051_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Retire the Jev skill router
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/JEV-AI.md
- docs-harness/harness-improvements/1031-jev-integration-reliability.md
- docs-harness/harness-improvements/1031-retire-jev-helpers.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/
- .agents/skills/typesafe-ai/tests/reliability-check.ps1
- .claude/skills/typesafe-ai/

## Objective

Retire the Jev skill-router helper and its mirror, and update current direct
consumers while preserving the generic Jev transport and ordinary skill use.

## Purposes

- [x] Remove a dedicated Jev skill-routing helper the User no longer needs.
- [x] Keep remaining guidance and tests aligned with available functionality.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, HEAD `1a72228`.
The worktree contains unstaged and untracked changes from the immediately prior
retirement of three other helpers, including the completed #050 record. The
pre-existing untracked plan `docs-harness/plans/completed/0902-evidence-backed-domain-freshness.md`
is unrelated and must remain untouched. The `jev-hook` checkbox is unchecked.

At baseline, `suggest-skill.ps1` existed in both skill trees and was referenced
by the Jev manifest, TypeSafe skill documents, and mocked offline test runner.
The User explicitly requested removing this remaining router.

## Proposed Improvement

Update the manifest first, then remove the router and direct executable
consumers. Preserve prior #049 calibration datasets as historical evidence,
not active router instructions. Hypothesis: removing the obsolete route and
router-specific tests leaves generic Jev invocation intact. Contrary evidence
would be a broken retained link, mirror, test, or invocation. The manifest and
TypeSafe skill remain maintenance owners; revisit if the User requests a new
skill-routing facility.

## Scope

The named router and its mirror, their current skill and manifest references,
the focused offline runner, INDEX route and this record. Preserve unrelated
work, the previously authorized #050 changes, historical records and
`docs/raw-requirements/`; do not stage, commit or push.

## Progress

- 2026-10-31: Inspected baseline status, current references and existing
  historical router evidence before the intervention.
- Updated the manifest first, then removed both router copies, their current
  skill pointers, and router-specific test code. The prior #050 changes and
  historical #049 router datasets remain in place.
- A fresh replay found a stale mention of threshold rules in the manifest;
  updated it to describe the retained request and fallback contracts.

## Validation

Inspect current references and links, verify mirror parity and script syntax,
run the retained transport tests on PowerShell 7 and 5.1, and exercise the
changed guidance in a fresh bounded agent session. A targeted live synthetic
consult may be used to verify retained Jev transport; it is not an automatic
hook call.

2026-10-31 native proof: the eight remaining mocked transport checks passed
in both skill trees on PowerShell 7 and Windows PowerShell 5.1; all four
remaining PowerShell scripts parse. The six files in each TypeSafe tree have
identical hashes. Targeted current references and local links were inspected,
and `git diff --check` passed. The retained `invoke-typesafe.ps1` and AGENTS.md
are unchanged against HEAD. No additional live API call was made in this task;
the immediately preceding #050 validation recorded a successful 483 ms live
synthetic call using the unchanged helper.

Fresh read-only replay: the worker loaded the current guidance, observed the
unchecked hook and absent router, used native skill selection in a synthetic
scenario, and confirmed the generic helper remained available. It ran all
four 8/8 mocked test combinations, checked mirror hashes and 113 local links,
and made no live Jev calls or repeated User questions. A focused rerun of the
manifest wording correction passed in the same fresh session.

## Risks

- User-owned `docs/raw-requirements/skills/enhance-jev-ai.json` still contains
  an optional Jev skill-selection requirement. Mitigation: leave that file to
  the User and propose replacing its requirement 4 with: "Sử dụng cơ chế chọn
  skill sẵn có của agent; không yêu cầu script Jev riêng để chọn skill."
- Older improvement records and datasets describe the former router.
  Mitigation: identify them as history and keep their evidence instead of
  treating them as current executable guidance.

## Decision and Result

Keep the removal. Both router copies and current executable references are
gone; the generic transport remains available, the hook stays disabled, and
the focused checks and fresh replay passed. Historical calibration evidence
remains as history. No production accuracy claim is made.
