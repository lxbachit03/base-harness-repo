# Dark OLED Luxury

Evidence labels: [NNG] nngroup.com/articles/dark-mode-users-issues (Kohler and Zhang) · [SD] superdesign.dev/styles/dark-mode (computed contrast) · [REF] chrislemke.github.io/website_designs/designs/Dark_Luxe.html (third-party guide, tokens) · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Two ideas stacked: a designed **dark/OLED system** (layered near-black surfaces, light text, desaturated accents, elevation by lightening) and a **luxury editorial voice** (warm metallic accents, high-contrast serif headlines, grain, spotlight lighting, symmetrical calm). [SD][REF]
- OLED facts [NNG]: dark mode saves battery only on OLED screens (about half of phones made in 2023); pure #000000 pixels switch off and save most; a Purdue study measured 67% average savings at 100% brightness but 14% at 30% brightness; image- and video-heavy designs save little.
- Users set dark mode at OS level and expect apps to follow it; mirror the system setting by default. Dark mode is mainly an aesthetic and accessibility feature. [NNG]
- Depth on dark: darkest colours at the bottom layer, lightest on top; a lighter "shadow" on black makes the element look like it glows. [NNG]

## Tokens
```css
:root{ color-scheme:dark;
  --lx-obsidian:#0a0a0a; --lx-onyx:#111111; --lx-charcoal:#1a1a1a; --lx-graphite:#252525; --lx-smoke:#333333;
  --lx-black:#000000;                         /* OLED canvas under media only; text areas use obsidian+ */
  --lx-gold:#d4af37; --lx-gold-antique:#c5a258; --lx-gold-pale:#e8d48b; --lx-rose:#b76e79;
  --lx-ivory:#f5f0e1; --lx-warm-white:#e8e0d0; --lx-muted:#8a8070;
  --lx-burgundy:#6b1024; --lx-emerald:#1b5e3b; --lx-sapphire:#1a3a5c;
  --lx-border:rgba(255,255,255,.12); --lx-gold-line:rgba(212,175,55,.35);
  --font-display:"Playfair Display","Bodoni Moda","Cormorant Garamond",serif;   /* headings, high contrast */
  --font-body:"Montserrat","Raleway",Inter,sans-serif;                          /* 300-400 body, +.02-.04em tracking */
  --section-gap:clamp(80px,10vw,120px); --pad-block:clamp(40px,5vw,60px); --max:1160px;
}
.lx-gold-text{background:linear-gradient(135deg,#bf953f,#fcf6ba 30%,#b38728 50%,#fbf5b7 70%,#aa771c);-webkit-background-clip:text;background-clip:text;color:var(--lx-gold);-webkit-text-fill-color:transparent}
.lx-velvet{position:relative;background-color:var(--lx-onyx)}
.lx-velvet::after{content:"";position:absolute;inset:0;pointer-events:none;mix-blend-mode:overlay;opacity:.04;
  background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 512 512' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E")}
.lx-spot{background:radial-gradient(ellipse at 50% 0%,rgba(212,175,55,.12),transparent 60%),var(--lx-obsidian)}
.lx-img img{filter:brightness(.7) contrast(1.1) saturate(.85)}
.lx-frame{padding:3px;border:1px solid var(--lx-gold);outline:1px solid var(--lx-gold);outline-offset:6px}
```
- Neutral dark system alternative [SD]: surfaces #121212 / #1e1e1e / #2a2a2a / #333333 (each tier +4-6% lightness), text #e6e6e6 (15.0:1) and #a3a3a3 (7.4:1), accent = light-mode 500 colour shifted to 300-400 weight (#8ab4f8 8.9:1), danger #f28b82, border `rgba(255,255,255,.12)`.
- Warm shadows: add a faint gold tone (`rgba(212,175,55,.05)`) to shadow colours. [REF]
- Layout: centered 1100-1200px container, symmetrical balanced columns, 80-120px section rhythm, full-bleed dark sections with contained content. [REF]

## Guardrails
- [DERIVED] On #0a0a0a: ivory #f5f0e1 17.38:1, gold #d4af37 9.42:1, rose #b76e79 5.20:1, muted #8a8070 5.09:1, pewter #5c5c5c 2.96:1 (fails; disabled only). Gold #c5a258 on #111 is 7.81:1; ivory on burgundy #6b1024 is 10.69:1; #0a0a0a on gold 9.42:1 for gold buttons.
- Avoid pure white text and a pure black sole background: halation and eye strain; #fff on #000 is 21:1 yet reads badly. Use off-white text, and keep `#000` for media canvases where battery and image focus matter. [SD][REF]
- Test secondary text on the **lightest** surface it appears on; opacity-based muted text fails silently on elevated tiers. [SD]
- Saturated brand colours that pass on white often fail on dark and vibrate: desaturate to the 300-400 weight. [SD]
- Reserve gold for hierarchy (headings, primary CTA, dividers); do not combine gold with neon or saturated brights. [REF]
- Declare `color-scheme`, honour `prefers-color-scheme`, store a manual toggle on `[data-theme]`; never use `filter:invert(1)` as a theme. Gate shimmer animations behind `prefers-reduced-motion`. [SD][DERIVED]
- Reading-first content: offer a light theme and do not force dark as default. Bright-environment tools default to light. White-background product imagery needs knock-outs. [SD]

## Choose when / avoid when
- Choose: luxury, fashion, hospitality, watches and automotive; premium media and music players; portfolios, invitations; premium fintech; any OLED mobile app with night use.
- Avoid: long-form reading products, outdoor or field tools, catalogs shot on white, brands whose colours cannot be desaturated.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&family=Montserrat:wght@300;400&display=swap">
<style>body{margin:0;background:var(--lx-obsidian);color:var(--lx-ivory);font-family:var(--font-body)}</style>
<div class="lx-spot lx-velvet" style="padding:36px 24px;text-align:center"><h2 class="lx-gold-text" style="font:600 2.2rem var(--font-display);margin:0 0 8px">Maison</h2><p style="margin:0 0 16px;color:var(--lx-warm-white)">Obsidian layers, gold hierarchy.</p><div class="lx-frame lx-img" style="max-width:240px;margin:auto"><div style="height:90px;background:linear-gradient(135deg,#333,#111)"></div></div></div>
```
