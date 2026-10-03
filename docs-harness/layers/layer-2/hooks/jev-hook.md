# Hook: jev-hook — Jev verdict gate

Applies to every AI agent session in this repository, Bale and delegated
workers, when the activation checklist below is checked.

## Activation (User-controlled)

- [x] Enable jev-hook: require a Jev verdict before each action group this
  session

The checkbox state in this file is the hook's only switch. Only the User
toggles it, anytime; agents read the current state and never edit it.
Unchecked: the gate is dormant — skip this hook entirely and work normally.
Checked: apply the gate for the rest of the session; re-read after
compaction, a workspace switch, or when the User reports toggling it.

## Gate rule

Before performing any action outside the exemptions, run the matching Jev
consult and wait for its verdict; execute only after the verdict arrives.
One consult covers one action group per turn:

- File ops: read, write, edit any repository file.
- Shell and external: bash commands, websearch, webfetch.
- Coordination: delegating, spawning, or coordinating other agents (Herdr,
  Orca, native subagents).
- Other tools: any further tool invocation not covered above.

One verdict covers the same-intent actions of that group in the same turn; a
new intent starts a new consult.

Exempt: the Jev consult itself (including reading docs-harness/JEV-AI.md
section 3.5 to build it), and session-start retrieval (AGENTS.md,
docs-harness/INDEX.md, PERSONA.md, layers walk, hook files) — they enable
the gate and cannot gate themselves.

## Script selection

- Bash commands → `.agents/skills/typesafe-ai/scripts/precheck-authority.ps1`
  (`-Command`, `-ActionDescription`, `-TargetFiles`). Its returned
  Permitted/RequiresUserPermission result is the gate verdict.
- All other groups → `.agents/skills/typesafe-ai/scripts/invoke-typesafe.ps1`
  with state and questions built for the pending action (default when no
  dedicated script fits). Build state from the current user intent, the
  pending action summary and targets, and the applicable AGENTS.md authority
  excerpt; include at least:

  - `gate_decision` (choice): `proceed` | `proceed_with_caution` |
    `pause_ask_user` | `veto` — self-contained instructions and criteria.
  - `risk_score` (score): 0 safe read-only / 1 local reversible /
    2 external or hard to undo.

  Follow docs-harness/JEV-AI.md section 3.5 for state and question shapes.

## Consult observability

Invoke every consult without `-Quiet`: the full request payload, response
answers, model, and latency must appear in the session output. A one-line
summary alone does not satisfy the gate; the request and response stay
observable so a skipped or truncated consult is detectable.

## Verdict handling

- `proceed` or `proceed_with_caution`: execute; surface the caution.
- `pause_ask_user`: stop; report Jev's reason and one concrete question.
- `veto`: do not execute; report the verdict and one alternative proposal.

## When Jev cannot answer

Missing key, offline, or API error (helpers return Fallback = true):
announce `JEV GATE BYPASS — Jev unavailable (<reason>)`, then execute. The
bypass never lowers AGENTS.md authority; actions needing explicit User
authority still pause for the User.

## Reporting

In the session outcome summary, report consulted action groups, verdicts,
and any bypasses so a skipped gate stays observable.
