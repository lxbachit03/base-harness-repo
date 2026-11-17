---
name: asset-design-systems-hallmark
description: "Hallmark design systems: apply, choose or compare one of fourteen researched Hallmark themes (hum, furrow, coral, lumen, terrazzo, sticker, console, studio, ink, dose, wayfind, dusk, bloom, cobalt) from exact tokens, CSS recipes and contrast guardrails. Use when the User mentions Hallmark, or one of these as a Hallmark theme, for a design, HTML page, artifact or UI; with no pick it prints a numbered menu."
---

# Asset Design Systems: Hallmark

Fourteen themes taken from the fifty in Hallmark (github.com/Nutlope/hallmark, MIT; notice in [NOTICE.md](NOTICE.md)). A theme is a material: paper, ink, faces, depth, controls, motion and voice. Each one is researched into a reference with exact tokens, CSS recipes, measured contrast and the source commit it was read at; [foundation](references/foundation.md) holds the scale and base stylesheet every theme builds on. This file lists the themes, resolves the User's pick, runs the build and verifies it; the theme's own file holds every value.

## 1. Resolve the theme

1. The call or request names a theme (number or name from the table): use it and skip the menu.
2. No theme named: print the menu below and end the turn; the reply starts the build. Keep any brief that came with the call or earlier in the conversation.
3. A Hallmark theme outside the table, or a plain style name (Swiss, glass, brutalism...): say this skill covers the fourteen below, print the menu, and send a plain style to `asset-design-systems`.
4. A project design system (CLAUDE.md, token or theme file, existing styles) outranks this skill; use the reference to fill its gaps. Precedence: the User's words, the project's system, this skill.

Done when one theme is named. A build uses exactly one theme; a second theme is a separate build. With a brief in hand go to step 2; without one, ask once what to build and in which form: a local .html file (the default) or a claude.ai Artifact.

| # | Theme | Feel | Choose when | Reference |
|---|---|---|---|---|
| 1 | hum | handmade cut paper, cheerful, tactile | daily habits and streaks, learning, kids and family, games, community | [hum](references/hum.md) |
| 2 | furrow | warm manila, survey map, working records | farm and field records, inspection and compliance, rural field service | [furrow](references/furrow.md) |
| 3 | coral | warm stationery on a felt desk, calm | SaaS, billing and invoicing, fintech, onboarding, trust | [coral](references/coral.md) |
| 4 | lumen | violet-black night console, lowercase serif, one brass signal | AI and model APIs, agents, dev tools, research labs | [lumen](references/lumen.md) |
| 5 | terrazzo | off-white, ruled cards on hard offsets, rust signal | material and sample libraries, architects, interiors, showrooms | [terrazzo](references/terrazzo.md) |
| 6 | sticker | loud die-cut stickers, hot pink and lime | stickers, merch, print shops, makers, small-shop e-commerce | [sticker](references/sticker.md) |
| 7 | console | graphite lab notebook, amber and instrument blue | labs, protocols, observability, audit, operations | [console](references/console.md) |
| 8 | studio | cool proof paper, dot grid, crop marks, cadmium orange | design studios, branding, portfolios, case studies | [studio](references/studio.md) |
| 9 | ink | white paper, true black, one teal, hairline rules | libraries, civic and non-profit, notice boards, membership | [ink](references/ink.md) |
| 10 | dose | warm morning paper, tinted plastic, pharmacy green | health and medication apps, reminders, clinics, carers | [dose](references/dose.md) |
| 11 | wayfind | cool grey, mono, square ink borders, live cobalt | transit, timetables, departures, status, travel | [wayfind](references/wayfind.md) |
| 12 | dusk | real dusk landscape, slate, smoked glass, periwinkle | treasury, banking, reconciliation, month-end close | [dusk](references/dusk.md) |
| 13 | bloom | warm grain, terracotta blooms, rubber and cased parts | generative and creative AI, music, image and video tools | [bloom](references/bloom.md) |
| 14 | cobalt | cool near-white, ASCII field, keycaps, electric cobalt | APIs, SDKs, CLIs, docs, developer platforms | [cobalt](references/cobalt.md) |

### The menu

Print one line per table row: `<#>. <theme> - <Feel>. Best for: <Choose when>`,
with theme names in English and the label, Feel and Choose-when text in the
language of the User's messages (English when there are none). Close with one
line: a number or a name picks that theme, and `xem mẫu a b` or `preview a b`
renders those themes side by side.

On a preview reply (`a` and `b` are numbers or names), run
`python -I <skill folder>/scripts/preview.py a b` from the working folder
(`<skill folder>` is the base directory shown when this skill loads), report the
page it writes there, `hallmark-preview.html`, then repeat the closing line.

When the User asks which theme fits a brief, answer with one pick and one
runner-up from these shortcuts, then offer the menu: playful or habit apps on
hum or sticker; billing and plain SaaS on coral or dusk; developer and API
products on cobalt, lumen or console; records, labs and operations on furrow,
console or wayfind; creative portfolios on studio or terrazzo; civic and
community on ink; health on dose; generative creative tools on bloom or lumen.

A new theme is a reference file with the standard sections and a `## Preview`
block, plus one table row; the menu and the preview pick it up.

## 2. Read the reference

Open [foundation](references/foundation.md) once, then the chosen theme file in
full. The theme's **Tokens** and **Guardrails** bind the build; the foundation's
Floor binds every build, and its Defaults give way to a theme's own value.
Source tags show confidence: `[HALLMARK]` marks a value or rule read from the
Hallmark theme file, `[DERIVED]` one computed or chosen here (a texture
stand-in, a measured ratio, a font substitute). Recipe CSS copies the theme's
Build hint, with small resets added where the source leaves them to its page
base (a button's border, background and colour).

## 3. Build from tokens

- Start from the foundation's scale block and base stylesheet, then the theme's
  `:root` block, then its recipes; derive every colour, radius, shadow, type and
  spacing choice from those tokens. Colours are `oklch()`; keep them (browsers
  from 2023 draw them) unless the User names an older target. Where the theme's
  type notes state a line-height, tracking or weight that the base stylesheet
  sets differently, the theme's value wins.
- The theme decides material and never page structure: choose the sections and
  composition from the brief within the foundation's canvas rules.
- Where a reference lists colourways or dials, use the default unless the User
  asks for another, and state the pick in the report.
- Fonts: link the theme's own faces for a local file; a face that is not on
  Google Fonts gets the substitute the reference names when the build is an
  Artifact. Vietnamese copy needs a family with the `vietnamese` subset (the
  reference names the swap where its faces lack it) and display lines of 1.1 or
  more, because tone marks stack above capitals.
- Output is a local .html file in the working folder. Deliver a claude.ai
  Artifact only when the User asks for one (publishing needs that request): load
  `artifact-design` first and build under its page contract (theme tokens in
  three states, safe-area gutters, allowed hosts); the reference supplies
  palette, type and effects.

## 4. Verify

1. Run `python -I <skill folder>/scripts/contrast.py FG:BG ...` on every text
   and control colour pair, `oklch()` values included (quote an argument that
   holds spaces); the bar is 4.5 for text and `--min 3` for large text and UI
   edges. Join translucent layers with `>` so a tinted fill is measured over the
   paper behind it. A theme's Guardrails name the decorative edges it leaves
   under 3:1 on purpose; keep those and let the label and fill identify the
   control.
2. Walk the reference's Guardrails and the foundation's Floor bullet by bullet,
   and its Defaults wherever the theme is silent.
3. Add the fallbacks the theme uses: `prefers-reduced-motion`, `:focus-visible`,
   the no-script end state. Headless Edge may report `reduce` by default;
   override `matchMedia` to see the animated path.
4. Check a 400px width for horizontal scroll. Headless Edge or Chrome renders
   local files (the built-in browser pane cannot open them) but keeps a window
   of about 500px at least, and `overflow-x: clip` hides `scrollWidth`; load the
   page in a 400px-wide iframe on a probe page and compare each element's right
   edge with 400.

Done when every pair meets its bar and every Guardrails and Floor bullet is
applied or marked not applicable.

## 5. Report

One short line: the theme used, the tokens substituted for contrast or fonts, and
what stayed unrendered or unverified. Leave only the deliverable in the working
folder: remove the preview page, probe pages and scripts, screenshots and any
browser profile folder.
