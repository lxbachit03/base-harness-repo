# Harness Improvement Resource

ID: #076_IMPROVE_HARNESS_1120
TAG: [IMPROVE_HARNESS]
PRIORITY: [MEDIUM]
TITLE: Add a claude-instructions folder that Claude sessions read at session start
CREATED: 2026-11-20
STATUS: active
REFERENCES:
- docs-harness/claude-instructions/README.md
- docs-harness/INDEX.md
- docs-harness/layers/README.md
- docs-harness/README.md
- docs/tools/claude/README.md

## Objective

`docs-harness/claude-instructions/` exists, and `docs-harness/INDEX.md` has a
session read its `README.md` and every Markdown file under it when the session runs
a Claude model or a Claude platform. The folder holds instructions written for
working with Claude. Other sessions skip it.

## Purposes

- [x] Give Claude-specific instructions one home that a Claude session reads without
  being told, as the User asked on 2026-11-20.
- [ ] Candidate, awaiting the User: keep the session-start cost for a Claude session
  to the folder README until an instruction file is added, and zero for any other
  model.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `14235a6` (one commit
ahead of `origin/main`), working tree clean. `harness-check` clean at 75 IDs.

Request: the User wrote, in Vietnamese, to create a folder `claude-instructions` so
that when they use Claude models or Claude-related platforms, the Harness reads it
automatically, and that it holds instructions designed for working with Claude. The
User named no instruction to put in it.

Today Claude-specific material is scattered: the catalog `docs/tools/claude/README.md`,
the `utilizing-tools-claude` skill, and the Claude-specific add-ons that
`docs-harness/layers/` can hold per exact model identifier. `layers/README.md` records
a User decision of 2026-09-26 that no family-wide tier exists inside `layers/`.

## Proposed Improvement

1. Create `docs-harness/claude-instructions/README.md`: purpose, who loads it and
   when, how to add an instruction file, and pointers to the existing Claude material.
   No instruction file is added, because the User named none.
2. `INDEX.md`: one session-start sentence, a Folder Tree line and a routing section.
3. `docs-harness/README.md`: one line in the folder guide.
4. `layers/README.md`: one line saying provider-wide Claude instructions live in
   `claude-instructions/`, so the 2026-09-26 decision still holds inside `layers/`.
5. List this record in `docs-harness/harness-improvements/README.md`.

## Scope

May change: the files above. Unchanged: the add-ons in `layers/`, task authority and
session role (`#009`, `#074`), the `utilizing-tools-claude` skill and the catalog.
Instruction files under the new folder are no canonical resources, so they get no ID.
Nothing is committed or pushed.

## Progress

- 2026-11-20: Record opened before the edits; baseline taken as above.
- 2026-11-20: Created `claude-instructions/README.md` (no instruction file); added the
  session-start sentence, Folder Tree line and routing section to `INDEX.md`, a line to
  `docs-harness/README.md` and to `layers/README.md`; listed this record. Nothing is
  committed or pushed.

## Validation

Results, 2026-11-20:
- `harness-check` full: clean (76 unique IDs #001-#076, 73 INDEX links, 29 folders match
  the Folder Tree, 22 folders with README, 1028 links in 171 Markdown files).
- `git diff --stat`: 4 tracked files changed (25 insertions, 1 deletion), plus the new
  README and this record.

Unattempted: a fresh Claude session that reads the folder without being told, and a
non-Claude session that skips it (see Decision).

## Risks

- "A Claude model or platform" is the agent's judgment of its own model ID and host.
  Mitigation: the README names the signals (a model ID containing `claude`; Claude
  Code, the Claude desktop app, claude.ai, the Claude Agent SDK) and asks nothing of
  the User.
- A model such as Gemini inside a Claude-hosted tool is ambiguous. Mitigation: the
  rule is "model or platform", so a Claude platform reads it whatever the model.
- The folder overlaps `layers/` in purpose. Mitigation: the line in `layers/README.md`
  separates them: `layers/` per exact model and effort, this folder per provider.
- Every instruction file added later loads in every Claude session. Mitigation: the
  README asks for one topic per file and short files.

## Decision and Result

Decision: pending fresh rerun. The folder and its route are the implementation; that a
Claude session reaches the README from INDEX is unverified, and the folder holds no
instruction yet.

Replay task: in a new Claude session, ask which docs-harness folders it read at start;
expect `claude-instructions/README.md` among them. Owner: the next primary session or
the User. Cost: about 100k tokens, no build; it leaves the non-Claude skip uncovered.
