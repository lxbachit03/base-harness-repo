# Harness Improvement Resource

ID: #065_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Consult Jev only on request and retire unused Jev test assets
CREATED: 2026-11-15
STATUS: active
REFERENCES:
- docs-harness/JEV-AI.md
- docs-harness/harness-improvements/1031-jev-integration-reliability.md
- docs-harness/harness-improvements/1031-retire-jev-skill-router.md
- .agents/skills/typesafe-ai/tests/reliability-check.ps1
- docs/raw-requirements/jev-ai/jev-ai.json

## Objective

Agents consult Jev only when the User asks for it or a checked jev-hook
requires a consult, and the retired skill router's three test fixtures leave
the working tree, so repository searches stop returning their stale
`enhance-jev` lines. At the User's later request, the transport's offline
reliability check leaves the tree as well.

## Purposes

- [x] Remove the open trigger that let agents spend tool calls and context on
  Jev without the User asking (raw requirement jev-ai Yêu cầu 3: "khi tôi gọi
  'Jev'").
- [x] Stop the retired router fixtures from adding noise and tokens to
  repository searches.
- [x] Keep the fixtures recoverable as `#049` evidence.
- [x] Remove the Jev transport's offline test at the User's request; it
  guarded a script that now runs only when the User asks for Jev.

## Current State

Baseline (2026-11-15 14:01, Asia/Bangkok): `D:/repos/base-harness-repo`,
branch `main` at `67a453d`, two commits ahead of `origin/main`, worktree
clean; jev-hook disabled.

- `JEV-AI.md` ends its catalog note with "Jev remains available for
  explicitly requested or otherwise relevant semantic work"; the second branch
  lets an agent consult Jev on its own judgment.
- `.agents/skills/typesafe-ai/tests/` holds `router-cases.json` (5,970 bytes),
  `router-calibration.json` (23,483) and `router-holdout.json` (9,182), with
  byte-identical `.claude` copies: 77,270 bytes in all. They calibrated the
  skill router that `#051` retired. Only `#049` (REFERENCES and Validation)
  and the fixtures themselves mention them; `reliability-check.ps1` does not
  use them. 92 of the 94 `enhance-jev` search hits outside `.git` and the
  improvement records come from these files.
- Jev-related start-up load is about 2.9 KB with the hook unchecked.

User decisions (2026-11-15): apply both changes; delete the fixtures from the
working tree and keep them in git history rather than move them within the
repository.

## Proposed Improvement

Replace the open trigger in `JEV-AI.md` with a request-only rule. Delete the
six fixture files and add a dated notice to `#049` naming the revision that
still holds them.

Hypothesis: without the open branch an agent reaches for Jev only when the
User asks or the hook is checked, and without the fixtures repository searches
lose their largest source of stale Jev text. Contrary evidence: an agent still
consults Jev unprompted, or later work needs the fixtures in the tree. Owner:
`JEV-AI.md` for Jev usage; the typesafe-ai skill for its tests folder. Restore
the fixtures from git if the router returns; widen the trigger only by User
decision.

## Scope

May change: the `JEV-AI.md` sentence, the six fixture files (deleted), the
reliability check and its mirror (deleted at the User's later request), a
dated notice in `#049`, this record and its entry in
`harness-improvements/README.md`.

Unchanged: jev-hook, the SESSION.md authority sentence, typesafe-ai's
SKILL.md and scripts, the capability rows of the
`utilizing-tools-*` skills (they route to Jev only inside a capability
selection the User requested), and `docs/raw-requirements/`. No commit or push
without the User's approval.

## Progress

- 2026-11-15: Baseline captured; deletion targets confirmed tracked in
  `67a453d`; record created and listed before intervention edits.
- 2026-11-15: `JEV-AI.md` now reads "Beyond the jev-hook, consult Jev only
  when the User asks for it, for example by naming Jev." Deleted the six
  fixture files and added the dated notice to `#049`.
- 2026-11-15: After reviewing the check's value (a cheap regression guard
  that no guidance told agents to run, for a script now used only on
  request), the User asked to delete `reliability-check.ps1`. Deleted both
  copies and the empty `tests/` folders and extended the `#049` notice.

## Validation

- All three fixtures remain readable from `67a453d` at their original sizes
  (5,970, 23,483 and 9,182 bytes), as does `reliability-check.ps1` (4,948
  bytes), which passed 8 of 8 offline checks just before its deletion. No
  `tests/` folder remains in either copy of typesafe-ai.
- `enhance-jev` search hits outside `.git` and the improvement records fell
  from 94 to 2; both remaining hits are in the User-owned
  `docs/raw-requirements/`. No live guidance still says "otherwise relevant".
- `harness-check` full run: all 65 resources with an ID routed, IDs
  `#001`–`#065` unique, 65 ID entries match, 944 local links resolve, the
  skill mirror is identical (18 skills, 37 files); the only drift is the five
  pre-existing folders without README.
- Line endings stay consistent in both edited files.

Unattempted: a fresh session showing that an agent no longer consults Jev
unprompted.

## Risks

- A legitimate semantic task may now skip Jev where it would help. Mitigation:
  the User can ask for Jev at any time; the typesafe-ai skill still serves
  product work that builds on TypeSafe.
- The fixtures leave the tree. Mitigation: `#049` names the revision and the
  `git show` command that restores them.
- No regression guard remains for `invoke-typesafe.ps1`. Mitigation: before
  changing the transport, restore and run the check from `67a453d`, or ask
  the User for a new test (`#058`).

## Decision and Result

Decision: keep; pending a fresh rerun of the trigger case. The fixture
removal is proven by the search counts and git recovery above. The narrowed
trigger is unverified for a fresh agent.

Next case: a fresh session given a semantic-judgment task that does not
mention Jev (for example, ranking three findings by risk) completes it without
a Jev consult; asked to check something "with Jev", it consults Jev, or
reports the bypass when no key is available. The run can share a session with
`#063`'s pending status-request case. Owner: the primary (Bale) session, when
the User authorizes the rerun.
