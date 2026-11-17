# Studio (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/studio.md`, last changed 3d760dd (2026-10-21), MIT; live sample usehallmark.com/themes/studio/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Editorial genre, light cool paper (hue 215), restrained posture: a design studio's proof sheet caught mid-build. Cool studio-white paper with an ink dot grid and a fine grain, blue-black ink, Hedvig Letters Serif for the heads (a contemporary serif with a calligraphic hand in its joins), a clean Geist body, crop marks at the corners of every printed piece, and one cadmium orange that both fills the action and draws the construction: metric guides, clear-space boxes, redlines. It reads as considered because the type is shown being measured. [HALLMARK]
- Best for: design and creative studios, branding and brand identity, art direction, agencies, portfolios, case studies and selected work, editorial and typographic work.
- Not a warm cream portfolio with a terracotta accent and not a grey minimal template.

## Tokens

```css
:root {
  --color-paper: oklch(97.2% 0.006 215); --color-paper-2: oklch(94% 0.009 215); --color-paper-3: oklch(90.5% 0.011 215); --color-paper-hi: oklch(99% 0.004 215);
  --color-ink: oklch(16% 0.032 250); --color-ink-2: oklch(34% 0.022 245); --color-muted: oklch(49% 0.018 240);
  --color-rule: oklch(84% 0.010 225);
  --color-accent: oklch(68% 0.172 50); --color-accent-ink: oklch(16% 0.032 250); --color-focus: oklch(52% 0.15 48);
  --color-dot: color-mix(in oklab, var(--color-ink) 20%, transparent); --color-mark: color-mix(in oklab, var(--color-ink) 72%, transparent);
  --font-display: "Hedvig Letters Serif", ui-serif, Georgia, serif; --font-body: "Geist", ui-sans-serif, system-ui, sans-serif;
  --font-outlier: "Sofia Sans Extra Condensed", "Arial Narrow", ui-sans-serif, sans-serif;
  --radius-card: 3px; --radius-pill: 3px; --rule-hair: 1px;
  --shadow-card: none;
  --shadow-sheet: 1px 2px 0 color-mix(in oklab, var(--color-ink) 7%, transparent), 10px 18px 36px -14px color-mix(in oklab, var(--color-ink) 32%, transparent);
  --tracking-display: -0.022em; --display-weight: 400;
}
```

- Type [HALLMARK]: Hedvig Letters Serif 400, its one weight, for display (`--tracking-display`, line-height 0.98 to 1.04, sentence case, `font-optical-sizing: auto`); the hand holds from a 200px wordmark down to a 25px item title (tracking -0.005em there); heads, figures and the wordmark only. Body Geist 400 and 500, line-height 1.55, ink-2 for running text. Labels, captions and guide readouts: Geist 500 one step smaller, sentence case, `--color-muted`, tabular figures for any measurement; no mono. Specimen face: Sofia Sans Extra Condensed 500, only inside a specimen that shows an alternative system, never a head or label of the page itself.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Hedvig+Letters+Serif:opsz@12..24&family=Geist:wght@400;500&family=Sofia+Sans+Extra+Condensed:wght@500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Hedvig Letters Serif (vietnamese no), Geist (vietnamese yes), Sofia Sans Extra Condensed (vietnamese no). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Hedvig Letters Serif, Sofia Sans Extra Condensed, so accents fall back glyph by glyph. For a Vietnamese page swap Hedvig Letters Serif to Newsreader, Sofia Sans Extra Condensed to Barlow Condensed.
- The source names `--grain` (an `feTurbulence` grain) without defining it; the recipes below define a stand-in [DERIVED]. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- The ground is a generated proof, never a picture: a 24px radial-gradient dot grid in `--color-dot` under an `feTurbulence` grain on the hero, nav and footer, masked to fade before the next section; the rest of the page is clean paper.
- Crop marks on every printed piece (a sheet, a photograph, a card, a control, a focused field): eight 1px `--color-mark` ticks drawn with background gradients on a `::before`, set off the corners by a small gap, larger on a sheet; registration targets may sit at a sheet's sides.
- Orange draws construction: 1px `--color-accent` guides at the font's real ascender, cap height, x-height, baseline and descender with readouts in the label voice, a clear-space box in x units, redlines with dimensions. Rules only, never orange type.
- Two rules: 1px `--color-rule` between rows, 1px `--color-ink` opening a set; radius 3px. One shadow, for paper objects only (a card, a sheet), lit from the top left (`--shadow-sheet`); everything else lies flat. Bands: paper-2, or one ink band with paper type, never an orange field.
- Photographs: the work where it is used, level, daylight, verticals straight, true colour, crop-marked, a ratio redline beside it; never a mockup.
- Compositions: a wordmark under construction (the name set huge in Hedvig with its metric guides, clear-space box and readouts on the dot grid); systems as specimen cards (two or three crop-marked alternatives with a face line, `Aa Gg Rr 0123456789` and hex swatches that switch one board by type, colour or grid); an index that opens (rows under an ink rule, Hedvig at item size, each opening into a case with its photograph at a stated ratio); a size test (one line at falling sizes, each on its own orange guides with the live size beside it).
- Controls: printed buttons with a 1px ink border at 2px radius, a second rule inset 2px, crop marks at the corners that open slightly on hover; the primary is filled orange with ink text; Geist 500, 48px. Fields: 3px radius, a 1px `--color-muted` border, crop marks on focus. Links take an orange underline on hover. The orange fill stays on the one action; orange lines are construction and may be many but thin.
- Motion: guides draw in once along their length; a set of systems may turn every few seconds while in view and stops on any choice; state changes at `--dur-short` on `--ease-out`; reduced motion shows the full construction, still. Voice: spare, exact, a little literary; verbs over adjectives; name the work, the institution, the surface, the measurement.

## Component recipes

```css
:root { --grain: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='g' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='2' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .12 0 0 0 0 .14 0 0 0 0 .2 0 0 0 .5 -.2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23g)'/%3E%3C/svg%3E"); }
h1, h2, h3 { font-family: var(--font-display); font-weight: var(--display-weight); letter-spacing: var(--tracking-display); color: var(--color-ink); font-optical-sizing: auto; line-height: 1.0; }
.proof { background-image: var(--grain), radial-gradient(circle at 1px 1px, var(--color-dot) 1px, transparent 1.4px); background-size: 160px 160px, 24px 24px; }
.crop { position: relative; --l: 8px; --o: 12px; }
.crop::before { content: ""; position: absolute; inset: calc(-1 * var(--o)); pointer-events: none; background: linear-gradient(var(--color-mark), var(--color-mark)) 0 var(--o) / var(--l) 1px no-repeat, linear-gradient(var(--color-mark), var(--color-mark)) var(--o) 0 / 1px var(--l) no-repeat; }
.btn { position: relative; border: var(--rule-hair) solid var(--color-ink); border-radius: 2px; min-height: 48px; padding: 0 var(--space-lg); background: transparent; font-weight: 500; color: var(--color-ink); }
.btn::after { content: ""; position: absolute; inset: 2px; border: var(--rule-hair) solid var(--color-mark); pointer-events: none; }
.btn--primary { background: var(--color-accent); color: var(--color-accent-ink); }
.guide { height: var(--rule-hair); background: var(--color-accent); }
.set { border-top: var(--rule-hair) solid var(--color-ink); } .set > * { border-bottom: var(--rule-hair) solid var(--color-rule); }
```

The upstream recipe leaves `.btn` unpositioned although `.btn::after` is absolute; the added `position: relative` and `pointer-events: none` are [DERIVED] fixes. The `.crop::before` gradient draws two of the eight ticks; repeat it with the other corners (right and bottom positions) for the full set.

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 17.94:1 (AAA); ink-2 running text on paper 10.86:1; muted label on paper 5.76:1 and on paper-2 5.25:1; ink on the orange primary 6.37:1; ink on the raised sheet 18.83:1; focus ring on paper 5.41:1. Orange on paper is 2.82:1 (fail): it draws lines and fills a button, so it never becomes type.
- [HALLMARK] Never Hedvig in running text and never the specimen face outside a specimen. Never an orange flood, orange type or a second warm colour. Never warm paper: the ground is cool, hue 215. Never a guide that is not true to the font's metrics or a dimension that is not the real one. Never the dot grid behind a whole page or running text.
- [DERIVED] The crop marks and construction guides are drawn with gradients and 1px lines; keep them `pointer-events: none` so they never block a click.

## Choose when / avoid when
- Choose: studio, agency and portfolio sites where the craft of type, brand and measurement is the subject, with case studies and photographed work.
- Avoid: warm or playful brands, product dashboards, dark-first pages, anything without real work to show.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Hedvig+Letters+Serif:opsz@12..24&family=Geist:wght@400;500&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-md);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.6rem,12vw,4.2rem)}</style>
<div class="proof"><main class="container" style="display:grid;gap:var(--space-lg);padding-block:var(--space-xl)">
<h1>Marks that hold up.</h1><p class="lead" style="color:var(--color-ink-2)">Brand identity for institutions, measured to the millimetre.</p>
<div class="row"><button class="btn btn--primary">See selected work</button><button class="btn">About the studio</button></div>
<div class="crop" style="padding:var(--space-lg);background:var(--color-paper-hi);box-shadow:var(--shadow-sheet);margin:12px"><div class="guide"></div><b style="font-family:var(--font-display);font-size:3.2rem;font-weight:400">Aa</b><div class="guide"></div></div>
</main></div>
```
