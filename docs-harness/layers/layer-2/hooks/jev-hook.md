# Hook: jev-hook — Jev verdict gate

Applies to every AI agent session in this repository, Bale and delegated
workers, when the activation checklist below is checked.

## Activation (User-controlled)

- [ ] Enable jev-hook: require a Jev verdict before each action group this
  session

Toggle rules live in [hooks/README.md](README.md) (Loading).

## Gate rule

Before performing any action outside the exemptions, run the matching Jev
consult and wait for its verdict; execute only after the verdict arrives.
One consult covers one action group per turn (a turn is one User message and
the agent's work on it; a delegated worker's whole assignment is one turn):

- File ops: read, write, edit or search (Grep, Glob) any repository file.
- Shell: Bash and PowerShell commands.
- Web: web search and web fetch.
- Coordination: delegating, spawning, or coordinating other agents (Herdr,
  Orca, native subagents).
- Other tools: any further tool invocation not covered above.

One verdict covers the same-intent actions of that group in the same turn; a
new intent starts a new consult.

Exempt: the Jev consult itself (including locating and reading
docs-harness/JEV-AI.md section 3.1 to build it), and session-start retrieval:
AGENTS.md, docs-harness/INDEX.md, docs-harness/SESSION.md, PERSONA.md, the
layers walk, hook files, Markdown files under docs-harness/project-constraints/,
and INDEX's alignment check (the `harness-check --quick` run or its manual
name comparison). Other file
contents are gated. These exemptions enable the gate and cannot gate themselves.

## Script selection

- All action groups, including shell →
  `.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1`
  with state and questions built for the pending action (default when no
  dedicated script fits). Build state from the current user intent, the
  pending action summary and targets, and applicable SESSION.md authority and
  project constraints; include at least:

  - `gate_decision` (choice): `proceed` | `proceed_with_caution` |
    `pause_ask_user` | `veto` — self-contained instructions and criteria.
  - `risk_score` (score): 0 safe read-only / 1 local reversible /
    2 external or hard to undo.

  For shell actions, include the exact command in the pending action. Follow
  docs-harness/JEV-AI.md section 3.1 for state and question shapes.

## Consult observability

Invoke every consult without `-Quiet`: the full request payload, response
answers, model, and latency must appear in the session output. A one-line
summary alone does not satisfy the gate; the request and response stay
observable so a skipped or truncated consult is detectable.

## Verdict handling

- `proceed` or `proceed_with_caution`: execute; surface the caution.
- `pause_ask_user`: stop; report Jev's reason and one concrete question.
- `veto`: do not execute; report the verdict and one alternative proposal.

The verdict does not grant authority absent from SESSION.md. Apply its explicit
permission requirements independently for every action and target.

## When Jev cannot answer

Missing key, offline, or API error (helpers return Fallback = true):
announce `JEV GATE BYPASS — Jev unavailable (<reason>)`, then execute. The
bypass never lowers SESSION.md authority; actions needing explicit User
authority still pause for the User.

## Reporting

In the session outcome summary, report consulted action groups, verdicts,
and any bypasses so a skipped gate stays observable.
