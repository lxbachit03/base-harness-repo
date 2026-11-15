# Harness Improvement Resource

ID: #049_IMPROVE_HARNESS_1031
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Improve TypeSafe Jev integration reliability
CREATED: 2026-10-31
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/JEV-AI.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- docs-harness/harness-improvements/0930-layer-2-hooks-and-jev-gate.md
- docs-harness/harness-improvements/1005-gate-and-jev-decisions.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/
- .agents/skills/typesafe-ai/tests/router-cases.json
- .agents/skills/typesafe-ai/tests/router-calibration.json
- .agents/skills/typesafe-ai/tests/router-holdout.json
- .agents/skills/typesafe-ai/tests/reliability-check.ps1
- .claude/skills/typesafe-ai/

## Current state notice (2026-11-15)

By User decision ([#065](1115-jev-trigger-and-fixture-cleanup.md)), the three
`router-*.json` fixtures listed above left the working tree after `#051`
retired the router they calibrated, and `reliability-check.ps1` followed at
the User's request. Read any of them with
`git show 67a453d:.agents/skills/typesafe-ai/tests/<file>`. This record keeps
its original scope and evidence.

## Objective

Improve the reliability and verifiability of the TypeSafe skill and its
direct Jev integrations, preserving the repository's accepted authority,
fallback, hook-activation, and consult-observability contracts.

## Purposes

- [x] Prevent missing or malformed Jev answers from being presented as
  reliable authority decisions or domain judgments.
- [x] Make skill selection and Jev request handling testable against
  representative Harness scenarios, including Vietnamese requests.
- [x] Preserve the User's existing control of the hook and their work during
  the ongoing merge.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, HEAD `94d8457`;
`origin/main` is the locally recorded `9651492`. An existing merge is in
progress, with pre-existing staged changes, untracked files, and 24 unmerged
paths. `docs-harness/INDEX.md`, `docs-harness/JEV-AI.md`, and both copies of
`suggest-skill.ps1` are among the unmerged paths. Their conflict markers and
existing index entries must be preserved until that merge is resolved.

The accepted review found these reproducible gaps using synthetic inputs:

- A simulated `git -C . add example.txt` is not recognized by the hard
  boundary when Jev is deliberately stubbed to return a read-only verdict;
  the command itself was never run.
- A simulated successful transport response with no `Answers` can yield
  `Permitted=True` in `precheck-authority.ps1`.
- Domain freshness reports `IsStale=False` both for an offline fallback and
  for a 0.45 simulated stale probability while recommending review.
- JSON serialization at depth 10 truncates a synthetic 13-level state.
- Both router copies contain merge markers and do not parse. The review also
  identified a no-match gap and use of a single Choice distribution as though
  it were independent multi-skill applicability.

Official TypeSafe documentation was consulted on 2026-10-31. A live read-only
consult resolved `jev-latest` to `jev-1.14.0`; the manifest currently records
`jev-1.13.0`. The alias may change again. The two skill trees were byte-equal
for the six TypeSafe files inspected, including the conflicted router.

## Proposed Improvement

After the relevant merge conflicts are resolved, synchronize the manifest,
skill, scripts, and mirrors. Validate authority answers and command boundaries;
make unknown and fallback outcomes explicit; prevent silent request truncation;
and evaluate skill routing with no-match, single-skill, multi-skill, and
Vietnamese examples. Keep thresholds and externally observable policy aligned
with accepted User decisions; pause for any genuinely new policy choice.

Hypothesis: typed response validation plus separately measured applicability
will make malformed outcomes distinguishable and composite suggestions
testable. Contrary evidence includes the extra suggestions observed in the
synthetic calibration and holdout. Maintenance belongs to the TypeSafe skill
and `JEV-AI.md` owners. Revise or remove the provisional threshold and platform
filter if independently labeled examples show unacceptable misses or extras.

## Scope

The `typesafe-ai` skill, its direct Jev scripts, their `.claude` mirrors,
affected Harness manifest/routing, focused verification, and this record.
Preserve the checkbox activation mechanism, full consult request/response
observability, and the existing unavailable-Jev bypass contract. Do not edit
`docs/raw-requirements/`; suggest exact wording to the User if it needs change.
Do not stage, commit, push, overwrite unrelated work, or resolve conflicted
files without the corresponding authority. The approved goal pauses edits
whose required owners remain conflicted.

## Progress

- 2026-10-31: User accepted the review and selected the skill plus direct Jev
  integrations as the goal scope. User confirmed that the current checkbox
  activation mechanism should be preserved.
- 2026-10-31: Baseline and merge state rechecked. This record was created
  before intervention edits; its INDEX route remains pending because INDEX is
  already conflicted. No existing conflict or staged change was altered.
- 2026-10-31: Updated both unconflicted skill documents with guidance on
  malformed/unavailable answers, serialization, model identity, multilingual
  evaluation, API errors, and experimental Box support. The existing staged
  skill blobs were preserved. Added matching 20-case synthetic router fixtures
  to both skill trees; labels are proposed expectations derived from skill
  descriptions, not observed router results.
- 2026-10-31: User explicitly authorized resolving and marking the 24 existing
  conflicts, without a commit or push. All 24 were marked resolved; the 182
  pre-existing non-conflict index entries retained their blob IDs. All ten Jev
  scripts now parse. The merge itself remains uncommitted by User instruction.
  Added this record's INDEX route as a separate, unstaged goal edit.
- 2026-10-31: User authorized calibrating the router's independent Noul
  applicability threshold on the prepared synthetic cases. Do not treat the
  old Choice probability threshold `0.12` as an independently calibrated
  Noul threshold; record the chosen value, model, cases and limitations.
- 2026-10-31: Updated the manifest first, then both mirrored helpers and
  consumers. They now validate responses, preserve nested request and response
  data, expose fallback as unknown, handle common Git wrappers in the bounded
  authority precheck, and select skills using independent applicability values.
  The existing hook checkbox and unavailable-Jev bypass remain unchanged.
- 2026-10-31: Selected provisional Noul default `0.55`. On a 0.05-spaced
  grid from `0.40` to `0.90`, `0.55` and `0.60` tied for the best micro F1;
  `0.55` leaves a larger margin to the lowest expected score (`0.61`).
  On a fresh prompt about Codex tools, the router also suggested Claude and
  Antigravity. Added a named-platform filter for automatic tool-skill routing
  and reran that prompt; the result selected only the Codex skill. No platform
  name leaves semantic routing unchanged, and explicit mentions still bypass.

## Validation

Before claiming completion, run focused offline simulations for malformed
responses, fallback, Git command variants and deep state; evaluate at least 12
labeled routing examples spanning no skill, one skill, multiple skills and
Vietnamese; verify script syntax and `.agents`/`.claude` parity; inspect
affected routes, IDs, links and final diff. Use a synthetic live Jev consult
where applicable and record its actual model, result and latency.

Baseline checks on 2026-10-31: both fixtures parse and match byte-for-byte;
they contain 20 unique cases (4 no-skill, 8 single-skill, 8 multi-skill),
including 10 in Vietnamese, and all named skill paths exist. Router evaluation
is pending: each unmerged router reports 31 PowerShell parse errors. In a
19-case in-memory hard-boundary simulation with Jev deliberately stubbed to
return read-only, 14 cases passed and 5 Git wrapper/option cases failed:
`git -C . add example.txt`, `git -c core.filemode=false commit -m example`,
`git --git-dir .git push origin main`, `& git add example.txt`, and
`cmd /c git add example.txt`. No simulated command was executed. A separately
stubbed missing-answer response returned `JevSemanticEvaluation` and
`Permitted=True` at baseline; the post-change checks below exercise its fix.
The two edited skill documents had identical hashes, and their pre-existing
staged blob IDs were `029177271e911311156505539f9a6ae07d525d4b`.

Post-change checks on 2026-10-31:

- The offline runner passed 46/46 checks under both PowerShell 7 and Windows
  PowerShell 5.1 in each of `.agents` and `.claude`. Its HTTP transport is
  mocked and simulated Git mutation strings are never executed. It covers the
  prior 19 command cases, malformed and unavailable answers, strict mode,
  HTTP 429, nested state and response logging, routing and platform filtering.
- `router-calibration.json` records the actual scored outputs for the 20
  synthetic draft-label cases, resolved model `jev-1.14.0`. Eight explicit
  cases bypassed Jev; 12 natural cases used live Jev. Re-evaluating those
  scores at `0.55` satisfies 20/20 case contracts (the `contains` contract
  allows extra skills). Counting every unlabelled extra as a false positive
  gives 24 true positives, 2 extras, 0 missing, and micro F1 0.96 across all
  cases; on the 12 live cases alone these counts are 12, 2, 0 and F1 0.923.
  Extras may themselves be justified, because the draft labels for natural
  cases are not exhaustive. This is calibration on the measured cases, not
  an independent production accuracy estimate.
- `router-holdout.json` records four newly written live prompts at the chosen
  default, two in Vietnamese. Initially 3/4 met their defined contracts; the
  Codex-only case included unrelated platform skills. After the filter, that
  case was rerun and met its exact contract, making 4/4 by those definitions.
  The Vietnamese multi-skill case also selected `sequence-execution-plan`,
  which its `contains` contract permits but does not establish as necessary.
  Only the Codex case was rerun after the filter. The observed live calls used
  `jev-1.14.0`; the post-filter call took 1135 ms.
- All 12 PowerShell scripts in the two skill trees parse, all six test JSON
  files parse, and all 10 files in each mirrored tree have equal SHA-256
  hashes. Git's staged and unstaged `diff --check` pass. There are no unmerged
  index paths or conflict markers; the 182 original non-conflict index entries
  retain their prior blobs. The merge remains uncommitted by instruction.
- Targeted self-review inspected the changed helper and consumer diffs,
  `JEV-AI.md` sections 3.0–3.5, the skill instructions, #049 metadata and its
  INDEX route, mirror hashes, all test fixtures, and the hook activation and
  verdict handling. No external service, domain data, or user ticket was
  modified by the checks.
- Fresh delegated read-only replay: the worker loaded the skill, manifest,
  hook, INDEX and record, then ran the 46-check suite on both skill trees and
  both PowerShell versions. It independently explained that a malformed
  composite request produces a marked fallback rather than a successful
  semantic decision; it found no repeated User questions or unreported file
  edits. Its shell consult proceeded with `jev-1.14.0` and no fallback. The
  worker relied on the primary session's prior live-doc evidence rather than
  making a separate web read; the replay does not prove production quality.

## Risks

- The existing merge is resolved in the index but not committed. Mitigation:
  review staged and unstaged changes separately before any later commit; do
  not stage the goal edits without additional authority.
- The checked-in raw Jev requirement says activation depends on naming Jev,
  while the User confirmed preserving checkbox activation. Mitigation: leave
  raw requirements untouched and propose exact replacement text to the User.
- Jev is probabilistic and its model alias can move. Mitigation: preserve
  deterministic authority checks, validate inputs and outputs, and retain
  representative synthetic cases and the resolved model in proof. Re-evaluate
  the provisional threshold on independently labeled real-world examples.
- The precheck's literal-command recognition and the platform-name filter are
  bounded heuristics, not a sandbox or full natural-language understanding.
  Mitigation: continue applying AGENTS.md authority independently and add
  representative missed variants to offline and live evaluation when observed.

## Decision and Result

Keep the scoped intervention, including the provisional `0.55` default and
named-platform filter, based on the local checks and fresh synthetic replay.
The changes make unavailable judgments explicit and the evaluated routes
observable; they do not establish production accuracy, comprehensive command
recognition, or a stable model alias. The merge is still uncommitted and the
goal edits remain unstaged or untracked.
