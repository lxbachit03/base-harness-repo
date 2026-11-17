# Harness Improvement Resource

ID: #070_IMPROVE_HARNESS_1117
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Rename the asset-design-style skill to asset-design-systems
CREATED: 2026-11-17
STATUS: active
REFERENCES:
- .agents/skills/asset-design-systems/SKILL.md
- .claude/skills/asset-design-systems/SKILL.md
- .agents/skills/asset-design-systems-hallmark/SKILL.md
- docs/tools/claude/README.md
- docs-harness/harness-improvements/1116-design-styles-skill.md
- docs-harness/harness-improvements/1116-hallmark-design-systems-skill.md

## Objective

The skill `asset-design-style` is called `asset-design-systems`: both skill
folders, the `name` field and the title line, the Hallmark skill's pointer for
plain style names and the catalog's skill list use the new name, and no live
guidance names the old one. The skill's description, steps, tables, references
and scripts keep their behavior.

## Purposes

- [x] Name the skill `asset-design-systems`, as the User asked on 2026-11-17.
- [ ] Candidate, awaiting the User: the name pairs with
  `asset-design-systems-hallmark` as one family, a base skill for named UI styles
  beside its Hallmark variant.

## Current State

Baseline: `D:/repos/base-harness-repo`, branch `main`, revision `51977dc` (seven
commits ahead of `origin/main`, none pushed), working tree clean, `harness-check`
clean (69 IDs, 1005 links in 166 Markdown files, 20 skills and 70 files identical
across both trees, 21 folders with README).

Request: the User wrote `đổi tên skill /asset-design-style thành "asset-design-systems"`.
No friction was observed; the change is a naming decision that the request
authorizes.

`asset-design-style` lives in `.agents/skills/` and, byte for byte, in
`.claude/skills/` (15 files each). Its `SKILL.md` carries `name: asset-design-style`
and the title `# Asset Design Style`; its two scripts name it in their docstrings.
Thirteen tracked files hold the hyphenated name: those six, both copies of the
Hallmark `SKILL.md` (step 1.3 sends a plain style name to it), the catalog
(`docs/tools/claude/README.md` section 7.3 and its derived `README.html`), the
#068 and #069 records, and #068's list line in
`docs-harness/harness-improvements/README.md`. No untracked or ignored file and
no settings file names it.

## Proposed Improvement

1. Move both skill folders to `asset-design-systems`.
2. `SKILL.md`: set `name` and the title line to the new name.
3. Replace the name in the two script docstrings.
4. Replace it in step 1.3 of both Hallmark `SKILL.md` copies.
5. Replace it in the catalog list and refresh `README.html`: the skill sentence
   and its two copies of the source SHA-256.
6. List this record in `docs-harness/harness-improvements/README.md`.
7. In #068 and #069 point `REFERENCES` at the new paths and at this record.

## Scope

May change: the items above. Unchanged: the skill's `description`, steps, tables,
references and script behavior; every other skill; the narrative of #068 and
#069, which keeps the name that was in use when it was written. No alias folder
keeps the old name, because a second copy would list the same description twice.
Nothing is committed or pushed.

## Progress

- 2026-11-17: Record opened before the edits; baseline taken as above.
- 2026-11-17: Moved both folders (15 files each) to `asset-design-systems`; set
  `name` and the title line; replaced the name in both script docstrings and in
  step 1.3 of both Hallmark copies; replaced it in the catalog list and set both
  source SHA-256 values in `README.html` to the hash of the new `README.md`;
  pointed the `REFERENCES` of #068 and #069 at the new paths and at this record;
  listed this record. Nothing is committed or pushed.

## Validation

Results, 2026-11-17:
- Old tree read from `HEAD` against the new tree, in both mirrors: the same 15
  files; only `SKILL.md` (2 lines: `name` and the title), `scripts/contrast.py`
  (1 line) and `scripts/preview.py` (1 line) differ. Hallmark trees: the same 19
  files; only `SKILL.md` differs, by 1 line (step 1.3), so its tree hash moves
  from `deb3be00d7114f55` (the tree #069 replayed) to `95dbbfe1db4bcb59`, still
  identical in both mirrors.
- Tree hash of `asset-design-systems`: `856797d675ba80c1` in both mirrors.
- `harness-check`: clean (70 IDs, 1006 links in 166 Markdown files, 20 skills
  and 70 files identical, 21 folders with README).
- `README.html`: three lines differ from `HEAD` (the skill sentence and the two
  source SHA-256 values); both values equal the hash of `README.md`.
- Search of the working tree for the hyphenated old name: the hits left are in
  #068 (11 lines), #069 (8), this record (6) and `harness-improvements/README.md`
  (2, the list lines of #068 and this record). No skill file, catalog, settings
  file or untracked file names it.
- The running session's skill list showed `asset-design-systems` right after the
  move, as #068 saw with the earlier rename. That is not a replay: the skill was
  not called.

Unattempted: a call in a new session under the new name (see Decision).

## Risks

- Anything that typed `/asset-design-style` (a note, a saved prompt) stops
  resolving; no alias is kept.
- A session that already loaded the old name keeps serving it from the Skill
  tool's cache until it restarts.
- #068 and #069 still show the old name in their narrative; their `REFERENCES`
  and this record explain the rename.

## Decision and Result

Decision: pending fresh rerun. The edits above are the implementation; the
effect under the new name is unverified until a new session calls it.

Replay task: in a new session, after a message in Vietnamese, call
`/asset-design-systems` bare and expect the numbered twelve-style menu (the rows
it printed before the rename) and one closing line. The call also covers the item
#068 left unattempted: a call in a new session under the skill's current name.
Owner: the next primary session or the User. Cost: about 100k tokens, no build
(the two scenarios of #069 used 99k and 118k).
