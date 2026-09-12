# Harness Improvement Resource

ID: #021_IMPROVE_HARNESS_0913
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add source-backed OpenCode Go worker model catalog
CREATED: 2026-09-13
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/WORKFLOW.md
- docs-harness/HERDR-AGENTS.md
- .agents/skills/improve-harness/SKILL.md
- .agents/skills/herdr-coordinate-agents/SKILL.md
- .agents/skills/utilizing-tools-codex/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- https://opencode.ai/go
- https://opencode.ai/docs/go/
- https://opencode.ai/docs/models/
- https://opencode.ai/zen/go/v1/models
- https://dev.opencode.ai/docs/cli/
- https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/deepseek-v4.1-flash.toml
- https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/kimi-k3.toml
- https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/glm-5.2.toml
- https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/glm-5.3.toml
- https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/deepseek-v4-pro.toml
- https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/acp/config-option.ts
- https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/cli/cmd/tui.ts
- https://github.com/anomalyco/opencode/blob/v1.18.30/packages/tui/src/component/dialog-variant.tsx
- https://github.com/anomalyco/opencode/blob/v1.18.30/packages/tui/src/component/prompt/index.tsx
- https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash/blob/main/README.md
- https://huggingface.co/moonshotai/Kimi-K3/blob/main/README.md
- https://docs.z.ai/guides/llm/glm-5.2
- https://docs.z.ai/guides/llm/glm-5.3
- https://docs.z.ai/guides/capabilities/thinking
- https://api-docs.deepseek.com/guides/thinking_mode/
- https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/provider/transform.ts

## Objective

Add a source-backed OpenCode Go section to the Herdr worker catalog for the
User-requested DeepSeek V4.1 Flash, Kimi K3, GLM 5.2, GLM 5.3 and DeepSeek V4
Pro profiles. Keep effort choices model-scoped, omit Fast checklists unless a
separate Fast mode is documented, and make the provider/adapter proof boundary
explicit so a catalog checkbox cannot be mistaken for dispatch authorization.

## Current State

- Baseline revision: `f8e6ec987576a32a31f99196c5acbd4990041028` on `main`.
- Baseline worktree status: clean; branch is five commits ahead of
  `origin/main`.
- `docs-harness/HERDR-AGENTS.md` contains Codex, Antigravity and Claude API
  profiles, but no OpenCode Go provider or exact Go model IDs.
- The current Herdr preview accepts `--kind opencode` as well as `--kind codex`;
  a provider profile still requires a fresh adapter launch, native full-access
  state and tool/plugin/MCP capability inventory before dispatch.
- Official OpenCode Go docs and the Go model endpoint currently list all five
  requested IDs. The local OpenCode CLI (`1.18.30`) independently returned the
  same IDs from `opencode models opencode-go` on 2026-09-13. No credentials were
  read or changed.
- The provider documentation does not describe a separate Fast variant for
  these five models. The initial catalog incorrectly carried DeepSeek V4.1
  Flash's upstream continuous reasoning range into the OpenCode Go entry. The
  effective OpenCode Go metadata and local CLI expose discrete provider
  variants; the exact current lists are DeepSeek V4.1 Flash `low/high/max`,
  Kimi K3 `max`, GLM 5.2 `high/max`, GLM 5.3 `low/high/max`, and DeepSeek V4
  Pro `high/max`. The OpenCode TUI adds a synthetic `Default` no-override
  option for models with variants; it is not provider metadata.

## Proposed Improvement

Add a dated OpenCode Go catalog section with exact `opencode-go/<model-id>`
configuration IDs, per-model effort/variant checklists, source links and
verification dates. Represent DeepSeek V4.1 Flash using the TUI's synthetic
`default` no-override choice plus the provider variants `low`, `high` and
`max`; do not describe `default` as a fourth provider effort or assume it
equals the model-native default. Document
native-versus-adapter option differences (including GLM 5.2 and DeepSeek V4
Pro mappings) and state that all five entries are catalog-only until a proven
Herdr OpenCode adapter and permission/capability evidence exist. Update the
selection contract and INDEX only where needed to route this evidence; do not
add a validator or dispatch script.

Smallest hypothesis: an explicit, source-backed provider section lets the User
choose OpenCode Go models dynamically while preventing an unproven model ID,
effort label or host permission from reaching Herdr. Contrary evidence would be
a fresh bounded replay showing that the nested choices are ambiguous, stale or
cannot be reconciled with the provider's native output. The maintenance owner
is the Herdr coordination skill and its model catalog.

## Scope

May change:

- `docs-harness/HERDR-AGENTS.md` selection contract and OpenCode Go entries;
- `.agents/skills/herdr-coordinate-agents/references/herdr-runtime.md` and
  `.agents/skills/herdr-coordinate-agents/references/task-contract.md`
  continuous-effort evidence guidance;
- this improvement record, its INDEX entry and its narrow ignore exception.

Must not change:

- OpenCode installation, subscription, credentials, global settings or external
  accounts;
- Herdr/provider adapters, worker panes, permission policy or runtime scripts;
- model entries outside the five requested OpenCode Go profiles;
- any effort/Fast option not supported by a cited provider source or proven
  runtime output.

## Progress

- 2026-09-13: Baseline captured from the clean post-review-gate commit. The
  User requested research and catalog-only configuration for five OpenCode Go
  models after subscribing to OpenCode Go.
- 2026-09-13: Created this record before catalog intervention edits, as required
  by the Harness improvement lifecycle.
- 2026-09-13: Official OpenCode Go page/docs and model endpoint confirmed the
  exact provider IDs, endpoint and current catalog. Official DeepSeek, Moonshot,
  Z.ai and OpenCode source documentation supplied model-specific effort rules;
  the local CLI independently confirmed the five IDs.
- 2026-09-13: Updated the catalog selection contract, Herdr runtime reference
  and task contract for continuous effort evidence, then added only the five
  requested OpenCode Go profiles. No Fast checklist was added because no
  separate Fast variant is documented for these models.
- 2026-09-13: A fresh read-only worker replay (before the later DeepSeek
  correction) retrieved the catalog and matched all five profile/model IDs,
  each then-current nested effort list and the omitted-Fast rule.
  It correctly treated the entries as non-dispatchable until an OpenCode Herdr
  adapter proves authentication, full-access/approval state and tool/plugin/MCP
  inventory. No files were changed by the replay.
- 2026-09-13: Follow-up verification corrected the DeepSeek V4.1 Flash entry.
  `opencode models opencode-go --verbose` reports provider variants `low`,
  `high` and `max`; the v1.18.30 TUI source explicitly prepends a synthetic
  `Default` option and sends no explicit variant when it is selected. The
  models.dev OpenCode Go metadata independently lists the same three provider
  variants. The catalog keeps `Default/default` as a UI no-override choice,
  not as a provider effort or guaranteed native default.
- 2026-09-13: The local CLI also reconciled the remaining four profiles:
  Kimi K3 exposes only `max`; GLM 5.2 exposes `high/max`; GLM 5.3 exposes
  `low/high/max` with no `medium`; and DeepSeek V4 Pro exposes `high/max` with
  no selectable `low` through OpenCode Go. None has a Fast variant.
- 2026-09-13: A real Herdr trial created task-owned workspace `w1C`, launched
  `opencode-v41-flash-worker-03` with `--kind opencode`, and showed the native
  OpenCode screen `DeepSeek V4.1 Flash OpenCode Go - high`. One bounded prompt
  created `worker-output.md` and a matching `completed` receipt; no duplicate
  prompt was sent. Herdr's Windows adapter first resolved `opencode.ps1` as a
  Win32 process, so the successful retry used a task-local shim and isolated
  state; no global integration/configuration was installed.
- 2026-09-13: A follow-up real Herdr trial created task-owned workspace `w1D`,
  launched `oc-v41-auto-04` with `--kind opencode` and the documented
  `--auto --model opencode-go/deepseek-v4.1-flash --variant high` request. The
  native screen showed `Build auto · DeepSeek V4.1 Flash OpenCode Go · high`.
  One bounded prompt created `worker-output-auto.md` and a matching completed
  receipt at `attempt-03`; no duplicate prompt was sent. The task-local shim
  also invoked the installed binary with `--auto`.

## Validation

Targeted inspection verified one model-scoped section per requested profile,
exact provider IDs, no unrequested OpenCode Go model, no Fast checklist without
source evidence, and the provider-effective effort lists above. The local
`opencode models opencode-go --verbose` output reports those lists; the
v1.18.30 TUI source proves `Default` is a synthetic no-override option, while
the prompt path sends an absent variant when it is selected. The local model
list and `https://opencode.ai/zen/go/v1/models` both contained the five exact
IDs. `git diff --check` passed. The real Herdr replay reported:

```text
replay-01: passed (read-only catalog retrieval)
replay-02: passed (Herdr --kind opencode + OpenCode Go worker)
replay-03: passed (Herdr --kind opencode + documented opencode --auto worker)
profiles: 5 exact IDs; current effort lists matched; Fast checklists: 0
dispatch: completed with native model/variant screen and documented auto-approval
artifact: worker-output-auto.md; receipt: attempt-03/receipt.json; duplicate_prompt: none
```

The first replay was run before the follow-up DeepSeek correction and was
read-only. The second replay proves this Herdr/OpenCode path with the historical
hidden permission alias, while the third replay proves the documented `--auto`
form; both are limited to the captured local environment. Neither installs a
reusable Herdr integration or establishes entitlement on another account. The
`Default` checkbox is source-backed by the v1.18.30 TUI, but its no-override
provider behavior still needs to be recorded if a future task selects it. OpenCode's hidden
`--dangerously-skip-permissions` flag is a version-scoped alias for the same
process-scoped auto-approval behavior as documented `--auto`; the follow-up
replay proves the documented form. Neither form proves removal of an OS sandbox
or override of provider/managed deny rules.

## Risks

- OpenCode Go's model list, pricing or account entitlements can change.
  Mitigation: retain the verification date and require a fresh `/models` or
  `opencode models opencode-go` check before dispatch.
- OpenCode's generic adapter may expose fewer effort variants than a provider's
  native API. Mitigation: record the effective runtime value and pause on an
  unsupported or ambiguous option; never silently map a checked label.
- The synthetic `Default` variant can be confused with an explicit effort.
  Mitigation: record `default` as `no explicit variant`, distinguish it from
  `low`, `high` and `max`, and capture effective provider behavior instead of
  calling it the model-native default.
- A model catalog entry may be mistaken for host permission. Mitigation: keep
  the provider-adapter and full-access/capability proof gate explicit; this
  change does not enable or bypass any permission.
- Herdr's Windows OpenCode launch can resolve the `opencode.ps1` wrapper as a
  Win32 executable. Mitigation: prove executable resolution in the task-owned
  pane and use only a task-local shim or an upstream adapter fix; never rename
  or overwrite the user's global wrappers.

## Decision and Result

Keep. The source/CLI IDs and all five provider-effective variant lists
reconcile after the catalog correction. The v1.18.30 TUI source validates the
synthetic `Default` entry, while the real Herdr replays prove local
`--kind opencode` launches with native `high` selection and documented
process-scoped auto-approval (`--auto`) under the bounded artifact/receipt
contract. Future dispatches must still recheck account entitlement,
integration/adapter availability, executable resolution and capability
inventory; the task-local shim is not a product adapter.
