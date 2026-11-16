# Harness Improvement Resource

ID: #068_IMPROVE_HARNESS_1116
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Add the asset-design-style skill with twelve researched UI style systems
CREATED: 2026-11-16
STATUS: completed
REFERENCES:
- .agents/skills/asset-design-style/SKILL.md
- .claude/skills/asset-design-style/SKILL.md
- .claude/skills/writing-for-agents/SKILL.md
- .claude/skills/writing-for-agents/SKILL-MECHANICS.md
- docs/tools/claude/README.md
- docs-harness/SESSION.md
- docs-harness/harness-improvements/1115-claude-catalog-refresh.md

## Objective

An `asset-design-style` skill lets an agent apply one of twelve UI styles using
researched tokens, CSS recipes and accessibility guardrails, and measure the
contrast of the result with a script. Called without a named style, it prints a
numbered list of the twelve (number, name, feel, best for) and waits for the
User's pick: a number or name, `a + b` for a primary and an accent, or
`xem mẫu a b` for a rendered preview of those styles. It then builds the
requested .html or claude.ai Artifact asset. The styles are
the User's list of eleven (Swiss Minimalism, Neumorphism, Glassmorphism,
Brutalism, Claymorphism, Aurora / Mesh Gradient, Retro-Futurism / Cyberpunk, 3D
Hyperrealism, Vibrant Block / Maximalist, Dark OLED Luxury, Organic /
Biomorphic) plus an Anthropic style taken from the design artifact and HTML page
built earlier in the session. The `.claude` mirror stays byte-identical.

## Purposes

- [x] Make an agent apply a named style from researched specifications instead of memory, as the User asked by supplying the style list and requesting deep research of each system design.
- [x] Cover the Anthropic style the User asked to add beside the eleven listed styles.
- [x] Let the User pick the style from a numbered list when none is named, with an on-demand preview, as chosen in the 2026-11-16 goal interview and confirmed with "Chạy ngay".
- [x] Give the skill the name `asset-design-style`, as the User asked in the 2026-11-16 rename request.
- [ ] Keep accessibility measurable: every colour pair a style recommends carries a computed contrast ratio, and a script lets the agent recompute pairs it invents. (candidate; awaiting User clarification)
- [ ] Keep the Artifact page contract single-sourced in `artifact-design`, with the project's own design system ranked first. (candidate; awaiting User clarification)

## Current State

Baseline (2026-11-16, Asia/Bangkok): `D:/repos/base-harness-repo`, branch `main`
at `1a002a6`, four commits ahead of `origin/main`. The working tree still holds
the uncommitted #067 changes (the `utilizing-tools-claude` skill and its mirror,
`docs/README.md`, the Claude catalog and its `README.html`, the #067 record and
its list entry). `harness-check` full run: RESULT clean (67 IDs, 960 links in 133
Markdown files, 18 skills and 36 files identical across the mirror, 21 folders
with README).

Request: the User supplied a table of eleven design styles (an image) and asked
to create a new skill with `anthropic-skills:skill-creator`, adding one Anthropic
style "like the artifact and the .html built earlier", then asked for deep
research of each style's system design with the built-in browser.

Observed gap: no Harness skill covers UI style selection or application. None of
the 18 skills holds tokens, shadow recipes, type pairings or fallbacks for a
named style.

Second request (2026-11-16, `/goal-griller`): the User wants the skill, when
called, to show a list of the styles to choose from. Observed gap: step 1 rule 2
of `SKILL.md` chooses a style for the User and names a runner-up; nothing lists
the twelve or previews them. Interview answers: the list is a numbered chat list
(a button question holds at most four options, so twelve cannot be buttons);
proof is a fresh-session replay of three scenarios, which authorizes a replay
subagent. Assumptions accepted with "Chạy ngay": extend `design-styles` instead
of adding a second skill; asset types are .html files and claude.ai Artifacts;
the preview is a local .html file.

Third request (2026-11-16): the User asked to rename the skill to
`asset-design-style`, with no change in behavior. Consumers of the old name,
found with `git grep --untracked` and a plain search of the hidden skill
folders: `SKILL.md` (`name:` and the heading), two script docstrings, the
catalog sentence and its derived `README.html`, the list entry, and this record.
The skill and its mirror are untracked, so no commit carries the old name. Text
in this record dated before the rename keeps the name that was current when it
was written, `design-styles`.

Evidence collected on 2026-11-16 with the built-in browser, read-only, kept as
twelve draft notes in the session scratchpad:

- Wikipedia (International Typographic Style, Retrofuturism, Biomorphism,
  Biophilic design); NN/g (Glassmorphism, Skeuomorphism, Dark Mode); MDN
  (`backdrop-filter`, `prefers-reduced-transparency`); CSS-Tricks (Neumorphism
  and CSS); Smashing Magazine (Swiss Style, 2009); Brutalist Websites;
  neubrutalism.com; superdesign.dev style pages (claymorphism, aurora, dark
  mode, retro); the third-party `chrislemke/website_designs` guides (tokens for
  every style); the live CSS of www.anthropic.com; the `artifact-design` skill.
- Findings that change the guidance: the sources' own palettes fail WCAG in
  places (neumorphism secondary text 4.14:1 and shadow edge 1.72:1; white on
  `#ff6b6b` 2.78:1; white on pastel lavender 1.85:1; neon purple 4.03:1; moss
  4.26:1; clay `#d97757` on ivory 2.96:1), so each reference substitutes a
  measured value. The third-party guide overstates NN/g on glass (NN/g names
  opacity and blur, with strokes and gradients optional). Pure black conflicts
  between NN/g (saves most OLED power) and Dark Luxe/Superdesign (off-black
  avoids halation); the reference separates media canvases from text surfaces.

Limits of the evidence: the CSS recipes were rendered once, in static states
(see Validation); Vibrant Block / Maximalist has no primary or vendor source; the
account has no attached design system; Anthropic's own typefaces are proprietary
and cannot load in an Artifact, so Google Fonts stand-ins are named.

## Proposed Improvement

Add `.agents/skills/asset-design-style/` and its `.claude` mirror: `SKILL.md`
(model-invoked; resolve the style, read its reference, build from tokens, verify
with measured contrast, report deviations), `references/<style>.md` for each of
the twelve styles (identity, tokens, recipes, guardrails, choose or avoid, dated
evidence labels), and `scripts/contrast.py` (a WCAG ratio checker that
composites translucent layers). The skill defers to the project's own design
system and to `artifact-design` for the Artifact page contract. Update the skill
inventory in `docs/tools/claude/README.md` and rebuild its derived `README.html`.

Revision of 2026-11-16: number the style table and add a Feel column; step 1
prints the menu when no style is named, accepts a number, a name, `a + b` and
`xem mẫu a b`, and asks once what to build when the call holds no brief; add
`scripts/preview.py` (stdlib) and a `## Preview` block to each reference so a
preview page is assembled from the references' own CSS. The table stays the one
source for the menu and the preview.

Rename of 2026-11-16: move both skill folders to `asset-design-style`, set
`name:` and the heading, and update the script docstrings, the catalog sentence
and its `README.html`, the list entry and this record. The description, the
style table, the references and the scripts' behavior stay as replayed. The
record keeps its path and ID because the intervention is the same skill; its
filename retains the original slug `design-styles`.

Hypothesis: naming a style retrieves one reference whose tokens already pass the
contrast bar and whose guardrails name the failure modes found in the sources,
so the agent ships the style without those failures. Contrary evidence: the agent
skips the references or the verify step; a reference drifts from its source or
the sources go stale; the description fires on any UI request and adds context
load. Owner: the primary (Bale) session. Revise when the style list changes, a
source contradicts a reference, or a replay shows the verify step skipped;
remove if the User retires the style list.

## Scope

May change: the new skill folder and its `.claude` mirror; the skill inventory
sentences in `docs/tools/claude/README.md` and the derived `README.html`; this
record and its list entry.

Unchanged: the other skills, the `utilizing-tools-*` skills, INDEX, the
`harness-check` script, `docs/raw-requirements/`. No commit or push without the
User's approval; nothing is installed outside the repository.

Revision: the menu step, `scripts/preview.py` and the Preview blocks stay inside
the skill folder; replay output goes to disposable folders outside the
repository; the catalog's dated file count (50 on 2026-11-16) is left as a
snapshot.

Rename: it touches only the folder names, `name:`, the heading, two script
docstrings, the catalog sentence and its `README.html`, the list entry, and this
record's title, references and notes; this record keeps its filename.

## Progress

- 2026-11-16: Researched the twelve styles with the built-in browser and drafted
  twelve reference notes. Record created and listed before the skill edits.
- 2026-11-16: Created `.agents/skills/design-styles/` (`SKILL.md`, twelve
  references, `scripts/contrast.py`) and its `.claude` mirror; recomputed the
  contrast figures; rendered a sampler and patched the recipe gaps it and a
  review exposed; updated the skill inventory in the catalog and rebuilt
  `README.html`.
- 2026-11-16: Second request through `/goal-griller`; the drafted goal was
  accepted with "Chạy ngay". Record revised before the skill edits (Objective,
  Purposes, Current State, Proposed Improvement, Scope).
- 2026-11-16: Defaults chosen without asking, for the User to reverse: the skill
  lives in the repository (`.agents/skills` with the `.claude` mirror) instead of
  `~/.claude/skills`; it is model-invoked with a trigger description; no
  skill-creator eval cases were written because the output is a subjective
  design; the Anthropic style combines the brand look read from anthropic.com,
  the documentation look of the earlier artifact and HTML page, and the Artifact
  page contract.
- 2026-11-16: Rewrote step 1 of `SKILL.md` (numbered table with a Feel column,
  the menu, the reply grammar), added `scripts/preview.py` and a `## Preview`
  block to each reference; the preview page renders all twelve styles from the
  references' own CSS in headless Edge. Mirrored; `harness-check` clean.
- 2026-11-16: Replay 1 on skill tree `6349779d69a5715f`: three fresh native
  subagents, the coordinator playing the User. Both build runs loaded
  `artifact-design` and called Artifact delivery the default although their
  prompts forbade publishing, and S2 had to swap the repo-relative script path
  for an absolute one. Revised steps 1, 3 and 4: local .html is the default
  form and an Artifact only on request; script paths use `<skill folder>`; a
  render hint was added. New tree `1162717cfd3285ee`.
- 2026-11-16: Replay 2 on tree `1162717cfd3285ee`: three more subagents, the
  Artifact tool simulated with a "WOULD PUBLISH" rule. Results in Validation.
- 2026-11-16: Renamed the skill to `asset-design-style` at the User's request:
  both folders moved, `name:` and the heading set, the script docstrings, the
  catalog sentence (`README.md` and the rebuilt `README.html`), the list entry
  and this record updated. Entries above keep the name that was current when
  they ran. Checks under Validation; no fresh replay under the new name.

## Validation

Names below are the ones current when each check ran: `design-styles` until
the rename, `asset-design-style` in the last bullet.

- `harness-check` full run after the edits: RESULT clean (exit 0). 68 unique IDs
  `#001`-`#068`; 973 local links in 147 Markdown files resolve; 19 skills and 50
  files identical across the mirror; 21 folders with README.
- SHA-256 comparison of `.agents/skills/design-styles` and
  `.claude/skills/design-styles`: 14 files, 0 differences.
- `scripts/contrast.py` self-test: white on black 21.00:1, `#999999` on white
  2.85:1, the chain `#ffffff:rgba(17,25,40,.45)>#00d2ff` 4.63:1; exit codes 0, 1
  and 2 each observed.
- Contrast figures in the references: 157 stated ratios; 114 matched by script
  against the colours on the same line; the other 43 name colours in words and
  were checked by hand against earlier runs of the same formula.
- Rendering: a sampler page with one iframe per style, built from the
  references' own CSS, rendered in headless Edge at 480px width. All twelve
  recipes drew their intended effects. Hover and active states, dark themes,
  reduced-motion branches and the Artifact sandbox were not rendered.
- Review of the recipes found and fixed missing base rules (`.neu-btn`, `.sk-btn`,
  a positioned parent for `.lx-velvet` and `.bio-blob`) and added recipes for
  Retro-Futurism / Cyberpunk, the Maximal mode and the Anthropic brand look.
- Line endings are CRLF in every new and changed file. The catalog's skill
  inventory (section 7) reads 19 skills and 50 files, a dated snapshot of the
  first check; the tree now holds 51 files and the catalog is left unchanged by
  scope. `README.html` was rebuilt for that snapshot.
- Menu, preview and build, checked in disposable folders outside the repository
  by fresh native subagents (workers) with the coordinator playing the User; the
  Edge and Chrome renders were headless:
  - S1, bare `/design-styles` (tree `6349779d69a5715f`): twelve numbered rows with
    number, name, feel and best-for, then the reply line; no file written.
  - S2, `/design-styles <brief>`, then `xem mẫu 2 5`, then `2` (same tree): the
    list kept the brief; `preview.py 2 5` wrote a two-style page byte-identical
    to the coordinator's own run; the pick built a Neumorphism landing page with
    secondary text `#4b565a` instead of `#636e72` and accent `#3a62d8` instead
    of `#4d7cff`, every pair measured with `contrast.py`, no horizontal scroll
    from 400px to 1280px, and the reduced-motion, forced-colors and
    reduced-transparency branches present.
  - S3, `/design-styles glassmorphism <brief>` (same tree): no list; the
    reference was read; dark glass for white text, 13 `contrast.py` runs over
    worst-case backdrops, 29 interaction probes passed, fallbacks present.
  - S3d, `/design-styles 4` (tree `1162717cfd3285ee`): resolved to Brutalism,
    skipped the menu, asked once what to build and in which form, named a local
    .html as the default and an Artifact only on request; nothing written.
  - S3c, `/design-styles brutalism <brief>` (same tree): no list, no
    `artifact-design` load, no "WOULD PUBLISH"; built a local .html in Neo mode
    with black text on every accent and no failing token; swapped Syne for Space
    Grotesk because Syne has no Vietnamese glyphs; no horizontal scroll from 320px
    to 1280px.
  - S3b, `/design-styles 4 trang đăng nhập ...` (same tree): the agent read "4" as
    a page count and printed the menu with a one-line note; a safe reading of an
    ambiguous scenario, not a skill failure.
- Review of the returned work: the S2, S3 and S3c deliverable folders and the
  empty S1, S3b and S3d folders were inspected; the expected tokens are present,
  the failing source tokens are absent, the fallbacks are present, and the only
  external host is Google Fonts; `git status` and the skill tree hash were
  unchanged after every run; three screenshots were viewed.
- Font measurement (2026-11-16, read-only, Google Fonts CSS, token and preview
  lines only): of 25 families parsed from the references, 10 have no `vietnamese`
  subset: Archivo Black, Bebas Neue, Bodoni Moda, DM Sans, Jost, Orbitron,
  Outfit, Poppins, Sora and Syne.
- Rename checks (2026-11-16, after the move): the `.agents` and `.claude`
  folders `asset-design-style` hold 15 files, 0 differences by SHA-256; against
  the manifest taken before the move, the 12 references are byte-identical and
  only `SKILL.md`, `scripts/contrast.py` and `scripts/preview.py` changed, by
  four lines (`name:`, the heading and two docstrings), all CRLF.
  `git grep --untracked` finds the old name only in this record's dated
  entries, its filename slug and the list entry's link target, and a plain
  search of `.claude` and `.agents` finds none. `contrast.py` (exit codes 0, 1
  and 2) and `preview.py 2 5` ran from the new path: both mirrors write
  byte-identical pages, equal to the preview page written before the rename.
  `harness-check` full run: RESULT clean (exit 0); 68 IDs, 973 local links in
  147 Markdown files, 19 skills and 51 files identical, 21 folders with README.
  `README.html` rebuilt: three lines differ (the skill sentence and the two
  source SHA-256 values). The running session's skill list picked up the new
  name without a restart; a new session's list was not opened.

Unattempted: the `a + b` reply and the Opposed-languages warning; the English
`preview a b` form; a replay in a full user-permission session instead of native
subagents; real clicking in the S2 page; forced-colors, Safari and Firefox
rendering; an Artifact build that actually publishes (simulated only); a call
of `/asset-design-style` in a new session and a replay under the new name (the
replays above ran under `design-styles`).

## Risks

- The description fires on any UI request and adds always-loaded context.
  Mitigation: one trigger per style and one for selection; nothing generic.
- References go stale as sources change. Mitigation: each reference dates its
  sources and labels third-party and derived values.
- Recipes were rendered once, in static states. Mitigation: the skill's report
  line names what stayed unrendered; a later sampler can cover hover, dark and
  reduced-motion branches.
- Anthropic faces cannot be shipped. Mitigation: Google Fonts stand-ins.
- Several recommended faces have no Vietnamese glyphs (see Validation), so
  Vietnamese copy falls back glyph by glyph. Proposal, not applied: a new
  improvement record that adds a Vietnamese-copy guardrail to `SKILL.md` and
  moves the affected stacks (Syne, Archivo Black and Bebas Neue in Brutalism,
  Sora in Aurora, Orbitron and Jost in Retro-Futurism) behind a face that has the
  subset, such as Space Grotesk or Inter.
- Verification scratch files can stay in the working folder: S3c left a probe
  script, a result file and nine screenshots while S2 and S3 removed theirs.
  Proposal, not applied: one line in step 5 asking to leave only the deliverable.

## Decision and Result

Decision: keep. The skill (now `asset-design-style`), its twelve references, the
menu and reply grammar, the preview script and the contrast script exist, match
the research of 2026-11-16, pass `harness-check`, and passed the replays above
on tree `1162717cfd3285ee`, after one revision that the first replay exposed
(the Artifact default and the script paths).

Rename (2026-11-16): keep. Four name lines changed (see Validation) and the
other twelve files are byte-identical, so the replays above stand for the
behavior. They ran under the original name and were not repeated: the text a
fresh agent reads is unchanged apart from the name lines, so a replay would
re-observe the same behavior. What a replay could add is discovery by the new
name in a new session, listed under Unattempted.

Remaining proof: the unattempted items under Validation and a replay in a full
session. Follow-ups proposed and not started: Vietnamese glyph coverage for the
font stacks, and the step-5 cleanup line. Committed on `main` in its own commit
after `#067` (2026-11-16); not pushed.
