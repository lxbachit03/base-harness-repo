# Decisions

Decision records preserve lasting product, architecture, data ownership,
security, compatibility, and validation choices that future work must inherit.

## Read When

Read this folder when a task makes, challenges, or relies on a consequential
choice that future work must inherit. Do not load historical decisions when the
current task is independent of them.

## Create And Maintain

Use `docs-harness/templates/decision.md`. Task-local implementation choices
remain in the active execution plan and do not require a separate decision.

- Create a decision only after the relevant authority accepts the choice.
- Record the rejected alternatives, rationale, scope, and validation impact
  when they matter to future work.
- Index each real decision in this file and `docs-harness/INDEX.md` as required;
  do not fabricate decisions for an empty installation.

An installed consumer begins with no fabricated decisions. Add local decision
documents here as real choices are accepted, then index them in this file.
