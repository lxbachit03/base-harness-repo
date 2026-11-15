# Harness Improvement Resource

ID: #066_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Give every docs-harness folder a README
CREATED: 2026-11-15
STATUS: active
REFERENCES:
- docs/raw-requirements/skills/init-harness-repo.json
- docs/raw-requirements/layers/layers.json
- docs-harness/templates/folder-readme.md
- docs-harness/templates/README.md
- docs-harness/INDEX.md
- docs-harness/tickets/README.md
- .agents/skills/ticket-solving/SKILL.md
- .agents/skills/prd-research/SKILL.md
- docs-harness/layers/layer-1/README.md
- docs-harness/layers/layer-1/agents/README.md
- docs-harness/layers/layer-2/README.md
- docs-harness/tickets/active/01-sample-ticket/README.md
- docs-harness/tickets/active/01-sample-ticket/docs/prd-research/README.md

## Objective

Every `docs-harness/` folder outside the template scaffolds has a README.md,
as raw requirement init-harness-repo Yêu cầu 1.6 asks, and the ticket workflow
keeps new ticket folders compliant. Each README is short: it states the
folder's purpose and points to the file that owns its rules, record or
manifest, following a new folder-README template.

## Purposes

- [x] Meet requirement 1.6 for the five folders `harness-check` reports.
- [x] Keep new ticket, batch and artifact folders from re-creating the drift.
- [x] Keep each rule in one owner: a README points to it instead of copying.
- [x] Honor requirement 2.4.1 with the template the User chose to create.

## Current State

Baseline (2026-11-15 14:21, Asia/Bangkok): `D:/repos/base-harness-repo`,
branch `main` at `4e83213`, three commits ahead of `origin/main`, worktree
clean.

`harness-check` reports 5 of 21 folders without README.md: `layers/layer-1`,
`layers/layer-1/agents`, `layers/layer-2`, `tickets/active/01-sample-ticket`
and its `docs/prd-research`. The ticket guide uses `ticket.md` at a ticket
root and `docs/README.md` as the artifact manifest, so every new ticket or
artifact folder would also lack a README. No folder-README template exists.
`layers.json` Yêu cầu 2 asks for an INDEX entry for every `.md` file under
`layers/`.

User decisions (2026-11-15): apply the proposed handling (pointer READMEs; INDEX
links for the new layer READMEs; a README rule for ticket, batch and artifact
folders in the ticket guide and both ticket skills; no invented `ticket.md` for
the sample ticket) and create a folder-README template (requirement 2.4.1).

## Proposed Improvement

Add `templates/folder-readme.md` and list it in the template catalog and
INDEX. Use it for the five READMEs: the three layer READMEs point to
`layers/README.md` or `hooks/README.md` and are linked from INDEX; the sample
ticket's README says it has no `ticket.md` and points to its manifest; the
`prd-research/` README points to the manifest. Add the README rule to
`tickets/README.md`, ticket-solving and prd-research, with mirrors.

Hypothesis: a pointer README per folder meets 1.6 without duplicating rules,
and naming it in the ticket workflow keeps new folders compliant. Contrary
evidence: a README drifts from its owner, a new ticket folder appears without
one, or agents start reading these READMEs at session start. Owner:
`templates/folder-readme.md` and the ticket guide. Revise if requirement 1.6
changes.

## Scope

May change: the new template and five READMEs, the template catalog, INDEX
(layers and templates routes), `tickets/README.md`, the ticket-solving and
prd-research skills with their `.claude` mirrors, this record and its list
entry.

Unchanged: the INDEX status of the four existing layer files (a separate
`layers.json` Yêu cầu 2 mismatch), the sample ticket's other files and its
missing `ticket.md`, and `docs/raw-requirements/`. No commit or push without
the User's approval.

## Progress

- 2026-11-15: Baseline captured; record created and listed before
  intervention edits.
- 2026-11-15: Added `templates/folder-readme.md` to the catalog and INDEX;
  wrote the five READMEs from it (layer READMEs in English, sample-ticket
  READMEs in Vietnamese like the ticket's manifest); linked the three layer
  READMEs from INDEX; added the README rule to `tickets/README.md`,
  ticket-solving and prd-research, with mirrors.

## Validation

- `harness-check` full run: RESULT clean (exit 0). All 21 folders outside the
  template scaffolds have README.md; 66 INDEX links, 66 ID entries and 958
  local links in 132 Markdown files resolve; the skill mirror is identical;
  IDs `#001`–`#066` are unique.
- Session-start load: INDEX grew from 14,996 to 15,206 normalized bytes, so
  the start-up total including the quick-check output rose from 32,589 to
  32,799, still within `#064`'s 33,400 target. The layers walk does not read
  the new READMEs.
- Line endings are consistent in every changed file; mirrors are
  byte-identical.

Unattempted: a fresh intake showing that a new ticket gets its folder
READMEs.

## Risks

- More READMEs to keep current. Mitigation: each only points to its owner;
  `harness-check` catches missing READMEs and broken links.
- INDEX grows by the new layer and template links. Mitigation: about 0.4 KB,
  measured under Validation.

## Decision and Result

Decision: keep; pending a fresh rerun of a ticket intake. The five folders now
meet requirement 1.6, and the first fully clean `harness-check` run confirms
it.

Next case: in a disposable copy, a fresh session runs ticket-solving intake for
a small synthetic ticket and creates `ticket.md`, `decision/README.md` and the
ticket folder's README from the template; `harness-check` then reports no
folder without README. The run can share a session with the pending cases of
`#063` and `#065`. Owner: the primary (Bale) session, when the User authorizes
the rerun.
