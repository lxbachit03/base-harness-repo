# Harness Improvement Resource

ID: #069_IMPROVE_HARNESS_1116
TAG: [IMPROVE_HARNESS]
PRIORITY: [NORMAL]
TITLE: Add the asset-design-systems-hallmark skill with fourteen researched Hallmark design systems
CREATED: 2026-11-16
STATUS: completed
REFERENCES:
- .agents/skills/asset-design-systems-hallmark/SKILL.md
- .claude/skills/asset-design-systems-hallmark/SKILL.md
- .agents/skills/asset-design-style/SKILL.md
- .claude/skills/writing-for-agents/SKILL.md
- .claude/skills/writing-for-agents/SKILL-MECHANICS.md
- docs/tools/claude/README.md
- docs-harness/SESSION.md
- docs-harness/harness-improvements/1116-design-styles-skill.md

## Objective

An `asset-design-systems-hallmark` skill lets an agent apply one of fourteen
Hallmark design systems (hum, furrow, coral, lumen, terrazzo, sticker, console,
studio, ink, dose, wayfind, dusk, bloom, cobalt) using researched tokens, CSS
recipes and accessibility guardrails, and measure the contrast of the result
with a script. Called without a named system, it prints a numbered list of the
fourteen (number, name, feel, best for) and waits for the User's pick, as
`asset-design-style` does for its twelve styles. It then builds the requested
.html or claude.ai Artifact asset. The fourteen are the User's selection from the
fifty themes of the Hallmark repository (github.com/Nutlope/hallmark, MIT
licence). The `.claude` mirror stays byte-identical.

## Purposes

- [x] Make an agent apply a named Hallmark design system from researched specifications instead of memory, as the User asked by supplying the three Hallmark links and requesting deep research of them.
- [x] Offer only the fourteen systems the User selected from Hallmark's fifty.
- [x] Let the User pick the system from a list when none is named, as `asset-design-style` does for its styles, as the User asked.
- [x] Give the skill the name `asset-design-systems-hallmark`, as the User asked.
- [ ] Keep Hallmark's MIT attribution with the material reused from its theme files. (candidate; awaiting User clarification)
- [ ] Keep accessibility measurable: every colour pair a system recommends carries a computed contrast ratio, and a script lets the agent recompute pairs it invents. (candidate; awaiting User clarification)

## Current State

Baseline (2026-11-16, Asia/Bangkok): `D:/repos/base-harness-repo`, branch `main`
at `5582dbe`, six commits ahead of `origin/main`; the working tree held only the
untracked `GOAL.md` (the User's request file). `harness-check` full run: RESULT
clean (68 IDs, 973 links in 148 Markdown files, 19 skills and 51 files identical
across the mirror, 21 folders with README).

Request: the User saved a request in `GOAL.md`, which opens with `/goal-griller`,
and then asked to implement it. It asks to research three links
(usehallmark.com, the Nutlope/hallmark repository and its
`skills/hallmark/references/themes` folder) with `anthropic-skills:deep-research`,
then to create a skill named `asset-design-systems-hallmark` with
`anthropic-skills:skill-creator`. Hallmark has fifty styles; the User wants only
the fourteen named in the Objective. As with `asset-design-style`, calling the
skill lists the systems so the User can choose.

Observed gap: none of the 19 skills covers Hallmark. `asset-design-style` holds
twelve other styles; no Harness skill lists, previews or applies a Hallmark
system.

Pre-flight evidence (GitHub REST API, read-only, 2026-11-16): the themes folder
holds fifty theme specifications (`<name>.md`, about 7 to 8 KB each) with a
preview `.jpg` each, plus a `README.md` and an `index.json`; all fourteen
requested names exist as `<name>.md`. The repository reports an MIT licence,
default branch `main`, last push 2026-11-11 and the homepage
https://www.usehallmark.com/.

Research (2026-11-16, `anthropic-skills:deep-research`): five researchers ran in
parallel (the site, the repository and its shared files, and four batches of the
fourteen theme files) and one report writer followed. The account's five-hour
usage limit cut the researchers off during their last verification passes; their
notes were complete and structurally intact (every theme section, every overview
section), so no extra round was run. The report (1,209 lines) was sent to the
User; it and the notes stay in the session scratchpad, outside the repository.
Findings that shape the skill:

- usehallmark.com is a static one-page site that lists all fifty themes (name,
  one-line tagline, genre) with a live sample of each at `/themes/<slug>/`;
  install is `npx skills add nutlope/hallmark -g`.
- The repository (MIT, copyright line "Copyright (c) 2026 Hallmark contributors",
  `main` at `04977e1` of 2026-11-11, version 2.0.0, no releases) defines a theme
  as a material (paper, ink, faces, rules, depth, controls, motion, voice) and
  keeps the type scale, spacing, durations, canvas, copy rules and the anti-slop
  gates in shared files that bind every theme. A theme file is an 11-key header
  plus nine sections: Tokens, Type, Surfaces, Range, Controls, Motion, Voice,
  Do-nots, Build hint.
- A Hallmark build reads exactly one theme and no file advises mixing or pairing
  themes; Hallmark's own word for what the User picks is "theme".
- Every colour in the theme files is OKLCH and no contrast ratio appears in them.
  Four faces load from Fontshare, which an Artifact cannot use, and 14 of the 25
  Google families named in the fourteen build hints lack the Vietnamese subset
  (measured from Google Fonts CSS).
- The fourteen theme files were last changed by `45af70a`, `3d760dd`, `3756c14`,
  `1e33562` and `0857f9c` (2026-10-20 to 2026-10-27).

## Proposed Improvement

Add `.agents/skills/asset-design-systems-hallmark/` and its `.claude` mirror:

- `SKILL.md` (model-invoked, 65-word description): resolve the theme (named, or a
  numbered menu with Feel and Choose-when per theme), read its reference, build
  from tokens, verify with measured contrast, report. The reply grammar is a
  number or name, or `xem mẫu a b` for a rendered preview; there is no `a + b`
  because Hallmark builds exactly one theme.
- `references/foundation.md`: Hallmark's shared scale tokens and base stylesheet,
  the Floor that binds every build and the Defaults a theme's own value
  overrides, so that every theme's token block resolves.
- `references/<theme>.md` for each of the fourteen: identity, the exact token
  block copied from the source, surfaces and range, recipes (the Build hint plus
  resets and texture stand-ins), guardrails with measured contrast, choose or
  avoid, a `## Preview` block, and the commit the theme file was last changed at.
- `scripts/contrast.py` (WCAG ratios; OKLCH input added because Hallmark writes
  OKLCH) and `scripts/preview.py` (the sibling's, prepending the foundation CSS
  and writing `hallmark-preview.html`).
- `NOTICE.md`: the MIT notice that travels with the copied material.

The skill defers to the project's own design system and to `artifact-design` for
the Artifact page contract. The skill inventory in `docs/tools/claude/README.md`
(sections 7.1 and 7.3) is updated and its derived `README.html` rebuilt.

Hypothesis: naming a system retrieves one reference whose tokens already pass the
contrast bar and whose guardrails name the failure modes of the source, so the
agent ships the system without those failures. Contrary evidence: the agent skips
the references or the verify step; a reference drifts from the Hallmark file it
came from; the description fires on any UI request and adds context load. Owner:
the primary (Bale) session. Revise when the system list changes, a source theme
file changes, or a replay shows the verify step skipped; remove if the User
retires the list.

## Scope

May change: the new skill folder and its `.claude` mirror; the skill inventory
sentences in `docs/tools/claude/README.md` (sections 7.1 and 7.3) and the derived
`README.html`; this record and its list entry.

Unchanged: `asset-design-style` and every other skill, INDEX, the `harness-check`
script, `docs/raw-requirements/`, `GOAL.md`. No commit or push without the User's
approval; nothing is installed; research notes and replay output stay outside the
repository.

## Progress

- 2026-11-16: Read `GOAL.md`; confirmed through the GitHub contents API that the
  fourteen names exist in the Hallmark themes folder. Started the deep research:
  one researcher for the site, the repository and the shared structure, four for
  the fourteen theme files. Record created and listed before the skill edits.
- 2026-11-16: The researchers were cut off by the usage limit during their last
  verification passes; their notes were complete. A report writer ran in the
  background. The theme sources were then read again directly at commit `04977e1`
  (in memory only, nothing saved), because the notes are three times the size of
  the 7 to 8 KB files they describe.
- 2026-11-16: Built the skill. The references come from templates: a build script
  copies each theme's token block from the source at the pinned commit, and every
  contrast figure is computed by the shipped `contrast.py`. Defaults chosen
  without asking, for the User to reverse: model-invoked with a trigger
  description (as `asset-design-style`); local .html as the default output and an
  Artifact only on request; no `a + b`; Vietnamese-copy font swaps and a cleanup
  line included from the start (the two follow-ups #068 proposed for its own
  skill); no skill-creator eval cases because the output is a subjective design.
- 2026-11-16: Rendered the fourteen previews in headless Edge and fixed what they
  exposed: texture strength (hum, coral), button resets the source leaves to its
  page base (terrazzo, sticker, studio, dose, wayfind, lumen), a ghost button on
  the pale dusk hero, and a dot-grid stand-in that fought the text (cobalt).
  Two pairs measured below 4.5:1 and carry a measured substitute: the terrazzo
  rust code on the selected-row tint (4.29:1, darker rust 5.33:1) and dusk glass
  over the palest fog (4.29:1, alpha 0.70 gives 6.28:1).
- 2026-11-16: Installed both skill trees (19 files each, CRLF), updated the
  catalog (sections 7.1 and 7.3) and rebuilt `README.html` (four lines differ).
- 2026-11-16: Replays 1 (native subagents, the coordinator playing the User) on
  the first complete tree. S1, the bare call, and S2 and S3, two builds, passed
  with findings; see Validation. Revision after them: the brief rule moved to the
  end of step 1 and extended to an earlier turn; the menu prints in the language
  of the User's messages with one closing line that names both preview forms; the
  foundation splits its rules into a Floor and Defaults a theme's own value
  overrides, and adds the control-edge and shadow-transition notes; `SKILL.md`
  gains the theme-wins line for type values, the Vietnamese line-height, the
  400px iframe probe, the `matchMedia` note, the edge sentence and a wider
  cleanup line; dose takes a `--color-muted` key rim and a paper-filled stamp;
  cobalt says graphite panes are not bands; every preview is labelled sample
  copy. Tree after this revision: `11389bac543350a9`.
- 2026-11-16: Replays 2, S1v (bare call after a Vietnamese message) and S4
  (`/asset-design-systems-hallmark 4`), ran after the revision. Both reports quote
  the pre-revision wording (the brief rule at the end of the menu, a closing line
  followed by two bullets), so the Skill tool served a `SKILL.md` it had cached
  earlier in the session and these two replays exercised the old text with the
  revised references and scripts. They passed on that text; the revised text
  itself is not yet replayed. Three small wording edits followed their reports (a
  brief given earlier in the conversation counts, `a` and `b` are numbers or
  names, the preview page is `hallmark-preview.html`) and gave the final tree
  `deb3be00d7114f55`.
- 2026-11-17: Replayed S1v and S4 in a fresh session, which loads the revised
  `SKILL.md` from disk: two native subagents, this session playing the User, on
  tree `deb3be00d7114f55` (19 files in each mirror). Both passed; see Validation.
  They exercise only step 1, so the later steps and the preview paragraph stay
  checked by reading and `harness-check`. The record is completed; nothing is
  committed or pushed.

## Validation

Tree hash method: SHA-256 of the sorted lines `path:sha256(LF text)` of every file
of the skill, first 16 hex digits.

- `harness-check` full run after the final install: RESULT clean (exit 0). 69
  unique IDs `#001`-`#069`; 1005 local links in 166 Markdown files resolve; 20
  skills and 70 files identical across the mirror; 21 folders with README.
- Structure check of the skill folder (a scratch script): front matter name equals
  the folder, 14 numbered rows in order, every reference present with its
  required sections, balanced CSS, an html block under `## Preview`, no unexpanded
  marker; 0 problems.
- Source fidelity: the fourteen token blocks are copied programmatically from the
  sources at `04977e1`; the Build hint CSS lines were compared with the sources
  and every line that differs is a deliberate reset or stand-in noted in the
  reference or in SKILL.md step 2.
- Contrast: 157 ratio and band figures computed by the shipped script during the
  build; the substitutes above were measured the same way. `contrast.py` converts
  OKLCH with CSS Color 4 chroma-reduction mapping; checked on white, black,
  `#ff0000` (4.00:1 on white) and the known figures of `asset-design-style`'s
  script; exit codes 0, 1 and 2 each observed.
- Rendering: each theme's `## Preview` block rendered in headless Edge, in static
  states, in 340px frames, from the installed skill folder. Hover, active, focus,
  forced-colors and dark colourway branches were not rendered by the preview.
- Fonts (Google Fonts CSS, read-only): 14 of 25 families lack the vietnamese
  subset (Atkinson Hyperlegible Mono, Bowlby One SC, DM Mono, Hedvig Letters
  Serif, Host Grotesk, Instrument Sans, Instrument Serif, Red Hat Display, Red
  Hat Mono, Red Hat Text, Schibsted Grotesk, Sofia Sans, Sofia Sans Extra
  Condensed and Syne); each reference names a swap that has it, and the Fontshare
  faces (Chillax, General Sans, Ranade, Gambarino) name a Google substitute.
- Installed scripts, run from the repository path: `preview.py` by number and by
  name, ambiguity and unknown number exit 2; `contrast.py` exit 0 and 1.
- Replays, disposable folders outside the repository, fresh native subagents
  (workers) with the coordinator playing the User; the Edge renders were headless:
  - S1, bare `/asset-design-systems-hallmark` (tree `c028b83753481552`): found by
    its exact name; fourteen numbered rows with number, name, feel and best-for,
    then one reply line; nothing read or written. Unclear to the agent: the
    language of a bare call, whether the brief rule applies after a named pick.
  - S2, `/asset-design-systems-hallmark trang đích cho ứng dụng nhắc uống thuốc của
    gia đình`, then `xem mẫu 10 11`, then `10` (same tree): the menu came in
    Vietnamese and kept the brief; `preview.py 10 11` wrote the page; the pick
    read the foundation and `dose.md` and built a Vietnamese local .html with the
    reference's swaps (Hanken Grotesk, IBM Plex Mono), confirmed through
    `document.fonts` to load the vietnamese range; 32 pairs in two `contrast.py`
    runs, all above their bars (4.5 and 3); a third run flagged the key rim at
    1.40:1 and led to a muted rim; no horizontal overflow in a 400px iframe; one
    fix round; the folder ended with the deliverable alone. Findings:
    Edge keeps a window of about 500px so `--window-size=400` misleads; the rim
    of the dose key measured 1.40:1 and the stamp text 4.2 to 4.3:1 on darker
    tints; no Vietnamese line-height note; the cleanup line did not say whether
    the preview page goes.
  - S3, `/asset-design-systems-hallmark cobalt <brief>` (same tree): no menu; the
    foundation and `cobalt.md` read; a local .html with the generated ASCII
    field, keycaps, cut panes and graphite code panes; every text pair above 4.5;
    reduced-motion, no-script and `@supports` fallbacks; 400px checked in an
    iframe; one fix round; only the deliverable left. Findings: the same Edge
    width issue; "two bands, one graphite" read two ways; the Floor said "only
    transform and opacity" while the recipe transitions a shadow; `--min 3` for
    edges against a guardrail that lists failing key edges; an invented figure in
    the cobalt preview; the base line-height 1.05 against the theme's 1.02.
  - S1v and S4 (references and scripts at tree `11389bac543350a9`, `SKILL.md` as
    cached, pre-revision): S1v printed the menu in Vietnamese with the labels and
    every Feel and Choose-when phrase translated, theme names in English, and a
    closing line naming `xem mẫu a b` and `preview a b`; S4 resolved the number to
    lumen, echoed it with its feel and asked once what to build and in which form,
    reading and writing nothing.
  - S1v-fresh and S4-fresh (2026-11-17, a new session; tree `deb3be00d7114f55` in
    both mirrors): two fresh native subagents, one per scenario, this session
    playing the User, each given an empty folder under this session's scratchpad
    (both still empty afterwards). The Skill tool served the revised text from
    disk: all 97 non-empty `SKILL.md` body lines appear verbatim in each
    transcript. Each subagent first ran the start-up retrieval that `AGENTS.md`
    and INDEX require (14 and 12 calls: reads, listings, an inspection of
    `harness_check.py` and its `--quick` run, which each reported apart from the
    skill), then made one Skill call; neither opened a reference or a script of
    the skill, and nothing was written, edited or deleted. S4-fresh ran one more
    Glob after the Skill call, for stray `.pyc` files left by the start-up
    script (none). The harness reported 118k and 99k subagent tokens, above the
    75k estimate because of that start-up retrieval.
    - S1v-fresh, `/asset-design-systems-hallmark` after the Vietnamese message
      "chào, mình đang cần thiết kế một trang web giới thiệu dịch vụ của mình"
      (already answered): pass. 14 rows numbered 1 to 14 in table order, each
      `<#>. <theme> - <Feel>. Phù hợp với: <Choose when>`, with the label, Feel
      and Choose-when text in Vietnamese (a few borrowed terms such as SaaS, API,
      SDK, CLI, merch and portfolio stay in English) and the theme names in
      English; no lead-in; one closing line and nothing after it, no bullets:
      "Gõ số hoặc tên để chọn theme đó; gõ `xem mẫu a b` hoặc `preview a b` (a, b
      là số hoặc tên) để xem các theme đó cạnh nhau." (the parenthesis is the
      agent's addition). First row: "1. hum - Giấy cắt thủ công, vui tươi, gợi
      cảm giác chạm. Phù hợp với: thói quen hằng ngày và chuỗi ngày liên tiếp,
      học tập, trẻ em và gia đình, trò chơi, cộng đồng". The turn ended at the
      menu; no brief or form question, since a brief was in hand.
    - S4-fresh, `/asset-design-systems-hallmark 4` with no earlier message: pass.
      After a start-up line, "Harness check (quick): RESULT: clean (exit 0)",
      which INDEX requires and the skill does not produce, the reply was: "Theme
      4 is lumen (violet-black night console, lowercase serif, one brass signal).
      What should I build with it, and in which form: a local .html file (the
      default) or a claude.ai Artifact?" No menu, one question, no reference
      opened before asking, nothing written.
    - Unclear to the agents, left unchanged because both passed: whether the Feel
      keeps the table's lowercase or is capitalised and whether a row ends with a
      period; no glossary for the translated label; whether the menu reply may
      echo the brief or put a blank line before the closing line; "ask once" does
      not say to end the turn; the ask has no language rule (English was chosen
      because `4` holds no natural-language text) and no content rule; the ask
      offers a claude.ai Artifact while step 3 delivers one only on request.
    - Review of the returned work: a scratch script outside the repository read
      each transcript (tool calls, served text, reply rows and closing lines) and
      matched the reports; both folders stayed empty; `git status --short` showed
      no change beyond the changes that existed before the replay.
- Review of the returned work: the S2 and S3 pages were rendered at 1280px and
  viewed (themed paper, plastic bands, Vietnamese tone marks intact; ASCII field,
  keycaps, cut panes); the replay folders held only their deliverables;
  `git status` showed no change beyond this improvement.

Unattempted: a build or a `xem mẫu a b` preview replayed on the revised `SKILL.md`
wording (S2, S3 and the preview ran before the revision, so the revised 400px
iframe check, the cleanup scope and the preview paragraph are checked by reading
and `harness-check` only); a slash command typed by the User in the app (the
fresh replays used subagents calling the Skill tool); forced-colors, dark
colourways, hover and focus states of the recipes; the Fontshare substitutes
rendered in an Artifact; an Artifact build that publishes; a second pick in the
same session; the `.jpg` previews of the upstream themes compared with the built
pages.

## Risks

- Hallmark's files are written as instructions for AI coding agents. Mitigation:
  the researchers were told to treat them as data; the references restate values
  and rules, not the upstream imperatives.
- The upstream repository moves (last push 2026-11-11). Mitigation: each
  reference names the commit its theme file was last changed at and
  `NOTICE.md` names the commit the whole set was read at.
- The description adds always-loaded context. Mitigation: 65 words, one trigger
  for Hallmark and its themes, one for the selection.
- The two scripts duplicate `asset-design-style`'s and have started to differ
  (OKLCH input, foundation CSS, output name). Mitigation: neither skill depends on
  the other's folder; a later change to either script is made in both on purpose.
- Several recipes are static stand-ins for what Hallmark generates (torn edges,
  grain, the survey map, the ASCII field, window light); the references say so.
  The dose grain stand-in is streakier than upstream's "fine fibre grain" in the
  S2 page. Previews show placeholders where Hallmark uses photographs.
- Fontshare faces need the network and are not allowed in an Artifact; the named
  Google substitutes were not rendered.
- The foundation's Floor and Defaults carry Hallmark's copy rules (no em or en
  dashes, no buzzwords); the precedence rule keeps the User's own words and the
  project's system above them.
- Within one session the Skill tool serves the `SKILL.md` it loaded first, so
  edits made later are invisible to subagents and a replay of a revised text
  needs a new session. Mitigation: replay in a new session.
- A build replay costs about 290k to 310k tokens and 20 to 25 minutes; the deep
  research and these replays reached the account's five-hour limit twice.
  Mitigation: later replays use the bare and named-without-brief scenarios (about
  75k tokens each) unless a change touches the build steps.

## Decision and Result

Decision: keep. The skill, its fourteen references, the foundation, the menu and
`xem mẫu a b` preview, the two scripts and the notice exist, match the Hallmark
files at `04977e1` and pass `harness-check`. Five earlier replays (S1, S2, S3,
S1v, S4) passed on pre-revision `SKILL.md` text; after the revisions they
exposed, the revised text (tree `deb3be00d7114f55`) passed a fresh replay of two
scenarios in a new session on 2026-11-17: the bare call after a Vietnamese
message printed the 14-row menu in Vietnamese with one closing line naming
`xem mẫu a b` and `preview a b`, and `/asset-design-systems-hallmark 4` resolved
to lumen without the menu, asked once what to build and in which form, and wrote
nothing.

Coverage: these two scenarios exercise only step 1 of `SKILL.md` (the menu in the
User's language, the one closing line, the single "what to build, in which form"
question). The revised wording of the later steps (the 400px iframe check, the
cleanup scope) and of the `xem mẫu a b` paragraph stays checked by reading and
`harness-check` only, because the earlier build replays ran on the pre-revision
text and no build or preview was replayed after the revision. The User chose
these two cheap scenarios and no build replay, accepting that trade-off. The
calls were made by subagents through the Skill tool, not typed in the app.

Remaining proof, not required for this decision: a build and a `xem mẫu a b`
preview replayed on the revised text. Run them if a later change touches steps 2
to 5 or the preview paragraph, or if the User wants that proof (a build replay
costs about 300k tokens). Owner: the next primary (Bale) session or the User.
Nothing is committed or pushed.
