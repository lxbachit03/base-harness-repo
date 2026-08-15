# Harness Improvements

This folder is the `IMPROVE_HARNESS` routing category for bounded changes to
agent guidance, tools, runbooks, or validation. The purpose is to improve one
reusable future-agent behavior, not to collect speculative cleanup or ordinary
product changes.

## Read When

Read this folder when the User explicitly invokes `$improve-harness` or asks to
improve the Harness after observed, reusable agent friction.

## Operating Boundary

- Start from an observed task trajectory and identify the earliest preventable
  gap and its owner.
- Apply one smallest intervention at the correct owner.
- Preserve consumer-owned product truth and do not add credentials or mutate
  external systems.
- Require a fresh equivalent rerun before claiming the Harness improved.
- Keep the result as `keep`, `revise`, `remove`, or `pending fresh rerun`.

Experiment records use `docs-harness/templates/harness-improvement.md` and are
kept with the active/completed plan lifecycle when they need durable memory.
The record, not this README, holds the task-specific baseline and evidence.

## Skip When

Skip this folder for ordinary product implementation, a one-off agent mistake,
speculative process changes, or an inspection that has no authorization to
change Harness behavior.
