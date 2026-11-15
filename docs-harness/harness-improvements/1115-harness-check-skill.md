# Harness Improvement Resource

ID: #063_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Repeatable read-only Harness status check
CREATED: 2026-11-15
STATUS: active
REFERENCES:
- .agents/skills/harness-check/SKILL.md
- .agents/skills/harness-check/scripts/harness_check.py
- .claude/skills/harness-check/SKILL.md
- .claude/skills/harness-check/scripts/harness_check.py
- docs-harness/INDEX.md
- docs-harness/templates/README.md
- docs-harness/harness-improvements/0912-agent-self-validation.md
- docs-harness/harness-improvements/1005-group-b-context-load-reduction.md
- docs/raw-requirements/README.md
- docs/raw-requirements/skills/init-harness-repo.json

## Objective

A user-invoked `harness-check` skill runs one read-only Python 3 script that
reports Harness drift: INDEX alignment, resource IDs and metadata, relative
links and anchors, the `.agents`/`.claude` skill mirror, and folder READMEs.
The agent then compares `docs/raw-requirements/` with the implementation and
reports every finding with a proposal. A `--quick` mode runs exactly INDEX's
session-start alignment check. INDEX routes Harness status requests to the
skill.

## Purposes

- [x] Make a Harness status check repeatable: the same checks on every run
  instead of an improvised inspection (raw requirement init-harness-repo 1.5).
- [x] Cut a status check from 30+ tool calls and throwaway scripts to one
  script run plus the requirement comparison.
- [x] Provide the route-reachability proof that the planned session-start
  context cut will use to show that no route is lost.
- [x] Keep the check report-only, so finding drift never silently repairs it.

## Current State

Baseline (2026-11-15, Asia/Bangkok): `D:/repos/base-harness-repo`, branch
`main` at `9c99521`, level with `origin/main`, worktree clean; Jev hook
disabled.

Representative request: the User asked for the Harness status ("Kiểm tra tình
trạng hiện tại của harness repo"). The agent needed more than 30 tool calls
and three throwaway Python scripts in its session scratchpad; its first link
check reported 494 false positives (template placeholders and HTML `id`
anchors) before refinement. Its findings: the `#012` file
`plans/completed/0902-evidence-backed-domain-freshness.md` exists (re-added
by `ba9fcc8`) but is unrouted after `#037` retired the route; six
`docs-harness/` folders lack README.md (raw requirement init-harness-repo
1.6); IDs `#001`–`#062` are contiguous without duplicates; INDEX links, the
Folder Tree and 936 real relative links resolve; `.agents/skills` and
`.claude/skills` are byte-identical.

Policy: `#042` decision B6 (2026-10-05) removed the prohibition on creating
or invoking a repository validation script; targeted self-review and evidence
reporting remain required. No current skill or script performs these checks.

The User chose this improvement through goal-griller on 2026-11-15: a
read-only Python 3 standard-library script inside a user-invoked skill,
verified on the repository and on a disposable seeded copy, without committed
unit tests (`#058`), schedules or settings.

## Proposed Improvement

Add `.agents/skills/harness-check/` with `SKILL.md`
(`disable-model-invocation: true`) and `scripts/harness_check.py`, mirrored
byte-identically to `.claude/skills/`. The script reads only, writes only to
stdout and exits 0 when clean, 1 on drift and 2 on error. Each check names the
rule it enforces and that rule's owner. A resource counts as routed when INDEX
links it directly or through a README.md that INDEX links, so the check stays
valid if history routes later move into folder READMEs. Add one INDEX pointer
for Harness status requests.

Hypothesis: a maintained read-only script gives the structural findings of a
careful manual inspection in one tool call, making a status check repeatable
and cheap. Contrary evidence: the script misses a finding the manual check
found, flags legitimate content, produces output too long to read cheaply, or
agents stop at its output and skip the requirement comparison. Owner: the
`harness-check` skill. Revise or remove it when a rule it encodes changes and
the script cannot follow, or when runs show agents treating its output as a
verdict.

## Scope

May change: the new `.agents/skills/harness-check/` folder and its
byte-identical `.claude/skills/harness-check/` mirror; INDEX (this record's
route and one status-check pointer); this record.

Unchanged: the drift the check reports (including `#012` and the missing
READMEs), `docs/raw-requirements/`, other skills, settings, hooks and
schedules. No committed unit tests, staging, commit or push.

## Progress

- 2026-11-15: Baseline captured; record created and indexed before
  intervention edits.
- 2026-11-15: Added `SKILL.md` and `scripts/harness_check.py`, mirrored them
  byte-identically to `.claude/skills/harness-check/`, and added the INDEX
  status-check pointer under Root Routing.
- 2026-11-15: Verified on the repository, a pristine copy and a seeded copy in
  the session scratchpad (see Validation); the copies were then deleted.
- 2026-11-15: Goal A committed as `377a0fc`. `#064` then made the folder
  READMEs part of routing; `harness-check` now validates their entries and
  reports README-routed resources as a count.
- 2026-11-15: A fresh replay shared with `#064` exercised the status check
  (see Validation). The route and report worked; the check took 26 tool
  calls, so validation item 3 failed. The revision awaits the User's choice of
  when the requirement comparison runs.
- 2026-11-15: The User chose to run the requirement comparison only on
  request. SKILL.md (and mirror) now runs the script without
  `--requirements` for a status request and names the skipped comparison in
  the report; the INDEX pointer gained the requirement-question branch
  (INDEX 14,996 bytes; start-up total 32,589, still within `#064`'s target).

## Validation

1. Repository full run (exit 1) reports exactly the baseline findings:
   `routing` flags only the `#012` file and `folder-readmes` the six baseline
   folders; `index-links` (117), `folder-tree` (28 folders), `ids` (63 unique,
   `#001`–`#063`), `metadata`, `index-entries` (62), `links` (931 local links
   in 123 Markdown files), `skill-mirror` (18 skills, 40 files) and
   `requirements` (6 files) pass.
2. Seeded copy: 22 injected defects across all ten check classes. 21 were
   reported as drift in their expected check (the broken INDEX link also in
   `links`, by design), and the README-only route as `info`. A diff against
   the pristine copy's output shows no other change. Exit codes: 1 on drift,
   0 after routing `#012` in a copy, 2 for a root without INDEX.
3. Cost: one tool call returns every structural check plus the requirement
   text (83 lines, 12,573 bytes, about 3.6k tokens at 3.5 bytes per token);
   `--quick` prints 6 lines (519 bytes); a run takes about 0.4 s. The
   requirement comparison's extra lookups are left to the fresh replay.
4. Both copies are byte-identical (SHA-256); INDEX keeps consistent CRLF line
   endings; the script compiles with warnings as errors; the fixtures left the
   repository untouched (`git status` lists only in-scope paths, no
   `__pycache__`).

5. Fresh replay (2026-11-15, fresh read-only worker, shared with `#064`):
   asked "Kiểm tra tình trạng hiện tại của harness repo", the agent followed
   the INDEX pointer to the user-invoked skill, ran the script with
   `--requirements`, compared every requirement node and reported each
   finding with a proposal, staying read-only. It reported the five README
   gaps and seven requirement mismatches, two more than the manual check of
   the same day (improve-harness's interview and audit-location question,
   and the missing-template question of init-harness-repo 2.4.1). It took 26
   tool calls: one script run, two direct JSON reads after its tool truncated
   about 1 KB of the printout, and lookups for the requirement comparison.

6. Revision (native): both copies byte-identical, INDEX links resolve,
   `--quick` exits 0. Not yet observed in a fresh session.

Unattempted: macOS/Linux and Python versions other than 3.14 (the only one
installed); a fresh rerun of the revised status request.

## Risks

- A clean script run can be mistaken for a correct Harness. Mitigation: the
  skill requires the agent's requirement comparison and lists what the script
  cannot judge (business facts, requirement meaning).
- The script encodes rules owned elsewhere (INDEX session retrieval,
  `templates/README.md`, raw requirement 1.6). Mitigation: each check names
  its owner; a change to that owner includes the script update.
- Anchor slugs approximate GitHub rendering. Mitigation: explicit HTML `id`
  and `name` anchors are honoured; a mismatch is reported for review, not
  repaired.
- A machine without Python 3 cannot run the script. Mitigation: the skill
  gives the manual fallback and reports the script check as unattempted.
- Known drift (`#012`, the six missing READMEs) repeats on every run until
  the User decides it, and repeated rows can fade into noise. Mitigation:
  each report pairs them with a proposal; resolving them is a separate User
  decision.

## Decision and Result

Decision: keep, revised on 2026-11-15; pending a fresh rerun of the revised
case. A fresh agent found the skill, ran it and reported correctly without
treating the script output as a verdict. Its status check took 26 tool calls
(validation item 3 failed) because the requirement comparison had no bound.
By User decision the comparison now runs only when the User asks whether the
repository meets their requirements, the trigger in
`docs/raw-requirements/README.md`; requirement 1.5 asks only that a status
request reads the Harness state.

Next case: a fresh session asked "Kiểm tra tình trạng hiện tại của harness
repo" runs the script without `--requirements`, reports the RESULT line and
each drift row with a proposal, and names the skipped comparison; the
expected cost after start-up is two tool calls (read SKILL.md, run the
script). Asked whether the repository meets the User's requirements, it adds
the comparison. Owner: the primary (Bale) session, when the User authorizes
the rerun.
