---
name: utilizing-tools-agy
description: Select and execute optimal combinations of Antigravity (AGY) built-in tools, MCP servers, and specialized skills for any task. Use when asked to leverage AGY tools/MCPs effectively, with mandatory tool declaration table and seamless execution.
---

# Utilizing Antigravity (AGY) Tools, MCPs & Skills

Select, declare, and execute the most effective combination of Google Antigravity (AGY) built-in core tools, MCP plugins, and specialized skills for any given task.

## Mandatory Response Contract

Whenever this skill is triggered, you **MUST** begin the response by declaring your selected tools/MCPs/skills in a concise Markdown table, followed immediately by seamless execution:

```markdown
### 🛠️ Selected Tools & MCPs
| Tool / MCP / Skill Name | Purpose in this Task | Target Scope |
| :--- | :--- | :--- |
| `<tool_name_or_plugin:skill>` | `<Concise rationale for selection>` | `<Target files, endpoints, or system modules>` |
```

---

## 3-Phase Execution Workflow

```text
1. Task Classification & Tool/Skill Selection
   ↓
2. Mandatory Tool Declaration Table
   ↓
3. Seamless Execution & Proof Verification
```

### Phase 1: Task Classification & Tool/Skill Selection

Analyze the User prompt and match the task domain with the optimal Antigravity capabilities:

#### 1. Antigravity Built-in Core Tools
- **Filesystem & Code**:
  - `view_file`: Read specific lines or file contents with line-number precision.
  - `replace_file_content`: Make contiguous, verified edits to existing files.
  - `write_to_file`: Create new files or persist structured User Artifacts.
  - `grep_search`: Scan codebase for exact patterns or regex matches across directories.
  - `list_dir`: Inspect directory structure and file sizes.
- **Terminal & Execution Lifecycle**:
  - `run_command`: Run shell/PowerShell commands (tests, builds, linter, git).
  - `manage_task`: Manage long-running background tasks (`list`, `status`, `send_input`, `kill`).
  - `schedule`: Set one-shot timers or cron triggers for deferred wakeup (never use `sleep`).
- **Multi-Agent Orchestration**:
  - `invoke_subagent` / `define_subagent`: Delegate token-heavy surveys, broad searches, or isolated tasks to background subagents.
  - `manage_subagents` / `send_message`: Coordinate active subagents.
- **Web & Visual Synthesis**:
  - `search_web`: Search live technical documentation and current library specifications.
  - `read_url_content`: Fetch public web documentation as clean Markdown.
  - `generate_image`: Create UI mockups, visual assets, or diagrams.
- **User Interaction**:
  - `ask_question`: Display interactive modal for clarifying ambiguous requirements or selecting design choices.

#### 2. Antigravity MCP Plugins & Built-in Skills (`plugin:skill`)
- **`chrome-devtools-plugin` (Chrome DevTools MCP)**:
  - `chrome-devtools-plugin:chrome-devtools`: Browser automation, navigation, element interaction, screenshot capture.
  - `chrome-devtools-plugin:debug-optimize-lcp`: Diagnose and optimize Largest Contentful Paint & Core Web Vitals.
  - `chrome-devtools-plugin:memory-leak-debugging`: Diagnose and fix JS/Node.js memory leaks and heap snapshots.
  - `chrome-devtools-plugin:a11y-debugging`: Audit and repair Web Accessibility (a11y), contrast, and ARIA labels.
  - `chrome-devtools-plugin:troubleshooting`: Fix MCP connection and browser target issues.
- **`modern-web-guidance-plugin`**:
  - `modern-web-guidance-plugin:chrome-extensions`: Build and publish Chrome Extensions Manifest V3.
  - `modern-web-guidance-plugin:modern-web-guidance`: Modern HTML5/CSS, View Transitions, modern web APIs.
- **`builtin` Packages**:
  - `builtin:antigravity-guide`: Reference guide for Antigravity CLI, IDE, keybindings, SDK, slash commands.
  - `builtin:agy-customizations`: Guide to customizing Rules, Plugins, Hooks, and MCP servers.
  - `google-antigravity-sdk:google-antigravity-sdk`: Design and orchestrate autonomous agents.

#### 3. Repository Governance & Workflow Skills
- `goal-griller`: Clarify ambiguous intent into verifiable goals (`/goal`).
- `prompt-leverage`: Upgrade raw prompts into execution-ready contracts.
- `sequence-execution-plan`: Build dependency-aware execution plans.
- `improve-harness`: Run authorized improvements to Harness repo (`$improve-harness`).
- `writing-for-agents`: Author clean, token-efficient instructions for AI agents.
- `onboarding`: Map brownfield data flows into isolated workspaces (`docs-harness/onboarding/<flow-name>/`).
- `onboard-repository`: Audit and map unfamiliar codebases to generate evidence bundles.
- `xia`: Conduct deep technical research before coding.

**Completion Criterion**: Exact set of tools, plugins, and target scopes determined.

---

### Phase 2: Mandatory Tool Declaration

Render the tool declaration table directly at the top of your response before calling the tools.

**Completion Criterion**: Markdown table printed with non-empty `Tool / MCP / Skill Name`, `Purpose in this Task`, and `Target Scope` columns.

---

### Phase 3: Seamless Execution & Verification

1. Immediately execute the planned tool actions without pausing or asking for redundant confirmation.
2. Observe tool outputs, handle error cases, and verify results with concrete evidence.
3. Report the final outcome, important changes, and validation proof.

**Completion Criterion**: Task completed with observable evidence from executed tools.

---

## Anti-Patterns & Guardrails

- **Always render the Tool Declaration Table**: Never execute tools silently without declaring them upfront.
- **Execute seamlessly after the table**: Never stop after printing the table; proceed straight into execution.
- **Always prefer precise tools**: Use `grep_search` and `view_file` with line slices instead of dumping entire large files.
- **Never guess facts**: Use `view_file` or `run_command` to inspect real code instead of hallucinating implementation details.
