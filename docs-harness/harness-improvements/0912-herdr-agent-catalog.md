# Harness Improvement Resource

ID: #018_IMPROVE_HARNESS_0912
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: User-selected Herdr worker configuration catalog
CREATED: 2026-09-12
STATUS: active
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/HERDR-AGENTS.md
- docs-harness/WORKFLOW.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0912-agent-self-validation.md

## Objective

Replace the active Herdr policy's mandatory GPT-5.6 Luna/max/Fast worker
configuration with an explicit, user-editable model catalog. BALE must read one
catalog, choose exactly one model and only the supported reasoning-effort and
speed/Fast settings nested under that model when dispatching, and pause when any
selection or runtime support is not provable. Codex dispatch also requires a
process-scoped full-access permission/capability proof; the primary session's
global config is not changed by this policy.

## Current State

- Baseline revision: `4913deb99f205063b8f3e50245e43aba1bb5d87c` on `main`.
- Baseline worktree status: clean; branch is one commit ahead of
  `origin/main`.
- `.agents/skills/herdr-coordinate-agents/SKILL.md` hard-codes
  `gpt-5.6-luna`, max reasoning effort and Fast mode for workers, and its
  unsupported-configuration pause names only that profile.
- `.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md`
  hard-codes the same Codex flags in its launch example and requires proving
  those three settings.
- `README.md` describes Herdr as dispatching Codex Luna/Max/Fast workers.
- The current runtime launch path is `agent start --kind codex`; there is no
  repository evidence that an Antigravity or direct Claude adapter is already
  available through Herdr.
- The preceding improvement retired `.agents/validators/` and makes targeted
  agent inspection the default Harness proof; this change must not recreate a
  validator script.

## Proposed Improvement

Add `docs-harness/HERDR-AGENTS.md` as the single BALE-facing selection registry.
It will provide model-scoped sections for Codex, Antigravity and Claude catalog
entries. Each model section owns its supported effort checklist and an optional
Fast checklist; unsupported sections are omitted. Provider/transport fields,
sources and verification dates, and a user-added model template remain explicit.
It will require exactly one model and exactly one choice in each checklist
present under that model, runtime proof of the combined settings, and a pause
rather than silent substitution when a selected choice is unavailable or has no
verified Herdr adapter. For Codex, the runtime contract will pass the
provider-native `--dangerously-bypass-approvals-and-sandbox` flag after
Herdr's argument separator (`--yolo` is accepted only when local help exposes
that alias), or its equivalent pair (`--sandbox danger-full-access` plus
`--ask-for-approval never`), and inventory enabled/authenticated plugins and MCP
servers.

Update the Herdr skill, runtime reference, AGENTS.md, README.md and INDEX.md to
route BALE to this registry and remove the active mandatory Luna wording.
Historical improvement records remain historical evidence; only direct references
to retired Herdr artefacts may be removed during cleanup.

## Scope

May change:

- the new `docs-harness/HERDR-AGENTS.md` catalog;
- direct Herdr coordination/runtime instructions and their repository pointers;
- the new improvement record, INDEX classification, and narrow ignore
  exceptions needed to track the two new Harness resources.

Must not change:

- Herdr installation, global settings, external accounts, panes, or provider
  adapters;
- the primary Bale model rule or the default maximum of two live workers;
- historical records that document the previously accepted Luna trial, except for
  direct references to retired Herdr artefacts;
- the retired `.agents/validators/` tree or the manual self-validation policy.

## Progress

- 2026-09-12: Baseline captured and current Luna-specific consumers identified.
- 2026-09-12: Official OpenAI, Google Antigravity and Anthropic model sources
  consulted for catalog candidates; account/runtime availability remains a
  runtime question.
- 2026-09-12: Added the registry, routed all active Herdr consumers to it, and
  removed the active Luna-only requirement. Native inspection passed; fresh
  routing replay remains pending.
- 2026-09-12: Reworked the registry after User feedback so every model owns its
  effort checklist and optional Fast checklist. There are no global effort or
  speed groups; all model and scoped choices remain intentionally unselected.
- 2026-09-12: Researched Codex 0.153.4 and Herdr 0.7.5 argument forwarding.
  Added a process-scoped Codex YOLO/full-access contract (with the equivalent
  auditable flag pair) and capability inventory; local help exposes the long
  flag, while `--yolo` remains conditional; global `config.toml` remains
  unchanged and no worker was launched during this documentation update.
- 2026-09-12: Researched the provider-native full-access requests for Herdr
  `agy` (Antigravity `--dangerously-skip-permissions`) and `claude` (Claude
  `--dangerously-skip-permissions`/`bypassPermissions`). Recorded them as
  provisional adapter mappings only: the current dispatcher still proves and
  accepts Codex identity, Antigravity requires its own permission/config and
  MCP inventory, and Claude is not installed in this runtime.
- 2026-09-12: Read-only capability inventory found 10 enabled Codex plugins and
  an enabled `node_repl` MCP whose auth status is `Unsupported`; Antigravity
  reports no imported plugins and no configured MCP servers; `claude` is not on
  PATH. Full permission does not create or authenticate any of these missing
  capabilities.
- 2026-09-12: Per User direction, removed the Herdr skill's retired validation
  evidence and dispatch-helper trees. Active guidance now uses native Herdr
  operations, coordinator-owned attempt records and manual agent self-review;
  direct references to the removed artefacts were deleted from the codebase.
- 2026-09-12: Practical calculator trial completed through the Antigravity
  adapter. An unsupported `fast` choice paused before submission; after the
  User selected `standard`, one prompt produced the three calculator files and
  Bale's independent checks passed. The run also exposed avoidable orchestrator
  overhead: repeated repository/catalog and capability context, two pre-waits
  before the final observation, overlapping acceptance reads, and a main-checkout
  write boundary. Worker effort was a selected input, not the target of this
  intervention; no per-model token telemetry was captured.
  The active guidance now adds `direct`/`tight`/`full` attempt profiles, compact
  packets, worker reuse conditions, one bounded prompt/wait path, proportional
  acceptance, exact model-ID resolution, and stronger Antigravity proof fields.
  The trial proves local transport and task delivery, but did not capture the
  provider settings/deny-rule evidence required for a complete Antigravity
  permission claim; that gap remains explicit.
- 2026-09-12: Installed `herdr agent prompt --help` confirms the native
  `--wait --until <status> --timeout <ms>` path used by the lean handoff; no
  repository dispatch helper was added.
- 2026-09-12: User clarified that the cost target is BALE's orchestrator, not
  the delegated model. Reframed the guidance to preserve worker selections and
  reduce coordinator context/tool calls through cached hashes, compact ledgers,
  receipt-first inspection and no repeated catalog read for unchanged profiles;
  updated the INDEX route to match.
- 2026-09-12: Fresh lean calculator replay used one prompt and zero pre-poll
  waits. The bounded call timed out at 60 seconds, but reconciliation found the
  same worker `done`; no prompt was resent. Three files and independent checks
  passed. The worker returned a concise terminal receipt but did not persist the
  packet's receipt file because the prompt omitted its absolute path; the
  coordinator recorded a receipt-gap observation and kept the experiment active.
  No orchestrator token telemetry was exposed.
- Coordinator acceptance snapshot for `herdr-calculator/`: `index.html`
  `FCFA5E43C1CF34932FBEF13D959ECCD2AF3AFACCC85F7472034E14B949F0FE58`,
  `styles.css` `CB91EB85E4F089A180EC0549FBA082AC3EA109B2040325391059F944FE4C4659`,
  and `app.js` `9A001353D6EBBAB8B77CFA0E5FD5A0EA657E186F47913890526C867913B82D01`.
- 2026-09-12: Revised the tight handoff contract so the prompt must include the
  absolute receipt path and require the worker to write JSON before its terminal
  summary. The trial scratch packet remains disposable; the durable record keeps
  the hashes, state reconciliation and receipt-gap limitation.

## Performance observations and decision

The trial establishes process overhead, not a controlled token or latency
benchmark, and it did not attribute tokens between models. The user's target is
BALE's orchestrator cost, so worker effort/Fast choices stay unchanged. Reduce
orchestrator work by caching unchanged routing/configuration hashes, keeping a
compact ledger and one-sentence scope, sending one bounded prompt/wait, reading
the receipt/output diff before any transcript, and doing one proportional
acceptance pass. Use `full` packets only when dependencies, shared outputs,
external risk or recovery justify the additional evidence.

## Validation

Targeted agent inspection will check:

- the catalog has one unambiguous model-scoped checkbox contract and
  distinguishes catalog candidates from dispatchable runtime profiles;
- all active Herdr pointers, model-selection steps and links resolve to the new
  owner without the old mandatory Luna rule;
- provider/transport, model, model-specific effort and Fast evidence
  requirements remain explicit, with unsupported settings omitted and no
  unsupported Antigravity/Claude dispatch implied by a list entry;
- Codex YOLO/full-access mode (or the equivalent permission mode), approval
  policy, and redacted plugin/MCP capability evidence are captured before prompt
  submission;
- tight handoffs keep configuration evidence in the coordinator, use one bounded
  prompt/wait path, keep BALE's ledger/context compact, avoid duplicate broad
  checks, and reuse a worker only when its identity/worktree/configuration
  evidence is unchanged;
- multi-ID catalog entries resolve to an exact provider model ID in the attempt
  record, while Antigravity evidence includes native speed state, sandbox,
  `allowNonWorkspaceAccess`, and applicable deny/managed rules;
- metadata, IDs, ignore exceptions and final diff are coherent.

Observed native proof on 2026-09-12: all scoped files and both new resources
exist; the registry contains model-local effort checklists and Fast checklists
only where the dated sources document support, with zero choices selected; the
new skill/runtime links resolve; the active-owner scan found no legacy
Luna-only hard-code; `git diff --check` passed. Manual self-review confirmed
that no Harness validator or dispatch script was created or invoked and that no
direct references to the retired Herdr artefacts remain. The fresh lean replay
completed with one prompt, zero pre-poll waits and passing independent checks,
but its worker receipt file was missing because the prompt omitted the absolute
path; the Antigravity settings/deny-rule proof is also incomplete. The record
therefore remains active for contract revision and a later bounded replay.

## Risks

- Model catalogs and account entitlements change. Mitigation: keep source URLs
  and verification dates beside each profile, re-check runtime status before
  dispatch, and pause on stale or missing evidence.
- Complete permission/capability proof is still Codex-only, although the
  calculator trial exercised an Antigravity transport. Mitigation: record the
  transport/adapter explicitly and treat each Antigravity profile as
  non-dispatchable until its native settings proof is complete; direct Claude
  remains catalog-only. Never pass a foreign model ID to `--kind codex`.
- Zero or multiple checked boxes could make selection ambiguous. Mitigation:
  require exactly one model plus exactly one value in each applicable
  model-scoped checklist, and make BALE pause for User choice when a required
  checklist is empty or has multiple checks.
- Full access removes filesystem/network sandbox boundaries and suppresses
  approval prompts. Mitigation: apply it only to a task-owned trusted worktree,
  keep the primary/global config unchanged, inventory plugin/MCP authentication,
  and pause when the external sandbox or capability proof is missing.
- Provider bypass flags are not interchangeable. Mitigation: use only the
  provider-native adapter mapping, preserve explicit deny/managed rules and
  authentication requirements, and keep unproven Antigravity/Claude profiles
  catalog-only until the dispatcher and native proof support them.
- A tight path or reused context could under-verify a task whose dependencies
  changed. Mitigation: promote work to `full` when dependencies, shared outputs,
  external risk or recovery are present; otherwise require unchanged identity,
  input hashes and configuration evidence before reuse.
- A single bounded wait can time out a genuinely long task. Mitigation: keep the
  attempt pending, reobserve the same handle and receipt, and issue at most a
  focused correction after the prior attempt settles; never resend blindly.

## Decision and Result

Keep the lean coordinator path provisionally: the fresh replay preserved the
selected profile, used one prompt without pre-polling, produced the requested
files, and passed independent checks. The receipt-path contract is now revised;
complete one bounded replay with the path included and finish the Antigravity
settings proof before marking the improvement completed. Owner for that replay:
the next fresh BALE session handling a Herdr coordination request.
