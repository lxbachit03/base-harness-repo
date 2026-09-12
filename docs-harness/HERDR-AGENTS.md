# Herdr worker configuration catalog

This file is BALE's user-editable model registry for Herdr workers. Read it
after `AGENTS.md` and `docs-harness/INDEX.md`, before every Herdr launch,
reassignment, or worker-model change. A checkbox is a user choice; it is not
proof that the current Herdr installation can launch that profile.

## Selection contract

1. Check exactly one **Model** checkbox in this catalog. The catalog starts
   with zero selections; BALE must not infer a model from list order or from a
   previous task.
2. After choosing a model, use only the **Effort** and **Fast mode** checklists
   nested under that model. Check exactly one effort value when that model has
   an effort checklist. When the section is explicitly omitted, the provider
   does not expose a selectable effort for that model and no effort checkbox is
   required. Check exactly one Fast value only when that model has a Fast mode
   checklist. When that section is omitted, Fast mode is not documented for the
   model and standard speed is the only permitted interpretation.
3. These choices are model-scoped, not global. Do not combine an effort or
   Fast value copied from another model section, and do not add an option that
   the model's source does not list.
4. Prove the effective model ID, effort (when applicable), speed/Fast state
   (when applicable), provider, transport, and permission/capability state in
   native runtime output before submission. The current repository runtime
   documents a Codex adapter; Antigravity and direct Claude entries remain
   catalog-only until a compatible Herdr adapter and permission mapping are
   demonstrated.
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
submission.

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
| `agy` | `--dangerously-skip-permissions`; keep terminal sandbox disabled when host-level access is intended | Antigravity headless `stream-json` `init.permission_mode` and `tools`; `agy plugin list`; `agy mcp list`; inspect `settings.json` deny/managed rules and `allowNonWorkspaceAccess` | Herdr kind exists locally, but no repository dispatcher/adapter proof |
| `claude` | `--dangerously-skip-permissions` (equivalent to `--permission-mode bypassPermissions`) | Claude `/permissions` or native startup output; `claude plugin list`; `claude mcp list`; inspect managed/project deny rules and authentication | Herdr kind is documented, but Claude CLI is not installed in the current runtime |

The Antigravity and Claude requests still do not override explicit deny rules,
managed policy, provider authentication, or an MCP server's own access policy.
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

Catalog snapshot: 2026-09-12. Re-check availability, exact IDs, account
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
- [Anthropic effort controls](https://platform.claude.com/docs/en/build-with-claude/effort)
- [Anthropic Fast mode](https://platform.claude.com/docs/en/build-with-claude/fast-mode)
- [Anthropic model overview](https://platform.claude.com/docs/en/models/overview)
- [Anthropic model status and deprecations](https://docs.anthropic.com/en/docs/about-claude/model-deprecations)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)

When a source, account entitlement, Herdr adapter, or runtime output disagrees
with this file, runtime evidence wins for dispatchability and BALE pauses for a
User decision rather than rewriting the selected configuration silently.
