# Swiss Minimalism (International Typographic Style)

Evidence labels: [WIKI] en.wikipedia.org/wiki/International_Typographic_Style · [SMASH] smashingmagazine.com/2009/07/lessons-from-swiss-style-graphic-design (Diogo Terror, 2009) · [REF] chrislemke.github.io/website_designs (third-party guide, tokens) · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- A systemic approach to graphic design that emerged in the 1930s-1950s and was formalised at the Basel and Zürich schools; built on Constructivism, De Stijl and Bauhaus. [WIKI]
- Hallmarks: mathematical grid, asymmetric layout, sans-serif type (Akzidenz-Grotesk, Univers, Helvetica), flush-left ragged-right text, photography instead of illustration, objective tone. [WIKI]
- Principle: the solution emerges from the content (Ernst Keller); form follows function; type does the work ornament does elsewhere; "the content is the interface". [WIKI][SMASH]
- Sibling terms: "International Typographic Style" names the 1920s-30s state, "Swiss Style" the 1950s-60s grid systems (Müller-Brockmann). Sources use them interchangeably. [WIKI]

## Tokens
```css
:root{
  --ink:#1a1a1a; --ink-2:#666666; --paper:#ffffff; --paper-2:#f5f5f5; --rule:#cccccc; --black:#000000;
  --accent:#e30613;                       /* one accent per composition; alt #0057a8 */
  --font:"Inter","Helvetica Neue",Helvetica,Arial,sans-serif;
  --fs-display:clamp(3rem,5vw,5rem); --fs-h2:clamp(1.75rem,3vw,2.5rem); --fs-body:1rem; --fs-label:.75rem;
  --lh-body:1.5; --lh-display:1; --track-display:-.03em; --track-label:.08em;
  --cols:12; --gutter:24px; --margin:48px; --max:1200px; --unit:8px;   /* margin 32px <=1024, 20px <=600 */
  --radius:0; --rule:1px; --rule-strong:3px; --t:150ms ease;
}
```
- Neutral ramp [REF]: #000, #1a1a1a, #333, #555, #666, #999, #ccc, #eee, #f5f5f5, #fafafa, #fff. Accents [REF]: red #e30613, signal red #cc0000, blue #0057a8, steel #336699, yellow #ffcc00, green #006633.
- Type: one neo-grotesque family in many weights (300-900). Web substitutes for Helvetica: Inter, Roboto, IBM Plex Sans, Barlow, Archivo, Work Sans, DM Sans. [REF]
- Hierarchy by size and weight contrast: huge words are the entry points. [SMASH]

## Layout
- 12-column modular grid (3, 4, 6 or 12 columns by density), gutter 24px, baseline-aligned text, asymmetric placement (text in cols 1-5, figure in cols 7-12). [REF][WIKI]
- Whitespace is an active element; remove markers and ornaments instead of adding them. [SMASH]
- Structure data semantically (definition lists, tables), not only visually. [SMASH]
- Photography in grayscale with contrast 1.05; captions 12px/1.5. [REF]

## Component recipes
```css
.page{display:grid;grid-template-columns:repeat(var(--cols),1fr);gap:var(--gutter);max-width:var(--max);margin-inline:auto;padding-inline:var(--margin)}
.btn{border:2px solid var(--black);background:transparent;padding:.75rem 1.25rem;font:600 .875rem/1 var(--font);text-transform:uppercase;letter-spacing:var(--track-label);transition:background var(--t),color var(--t)}
.btn:hover{background:var(--black);color:var(--paper)}
.btn:focus-visible{outline:3px solid var(--accent);outline-offset:2px}
.rule-strong{border-top:var(--rule-strong) solid var(--black)}
.photo{filter:grayscale(1) contrast(1.05)}
```
- Card = text under a top rule, no card chrome. Input = bottom rule 1px, focus rule 3px in accent. Table = horizontal rules only. Navigation = text links, uppercase labels.

## Guardrails
- [DERIVED] Contrast on #fff: #1a1a1a 17.40:1, #666 5.74:1 (AA), #999 2.85:1 (fails: rules and decoration only), #e30613 4.88:1 (AA), #0057a8 7.17:1, #ffcc00 1.51:1 (never as text; black on #ffcc00 is 13.89:1). #666 on #f5f5f5 is 5.27:1.
- Left-align all text; cap measure at 60-75ch; use flat 100% opaque colours; radius 0; no shadows, gradients or textures. [REF]
- Motion only when it informs (150ms ease). Keep visible focus rings.

## Choose when / avoid when
- Choose: documentation, editorial and reading products, data-dense dashboards, institutional or portfolio sites, anything where clarity outranks mood.
- Avoid: playful consumer brands, children's products, emotional storytelling that needs texture or illustration.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap">
<style>body{margin:0;background:var(--paper);color:var(--ink);font-family:var(--font)}h1{margin:0 0 .5rem;font-size:2.2rem;line-height:1;letter-spacing:var(--track-display);font-weight:800}</style>
<main class="page" style="padding-block:24px"><div style="grid-column:1/8"><h1>Grid, type, one red.</h1><p>Left-aligned copy on a 12-column grid. The accent is used once.</p><button class="btn">Read more</button></div><div style="grid-column:8/13"><div class="photo" style="height:96px;background:linear-gradient(#bbb,#333)"></div><div class="rule-strong" style="margin-top:12px"></div></div></main>
```
