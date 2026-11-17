# Furrow (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/furrow.md`, last changed 3d760dd (2026-10-21), MIT; live sample usehallmark.com/themes/furrow/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, light paper, committed posture: a working-records voice drawn on the land itself. Warm manila paper, near-black ink, and the place of the work generated as a survey map (contours, hedges, walls, water, the holding edged in tangerine like a title plan) with records pinned where they happened. [HALLMARK]
- Entries open as waterproof notebook pages; the rest is ruled lists, figures with their units and moulded keys. Tangerine is ear tag and baler twine; green means in date. [HALLMARK]
- Best for: farm, livestock and crop records, compliance and inspection, field service and fleet work, rural contractors, anything counted in units and dates.
- Not a pastoral lifestyle page, a glossy dashboard or a sat-nav.

## Tokens

```css
:root {
  --color-paper: oklch(96% 0.011 85); --color-paper-2: oklch(99.5% 0.005 85); --color-paper-3: oklch(92% 0.016 85);
  --color-ink: oklch(18% 0.006 60); --color-ink-2: oklch(28% 0.008 60); --color-muted: oklch(44% 0.012 60); --color-rule: oklch(88% 0.013 85);
  --color-accent: oklch(70% 0.19 40); --color-accent-ink: oklch(18% 0.006 60); --color-accent-soft: oklch(91% 0.05 50); --color-focus: oklch(60% 0.19 40);
  --color-green: oklch(48% 0.11 150); --color-green-soft: oklch(92% 0.04 150);
  --color-contour: oklch(62% 0.07 58); --color-water: oklch(60% 0.05 232); --color-hedge: oklch(50% 0.1 150);
  --color-grid: oklch(90% 0.014 85); --color-grid-strong: oklch(85% 0.018 85); --color-sheet: oklch(99.3% 0.004 85);
  --font-display: "Red Hat Display", "Red Hat Text", ui-sans-serif, sans-serif; --font-body: "Red Hat Text", ui-sans-serif, system-ui, sans-serif;
  --font-outlier: "Red Hat Mono", ui-monospace, monospace;
  --radius-card: 10px; --radius-entry: 14px; --radius-pill: 6px; --rule-hair: 1px;
  --shadow-card: 0 1px 2px oklch(18% 0.006 60 / 0.08), 0 14px 28px -16px oklch(18% 0.006 60 / 0.28);
  --shadow-lift: 0 1px 1px oklch(18% 0.006 60 / 0.1), 0 2px 4px -1px oklch(18% 0.006 60 / 0.1), 0 24px 44px -20px oklch(18% 0.006 60 / 0.42);
  --tracking-display: -0.035em; --display-weight: 600;
}
```

- Type [HALLMARK]: Red Hat Display 600 for display (`--tracking-display`, line-height 1.0, sentence case; the price that is the offer, and an entry's time at 44px tabular, are set in it). Red Hat Text 400 for body (line-height 1.55, `--color-muted`), 500 for a row's title. Labels, chips and tabs: Red Hat Text 500 one step smaller, sentence case, untracked, never mono or uppercase. Red Hat Mono 400 and 500, tabular, one step smaller than its neighbours, only for what gets copied onto a form: dates, times, tag numbers, doses, batches, hectares. Place names on the map: Red Hat Text 500, sentence case, set along their field.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Red+Hat+Display:wght@600&family=Red+Hat+Text:wght@400;500&family=Red+Hat+Mono:wght@400;500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Red Hat Display (vietnamese no), Red Hat Text (vietnamese no), Red Hat Mono (vietnamese no). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Red Hat Display, Red Hat Text, Red Hat Mono, so accents fall back glyph by glyph. For a Vietnamese page swap Red Hat Display to Hanken Grotesk, Red Hat Text to Hanken Grotesk, Red Hat Mono to IBM Plex Mono.
- The shared `--space-*`, `--text-*`, `--dur-*` and `--ease-out` tokens come from [foundation](foundation.md).

## Surfaces and range
- The survey map is generated on a canvas on load and resize, never a picture: contours traced from noise by marching squares in `--color-contour` (every fifth heavier and labelled), hedges dotted in `--color-hedge`, walls solid ink, water in `--color-water`, buildings hatched, a lane and a gate, the holding edged in tangerine. Paper grain, fibre and two fold creases are drawn into the map only. A still frame is the no-script fallback.
- On the map: pins in three shapes (disc, diamond, triangle) for the kinds of record, an ink tag beside each with its time; the open pin turns tangerine; a movement draws a dashed route; a loupe (1.9x, fine ring, reticle) rests on a landmark and glides to the pointer.
- The notebook card: `--color-paper-2` at `--radius-entry`, a 1px ink ring and `--shadow-lift`, an ink head with the kind and the time, cells on an 8px `--color-grid` grid parted by 1px ink lines, 56px step keys at the foot. An exported record is a letter-folded sheet opened flat (`--color-sheet`, 3px corners, two creases lit from above). Only the card and the white sheet lift.
- Rules: a 1px ink rule over a list, `--color-rule` hairlines between rows, a 2px ink rule over a total. Photographs: the holding in ordinary weather at mid distance, natural and never golden hour; 10px radius, or full-bleed under an ink scrim.
- Compositions: the day on the map with one entry open as a notebook card; the book as a ruled table on the white sheet with a segmented log filter and chips (in date, in withdrawal); one day by the hour as rows with a pinned entry each; the price as ruled lines on the tangerine field with a contour fragment, a hedge, a gate and one pin behind it.
- Tangerine is a fill with ink on it: the primary, the selected tab, the open pin, the holding's edge, the field band, the focus ring. Motion: once, in view; pins land in time order, the route draws, the card opens, the loupe settles; transforms and opacity on `--ease-out`, paused off screen; reduced motion or no script shows the pins down and one entry open. Voice: plain and unit-bearing (3.6 ha, 10 ml, 28 days); never a number without its unit, never a pastoral adjective.

## Component recipes

```css
h1, h2, h3 { font-weight: var(--display-weight); line-height: 1; }
.btn { min-height: 48px; border: var(--rule-hair) solid var(--color-rule); border-radius: var(--radius-pill); padding: 0 var(--space-lg); font-weight: 500; background: var(--color-paper-2); color: var(--color-ink); box-shadow: inset 0 1px 0 var(--color-sheet), 0 1px 1px var(--color-rule); }
.btn--primary { background: var(--color-accent); color: var(--color-accent-ink); border-color: color-mix(in oklab, var(--color-accent) 78%, var(--color-ink)); box-shadow: inset 0 1px 0 color-mix(in oklab, var(--color-sheet) 32%, transparent), inset 0 -1px 0 color-mix(in oklab, var(--color-ink) 10%, transparent); }
.btn:active { transform: translateY(1px); }
.ruled { border-top: var(--rule-hair) solid var(--color-ink); } .ruled > * { border-bottom: var(--rule-hair) solid var(--color-rule); }
.entry { border-radius: var(--radius-entry); background: var(--color-paper-2); box-shadow: 0 0 0 1px var(--color-ink), var(--shadow-lift); overflow: hidden; }
.notebook { background: linear-gradient(var(--color-grid) 1px, transparent 1px) 0 0 / 8px 8px, linear-gradient(90deg, var(--color-grid) 1px, transparent 1px) 0 0 / 8px 8px, var(--color-paper-2); }
.field label { position: absolute; left: var(--space-md); top: var(--space-xs); font-size: 0.75rem; font-weight: 500; color: var(--color-muted); }
.num { font-family: var(--font-outlier); font-variant-numeric: tabular-nums; }
.survey { position: relative; min-height: 190px; overflow: hidden; border-radius: var(--radius-card); box-shadow: 0 0 0 1px var(--color-ink); background: linear-gradient(115deg, transparent 0 62%, color-mix(in oklab, var(--color-water) 30%, transparent) 62% 70%, transparent 70%), repeating-radial-gradient(ellipse at 30% 42%, transparent 0 10px, var(--color-contour) 10px 11.5px), var(--color-paper-2); }
.survey::after { content: ""; position: absolute; inset: 14px; border: 2px solid var(--color-accent); border-radius: 3px; pointer-events: none; }
.pin { position: absolute; width: 14px; height: 14px; background: var(--color-ink); border-radius: 50%; }
.pin--diamond { border-radius: 0; rotate: 45deg; } .pin--tri { border-radius: 0; clip-path: polygon(50% 0, 100% 100%, 0 100%); }
.pin--open { background: var(--color-accent); box-shadow: 0 0 0 2px var(--color-ink); }
.tag { position: absolute; padding: 2px 6px; border-radius: 3px; background: var(--color-ink); color: var(--color-paper); font: 500 0.75rem/1.2 var(--font-outlier); }
.chip { display: inline-block; padding: 2px 10px; border-radius: var(--radius-pill); background: var(--color-green-soft); color: var(--color-green); font-weight: 500; font-size: var(--text-sm); }
```

The `.survey` rule is a static [DERIVED] stand-in for the generated map: use it for a hero or a still, and generate the real map with a canvas when the page needs one.

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.70:1 (AAA); muted body on paper 6.92:1 and on paper-2 7.67:1; ink on the tangerine primary 6.53:1; ink on the soft tangerine tint 14.18:1; green in-date chip text on its tint 5.01:1; paper-coloured tag text on ink 16.70:1; focus ring on paper 3.81:1. Tangerine on paper is 2.56:1 (fail), so it is a fill that carries ink, never type.
- [HALLMARK] Never tangerine as type. Never a map tile, a satellite photograph or a pin-drop icon: the land is a generated survey. Never grain or creases outside the map. Never mono on a label, a chip or a head.
- [HALLMARK] Keys are 48px tall at a 6px radius; fields hold their label inside the box (small, muted, top left), are white and 52px with a 1px `--color-muted` border, and a figure field sets in mono; active sinks the key 1px.
- [HALLMARK] Only the notebook card and the white sheet lift; every other surface stays flat with rules.

## Choose when / avoid when
- Choose: records kept against land, animals, sites or vehicles; inspection, compliance and field-service tools; any product whose facts are dates, times, tag numbers and units.
- Avoid: lifestyle or tourism pages, glossy analytics dashboards, navigation products, dark mode requests.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Red+Hat+Display:wght@600&family=Red+Hat+Text:wght@400;500&family=Red+Hat+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2rem,8vw,3rem)}</style>
<main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Every field, on record.</h1><p class="lead" style="color:var(--color-muted)">Log work where it happened, in units you can copy onto a form.</p>
<div class="row"><button class="btn btn--primary">Open the book</button><button class="btn">Export a record</button></div>
<div class="survey"><span class="pin" style="left:22%;top:38%"></span><span class="tag" style="left:calc(22% + 20px);top:calc(38% - 3px)">06:40</span><span class="pin pin--diamond" style="left:52%;top:56%"></span><span class="pin pin--open" style="left:70%;top:30%"></span><span class="tag" style="left:calc(70% + 20px);top:calc(30% - 3px)">14:15</span><span class="pin pin--tri" style="left:40%;top:72%"></span></div>
<div class="entry"><div style="background:var(--color-ink);color:var(--color-paper);padding:var(--space-sm) var(--space-md);display:flex;justify-content:space-between"><span>Treatment</span><span class="num">14:15</span></div><div class="notebook" style="padding:var(--space-md);display:grid;gap:var(--space-xs)"><span class="chip">In date</span><span class="num">Tag 0412, 10 ml, batch 7</span></div></div>
<div class="ruled"><div class="row" style="justify-content:space-between;padding:var(--space-sm) 0"><span>North pasture</span><span class="num">3.6 ha</span></div><div class="row" style="justify-content:space-between;padding:var(--space-sm) 0"><span>Lambing shed</span><span class="num">28 days</span></div></div>
</main>
```
