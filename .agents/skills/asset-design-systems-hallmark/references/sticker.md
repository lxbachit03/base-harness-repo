# Sticker (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/sticker.md`, last changed 45af70a (2026-10-21), MIT; live sample usehallmark.com/themes/sticker/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Playful genre, light paper, full-palette posture: a print shop's material. A warm off-white sheet, warm black ink, Bowlby One SC capitals over Sofia Sans, hot pink and lime fills, and every raised surface edged in a thick white die-cut on a hard offset shadow. It feels loud and handmade because the depth is printed and the colours are fills, never tints. [HALLMARK]
- Best for: stickers, print and merch shops, makers and creators, DIY and craft, vinyl, packaging and labels, small-business e-commerce.
- Not a soft pastel shop with blurred shadows and not a cartoon toy page.

## Tokens

```css
:root {
  --color-paper: oklch(95.7% 0.013 82); --color-paper-2: oklch(92.8% 0.021 79); --color-paper-3: oklch(99.4% 0.007 89);
  --color-ink: oklch(21% 0.011 81); --color-ink-2: oklch(30% 0.013 78); --color-muted: oklch(50% 0.017 64);
  --color-rule: oklch(89.7% 0.02 80); --color-white: oklch(99.5% 0.003 82);
  --color-accent: oklch(56% 0.225 2); --color-accent-deep: oklch(49% 0.205 2); --color-accent-2: oklch(87.6% 0.179 119); --color-slot: oklch(95% 0.021 355);
  --color-accent-ink: oklch(99.5% 0.003 82); --color-focus: oklch(56% 0.225 2);
  --font-display: "Bowlby One SC", "Arial Black", sans-serif; --font-body: "Sofia Sans", ui-sans-serif, system-ui, sans-serif;
  --font-outlier: "Sofia Sans", ui-sans-serif, system-ui, sans-serif;
  --radius-card: 18px; --radius-pill: 999px; --rule-hair: 1px; --rule-bar: 2px;
  --shadow-card: 5px 6px 0 var(--color-ink); --shadow-press: 1px 1px 0 var(--color-ink);
  --tracking-display: 0.005em; --display-weight: 400;
}
```

Colourways [HALLMARK]: `sheet` is the default above. `vinyl`: ground `oklch(21% 0.011 81)`, cards `oklch(25.5% 0.013 72)`, ink `oklch(95.7% 0.013 82)`, rule `oklch(33% 0.016 75)`; pink and lime unchanged and the die-cut borders stay white.

```css no-preview
:root[data-colourway="vinyl"] { --color-paper: oklch(21% 0.011 81); --color-paper-3: oklch(25.5% 0.013 72); --color-ink: oklch(95.7% 0.013 82); --color-rule: oklch(33% 0.016 75); }
```

- Type [HALLMARK]: Bowlby One SC 400, capitals by design, `--tracking-display`, line-height 1.02; wide and heavy, so the `h1` caps at 4.5rem and section heads at 3.25rem; never a paragraph. Figures (prices, counts, step numbers) set in Bowlby; a lone figure on a fill may run to 12rem, the loudest thing the theme owns, so one a screen. Body Sofia Sans 400 and 600, line-height 1.5, `tabular-nums`. Labels, tags, captions and table heads: Sofia Sans 700 one step smaller, sentence case, untracked, `--color-muted`. No third face: the outlier token is Sofia Sans.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Bowlby+One+SC&family=Sofia+Sans:wght@400;600;700&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Bowlby One SC (vietnamese no), Sofia Sans (vietnamese no). Vietnamese copy [DERIVED, measured 2026-11-16]: no vietnamese subset in Bowlby One SC, Sofia Sans, so accents fall back glyph by glyph. For a Vietnamese page swap Bowlby One SC to Paytone One, Sofia Sans to Hanken Grotesk.
- The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- The die-cut: a raised surface (a card, a fill that holds a fact, a tag, a photograph, the primary control) carries a 6px `--color-white` border and `--shadow-card`, a hard offset with no blur. Surfaces that are the sheet itself (a table, a band) stay borderless, parted by the dashed rule. A raised surface may tilt between -6 and 6 degrees, never all one way; tables and inputs stay square.
- Radii: `--radius-card` on cards, 22px on photographs, pills on controls and tags; a 2px dashed `--color-rule` is the divider and the edge of a drop zone. Bands: `--color-paper-2`, a `--color-ink` band with paper type, or one lime field with ink type; two a page at most.
- Photographs: the product in use or held to the lens, close, colour kept loud, 22px radius inside the white die-cut, one a screen tilted 3 degrees or less; a tag may overlap a corner with a fact; type never sits on a picture. No texture and no gradient behind type: depth is the hard offset alone.
- Compositions: facts as die-cut fills (a bento of pink, lime, ink and white tiles, one fact in Bowlby and one Sofia line each, tilted a degree or two in alternate directions, the lead tile carrying the lone figure); steps as stuck-down cards (three or four `<ol>` cards with the numeral in Bowlby on a lime disc, overlapping the dashed rule); a working control on the lime field (a stepper, a running total in Bowlby, a bar that fills toward a threshold, beside a dashed price ladder); a statement in Bowlby on the ink band ten columns wide with one pink or lime tag across its corner.
- Controls: a pink pill with a 5px white ring and `--shadow-card` beside a ghost pill with an inset 2px ink border; chips are pills with a 2px inset rule, the chosen one ink-filled. Links are ink with a pink underline on hover; inputs take a 2px ink edge at `--radius-card`. Colour in thirds: pink for the fills that act (the primary, a price), lime for the fills that mark (a tag, a count, a highlight), ink for the type.
- Motion: sticker physics only: a hover lifts a clickable raised surface 2px and turns it a degree, a press pushes it onto its shadow; `--dur-micro` on `--ease-out`, nothing on scroll. Voice: cheerful and exact (price, quantity, size, ship day), the person at the cutter.

## Component recipes

```css
h1, h2, h3 { font-family: var(--font-display); font-weight: 400; letter-spacing: var(--tracking-display); line-height: 1.02; }
h1 { font-size: min(var(--text-display), 4.5rem); } h2 { font-size: min(var(--text-section), 3.25rem); }
.diecut { border: 6px solid var(--color-white); border-radius: var(--radius-card); box-shadow: var(--shadow-card); }
.diecut--photo { border-radius: 22px; overflow: hidden; background: var(--color-slot); }
.btn { display: inline-flex; align-items: center; height: 52px; padding: 0 var(--space-lg); border: 0; border-radius: var(--radius-pill); background: transparent; font-weight: 700; font-size: var(--text-md); color: var(--color-ink); box-shadow: inset 0 0 0 2px var(--color-ink); }
.btn--primary { background: var(--color-accent); color: var(--color-accent-ink); box-shadow: 0 0 0 5px var(--color-white), 5px 6px 0 var(--color-ink); transition: translate var(--dur-micro) var(--ease-out), box-shadow var(--dur-micro) var(--ease-out); }
.btn--primary:hover { background: var(--color-accent-deep); }
.btn--primary:active { translate: 4px 5px; box-shadow: 0 0 0 5px var(--color-white), var(--shadow-press); }
.fill { border: 6px solid var(--color-white); border-radius: var(--radius-card); box-shadow: var(--shadow-card); background: var(--color-accent); color: var(--color-accent-ink); }
.rule { border-top: var(--rule-bar) dashed var(--color-rule); }
::selection { background: var(--color-accent-2); color: var(--color-ink); }
.fill--lime { background: var(--color-accent-2); color: var(--color-ink); }
.tag { display: inline-block; padding: 2px 12px; border: 4px solid var(--color-white); border-radius: var(--radius-pill); background: var(--color-accent-2); color: var(--color-ink); font-weight: 700; box-shadow: 3px 4px 0 var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 15.59:1 (AAA); muted on paper 5.34:1; white label on the pink fill 5.18:1 and on the deeper pink hover 6.76:1; ink on the lime fill 12.58:1; ink on the white die-cut card 17.41:1; the pink focus ring on paper 4.64:1. Pink on paper measures 4.64:1 (AA), but the rule does not rest on contrast: pink is a fill with white on it, never text on the paper.
- [HALLMARK] Never a soft blurred drop under a raised surface: the shadow is a hard offset or there is none. Never a die-cut border thinner than 4px or in any colour but white. Never a drawn sticker, mascot or doodle: the die-cut edges a real surface, a fact or a photograph. Never a photograph that only stands near the subject; without the product's own pictures, the fills carry the page.
- [HALLMARK] The h1 caps at 4.5rem, section heads at 3.25rem, a lone figure at 12rem and one a screen; Bowlby never sets a paragraph.

## Choose when / avoid when
- Choose: print, sticker, merch and maker shops, creator storefronts, packaging and label businesses, anything loud and handmade that sells physical things.
- Avoid: serious finance, health or enterprise products, calm or soft brands, dense data views, photo-less pages that cannot carry loud fills.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Bowlby+One+SC&family=Sofia+Sans:wght@400;600;700&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-lg);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.2rem,10vw,3.6rem)}</style>
<main class="container" style="display:grid;gap:var(--space-lg);padding-block:var(--space-lg)">
<h1>Stickers cut to order</h1><p class="lead">Upload your art, pick a size, ship on Friday.</p>
<div class="row"><button class="btn btn--primary">Start an order</button><button class="btn">See sizes</button></div>
<div class="fill" style="padding:var(--space-lg);rotate:-2deg"><b style="font-family:var(--font-display);font-size:3.4rem;line-height:1">500</b><br>die-cut stickers from 29p each</div>
<div class="diecut" style="padding:var(--space-md);background:var(--color-white);rotate:1.5deg"><b>Ships Friday</b> when you order by Wednesday.</div>
<p><span class="tag">New: holographic</span></p>
</main>
```
