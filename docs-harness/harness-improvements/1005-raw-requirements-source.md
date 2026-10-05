# Harness Improvement Resource

ID: #047_IMPROVE_HARNESS_1005
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: User-owned raw requirements folder with an INDEX warning
CREATED: 2026-10-05
STATUS: completed
REFERENCES:
- docs/raw-requirements/README.md
- docs/README.md
- docs-harness/INDEX.md

## Objective

The User's raw requirements sit in `docs/raw-requirements/` as JSON trees and
serve as the single source of truth for both the User and the Harness. Agents
read them and propose changes; the User edits them. AGENTS.md is unchanged.

## Purposes

- [x] Give the User and agents one place to track the User's requirements.
- [x] Keep the User as the only editor of those requirements: agents propose,
  the User decides and edits.
- [x] Keep the rule portable: `docs-harness/` and AGENTS.md are carried to
  other repositories, so the rule lives in an INDEX warning section that applies
  only when the folder exists, plus the folder's own README.

## Current State

Baseline (2026-10-05): `main` at `b0620e7`. `docs/` held team documentation
only; the User's requirements existed only in conversation.

User decisions (2026-10-05):

| Question | Decision |
| --- | --- |
| Location | `docs/raw-requirements/` |
| Layout | One folder per group, one JSON file per item (`skills/improve-harness.json`, `layers/layers.json`, `jev-ai/jev-ai.json`, ...) |
| Node shape | Generic and verbatim: `{"title", "text", "children"}` |
| Rule placement | Not in AGENTS.md (it travels to other repositories); a warning section in INDEX plus the folder README |
| Editing | When the User accepts an agent's suggestion, the User edits the raw requirements directly |

## Proposed Improvement

- Create `docs/raw-requirements/README.md` with the warning, when to read, the
  layout and the node format.
- Transcribe the User's two pasted trees into six JSON files with a parser
  that splits by indentation and keeps the text unchanged.
- Add an INDEX warning section, conditional on the folder existing, and a
  `docs/README.md` entry.

## Scope

May change: `docs/raw-requirements/` (created on the User's request, content
from the User's paste), `docs/README.md`, `docs-harness/INDEX.md`, this record.

Unchanged: AGENTS.md; every skill, layer, hook and JEV-AI.md (requirement
mismatches are reported as suggestions, not fixed).

## Progress

- 2026-10-05: Created the folder README, the six JSON files and the INDEX
  warning section and route; added the `docs/README.md` entry.
- 2026-10-05: The first replay found three gaps: whether the exception
  covers renames and directions such as "make them match"; whether a fix or
  update task overrides the ban; and whether "the requirement wins" lets an
  agent change code. All three were clarified in the README and INDEX wording.

## Validation

- Native: each JSON file parses; the generator asserts that the standalone
  "Jev AI" paste equals the "Jev AI" subtree of the "Harness rules" paste;
  links resolve; the new ID is unique and routed; nothing is ignored by git.
- Fresh replay: a fresh read-only worker, asked to change a requirement and to
  align a skill with it, proposes the requirement change instead of editing
  the JSON.

## Risks

- The requirements and the implementation already differ in places. An agent
  may "fix" code to match a requirement the User has not re-confirmed.
  Mitigation: the README asks for a proposal naming the file and node, so
  each mismatch reaches the User first.

## Decision and Result

Decision: **keep**.

Native checks (2026-10-05):
- The generator's assertions passed: the tree splits into exactly the six
  planned files, and the standalone "Jev AI" paste equals the "Harness rules"
  subtree.
- All six JSON files parse as UTF-8 without a BOM, and every node has exactly
  `title`, `text` and `children` (56 nodes in total).
- No links are broken in the four touched Markdown files.
- There are no duplicate IDs, and every resource ID is routed in INDEX.
- `git check-ignore -v` matches only the `!*` re-include rule, and
  `git status` lists the new files as untracked.

Fresh replays (2026-10-05; native read-only workers following AGENTS.md and
INDEX):
- The first replay edited nothing and proposed the changes. It found the three
  gaps listed under Progress.
- After the revision, a second worker handled three cases correctly:
  - "Make them match": no edit; it proposes both options and asks.
  - An exact title change: it edits that one title only.
  - A compliance check: read-only; it reports mismatches as proposals.

Limits: open questions the replay raised are product decisions for the User,
not guidance gaps:
- which side the name mismatch should move to;
- how an "OPTINAL" requirement counts toward compliance;
- whether "Jev," in a prompt means calling TypeSafe or just addressing the
  agent.
