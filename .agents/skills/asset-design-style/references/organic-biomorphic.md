# Organic / Biomorphic

Evidence labels: [WIKI-B] en.wikipedia.org/wiki/Biomorphism · [WIKI-P] en.wikipedia.org/wiki/Biophilic_design (both read 2026-11-16) · [REF] chrislemke.github.io/website_designs/designs/{Biomorphic,Biophilic_Design}.html (third-party guides, tokens) · [DERIVED] computed or chosen here.

## Identity
- **Biomorphism**: design elements modelled on natural patterns and shapes that evoke living organisms; the art term was coined by Geoffrey Grigson in 1935 and used by Alfred Barr in 1936; examples: Miró, Arp, Moore, Hepworth; architecture: Gaudí's Sagrada Família, Saarinen's TWA Flight Center; ties to Surrealism and Art Nouveau. Forms stay abstract but evoke life. [WIKI-B]
- **Biophilic design**: increases people's connection with nature to improve health and well-being; "biophilia" (Fromm 1973; E. O. Wilson 1984, the biophilia hypothesis). [WIKI-P]
- In UI the two combine: blob shapes, curved edges, soft asymmetry and fluid gradients (biomorphic), plus earth palettes, natural textures, real nature imagery and breathing room (biophilic). Guides frame biophilic patterns as nature **in** the space (direct), natural **analogues** (shapes, textures), and nature **of** the space (prospect, refuge, mystery, risk). [REF]
- Feeling: warm, calm, welcoming, "a sunlit greenhouse". [REF]

## Tokens
```css
:root{
  --bio-cream:#faf3e8; --bio-ivory:#f5efe4; --bio-sandstone:#d4b896; --bio-sage:#a8bfa0;
  --bio-moss:#5b7c5a; --bio-moss-ink:#4a6a49;           /* moss as text/button fill needs the darker value */
  --bio-forest:#2c4a2c; --bio-bark:#5c4a3a; --bio-earth:#3a3028;
  --bio-teal:#3d8b8b; --bio-river:#6a9eb5; --bio-terracotta:#c17a56; --bio-coral:#e07b60; --bio-rose:#c4938a; --bio-lichen:#d4c77a; --bio-pebble:#8a8578;
  --font-display:"Comfortaa","Nunito",sans-serif;       /* 700, tracking .01em; serif alternative: Cormorant Garamond */
  --font-body:"Nunito","DM Sans",sans-serif;            /* 1.05rem / 1.8 */
  --font-label:"Quicksand",sans-serif;
  --r-1:24px 48px 24px 48px; --r-blob:42% 58% 62% 38% / 45% 55% 45% 55%; --r-mask:40% 60% 55% 45% / 55% 40% 60% 45%;
  --pad-section:80px 40px; --max:960px;
}
```
- Colours come from forest floor, river stone, sand and shallows: muted, warm, low contrast; one vivid botanical accent (coral bloom, spring leaf) at most. [REF]
- Layout: fluid `clamp()` widths, uneven grid tracks (`1fr 1.5fr`, `2fr 1fr`), overlapping blob layers behind content at about 0.12 opacity, curved section transitions (SVG waves or `clip-path:ellipse(120% 100% at 50% 100%)`), generous whitespace. [REF]

## Recipes
```css
.bio-bg{position:relative;overflow:hidden;background:var(--bio-cream)}
.bio-blob{position:absolute;pointer-events:none;opacity:.12;background:var(--bio-moss);border-radius:var(--r-blob);width:500px;height:500px;animation:blob-morph 18s ease-in-out infinite}
@keyframes blob-morph{0%,100%{border-radius:42% 58% 62% 38% / 45% 55% 45% 55%}50%{border-radius:55% 45% 38% 62% / 52% 48% 52% 48%}}
.bio-card{background:var(--bio-ivory);border-radius:var(--r-1);padding:2rem;box-shadow:0 12px 40px rgba(58,48,40,.10)}
.bio-img{aspect-ratio:1;object-fit:cover;border-radius:var(--r-mask);max-width:400px;width:100%;transition:border-radius .8s ease}
.bio-img:hover{border-radius:60% 40% 45% 55% / 45% 60% 40% 55%}
.bio-btn{background:var(--bio-moss-ink);color:#fff;border:0;border-radius:999px;padding:.85rem 1.75rem;font:700 1rem var(--font-label)}
@media (prefers-reduced-motion:reduce){.bio-blob,.bio-img{animation:none;transition:none}}
```
- Blob morph animation: 18-22s loops with gentle easing; slow and subtle only. Soften every edge and diffuse every shadow. [REF]
- Natural textures (linen via two crossed `repeating-linear-gradient`s at 2% alpha, topographic lines, grain) stay faint; use real, well-composed nature photography. [REF]

## Guardrails
- [DERIVED] On cream #faf3e8: forest #2c4a2c 8.97:1, earth #3a3028 11.66:1, darker moss #4a6a49 5.52:1 (text and button fill; white on it 6.09:1), original moss #5b7c5a 4.26:1 (fails as small text; white on it 4.69:1 passes for buttons), teal 3.62:1, terracotta 3.08:1, pebble 3.34:1, coral 2.66:1 (decoration or large text only). #2c4a2c on sage #a8bfa0 5.00:1; #3a3028 on sandstone #d4b896 6.79:1; terracotta as a fill fails both white (3.39:1) and earth text (3.79:1): use sandstone or sage fills for text-bearing surfaces.
- Muted low-contrast palettes tempt weak text: keep body copy at 8:1-class pairs (earth or forest on cream).
- Animate `transform` and `opacity`; animating `border-radius` on large blobs repaints every frame, so keep blobs small, few, and paused under `prefers-reduced-motion`. [DERIVED]
- Avoid neon, sharp 90-degree geometry and hard dividers; do not rely on texture to carry meaning. [REF]
- Organic does not mean imprecise: align text blocks on a clear reading column and keep interactive targets clearly shaped (a soft pill is fine; a blob-shaped button is not).

## Choose when / avoid when
- Choose: wellness, sustainability, food and farm brands, botanical and outdoor products, hospitality, education for children, calm onboarding.
- Avoid: data-dense tools, fintech trust screens, technical documentation, brands whose tone is sharp or high-tech.

## Preview

Markup that `scripts/preview.py` renders beside this file's CSS blocks; a block marked `css no-preview` is skipped.

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Comfortaa:wght@700&family=Nunito:wght@400;700&family=Quicksand:wght@700&display=swap">
<style>body{margin:0;font-family:var(--font-body)}</style>
<div class="bio-bg" style="min-height:600px;padding:32px"><div class="bio-blob" style="top:5%;left:-8%"></div><div class="bio-card" style="position:relative;max-width:300px"><h3 style="margin:0 0 8px;font-family:var(--font-display);color:var(--bio-forest)">Soft edges</h3><p style="margin:0 0 12px;color:var(--bio-earth)">Asymmetric radii, calm earth tones.</p><button class="bio-btn">Grow</button></div><div class="bio-img" style="margin-top:24px;background:var(--bio-sage);height:120px;width:120px"></div></div>
```
