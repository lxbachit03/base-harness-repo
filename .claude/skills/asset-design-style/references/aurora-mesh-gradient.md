# Aurora / Mesh Gradient

Evidence labels: [SD] superdesign.dev/styles/aurora (recipe, limits; read 2026-11-16) · [REF] chrislemke.github.io/website_designs/designs/Aurora_Gradient.html (third-party guide, tokens) · [DERIVED] computed or chosen here. Search results also list stellae.design, empire-ui.com and fireworkwebdesign.com guides (not read).

## Identity
- Dark-background style where soft, flowing bands of colour (purple, teal, pink, blue) glow like the northern lights behind the content; built from layered radial or conic gradients blurred together over a near-black base. [SD]
- The gradient is the hero; UI around it stays minimal and quiet. Glass panels carry the text. [REF][SD]
- Static aurora = four CSS gradient layers + one blur (zero JavaScript). Animated aurora on premium SaaS heroes usually runs a small WebGL shader (OGL "Aurora" with a colorStops ramp). [SD]

## Tokens
```css
:root{
  --au-midnight:#0b0d1a; --au-base:#05010f; --au-space:#111827; --au-cosmic:#1e1b4b;
  --au-purple:#7c3aed; --au-violet:#a855f7; --au-pink:#ec4899; --au-rose:#f472b6;
  --au-blue:#3b82f6; --au-cyan:#06b6d4; --au-green:#10b981; --au-mint:#34d399; --au-teal:#2dd4bf;
  --au-text:#e0e7ff; --au-text-2:#a5b4fc; --au-text-bright:#f8fafc;
  --au-panel:rgba(10,8,20,.55); --au-panel-edge:rgba(255,255,255,.12); --au-blur:14px;
  --au-orb-blur:80px; --au-drift:18s;
  --font:"Sora","Inter","Outfit",sans-serif;      /* light-medium weights, airy letter-spacing */
  --section-gap:clamp(80px,10vw,140px);
}
```
- Cap the palette at three or four hues; more muddies to brown. [SD]

## Recipe
```css
.aurora{position:relative;overflow:hidden;background-color:var(--au-base);
  background-image:
    radial-gradient(40% 50% at 20% 30%,rgba(99,102,241,.55),transparent 70%),
    radial-gradient(45% 55% at 75% 25%,rgba(45,212,191,.45),transparent 70%),
    radial-gradient(50% 60% at 60% 75%,rgba(236,72,153,.40),transparent 70%),
    radial-gradient(40% 50% at 30% 80%,rgba(139,92,246,.45),transparent 70%)}
.aurora::before{content:"";position:absolute;inset:-20%;
  background:conic-gradient(from 120deg at 50% 30%,#3a29ff,#2dd4bf,#ec4899,#8b5cf6,#3a29ff);
  filter:blur(var(--au-orb-blur)) saturate(1.4);opacity:.55;animation:drift var(--au-drift) ease-in-out infinite alternate}
@keyframes drift{from{transform:translate3d(-4%,-2%,0) rotate(0)}to{transform:translate3d(4%,3%,0) rotate(8deg)}}
@media (prefers-reduced-motion:reduce){.aurora::before{animation:none}}
.aurora-panel{position:relative;z-index:1;background:var(--au-panel);border:1px solid var(--au-panel-edge);border-radius:18px;color:#fff;
  -webkit-backdrop-filter:blur(var(--au-blur));backdrop-filter:blur(var(--au-blur))}
```
- Gradient text for one display heading: `background:linear-gradient(135deg,#7c3aed,#ec4899,#3b82f6,#06b6d4);-webkit-background-clip:text;color:transparent`. [REF]
- Sections can shift gradient phase; wavy SVG dividers or gradient fades between them. [REF]

## Guardrails
- Text goes on a panel, never on the raw drifting gradient: hue and luminance swing as the bands move. [SD]
- [DERIVED] On #0b0d1a: #f8fafc 18.47:1, #e0e7ff 15.68:1, #a5b4fc 9.69:1, #6366f1 4.33:1 (fails for body text; large or decorative only). White on the aurora panel over the brightest blooms: teal 6.91:1, green 7.11:1, pink 10.15:1, violet 10.95:1. White directly on #06b6d4 is 2.43:1 and on #ec4899 3.53:1 (fails): another reason for the panel.
- Dark base is mandatory; aurora over white has nothing to glow against. [SD][REF]
- Slow, meditative motion only (18-20s loops); honour `prefers-reduced-motion`. [SD][REF]
- Static CSS is the safe choice for low-end devices; WebGL adds a canvas, the ogl dependency and GPU cost. [SD]
- One gradient system per page; avoid applying the effect to small elements such as buttons or badges; too many glass layers hurts performance. [REF]
- Pair `backdrop-filter` with a more opaque fallback (see glassmorphism.md).

## Choose when / avoid when
- Choose: premium SaaS and AI product heroes, creative tools, launch pages, music or event sites that want an ambient mood.
- Avoid: light themes, dense reading, low-end audiences, content-heavy documentation.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600&family=Inter:wght@400&display=swap">
<style>body{margin:0;font-family:var(--font);color:#fff}</style>
<div class="aurora" style="min-height:600px;padding:32px;display:grid;place-items:center"><div class="aurora-panel" style="padding:24px;max-width:300px"><h3 style="margin:0 0 8px">Ambient light</h3><p style="margin:0">Text sits on a panel above the gradient.</p></div></div>
```
