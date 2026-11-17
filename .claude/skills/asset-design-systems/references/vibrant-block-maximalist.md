# Vibrant Block / Maximalist

Evidence labels: [REF] chrislemke.github.io/website_designs/designs/{Color_Block,Maximalism}.html (third-party guides, tokens) · [DERIVED] computed or chosen here. Read 2026-11-16. No primary or vendor source was found for this style; treat values as practice, not standard.

## Identity
- **Vibrant block**: the layout is divided into large flat saturated colour areas with hard edges, rooted in De Stijl and Mondrian's primary-colour grids; each section is one confident slab, colour is the section divider. [REF Color_Block]
- **Maximalist** (the loud end): horror vacui, layered patterns, jewel tones, ornate type, collage layouts, "controlled chaos", intentional abundance. [REF Maximalism]
- Choose an intensity: **Block** (orderly, 3-5 colours, no pattern) or **Maximal** (layered patterns and frames, jewel palette). One per page.

## Tokens (Block)
```css
:root{
  --cb-red:#e63946; --cb-navy:#1d3557; --cb-yellow:#ffd60a; --cb-cobalt:#2a6fdb;
  --cb-green:#2dc653; --cb-coral:#ff6b6b; --cb-violet:#7b2d8e; --cb-tangerine:#ff8c42; --cb-teal:#0b8a8a; --cb-blush:#f4acb7;
  --cb-black:#111111; --cb-ivory:#f8f7f2; --cb-white:#ffffff;
  --cb-divider:4px solid var(--cb-black);
  --cb-pad:clamp(40px,6vw,80px); --cb-t:.3s ease;
  --font-display:"Montserrat","Archivo Black","Bebas Neue",sans-serif;   /* 700-900, oversized, often uppercase */
  --font-body:Inter,"Poppins",sans-serif;                                 /* 400 */
}
.cb-section{width:100%;padding:var(--cb-pad)}
.cb-mondrian{display:grid;grid-template-columns:2fr 1fr 1fr;grid-template-rows:1fr 1fr 1fr;gap:4px;background:var(--cb-black);border:4px solid var(--cb-black)}
```
- Layout: full-width stacked bands with no gutters between blocks; Mondrian sub-grids with unequal tracks; the gap colour is the divider colour. No gradients, shadows, textures. [REF]
- Palette discipline: 3-5 dominant colours plus black and white; alternate warm and cool between adjacent sections. [REF]

## Tokens (Maximal)
- Jewel and clash palette [REF]: magenta #b60059, ruby #9b1b30, amethyst #5a175d, sapphire #074e67, emerald #006b3c, forest #00522e, teal #00a1a1, navy #06034d, gold #d5b800 / burnished #d4a017, hot pink #ff1493, electric blue #0066ff; ivory #fff8e7 base. Dark base with vivid overlays works best; metallic gold as the through-line.
- Techniques [REF]: stacked CSS gradient patterns (diagonal stripes, dots, radial glows) on a navy base; ornate multi-border frames (`border` + `outline` + stacked `box-shadow` rings) with corner flourishes; overlapping 12-column collage grid with rotated items; mixed serif/sans/script/display families; exaggerated scale contrast between a huge headline and small body text.

## Recipes (Maximal)
```css
.max-pattern{background-color:#06034d;background-size:auto,60px 60px,auto;
  background-image:repeating-linear-gradient(45deg,transparent 0 20px,rgba(182,0,89,.08) 20px 22px),
    radial-gradient(circle 8px at 30px 30px,rgba(213,184,0,.10),transparent 100%),
    radial-gradient(ellipse at 50% 50%,rgba(0,161,161,.10),transparent 60%)}
.max-frame{padding:2.5rem;border:4px solid #d5b800;outline:3px solid #b60059;outline-offset:6px;
  box-shadow:0 0 0 12px #06034d,0 0 0 15px #00a1a1,0 8px 32px rgba(0,0,0,.5)}
```

## Guardrails
- [DERIVED] Text colour per block, chosen by computed contrast: white on #1d3557 12.36:1; white on #7b2d8e 8.05:1; white on #2a6fdb 4.78:1; black #111 on #ffd60a 13.38:1, on #f4acb7 10.28:1, on #2dc653 8.38:1, on #ff8c42 8.17:1, on #e63946 4.53:1. Failing pairs: white on #e63946 4.17:1, white on #0b8a8a 4.19:1, white on #ff8c42 2.31:1. Large text (>=24px or 18.66px bold) needs 3:1.
- Contrast is non-negotiable in every block; compute it per pair instead of assuming white text on saturated colour. [REF]
- Do not put text over patterns: place copy on a solid panel. Keep one calm zone (plain background, normal spacing) for forms, checkout and long copy.
- Never rely on colour alone for state. Keep hover motion simple (0.3s); honour `prefers-reduced-motion` for any marquee or looping decoration.
- Maximal pages can be heavy: limit stacked gradients and fonts; lazy-load imagery.

## Choose when / avoid when
- Choose: brand and campaign sites, creative agencies, festivals and events, fashion, Gen Z and consumer launches, portfolios.
- Avoid: dense dashboards and admin tools, regulated or trust-critical flows, long reading, anything that must feel calm.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;900&family=Inter:wght@400&display=swap">
<style>body{margin:0;font-family:Inter,sans-serif}</style>
<section style="background:var(--cb-red);color:#111;padding:24px"><b style="font:900 1.6rem Montserrat,sans-serif">BLOCK ONE</b></section><section style="background:var(--cb-yellow);color:#111;padding:24px">Block two</section><section style="background:var(--cb-navy);color:#fff;padding:24px">Block three</section><div class="max-pattern" style="padding:36px"><div class="max-frame" style="color:#fff;background:#06034d">Maximal frame</div></div>
```
