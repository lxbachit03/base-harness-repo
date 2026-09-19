# Harness Improvement Resource

ID: #025_IMPROVE_HARNESS_0919
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Preserve improvement purposes as a checklist
CREATED: 2026-09-19
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/harness-improvements/README.md
- docs-harness/templates/harness-improvement.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- .gitignore

## Objective

Require every new or continued Harness improvement record to preserve the
intended purposes of that improvement in a dedicated checklist section, without
confusing purpose with the observable Objective, implementation scope, or proof.

## Purposes

- [x] Preserve why an improvement was requested, not only what files or rules it
  changes.
- [x] Make the intended value of each improvement reviewable in later sessions.
- [x] Keep purpose history explicit without inventing purposes for legacy records.

## Current State

- Repository: `D:/repos/base-harness-repo`, branch `main`, revision
  `5795f19`; worktree clean and one commit ahead of `origin/main`.
- `.agents/skills/improve-harness/SKILL.md` requires an Objective but does not
  require a separate purpose section or checklist.
- `docs-harness/templates/harness-improvement.md` has no `## Purposes` section.
- Existing records are historical evidence; their purposes cannot be safely
  inferred and bulk migration is outside this request.
- The User explicitly requested a purpose/purposes checklist for improvements.

## Proposed Improvement

Update the `improve-harness` contract and Harness improvement template so every
new or continued record includes `## Purposes` directly after `## Objective`.
Require at least one concrete checklist item, distinguish accepted purposes from
candidate purposes, and preserve the section through validation and completion.

## Scope

In scope:

- `.agents/skills/improve-harness/SKILL.md`.
- `docs-harness/templates/harness-improvement.md`.
- This record, its INDEX entry, and the ignore allowlist.

Out of scope:

- Bulk rewriting existing improvement records or legacy plans.
- Changing improvement IDs, statuses, lifecycle, or fresh-rerun requirements.
- Commits, pushes, or unrelated Harness policies.

## Progress

- 2026-09-19: Baseline captured, the User request recorded, and this record
  created before intervention edits.
- 2026-09-19: Updated `improve-harness` and the improvement template with the
  required `## Purposes` checklist contract, then verified this record follows
  the new layout.

## Validation

- Native validation: inspect the skill's record contract, template placement,
  checklist syntax, and INDEX/ignore routing.
- Native result: the skill requires at least one concrete checklist item, the
  template places `## Purposes` directly after `## Objective`, this record has
  three accepted purpose items, and the record is indexed and unignored.
- `git diff --check` passed; no repository validator script was created or
  invoked.
- Behavioral proof: pending a fresh bounded improvement request that creates or
  continues a record and verifies the purpose checklist is retrieved and kept.

## Risks

- Purpose duplication with Objective: define Objective as the observable change
  and Purposes as the reasons/value, then review both sections together.
- Unverified inferred history: leave legacy records unchanged and require the
  User or fresh improvement request to supply purposes when continuing them.

## Decision and Result

Implementation complete; fresh replay pending. The requested purpose checklist
is accepted by the User; effectiveness remains unverified until a new or
continued improvement record exercises the contract.
