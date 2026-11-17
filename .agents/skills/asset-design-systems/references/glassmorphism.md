# Glassmorphism

Evidence labels: [NNG] nngroup.com/articles/glassmorphism (Megan Brown, 2024-06-07) · [MDN] developer.mozilla.org backdrop-filter and prefers-reduced-transparency (read 2026-11-16) · [REF] chrislemke.github.io/website_designs/designs/Glassmorphism.html (third-party guide, tokens) · [DERIVED] computed or chosen here.

## Identity
- Frosted-glass interface: translucent surfaces that blur what sits behind them to create depth and hierarchy; prominent in Apple and Microsoft design systems; trend since about 2020. Design systems file it under "materials" (Fluent "Acrylic", SwiftUI materials, visionOS windows). [NNG]
- Two defining properties: fill **opacity** and **background blur**. Strokes (borders) and gradients are optional depth cues, most useful on plain backgrounds. [NNG] (The third-party guide calls the border a mandatory third pillar; NNG does not.)
- Works when the glass sits in front of gradients, imagery or other complex backgrounds; over a flat colour nothing shows. [NNG][REF]
- Used sparingly to suggest depth; established systems (SwiftUI, Fluent) already solve the hard cases. [NNG]

## Tokens
```css
:root{
  --glass-fill:rgba(255,255,255,.15); --glass-fill-2:rgba(255,255,255,.25); --glass-fill-3:rgba(255,255,255,.40);
  --glass-fill-dark:rgba(17,25,40,.75);
  --glass-edge:rgba(255,255,255,.20); --glass-edge-2:rgba(255,255,255,.30);
  --glass-blur:12px;  /* 8-12 light frost, 16-24 heavy diffusion */
  --glass-sat:150%;
  --glass-radius:16px; --glass-shadow:0 8px 32px rgba(0,0,0,.10);        /* dark theme .37 */
  --glass-highlight:inset 0 1px 0 rgba(255,255,255,.50), inset 0 -1px 0 rgba(255,255,255,.10);
  --bg-cool:linear-gradient(135deg,#4a00e0,#2575fc);
  --bg-aurora:linear-gradient(135deg,#8e2de2,#00d2ff);
  --bg-dark:linear-gradient(135deg,#0f0c29,#302b63 50%,#24243e);
  --font:Inter,system-ui,sans-serif; --fw-body:500;
}
```
- Fill/edge/blur ranges, gradient swatches and dark glass `rgba(17,25,40,.75)` come from the third-party guide [REF]; padding 24-48px inside, 24-32px gaps between cards.

## Recipe
```css
.glass-stage{min-height:100vh;display:grid;place-items:center;padding:2rem;background:var(--bg-cool)}   /* glass needs a colourful backdrop */
.glass{background:var(--glass-fill);border:1px solid var(--glass-edge);border-radius:var(--glass-radius);
  box-shadow:var(--glass-shadow),var(--glass-highlight);padding:32px;color:#fff;
  -webkit-backdrop-filter:blur(var(--glass-blur)) saturate(var(--glass-sat));
          backdrop-filter:blur(var(--glass-blur)) saturate(var(--glass-sat))}
@supports not ((backdrop-filter:blur(1px)) or (-webkit-backdrop-filter:blur(1px))){.glass{background:rgba(17,25,40,.85)}}
@media (prefers-reduced-transparency:reduce){.glass{background:rgba(17,25,40,.95);-webkit-backdrop-filter:none;backdrop-filter:none}}
@media (forced-colors:active){.glass{background:Canvas;border-color:CanvasText;backdrop-filter:none}}
```
- Decorative blurred blobs (`filter:blur(80px)`, 300-400px circles in pink/cyan) behind the glass give the blur something to diffuse. [REF]
- Stack depth: heavier blur on back layers, lighter on front layers. [REF]

## Guardrails
- Meet contrast on the **worst** pixel under the text; translucent text surfaces span many colours. Check with a contrast tool that can sample gradients. [NNG]
- More blur is better, especially over video, photos or animation; low translucency makes the background distracting and text unreadable. If you control the background, use a simple or single-colour one. [NNG]
- Let users reduce transparency or raise contrast (Apple replaces glass with solid colour). [NNG] `prefers-reduced-transparency` is experimental and not Baseline; keep a manual toggle or solid fallback. [MDN]
- `backdrop-filter` is Baseline 2024 (newly available); keep the `-webkit-` prefix for older Safari. [MDN][REF]
- Backdrop-root trap: a parent with `opacity<1`, `filter`, `mask`, `clip-path`, `mix-blend-mode` or `will-change` of those makes the child blur only what lies between parent and child, so the effect seems to vanish. Never put `opacity` on the glass or its ancestors; use `rgba()` fills. [MDN][REF]
- [DERIVED] White text over gradient anchors: #4a00e0 8.87:1, #8e2de2 5.80:1, #2575fc 4.18:1 (fails), #ff0099 3.68:1 (fails), #00d2ff 1.80:1 (fails). A white-tinted fill lightens the surface and lowers white-text contrast: prefer dark-tinted glass (rgba(17,25,40,.45-.75)) or a 25-40% dark scrim for white text; dark text `#111927` on near-opaque white glass is 17.61:1.
- Weight 500+ body, no thin weights; add `text-shadow:0 1px 2px rgba(0,0,0,.1)` only if needed. [REF]
- Performance: blur composites on the GPU; limit glass to key surfaces, avoid nested or animated blur, test on mid-range phones. [REF][DERIVED]

## Choose when / avoid when
- Choose: overlays, floating panels and dashboards over imagery or gradients, media players, OS-like shells, spatial/AR-style interfaces.
- Avoid: dense reading surfaces, forms with long text, low-end devices, accessibility-critical flows, flat or white backgrounds.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap">
<style>body{margin:0;font-family:var(--font)}</style>
<div class="glass-stage" style="position:relative;overflow:hidden"><div style="position:absolute;width:260px;height:260px;border-radius:50%;background:rgba(255,0,153,.5);filter:blur(50px);top:40px;left:20px"></div><div class="glass" style="position:relative;max-width:300px"><h3 style="margin:0 0 8px">Frosted panel</h3><p style="margin:0">Blur and a pale fill over a vivid gradient.</p></div></div>
```
