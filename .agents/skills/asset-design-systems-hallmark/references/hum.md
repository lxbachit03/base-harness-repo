# Hum (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/hum.md`, last changed 45af70a (2026-10-21), MIT; live sample usehallmark.com/themes/hum/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Playful genre, light paper, full-palette posture: cut paper made by hand, cheerful without turning childish. Cream paper with visible grain and fibre, torn edges that show a paler core, card-stock controls that sink when pressed, one light from the top left. [HALLMARK]
- One rounded sans, Chillax, carries every role in blue-black ink. Three accents never blend: pear yellow for the action, blue for links and focus, coral for one loud moment; mint stands for growth. [HALLMARK]
- Best for: daily habits and streaks, learning and reading practice, kids and family, school, games and puzzles, community, creative tools.
- Not a pastel nursery template, a rainbow page or clip-art.

## Tokens

```css
:root {
  --color-paper: oklch(97% 0.012 95); --color-paper-2: oklch(94.5% 0.018 95); --color-paper-3: oklch(91% 0.022 95);
  --color-ink: oklch(20% 0.014 255); --color-ink-2: oklch(29% 0.014 255); --color-muted: oklch(47% 0.014 255);
  --color-rule: oklch(87% 0.016 95);
  --color-accent: oklch(87% 0.175 96); --color-accent-deep: oklch(72% 0.16 92); --color-accent-ink: oklch(20% 0.014 255);
  --color-accent-2: oklch(50% 0.17 250); --color-accent-3: oklch(70% 0.2 22);
  --color-mint: oklch(82% 0.15 152); --color-mint-deep: oklch(48% 0.12 155); --color-focus: oklch(50% 0.17 250);
  --color-card: oklch(98.8% 0.007 95); --color-edge: oklch(83% 0.04 88); --color-fringe: oklch(99.2% 0.006 95);
  --color-kraft: oklch(63% 0.085 62); --color-sand: oklch(77% 0.1 76); --color-sugar: oklch(89% 0.035 236);
  --color-hill-1: oklch(94.5% 0.03 118); --color-hill-2: oklch(91.5% 0.045 135); --color-leaf: oklch(64% 0.15 150);
  --font-display: "Chillax", ui-rounded, ui-sans-serif, sans-serif; --font-body: var(--font-display);
  --font-outlier: "Geist Mono", ui-monospace, monospace;
  --radius-card: 24px; --radius-stock: 16px; --radius-input: 14px; --radius-pill: 999px; --rule-hair: 1px;
  --shadow-card: 0 1px 2px oklch(20% 0.014 255 / 0.06), 0 12px 28px -14px oklch(20% 0.014 255 / 0.22);
  --shadow-paper: drop-shadow(0 0 0.6px oklch(20% 0.014 255 / 0.32)) drop-shadow(1.5px 2.5px 1.5px oklch(20% 0.014 255 / 0.1)) drop-shadow(6px 14px 16px oklch(20% 0.014 255 / 0.13));
  --tracking-display: -0.03em; --display-weight: 600;
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1); --ease-snap: cubic-bezier(0.22, 1, 0.36, 1);
}
```

- Type [HALLMARK]: Chillax 600 for display (`--tracking-display`, line-height 1.02 to 1.05) and 500 for body at 17 to 19px, line-height 1.5; only those two weights, sentence case; labels, captions and units one step smaller in `--color-muted`; Geist Mono only inside code. Emphasis is a pear highlighter band behind the words, never inside a head. A figure sets at `--text-display` or larger with its unit beneath at `--text-title`.
- Fonts [HALLMARK]: the source loads them with `<link href="https://api.fontshare.com/v2/css?f[]=chillax@500,600&display=swap" rel="stylesheet">`. Fontshare is not an allowed Artifact host: Chillax (substitute Quicksand, vietnamese yes) [DERIVED]; Fontshare's own vietnamese coverage was not measured.
- The source names `--grain` and `--fibre` (generated textures) without defining them; the recipes below define stand-ins as inline SVG [DERIVED]. The shared `--space-*`, `--text-*`, `--dur-*` and `--ease-out` tokens come from [foundation](foundation.md).

## Surfaces and range
- Paper is generated, never a picture: a fine grain plus a long fibre under every paper, card and accent fill. Sheets end in a torn edge whose paler core (`--color-fringe`) stands a pixel proud beneath it. Grounds may layer far hills (`--color-hill-1`, `--color-hill-2`), soil (`--color-leaf`), a kraft strip and a blue sugar-paper mat.
- Light comes from the top left: shadows fall down and right on every cut sheet (`--shadow-paper`), a card may lift one corner in a page curl. Everything is round: 24px surfaces (28 to 32px for children's products), 16px card stock, 14px inputs, no square corner.
- Bands are paper-2, a torn ink sheet with paper-coloured text, or one pear field; two a page at most. Photographs: bright daylight at a child's height, never a face to camera, torn on one edge, one or two a page.
- Compositions it carries without a photograph: the product built large as card-stock tiles on a torn kraft strip; growth drawn as plants made of Chillax glyphs on torn soil; three or four numbers at display size on one pear sheet, each unit beneath; a choice as card-stock pills whose result sentence highlights its key value.
- Each accent owns one job: pear the primary action and the one pear field, blue links and the focus ring, coral one loud fill, mint growth. A chosen pill is ink with paper-coloured type. One die-cut sticker may carry the offer.
- Motion: the spring easing runs on the primary control only, everything else on `--ease-snap`, never `scale()`. A word pops in its accent; a timer may tear off a scrap of paper while it runs, paused off screen. Reduced motion or no script shows the end state. Voice: warm, smart, casual, direct, written to the grown-up beside the child; verbs over nouns, honest numbers.

## Component recipes

```css
:root {
  --grain: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='g' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='2' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .32 0 0 0 0 .26 0 0 0 0 .16 0 0 0 .6 -.24'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23g)'/%3E%3C/svg%3E");
  --fibre: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='240' height='240'%3E%3Cfilter id='f' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.012 .6' numOctaves='2' seed='4' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 1 0 0 0 0 .98 0 0 0 0 .92 0 0 0 .75 -.32'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23f)'/%3E%3C/svg%3E");
  --torn: polygon(0 0, 100% 0, 100% calc(100% - 6px), 97% calc(100% - 3px), 94.5% calc(100% - 8px), 91.5% calc(100% - 4px), 88% calc(100% - 9px), 85% calc(100% - 5px), 82% calc(100% - 3px), 79% calc(100% - 7px), 75.5% calc(100% - 10px), 72% calc(100% - 6px), 69% calc(100% - 4px), 65.5% calc(100% - 8px), 62% calc(100% - 5px), 58.5% calc(100% - 2px), 55% calc(100% - 6px), 51.5% calc(100% - 9px), 48% calc(100% - 5px), 45% calc(100% - 3px), 41.5% calc(100% - 7px), 38% calc(100% - 10px), 34.5% calc(100% - 6px), 31% calc(100% - 4px), 27.5% calc(100% - 8px), 24% calc(100% - 4px), 21% calc(100% - 2px), 17.5% calc(100% - 6px), 14% calc(100% - 9px), 11% calc(100% - 5px), 8% calc(100% - 3px), 5% calc(100% - 7px), 2% calc(100% - 4px), 0 calc(100% - 6px));
}
h1, h2, h3 { font-weight: var(--display-weight); }
a { color: var(--color-accent-2); }
mark { background: color-mix(in oklab, var(--color-accent) 55%, transparent); color: inherit; box-decoration-break: clone; }
.btn { --edge: 5px; border: 0; border-radius: var(--radius-stock); min-height: 54px; padding: 0 var(--space-lg); font-weight: 600; color: var(--color-ink); background: var(--grain), var(--fibre), var(--color-card); box-shadow: inset 0 0 0 1px var(--color-rule), 0 var(--edge) 0 0 var(--color-edge); transition: translate var(--dur-micro) var(--ease-snap), box-shadow var(--dur-micro) var(--ease-snap); }
.btn--primary { background: var(--grain), var(--fibre), var(--color-accent); color: var(--color-accent-ink); box-shadow: 0 var(--edge) 0 0 var(--color-accent-deep), 2px calc(var(--edge) + 4px) 10px -3px color-mix(in oklab, var(--color-ink) 32%, transparent); transition-timing-function: var(--ease-spring); }
.btn:hover { --edge: 7px; translate: 0 -2px; } .btn:active { --edge: 1px; translate: 0 4px; }
.sheet { position: absolute; inset: 0; filter: var(--shadow-paper); }
.sheet > b, .sheet > i { position: absolute; inset: 0; clip-path: var(--torn); }
.sheet > b { background: var(--color-fringe); translate: 0 2px; }
.sheet > i { background: var(--grain), var(--fibre), var(--sheet-c, var(--color-paper-3)); }
.card { padding: var(--space-lg); border-radius: var(--radius-card); background: var(--grain), var(--color-card); box-shadow: var(--shadow-card); }
.pill { min-height: 44px; padding: 0 var(--space-md); border: 0; border-radius: var(--radius-pill); font-weight: 500; color: var(--color-ink); background: var(--grain), var(--fibre), var(--color-card); box-shadow: inset 0 0 0 1px var(--color-rule), 0 3px 0 var(--color-edge); }
.pill[aria-pressed="true"] { background: var(--color-ink); color: var(--color-paper); box-shadow: none; }
.field { min-height: 52px; padding: 0 var(--space-md); border: var(--rule-hair) solid var(--color-muted); border-radius: var(--radius-input); background: var(--color-card); color: var(--color-ink); }
.pear { background: var(--grain), var(--fibre), var(--color-accent); color: var(--color-accent-ink); border-radius: var(--radius-card); padding: var(--space-lg); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.61:1 (AAA); muted label on paper 6.26:1 and on card 6.60:1; accent-ink on the pear primary 12.26:1; blue link or focus ring on paper 5.39:1; paper-coloured type on an ink pill or sheet 16.61:1; ink on a coral fill 6.08:1; ink on mint 11.04:1. Coral on paper is 2.73:1 (fail), so coral stays a fill and never becomes type.
- [HALLMARK] Never a serif, pure white paper or a square corner. Never a clean vector edge on a cut sheet, a shadow that falls up or left, a gradient between two accents or a rainbow ground. Never emoji, stock icons or a drawn character; type, paper and the product carry the visuals.
- [HALLMARK] Press feel: `--edge` is 5px at rest, 7px on hover (`translate: 0 -2px`) and 1px pressed (`translate: 0 4px`); controls are 54px tall, inputs 52px.
- [DERIVED] The torn edge, grain and fibre above are static stand-ins for upstream's generated textures: keep them as backgrounds under text, use the page's own seeds for variety, and give two sheets on one page different polygons.
- [HALLMARK] Two bands a page at most; links are the blue accent; the highlighter band never sits inside a head.

## Choose when / avoid when
- Choose: a product that feels like play and practice (habits, learning, reading, mood, kids and family, school, games, community, creative tools) and can carry a tactile, handmade page.
- Avoid: serious finance or compliance, dense data tables, dark mode requests, anything that needs a clinical or luxury register.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://api.fontshare.com/v2/css?f[]=chillax@500,600&display=swap" rel="stylesheet">
<style>body{font-weight:500;line-height:1.5}.hero{position:relative;padding-block:var(--space-lg) calc(var(--space-xl) + 12px)}.hero>.container{position:relative;display:grid;gap:var(--space-md);justify-items:start}.hero h1{font-size:clamp(2.1rem,8vw,3.2rem)}.row{display:flex;gap:var(--space-sm);flex-wrap:wrap}</style>
<div class="hero"><div class="sheet"><b></b><i style="--sheet-c:var(--color-paper-2)"></i></div><div class="container"><nav class="row" style="justify-content:space-between;width:100%"><b>hum</b><a href="#">Log in</a></nav><h1>Ten minutes a day, <mark>kept</mark></h1><p class="lead">A small practice for the whole family. Start tonight.</p><div class="row"><button class="btn btn--primary">Start today</button><button class="btn">See a streak</button></div></div></div>
<div class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-md)"><div class="card"><h3>Reading streak</h3><p>12 days in a row. <a href="#">Add a day</a></p></div><div class="row"><button class="pill" aria-pressed="true">Mornings</button><button class="pill" aria-pressed="false">Evenings</button></div><div class="pear"><h3 style="font-size:var(--text-display-s)">12</h3><p>days kept</p></div></div>
```
