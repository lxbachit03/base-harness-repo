# Neumorphism (Soft UI)

Evidence labels: [CSST] css-tricks.com/neumorphism-and-css (Adrian Bece, 2020-03-20) · [REF] chrislemke.github.io/website_designs/designs/Neumorphism.html (third-party guide, tokens) · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- A blend of minimalism and skeuomorphism: elements look extruded from, or pressed into, a background of the same colour. Named in a UX Collective post of December 2019; popularised by Alexander Plyuto's Dribbble shots. [CSST]
- Versus Material Design [CSST]: two shadows (one light, one dark) instead of dark ones; element background equals the parent's; rounded corners are defining; an optional subtle border sharpens edges.
- Depth lives only in shadow. Material metaphor: extruded plastic, molded rubber, embossed paper. [REF]

## Tokens
```css
:root{
  --neu-bg:#e0e5ec; --neu-shadow-dark:#a3b1c6; --neu-shadow-light:#ffffff;
  --neu-text:#2d3436; --neu-text-2:#4b565a;          /* #636e72 from sources fails AA, see guardrails */
  --neu-accent:#3a62d8; --neu-accent-soft:rgba(58,98,216,.15);
  --neu-dist:8px; --neu-blur:15px;  --neu-dist-sm:4px; --neu-blur-sm:8px;  --neu-dist-lg:12px; --neu-blur-lg:24px;
  --radius-card:20px; --radius-ctl:12px; --radius-pill:999px;
  --font:"Nunito Sans","Nunito",Inter,system-ui,sans-serif;   /* rounded, weights 500-700, body >=16px */
}
```
- Other light bases [REF]: warm #e8e0d8, lavender #e6e7ee, neutral #e0e0e0 (shadows #bebebe/#fff), mint #dce8e0, pale blue #dde4f0.
- Dark theme [REF]: base #2d2d2d, dark shadow #252525, light shadow #353535, text #e0e0e0.
- Shadow rule [REF]: dark shadow 15-20% darker than base at 50-80% opacity, light shadow white at 60-80%; blur about 1.5-2x offset; offsets 3-6px for controls, 6-10px for cards, 10-15px for panels.
- Base lightness 80-90% HSL; stay away from pure white or black so both shadows stay visible. [REF][CSST]

## Recipes
```css
.neu-raised {background:var(--neu-bg);border-radius:var(--radius-card);box-shadow:var(--neu-dist) var(--neu-dist) var(--neu-blur) var(--neu-shadow-dark),calc(-1*var(--neu-dist)) calc(-1*var(--neu-dist)) var(--neu-blur) var(--neu-shadow-light)}
.neu-pressed{background:var(--neu-bg);border-radius:var(--radius-card);box-shadow:inset 5px 5px 10px var(--neu-shadow-dark),inset -5px -5px 10px var(--neu-shadow-light)}
.neu-btn{background:var(--neu-bg);color:var(--neu-text);border:0;border-radius:var(--radius-ctl);padding:.875rem 2rem;font:600 1rem var(--font);
  box-shadow:5px 5px 10px var(--neu-shadow-dark),-5px -5px 10px var(--neu-shadow-light);transition:box-shadow .2s ease}
.neu-btn:hover{box-shadow:3px 3px 6px var(--neu-shadow-dark),-3px -3px 6px var(--neu-shadow-light)}
.neu-btn:active{box-shadow:inset 3px 3px 6px var(--neu-shadow-dark),inset -3px -3px 6px var(--neu-shadow-light)}
.neu-btn:focus-visible{outline:3px solid var(--neu-accent);outline-offset:3px}
```
- Convex surface: `linear-gradient(145deg,#e6ebf2,#ccd1d8)` with the raised shadow; concave swaps the gradient order. [REF][CSST]
- One light source for the whole page (top-left). Three depth states only: raised, flat, pressed. [REF][CSST]

## Guardrails
- [DERIVED] On #e0e5ec: #2d3436 10.02:1; #636e72 only 4.14:1 (fails AA); #b2bec3 1.50:1 (decoration/disabled only); #4b565a 5.97:1 (use for secondary text). Shadow edge #a3b1c6 against the base is 1.72:1, below the 3:1 non-text bar, so add a label, icon, accent state or 1px border so controls read as controls. White text on #4d7cff is 3.72:1 (fails); on #3a62d8 it is 5.36:1.
- Colour constraint removes the "stand out" lever: primary CTA needs a solid accent fill or a stickered inset, not a bare neumorphic bump. [CSST]
- Everything starts to look like a button; progress bars resemble scrollbars; clickable vs static becomes unclear. Keep it for static containers and a few controls. [CSST]
- Use as an accent on top of another style, sparingly; diminishing returns and a plastic look when dominant. [CSST]
- Add `@media (forced-colors:active)` with real borders; shadows vanish there. Keep generous padding (32-48px inside, 24-40px gaps); shrink offsets under 768px. [REF][DERIVED]

## Choose when / avoid when
- Choose: music, smart-home or device-control dashboards, calculators, concept hero cards, tactile product shots.
- Avoid: forms-heavy apps, data tables, anything with many interaction and validation states, accessibility-critical products.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;600;700&display=swap">
<style>body{margin:0;padding:24px;background:var(--neu-bg);color:var(--neu-text);font-family:var(--font)}</style>
<div style="display:grid;gap:24px"><div class="neu-raised" style="padding:24px">Raised card</div><div class="neu-pressed" style="padding:24px">Pressed well</div><div><button class="neu-btn">Primary action</button></div></div>
```
