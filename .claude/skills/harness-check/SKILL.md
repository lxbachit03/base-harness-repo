---
name: harness-check
description: Read-only Harness status check that runs the drift script and reports each finding with a proposal; compares docs/raw-requirements when the User asks whether the repository meets them.
disable-model-invocation: true
---

# Harness Check

A report-only status check of the Harness. The script judges structure and you
propose a response to every finding; the requirement comparison runs only
when the User asks for it.

## 1. Run the script

From the repository root:

```text
python -I .agents/skills/harness-check/scripts/harness_check.py
```

Exit 0 is clean, 1 is drift, 2 is an error to report verbatim. Each row names
its check, its result and the owner of the rule it enforces; `info` rows give
context and are not drift. `--quick` runs only INDEX's session-start
alignment check.

Without Python 3, run the checks in the table below by hand and report the
script run as unattempted.

Done when you hold the RESULT line and every row.

## 2. Compare the raw requirements when asked

Run this step only when the User asks whether the repository meets their
requirements; a plain status request skips it. Run the script with
`--requirements` to print `docs/raw-requirements/` after its rows, then apply
[its README](../../../docs/raw-requirements/README.md): for each node whose
text states something the repository must have or do, find the
implementation evidence. Script rows, the session-start context and targeted
lookups supply most of it.

Done when every such node is backed by evidence or listed as a mismatch with
its file, node title and quoted text.

## 3. Report

Lead with the RESULT line. Then list each drift row, and each requirement
mismatch when step 2 ran, with a concrete proposal, as the
[risk and proposal constraint](../../../docs-harness/harness-constraints/0812-risk-proposal-suggestion-cross-link.md)
requires; summarize the passing checks in one line; and name every
unattempted check, including a requirement comparison step 2 skipped.
Proposals wait for the User's decision, and
`docs/raw-requirements/` stays exactly as the User wrote it.

Done when every finding carries a proposal and every gap in proof is named.

## Checks

| Check | Verifies | Rule owner |
| :--- | :--- | :--- |
| `routing` | Every `docs-harness/` file with an `ID:` line is linked from INDEX, directly or through a folder README.md that INDEX links (templates excluded) | INDEX.md > Session retrieval |
| `index-links` | Every local INDEX link and anchor resolves | INDEX.md > Session retrieval |
| `folder-tree` | Folders on disk and in INDEX's Folder Tree match both ways | INDEX.md > Session retrieval |
| `ids` | IDs are unique, sequence numbers unreused, and the name prefix and CREATED match the ID date | templates/README.md > Immutable identity |
| `metadata` | Required fields exist, PRIORITY is valid, and STATUS fits the plans/ lifecycle folder | templates/README.md > Common metadata |
| `index-entries` | Each ID entry in INDEX and in the folder READMEs it links matches its file's ID and PRIORITY, once per route | INDEX.md > Resource Routing Rules |
| `links` | Local links and anchors in Markdown resolve, with exact letter case (`.claude/skills` and `docs-harness/templates` skipped) | templates/README.md > Routing and proof |
| `skill-mirror` | `.agents/skills` and `.claude/skills` are byte-identical | docs/tools/claude/README.md > 7.1 |
| `folder-readmes` | Every `docs-harness/` folder outside template scaffolds has README.md | docs/raw-requirements/skills/init-harness-repo.json > Yêu cầu 1.6 |
| `requirements` | With `--requirements`, every `docs/raw-requirements/` JSON file parses; its text is printed for step 2 | docs/raw-requirements/README.md > JSON format |

The `--quick` mode runs the first three rows.
