# Ink (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/ink.md`, last changed 3756c14 (2026-10-20), MIT; live sample usehallmark.com/themes/ink/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Editorial genre, light paper, restrained posture: a notice printed in plain black. White paper, a black with no hue, Epilogue at 700 for the head and 400 for everything you read, hairline rules, and one teal that means in or open. Its photographs show the things on the shelves, in daylight with the colour turned down. It feels competent, local and kind, like a well-run community desk. [HALLMARK]
- Best for: libraries and lending schemes, community and civic services, notice boards, rotas and volunteer desks, non-profits, memberships and local events, repair cafes and tool libraries.
- Not a cold corporate monochrome and not a warm cream editorial page.

## Tokens

```css
:root {
  --color-paper: oklch(99.5% 0.003 100); --color-paper-2: oklch(97% 0.004 100); --color-paper-3: oklch(94% 0.006 100);
  --color-ink: oklch(16% 0 0); --color-ink-2: oklch(28% 0 0); --color-muted: oklch(44% 0 0);
  --color-rule: oklch(89% 0.004 100); --color-rule-2: oklch(93.5% 0.003 100);
  --color-accent: oklch(50% 0.095 188); --color-accent-ink: oklch(99.5% 0.003 100); --color-accent-soft: oklch(93% 0.05 190); --color-accent-soft-ink: oklch(27% 0.045 190);
  --color-focus: oklch(50% 0.095 188);
  --font-display: "Epilogue", ui-sans-serif, system-ui, sans-serif; --font-body: var(--font-display);
  --font-outlier: "IBM Plex Mono", ui-monospace, monospace;
  --radius-card: 12px; --radius-pill: 999px; --rule-hair: 1px;
  --shadow-card: 0 20px 40px oklch(20% 0 0 / 0.16);
  --tracking-display: -0.04em; --display-weight: 700;
}
```

Colourways [HALLMARK], both light: `paper` is the default above. `board`: notice-board yellow ground `oklch(93% 0.10 95)` with rules at `oklch(84% 0.10 92)`, ink `oklch(20% 0.02 80)`, teal deepened to `oklch(46% 0.078 190)`; wells and tags turn white.

```css no-preview
:root[data-colourway="board"] { --color-paper: oklch(93% 0.10 95); --color-rule: oklch(84% 0.10 92); --color-ink: oklch(20% 0.02 80); --color-accent: oklch(46% 0.078 190); }
```

- Type [HALLMARK]: Epilogue 700 for display (`--tracking-display`, line-height 1.0 at hero size and 1.05 below, sentence case, roman); a figure (a count, a price, an hour) takes the same setting, a step larger than the head beside it. Body Epilogue 400 at 16 to 17px, line-height 1.55, in `--color-ink-2` (muted greys tire on white); the name in a row, links and tags at 600. Labels, captions, table heads and meta: Epilogue 400 one step smaller, sentence case, untracked, never mono. IBM Plex Mono only inside code and on figures that compare in a column (loan counts, a card number, times on a rota). Large figures and prices are Epilogue 700 in ink; teal marks only what is in or open.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;600;700&family=IBM+Plex+Mono:wght@400&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Epilogue (vietnamese yes), IBM Plex Mono (vietnamese yes).
- The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- Rules: a list or table opens on a 1px `--color-ink` rule and continues on `--color-rule` hairlines between rows; `--color-rule-2` parts quieter rows. Radius 12px on wells and photographs, 10px on controls and inputs, pills on tags.
- Flat paper: a well is `--color-paper-2` with a 1px `--color-rule` edge; `--shadow-card` sits only under something that floats over the page (a menu, a dialog), never under a surface at rest. Bands: a `--color-paper-2` band or an ink band with paper text; two a page at most; never a teal field. No texture.
- Photographs: the things and the street that shares them, in plain daylight at arm's length (a pegboard of tools, a ladder against a wall, a neighbour carrying something home, seen from behind); no face to the lens and no brand mark to the camera. The colour is turned down so the teal stays the one colour that means anything; 12px radius, a 1px `--color-rule` hairline, no shadow; a thing's name and its state tag sit under its picture, never on it.
- Compositions: the shelf as a ruled list (every thing a row under the ink rule, its name at 600, one line on what it is, its state pill at the row's end, a filter field that narrows rows as you type); steps as a notice (three or four numbered stages across the columns, each numeral in Epilogue 700 at display size over a hairline, the current stage carrying the pale teal pill); a timetable of opening days (rows of dates and hours, the next one inked, dates read from the clock); figures in plain black (a count, a fee and the hours set large on a `--color-paper-2` well, the one that means open in teal).
- Controls: an ink-filled button with paper text beside a 1px `--color-rule` bordered button on `--color-paper-2`, both at 10px radius in Epilogue 600. Tags carry state and nothing else: in is pale teal (`--color-accent-soft`) with `--color-accent-soft-ink`, out is outlined in the rule colour, on is ink-filled. Teal means in or open: a tag, a large figure, a link's hover, the focus ring. Links are ink at 600, underlined, teal on hover.
- Motion: nothing moves but state (a filter applies as you type, a tag changes on click, an underline turns teal over `--dur-micro`); no marquee, reveal or counter. Voice: the desk volunteer's, what is in, when it is back, who is on Saturday; short, kind, exact, never institutional.

## Component recipes

```css
h1, h2, h3 { font-weight: var(--display-weight); line-height: 1.02; }
.btn { border: var(--rule-hair) solid var(--color-rule); border-radius: 10px; padding: var(--space-sm) var(--space-md); font-weight: 600; background: var(--color-paper-2); color: var(--color-ink); }
.btn--primary { background: var(--color-ink); border-color: var(--color-ink); color: var(--color-paper); }
.tag { display: inline-flex; padding: var(--space-2xs) var(--space-sm); border-radius: var(--radius-pill); font-size: var(--text-xs); font-weight: 600; background: var(--color-paper-3); }
.tag--in { background: var(--color-accent-soft); color: var(--color-accent-soft-ink); }
.tag--out { background: transparent; box-shadow: inset 0 0 0 var(--rule-hair) var(--color-rule); color: var(--color-muted); }
.tag--on { background: var(--color-ink); color: var(--color-paper); }
.ruled { border-top: var(--rule-hair) solid var(--color-ink); } .ruled > * { border-bottom: var(--rule-hair) solid var(--color-rule); }
.well { background: var(--color-paper-2); border: var(--rule-hair) solid var(--color-rule); border-radius: var(--radius-card); }
.photo { border-radius: var(--radius-card); outline: var(--rule-hair) solid var(--color-rule); outline-offset: -1px; }
a { font-weight: 600; } a:hover { text-decoration-color: var(--color-accent); }
::selection { background: var(--color-accent-soft); color: var(--color-accent-soft-ink); }
.input { min-height: 48px; padding: 0 var(--space-md); border: var(--rule-hair) solid var(--color-muted); border-radius: 10px; background: var(--color-paper); color: var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 19.12:1 (AAA); ink-2 body on paper 14.31:1; muted on paper 7.69:1 and on a well 7.17:1; the in tag, `--color-accent-soft-ink` on `--color-accent-soft` 12.31:1; paper on the on tag (ink) 19.12:1; teal link hover or large figure on paper 5.55:1; teal focus ring on paper 5.55:1; paper label on a teal fill 5.55:1.
- [HALLMARK] Never a second colour: teal means in and out is an outline, never red. Never a warm black: the ink has zero chroma, so the page's greys stay neutral. Never a teal field or teal running text: teal is a state, not a surface. Never a resting shadow: the paper stays flat.
- [HALLMARK] Muted greys are avoided for running text on white; body text takes `--color-ink-2`.

## Choose when / avoid when
- Choose: community, civic and non-profit services where the page is a clear, kind notice: libraries, lending schemes, rotas, memberships, local events.
- Avoid: luxury or playful brands, dark-first pages, warm editorial storytelling, products that need more than one status colour.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;600;700&family=IBM+Plex+Mono:wght@400&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}.line{display:flex;justify-content:space-between;align-items:center;padding:var(--space-sm) 0}h1{font-size:clamp(2.2rem,9vw,3.4rem)}</style>
<main class="container" style="display:grid;gap:var(--space-lg);padding-block:var(--space-lg)">
<h1>Borrow tools, don't buy them.</h1><p class="lead" style="color:var(--color-ink-2)">Open Saturdays, 10 to 2. Sign up at the desk.</p>
<div class="row"><button class="btn btn--primary">Join the library</button><button class="btn">See what is in</button></div>
<div class="ruled"><div class="line"><b>Cordless drill</b><span class="tag tag--in">In</span></div><div class="line"><b>Ladder, 3 m</b><span class="tag tag--out">Out</span></div><div class="line"><b>Hedge trimmer</b><span class="tag tag--on">On loan</span></div></div>
<div class="well" style="padding:var(--space-lg)"><b style="font-size:var(--text-display-s);letter-spacing:-.04em;line-height:1">Open Saturday</b><br>Back at the desk from 10:00</div>
</main>
```
