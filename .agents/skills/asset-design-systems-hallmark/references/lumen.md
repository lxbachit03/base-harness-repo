# Lumen (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/lumen.md`, last changed 3756c14 (2026-10-20), MIT; live sample usehallmark.com/themes/lumen/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Atmospheric genre, dark paper (violet-black), restrained posture: a night console with a literary voice. Near-white ink, Instrument Serif set all in lowercase and a step large over Geist, hairline wells and one molten brass signal. Cool dark, warm light: the warmth is rationed to the brass and one rose verb, so the page reads engineered and quietly lit at once. The product is the picture. [HALLMARK]
- Best for: model and inference platforms, LLM and agent products, voice and synthesis APIs, GPUs and serverless runtimes, developer tools, research labs, premium technical brands.
- Not a neon dark mode, an orb on black, a glowing object, a purple poster or a serif magazine.

## Tokens

```css
:root {
  --color-paper: oklch(12.5% 0.027 290); --color-paper-2: oklch(16% 0.03 290); --color-paper-3: oklch(20% 0.032 290);
  --color-ink: oklch(96% 0.01 300); --color-ink-2: oklch(85% 0.017 298); --color-muted: oklch(69% 0.026 295);
  --color-rule: oklch(27% 0.034 290); --color-rule-2: oklch(36% 0.04 292); --rule-blueprint: oklch(96% 0.01 300 / 0.05);
  --color-accent: oklch(80% 0.15 62); --color-accent-2: oklch(72% 0.15 12); --color-accent-ink: oklch(14% 0.028 290);
  --color-live: oklch(80% 0.13 155); --color-focus: oklch(80% 0.15 62);
  --font-display: "Instrument Serif", ui-serif, Georgia, serif; --font-body: "Geist", ui-sans-serif, system-ui, sans-serif;
  --font-outlier: "Geist Mono", ui-monospace, monospace;
  --radius-card: 10px; --radius-pill: 999px; --rule-hair: 1px;
  --shadow-card: 0 28px 64px -30px oklch(4% 0.02 290 / 0.8);
  --tracking-display: -0.015em; --display-weight: 400;
}
```

A second drop, `day` [HALLMARK, four values only]: bone paper `oklch(97% 0.008 290)`, ink `oklch(18% 0.02 290)`, an indigo signal `oklch(46% 0.24 268)` with bone text, and the verb in `oklch(56% 0.16 18)`; the page stamp states the drop. The source does not give the other tokens of the day drop, so derive them from these four.

- Type [HALLMARK]: Instrument Serif 400, roman, all lowercase, `--tracking-display`, line-height 0.95 to 1.02; the face is narrow and light, so it sets one step large (section heads at `--text-display-s`, the hero head at its cap and beyond). Lowercase is the register for heads, nav, controls and labels; prose keeps sentence case so a model name survives. Body Geist 400 and 500 with `tabular-nums` wherever a figure appears. Labels, captions and table heads Geist 400 one step smaller, lowercase, untracked, `--color-muted`. Readouts and code Geist Mono 400 at 13px, lowercase: a measured value with its unit, a status, a model id; the mono is the machine speaking, never a label voice.
- The verb: the one accented word on the page, in the hero head only, always a verb, in `--color-accent-2` with a 1px underline that draws in once.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif&family=Geist:wght@400;500&family=Geist+Mono:wght@400&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Instrument Serif (vietnamese no), Geist (vietnamese yes), Geist Mono (vietnamese yes). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Instrument Serif, so accents fall back glyph by glyph. For a Vietnamese page swap Instrument Serif to Newsreader.
- The shared scale tokens come from [foundation](foundation.md); lumen is a dark theme, so add the foundation's dark error and success pair.

## Surfaces and range
- Hairlines contain: 1px `--color-rule` on wells, rows and inputs, `--color-rule-2` on a control's edge; 10px radius on surfaces, pills on controls and tags. Depth is a lightness step from paper to paper-3; a surface that must lift trades its hairline for `--shadow-card` in the ground's own dark. Never a glow, a halo or a coloured shadow.
- Bands: `--color-paper-2`, two a page at most; no accent field, and a night page never takes a bone band. One photograph at most: a 21:9 band of the machines the work runs on (an aisle of racks, cabling, a lit rack face), printed in the ground's violet, 10px radius and a 1px rule, with a caption naming the hardware beneath and no head on it.
- Texture: the blueprint grid, 1px `--rule-blueprint` lines on a 48px pitch, inside one well or band and never under running text. No glass, no blur, no generated object standing in for the product.
- Compositions: a path as a diagram (hairline nodes and connectors, the slow path in muted mono, the product's path ruled in brass); the product's own surface (a request beside its response in one well split by a hairline, lowercase tabs, readouts, a live state in `--color-live`); a chart in a well over the blueprint grid with the variable at half strength in `--color-ink-2` and the one fixed thing as a brass line; a measured figure in Instrument Serif at display size with its unit in mono, or rates as hairline rows of tabular figures.
- Controls: a solid brass pill with `--color-accent-ink` text beside a hairline pill in `--color-rule-2`, both lowercase, 44 to 48px. Links take a brass underline on hover; inputs sit on `--color-paper` inside a band, 1px `--color-rule-2`, 10px radius, the brass focus ring. The brass stays under 5% of a screen; the rose belongs to the verb; `--color-live` to a live state only.
- Motion: one reveal, the verb's underline drawing in over `--dur-long`; otherwise state only (a hairline pill takes `--color-paper-2` on hover, a streamed answer types once). No ambient loop, breathing light or stagger. Voice: engineered, plain, specific (the model, the state, the unit, the price); no exclamation marks.

## Component recipes

```css
body { font-variant-numeric: tabular-nums; }
h1, h2, h3, nav, label, th, figcaption, .btn { text-transform: lowercase; }
h1, h2, h3 { font-weight: 400; } h2 { font-size: var(--text-display-s); line-height: 0.98; }
.verb { display: inline-block; color: var(--color-accent-2); }
.verb::after { content: ""; display: block; height: var(--rule-hair); background: currentColor; transform-origin: left; animation: draw var(--dur-long) var(--ease-out) both; }
@keyframes draw { from { transform: scaleX(0); } }
.btn { border: 0; border-radius: var(--radius-pill); padding: var(--space-sm) var(--space-lg); font-weight: 500; }
.btn--primary { background: var(--color-accent); color: var(--color-accent-ink); }
.btn--secondary { background: transparent; box-shadow: inset 0 0 0 var(--rule-hair) var(--color-rule-2); color: var(--color-ink); }
.btn--secondary:hover { background: var(--color-paper-2); }
.well { background: var(--color-paper-2); border: var(--rule-hair) solid var(--color-rule); border-radius: var(--radius-card); }
.blueprint { background-image: linear-gradient(var(--rule-blueprint) 1px, transparent 1px), linear-gradient(90deg, var(--rule-blueprint) 1px, transparent 1px); background-size: 48px 48px; }
.readout { font: 400 0.8125rem/1.5 var(--font-outlier); color: var(--color-ink-2); }
```

```css no-preview
:root[data-drop="day"] { --color-paper: oklch(97% 0.008 290); --color-ink: oklch(18% 0.02 290); --color-accent: oklch(46% 0.24 268); --color-accent-ink: oklch(97% 0.008 290); --color-accent-2: oklch(56% 0.16 18); --color-focus: oklch(46% 0.24 268); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 17.97:1 (AAA); ink-2 on paper-2 12.31:1; muted on paper 7.22:1 and on paper-2 6.94:1; brass primary label `--color-accent-ink` on `--color-accent` 10.27:1; brass on paper (link hover, focus ring, readout) 10.42:1; the rose verb on paper 7.64:1; live state on paper 11.37:1; hairline rule-2 on paper (UI edge) 1.83:1 (fail), so rely on the lightness step and the label, not the hairline alone, to mark a control.
- [HALLMARK] Never a drawn or generated light: no orb, lamp, ring, halo or glowing object behind or beside a head. Never let the violet climb: a violet field or a violet-to-blue gradient is the generated look. Never colour a noun or add a second accented word: one verb, in the hero. Never sentence-case heads, and never a head at the plain section size: this face reads thin there. Never a warm ground or a third warm colour.
- [HALLMARK] Lowercase applies to heads, nav, controls and labels only; prose, model names and code keep their case. No exclamation marks.

## Choose when / avoid when
- Choose: AI, model, inference, voice and developer-platform products that want an engineered, quietly premium night look with a literary voice and a diagram or console as the picture.
- Avoid: consumer, playful or warm brands, light-first pages, photo-led storytelling, anything that needs glow, glass or gradients.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif&family=Geist:wght@400;500&family=Geist+Mono:wght@400&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.6rem,11vw,4rem)}</style>
<main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<nav class="row" style="justify-content:space-between"><b style="font-family:var(--font-display);font-size:1.4rem">lumen</b><a href="#">docs</a></nav>
<h1>run any model, <span class="verb">ship</span> faster</h1><p class="lead" style="color:var(--color-ink-2)">One endpoint for open models, billed by the token.</p>
<div class="row"><button class="btn btn--primary">start free</button><button class="btn btn--secondary">read the docs</button></div>
<div class="well blueprint" style="padding:var(--space-md);display:grid;gap:var(--space-xs)"><span class="readout">POST /v1/chat latency 182 ms</span><span class="readout" style="color:var(--color-live)">status live</span></div>
</main>
```
