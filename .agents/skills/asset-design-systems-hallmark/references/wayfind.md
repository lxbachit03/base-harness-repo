# Wayfind (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/wayfind.md`, last changed 3756c14 (2026-10-20), MIT; live sample usehallmark.com/themes/wayfind/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, light cool paper, committed posture: public signage set as a page. Cool grey paper, blue-black ink, every glyph in Chivo Mono (a sober grotesk cut to the fixed cell of a departure board), square 2px ink borders, ink plates that carry a sign, cobalt for what is live and amber for figures. The mono is the board's face and the borders mark the way. It reads in daylight, at a glance, from three metres. [HALLMARK]
- Best for: transit, metro and rail, stations and wayfinding, departures and timetables, live status and operations, logistics, travel itineraries, bookings, flights and airports.
- Not a developer tool, a dark terminal or a retro departures pastiche.

## Tokens

```css
:root {
  --color-paper: oklch(95.5% 0.006 250); --color-paper-2: oklch(91% 0.009 250); --color-paper-3: oklch(99.5% 0.005 250);
  --color-ink: oklch(16% 0.014 262); --color-ink-2: oklch(29% 0.014 262); --color-muted: oklch(47% 0.016 260);
  --color-rule: oklch(80% 0.011 250); --color-ink-rule: oklch(34% 0.014 262);
  --color-accent: oklch(51% 0.22 264); --color-accent-2: oklch(81% 0.16 82); --color-accent-ink: oklch(99.5% 0.003 250); --color-focus: oklch(51% 0.22 264);
  --font-display: "Chivo Mono", ui-monospace, monospace; --font-body: var(--font-display); --font-outlier: var(--font-body);
  --radius-card: 0; --radius-pill: 999px; --rule-hair: 1px; --rule-bar: 2px;
  --shadow-card: 0 24px 40px -24px oklch(8% 0.01 260 / 0.6);
  --tracking-display: -0.03em; --display-weight: 800;
}
```

Colourways [HALLMARK], set once per page: `platform` is the default above. `night`: paper `oklch(15% 0.012 262)`, ink `oklch(96% 0.005 250)`, rule `oklch(31% 0.014 262)`, cobalt lifting to `oklch(62% 0.2 264)`. `signal`: paper is the cobalt `oklch(51% 0.22 264)`, ink white, rule `oklch(75% 0.12 264)`, and the cobalt button becomes the ink one.

```css no-preview
:root[data-colourway="night"] { --color-paper: oklch(15% 0.012 262); --color-ink: oklch(96% 0.005 250); --color-rule: oklch(31% 0.014 262); --color-accent: oklch(62% 0.2 264); }
:root[data-colourway="signal"] { --color-paper: oklch(51% 0.22 264); --color-ink: oklch(100% 0 0); --color-rule: oklch(75% 0.12 264); }
```

- Type [HALLMARK]: Chivo Mono 800 for display (`--tracking-display`, line-height 0.98, sentence case); a mono line runs wide, so `h1` caps at 4.75rem and a head stays short enough to read in one look. Body Chivo Mono 400, line-height 1.55, `tabular-nums` on everything; mono is the material, the board's face sets the whole page. Three weights: 400, 500 and 800. Figures (minutes, platforms, exits) in 800 at `--text-display-s` or larger when a figure is the section's reason: amber on ink, ink on paper. Labels, table heads, pills and buttons: Chivo Mono 500 one step smaller (buttons 800), sentence case, untracked; the signage reads through the mono and the borders, never through capitals.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Chivo+Mono:wght@400;500;800&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Chivo Mono (vietnamese yes).
- Wayfind is light by default; for the `night` colourway add the foundation's dark error and success pair. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- Rules: `--rule-bar` (2px) ink borders on every surface (wells, plates, buttons, the underside of a nav, a table's head rule); row dividers `--rule-hair` in `--color-rule`, or `--color-ink-rule` on ink. Radius 0 everywhere except pills; depth is borders, and `--shadow-card` only under a surface that floats over another. No texture, no gradient.
- The plate: a square field of ink (or amber under ink text) inside a 2px border, holding one instruction and its figure, the way a sign holds a platform number. Bands: `--color-paper-2`, an `--color-ink` band where figures turn amber, or one cobalt field in the `signal` colours; two a page at most.
- Photographs: the network at eye level (platforms, tiled walls, a train in, stairs up to daylight), people only from behind and moving; square, inside the 2px ink border; type never sits on the picture, only on a plate inside the frame; captions name the station or the line. A phone screen built from the product takes a 9:19.5 frame in that border, never a drawn bezel.
- Compositions: a departure board as a table on the ink band (destination in 500, the line as a small square in the network's own colour, minutes in 800 amber at title size or larger, a late row as an amber fill under ink text, a 2px paper head rule); a route as steps (three or four plates in a row, each a 2px bordered square holding one instruction and its figure, joined by a 2px ink rule like a corridor sign); status as rows (a full-width row per line or service with its swatch, name in 800, ends in 400, state at the right edge, one cobalt live dot on the row that just changed); a figure as a sign (one number in 800 at display size inside a bordered plate, its unit beside it, and a station picker of square cells joined edge to edge).
- Controls: a cobalt-filled button beside a transparent one with a 2px ink border, both square, Chivo Mono 800, sentence case, 48 to 52px. A choice set is square cells sharing 2px borders, the chosen cell filled ink with paper text. Links are ink, underlined, cobalt on hover; inputs are square with a 2px ink border on `--color-paper-3`. Cobalt is for what is live (the current stop, a clock, the primary action); amber colours figures only on ink or as a fill under ink text.
- Motion: departure-board stiff, `--dur-micro` colour changes in `steps(1)`, rows updating in place, no reveal on scroll; a live dot blinks once when a row updates and never loops. Voice: signage (the platform, the exit, the minute, the carriage), imperative and short.

## Component recipes

```css
body { font-variant-numeric: tabular-nums; }
h1, h2, h3 { font-weight: 800; line-height: 0.98; }
h1 { font-size: min(var(--text-display), 4.75rem); }
small, th, figcaption { font-weight: 500; color: var(--color-muted); }
.btn { display: inline-flex; align-items: center; gap: var(--space-xs); padding: var(--space-md) var(--space-lg); border: var(--rule-bar) solid currentColor; background: transparent; font: 800 var(--text-sm)/1 var(--font-body); color: inherit; transition: background-color var(--dur-micro) steps(1); }
.btn--primary { background: var(--color-accent); border-color: var(--color-accent); color: var(--color-accent-ink); }
.plate { border: var(--rule-bar) solid var(--color-ink); background: var(--color-ink); color: var(--color-paper); }
.plate .figure { font-weight: 800; color: var(--color-accent-2); }
.band--ink { background: var(--color-ink); color: var(--color-paper); }
th { border-bottom: var(--rule-bar) solid currentColor; } td { border-bottom: var(--rule-hair) solid var(--color-rule); }
::selection { background: var(--color-accent-2); color: var(--color-ink); }
.cell { padding: var(--space-sm) var(--space-md); border: var(--rule-bar) solid var(--color-ink); margin-left: calc(-1 * var(--rule-bar)); background: transparent; font-weight: 500; color: var(--color-ink); }
.cell[aria-pressed="true"] { background: var(--color-ink); color: var(--color-paper); }
.input { min-height: 48px; padding: 0 var(--space-md); border: var(--rule-bar) solid var(--color-ink); border-radius: 0; background: var(--color-paper-3); color: var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 17.01:1 (AAA); ink-2 on paper 12.40:1; muted on paper 5.97:1; paper on an ink plate 17.01:1; amber figures on ink 10.63:1; ink on an amber fill 10.63:1; paper label on the cobalt button 6.02:1; cobalt link hover or live dot on paper 5.33:1. Amber on the paper is 1.60:1 (fail), so amber stays on ink or under ink text.
- [HALLMARK] Never a proportional face anywhere, not even for prose. Never amber as a text colour on the paper. Never a third bright colour, except a network's own line colours as small squares beside their names. Never rounded cards or soft shadows on cards: Wayfind is bordered. Never a drawn platform, train or carriage row standing in for the place: photograph the station, build the screen.
- [HALLMARK] `h1` caps at 4.75rem; three weights only (400, 500, 800).

## Choose when / avoid when
- Choose: transit, travel and logistics products where the page is a sign read at a glance: departures, status boards, itineraries, bookings, operations.
- Avoid: soft or playful brands, long-form editorial, dark-first developer tools, anything that needs a proportional text face.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Chivo+Mono:wght@400;500;800&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2rem,8vw,3rem)}table{width:100%;border-collapse:collapse}th,td{padding:var(--space-sm);text-align:left}</style>
<main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Platform 4, two minutes.</h1><p>Live departures from Central.</p>
<div class="row"><button class="btn btn--primary">Plan a trip</button><button class="btn">Live board</button></div>
<div class="band--ink"><table><tr><th>To</th><th>Plat</th><th>Min</th></tr><tr><td>Harbour</td><td>4</td><td class="figure" style="color:var(--color-accent-2);font-weight:800">2</td></tr><tr><td>Airport</td><td>1</td><td class="figure" style="color:var(--color-accent-2);font-weight:800">7</td></tr></table></div>
<div class="plate" style="padding:var(--space-md)"><span class="figure" style="font-size:var(--text-display-s)">Exit B</span> stairs up</div>
<div><button class="cell" aria-pressed="true">Central</button><button class="cell" aria-pressed="false">Harbour</button></div>
</main>
```
