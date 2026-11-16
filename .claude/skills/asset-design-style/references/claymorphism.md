# Claymorphism

Evidence labels: [SD] superdesign.dev/styles/claymorphism (computed contrast, recipe, limits; read 2026-11-16) · [REF] chrislemke.github.io/website_designs/designs/Claymorphism.html (third-party guide, tokens) · [DERIVED] computed or chosen here.

## Identity
- UI elements that look moulded from soft clay: fat rounded corners, light pastel fill, two inner shadows (a bright one on the top edge, a darker one at the bottom) plus one soft outer shadow that floats the object. [SD][REF]
- Term coined by Michal Malewicz (Hype4 Academy) in 2021; the two-inset stack was popularised by Adrian Bece's clay.css and LogRocket walkthrough. [SD]
- Exists largely because neumorphism failed contrast: clay inflates elements **on top of** the page instead of extruding them from it, so element and background keep real contrast. [SD]
- Tone: friendly, safe, toy-like (Duolingo-style chunky buttons, kids' and edtech apps, wellness). [SD]

## Tokens
```css
:root{
  --clay-bg:#f5f5fa; --clay-bg-2:#f0eeff; --clay-bg-3:#eefbf5;
  --clay-white:#ffffff; --clay-lav:#f3e8ff;
  --clay-coral:#f76d6d; --clay-sky:#62cdff; --clay-purple:#d6a2ff; --clay-green:#7ae582; --clay-peach:#ffb347;
  --clay-text:#2d3557; --clay-text-2:#555b7a;                 /* dark text on every fill, see guardrails */
  --clay-shadow-tint:112,100,176;                             /* rgb of a darker, desaturated bg hue */
  --radius-card:32px; --radius-ctl:24px; --radius-pill:999px;  /* ~25% of element height; cards 30-50px */
  --pad-card:2rem;                                            /* 32-48px; gaps 24-40px */
  --font:"Nunito","Quicksand","Poppins",sans-serif;  /* headings 700-800, body 400-600 */
}
```
- Keep backgrounds lighter than the foreground objects; drop shadows lose effect on dark backgrounds. [REF]

## Recipe (three shadows, order matters)
```css
.clay{background:var(--clay-lav);border-radius:var(--radius-card);padding:var(--pad-card);
  box-shadow:
    0 35px 68px rgba(var(--clay-shadow-tint),.30),        /* 1 outer: floats the object */
    inset 0 -8px 16px rgba(95,70,140,.22),                /* 2 inner dark: negative y, underside curve */
    inset 0 8px 16px rgba(255,255,255,.65)}               /* 3 inner light: positive y, highlight */
.clay-btn{background:#c4b5fd;border:0;border-radius:var(--radius-ctl);padding:.875rem 2rem;color:var(--clay-text);
  box-shadow:0 12px 24px rgba(var(--clay-shadow-tint),.35),inset 0 -4px 8px rgba(95,70,140,.25),inset 0 4px 8px rgba(255,255,255,.7);
  transition:transform 120ms ease}
.clay-btn:active{transform:translateY(2px) scale(.98)}      /* squash; never animate the shadows */
.clay-btn:focus-visible{outline:3px solid #6d28d9;outline-offset:3px}
```
- Coloured variant: tint every shadow from the element's own hue (outer 30-45% alpha darker hue; inner dark 20-30% darker at 30-70% alpha; inner light heavily lightened at 50-90% alpha). A diagonal light source (`inset -8px -8px` dark, `inset 8px 8px` light) is the alternative; keep one light source per page. [REF][SD]
- Never pure-black shadows (they look like dirt on pastel). Reversing the inset signs dents the element instead of inflating it. [SD]

## Guardrails
- [SD] White text on #c4b5fd is 1.85:1; #3b2d5e on #f3e8ff is 10.33:1 and on #c4b5fd 6.6:1. #6d28d9 outline on #c4b5fd is 3.85:1 (above the 3:1 non-text bar).
- [DERIVED] #2d3557 text on: #f5f5fa 10.99:1, #7ae582 7.60:1, #ffb347 6.71:1, #62cdff 6.65:1, #d6a2ff 5.95:1, #f76d6d 4.19:1 (large text only). White on #f76d6d is 2.85:1 (fails). Use dark text on pastel fills.
- Reserve the full three-shadow stack for interactive elements; containers get the outer shadow only, or users cannot tell what is pressable. [SD]
- Keep an explicit `:focus-visible` outline; the soft look tempts designers to delete it. [SD]
- Generous padding costs area: 32px padding takes a 300x200 card from 75% to 53% content area versus 16px; avoid on dense dashboards and tables. [SD]
- Animate `transform` and `opacity` only; large-blur shadows are expensive to repaint. Respect `prefers-reduced-motion`. [SD]
- Limit layers to prevent clutter; centered card layouts, max-width 900-1100px. [REF]

## Choose when / avoid when
- Choose: kids' and learning apps, wellness, onboarding, playful consumer finance, illustration-heavy landing pages.
- Avoid: data-dense tools, tables, enterprise admin, serious or regulated tones, dark UIs.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&display=swap">
<style>body{margin:0;padding:24px;background:var(--clay-bg);color:var(--clay-text);font-family:var(--font)}</style>
<div class="clay">Soft clay card with two inner shadows.</div><p style="margin-top:28px"><button class="clay-btn">Squish</button></p>
```
