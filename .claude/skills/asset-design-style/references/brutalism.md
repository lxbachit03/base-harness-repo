# Brutalism (raw web brutalism and neubrutalism)

Evidence labels: [BW] brutalistwebsites.com (Pascal Deville, 2014) · [NEUB] neubrutalism.com (guide, 2026) · [REF] chrislemke.github.io/website_designs/designs/{Brutalist_Web_Design,Neubrutalism}.html (third-party guides) · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Name traces to Le Corbusier's béton brut (raw concrete), not to "brutal"; architectural New Brutalism 1950s-70s: exposed structure, material as found. [NEUB]
- Raw web brutalism (named 2014 by Brutalist Websites): a reaction to the lightness, optimism and frivolity of polished web design; browser defaults, monospace, dense text, exposed structure. [BW][NEUB]
- Neubrutalism (2021-): same bluntness turned into a repeatable commercial grammar: thick outlines, hard offset shadows, flat saturated colour, oversized type; more colourful and orderly than raw brutalism. [NEUB]
- Core attitude: explicitness over subtlety; "intentionally emphatic, not accidentally clumsy". [NEUB]
- Pick a mode: **Raw** (document-like, zero polish) or **Neo** (bold product UI). Do not mix them in one page.

## Tokens (Neo)
```css
:root{
  --nb-black:#000; --nb-paper:#fffdf5;
  --nb-yellow:#ffd23f; --nb-coral:#ff6b6b; --nb-sky:#74b9ff; --nb-green:#88d498; --nb-orange:#ffa552; --nb-lav:#b8a9fa;
  --nb-border:3px solid var(--nb-black);                 /* one stroke width token, 2-3px */
  --nb-shadow-s:3px 3px 0 0 #000; --nb-shadow-m:5px 5px 0 0 #000; --nb-shadow-l:8px 8px 0 0 #000;
  --nb-radius:0;
  --font-display:"Syne","Archivo Black","Bebas Neue",sans-serif;  /* 800, uppercase, tracking -.02em, lh 1 */
  --font-head:"Space Grotesk",sans-serif;                          /* 700 */
  --font-body:Inter,"DM Sans",sans-serif;                          /* 400, 1.05rem/1.7 */
  --font-mono:"Space Mono",monospace;
}
```
- Display size `clamp(3rem,7vw,5.5rem)`; labels 0.95rem uppercase tracking .04em; container 1000-1200px; padding 24-32px; touch targets 48px+. [NEUB][REF]
- Palette: one neutral base + black outline + 1-3 saturated accents; no gradients; sections may take different accent colours. [NEUB][REF]

## Recipes (Neo)
```css
.nb-card{background:var(--nb-yellow);border:var(--nb-border);box-shadow:var(--nb-shadow-m);border-radius:var(--nb-radius);padding:1.5rem}
.nb-btn{background:var(--nb-coral);color:#000;border:var(--nb-border);box-shadow:var(--nb-shadow-m);font:700 .95rem var(--font-head);text-transform:uppercase;letter-spacing:.04em;padding:.9rem 1.5rem;transition:transform .08s,box-shadow .08s}
.nb-btn:hover{transform:translate(2px,2px);box-shadow:3px 3px 0 0 #000}
.nb-btn:active{transform:translate(5px,5px);box-shadow:0 0 0 0 #000}       /* presses into its shadow */
.nb-btn:focus-visible{outline:3px solid #000;outline-offset:3px}
```
- Shadow tiers: small 3px (badges, chips), medium 5px (cards, buttons), large 8px (overlays, hero). Predictable z-axis, or hierarchy collapses. [NEUB]
- Layout: "broken but not random": asymmetry at macro level (hero, card stacks), mechanical alignment at micro level (labels, fields); keep navigation and reading flow predictable. [NEUB]
- Nav = bold top bar with thick bottom border, no transparency or blur; sections separated by thick borders; shadows and borders stay full strength at every breakpoint. [REF]

## Raw mode essentials
- Black on white, link #0000ee, visited #551a8b, system or monospace fonts, single-column document flow, visible borders and rules, no radius, no transitions (snap states), no hero images, no hidden navigation. [REF]
- Start from zero CSS and add only what serves function; test with images and JavaScript off. [REF]

## Guardrails
- [DERIVED] Black text on accents: #ffd23f 14.54:1, #ff6b6b 7.57:1, #74b9ff 10.13:1, #88d498 11.92:1, #b8a9fa 10.09:1, on #fffdf5 20.62:1. White on #ff6b6b is 2.78:1 (fails): keep black text on pastel fills.
- Raw palette: #0000ee on #fff 9.40:1, #551a8b 11.01:1, #00ff00 on #000 15.30:1; #ff0000 on #fff 4.00:1 and #808080 on #fff 3.95:1 fail for body text (large text and decoration only).
- Loud is not accessible: never colour alone for state; do not let every component shout at the same volume; body copy stays calm and readable. [NEUB]
- Keep focus visible; honour `prefers-reduced-motion` for the press animation.

## Choose when / avoid when
- Choose (Neo): creative tools, indie SaaS, portfolios, campaigns, dev-tool landing pages needing memorable personality. Choose (Raw): manifestos, directories, zines, performance-first text sites.
- Avoid: regulated, healthcare, finance or luxury contexts needing calm trust; audiences that read long copy at length.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=Space+Grotesk:wght@700&family=Inter:wght@400&display=swap">
<style>body{margin:0;padding:24px;background:var(--nb-paper);font-family:var(--font-body);color:#000}</style>
<h2 style="font:800 1.8rem var(--font-display);text-transform:uppercase;margin:0 0 16px">Bold, boxed</h2><div class="nb-card">Hard shadow, thick border, flat colour.</div><p style="margin-top:24px"><button class="nb-btn">Press me</button></p>
```
