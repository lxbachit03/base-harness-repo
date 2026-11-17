# Retro-Futurism / Cyberpunk

Evidence labels: [WIKI] en.wikipedia.org/wiki/Retrofuturism (read 2026-11-16) · [REF] chrislemke.github.io/website_designs/designs/{Retro_Futurism,Cyberpunk}.html (third-party guides, tokens) · [DERIVED] computed or chosen here. superdesign.dev/styles/retro covers the 1990s Windows/GeoCities "retro web" look, a different sub-style, used only for its general accessibility cautions.

## Identity
- Retrofuturism is the remembering of earlier eras' anticipation of the future: old-fashioned "retro" styles blended with futuristic technology, tension between past and future, and between the alienating and empowering effects of technology; prevalent again from the early 2020s. [WIKI]
- Two moods share the name. Pick one per project:
  - **Atomic / Space-Age** (mid-century optimism): Googie, Streamline Moderne, chrome, starbursts, atomic orbits, pulp sci-fi illustration. Optimistic, never gritty. [REF]
  - **Cyberpunk / neon** (dystopian night city): near-black canvas, neon glow, HUD panels, glitch, scanlines, terminal type. Gritty and synthetic. [REF]
- Not the same as Synthwave (neon grid on purple sunset, 1980s nostalgia). Keep them separate. [REF]

## Tokens: Atomic / Space-Age
```css
:root{
  --ra-navy:#0e1a2b; --ra-charcoal:#1c2a3a; --ra-space:#0a0f1a;
  --ra-chrome:#c0c0c0; --ra-chrome-hi:#e2e2e2; --ra-chrome-lo:#8a8a8a; --ra-cream:#fff5e1;
  --ra-turquoise:#00c9b7; --ra-coral:#ff6b57; --ra-gold:#f0a500; --ra-red:#d0342c;
  --ra-font-display:"Orbitron","Audiowide",sans-serif;   /* uppercase, tracking .1em, 700 */
  --ra-font-deco:"Monoton","Bungee",sans-serif;           /* hero only, clamp(3rem,8vw,8rem) */
  --ra-font-body:"Jost","Space Grotesk",sans-serif;       /* mono accents: Space Mono */
  --ra-radius:24px 24px 8px 8px;                          /* streamlined panel */
}
```
- Motifs: orbit rings (1.5px turquoise at 50% alpha, 6s rotate), starbursts, boomerang shapes, ray beams (conic-gradient at 0.06 opacity), chrome strip `linear-gradient(90deg,#8a8a8a,#e2e2e2,#c0c0c0,#e2e2e2,#8a8a8a)` 4px on panel tops, chrome text via 180deg silver gradient with background-clip:text, sweeping clip-path dividers, faint grain or halftone. [REF]
- Layout: asymmetric, diagonal, tilted panels, floating orbital arrangements, generous whitespace; process photos with vintage grading or halftone. [REF]

## Tokens: Cyberpunk / neon
```css
:root{
  --cy-void:#0a0a0f; --cy-steel:#12121a; --cy-gunmetal:#1a1a2e; --cy-slate:#2a2a3e;
  --cy-cyan:#00f0ff; --cy-blue:#0080ff; --cy-magenta:#ff0080; --cy-green:#00ff41; --cy-amber:#ffb800; --cy-red:#ff1744; --cy-purple:#b000ff;
  --cy-text:#e0e0ec; --cy-text-2:#8a8aa6;                 /* #6a6a8a from sources fails AA */
  --cy-glow-cyan:0 0 10px rgba(0,240,255,.5),0 0 40px rgba(0,240,255,.15);
  --cy-font-ui:"Share Tech Mono","IBM Plex Mono",monospace; --cy-font-display:"Orbitron","Rajdhani","Exo 2",sans-serif;
}
```
- Cool colours (cyan, blue) mean interactive or informational; warm (amber, red) mean warning or danger; 2-3 neon accents per page. [REF]
- Effects: scanline overlay `repeating-linear-gradient(0deg,transparent 0 2px,rgba(0,0,0,.15) 2px 4px)`; glitch via two pseudo-element copies and clip-path keyframes (3s); cut-corner buttons with clip-path; thin neon borders instead of shadows; faint grid lines; HUD details (corner brackets, data labels); backdrop-blur panels; decorative katakana. [REF]

## Recipes
```css
/* Atomic */
.ra-panel{position:relative;overflow:hidden;padding:2.5rem;border:1px solid var(--ra-chrome-lo);border-radius:var(--ra-radius);
  background:linear-gradient(135deg,var(--ra-charcoal),rgba(28,42,58,.8));color:var(--ra-cream)}
.ra-panel::before{content:"";position:absolute;inset:0 0 auto 0;height:4px;background:linear-gradient(90deg,#8a8a8a,#e2e2e2,#c0c0c0,#e2e2e2,#8a8a8a)}
.ra-chrome-text{font:900 clamp(2rem,5vw,4rem) var(--ra-font-display);text-transform:uppercase;letter-spacing:.08em;
  background:linear-gradient(180deg,#e8e8e8,#f5f5f5 25%,#a0a0a0 50%,#d0d0d0 75%,#b0b0b0);-webkit-background-clip:text;background-clip:text;color:transparent;filter:drop-shadow(2px 2px 0 rgba(0,0,0,.3))}
/* Cyberpunk: clip-path also clips box-shadow, so the glow rides on a wrapper */
.cy-glow{filter:drop-shadow(0 0 8px rgba(0,240,255,.5))}
.cy-panel{position:relative;padding:1.5rem;background:var(--cy-gunmetal);border:1px solid var(--cy-cyan);color:var(--cy-text);
  clip-path:polygon(0 0,calc(100% - 16px) 0,100% 16px,100% 100%,16px 100%,0 calc(100% - 16px))}
.cy-scan::after{content:"";position:absolute;inset:0;pointer-events:none;background:repeating-linear-gradient(0deg,transparent 0 2px,rgba(0,0,0,.15) 2px 4px)}
.cy-title{font-family:var(--cy-font-display);text-transform:uppercase;letter-spacing:.12em;color:var(--cy-cyan);text-shadow:0 0 10px rgba(0,240,255,.5)}
@media (prefers-reduced-motion:reduce){*{animation:none!important}}
```

## Guardrails
- [DERIVED] Atomic on #0e1a2b: turquoise 8.36:1, coral 6.24:1, gold 8.40:1, chrome 9.61:1, cream 16.15:1, rocket red #d0342c 3.50:1 (fails: large or decorative only). On cream: turquoise 1.93:1 and coral 2.59:1 fail, so text on cream stays navy (16.15:1); navy on turquoise 8.36:1 and on coral 6.24:1 for buttons.
- [DERIVED] Cyber on #0a0a0f: #e0e0ec 15.09:1, cyan 14.02:1, green 14.47:1, amber 11.39:1, magenta 5.23:1, blue 5.20:1, red 5.13:1, purple #b000ff 4.03:1 (fails body text), source secondary #6a6a8a 3.80:1 (fails); #8a8aa6 is 5.89:1 and #c084fc is 7.47:1.
- Glow, glitch and scanlines carry mood, not text: apply glow only to headings and key controls, keep body copy un-glowed, lower scanline alpha on text-heavy panels, `pointer-events:none` on overlays. When everything glows, nothing stands out. [REF]
- Motion: glitch and rotation loops are accents; keep flashing under three flashes per second (WCAG 2.3.1) and gate all loops behind `prefers-reduced-motion`. [DERIVED]
- Atomic mood: slow rotating starburst at most; do not go dystopian or gritty, do not use neon-grid-on-purple clichés. Cyber mood: no light backgrounds, no rounded friendly type, no cute illustration. [REF]

## Choose when / avoid when
- Choose Atomic: brand stories, museums and events, product launches with optimistic tech, games and kids' science. Choose Cyberpunk: games, security and dev tools, crypto/AI launch pages, music and event sites.
- Avoid: conversion and checkout flows, long-form reading, healthcare, finance, enterprise admin.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Orbitron:wght@700;900&family=Jost:wght@400&display=swap">
<style>body{margin:0;padding:20px;background:var(--ra-navy);color:var(--ra-cream);font-family:var(--ra-font-body);display:grid;gap:20px}</style>
<div class="ra-panel"><div class="ra-chrome-text">Atomic</div><p>Chrome strip, navy panel.</p></div><div class="cy-glow"><div class="cy-panel cy-scan"><div class="cy-title">Neon HUD</div><p>Cut corners, scanlines, glow on the wrapper.</p></div></div>
```
