# Harness Improvement Resource

ID: #043_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Apply the User's group C decisions to remove duplicated on-demand guidance
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- docs-harness/JEV-AI.md
- docs-harness/WORKFLOW.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/enhance-jev/SKILL.md
- docs-harness/harness-constraints/README.md
- docs-harness/risks/README.md
- docs-harness/proposals/README.md
- docs-harness/templates/README.md
- docs-harness/harness-constraints/0812-risk-proposal-suggestion-cross-link.md
- docs-harness/decisions/README.md
- docs-harness/plans/README.md
- docs-harness/product/README.md
- docs-harness/README.md
- docs-harness/templates/constraint.md

## Objective

The User's group C decisions are applied: each duplicated rule or procedure in
on-demand guidance keeps one owner and the other copies become pointers or are
removed, and the small stale items of C9 are corrected, without changing any
file's or folder's purpose.

## Purposes

- [x] Keep each rule in one owner so a change is a one-place edit.
- [x] Remove stale or misleading text that no longer matches the repository.

## Current State

Baseline (2026-10-05): branch `main` at `d51d6ab`, level with `origin/main`,
worktree clean. Source: group C of the 2026-10-03 optimization review.

User decisions (2026-10-05):

| # | Finding | Decision |
| --- | --- | --- |
| C1 | `HERDR-AGENTS.md` duplicated the Herdr runtime | Done in #042 |
| C2 | `JEV-AI.md` §4 restates the `enhance-jev` procedure | Replace with a pointer |
| C3 | `WORKFLOW.md` lists the five Jev practices that belong to the manifest | Move to `JEV-AI.md`; WORKFLOW keeps a pointer and the fallback/credential rule |
| C4 | `goal-griller` Route block twice; `xia` reference table | Not changed |
| C5 | Risk/proposal pairing rule restated in four READMEs | Pointer to `#001_CONSTRAINTS_0812` |
| C6 | `herdr-coordinate-agents` repeats its own rules in the preamble and steps | Keep each rule once, in its step; no replay (User decision) |
| C7 | `enhance-jev` mermaid repeats the phases; `run_command` is an Antigravity tool name | Remove the diagram; say "the shell tool" |
| C8 | Move `sequence-execution-plan` steps 8–9 to a reference | Not changed (recommendation followed) |
| C9 | Small stale items in decisions, plans, product READMEs, constraint and data-flow templates, the empty schema template, templates README, docs-harness README | Fix each |

## Proposed Improvement

Edit each owner per the table; mirror changed skill files to `.claude/skills/`.

## Scope

May change: files in REFERENCES, the four `templates/{service-name}/data-flows/{data-flow-name}/` templates, `templates/{service-name}/schemas/{schema-name}.md`, the `.claude/skills/` mirrors, this record, its INDEX entry and `.gitignore` allow line.

Unchanged: `goal-griller`, `xia`, `sequence-execution-plan`; every rule's meaning.

## Progress

- 2026-10-05: Record created before edits.
- 2026-10-05: Applied C2, C3, C5, C6, C7, C9. C3's five practices now live in
  `JEV-AI.md` §2 as "Usage practices"; WORKFLOW keeps a pointer and the
  fallback/credential rule. C5 first added the "Related Risks / Related
  Proposals sections list the same links" requirement to the #001 constraint,
  which the READMEs carried but the constraint did not, then reduced the
  three READMEs to pointers (`templates/README.md` already pointed). C6 kept
  every removed preamble rule at one step (catalog pointer and limits stay in
  the preamble; pause conditions, no-preflight and Codex flags moved into
  step 3; the worktree ban into step 2). The data-flow typo spanned a line
  break ("a" / "authorized").

## Validation

- Native: every removed copy has its content present at the owner; links
  resolve; IDs unique; mirror diff.
- Fresh replay (C2, C3, C7 only; none for C6 by User decision): a fresh
  read-only worker finds the Jev usage practices, the fallback/credential rule
  and the `enhance-jev` procedure from the repository alone.

## Risks

- C6 edits the only owner of Herdr rules without a replay. Mitigation: every
  removed preamble sentence is checked to exist in a step or the runtime
  reference before removal.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05): no removed string remains in current guidance
(`run_command` remains only in `utilizing-tools-agy`, where it is the
Antigravity tool name); each of 13 Herdr rules checked appears exactly once in
`herdr-coordinate-agents/SKILL.md`; links in every edited file and in INDEX
resolve; no duplicate IDs; `.agents`/`.claude` differ only by line endings;
23 files changed, +101/−156 lines.

Fresh replay for C2, C3, C7 (fresh native general-purpose read-only worker;
no replay for C6 by User decision): from the repository alone it found the
router rule and the other usage practices in `JEV-AI.md` §2 through the
WORKFLOW pointer, the fallback and credential rule in WORKFLOW, and the
`enhance-jev` procedure through the `JEV-AI.md` §4 pointer, including the
"shell tool" test step.

Pre-existing tensions the replay reported (not introduced here; suggestions
until authorized):

- `JEV-AI.md` §1 says credential access needs explicit User authority while
  the helpers resolve the API key from the environment or registry on their
  own. Proposal: state whether the helper's own key lookup is the restricted
  "credential access".
- `enhance-jev` Phase 3 treats live TypeSafe calls as routine local
  verification, while the precheck classifies external requests as needing
  permission. Proposal: say which applies to a test call.
- `enhance-jev` Phase 2 does not say to mirror a new script into
  `.claude/skills/typesafe-ai/scripts/`. Proposal: add the mirror step.

Not done by User decision: C4; C8 kept (recommendation not to move).
