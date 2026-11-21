# Ubiquitous language: shared terms for the User, agents and the Harness repo

Lookup, not a start-up read. Open it when the User's word, abbreviation or short reply is not
defined in a document you already loaded, or before you write a term to the User that this
file maps. Each row gives the meaning and the owner; the owner file stays the authority for
behavior. A term the User defines in a prompt wins over this file for that task.

## Herdr and agents

| Term (also written) | Meaning | Owner |
| :--- | :--- | :--- |
| HDA (HAD, Herdr App Desktop, Herdr Desktop App) | The Herdr desktop app, driven with `herdr-app` | [HERDR-APP.md](HERDR-APP.md) |
| Herdr TUI | The terminal app `herdr` and its panes; a different program from the HDA | [HERDR-TUI.md](HERDR-TUI.md) |
| "Herdr" alone | Ambiguous: ask whether the TUI or the HDA is meant | [INDEX.md](INDEX.md) |
| `hc` | herdr-core command line: runs every terminal and agent; the HDA is one client of it | [HERDR-APP.md](HERDR-APP.md) |
| space, tab, terminal (`t5`) | HDA units: a sidebar space holds tabs, a tab holds a terminal with an address | [HERDR-APP.md](HERDR-APP.md) |
| pane | A generic word for both programs, not tied to one: it means what the Herdr the User is currently asking for calls a unit on screen. In the HDA that is a space or terminal ("the `agy-` panes" = the spaces named `agy-...`); in the TUI it is a TUI pane. When the User has not said which, ask as for "Herdr" alone | [HERDR-APP.md](HERDR-APP.md), [HERDR-TUI.md](HERDR-TUI.md) |
| agy, AGY | Antigravity CLI (`agy`), Google's agent CLI | [docs/tools/antigravity/README.md](../docs/tools/antigravity/README.md) |
| hydrogen, neon, argon | Gemini 4 model families, ID `gemini-4-<family>-<effort>` (low, medium, high or xhigh) | [HERDR-APP.md](HERDR-APP.md) section 3 |
| Orchestrator (Neon), Orchestrator (Argon) | `gemini-pro-orchestrator-neon`, `gemini-pro-orchestrator-g1-pro` (Plan Mode sessions) | [HERDR-APP.md](HERDR-APP.md) section 3 |
| worker, coordinator | The agent that does a delegated task, and the session that briefed it and reviews it; a delegated worker starts no agents | [session role](harness-constraints/1120-session-role-and-judgment.md) |
| brief | The message that carries a task, limits and report shape to a worker | [HERDR-APP.md](HERDR-APP.md) section 4 |
| blocked | An `agy` status: the worker waits at a dialog; only the User answers it | [HERDR-APP.md](HERDR-APP.md) section 4 |
| Load / Skip (Harness context) | Whether the worker reads `AGENTS.md` and the INDEX first | [HERDR-APP.md](HERDR-APP.md) section 3 |
| Skip / Ask (permission flag) | Whether workers start with `--dangerously-skip-permissions` | [HERDR-APP.md](HERDR-APP.md) section 3 |

## Harness structure

| Term | Meaning | Owner |
| :--- | :--- | :--- |
| Harness, Harness repo | This repository and its context workspace `docs-harness/` | [README.md](README.md) |
| INDEX | `docs-harness/INDEX.md`, the routing hub read at every session start | [INDEX.md](INDEX.md) |
| ID `#NNN_TAG_MMDD` | A resource's global number, its tag and the creation month and day | [templates/README.md](templates/README.md) |
| record | One improvement file under `harness-improvements/` (baseline, progress, validation, decision) | [harness-improvements/README.md](harness-improvements/README.md) |
| constraint, project constraint | A rule that binds work; project constraints are the User's rules for the project, read at every start | [harness-constraints/README.md](harness-constraints/README.md), [project-constraints/README.md](project-constraints/README.md) |
| plan, ticket, domain | Durable execution memory, a unit of requested work, confirmed project knowledge | [README.md](README.md) |
| layer | A model-specific add-on prompt loaded at session start | [layers/README.md](layers/README.md) |
| persona | The conversation style the User selected; it never touches files | [PERSONA.md](PERSONA.md) |
| raw requirements | `docs/raw-requirements/`, the User's own words; agents propose changes, never edit | [INDEX.md](INDEX.md) |
| skill mirror | `.agents/skills/` and `.claude/skills/` hold identical skill copies | [harness-check](../.agents/skills/harness-check/SKILL.md) |
| `harness-check` | The read-only alignment check run at session start | [harness-check](../.agents/skills/harness-check/SKILL.md) |
| `improve-harness` | The skill that applies a requested Harness change and records it | [improve-harness](../.agents/skills/improve-harness/SKILL.md) |
| Jev | TypeSafe's System One model, called through the repository's helper scripts | [JEV-AI.md](JEV-AI.md) |

## The User's short replies and words

| Words | Read as | Limit |
| :--- | :--- | :--- |
| "Chạy ngay" (run now) | Go ahead with the step just proposed | That step only; a plan never grants new authority ([task authority](harness-constraints/0822-user-authority-operation-gate.md)) |
| "Đã xử lý" (handled) | The User answered the worker's dialog; resume | Never answer a dialog for the User |
| "commit", "push" | Explicit authority for that action | Not for staging other work or a later push |
| "bảng công việc" (task board) | The task board pages `docs/tools/antigravity/board-NN-<style>.html` | Matches the Claude Artifact the User named |
| artifact | A Claude Artifact (a page hosted on claude.ai) or an `agy` artifact (a local file in `~/.gemini/antigravity-cli/brain/`); ask which when unclear | |

## Keeping it

- Add a term when the User names or defines a shorthand, through `improve-harness` with its
  record; give the owner and one line, and mark a guess `(unverified)`.
- A conflict between this file and an owner file goes to the owner; fix the row.
- Keep rows to what the repository or the User's words evidence.
