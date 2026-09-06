---
name: improve-harness
description: Apply a scoped Harness improvement after an explicit request or acceptance of an evidence-backed rules review, then verify the changed behavior.
---

# Improve Harness

Use for an explicitly requested change to guidance, skills, tools, or validation
after observed reusable friction. A request to report friction remains read-only.
Read AGENTS.md, docs-harness/INDEX.md, docs-harness/WORKFLOW.md, and the routed policy owners first.
Use writing-for-agents for instruction edits. AGENTS.md owns task authority,
including routine local proof; the workflow name is not an external-write grant.

## 1. Preserve the baseline

Record repository root, revision, branch, status, representative request,
observed gap, relevant tool/authority conditions, and existing proof. A concrete
rules review accepted by the User supplies a baseline and change authority.
Do not invent runtime measurements or diagnose model limitations from one run.

Every new authorized improvement, including a small single-session change,
gets one Markdown record directly under docs-harness/harness-improvements/.
Create it before intervention edits from docs-harness/templates/harness-improvement.md.
Name it MMDD-lowercase-kebab-case-description.md, using the creation date in
Asia/Bangkok with zero-padded month/day, for example 0906-update-index-routing.md.
Follow docs-harness/templates/README.md for the global ID, metadata and collision
checks; use TAG: [IMPROVE_HARNESS] and index the record in that classification.

On continuation, identify the same intervention by its objective, scope and
existing record; update that record and preserve its ID, creation date and path.
A different improvement gets a new record even on the same day. If its intended
filename is occupied by another improvement, use a distinct meaningful slug or
a numeric suffix such as -2; never overwrite it. Pause if identity is ambiguous.
An existing legacy record under plans/ is continued in place; migration requires
User authority. This record holds baseline, progress, decisions, proof and result;
do not create a duplicate plan merely to record the same improvement.

An explicit request to perform an improvement includes its bounded record.
A question about the skill or an explicitly read-only review does not start a
new improvement and creates no record. If the requested change lacks evidence,
record the gap and proposed investigation before pausing the intervention.

Done when the record exists, is indexed, and the accepted outcome and evidenced
gap are concrete. If no gap is established, propose an investigation before
intervention edits; keep the record's status and missing evidence explicit.

## 2. Change the owning contract

Locate the earliest preventable gap: context, capability, domain ownership,
authority, proof, or environment. State the smallest hypothesis, contrary
evidence, maintenance owner, and removal condition.

Apply the accepted scope at its existing owner and update direct consumers.
A User-approved consistency review may span several files; it remains one
coherent intervention. Preserve consumer policy and unrelated work.

Done when contradictory current guidance is reconciled and local checks pass.

## 3. Exercise the changed behavior

Use a fresh agent session with equivalent task, tools, authority, and relevant
conditions. Match the replay to the change: instruction routing/permission
changes can use bounded scenarios, including a real isolated local edit/check
where execution authority is being tested. Keep external actions simulated.

Record whether the intervention was available, retrieved, and exercised; report
observed outcome, repeated questions, mistakes, and remaining limits. Review
returned work. Do not infer production effectiveness or speed from scenario
results. A separate reviewer may independently check consistency while the
main agent finishes native validation.

If a relevant fresh replay cannot run, keep the experiment active with
Decision: pending fresh rerun, a concrete replay task and owner. Implementation
may be reported finished; effectiveness remains unverified.

## 4. Decide and report

Choose keep, revise, or remove from the evidence. After native checks and the
relevant replay decision, record the result and set STATUS: completed in the
same file under harness-improvements/; retain its path, ID and creation date.
Pending replay keeps STATUS: active with the missing proof and next case.
Legacy experiments already under plans/ retain that plan lifecycle. Preserve
their history without retroactively claiming they passed earlier reruns.

Report the record path, baseline, changed owners, checks, fresh scenario results, decision, and
limitations. If a replay exposes a defect, revise and rerun the affected case.
