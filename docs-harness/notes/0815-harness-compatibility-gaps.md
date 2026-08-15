# Harness Compatibility Gaps

AUTHORITY: The User explicitly authorized a `docs-harness/notes/` workspace and
asked it to record the compatibility-review gaps identified above.
CREATED: 2026-08-15
STATUS: open
SCOPE: current Harness setup in `test_custom_harness`
REFERENCES:
- ../INDEX.md
- ../plans/active/0815-user-authorized-notes.md

## Observed Gaps

### Validator documentation

Observed: `.agents/validators/README.md` is effectively empty, so the entry
point, invocation timing, and exit semantics are not documented in the local
validator workspace.

Suggested follow-up — not authorized or applied by this note: add a concise
validator README that documents the supported commands, empty-state meaning,
failure exit codes, and fixture-suite usage.

### Ticket lifecycle proof

Observed: the active/completed ticket layout and routing contract exist, but no
fresh rerun with a real ticket has yet proven intake, User-authorized closure,
stale-status normalization, and default exclusion of completed history.

Suggested follow-up — not authorized or applied by this note: run one real
ticket through the lifecycle and record the comparison before deciding
`keep`, `revise`, or `remove` for the active improvement.

### Validator routing

Observed: the Risk-to-Proposal validator and fixture suite are available, but
the validator is not automatically invoked for every relevant workflow.

Suggested follow-up — not authorized or applied by this note: route the
validator at the relevant risk/proposal validation boundary without making it
mandatory for unrelated prompts.

## Resolution Boundary

This note records observations and User-authorized follow-up context. It does
not approve any suggested change, close any active improvement, or claim that
the Harness has improved. Resolve, supersede, or promote an item only when the
User authorizes the corresponding action and the canonical resource is updated.
