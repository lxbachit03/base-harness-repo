# Dose (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/dose.md`, last changed 3d760dd (2026-10-21), MIT; live sample usehallmark.com/themes/dose/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, light warm paper, committed posture: translucent plastic and daylight. Warm morning paper with a fine fibre grain, window light falling across it, bands of soft tinted plastic like a pill organiser, green-black ink, Schibsted Grotesk heads over Instrument Sans, and DM Mono for the time and the dose, set like a pharmacy label. One pharmacy green does every signal. [HALLMARK]
- Trustworthy because it is exact and unhurried, and it lives in a kitchen, not a clinic. [HALLMARK]
- Best for: health and medication apps, pharmacy and prescription services, care and carer tools, family reminders and routines, clinics, patient tracking, products for parents and older people.
- Not a clinical blue portal, a wellness pastel or an alarm.

## Tokens

```css
:root {
  --color-paper: oklch(97.6% 0.011 88); --color-paper-2: oklch(96.5% 0.02 160); --color-paper-3: oklch(93% 0.036 160);
  --color-ink: oklch(21% 0.025 170); --color-ink-2: oklch(31% 0.02 170); --color-muted: oklch(49% 0.024 165);
  --color-rule: oklch(86.5% 0.022 140);
  --color-accent: oklch(50% 0.13 160); --color-accent-deep: oklch(42% 0.11 162); --color-accent-soft: oklch(88% 0.08 160); --color-accent-ink: oklch(99% 0.006 160);
  --color-focus: oklch(45% 0.14 160);
  --p-mon: oklch(85% 0.052 22); --p-tue: oklch(87.5% 0.058 64); --p-wed: oklch(91.5% 0.064 98); --p-thu: oklch(86.5% 0.075 160);
  --p-fri: oklch(87% 0.048 210); --p-sat: oklch(84% 0.045 270); --p-sun: oklch(84% 0.048 322);
  --light: oklch(99.4% 0.016 84); --glint: oklch(100% 0 0);
  --font-display: "Schibsted Grotesk", ui-sans-serif, sans-serif; --font-body: "Instrument Sans", ui-sans-serif, sans-serif;
  --font-outlier: "DM Mono", ui-monospace, monospace;
  --radius-card: 14px; --radius-input: 10px; --radius-pill: 999px; --rule-hair: 1px;
  --shadow-card: 0 1px 2px oklch(30% 0.03 165 / 0.08), 0 24px 48px -24px oklch(40% 0.08 165 / 0.35);
  --shadow-lift: 0 1px 1px oklch(30% 0.03 165 / 0.10), 8px 18px 28px -14px oklch(36% 0.06 165 / 0.32), 18px 40px 60px -30px oklch(40% 0.08 165 / 0.30);
  --tracking-display: -0.03em; --display-weight: 700;
}
```

Committed [HALLMARK]: the paper is warm, the green tints and the plastic carry the colour, mint (`--color-accent-soft`) marks what is checked, and the accent proper stays on controls, focus, a stamp and one figure. Grounds, stated once on the page: `white` is the default above; `green` is drenched, `oklch(46% 0.12 160)` under white ink, surfaces white inside, mint on the ground; `night` is `oklch(13% 0.01 170)` under `oklch(96% 0.01 160)`, plastic at 40% light, mint with dark ink.

```css no-preview
:root[data-ground="green"] { --color-paper: oklch(46% 0.12 160); --color-ink: oklch(99% 0.006 160); }
:root[data-ground="night"] { --color-paper: oklch(13% 0.01 170); --color-ink: oklch(96% 0.01 160); }
```

- Type [HALLMARK]: Schibsted Grotesk 700 for display (`--tracking-display`, line-height 1.02, sentence case, lining tabular figures). Body Instrument Sans 400 and 500 at 16 to 18px, line-height 1.5. Labels, captions and table heads: Instrument Sans 500 one step smaller, sentence case. Times, doses and pharmacy labels: DM Mono 400 and 500 (`08:00`, `500 mg`) at text size inside a sentence, at title size where a timetable's first column is the time, and as the whole voice of a pharmacy label; never a tab, a table head or a display figure. Three weights a page: 400, 500, 700.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Schibsted+Grotesk:wght@700&family=Instrument+Sans:wght@400;500&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Schibsted Grotesk (vietnamese no), Instrument Sans (vietnamese no), DM Mono (vietnamese no). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Schibsted Grotesk, Instrument Sans, DM Mono, so accents fall back glyph by glyph. For a Vietnamese page swap Schibsted Grotesk to Hanken Grotesk, Instrument Sans to Hanken Grotesk, DM Mono to IBM Plex Mono.
- The source names a fibre grain as an `feTurbulence` data URI without defining it; the recipes below define a stand-in [DERIVED]. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- The ground is generated, never a picture: the paper takes a fractal-noise fibre grain under the paper colour, and the hero takes window light, four blurred panes of `--light` skewed across the paper, drifting over 90 seconds and paused off screen.
- Plastic is the surface: a tint (`--p-mon` to `--p-sun`, never a state) at about 62% alpha, a `--glint` line along the top edge, a deeper inner shade at the foot, and the coloured light it lets through pooled and blurred on the paper below. It makes bands, trays and compartments; CSS 3D may turn a set of them three-quarter on the paper.
- A label is paper on plastic: grained white, 10px radius, a tear-off stub on a dashed rule, DM Mono throughout; a confirmation is a double-ringed green stamp rotated 2 degrees naming the time and who; missed or due is the same in grey.
- Radii read as an app: 10px controls, 14px surfaces, 999 on tags, a phone screen at about 28px. White surfaces lift on `--shadow-lift`; one green-black ink band may carry a statement. Photographs: the home where a dose is given, hands and rooms in soft daylight, never a face to camera or a clinic; 14px radius, captions beneath.
- Compositions: a sequence as plastic bands (each stage a full-width band in its own tint, the number in Schibsted at display size, two phone screens of the product on it, the minute each happened in DM Mono); a record as labels (a photograph beside two pharmacy labels, one stamped given in green, one missed in grey, each stating dose, time and person); a statement on the ink band (one plain sentence in Schibsted 700 at `--text-display`, one line in mint beneath); a first step in a tray (the form on a sunken plastic tray, choices as plastic keys, the product's screen answering live).
- Controls: moulded plastic, 52px at 10px with a 1px rim, a 3px rim below, a bevel of `--glint` on top and a soft cast shadow, sinking 3px on press; the primary is green plastic, the secondary clear. Choices are plastic keys, mint when checked; links underline in green on hover; inputs are 52px at 10px with a 1px `--color-muted` border.
- Motion: the light drifts over 90 seconds and pauses off screen; once in view a lid lifts, a label rises, its stamp lands and a tick ripples to whoever else sees it; reduced motion or no script shows the end state with the light still. Voice: a pharmacist's plainness spoken by a family (the name, the dose, the time, who gave it, in the words a son or daughter uses); never a journey, never a warning in red.

## Component recipes

```css
:root { --grain: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200'%3E%3Cfilter id='g' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.012 .5' numOctaves='3' seed='6' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .4 0 0 0 0 .38 0 0 0 0 .25 0 0 0 .5 -.2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23g)'/%3E%3C/svg%3E"); }
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; letter-spacing: var(--tracking-display); line-height: 1.02; }
.btn { height: 52px; padding: 0 var(--space-lg); border: 0; border-radius: var(--radius-input); background: var(--color-paper); color: var(--color-ink); font: 500 var(--text-md) var(--font-body); box-shadow: inset 0 1px 0 var(--glint), 0 0 0 1px var(--color-muted), 0 3px 0 var(--color-rule); transition: transform var(--dur-micro) var(--ease-out); }
.btn--primary { background: linear-gradient(var(--color-accent), var(--color-accent-deep)); color: var(--color-accent-ink); box-shadow: 0 0 0 1px var(--color-accent-deep), 0 3px 0 var(--color-accent-deep); }
.btn:active { transform: translateY(3px); }
.plastic { --t: var(--p-thu); position: relative; border-radius: var(--radius-card); background: linear-gradient(color-mix(in oklab, var(--glint) 32%, transparent), transparent 18%), color-mix(in oklab, var(--t) 62%, transparent); box-shadow: inset 0 1.5px 0 var(--glint), inset 0 -24px 36px -28px color-mix(in oklab, var(--t) 45%, var(--color-ink)); }
.dose, .label { font-family: var(--font-outlier); font-variant-numeric: tabular-nums; }
.band--ink { background: var(--color-ink); color: var(--color-paper); }
.paper { position: relative; background: var(--grain), var(--color-paper); overflow: hidden; }
.paper::before { content: ""; position: absolute; inset: -20% -10% auto; height: 70%; background: linear-gradient(100deg, transparent 12%, var(--light) 12% 20%, transparent 20% 34%, var(--light) 34% 40%, transparent 40%); opacity: 0.45; filter: blur(14px); transform: skewX(-18deg); pointer-events: none; }
.paper > * { position: relative; }
.label { padding: var(--space-sm) var(--space-md); border-radius: 10px; background: var(--color-paper-3); box-shadow: var(--shadow-card); }
.stamp { display: inline-block; padding: 4px 16px; border-radius: var(--radius-pill); background: var(--color-paper); color: var(--color-accent); rotate: 2deg; box-shadow: inset 0 0 0 2px var(--color-accent), 0 0 0 3px var(--color-paper), 0 0 0 5px var(--color-accent); }
.input { min-height: 52px; padding: 0 var(--space-md); border: var(--rule-hair) solid var(--color-muted); border-radius: var(--radius-input); background: var(--color-paper); color: var(--color-ink); }
```

The `.paper::before` window light is a static [DERIVED] stand-in for the drifting panes; animate it over 90 seconds with a `transform` keyframe only if the page can afford it, paused off screen. Two [DERIVED] changes to the source recipe came out of a replay: the key's 1px rim uses `--color-muted` instead of `--color-rule`, because the rule colour measures 1.40:1 against the paper and a key's edge needs 3:1 (5.78:1 with the muted rim), and `.stamp` carries a paper fill, because the green text measures only 4.22:1 on a peach plastic tint.

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.44:1 (AAA); ink-2 on paper 12.15:1; muted on paper 5.78:1; white label on the green primary 5.33:1 and at the deep end of its gradient 7.57:1; green on paper (stamp, link underline, figure) 5.12:1; ink on mint 12.61:1; ink on a plastic band over paper 13.52:1; focus ring on paper 6.36:1.
- [HALLMARK] Never red or amber for a missed or late state: it is grey. Never a plastic tint as a signal or a second brand colour: the green does every signal. Never clinical stock (spilled pills, blister packs in close-up, white coats). Never glossy toy plastic: tints stay pale, the light is daylight, and no gradient goes beyond the glint and the shade.
- [HALLMARK] DM Mono never sets a tab, a table head or a display figure; three weights a page.

## Choose when / avoid when
- Choose: health, medication, care and family-routine products that want to feel exact, calm and domestic: reminders, schedules, records of who gave what and when.
- Avoid: clinical or enterprise health portals, loud consumer brands, dark-only pages, products where a late or missed state must alarm.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Schibsted+Grotesk:wght@700&family=Instrument+Sans:wght@400;500&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.2rem,9vw,3.3rem)}</style>
<div class="paper"><main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Mum's 8am, done.</h1><p class="lead">Everyone in the family sees when a dose is given.</p>
<div class="row"><button class="btn btn--primary">Add a medicine</button><button class="btn">See today</button></div>
<div class="plastic" style="--t:var(--p-wed);padding:var(--space-md)"><b>Morning</b> <span class="dose">08:00, 500 mg</span></div>
<div class="plastic" style="--t:var(--p-thu);padding:var(--space-md)"><b>Evening</b> <span class="dose">20:00, 250 mg</span></div>
<div class="label">Given 08:02 by Sam <span class="stamp">given</span></div>
</main></div>
```
