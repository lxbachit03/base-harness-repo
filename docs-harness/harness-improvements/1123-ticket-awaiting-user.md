# Harness Improvement Resource

ID: #095_IMPROVE_HARNESS_1123
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add ticket-DoD.md to every ticket: what the User must answer or do before the ticket can close
CREATED: 2026-11-23
STATUS: completed
REFERENCES:
- .agents/skills/ticket-solving/SKILL.md
- docs-harness/tickets/README.md
- docs-harness/templates/ticket-DoD.md
- docs-harness/templates/ticket.md
- .agents/skills/prd-research/SKILL.md

## Objective

Every ticket workspace holds `ticket-DoD.md`: the list of questions the User
must answer and actions the User must take before the ticket can be marked
resolved. `ticket-solving` creates it at intake, keeps it current while solving,
blocks `resolved` while an item is open, and reports the open items.

## Purposes

- [x] The User sees in one file, per ticket, exactly what blocks completion and
  what they need to answer or do (User request, 2026-11-23).
- [x] Questions and User actions stop being scattered across ticket.md sections,
  decisions and chat, where they get lost between sessions.
- [x] A ticket is not marked resolved while something still waits on the User.
- [x] After `prd-research`, the ticket's ticket-DoD.md holds the questions
  drawn from the BA's ACs and PRD, so the User answers them in one place
  (User request, 2026-11-23).
- [x] Apply ponytail's "does it need to exist?" principle: each item is triaged,
  and items no acceptance criterion depends on become optional with a stated
  default, so they do not block completion (User request, 2026-11-23).

## Current State

Baseline: `main` at `f0628c4`, clean. `ticket-solving` and
`docs-harness/tickets/README.md` record unknown acceptance criteria and open
questions inside ticket.md ("Risks and Open Questions") and decisions; there is
no per-ticket list of what waits on the User, and the resolved gate checks
acceptance evidence only. Example: the YGZ pilot ticket waited on several User
choices (agy instead of Claude CLI, round 2, accept/drop, remove skill) that
were visible only in chat until recorded as decisions afterwards.
`prd-research` already tracks AC questions with IDs inside its reports.

## Proposed Improvement

- New template `docs-harness/templates/ticket-DoD.md`: one entry per item
  with ID (`U1`, `U2`…), kind (question / action), what is needed, why it
  blocks completion (linked criterion or decision), options and the agent's
  recommendation, status (open / answered / done / waived), and the answer with
  date and where it was applied.
- `tickets/README.md` owns the rules: created with every ticket, items added
  when work needs the User, answers applied to ticket.md or a decision and
  kept as history, `resolved` only with no open items (or a User waiver),
  items owned by another artifact (prd-research questions) linked, not copied.
- `ticket-solving` SKILL.md (both mirrors): create at intake, maintain while
  solving, gate on it, report open items. ticket.md template links it.

## Scope

Changes: the files above, templates catalog, INDEX template list, single-ticket
layout example; `prd-research` (both mirrors) writes its pending questions into
the file (continuation, 2026-11-23). Existing tickets are not backfilled; they
get the file the next time they are worked under authority.

## Progress

2026-11-23: record created; edits applied to the template, tickets/README.md,
ticket-solving (both mirrors), ticket.md template, templates catalog, INDEX
template list and single-ticket example. 2026-11-23: checks and fresh replay
passed (see Decision and Result). 2026-11-23 continuation: User asked that
`prd-research` also update ticket-DoD.md with questions based on the BA's
ACs and PRD; added step 5 to the skill, a `Source` field to the template, and
replaced the link-only rule in tickets/README.md. 2026-11-23: User renamed the
file from `awaiting-user.md` to `ticket-DoD.md` (DoD: definition of done);
all references, the template and this record updated; earlier replay notes
refer to the old name. 2026-11-23: after the ponytail research
(`R&D/ponytail-research/`), the User asked for a required/optional triage;
added the four-rung ladder to tickets/README.md, `Priority`/`Default` fields
and `answered-from-evidence`/`defaulted` statuses to the template, and
required-only gates to ticket-solving and prd-research.

## Validation

- `harness_check.py` on the repo.
- Fresh replay: an agent with the changed skill runs intake on a small scratch
  ticket whose source leaves an acceptance criterion open, and should create
  `ticket-DoD.md` with that item open and refuse `resolved`.

## Risks

- One more file per ticket adds noise when nothing waits on the User.
  Mitigation: the file then states one line, `Nothing awaiting the User`.
- An agent lowers items to optional to close a ticket early (premature
  completion). Mitigation: rung 2 items (acceptance criteria, authority,
  product, money, security, data) are never lowered by the agent; optional
  needs a concrete reversible default; reports list every default applied;
  the User can raise any item back to required.
- Duplication with ticket.md open questions or prd-research questions.
  Mitigation: ticket-DoD.md is the single list of User-blocking items;
  ticket.md links it; prd-research reports keep the analysis while the file
  tracks status, one item per question ID.

## Decision and Result

**Keep.** `harness_check.py`: clean (95 IDs, links, skill mirror 20 skills / 70
files identical). Fresh replay (separate agent, no hint about the new file):
intake of a sample ticket "PAY-412 Export invoices to CSV" whose source left
the total currency and the background-export limit open, written to the
scratchpad, repository untouched. The agent retrieved
`templates/ticket-DoD.md` through the skill and tickets/README.md, created
`ticket-DoD.md` with three open items (U1 currency, U2 export limit, U3
codebase and owner as an action), each with what it blocks and a recommended
option, linked it from ticket.md instead of repeating the items, set status
`intake`, refused `resolved` citing the open items, and asked the User U1–U3 by
ID. Not exercised: closing an item after a User answer, and the waiver path;
existing tickets are not backfilled.

Continuation replay (prd-research step 5), 2026-11-23: a fresh agent ran
`prd-research` on a scratchpad copy of `01-sample-ticket`, told to reuse the
existing reports unchanged and "complete whatever else the skill requires",
with no mention of the new file. It created `ticket-DoD.md` with 12 open
items, one per pending question Q-01 to Q-12; each title carries the question
and AC IDs (AC sets matched the report exactly), `Source` quotes the BA's AC
wording with FRD page links and links the report entries, and options carry a
recommendation only where the FRD supports one. It asked the User U1–U12 by ID
and reported the missing ticket.md and decision/ as gaps. Repository untouched.
Not exercised: closing an item after a User answer, the rerun update path.

Triage replays (required/optional), 2026-11-23, fresh agents on scratchpad
copies of `01-sample-ticket` with the 12 FRD questions, repository untouched:
- Run 1, rung 2 worded "touches an acceptance criterion": 11 required,
  1 optional (Q-09 draft-until-Save). Too conservative: every PRD question
  names an AC, so ownership (Q-01) stayed required.
- Revised rung 2 to "different answers would change an acceptance criterion's
  observable outcome", noting that ownership rarely does.
- Run 2: 10 required, 2 optional (Q-01 ownership with the report's proposed
  layers as default; Q-09 draft-until-Save, citing FRD p.65). All money,
  scope, version and display questions stayed required; both optional items
  carry a default; the agent asked required items first and listed the
  defaults. It noted Q-04 and Q-09 are nearly settled by the FRD but left them
  because rung 1 would edit the reports, which the test forbade.
Not exercised: closing optional items as `defaulted` at resolution, the User
raising an item, rung 1 with report edits. Keep.
