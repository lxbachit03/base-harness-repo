# Terrazzo (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/terrazzo.md`, last changed 3756c14 (2026-10-20), MIT; live sample usehallmark.com/themes/terrazzo/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, light paper, restrained posture: a materials library's specification voice. Off-white paper, near-black ink, wide Syne heads over a plain Onest body, JetBrains Mono for codes and millimetres, and white card surfaces ruled in 2px ink over a hard offset, holding the surfaces themselves photographed flat-on and close. [HALLMARK]
- Controls are ink; colour arrives only in aggregate, in the stone, timber, terrazzo and glaze the photographs show, with rust as the one signal. Organised like a sample drawer, it reads like a spec sheet. [HALLMARK]
- Best for: material and sample libraries, architects, interiors and showrooms, stone, timber, tile and ceramic suppliers, catalogues, specification and swatch tools.
- Not a pastel lifestyle page and not confetti.

## Tokens

```css
:root {
  --color-paper: oklch(96% 0.009 82); --color-paper-2: oklch(92% 0.012 82); --color-paper-3: oklch(87.5% 0.014 80);
  --color-plate: oklch(99.5% 0.003 82);
  --color-ink: oklch(16% 0.006 60); --color-ink-2: oklch(27% 0.006 60); --color-muted: oklch(46% 0.01 60);
  --color-rule: oklch(81% 0.012 80);
  --color-accent: oklch(53% 0.15 38); --color-accent-soft: oklch(91% 0.035 45); --color-accent-ink: oklch(99.5% 0.003 82); --color-focus: oklch(50% 0.16 38);
  --font-display: "Syne", ui-sans-serif, sans-serif; --font-body: "Onest", ui-sans-serif, sans-serif;
  --font-outlier: "JetBrains Mono", ui-monospace, monospace;
  --radius-card: 0; --radius-pill: 0; --rule-hair: 1px; --rule-bar: 2px;
  --shadow-card: 14px 14px 0 var(--color-paper-3); --shadow-card-hover: 14px 14px 0 var(--color-ink);
  --tracking-display: -0.025em; --display-weight: 700;
}
```

Colourways [HALLMARK]: Off-white is the default above. Black: paper `oklch(14% 0.005 60)` under bone ink `oklch(96% 0.01 80)`, cards stay white, rust lifts to `oklch(68% 0.14 40)`, controls turn bone with ink text. Stone: warm grey paper `oklch(85% 0.012 80)` under the same ink, rust, ink controls.

```css no-preview
:root[data-colourway="black"] { --color-paper: oklch(14% 0.005 60); --color-ink: oklch(96% 0.01 80); --color-accent: oklch(68% 0.14 40); }
:root[data-colourway="stone"] { --color-paper: oklch(85% 0.012 80); }
```

- Type [HALLMARK]: Syne 700 for display (`--tracking-display`, line-height 1.0, sentence case); the face sets wide, so heads stay short instead of dropping a step; 800 turns clumsy and is never used; a figure at display size takes -0.04em. Body Onest 400 and 500, line-height 1.5; three weights a page: 400, 500, 700. Labels, captions, table heads: Onest 500 one step smaller, sentence case, untracked. Codes and measures: JetBrains Mono 500 for a sample code (`ST-0412`), a size in millimetres, a count in a table, at the size of the text beside it, never a label or a head.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700&family=Onest:wght@400;500&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Syne (vietnamese no), Onest (vietnamese yes), JetBrains Mono (vietnamese yes). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Syne, so accents fall back glyph by glyph. For a Vietnamese page swap Syne to Lexend.
- The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- Rules: `--rule-bar` (2px) ink on the top of a table, along a band's edge and around a card; `--rule-hair` in `--color-rule` between rows. Radius 0 everywhere, photographs included.
- The card: `--color-plate` inside a 2px ink border over the hard `--shadow-card` (paper-3, no blur); it is the page's one container and nothing else casts. A linked card swaps its offset to ink on hover over `--dur-micro`.
- Bands: a `--color-ink` band with paper text, or a `--color-paper-2` band; never a coloured field; two a page at most.
- Photographs: the surface itself, flat-on and close in even daylight so grain, chips, veins and joints read near one to one; a set of four runs as a true set at one ratio; true colour, a little sharpened. Each sits in a card, edge to edge, with a caption beneath naming the family and the finish; type never sits on a photograph. No texture and nothing drawn on the paper: the surfaces in the photographs are the pattern.
- Compositions: a specification table under a 2px ink rule (the code and size in mono, the name in Onest 500 at title size, family and finish muted, a hovered or selected row on `--color-accent-soft` with a rust code); the library's one big number in Syne at twice `--text-display`, paper on ink, beside a short ruled list; steps hung from hairlines with each numeral in Syne at section size; a booking form as a request card with square inputs on the plate colour and choices as square cells joined edge to edge, the checked cell ink with paper text.
- Controls: an ink-filled primary with paper text beside a 2px inset ink outline, both square, Onest 500; on the ink band the primary turns plate with ink text. Links are ink with a hairline underline that turns rust on hover; inputs are square on `--color-plate` with a 1px ink border. Rust reaches only a code, a selected row or chip, a hover underline and the focus ring. Motion: still, apart from the card's offset swap and a filtered row that leaves without animation. Voice: a catalogue's plainness (family, finish, code, size at one to one); it never sells the feeling of stone.

## Component recipes

```css
h1, h2, h3 { font-weight: 700; line-height: 1; }
.btn { border: 0; border-radius: 0; padding: var(--space-md) var(--space-lg); background: transparent; font-weight: 500; color: inherit; }
.btn--primary { background: var(--color-ink); color: var(--color-paper); }
.btn--secondary { box-shadow: inset 0 0 0 var(--rule-bar) currentColor; }
.card { background: var(--color-plate); border: var(--rule-bar) solid var(--color-ink); box-shadow: var(--shadow-card); }
a.card { transition: box-shadow var(--dur-micro) var(--ease-out); }
a.card:hover { box-shadow: var(--shadow-card-hover); }
.band--ink { background: var(--color-ink); color: var(--color-paper); }
.band--ink .btn--primary { background: var(--color-plate); color: var(--color-ink); }
.spec { border-top: var(--rule-bar) solid var(--color-ink); } .spec tr:hover { background: var(--color-accent-soft); } .spec tr:hover .code { color: oklch(48% 0.15 38); }
.code { font-family: var(--font-outlier); font-weight: 500; font-variant-numeric: tabular-nums; }
::selection { background: color-mix(in oklab, var(--color-accent) 25%, transparent); }
.input { min-height: 48px; padding: 0 var(--space-md); border: var(--rule-hair) solid var(--color-ink); border-radius: 0; background: var(--color-plate); color: var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 17.24:1 (AAA); muted on paper 6.34:1 and on plate 7.02:1; ink on paper-3 13.30:1; paper on an ink band 17.24:1; rust code or hover underline on paper 5.02:1, but only 4.29:1 on the selected-row tint, so a code on a selected row takes the darker rust `oklch(48% 0.15 38)` (5.33:1) [DERIVED]; the plate-coloured label on rust, if rust is ever a fill, 5.56:1; focus ring on paper 5.76:1.
- [HALLMARK] Never a drawn chip, speck or confetti; a surface's colour comes from its photograph. Never a photograph as a background or under type: it lives in a card. Never a coloured primary on off-white paper: controls are ink. Never a rounded corner on a card, a control or a photograph.
- [HALLMARK] Three weights a page (400, 500, 700); Syne 800 is never used.
- [HALLMARK] Nothing but the card casts a shadow, and its offset is hard (no blur).

## Choose when / avoid when
- Choose: catalogue and specification products where the material itself is the picture: stone, timber, tile, ceramics, fabrics, finishes, sample drawers, showrooms, architects and interiors suppliers.
- Avoid: playful consumer brands, soft or rounded interfaces, dark-first pages, products with no photographs of real surfaces.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700&family=Onest:wght@400;500&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.2rem,9vw,3.4rem)}table{width:100%;border-collapse:collapse}td{padding:var(--space-sm) 0;border-bottom:var(--rule-hair) solid var(--color-rule)}</style>
<main class="container" style="display:grid;gap:var(--space-lg);padding-block:var(--space-lg)">
<h1>Surfaces, specified.</h1><p class="lead">Every sample in the drawer, with its code and size.</p>
<div class="row"><button class="btn btn--primary">Request samples</button><button class="btn btn--secondary">Browse the drawer</button></div>
<a class="card" href="#" style="display:grid;color:inherit;text-decoration:none"><div style="aspect-ratio:16/9;background:linear-gradient(135deg,var(--color-paper-3),var(--color-paper-2))"></div><div style="padding:var(--space-md)"><b>Honed marble chip</b><br><span class="code">ST-0412, 600 x 600 mm</span></div></a>
<table class="spec"><tr><td class="code">ST-0412</td><td>Marble chip</td><td class="code">600 mm</td></tr><tr><td class="code">TB-0108</td><td>Smoked oak</td><td class="code">1200 mm</td></tr></table>
</main>
```
