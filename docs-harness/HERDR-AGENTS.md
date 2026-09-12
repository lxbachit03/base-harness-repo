# Herdr worker configuration catalog

This file is BALE's user-editable model registry for Herdr workers. Read it
after `AGENTS.md` and `docs-harness/INDEX.md` before a new Herdr launch or
worker-model change. For a reassignment that keeps the same resolved profile,
reuse the recorded catalog hash and configuration evidence; reread on drift.
A checkbox is a user choice; it is not proof that the current Herdr installation
can launch that profile.

## Selection contract

1. Check exactly one **Model** checkbox in this catalog. The catalog starts
   with zero selections; BALE must not infer a model from list order or from a
   previous task.
2. After choosing a model, use only the **Effort** and **Fast mode** checklists
   nested under that model. Check exactly one effort value when that model has
   an effort checklist. When a provider exposes a continuous effort range,
   check exactly one documented range option and record the exact numeric value
   actually sent or accepted in configuration evidence; the range checkbox is
   not itself the effective number. When the section is explicitly omitted, the
   provider does not expose a selectable effort for that model and no effort
   checkbox is required. Check exactly one Fast value only when that model has
   a Fast mode checklist. When that section is omitted, Fast mode is not
   documented for the model and standard speed is the only permitted
   interpretation.
3. These choices are model-scoped, not global. Do not combine an effort or
   Fast value copied from another model section, and do not add an option that
   the model's source does not list.
4. Prove the effective model ID, effort (when applicable), speed/Fast state
   (when applicable), provider, transport, and permission/capability state in
   native runtime output before submission. The current repository has a Codex
   adapter and a bounded Antigravity calculator trial; an Antigravity profile
   is dispatchable only after its native permission/configuration proof is
   complete, and direct Claude entries remain catalog-only until an adapter is
   demonstrated. OpenCode Go entries require a current Herdr `--kind opencode`
   adapter and native proof; the 2026-09-13 replay proves that path only in the
   captured local environment. Never pass an `opencode-go/<model-id>` to the
   current `--kind codex` dispatcher.
5. Preserve the selected configuration exactly. If a model, scoped option,
   account entitlement, adapter, or runtime result is unavailable, stale,
   incompatible, or unprovable, pause and report the gap instead of silently
   substituting another choice.
6. The primary session remains BALE's current model. This registry selects
   workers only; the default maximum remains two live workers.

Completion criterion: a worker is dispatchable only when exactly one model is
selected, every required checklist nested under that model has exactly one
selection, the resulting transport is supported, the permission/capability
contract is proven, and effective configuration evidence is captured before
submission. For delegated code, runtime-affecting assets or runtime-configuration
output, acceptance also requires the Bale code-review gate in the Herdr task
contract.

## Latency and token guidance

This section targets BALE orchestrator context and tool-call overhead; it does
not change the User's worker model, effort or Fast selections. For a bounded,
single-output task, use one `tight` handoff, a compact task-specific prompt, one
bounded wait, and one proportional acceptance pass. Read the catalog and routing
context once per unchanged session, retain their hashes, and do not paste their
prose into a worker prompt. Prefer the matching idle worker when identity,
worktree and configuration evidence are unchanged. Use receipt-first observation:
inspect the matching receipt and output diff after a settled success, without
calling `agent read`. If receipt, lifecycle or artifact evidence is ambiguous,
read one recent text snapshot capped at 80 lines; keep the attempt pending when
that does not resolve the ambiguity. Full terminal transcripts are incident-only
and require explicit User authority. Then apply one diff-scoped Bale code review
for executable code, runtime-affecting assets or runtime configuration,
classifying CPU and memory evidence as static, measured or unknown; record
limitations before acceptance. Fast/standard remains provider-specific and must
be proven natively.

When a model entry lists more than one provider model ID, BALE must resolve and
record the exact ID used for the attempt. Effort labels do not select an ID
unless the catalog or provider adapter explicitly maps them.

## Permission and capability contract

Permission is a host-runtime property, not a model property. For a Codex
worker, the User-authorized Herdr policy is the provider's YOLO/full-host mode;
a task-owned trusted worktree is an operating boundary, not an OS sandbox:

- Launch with `--dangerously-bypass-approvals-and-sandbox` after Herdr's `--`
  separator. This is the canonical Codex YOLO request: it removes the
  filesystem/network sandbox and suppresses approval prompts, so the process
  can reach paths and network resources outside the worktree. Use the `--yolo`
  alias only when the installed `codex --help` exposes it; the current 0.153.4
  help exposes the long form only.
- The equivalent auditable form is the pair `--sandbox danger-full-access`
  plus `--ask-for-approval never`; use one form or the other, not both. Native
  runtime output must prove the resulting full-access/approval state.
- Do not put those flags in the primary session's global configuration as part
  of this catalog. Apply them to the worker process only and keep the worker
  in a task-owned, trusted worktree. A global `config.toml` change needs a
  separate User decision.
- The YOLO form is high risk. Use it only for a trusted task-owned worktree or
  an environment with an independently enforced external sandbox; it must not
  be silently applied to the primary session or shared global configuration.
- Full access does not install, authenticate, or enable tools. The worker
  inherits the selected Codex host's built-in tools, enabled plugins, skills,
  and configured MCP servers. MCP servers and external plugins retain their
  own authentication and tool-level policies.
- Before dispatch, inspect the same `CODEX_HOME` used by the worker with
  `codex plugin list` and `codex mcp list`. Record only names, enabled state,
  and authentication status; never copy tokens into task evidence. If a
  required capability is absent or unauthenticated, pause instead of
  claiming that full permission created it.
- For a non-Codex provider, BALE must use that provider's documented full-access
  adapter and equivalent capability inventory. Do not pass Codex flags to an
  Antigravity or Claude process.

Dispatch gate: the selected worker must show the requested model/effort/Fast
values, its provider-native full-access and approval state, and the observed
tool/plugin/MCP inventory in configuration evidence before the task prompt is
submitted. For Codex this means YOLO/bypass mode, or the equivalent
`danger-full-access` plus approval policy `never`; other providers must show the
equivalent native state from a proven adapter.

### Provider adapter matrix (research, not an implicit enablement)

Herdr only forwards the arguments after its `--` separator; it does not grant
the child agent permission or install its tools. The provider must expose a
verified adapter before BALE may dispatch it. These are the provider-native
full-access requests to use when such an adapter is added:

| Herdr kind | Provider-native request | Native proof and capability inventory | Current repository status |
| :--- | :--- | :--- | :--- |
| `codex` | `--dangerously-bypass-approvals-and-sandbox`; use `--yolo` only if local help exposes the alias; equivalent pair `--sandbox danger-full-access --ask-for-approval never` | Codex `/status` + `/permissions`; `codex plugin list`; `codex mcp list` in the worker's `CODEX_HOME` | Dispatch path implemented; process-scoped YOLO/full-access required |
| `agy` | `--dangerously-skip-permissions`; keep terminal sandbox disabled when host-level access is intended | Antigravity headless `stream-json` `init.permission_mode` and `tools`; `agy plugin list`; `agy mcp list`; inspect `settings.json` deny/managed rules and `allowNonWorkspaceAccess` | Bounded calculator trial completed 2026-09-12; complete permission/configuration proof remains per profile |
| `claude` | `--dangerously-skip-permissions` (equivalent to `--permission-mode bypassPermissions`) | Claude `/permissions` or native startup output; `claude plugin list`; `claude mcp list`; inspect managed/project deny rules and authentication | Herdr kind is documented, but Claude CLI is not installed in the current runtime |
| `opencode` | Documented `--auto` (root TUI or `run`); auto-approves permissions not explicitly denied. OpenCode v1.18.30 also has hidden aliases `--yolo` and `--dangerously-skip-permissions`, but do not make them the default | Native startup screen/process command proving auto state and selected model/variant; `opencode mcp list`; no separate plugin-list command is exposed | Bounded OpenCode Go replay passed 2026-09-13 with documented `--auto`; account/adapter/capability proof remains per profile |

The Antigravity and Claude requests still do not override explicit deny rules,
managed policy, provider authentication, or an MCP server's own access policy.
OpenCode `--auto` has the same process-scoped limitation: it is not an OS
sandbox removal or a bypass of provider/managed deny rules.
`--sandbox` on Antigravity or Claude sandbox settings intentionally retain an
OS boundary and therefore are not equivalent to host-level full access. For
Antigravity, `allowNonWorkspaceAccess` and any deny/managed rule must also
permit the requested scope; the bypass flag alone does not prove that. Never
use a global wildcard or rewrite shared provider settings merely to make an
unverified adapter appear ready; use a task-owned provider configuration when
the provider supports one, and record its effective state.

## Catalog by provider

The entries below are dated research candidates. Each model owns its own
effort checklist and, only when the sources document one, its own Fast mode
checklist. The option names are intentionally not shared across models.

### Codex

These profiles use the current Herdr launch kind (`codex`) when the local
runtime proves the selected model and settings.

#### `codex-gpt-6-astra`

- [ ] **Model** `codex-gpt-6-astra` - provider `codex`; transport `codex`;
  model ID `gpt-6-astra`; availability `runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast`
- [ ] `standard`

Fast mode is documented for this model but can be unavailable for some data
residency configurations; prove the effective state at runtime.

#### `codex-gpt-5.6-sol`

- [ ] **Model** `codex-gpt-5.6-sol` - provider `codex`; transport `codex`;
  model ID `gpt-5.6-sol`; availability `runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `none`
- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast`
- [ ] `standard`

#### `codex-gpt-5.6-terra`

- [ ] **Model** `codex-gpt-5.6-terra` - provider `codex`; transport `codex`;
  model ID `gpt-5.6-terra`; availability `runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `none`
- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast`
- [ ] `standard`

#### `codex-gpt-5.6-luna`

- [ ] **Model** `codex-gpt-5.6-luna` - provider `codex`; transport `codex`;
  model ID `gpt-5.6-luna`; availability `runtime-check required`; retained as
  a user-selectable option, not a mandatory default.

##### Effort checklist (select one for this model)

- [ ] `none`
- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast`
- [ ] `standard`

#### `codex-gpt-5.5`

- [ ] **Model** `codex-gpt-5.5` - provider `codex`; transport `codex`;
  model ID `gpt-5.5`; availability `runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `none`
- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`

##### Fast mode checklist (select one for this model)

- [ ] `fast`
- [ ] `standard`

### Antigravity

These profiles use an Antigravity selector/CLI transport, not the current
Herdr `--kind codex` path. The official headless CLI accepts `--effort` values
`low`, `medium`, and `high`; the selector also exposes model-specific presets.
The nested lists therefore remain subject to account and runtime proof. The
Fast entries below mean the Antigravity selector displays a Fast choice; they
are not automatically equivalent to Codex `service_tier=fast`.

#### `antigravity-gemini-3.8-flash`

- [ ] **Model** `antigravity-gemini-3.8-flash` - provider `antigravity`;
  transport `antigravity-cli`; model IDs `gemini-3.8-flash-medium` or
  `gemini-3.8-flash-high`; availability `account/adapter/runtime-check
  required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

##### Fast mode checklist (select one for this model)

- [ ] `fast` (selector entry)
- [ ] `standard`

#### `antigravity-gemini-3.7-flash`

- [ ] **Model** `antigravity-gemini-3.7-flash` - provider `antigravity`;
  transport `antigravity-cli`; model IDs `gemini-3.7-flash-medium` or
  `gemini-3.7-flash-high`; availability `account/adapter/runtime-check
  required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

##### Fast mode checklist (select one for this model)

- [ ] `fast` (selector entry)
- [ ] `standard`

#### `antigravity-gemini-3.6-flash`

- [ ] **Model** `antigravity-gemini-3.6-flash` - provider `antigravity`;
  transport `antigravity-cli`; model IDs `gemini-3.6-flash-medium` or
  `gemini-3.6-flash-high`; availability `account/adapter/runtime-check
  required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

##### Fast mode checklist (select one for this model)

- [ ] `fast` (selector entry)
- [ ] `standard`

#### `antigravity-gemini-3.1-pro`

- [ ] **Model** `antigravity-gemini-3.1-pro` - provider `antigravity`;
  transport `antigravity-cli`; model ID `gemini-3.1-pro-high`; availability
  `account/adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `high` (selector/CLI model preset)

Fast mode is not shown for this model in the current Antigravity selector; no
Fast checklist is provided. Use standard speed only.

#### `antigravity-claude-sonnet-4.6-thinking`

- [ ] **Model** `antigravity-claude-sonnet-4.6-thinking` - provider
  `antigravity`; transport `antigravity-cli`; model ID `claude-sonnet-4-6`;
  availability `account/adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

Fast mode is not shown for this model in the current Antigravity selector; no
Fast checklist is provided. Use standard speed only.

#### `antigravity-claude-opus-4.6-thinking`

- [ ] **Model** `antigravity-claude-opus-4.6-thinking` - provider
  `antigravity`; transport `antigravity-cli`; model ID `claude-opus-4-6`;
  availability `account/adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

Fast mode is not shown for this model in the current Antigravity selector; no
Fast checklist is provided. Use standard speed only.

#### `antigravity-gpt-oss-120b`

- [ ] **Model** `antigravity-gpt-oss-120b` - provider `antigravity`;
  transport `antigravity-cli`; model ID `gpt-oss-120b` (selector preset
  `Medium`); availability
  `account/adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`

Fast mode is not shown for this model in the current Antigravity selector; no
Fast checklist is provided. Use standard speed only.

### Claude API

These are direct Anthropic API entries. They require a verified Claude
transport/adapter; the current repository does not establish one.

#### `claude-opus-5`

- [ ] **Model** `claude-opus-5` - provider `claude-api`; transport `claude-api`;
  model ID `claude-opus-5`; availability `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast` (research preview; API beta/account access required)
- [ ] `standard`

#### `claude-opus-4-8`

- [ ] **Model** `claude-opus-4-8` - provider `claude-api`; transport
  `claude-api`; model ID `claude-opus-4-8`; availability
  `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

##### Fast mode checklist (select one for this model)

- [ ] `fast` (research preview; API beta/account access required)
- [ ] `standard`

#### `claude-opus-4-7`

- [ ] **Model** `claude-opus-4-7` - provider `claude-api`; transport
  `claude-api`; model ID `claude-opus-4-7`; availability
  `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

Fast mode is not available for this model; no Fast checklist is provided. Use
standard speed only.

#### `claude-opus-4-6`

- [ ] **Model** `claude-opus-4-6` - provider `claude-api`; transport
  `claude-api`; model ID `claude-opus-4-6`; availability
  `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `max`

Fast mode is not available for this model; no Fast checklist is provided. Use
standard speed only.

#### `claude-sonnet-5`

- [ ] **Model** `claude-sonnet-5` - provider `claude-api`; transport
  `claude-api`; model ID `claude-sonnet-5`; availability
  `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `xhigh`
- [ ] `max`

Fast mode is not documented for this model; no Fast checklist is provided. Use
standard speed only.

#### `claude-sonnet-4-6`

- [ ] **Model** `claude-sonnet-4-6` - provider `claude-api`; transport
  `claude-api`; model ID `claude-sonnet-4-6`; availability
  `adapter/runtime-check required`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `medium`
- [ ] `high`
- [ ] `max`

Fast mode is not available for this model; no Fast checklist is provided. Use
standard speed only.

#### `claude-haiku-4-5`

- [ ] **Model** `claude-haiku-4-5` - provider `claude-api`; transport
  `claude-api`; model ID `claude-haiku-4-5-20251001`; availability
  `adapter/runtime-check required`.

Effort is not supported for this model, so no effort checklist is provided.
Fast mode is not available, so no Fast checklist is provided. Use the model's
standard behavior only.

### OpenCode Go

These profiles use the OpenCode Go provider and its OpenAI-compatible endpoint,
not the Herdr `--kind codex` path. The installed Herdr preview accepts
`--kind opencode`; a bounded replay on `2026-09-13` launched the worker and
proved the native model/variant screen and artifact receipt in an isolated
worktree. On Windows the replay needed a task-local executable shim because
Herdr's `Start-Process opencode` resolved `opencode.ps1`; this is environment
evidence, not a global adapter installation. The exact OpenCode configuration form
is `opencode-go/<model-id>`; the provider endpoint is
`https://opencode.ai/zen/go/v1` and the current model list is available from
`https://opencode.ai/zen/go/v1/models`. The five entries below are the only
OpenCode Go models requested in this catalog. OpenCode Go's list, account
entitlements and adapter behavior can change, so BALE must recheck the native
CLI/API before selection.

When the User authorizes automatic permission approval, the OpenCode launch
request is the documented `opencode --auto` flag (or `opencode run --auto` for
non-interactive execution). It approves permissions that are not explicitly
denied; it does not remove the OS sandbox or override provider/managed deny
rules. The v1.18.30 replay used this documented flag and showed `Build auto` in
the native TUI. Hidden aliases are retained only as version-scoped compatibility
notes, not as the catalog default.

No Fast mode checklist is provided for these entries: the official OpenCode Go
model/endpoint documentation does not document a separate Fast variant for any
of the five models. Omitted Fast means standard speed only; do not infer Fast
from a low effort value or a model name. A checkbox records user intent, not
provider authentication, host permission, enabled plugins/MCPs or Herdr
dispatchability.

#### `opencode-go-deepseek-v4.1-flash`

- [x] **Model** `opencode-go-deepseek-v4.1-flash` - provider `opencode-go`;
  transport `opencode-cli`; model ID `deepseek-v4.1-flash`; OpenCode config ID
  `opencode-go/deepseek-v4.1-flash`; availability
  `account/adapter/runtime-check required`; source
  <https://opencode.ai/docs/go/> and
  <https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/deepseek-v4.1-flash.toml>;
  last verified `2026-09-13`.

##### Effort checklist (select one for this model)

- [ ] `default` (TUI label: **Default**; sends no explicit variant)
- [ ] `low`
- [ ] `high`
- [x] `max`

OpenCode Go's provider metadata declares `low`, `high` and `max` variants for
this model. OpenCode v1.18.30's TUI adds a synthetic `Default` choice; selecting
it stores no explicit variant and is not a fourth provider effort. Do not claim
that it equals the model-native default: record the no-override request and the
effective server/provider behavior separately before dispatch. The upstream
model card's continuous native control does not override the provider-effective
OpenCode Go variant contract.

#### `opencode-go-kimi-k3`

- [ ] **Model** `opencode-go-kimi-k3` - provider `opencode-go`;
  transport `opencode-cli`; model ID `kimi-k3`; OpenCode config ID
  `opencode-go/kimi-k3`; availability `account/adapter/runtime-check
  required`; source <https://opencode.ai/docs/go/> and
  <https://huggingface.co/moonshotai/Kimi-K3/blob/main/README.md>; last
  verified `2026-09-13`.

##### Effort checklist (select one for this model)

- [ ] `max`

The current OpenCode Go metadata and CLI expose only `max` for Kimi K3. The
model card documents `low`, `high` and `max`, but those native choices are not
selectable through this Go adapter unless a later catalog/runtime check proves
otherwise.

#### `opencode-go-glm-5.2`

- [ ] **Model** `opencode-go-glm-5.2` - provider `opencode-go`;
  transport `opencode-cli`; model ID `glm-5.2`; OpenCode config ID
  `opencode-go/glm-5.2`; availability `account/adapter/runtime-check
  required`; source <https://opencode.ai/docs/go/>,
  <https://docs.z.ai/guides/llm/glm-5.2>, and
  <https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/provider/transform.ts>;
  last verified `2026-09-13`.

##### Effort checklist (select one for this model)

- [ ] `high`
- [ ] `max`

Z.ai documents additional compatibility labels for GLM 5.2, but the installed
OpenCode v1.18.30 openai-compatible transform exposes `high` and `max` for this
model. Do not add or silently map another label until the effective Go adapter
proves it.

#### `opencode-go-glm-5.3`

- [ ] **Model** `opencode-go-glm-5.3` - provider `opencode-go`;
  transport `opencode-cli`; model ID `glm-5.3`; OpenCode config ID
  `opencode-go/glm-5.3`; availability `account/adapter/runtime-check
  required`; source <https://opencode.ai/docs/go/>,
  <https://docs.z.ai/guides/llm/glm-5.3>, and
  <https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/provider/transform.ts>;
  last verified `2026-09-13`.

##### Effort checklist (select one for this model)

- [ ] `low`
- [ ] `high`
- [ ] `max`

The current OpenCode Go metadata and CLI expose exactly `low`, `high` and `max`
for GLM 5.3. The v1.18.30 generic OpenAI-compatible transform does not add a
`medium` variant for this model; BALE must still prove the effective value at
runtime and must not silently substitute another label.

#### `opencode-go-deepseek-v4-pro`

- [ ] **Model** `opencode-go-deepseek-v4-pro` - provider `opencode-go`;
  transport `opencode-cli`; model ID `deepseek-v4-pro`; OpenCode config ID
  `opencode-go/deepseek-v4-pro`; availability `account/adapter/runtime-check
  required`; source <https://opencode.ai/docs/go/>,
  <https://api-docs.deepseek.com/guides/thinking_mode/>, and
  <https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/provider/transform.ts>;
  last verified `2026-09-13`.

##### Effort checklist (select one for this model)

- [ ] `high`
- [ ] `max`

The current OpenCode Go metadata and CLI expose exactly `high` and `max` for
DeepSeek V4 Pro. DeepSeek's native/model-card `low` choice is not selectable
through this Go adapter; compatibility labels such as `medium` or `xhigh` are
not additional checkboxes.

## User-added model template

Copy this block when the User wants a model not yet listed. Replace every
placeholder with source-backed values; do not leave generic effort or Fast
options that the provider has not documented.

#### `<provider>-<model-profile-id>`

- [ ] **Model** `<provider>-<model-profile-id>` - provider `<provider>`;
  transport `<herdr-launch-kind or adapter>`; model ID `<exact-model-id>`;
  availability `<account/runtime evidence>`; source `<URL>`; last verified
  `<YYYY-MM-DD>`.

##### Effort checklist (replace with supported values; select one)

- [ ] `<supported-effort-1>`
- [ ] `<supported-effort-2>`

##### Fast mode checklist (include only when the source documents Fast mode)

- [ ] `fast`
- [ ] `standard`

## Resolved worker evidence

BALE records the selected model and only the scoped choices nested under that
model in the Herdr attempt's configuration evidence:

- Model: `<checked model entry>` -> provider `<provider>`, transport
  `<transport>`, model ID `<exact-value>`
- Effort: `<checked scoped effort entry>` -> effective value
  `<observed-value>`, or `not supported/not applicable`
- Fast mode: `<checked scoped Fast entry>` -> effective value
  `<observed-value>`, or `not available; standard only`
- Permission: `<provider-native full-access mode>` and approval policy
  `<observed-value>`
- Capabilities: `<redacted built-in/plugin/MCP inventory>` with authentication
  state and any unavailable capability recorded
- Adapter/runtime proof: `<command or native output and timestamp>`

Do not pass an Antigravity or Claude model ID to a Codex launch.

## Sources and freshness

Catalog snapshot: 2026-09-13. Re-check availability, exact IDs, account
entitlements, and Herdr adapter support before selecting a profile. Research
sources:

- [OpenAI model catalog](https://developers.openai.com/api/docs/models)
- [Codex permissions](https://learn.chatgpt.com/docs/permissions)
- [Codex sandboxing](https://learn.chatgpt.com/docs/sandboxing)
- [Codex agent approvals and security](https://learn.chatgpt.com/docs/agent-approvals-security)
- [Codex MCP configuration](https://learn.chatgpt.com/docs/extend/mcp)
- [Codex plugins](https://learn.chatgpt.com/docs/plugins)
- [GPT-6 Astra](https://developers.openai.com/api/docs/models/gpt-6-astra)
- [GPT-5.6 Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol)
- [GPT-5.6 Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra)
- [GPT-5.6 Luna](https://developers.openai.com/api/docs/models/gpt-5.6-luna)
- [GPT-5.5](https://developers.openai.com/api/docs/models/gpt-5.5)
- [Codex speed/Fast mode](https://learn.chatgpt.com/docs/agent-configuration/speed)
- [Antigravity model selector](https://antigravity.google/docs/models)
- [Antigravity headless CLI](https://antigravity.google/docs/cli/headless/)
- [Antigravity permissions](https://antigravity.google/docs/cli/permissions/)
- [Antigravity sandbox](https://antigravity.google/docs/cli/sandbox/)
- [Antigravity MCP](https://antigravity.google/docs/cli/mcp/)
- [Claude Code CLI](https://code.claude.com/docs/en/cli-usage)
- [Claude Code permissions](https://code.claude.com/docs/en/permissions)
- [OpenCode Go](https://opencode.ai/go)
- [OpenCode Go documentation](https://opencode.ai/docs/go/)
- [OpenCode Go model endpoint](https://opencode.ai/zen/go/v1/models)
- [OpenCode CLI and run variants](https://dev.opencode.ai/docs/cli/)
- [OpenCode TUI command and `--auto` (v1.18.30)](https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/cli/cmd/tui.ts)
- [OpenCode model configuration](https://opencode.ai/docs/models/)
- [OpenCode Go DeepSeek V4.1 Flash metadata](https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/deepseek-v4.1-flash.toml)
- [OpenCode Go Kimi K3 metadata](https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/kimi-k3.toml)
- [OpenCode Go GLM 5.2 metadata](https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/glm-5.2.toml)
- [OpenCode Go GLM 5.3 metadata](https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/glm-5.3.toml)
- [OpenCode Go DeepSeek V4 Pro metadata](https://raw.githubusercontent.com/anomalyco/models.dev/dev/providers/opencode-go/models/deepseek-v4-pro.toml)
- [OpenCode TUI variant selector (v1.18.30)](https://github.com/anomalyco/opencode/blob/v1.18.30/packages/tui/src/component/dialog-variant.tsx)
- [OpenCode variant resolution (v1.18.30)](https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/acp/config-option.ts)
- [DeepSeek V4.1 Flash model card](https://huggingface.co/deepseek-ai/DeepSeek-V4.1-Flash/blob/main/README.md)
- [Kimi K3 model card](https://huggingface.co/moonshotai/Kimi-K3/blob/main/README.md)
- [Z.ai GLM-5.2](https://docs.z.ai/guides/llm/glm-5.2)
- [Z.ai GLM-5.3](https://docs.z.ai/guides/llm/glm-5.3)
- [Z.ai thinking controls](https://docs.z.ai/guides/capabilities/thinking)
- [DeepSeek thinking mode](https://api-docs.deepseek.com/guides/thinking_mode/)
- [OpenCode provider variants (v1.18.30)](https://github.com/anomalyco/opencode/blob/v1.18.30/packages/opencode/src/provider/transform.ts)
- [Anthropic effort controls](https://platform.claude.com/docs/en/build-with-claude/effort)
- [Anthropic Fast mode](https://platform.claude.com/docs/en/build-with-claude/fast-mode)
- [Anthropic model overview](https://platform.claude.com/docs/en/models/overview)
- [Anthropic model status and deprecations](https://docs.anthropic.com/en/docs/about-claude/model-deprecations)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)

When a source, account entitlement, Herdr adapter, or runtime output disagrees
with this file, runtime evidence wins for dispatchability and BALE pauses for a
User decision rather than rewriting the selected configuration silently.
