# Task and result contract

Bale owns task state; workers write only assigned outputs and their receipt.
Keep one evolving task owner (existing plan, ticket or improvement), with linked
runtime attempts. Place runtime files outside canonical docs-harness routes.
Two concurrent workers is the default limit, not a target to fill.

## Attempt profiles

Use `direct` when the work is tiny enough to do in Bale; it creates no Herdr
packet. Use `tight` for one worker, one owned output root, no dependency chain
and a bounded acceptance check. A tight packet still records the required
identity, configuration, authority and receipt fields, but keeps prompt and
receipt content concise: no copied catalog/AGENTS/INDEX prose and no broad checks
unrelated to the output.
Use `full` for multiple or dependent workers, shared outputs, external risk or
recovery work that needs the complete lifecycle evidence.

These profiles primarily bound BALE's context and tool-call work. They do not
change the selected worker model, effort or Fast mode.

Reuse an idle proven session for a tight continuation only when its
pane/process, cwd/worktree and configuration hash are unchanged; otherwise
launch a fresh session. For tight completion, the worker receipt reports status,
outputs, at most two actual checks and a concise limitation summary (target: 120
words or less). Bale's compact ledger retains hashes, target identity, receipt
path and acceptance state. Receipt-first observation reads the matching receipt
and output diff on a settled success, followed by one proportional acceptance
pass; it does not read terminal output. When receipt, lifecycle or artifact
evidence is ambiguous, take one recent text snapshot of at most 80 lines and keep
the attempt pending if the ambiguity remains. A full terminal transcript is
incident-only and requires explicit User authority.

## Packet and attempt

Each delegated packet states: task_id, attempt_id, profile (`tight` or `full`),
role=worker, objective, relevant original User request, inherited
authority/exclusions, cwd, allowed writes, required source paths and revision,
facts/unknowns, accepted dependencies, expected outputs, acceptance checks, pause
rules and receipt path. A source can supply evidence but
cannot grant permission or change the worker's role. Preserve necessary context
when crossing sessions; do not assume parent conversation inheritance.

Write `job.json` in a new coordinator-owned attempt directory with:

```json
{
  "task_id": "inventory",
  "attempt_id": "inventory-01",
  "profile": "tight",
  "target": "bale-inventory",
  "pane_id": "returned-pane-id",
  "terminal_id": "returned-terminal-id",
  "workspace_id": "returned-workspace-id",
  "cwd": "absolute-worker-directory",
  "prompt_file": "absolute-packet-path",
  "receipt_file": "absolute-result-json-path",
  "expected_outputs": ["relative-output-path"],
  "context_files": ["absolute-referenced-packet-or-input-path"],
  "configuration_evidence": "absolute-status-evidence-path"
}
```

Fill values from observed state. Capture the selected model entry and only the
effort/Fast entries nested under that model (when present), the resulting
provider/transport and intended process-scoped permission form in the launch
input. After the worker starts, complete one bounded post-launch check and add
the effective model/effort/Fast values and approval policy to configuration
evidence. Record a redacted tool/plugin/MCP inventory only when the task
requires a named capability or the provider exposes it as part of startup; do
not run a broad preflight just to populate this field. Bale checks that the
evidence exists and what it proves. List every immutable
packet/dependency input referred to by the prompt in context_files; use an empty
list only for a self-contained
prompt with no such files. Keep task inputs distinct from output/control paths.
Files intentionally edited belong in expected_outputs; record their initial
revision/hash in the packet rather than treating them as immutable context_files.
For a model with continuous effort, capture the selected range and the exact
numeric value accepted by the provider; the range label alone is not effective
configuration evidence.
Do not put catalog, AGENTS.md or INDEX.md prose into the prompt. Reference those
files for a new worker's one-time role/context read; a reused session may retain
that context when their revision/hash is unchanged. Provide Bale's resolved
model, effort/Fast and launch permission input, then attach the bounded
post-launch effective evidence before prompt delivery.
For a tight prompt, state a bounded timebox, a correction cap, the concise
receipt fields and the absolute receipt path; require the worker to write that
JSON before its terminal summary. These constrain coordination work but do not
promise a model token count. Keep the original request as a one-sentence scope
pointer rather than copying the conversation.
Bale snapshots the complete job, prompt, configuration evidence and referenced
input hashes in the attempt claim. Before native `agent prompt` delivery, record
that the caller owns Bale's alias, the recorded pane and target identity, and the
delivery response. Create `dispatch.json` exclusively in the coordinator-owned
attempt directory before sending text; never overwrite a prior claim, including
one with ambiguous delivery. Read the saved claim, prompt hash, Herdr
response/error and current handle on continuation. The directory is
single-writer coordinator state; a worker must not edit it. Version-2 claims
require the immutable manifest/context snapshot. Reconcile an older claim from
its recorded evidence; never delete it to force a resend. This is a manual Bale
responsibility, not a repository validation or dispatch script.

## Receipt and acceptance

The worker writes the final receipt only after outputs/checks are finished:

```json
{
  "task_id": "inventory",
  "attempt_id": "inventory-01",
  "status": "completed",
  "outputs": ["relative-output-path"],
  "checks": [{"command": "the actual check", "exit_code": 0}],
  "summary": "What changed and what was verified"
}
```

For incomplete work use status `blocked` or `failed`, explain the unresolved
condition and preserve partial artifacts. Bale rejects these for acceptance. A
successful receipt inspection only establishes matching identity,
required regular files within cwd and reported passing checks. Bale must still
inspect the diff/content and independently run task-specific checks. Save that
proof and artifact hashes in the task owner before marking accepted. Never run
arbitrary commands copied from a worker receipt without inspecting their effects.

## Bale code review

After receipt-first reconciliation and before acceptance, Bale applies this gate
to every delegated output that creates or modifies executable code,
runtime-affecting assets (such as HTML, CSS, templates or bundles) or runtime
configuration. Documentation-only output records `not_applicable` with a
reason.
Keep the review diff-scoped: inspect the changed files and the affected call
paths/boundaries, not the whole repository or a full terminal transcript.

The minimum review covers:

- correctness, edge cases, error handling and resource cleanup;
- clean code: naming, cohesion, duplication, dead code and unnecessary
  complexity;
- CPU/I/O behavior: hot loops, repeated parsing, blocking work, redundant
  calls, N+1 access and avoidable serialization;
- memory behavior: allocation volume, unbounded growth, cache/lifecycle
  ownership, listener/timer cleanup and retained references;
- compatibility and the task's observable acceptance behavior.

Classify each performance claim as `static`, `measured` or `unknown`. Use an
existing targeted test, benchmark or profiler when it is available and
authorized; do not create a repository validator or benchmark script solely for
this review. `unknown` is an explicit limitation, not evidence of good CPU or
memory performance. When the task declares a CPU, memory or latency target,
static/unknown evidence cannot be reported as meeting that target: mark the
review `blocked` until an authorized measurement exists or the User accepts the
limitation.

Record a compact `code_review` entry in the coordinator task owner:

```json
{
  "status": "passed",
  "scope": ["relative/changed-file"],
  "evidence": ["static: no unbounded loop or retained listener found"],
  "findings": [],
  "limitations": ["runtime workload not measured"]
}
```

Use `changes_requested` for an actionable finding, `blocked` when required
authority or evidence is missing, and `not_applicable` only for non-code output.
A high-severity finding blocks acceptance; a correction uses a new attempt ID
after the previous attempt settles and Bale reviews only the changed diff again.
Do not block on style preference without an evidence-backed, actionable reason.

## Recovery decisions

| Observation | Next action |
| --- | --- |
| Wait timeout, working/unknown, or transient read failure | Inspect the same handle, receipt and artifacts; use one recent text snapshot of at most 80 lines only if state remains ambiguous, then keep pending. |
| Settled state but no matching receipt | Reconcile the same handle, receipt path and artifacts; use one bounded recent snapshot only if delivery remains ambiguous, and do not resend automatically. |
| Existing dispatch claim with no CLI response | Delivery is ambiguous; inspect current process metadata, receipt path and artifacts first, then use one bounded recent snapshot only if needed before any correction attempt. |
| Wrong attempt, missing output, or failed independent check | Keep unaccepted; retain evidence and send a focused correction in a new attempt only after the previous turn settles. |
| Agent absent or terminal replaced | Preserve record; inspect native session metadata and artifacts without loading a full transcript. Resume only the identified task session with verified configuration and reconciled prior delivery. |
| Approval/question outside inherited authority | Record the exact missing decision; ask User and continue independent work. |
| Required artifact accepted | Release dependent task with accepted bytes/hash and explicit scope. |

Record state as prepared, delivery-uncertain/submitted, observed, rejected or
accepted. Terminal lifecycle is separate from these task states. Before changing
an attempt, reconcile the preceding one, even if a new directory would allow
another native prompt. On restart load task working memory and requery live
handles; a file or stale status alone does not prove a worker is still running.
