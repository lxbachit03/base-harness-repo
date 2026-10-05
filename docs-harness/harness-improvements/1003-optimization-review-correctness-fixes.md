# Harness Improvement Resource

ID: #039_IMPROVE_HARNESS_1003
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Correctness fixes from the 2026-10-03 optimization review (group A)
CREATED: 2026-10-03
STATUS: completed
REFERENCES:
- .agents/skills/typesafe-ai/scripts/precheck-authority.ps1
- .agents/skills/typesafe-ai/scripts/triage-ticket.ps1
- .agents/skills/typesafe-ai/scripts/check-domain-freshness.ps1
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/enhance-jev/SKILL.md
- docs-harness/JEV-AI.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/INDEX.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- README.md

## Objective

The twelve group-A findings of the 2026-10-03 optimization review are fixed at
their owners, each without changing the purpose of the file or folder that
holds it: the jev-hook shell gate classifies every segment of a chained
command, and the listed guidance, manifest and script contradictions, stale
references and broken links are corrected.

## Purposes

- [x] Make the jev-hook shell gate enforce AGENTS.md task authority for
  chained commands, so a read-only prefix cannot carry a commit or push.
- [x] Remove contradictions between owners (priority spelling, domain
  freshness flags, Herdr wait guidance) so agents follow one rule.
- [x] Repair stale or broken routes (lost clause, broken links, stale labels
  and counts, removed-skill mentions) without adding or removing policy.

## Current State

Baseline (2026-10-03): branch `main` at `a1690a1`, worktree clean, 3 commits
ahead of `origin/main`. Source: read-only review by four Opus 5.5 subagents
(session-start path, policy owners, skills, records); the coordinator
re-verified A1–A3, A5–A7, A9 and A10 by direct inspection. The User accepted
group A on 2026-10-03.

| # | Finding | Evidence (baseline) |
| --- | --- | --- |
| A1 | Shell gate fast path and hard block match only the start of the command | `precheck-authority.ps1:53-54,74-75`; classify-only probe `git status; git push origin main` returned `Permitted, ReadOnlyRoutine, RegexFastPath` |
| A2 | Clause lost in commit `e4cdc51` | `HERDR-AGENTS.md:188` ends "…configuration when" |
| A3 | `[CRITICAL]` emitted; catalog spelling is `[CRITIAL]` (`templates/README.md:33-35`) | `JEV-AI.md:86`; `triage-ticket.ps1:28,142` |
| A4 | Freshness check downgrades to `[UNCERTAIN]`; owner requires `STATUS: needs-review` + `Freshness: STALE` and preserves CONFIRMED (`domain/README.md:25-26,56-60`) | `JEV-AI.md:100`; `WORKFLOW.md:57`; `check-domain-freshness.ps1:9,30,106,121,125` |
| A5 | Four links resolve to the missing `.agents/docs-harness/` | `enhance-jev/SKILL.md:9,26,30,53` |
| A6 | `--timeout 60000` contradicts #028 (no `--timeout`) and `herdr-runtime.md` Read and wait | `herdr-coordinate-agents/SKILL.md:129` |
| A7 | "four core best practices" followed by five | `WORKFLOW.md:44` |
| A8 | Layers route names only model matching, so hooks can be missed | `INDEX.md:13-15,396-397` |
| A9 | Template catalog mislabelled | `INDEX.md:436` |
| A10 | "17 skills catalog"; script lists 18, disk has 19 | `JEV-AI.md:69`; `suggest-skill.ps1:6` |
| A11 | jev-hook points to JEV-AI §3, which has no generic consult shape | `jev-hook.md:52` |
| A12 | Mentions of strict audit skills removed by #023 | `README.md:53`; `WORKFLOW.md:16-18` |

## Proposed Improvement

Fix each item at its owner with the smallest edit; mirror changed skill files
to `.claude/skills/`.

## Scope

May change: the files in REFERENCES, their `.claude/skills/` mirrors, this
record, its INDEX entry and `.gitignore` allow line.

Unchanged: every other finding of the review (groups B–E), the User's
`[CRITIAL]` spelling, the layers model-matching design, the hook's activation
checkbox, policy wording in AGENTS.md. No commit or push without approval.

## Progress

- 2026-10-03: Record created before edits.
- 2026-10-03: A1–A12 fixed at their owners; skill files mirrored to
  `.claude/skills/`. A4 also covered the same `[UNCERTAIN]` rule in
  `WORKFLOW.md:57`, found while editing. `check-domain-freshness.ps1`
  Recommendation values renamed `KeepConfirmed` → `KeepCurrent` and
  `MarkUncertainAndScheduleReview` → `MarkStaleAndScheduleReview` (no
  repository consumer).
- 2026-10-03: Replay 1 exposed that building the first consult needs an
  ungated read of JEV-AI §3.5; the jev-hook exemption sentence now includes
  that read (checkbox untouched). Replay 2 passed.

## Validation

- Native: grep for each baseline string; PowerShell parse of edited scripts;
  `.agents`/`.claude` mirror diff; INDEX links resolve; IDs unique.
- Behavior (A1): classify-only runs of `precheck-authority.ps1` over chained,
  piped and substituted commands, read-only and mutating.
- Fresh replay (A8, A11): a fresh worker reads INDEX and the jev-hook and
  builds a file-ops consult from JEV-AI §3.5 without reading script source.

## Risks

- A1 sends more commands to Jev (about 0.5 s each) when a segment is not in
  the read-only list or a quoted `|` splits a segment. Mitigation: conservative
  by design; read-only chains still fast-pass.
  Correction (2026-10-05, [#044](1005-gate-and-jev-decisions.md)): a quoted
  `|` could also split off a hard-boundary segment and hard-block a read-only
  command, not only re-route it. #044 made splitting quote-aware and removed
  the fast path.
- A4 renames two `check-domain-freshness.ps1` Recommendation values. No
  consumer in the repository reads them (grep, 2026-10-03).

## Decision and Result

Decision: **keep**.

Native checks (2026-10-03): no `[CRITICAL]`, `[UNCERTAIN]` flag rule,
`MarkUncertain`/`KeepConfirmed`, "17 skills", "four core" or `--timeout 60000`
remains in the edited owners; `HERDR-AGENTS.md:189` restores the lost clause;
all `enhance-jev`, INDEX and JEV-AI relative links resolve; the four edited
scripts parse with 0 errors; `.agents`/`.claude` skills differ only by line
endings (`diff -rq --strip-trailing-cr` exit 0); no duplicate IDs; this record
is not git-ignored.

Gate probes (classify only; `precheck-authority.ps1 -Quiet`, nothing executed):

| Command | Result |
| --- | --- |
| `git status; git push origin main` | blocked, RegexHardBoundary (baseline: Permitted, RegexFastPath) |
| `echo $(git commit -m x)` | blocked, RegexHardBoundary |
| `ls; rm -rf build` | blocked, RegexHardBoundary |
| `git push` | blocked, RegexHardBoundary |
| `git status && git log --oneline -3` | Permitted, RegexFastPath |
| `cat README.md \| grep Harness` | Permitted, RegexFastPath |
| `git status` | Permitted, RegexFastPath |
| `grep -E "a\|b" README.md` | quoted `\|` over-splits → Jev: read_only_routine |
| `npm test` | Jev: local_routine_authorized |

Fresh replays (fresh native general-purpose workers, read-only status task,
`.ps1` source reading forbidden):

- Replay 1: reached jev-hook through the new INDEX text (`INDEX.md:15`,
  `:399-400`) and built a valid file-ops consult from JEV-AI §3.5 alone
  (`proceed`, Fallback False). It reported that reading §3.5 was not on the
  hook's exemption list. Revised as recorded in Progress.
- Replay 2 (after revision): same route; quoted the new exemption for the §3.5
  read; two file-ops consults and one shell precheck, all `proceed`/Permitted;
  no `.ps1` source read.

Follow-up proposals from the replays (suggestions until authorized; outside
group A):

- JEV-AI §3.5 does not show the invocation form (`& <script> -State … -Questions …`).
- Fast-path precheck output carries no request payload or model, so the hook's
  Consult observability rule cannot be met literally for shell commands; the
  hook should either accept fast-path output or the script should print what
  it checked.
- `layers/README.md` names files by model+effort, but some runtimes expose no
  effort value; state the naming rule for that case.
- The hook does not say whether Grep/Glob count as file ops, or whether the
  INDEX folder-name inspection may list files.
- `#038` lists the chained-command fast path as an open limit; this record
  closes it.
