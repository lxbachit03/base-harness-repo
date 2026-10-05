# Harness Improvement Resource

ID: #041_IMPROVE_HARNESS_1003
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Apply the User's group D policy decisions from the 2026-10-03 optimization review
CREATED: 2026-10-03
STATUS: completed
REFERENCES:
- AGENTS.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/orca-ade-coordinate-agents/SKILL.md
- .agents/skills/utilizing-tools-orca-ade/SKILL.md
- .agents/skills/domain-audit/SKILL.md
- .agents/skills/typesafe-ai/scripts/suggest-skill.ps1
- docs-harness/HERDR-AGENTS.md
- docs-harness/templates/README.md
- docs-harness/templates/proposal.md
- docs-harness/harness-improvements/0926-utilizing-tools-orca-ade.md
- docs-harness/domain/README.md
- docs/tools/orca-ade/README.md

## Current policy notice (2026-10-05)

The D1 clause that let User-selected Orca coordination use worktrees is
superseded by User decision ([#045](1005-coordination-without-worktrees.md)):
no agent coordination uses a Git worktree. D2–D5 stand.

## Objective

The five User decisions on group D are reflected at their owners: Herdr
coordination never uses Git worktrees and Orca coordination runs only when the
User selects it; `domain-audit` records User-confirmed domain knowledge and
AGENTS.md no longer calls every audit read-only; staging needs explicit
authority; a proposal not paired with a risk has no TAG; and `#018`, `#019`,
`#020`, `#024` and `#025` are completed by User decision.

## Purposes

- [x] Give agents one coordination rule: Herdr uses the shared checkout; Orca
  worktrees exist only in Orca coordination the User selects.
- [x] State what `domain-audit` is for: recording domain knowledge the User
  confirmed after onboarding, such as a service or an E2E data flow.
- [x] Make AGENTS.md, the policy owner, match the staging boundary its gate
  already enforces.
- [x] Let non-risk proposals be filed without a misleading `[RISK]` route.
- [x] Close five records the User judged complete, without claiming replays
  that were not separately recorded.

## Current State

Baseline (2026-10-03): branch `main` at `7df3eae`, worktree clean, 5 commits
ahead of `origin/main`. User decisions, 2026-10-03, answering the review's
group D questions:

| # | Question | User decision |
| --- | --- | --- |
| D1 | `#024` forbids worktrees for Herdr coordination; `HERDR-AGENTS.md:191-198` and `utilizing-tools-orca-ade/SKILL.md:107-131,139` create Orca worktrees for Herdr workers (`#031`) | `#024` wins; when the User specifies Orca, use Orca; when Herdr, use Herdr; Orca only with User authority |
| D2 | `AGENTS.md:64` "an audit is read-only" vs `domain-audit` adding a domain | `domain-audit` records the business domains, services or E2E data flows the User confirmed after onboarding into `docs-harness/domain` |
| D3 | WORKFLOW, JEV-AI and the gate require authority for staging; `AGENTS.md:50-52` lists commits and pushes only | Add staging to AGENTS.md |
| D4 | `templates/proposal.md:3-4` hardcodes `_RISK_`/`[RISK]` | Non-risk proposals use creation kind PROPOSAL and no TAG |
| D5 | `#018`, `#019`, `#020`, `#024`, `#025` active pending reruns; later records may hold evidence | Mark all five completed |

## Proposed Improvement

Edit each owner with the smallest change that carries the decision; add a
current-policy notice to `#031`; set the five STATUS lines and append a dated
User-decision note to each record's Decision and Result; mirror skills.

## Scope

May change: files in REFERENCES, the five records named in D5 (STATUS line and
an appended note), their `.claude/skills/` mirrors, `domain-audit`'s
`agents/openai.yaml`, this record, its INDEX entry and `.gitignore` line.

Unchanged: the Orca-only `orca-ade-coordinate-agents` workflow beyond its
selection rule; history in the five records.

Scope revision (2026-10-03, from replays): `docs/tools/orca-ade/README.md`
(a direct consumer of D1 that still placed Herdr workers in Orca worktrees)
and `docs-harness/domain/README.md` (its capture trigger still treated
domain-audit as unconfirmed capture) were added; both edits only carry the
User's D1/D2 decisions.

## Progress

- 2026-10-03: Record created before edits.
- 2026-10-03: D1–D5 applied. Native checks found two more Herdr-worktree
  lines in `utilizing-tools-orca-ade` (capability table, Herdr alignment);
  fixed. A `precheck-authority.ps1` probe of a read-only grep whose quoted
  pattern contained `\|git add` was hard-blocked: quote-unaware splitting can
  block (not only re-route) a read-only command. #039's Risks text understates
  this; see follow-ups.
- 2026-10-03: Replay 1 answered all four questions correctly and found
  residual conflicts (`docs/tools/orca-ade` Herdr-worktree text; domain-audit
  claim-level vs resource-level tagging and "only"; proposal template wording).
  Revised.
- 2026-10-03: Replay 2 answered correctly and found further wording conflicts
  (AGENTS.md "Outside Herdr" without the Orca exception; domain/README capture
  trigger; suggest-skill criteria; Orca sandbox row; "may omit TAG"; promotion
  of an existing UNCERTAIN resource). Revised.
- 2026-10-03: Replay 3 (sweep) found no current-guidance conflict on staging or
  proposal metadata, and on D1 only Orca-skill teardown issues outside this
  decision; on D2 it found the `suggest-skill.ps1` offline fallback routing
  any "domain|audit|freshness" prompt to the User-invoked domain-audit. Fixed
  to match only an explicit `domain-audit` mention.

## Validation

- Native: grep for the old worktree, audit, staging and proposal wording;
  mirror diff; INDEX and REFERENCES links resolve; IDs unique; STATUS values.
- Fresh replay: a fresh read-only worker answers three questions from the
  repository alone — may a Herdr task use an Orca worktree; may an agent run
  `git add` without asking; what metadata does a non-risk proposal take.

## Risks

- D5 closes records whose own replay rule was not met word for word.
  Mitigation: each note names the User decision and the related later
  evidence, and does not claim the replay.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-03): every Herdr-plus-worktree mention in
`utilizing-tools-orca-ade` and `HERDR-AGENTS.md` states the shared-checkout
rule; AGENTS.md lists staging and the revised skill clause; the five records
show `STATUS: completed` with a dated User-decision note citing later evidence
(cited lines re-read by the coordinator); `.agents`/`.claude` skills differ
only by line endings; `suggest-skill.ps1` parses with 0 errors; INDEX and
REFERENCES links resolve; no duplicate IDs; this record is not git-ignored.

Fresh replays (fresh native general-purpose read-only workers): three runs, as
recorded in Progress. Each answered the decision questions in line with the
User's decisions, citing current guidance:

- Herdr workers never get an Orca worktree; Orca worktree coordination runs
  only when the User selects it.
- `git add` needs explicit authority (AGENTS.md and the gate agree).
- A non-risk proposal uses `#<seq>_PROPOSAL_<MMDD>`, no TAG, and drops the
  risk link and Related Risks section.
- domain-audit records User-confirmed scope as [CONFIRMED], asks first when
  nothing is confirmed, and promotes an existing [UNCERTAIN] resource in place.

The last fix (suggest-skill fallback) was checked by code reading and parse
only; it was not re-replayed.

Limits and follow-ups (suggestions until authorized):

- `orca-ade-coordinate-agents` always tears down with `orca worktree rm
  --force` and requires a clean primary checkout, against AGENTS.md's
  recoverable-operation and preserve-changes rules; its worktree-to-checkout
  integration step is not gated by authority.
- `docs/tools/claude/README.md` routes all delegation through Herdr without
  the Orca exception, and its skill list is stale.
- domain-audit promotion does not say how unconfirmed claims of an existing
  [UNCERTAIN] resource become open questions; `templates/domain.md` defaults
  to [UNCERTAIN] with no confirmed-path note.
- A standalone proposal's `REFERENCES:` has no guidance once the risk link is
  removed; proposal STATUS values are undefined.
- `#032` (Orca-only coordination) has no current-policy notice; its content
  agrees with this decision.
- `precheck-authority.ps1` splits on separators inside quotes; make splitting
  quote-aware so a quoted pattern cannot hard-block a read-only command.
