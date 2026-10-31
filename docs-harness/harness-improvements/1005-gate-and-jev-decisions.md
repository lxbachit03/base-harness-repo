# Harness Improvement Resource

ID: #044_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Make the shell gate always consult Jev and apply the User's Jev guidance decisions
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- AGENTS.md
- .agents/skills/typesafe-ai/SKILL.md
- .agents/skills/typesafe-ai/scripts/precheck-authority.ps1
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- docs-harness/JEV-AI.md
- docs-harness/layers/layer-2/hooks/jev-hook.md
- .agents/skills/enhance-jev/SKILL.md
- docs-harness/harness-improvements/1003-optimization-review-correctness-fixes.md

## Objective

The jev-hook shell gate consults Jev for every command and prints the full
request and response, with the hard-block regex kept as an override that
always requires User authority, and command segmentation that ignores
separators inside quotes. The Jev manifest, hook and `enhance-jev` skill state
the User's decisions on consult invocation, tool grouping, helper key lookup,
live test calls and script mirroring, and the skill router honours only an
explicit `$skill-name`.

## Purposes

- [x] Make every shell gate decision observable, as the hook's Consult
  observability rule requires.
- [x] Stop the gate from misclassifying commands by their first words
  (a quoted `git add` blocked a read-only grep; `git branch -d` passed as
  read-only).
- [x] Record the User's defaults for Jev's own key lookup and live test calls
  so agents stop treating them as unauthorized.

## Current State

Baseline (2026-10-05): branch `main` at `9b71345`, level with `origin/main`.

User decisions (2026-10-05) on the optimization review's follow-ups:

| # | Decision |
| --- | --- |
| F1 | Split commands into segments without splitting inside quotes; correct #039's description of over-splitting |
| F2 | Remove the read-only regex fast path; always call Jev (chosen over accepting fast-path output) |
| F3 | Add an invocation example to `JEV-AI.md` §3.5 |
| F5 | jev-hook: Grep/Glob are file ops; session-start listing covers names only |
| F14 | The Jev helpers' own API-key lookup is permitted by default |
| F15 | A live TypeSafe test call in `enhance-jev` is routine local verification |
| F16 | `enhance-jev` mirrors new scripts into `.claude/skills/` |
| P3 | `suggest-skill.ps1` bypasses routing only for an explicit `$skill-name` |

Evidence for F1/F2 (2026-10-05): the gate hard-blocked the read-only command
`grep -n "read-only\|git add" AGENTS.md` (the quoted `|` split off a
`git add` segment, recorded in #041), and fast-passed `git branch -d …` as
`ReadOnlyRoutine` because the read-only pattern matched `git branch`.

## Proposed Improvement

Rewrite the gate's segmentation and flow; edit the manifest, hook, skill and
router per the table; mirror changed skill files.

## Scope

May change: files in REFERENCES, their `.claude/skills/` mirrors, this record,
its INDEX entry and `.gitignore` line (if still present).

Unchanged: `invoke-typesafe.ps1`; the other Jev scripts. Scope revision
(2026-10-05, from the replay): AGENTS.md, the Task authority owner, gained one
sentence carrying F14/F15, because a Jev-only exception contradicted its
credentials rule; `typesafe-ai/SKILL.md` and two history records (#034, #036)
were updated to drop the fast-path description.

## Progress

- 2026-10-05: Record created before edits.
- 2026-10-05: Gate rewritten (quote-aware segments; Jev for every command;
  hard-boundary override; conservative fallback); router requires `$`;
  JEV-AI §1/§2/§3.1/§3.5, jev-hook groups and exemptions, enhance-jev phases
  updated; #039 correction note added. While deleting branches (G3) the old
  fast path classified `git branch -d` as read-only, a further F2 example.
- 2026-10-05: Replay 1 passed and found gaps, all fixed: AGENTS.md lacked the
  F14/F15 exception; the gate criterion still listed credentials without the
  exception; no §3.1 invocation example; `action_group` lacked search/web
  values; web tools and PowerShell had no stated script; "turn" undefined;
  locating §3.5 not exempt; enhance-jev checklist lacked the mirror item.
- 2026-10-05: Combined replay (with #045) passed and found the remaining
  fast-path wording in `typesafe-ai/SKILL.md`, §3.5's group list without web,
  and no mapping from the shell gate result to hook verdicts; fixed, and
  notices added to #034 and #036.

## Validation

- Native: scripts parse; classification probes over read-only, chained,
  quoted, substituted and mutating commands (each now shows a Jev payload;
  hard-block segments always require permission; quoted separators do not
  split); router probes with and without `$`.
- Fresh replay: a fresh worker follows the hook with the new gate and builds a
  consult from §3.5's example.

## Risks

- Every shell consult now costs one Jev call (about 0.5 s) and API usage.
  Mitigation: the User chose this; the hook already gates each action group
  once per turn, not each command.
- Jev may misjudge a command. Mitigation: hard-block regex overrides to
  "requires permission" for staging, commits, pushes and destructive commands.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05): both scripts parse with 0 errors;
`.agents`/`.claude` differ only by line endings; no current guidance outside
history records describes a regex fast path.

Gate probes (`precheck-authority.ps1 -Quiet`, classify only; every case called
Jev):

| Command | Result |
| --- | --- |
| `git status; git push origin main` | blocked, JevWithHardBoundary (`git push origin main`) |
| `git status && git log --oneline -3` | Permitted, read_only_routine |
| `cat README.md \| grep Harness` | Permitted, read_only_routine |
| `echo $(git commit -m x)` | blocked, JevWithHardBoundary |
| `ls; rm -rf build` | blocked, JevWithHardBoundary |
| `grep -n "read-only\|git add" AGENTS.md` | Permitted, read_only_routine (was hard-blocked before #044) |
| `echo "$(git push)"` | blocked, JevWithHardBoundary (substitution inside double quotes) |
| `echo '$(git push)'` | blocked by Jev (critical); no hard segment inside single quotes |
| `git branch -d old-feature` | blocked by Jev (critical) (was fast-passed before #044) |
| `npm test` | Permitted, local_routine_authorized |
| `git status` | Permitted, read_only_routine |

Router probes: "map the onboarding flow…" → `JevDecision`; "use $onboarding…"
and "run $init-harness-repo…" → `ExplicitMention`.

Fresh replays: replay 1 gated `git log` through the new gate (full Jev
request and response printed, `read_only_routine`) and built a file consult
from §3.5's example; the combined replay answered how to gate PowerShell and
web fetch and that the key lookup needs no permission, quoting AGENTS.md.
Final wording fixes after the combined replay were checked natively.

Limits: each shell consult now costs one Jev call (~0.5–1.3 s observed).
