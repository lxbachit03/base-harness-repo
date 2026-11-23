# Definition of Done: <ticket-title>

What the User must answer or do before this ticket can be marked resolved
(DoD: definition of done). Only required items block resolution; optional
items close with their default.
docs-harness/tickets/README.md owns the rules. With no item, keep one line:
`Nothing awaiting the User.` Remove this template note in a real ticket.

## Open

### U1 — <short title>

- Kind: <question | action>
- Priority: <required | optional>
- Source: <PRD page/section, AC and question IDs, report link; omit if none>
- Needed: <the exact question, or the action the User must take>
- Blocks: <acceptance criterion, decision or step it blocks, with link>
- Options: <choices, with the agent's recommendation marked; or n/a>
- Default: <optional only: what applies if unanswered, and why no acceptance
  criterion depends on it>
- Asked: <YYYY-MM-DD>

## Closed

### U0 — <short title>

- Kind: <question | action>
- Status: <answered | answered-from-evidence | done | waived | defaulted>
- Answer: <the User's answer, what they did, the evidence, or the default applied>
- Closed: <YYYY-MM-DD>
- Applied in: <ticket.md section or decision/ file that records the result>
