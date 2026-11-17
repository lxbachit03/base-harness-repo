# Console (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/console.md`, last changed 3756c14 (2026-10-20), MIT; live sample usehallmark.com/themes/console/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, dark paper (graphite), restrained posture: an instrument kept by careful people. A graphite ground stepped in three lightnesses, hairline panels cut from one surface, Host Grotesk for what a person reads, Atkinson Hyperlegible Mono for what an instrument measured, amber for a person and cool blue for an instrument. The ground is neutral so both meanings sit on it at equal weight, and nothing glows. [HALLMARK]
- Best for: labs, protocols and experiment records, science and research notebooks, observability and monitoring, audit and compliance trails, version control, instruments and telemetry, developer and operations tools.
- Not a neon terminal, a glass dashboard or a science-fiction control room.

## Tokens

```css
:root {
  --color-paper: oklch(17% 0.008 250); --color-paper-2: oklch(21% 0.009 250); --color-paper-3: oklch(13.5% 0.007 250);
  --color-ink: oklch(95% 0.005 250); --color-ink-2: oklch(83% 0.008 250); --color-muted: oklch(71% 0.01 250);
  --color-rule: oklch(31% 0.01 250); --color-rule-2: oklch(42% 0.012 250);
  --color-accent: oklch(82% 0.15 80); --color-accent-ink: oklch(18% 0.04 75); --color-accent-soft: oklch(29% 0.05 80); --color-focus: oklch(82% 0.15 80);
  --color-cool: oklch(77% 0.12 245); --color-cool-soft: oklch(29% 0.05 245);
  --color-ok: oklch(76% 0.15 150); --color-ok-soft: oklch(24.5% 0.03 150); --color-bad: oklch(70% 0.17 25); --color-bad-soft: oklch(24.5% 0.035 25);
  --font-display: "Host Grotesk", ui-sans-serif, system-ui, sans-serif; --font-body: var(--font-display);
  --font-outlier: "Atkinson Hyperlegible Mono", ui-monospace, monospace;
  --radius-card: 10px; --radius-pill: 6px; --rule-hair: 1px;
  --shadow-card: none;
  --tracking-display: -0.03em; --display-weight: 500;
}
```

Colourways [HALLMARK], stated once on the page: `graphite` is the default above. `paper`: ground `oklch(98% 0.006 85)` under ink `oklch(19% 0.010 60)`, amber `oklch(54% 0.14 70)`, cool `oklch(52% 0.14 250)`, the paper band turning light. `amber-room`: ground `oklch(15% 0.022 70)` under ink `oklch(95% 0.012 85)`, amber `oklch(82% 0.15 82)`, the cool turned to ice `oklch(82% 0.08 200)`. In every colourway amber means a person and cool means an instrument.

```css no-preview
:root[data-colourway="paper"] { --color-paper: oklch(98% 0.006 85); --color-ink: oklch(19% 0.010 60); --color-accent: oklch(54% 0.14 70); --color-cool: oklch(52% 0.14 250); }
:root[data-colourway="amber-room"] { --color-paper: oklch(15% 0.022 70); --color-ink: oklch(95% 0.012 85); --color-accent: oklch(82% 0.15 82); --color-cool: oklch(82% 0.08 200); }
```

- Type [HALLMARK]: Host Grotesk 500 for display (`--tracking-display`, line-height 1.02 to 1.05, sentence case, roman; calm at size, never 700). Body Host Grotesk 400 at 16 to 17px, line-height 1.55, in `--color-muted`, the lede in `--color-ink-2`. Labels, captions, table heads and chips: Host Grotesk 500 one step smaller, sentence case, `--color-muted`. Measured values: Atkinson Hyperlegible Mono 400 and 500 at 14 to 15px for what an instrument or the system wrote (a reading with its unit, an id, a diff, a timestamp), every figure tabular; its slashed zero and tailed one are the point, and at display size it is the theme's loudest thing. Never a label, a head or a control.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Host+Grotesk:wght@400;500&family=Atkinson+Hyperlegible+Mono:wght@400;500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Host Grotesk (vietnamese no), Atkinson Hyperlegible Mono (vietnamese no). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Host Grotesk, Atkinson Hyperlegible Mono, so accents fall back glyph by glyph. For a Vietnamese page swap Host Grotesk to Hanken Grotesk, Atkinson Hyperlegible Mono to JetBrains Mono.
- Console is a dark theme: add the foundation's dark error and success pair (the theme adds `--color-ok` and `--color-bad` for diffs and status). The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- Hairline panels: a surface is a 1px `--color-rule` with `--color-paper-2` inside, radius 10px (6px on controls); panels that sit together are one surface divided by 1px rules; `--color-rule-2` marks the selected row or the spine of a trail. Three steps, no lamp: the ground, a panel one step up, and the deepest step for code, logs, a changed row and photographs. No shadow, glow, bloom or spotlight; no texture and no gradient on a surface.
- Bands: `--color-paper-3` or `--color-paper-2`, never an amber field; two a page at most. Photographs: one or two of the bench and never a face (gloved hands at a pipette, a rack of tubes), dark and close, black and white from the deepest step to the ink, radius 10px, a 1px rule edge, a caption beneath.
- Compositions: diffs (two versions in one panel, a gutter of plus and minus in ok and bad, the changed rows on the soft tints, the reason in the person's words beside them); readings (a single value at display size in the measured face, the struck value it replaced above it, and who, when and why beneath in amber, cool and ink); trails (rows on a 1px `--color-rule-2` spine, each entry a version, a person in amber, a time in cool, a reason in ink); panels (a bento or comparison cut from one surface with 1px seams, one panel the lead, each holding the product at full fidelity).
- Controls: an amber fill with `--color-accent-ink` beside a 1px `--color-rule-2` outline on `--color-paper-2`, both at 6px, Host Grotesk 500. A chip carries state only (the label face inside a 1px rule at 4px radius, tinted `--color-accent-soft` or `--color-cool-soft` by meaning); a version picker is a row of such chips with the chosen pair on the cool tint. Inputs sit on `--color-paper-3` inside a 1px rule at 6px; links underline in `--color-rule-2` and turn amber on hover. Amber is a person (an operator, a deviation, the current step, the one primary control); cool is an instrument (a reading, a trace, a version); ok and bad exist for diffs and status only.
- Motion: a value changes when its source does, over `--dur-short` on `--ease-out`; a chart may draw once; no reveal, parallax or hover lift. Voice: a lab notebook kept by a careful person (the value, its unit, the time, who signed); a number without a unit or a time is nothing.

## Component recipes

```css
h1, h2, h3 { font-family: var(--font-display); font-weight: 500; letter-spacing: var(--tracking-display); line-height: 1.04; }
.panels { display: grid; gap: var(--rule-hair); background: var(--color-rule); border: var(--rule-hair) solid var(--color-rule); border-radius: var(--radius-card); overflow: hidden; }
.panels > * { background: var(--color-paper-2); }
.measured { font-family: var(--font-outlier); font-size: var(--text-sm); font-variant-numeric: tabular-nums slashed-zero; }
.reading { font-family: var(--font-outlier); font-size: var(--text-display); font-weight: 400; letter-spacing: -0.04em; line-height: 1; color: var(--color-ink); }
.row--minus { background: var(--color-bad-soft); } .row--plus { background: var(--color-ok-soft); }
.btn { border: var(--rule-hair) solid var(--color-rule-2); border-radius: var(--radius-pill); padding: var(--space-sm) var(--space-md); background: var(--color-paper-2); color: var(--color-ink); font-weight: 500; transition: background-color var(--dur-short) var(--ease-out); }
.btn--primary { background: var(--color-accent); border-color: var(--color-accent); color: var(--color-accent-ink); }
::selection { background: color-mix(in oklab, var(--color-accent) 25%, transparent); }
.chip { display: inline-block; padding: 2px 8px; border: var(--rule-hair) solid var(--color-rule-2); border-radius: 4px; font-size: var(--text-sm); font-weight: 500; }
.chip--person { background: var(--color-accent-soft); } .chip--instrument { background: var(--color-cool-soft); }
.input { min-height: 44px; padding: 0 var(--space-sm); border: var(--rule-hair) solid var(--color-rule-2); border-radius: var(--radius-pill); background: var(--color-paper-3); color: var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.53:1 (AAA); body muted on paper 7.42:1 and on a panel 6.88:1; amber label on the amber fill `--color-accent-ink` 10.68:1; amber on a panel 10.00:1; cool on a panel 8.64:1; ok on its tint 7.88:1; bad on its tint 5.70:1; amber on the person chip 8.05:1; cool on the instrument chip 6.83:1; the hairline `--color-rule-2` against paper 2.27:1 (fail), so rely on the label and the lightness step, not the hairline alone, for a control's edge.
- [HALLMARK] Never swap the meanings: an amber reading or a cool deviation is the theme lying. Never a floating card with a shadow under it. Never a third signal or a photograph in colour. Never mono on a label, a head or a button: mono is what an instrument wrote. Never a page of small panels only: one value or one record a page is set large.
- [HALLMARK] Photographs are black and white and never show a face.

## Choose when / avoid when
- Choose: products where people record, measure and sign (labs, protocols, observability, audit trails, compliance, version control, operations) and want a dark, calm, exact surface.
- Avoid: playful or consumer brands, warm editorial pages, photo-led storytelling, anything that wants glow, glass or neon.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Host+Grotesk:wght@400;500&family=Atkinson+Hyperlegible+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2rem,8vw,3rem)}.panels>div{padding:var(--space-md)}</style>
<main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Every change, signed.</h1><p style="color:var(--color-muted)">Versioned readings, who changed them and why.</p>
<div class="row"><button class="btn btn--primary">Open the trail</button><button class="btn">Compare versions</button></div>
<div class="panels"><div class="row"><span class="chip chip--instrument">v14</span><span class="chip chip--person">M. Okafor</span></div><div class="measured">pH 7.42 at 21.3 C</div><div class="measured row--minus">- incubate 37.0 C</div><div class="measured row--plus">+ incubate 36.5 C</div></div>
<div class="reading">7.42</div>
</main>
```
