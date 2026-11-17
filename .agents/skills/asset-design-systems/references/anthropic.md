# Anthropic (brand look, documentation look, artifact contract)

Evidence labels: [ANTH] live CSS and computed styles of www.anthropic.com read through the built-in browser on 2026-11-16 (258 custom properties; first-party) · [ARTD] the `artifact-design` skill text loaded 2026-11-16 (Claude's own guidance for Artifacts) · [LOCAL] the two assets built in this session: the Design canvas artifact (claude.ai/artifact/UKqfEULkmr5YGwfQuAKg5x) and `docs/tools/claude/README.html` · [DERIVED] computed or chosen here. The account has no design system attached (Design quickstart, 2026-11-16).

## Identity
Three layers, usable together:
1. **Brand look** (anthropic.com): warm ivory canvas, slate-black ink, a warm gray ramp, one clay accent, a serif for display and a sans for text, small pill buttons, calm editorial pacing; dark slate sections with ivory text. [ANTH]
2. **Documentation look** (the two assets): cool-neutral page, one blue accent, Inter plus a mono face, hairline borders, 8-12px radii, sticky top bar, table-of-contents sidebar, semantic callouts, light and dark themes. [LOCAL]
3. **Artifact contract** (claude.ai Artifacts): token structure, theme states, safe-area gutters, CDN allowlist and the avoid-AI-cliché rules. Applies to every style when the output is an Artifact. [ARTD]

## Tokens: brand look
```css
:root{
  --bg:#faf9f5; --surface:#ffffff; --surface-2:#f5f4ed; --surface-3:#f0eee6; --line:#e8e6dc; --line-2:#dedcd1;
  --ink:#141413; --ink-2:#3d3d3a; --muted:#5e5d59;                     /* #73726c is 4.58:1; #87867f fails */
  --accent:#d97757; --accent-interactive:#c6613f;
  --olive:#788c5d; --sky:#6a9bcc; --fig:#c46686; --oat:#e3dacc; --cactus:#bcd1ca; --heather:#cbcadb; --coral:#ebcece;
  --iris:#dfdbfd; --iris-deep:#4a3aa7; --periwinkle:#cde2fb; --periwinkle-deep:#184f95;
  --radius-xs:4px; --radius-pill:999px;
  --font-serif:"Newsreader","Source Serif 4",Georgia,serif;            /* stand-in for the proprietary anthropicSerif */
  --font-sans:"Inter","DM Sans",system-ui,sans-serif;                  /* stand-in for the proprietary anthropicSans */
}
```
- Warm gray ramp [ANTH]: 000 #fff, 050 #faf9f5, 100 #f5f4ed, 150 #f0eee6, 200 #e8e6dc, 250 #dedcd1, 300 #d1cfc5, 350 #c2c0b6, 400 #b0aea5, 450 #9c9a92, 500 #87867f, 550 #73726c, 600 #5e5d59, 650 #4d4c48, 700 #3d3d3a, 750 #30302e, 800 #262624, 850 #1f1e1d, 900 #1a1918, 950 #141413, 1000 #000. Roles: background primary gray-000, secondary 050, tertiary 150, quaternary 250; primary button background gray-950, secondary button gray-150.
- Observed type [ANTH]: body sans 16px/1.5 weight 400 (lead paragraphs 20px/1.45); h1 serif 28px/1.3 weight 400 tracking -0.01em; large display h2 serif 52px/1.12 weight 500; button 13px with 0.01em tracking, fully rounded; weights available 400/500/600/700; optical size 48 for display, 16 for text.
- Dark surfaces [ANTH, DERIVED]: bg #141413, surface #1f1e1d, surface-2 #262624, line #30302e, ink #faf9f5, muted #b0aea5.
- The proprietary faces cannot load in an Artifact (only Google Fonts and data-URI fonts are allowed) and their licence is unknown here: use the stand-ins. [ARTD][UNKNOWN licence]

## Tokens: documentation look
```css no-preview
/* Design canvas artifact [LOCAL] */
:root{ --page:#f6f6f3; --surface:#ffffff; --tint:#eeefeb; --ink:#15171c; --line:#d9dad6; --muted:#575d6b;
  --accent:#1d4ed8; --accent-tint:#eaf0ff; --accent-edge:#c3d3fa; --accent-deep:#1e3a8a;
  --font:"Inter",system-ui,sans-serif; --mono:"JetBrains Mono",ui-monospace,Consolas,monospace;
  --r-ctl:8px; --r-card:12px; --r-pill:999px }
/* README.html [LOCAL]: light on :root, dark under both dark selectors */
:root{ color-scheme:light; --bg:#ffffff; --surface:#f6f8fa; --text:#1f2328; --muted:#59636e; --border:#d1d9e0;
  --accent:#0969da; --accent-weak:#ddf4ff; --code-bg:#eff1f3; --radius:10px; --topbar-h:56px; --toc-w:300px }
@media (prefers-color-scheme:dark){ :root:not([data-theme="light"]){ color-scheme:dark; --bg:#0d1117; --surface:#151b23; --text:#e6edf3;
  --muted:#9198a1; --border:#3d444d; --accent:#58a6ff; --accent-weak:#12263f; --code-bg:#1b222c } }
:root[data-theme="dark"]{ color-scheme:dark; --bg:#0d1117; --surface:#151b23; --text:#e6edf3;
  --muted:#9198a1; --border:#3d444d; --accent:#58a6ff; --accent-weak:#12263f; --code-bg:#1b222c }
```
- README.html layout [LOCAL]; the block above shows its light/dark theme shape: sticky 56px top bar with brand, search (with match count) and theme toggle; 300px sticky TOC at >=1000px, off-canvas drawer below; document column max 920px; body 16px/1.7 system sans; focus ring `2px solid accent` offset 2px; callouts note (#0550ae on #ddf4ff), tip (#116329 on #dafbe1), important (#6639ba on #fbefff), warning (#7d4e00 on #fff8c5); shadow `0 1px 2px rgba(31,35,40,.06), 0 8px 24px rgba(31,35,40,.10)`.
- Canvas artifact [LOCAL]: five 1280px boards; inline chips by kind (`code[data-k]`): skill = blue tint with 1px blue edge, workflow = amber with dashed edge, removed = muted strikethrough; pill badges; 12px cards.

## Recipes: brand look
```css
body{background:var(--bg);color:var(--ink);font:400 1rem/1.5 var(--font-sans)}
h1,h2{font-family:var(--font-serif);font-weight:400;letter-spacing:-.01em;line-height:1.2;text-wrap:balance}
.display{font-size:clamp(2.25rem,5vw,3.25rem);line-height:1.12;font-weight:500}
.btn{border:0;border-radius:var(--radius-pill);padding:.6rem 1.1rem;font:500 .8125rem/1.5 var(--font-sans);letter-spacing:.01em;background:var(--ink);color:var(--bg);cursor:pointer}
.btn.secondary{background:var(--surface-2);color:var(--ink-2)}
a{color:var(--ink);text-decoration-color:var(--accent);text-underline-offset:.2em}   /* clay underline, ink text: small text stays at 17.5:1 */
:focus-visible{outline:2px solid var(--accent-interactive);outline-offset:2px}
.section-dark{background:#141413;color:#faf9f5}
```

## Artifact contract (summary; the full text lives in `artifact-design`)
- Author `.html`, no doctype/html/head/body; `<title>` of 2-4 words; `icon` on first publish; user's words beat the project system, which beats your choices. [ARTD]
- Theme tokens: complete palette on bare `:root`; dark redefinitions under `@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){...;color-scheme:dark}}` and `:root[data-theme="dark"]{...}`; `body{background:var(--bg)}`; dark-first designs mirror the pattern. [ARTD]
- Gutter `max(16px, env(safe-area-inset-left,0px))` both sides, no horizontal scroll at 400px, wide tables and code in their own `overflow-x:auto`. [ARTD]
- Scripts only from cdnjs (preferred), jsDelivr/npm, unpkg, Tailwind CDN, jQuery, pinned to exact versions at least two weeks old; stylesheets only from Google Fonts; everything else inlined or data URI; no `alert`/`confirm`/`prompt`, no `window.print`, no download links. [ARTD]
- Page complete at rest (no `opacity:0` waiting for scroll), hero sized to content, visible focus, `prefers-reduced-motion`. [ARTD]
- Avoid the stock AI looks unless the user asks for them: warm cream with serif display and terracotta accent; near-black with one acid pop; hairline broadsheet columns; purple-to-blue hero gradient; emoji markers; all-centered layouts; `rounded-lg` everywhere; accent rails on cards. Asking for the Anthropic brand look is asking for the first one, so it is allowed. [ARTD]
- Copy: active voice, specific over clever, controls state what happens, no em-dash asides, no "not X but Y" framing. Numbering and eyebrows only when they encode real sequence. [ARTD]

## Guardrails
- [DERIVED] Brand on #faf9f5: ink 17.50:1, #5e5d59 6.26:1, #73726c 4.58:1, #87867f 3.47:1 (fails), clay #d97757 2.96:1 and interactive clay #c6613f 3.85:1 (large text and UI only; use ink or a deeper tone for small links), olive 3.49:1, fig 3.56:1, sky 2.78:1 (decoration). Ink on clay 5.90:1 (use dark text on clay fills); ivory on clay 2.96:1; white on #c6613f 4.05:1. Secondary button #3d3d3a on #f5f4ed 9.88:1. Deep tints: #4a3aa7 on iris 6.39:1, #184f95 on periwinkle 6.12:1. Dark: ivory on #141413 17.50:1, #b0aea5 on #141413 8.29:1, clay on #141413 5.90:1.
- [DERIVED] Documentation look: artifact ink on page 16.56:1, muted 6.09:1, accent on page 6.19:1, deep blue on tint 9.08:1; README light muted 6.11:1, accent #0969da 5.19:1; README dark muted 6.50:1, accent 7.49:1.
- Boldness in one place (usually the display serif or the clay accent) and quiet everywhere else. Cards, borders and shadows by role, not on every block. Semantic status colours stay separate from the accent. [ARTD]

## Choose when / avoid when
- Choose brand look: pages about Anthropic or Claude, editorial and writing-led pages, calm product storytelling. Choose documentation look: technical references, catalogs, dashboards and tools that people scan and operate; README-style pages with a table of contents and search.
- Avoid: playful or maximal briefs; contexts where the user names a different style.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Newsreader:wght@400;500&family=Inter:wght@400;500&display=swap">
<main style="padding:32px"><h1 class="display">Calm, warm, legible.</h1><p>Ivory canvas, slate ink, one clay accent.</p><p><button class="btn">Primary</button> <button class="btn secondary">Secondary</button></p><section class="section-dark" style="padding:20px;margin-top:16px">Dark section <a href="#" style="color:#faf9f5">link</a></section></main>
```
