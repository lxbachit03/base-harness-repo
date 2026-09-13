# Harness Improvement Resource

ID: #022_IMPROVE_HARNESS_0913
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Make Windows OpenCode launch deterministic and remove the mandatory Herdr preflight gate
CREATED: 2026-09-13
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/herdr-coordinate-agents/scripts/prepare-opencode-windows.ps1
- .agents/skills/herdr-coordinate-agents/references/herdr-runtime.md
- .agents/skills/herdr-coordinate-agents/references/task-contract.md
- docs-harness/harness-improvements/0913-opencode-go-model-catalog.md

## Objective

Make a fresh Windows Herdr `--kind opencode` launch avoid the PowerShell
`opencode.ps1` resolution failure by using a deterministic task-local
executable shim. Remove the separate mandatory Herdr preflight phase that
delays launch; retain only the minimum post-launch identity/permission check
needed to avoid submitting work to the wrong worker configuration.

## Current State

- Baseline revision: `a7cd789de8c27483e98b47004762a437d5779ffe` on `main`.
- Baseline worktree status: `main...origin/main [ahead 8]` with the two
  requested OpenCode output directories untracked and no other observed drift.
- On Windows, the first OpenCode Herdr launch resolved `opencode.ps1` through
  `Start-Process opencode` and failed with `%1 is not a valid Win32
  application`. A later retry succeeded only after a task-local shim invoked
  the installed `opencode.exe`; global wrappers were not changed.
- The Herdr skill/runtime/catalog currently require a broad configuration and
  capability preflight before prompt submission, including catalog selection,
  runtime proof and provider inventory. This is the reusable source of the
  launch delay, distinct from the OpenCode executable-resolution defect.
- Existing proof includes Herdr 0.7.5-preview.2026-07-21-0f10e1453a7f,
  OpenCode 1.18.30, a real OpenCode Go replay, and the observed wrapper
  resolution failure. No global configuration or credentials were changed.

## Proposed Improvement

Add a Windows-only, task-local OpenCode launcher-preparation helper that:

1. resolves an installed executable or `.cmd` entry without selecting the
   PowerShell wrapper;
2. creates a unique temp shim that invokes that executable with the original
   Windows `%*` argument list; and
3. returns the PATH/environment value to use when creating the Herdr worker
   workspace.

Update the Herdr contracts so the selected worker profile remains explicit but
there is no separate mandatory full preflight before launch. Launch with the
resolved profile and safe environment, then perform one bounded post-launch
check of cwd, provider/model and process-scoped permission state before sending
the task. Capability inventory remains evidence when the provider exposes it;
an unavailable optional listing must be recorded rather than manufactured by a
side-effecting command.

Smallest hypothesis: a task-local shim removes the known Windows resolution
failure, while launch-first/post-launch-check guidance removes repeated
preflight work without silently accepting a wrong worker. Contrary evidence
would be a fresh OpenCode launch that still resolves the wrapper, or a bounded
replay where the lean contract cannot detect a wrong identity/permission state.
The maintenance owners are the OpenCode launcher helper and the Herdr skill,
runtime reference, task contract, catalog and root role guidance.

## Scope

May change:

- the new task-local OpenCode Windows launcher helper;
- direct Herdr launch/selection guidance in `AGENTS.md`,
  `.agents/skills/herdr-coordinate-agents/`, and
  `docs-harness/HERDR-AGENTS.md`;
- this improvement record and its INDEX entry.

Must not change:

- global `opencode.ps1`, `opencode.cmd`, PATH, Herdr installation, credentials
  or account settings;
- unrelated worker panes, provider model choices or the two-worker limit;
- receipt-first completion, independent acceptance checks or the Bale code
  review gate;
- any repository validation or task-dispatch automation; the helper only
  prepares a temp executable environment and does not send prompts.

## Progress

- 2026-09-13: Baseline captured from the dirty worktree after the OpenCode
  documentation task. The User explicitly requested this improvement and a
  real coordinated validation.
- 2026-09-13: Created this record before intervention edits. The observed
  failure is reproducible in the captured environment and the proposed shim is
  recoverable because it lives outside the repository.
- 2026-09-13: Added `prepare-opencode-windows.ps1`, which resolves only an
  Application-typed `.cmd`/`.exe`, fails closed when neither is available, and
  emits a unique temp shim plus process-scoped PATH. Updated `AGENTS.md`, the
  Herdr skill/runtime/task contract and `HERDR-AGENTS.md` to remove the
  separate full preflight gate and require one bounded post-launch check.
- 2026-09-13: Helper parse and direct `Start-Process opencode --version`
  checks passed with the task-local shim; the resolved command was
  `C:\nvm4w\nodejs\opencode.cmd`, OpenCode `1.18.30`, exit code `0`.
- 2026-09-13: Fresh coordinated replay `replay-01` created workspace `w1H`
  with the helper PATH, launched `bale-opencode-win-01` once with Herdr
  `--kind opencode`, and returned `interactive_ready=true` in 3.3 seconds.
  The native screen showed `Build auto · DeepSeek V4.1 Flash OpenCode Go · max`,
  cwd `D:\repos\base-harness-repo`, OpenCode `1.18.30`, and no Win32 wrapper
  error. One prompt completed with a matching receipt and no repository writes;
  the task-owned workspace was closed after acceptance.

## Validation

Native proof inspected the helper, all direct Herdr consumers, route links,
metadata and the final diff. The fresh coordinated Windows OpenCode replay
created a task-owned workspace with the helper-provided environment, launched
the worker once, submitted one bounded read-only task and reconciled its
receipt/artifact. The wrapper error did not recur, and the worker retrieved and
exercised the launch-first/post-launch guidance without a broad preflight. The
coordinator independently verified the actual helper and live launch because
the worker receipt correctly limited its own static inspection. No global
wrapper or repository validator was changed or invoked.

Focused proof:

- PowerShell parser: helper syntax passed.
- Helper resolution: target was `C:\nvm4w\nodejs\opencode.cmd`, never `.ps1`.
- `Start-Process opencode --version` with the emitted PATH: OpenCode `1.18.30`,
  exit code `0`.
- Herdr replay: `w1H:p1`, `interactive_ready=true`, native `Build auto · ... ·
  max`, receipt status `completed`, one prompt, no repository changes.
- `git diff --check`, affected-file trailing-whitespace check, route/link and
  ID inspection passed; no validator or dispatch script was added.

## Risks

- The installed OpenCode path or Herdr adapter may change. Mitigation: the
  helper fails closed when it cannot resolve a real executable and the replay
  records the exact resolved path/version.
- Removing a broad preflight could hide a wrong model or permission state.
  Mitigation: keep one bounded post-launch check before prompt delivery and
  pause on a mismatch; do not infer capability from a side-effecting command.
- A temp shim could be reused by an unrelated process. Mitigation: use a unique
  task-owned temp directory, return its path in launch evidence, and never
  modify global wrappers or PATH persistently.

## Decision and Result

Keep. The deterministic task-local shim prevents the observed Windows
`opencode.ps1` resolution failure in the live Herdr replay, and the revised
contracts remove the separate full preflight while retaining a bounded
post-launch identity/permission check. The result is proven for the captured
Windows/Herdr `0.7.5-preview.2026-07-21-0f10e1453a7f` and OpenCode `1.18.30`
environment only; future adapter or installation changes still require the
helper's fail-closed resolution and the same post-launch check.
