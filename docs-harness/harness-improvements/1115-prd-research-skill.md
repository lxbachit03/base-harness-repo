# Harness Improvement Resource

ID: #062_IMPROVE_HARNESS_1115
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Research ticket PRDs into traceable Markdown and HTML
CREATED: 2026-11-15
STATUS: completed
REFERENCES:
- .agents/skills/prd-research/SKILL.md
- .claude/skills/prd-research/SKILL.md
- docs-harness/tickets/README.md
- docs-harness/templates/ticket-docs-README.md
- docs-harness/INDEX.md

## Objective

Create a `prd-research` skill that analyzes a BA document against the current
project, produces matching Markdown and self-contained HTML reports, and tracks
questions on unclear acceptance criteria through later User answers.

## Purposes

- [x] Explain the requested feature and its impact on end users.
- [x] Identify and highlight acceptance criteria with traceable evidence.
- [x] Propose FE, backend and internal-service ownership, marking uncertainty
  for User confirmation rather than inventing project responsibility.
- [x] Highlight each AC unclear against the codebase, ask a specific question,
  and retain its status until the User answers.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main` at `cf26811`, three
commits ahead of `origin/main`. The User supplied an untracked example PDF in
`docs-harness/tickets/active/01-sample-ticket/`; the folder has no `ticket.md`.
There is no `prd-research` skill. The User chose
`<ticket>/docs/prd-research/` for the two result files.

The example PDF has 97 pages; text extraction found very little text on pages
47 and 97, and images on 11 pages. Visual inspection found a substantive
diagram on page 47 and a blank page 97, so a text-only pass cannot establish
complete source coverage. The existing `#012` INDEX drift and the sample
ticket's unindexed folder predate this task. The Jev hook is disabled.
The User subsequently requested a question beside each unclear AC and the
ability to answer those questions later.

## Proposed Improvement

Add a discoverable skill and its Claude mirror. Trace requirements and all
identifiable acceptance criteria to source locations; separate BA statements,
repository evidence and proposed classifications. Produce two consistent local
reports in the selected ticket folder and keep ticket artifact routing intact.
Associate each unclear AC with an identifiable pending question; reflect later
User answers in both reports without changing the BA source wording.

Hypothesis: a fresh agent can preserve source coverage and accurately separate
confirmed facts from FE/backend/internal-service inferences, while surfacing
unresolved ownership for User confirmation. Contrary evidence includes missing
criteria, fabricated team ownership, inaccessible source regions, broken report
links, or divergence between Markdown and HTML. The skill owns the workflow;
revisit it if fresh evaluation exposes a mismatch or the User changes the goal.

## Scope

The new `.agents` skill and `.claude` mirror, INDEX, and this improvement record.
Preserve the User's untracked example PDF and existing ticket content. Inspect
the example locally for representative evidence; no real-ticket report, product
implementation, unit tests, external messages, staging, commit or push is
authorized by this skill-creation task.

## Progress

- 2026-11-15: Captured the baseline and User-selected report location before
  editing the skill or INDEX.
- The User added per-AC questions for unclear codebase comparisons and later
  replies. Added that behavior to both skill copies and preserved pending state.
- Created the `.agents` skill and byte-identical `.claude` mirror. The first
  fictional replay produced both reports and questions, but review found that
  an `Internal service` filter returned no matches and one quoted AC lost its
  internal quotation marks. The worker corrected the fictional reports. The
  skill now requires exact rendered AC text and checks each layer filter against
  expected matches and nonmatches.
- A separate simulated later User answer updated its linked AC and both reports
  while retaining the original BA text and keeping other questions pending.
- A fresh worker reran the revised skill on the fictional three-AC project and
  produced both reports, the ticket manifest, ownership proposals and linked
  pending questions. The worker checked and corrected the exact AC quotation
  during the rerun before reporting completion.

## Validation

Reviewed the changed guidance, ticket paths, ID and INDEX route, metadata,
mirror hashes and diff. In the fresh rerun, independently inspected both
reports: all three ACs retained their exact source wording at their respective
entries; each uncertain AC had a linked question. Browser checks exercised the
AC selector, FE/backend/internal-service filters and reset, verified local
links, and observed no external assets or network requests. The separate
simulated answer synchronized the answered status in both first-pass reports
and left unanswered questions pending.

The bundled `quick_validate.py` could not start because PyYAML is absent
(`ModuleNotFoundError: No module named 'yaml'`). The bundled JavaScript YAML
parser accepted both frontmatters; local naming, description, placeholder and
mirror checks passed. No dependency was installed. These checks do not replace
a successful run of that validator.

## Risks

- Images or tables may carry requirements that text extraction misses.
  Mitigation: inspect visual regions or use available OCR and flag unreadable
  pages instead of claiming complete coverage.
- Classification could be mistaken for a BA-confirmed decision. Mitigation:
  cite project evidence and label uncertain assignments for User confirmation.
- An unresolved AC question could be lost or its answer mistaken for a BA
  change. Mitigation: keep a stable AC/question link and record User answers
  separately from the source wording in both reports.
- Markdown and HTML could diverge or disclose content through external assets.
  Mitigation: compare their requirements and ACs and use embedded CSS/JS.
- The automatic approval review blocked removal of two rendered PDF inspection
  images in `C:/Users/BALE/AppData/Local/Temp/codex-prd-pdf-inspect-1115/`
  with `blocked by policy`. Mitigation: leave them untouched and report that
  the User can remove the temporary folder manually.
- The automatic approval review also blocked cleanup of the task-owned
  fictional fixture folders `C:/Users/BALE/AppData/Local/Temp/codex-prd-research-replay-1115/`
  and `C:/Users/BALE/AppData/Local/Temp/codex-prd-research-replay-1115-rerun/`
  with `blocked by policy`. Mitigation: leave them untouched and report that
  the User can remove the folders manually.

## Decision and Result

Decision: keep. The primary agent owns the skill and reviewed the fresh-worker
artifacts and later-answer scenario. The results establish behavior for the
fictional scenario, not production effectiveness. The User's example PDF was
inspected only for representative input characteristics; it was not researched
into ticket reports as part of this skill-creation request. The existing #012
route and sample-ticket folder-tree drift remain outside this intervention.
