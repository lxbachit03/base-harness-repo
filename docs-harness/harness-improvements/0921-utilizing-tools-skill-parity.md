# Harness Improvement Resource

ID: #027_IMPROVE_HARNESS_0921
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Converge the utilizing-tools skills on the routing pattern
CREATED: 2026-09-21
STATUS: completed
REFERENCES:
- AGENTS.md
- docs-harness/INDEX.md
- docs-harness/harness-improvements/README.md
- docs-harness/harness-improvements/0921-utilizing-tools-claude-capability-catalog.md
- docs-harness/templates/harness-improvement.md
- .agents/skills/utilizing-tools-agy/SKILL.md
- .agents/skills/utilizing-tools-codex/SKILL.md
- .agents/skills/utilizing-tools-opencode/SKILL.md
- .agents/skills/utilizing-tools-claude/SKILL.md
- .agents/skills/writing-for-agents/SKILL.md
- docs/tools/antigravity/README.md
- docs/tools/codex/README.md
- .gitignore

## Objective

Rewrite `utilizing-tools-agy` and `utilizing-tools-codex` so all four
`utilizing-tools-*` skills carry the same contract: a task-to-capability routing
table plus discovery rules, instead of an inventory of the runtime's tools. The
enumerations stay in the team-facing catalogs under `docs/tools/`.

## Purposes

- [x] Stop skills from caching a list the runtime already exposes, so the agent
  spends its context on routing decisions rather than on a copy of its own tool
  schemas.
- [x] Remove the contradiction where a skill both forbids inventing a tool and
  ships a frozen list that goes stale into one.
- [x] Give the User one predictable process across all four runtimes, so
  switching runtime does not change how work is declared and verified.
- [x] Keep every capability fact discoverable by leaving the enumerations in the
  `docs/tools/` catalogs, which are dated and evidence-classed for humans.

## Current State

Baseline: repository `D:/repos/base-harness-repo`, branch `main`, revision
`82ecc93`, worktree clean.

The four skills disagree on shape:

| Skill | Shape | Lines |
| :--- | :--- | :--- |
| `utilizing-tools-agy` | Exhaustive inventory of every tool and plugin skill | 114 |
| `utilizing-tools-codex` | Inventory grouped by tool family | 173 |
| `utilizing-tools-opencode` | Task-to-capability table plus discovery rules | 147 |
| `utilizing-tools-claude` | Task-to-capability table plus discovery rules | 177 |

Both inventory skills also state that the session is the runtime authority and
that inventing a tool name is an anti-pattern, while shipping the frozen list
that invites exactly that.

Evidence that the enumerations are already preserved elsewhere: every backticked
identifier in `utilizing-tools-agy` appears in `docs/tools/antigravity/README.md`
(34 of 35; the miss is the placeholder `plugin:skill`), and all 32 identifiers in
`utilizing-tools-codex` appear in `docs/tools/codex/README.md`. Removing the
inventories therefore deletes no capability fact from the repository.

Authority: the User reviewed the argument that the inventory pattern is the older
one and asked for the two older skills to be converged on the newer pattern.

## Proposed Improvement

Rewrite both skills to the shared contract: purpose and runtime authority, a
mandatory declaration table, three phases with completion criteria, a loading
model table, permission and connection boundaries, and anti-patterns. Replace
each inventory with a task-to-capability table and discovery rules for that
runtime. Preserve the non-obvious runtime mechanics each skill already carries,
because the environment does not confess them. Mirror both into `.claude/skills/`.

## Scope

In scope:

- `.agents/skills/utilizing-tools-agy/SKILL.md` and its `.claude/` mirror.
- `.agents/skills/utilizing-tools-codex/SKILL.md` and its `.claude/` mirror.
- This record, its INDEX entry, and its `.gitignore` allowlist line.

Out of scope:

- `utilizing-tools-opencode` and `utilizing-tools-claude`, which already hold the
  target shape.
- The `docs/tools/` catalogs, which keep the enumerations unchanged.
- Adding a pointer from any skill to its catalog. A dated snapshot would compete
  with the live session the skills already declare as the authority.
- Any claim about Antigravity or Codex capabilities beyond what the existing
  skills and catalogs already record; neither runtime is installed here.

## Progress

2026-09-21: record created before intervention edits. Catalog coverage verified
first, so the inventories can be removed without losing evidence.

Rewrote both skills to the shared contract, mirrored them, indexed this record,
and allowlisted it. Structural self-review results:

| Skill | Lines before → after | Sections | Completion criteria | Tables | Mirror |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `utilizing-tools-agy` | 113 → 139 | 5 | 2 | 3 | identical |
| `utilizing-tools-codex` | 172 → 149 | 5 | 2 | 3 | identical |
| `utilizing-tools-opencode` | 147 (unchanged) | 5 | 2 | 3 | identical |
| `utilizing-tools-claude` | 177 (unchanged) | 6 | 2 | 3 | identical |

`utilizing-tools-claude` keeps one extra section, `Delegation In This
Repository`, because the Herdr routing rule applies to the runtime this
repository is driven from. The other three need no equivalent.

Antigravity grew because it gained the loading-model table, permission and
connection boundaries, and completion criteria it never had. Codex shrank
because its inventory moved out while its mechanics stayed.

Fact retention: 12 identifiers were removed from the Antigravity skill and 22
from the Codex skill; every one of them is still present in its catalog, so
nothing was deleted from the repository. Spot checks confirm the load-bearing
Codex guidance survived — idempotency keys, `.openai/hosting.json` project
identity, opaque identifiers, Document Control ordering, freshness, subagent
review, autonomous-goal restraint, and the scope boundary.

Every relative link in the changed files resolves except the two pre-existing
`#012` links in INDEX, which remain out of scope. All 13 REFERENCES paths exist.

2026-09-21, first replay attempt — **invalid, discarded as evidence**. A fresh
subagent was asked one Codex-shaped and one Antigravity-shaped task. It invoked
`utilizing-tools-codex` and `utilizing-tools-agy` respectively and printed a
declaration table for each, which looks like a pass. It was not one: the answers
quoted `Always prefer precise tools`, the `🛠️` emoji heading, and
`### Selected Codex Tools & MCPs`, and all three strings exist only in the
pre-rewrite versions at `HEAD`, not in the rewritten files on disk.

Conclusion: a subagent in an already-running session can be served the skill
body cached at session start, so editing an existing skill and replaying it in
the same session proves nothing about the edit. A newly created skill directory
is picked up mid-session — improvement `#026` was exercised that way — but a
modified body is not. Verify which version a replay actually loaded by asking it
to quote a string that differs between the old and new text.

## Validation

Targeted agent self-review, no repository validator script:

- Frontmatter `name` still matches each skill directory name.
- Each `.agents` skill and its `.claude` mirror compare identical.
- Every identifier removed from a skill is still present in its catalog.
- All four skills carry the same section contract and completion criteria.
- Markdown tables have consistent column counts and code fences are balanced.
- `git check-ignore` confirms the new record is tracked.

## Risks

- Fact loss when deleting an inventory. Mitigation: catalog coverage was verified
  before the rewrite and is re-verified after it.
- Neither Antigravity nor Codex runs on this machine, so the rewrite cannot be
  replayed in its own runtime. Mitigation (suggestion until authorized): treat
  structural parity and catalog coverage as the evidence here, and record the
  runtime replay as unattempted rather than implying it passed.

## Decision and Result

Decision: **keep**.

Second replay (2026-09-21, fresh subagent, read-only, two runtime-shaped tasks,
skill names withheld from the task text). This run was required to quote strings
that differ between the old and new files, so the loaded version is provable:

| Quoted string | In rewrite | In `HEAD` | Discriminating |
| :--- | :--- | :--- | :--- |
| `### Selected Codex Capabilities` | yes | no | yes |
| `### Selected AGY Capabilities` | yes | no | yes |
| `- Dumping a whole large file when a line range or \`grep_search\` answers the task.` | yes | no | yes |
| `- Using web search for a task that local files or a native tool can answer.` | yes | yes | no |

Three of four strings exist only in the rewritten files, so this replay
exercised the new bodies rather than the cached ones.

Observed outcome:

- **Routing held after the description rewrite**: the Codex-shaped task retrieved
  `utilizing-tools-codex` and the Antigravity-shaped task retrieved
  `utilizing-tools-agy`, each invoked before any other tool call.
- **The new contract was followed**: both answers opened with the renamed
  declaration table and stayed within it.
- **The replacement structure carried the work**: both answers selected
  capabilities by citing the new task-to-capability rows — `Edit repository
  files`, `Inspect files, search, run commands`, `Search content across files`,
  `Read a known file` — none of which existed before this rewrite. The routing
  table did the job the deleted inventory used to be credited with.
- **Proportionate selection**: each answer declared two capabilities, and the
  Codex answer cited the anti-pattern against listing every available capability
  as its reason for not adding more.
- **Scope respected**: read-only throughout; no file was created, modified, or
  deleted.

Observed limits:

- The replay ran inside Claude Code, not inside Codex or Antigravity. It proves
  retrieval, contract compliance, and that the routing table is usable; it proves
  nothing about whether the named capabilities behave as described in their own
  runtimes. That runtime replay is **unattempted**, not passed, because neither
  runtime is installed here.
- The first replay attempt in this same session was invalid, and its failure mode
  is recorded above as the reason this one demanded version-discriminating
  quotes. Treat any same-session replay of an edited skill as suspect until the
  loaded version is proven.
