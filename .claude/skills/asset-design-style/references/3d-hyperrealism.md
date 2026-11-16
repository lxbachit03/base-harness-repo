# 3D Hyperrealism

Evidence labels: [NNG] nngroup.com/articles/skeuomorphism (Megan Chan, 2024-03-15) · [REF] chrislemke.github.io/website_designs/designs/{3D_Immersive,Light_Skeuomorphism}.html (third-party guides, tokens) · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Interfaces that suggest real objects, materials and space. Two layers, usable alone or together:
  - **Material realism** (CSS): a single light source, tinted shadows, gradients, inset highlights, embossed text, tactile button states. [REF Light_Skeuomorphism]
  - **Spatial 3D** (WebGL / Three.js / Spline): parallax depth layers, rendered 3D models, scroll-driven camera, atmospheric lighting. [REF 3D_Immersive]
- Skeuomorphism has two meanings: a functional learning aid (a folder icon, paper with a folded corner) and a visual trend of unnecessary realism. Familiar metaphors lower the learning curve; the trend produced clutter, slower loads and dated looks. [NNG]
- Realism must map to interaction: Pizza Hut's tilt-to-place-toppings failed because the physical action did not read as a digital input. [NNG]

## Tokens: material realism (light)
```css
:root{
  --sk-bg:#f5f0eb; --sk-surface:#ede5dc; --sk-raised:#e8e0d8; --sk-pressed:#d8d0c8;
  --sk-text:#4a4240; --sk-text-2:#6a605a;              /* #7a706a from the guide is 4.26:1 on #f5f0eb */
  --sk-emboss-light:#fffefa; --sk-emboss-dark:#9a8a80;
  --sk-coral:#d4836a; --sk-sky:#7ca8c8; --sk-sage:#8aaa8a; --sk-gold:#c8a86a;
  --sk-shadow:rgba(138,126,114,.35);                   /* warm brown, never pure black */
  --sk-radius:14px;                                    /* 8-16px */
  --light-angle:135deg;                                /* one light, top-left */
}
.sk-card{background:linear-gradient(180deg,#f1ebe4,var(--sk-raised));border-radius:var(--sk-radius);padding:2rem;
  box-shadow:inset 1px 1px 0 rgba(255,255,255,.8),inset -1px -1px 0 rgba(138,126,114,.15),6px 8px 16px var(--sk-shadow),-2px -2px 6px rgba(255,255,255,.7)}
.sk-well{background:var(--sk-pressed);border-radius:10px;box-shadow:inset 3px 3px 6px rgba(138,126,114,.4),inset -2px -2px 5px rgba(255,255,255,.7)}
.sk-btn{background:linear-gradient(180deg,#f1ebe4,var(--sk-raised));color:var(--sk-text);border:0;border-radius:10px;padding:.8rem 1.6rem;font:600 1rem Inter,system-ui,sans-serif;
  box-shadow:inset 1px 1px 0 rgba(255,255,255,.8),3px 4px 8px var(--sk-shadow);transition:box-shadow .18s ease,transform .18s ease}   /* 150-200ms ease between states */
.sk-btn:active{box-shadow:inset 2px 2px 5px rgba(138,126,114,.45);transform:translateY(1px)}
.sk-emboss{text-shadow:1px 1px 0 var(--sk-emboss-light),-1px -1px 0 var(--sk-emboss-dark)}
```
- Lighting model: highlight on the top and left edges, shadows fall bottom-right, inset shadows darkest at top-left, gradients light-to-dark along the same axis; drive every value from custom properties so the light is adjustable in one place. [REF]
- Dark variant: invert the model (lighter shadows become glows, pressed areas become darker recesses) with the same metaphor. [REF]

## Tokens: spatial 3D (dark canvas)
```css
:root{
  --imm-void:#0b0b0f; --imm-space:#101018; --imm-indigo:#161630; --imm-slate:#1e1e2e;
  --imm-cyan:#00e5ff; --imm-violet:#7c3aed; --imm-magenta:#e040fb; --imm-amber:#f59e0b; --imm-green:#10b981;
  --imm-fog:#94a3b8; --imm-text:#f1f5f9;
  --font-display:"Exo 2",sans-serif;     /* 700, uppercase, tracking .04em */
  --font-body:Inter,system-ui,sans-serif; /* 1rem / 1.75 */
}
```
- Layout: 100vh "scenes"; a persistent `<canvas>` as the base layer; floating glass panels (see glassmorphism.md) for text; sticky scroll sections; CSS-only parallax with `perspective:1px` and layers at `translateZ(-2px) scale(3)` / `translateZ(-1px) scale(2)`. [REF]
```css
.imm-parallax{perspective:1px;height:100vh;overflow-x:hidden;overflow-y:auto;transform-style:preserve-3d}
.imm-back{position:absolute;inset:0;transform:translateZ(-2px) scale(3);z-index:-1}
.imm-mid{position:absolute;inset:0;transform:translateZ(-1px) scale(2)}
@media (prefers-reduced-motion:reduce){.imm-parallax{perspective:none}.imm-back,.imm-mid{transform:none}}
```
- Depth is hierarchy: nearer means more important. Motion needs a purpose. [REF]

## Guardrails
- Performance first: hold 60fps, animate `transform` and `opacity` only, deliver glTF/GLB with Draco meshes and KTX2/basis textures, lazy-load, move heavy work off the main thread. [REF]
- Progressive enhancement: build the 2D page first; test `canvas.getContext('webgl2')`; skip the scene when absent or when `prefers-reduced-motion` is set; show a poster image fallback. [REF][DERIVED]
- Never hijack scroll without escape; keep keyboard, touch and trackpad navigation; add scroll cues. Do not auto-play heavy scenes on mobile. [REF]
- Text never sits on the raw canvas: put it on a glass panel or scrim. [DERIVED]
- [DERIVED] Light palette on #f5f0eb: #4a4240 8.65:1, #7a706a 4.26:1 (fails AA, use #6a605a), #a09890 2.51:1 (disabled only), #d4836a 2.56:1 and white on it 2.89:1 (decorative; use dark text on coral). Dark palette on #0b0b0f: #f1f5f9 17.93:1, #94a3b8 7.66:1, cyan 12.77:1, amber 9.15:1, magenta 5.89:1, red #ef4444 5.22:1, violet #7c3aed 3.45:1 (fails for text; icons and large type only).
- Use realism only where it explains function; flat controls beside a hero object are fine. Skeuomorphic excess adds clutter and load. [NNG]

## Choose when / avoid when
- Choose: product and hardware showcases, games, automotive, immersive storytelling, creative portfolios, configurators.
- Avoid: documentation, forms, dashboards, content that must be indexed or read quickly, low-end or battery-sensitive audiences, accessibility-critical flows.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap">
<style>body{margin:0;padding:24px;background:var(--sk-bg);color:var(--sk-text);font-family:Inter,system-ui,sans-serif}</style>
<div class="sk-card"><h3 class="sk-emboss" style="margin:0 0 8px">Lit from the top left</h3><p>One light, warm shadows.</p><div class="sk-well" style="padding:12px;margin:12px 0">Pressed well</div><button class="sk-btn">Tactile</button></div>
```
