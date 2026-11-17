# Foundation (the shared layer under every Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark at commit 04977e1 (main, 2026-11-11), MIT: the scaffold in `skills/hallmark/scripts/theme.mjs` (scale tokens, base stylesheet) and `references/craft.md`, `layout.md`, `responsive.md` and the Floor in `SKILL.md` · [DERIVED] condensed or chosen here. Read 2026-11-16.

A Hallmark theme is a material: paper, ink, faces, rules, radius, depth, controls, motion and voice. It does not set the type scale, spacing, durations, canvas or copy rules; those sit in this shared layer and bind every theme. Each theme's token block uses names defined below (`--space-lg`, `--text-display`, `--dur-micro`, `--ease-out`), so a build always carries this block and the base stylesheet together with one theme's block.

## Scale tokens

```css
:root {
  --space-3xs: 2px; --space-2xs: 4px; --space-xs: 8px; --space-sm: 12px; --space-md: 16px; --space-lg: 24px; --space-xl: 40px; --space-2xl: 64px; --space-3xl: 96px; --space-4xl: 144px;
  --text-xs: 0.8125rem; --text-sm: 0.875rem; --text-md: 1rem; --text-lg: 1.25rem; --text-xl: 1.5625rem; --text-2xl: 1.953rem; --text-3xl: 2.441rem;
  --text-display-s: clamp(2.25rem, 4vw + 0.5rem, 3.75rem); --text-display: clamp(2.75rem, 5vw + 1rem, 5.25rem);
  --text-section: clamp(2rem, 2.5vw + 1rem, 3.5rem); --text-title: clamp(1.25rem, 0.75vw + 0.875rem, 1.625rem); --text-lead: clamp(1.125rem, 0.35vw + 1rem, 1.375rem);
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1); --ease-in: cubic-bezier(0.7, 0, 0.84, 0); --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  --dur-micro: 120ms; --dur-short: 220ms; --dur-long: 420ms;
  --color-error: oklch(52% 0.19 27); --color-success: oklch(50% 0.12 150);
  --container: 1440px; --gutter: 64px; --gap-columns: 32px; --section-gap-s: 120px; --section-gap: 144px; --section-gap-l: 176px;
  --z-base: 1; --z-raised: 10; --z-dropdown: 100; --z-sticky: 200; --z-sticky-nav: 300; --z-modal: 400; --z-toast: 500; --z-tooltip: 600;
}
```

For a dark theme (lumen, console, dusk) add this pair after the block, so status colours stay legible on the dark paper. For an app screen instead of a page, shrink the type scale: display 1.728rem, section 1.2rem, title and lead 1rem.

```css no-preview
:root { --color-error: oklch(72% 0.15 27); --color-success: oklch(76% 0.13 150); }
```

## Base stylesheet

```css
*, *::before, *::after { box-sizing: border-box; }
html, body { overflow-x: clip; }
html { scrollbar-color: var(--color-muted) var(--color-paper); scroll-padding-top: var(--space-3xl); }
body { margin: 0; background: var(--color-paper); color: var(--color-ink); font-family: var(--font-body); font-size: var(--text-md); line-height: 1.55; -webkit-font-smoothing: antialiased; caret-color: var(--color-accent); }
::selection { background: color-mix(in oklab, var(--color-accent) 22%, transparent); color: var(--color-ink); }
:focus-visible { outline: 2px solid var(--color-focus); outline-offset: 2px; }
a { color: inherit; text-decoration-thickness: 1px; text-underline-offset: 0.16em; }
h1, h2, h3 { margin: 0; font-family: var(--font-display); font-weight: var(--display-weight, 700); font-synthesis: none; letter-spacing: var(--tracking-display); line-height: 1.05; overflow-wrap: break-word; min-width: 0; text-wrap: balance; }
h1 { max-width: 20ch; font-size: var(--text-display); } h2 { max-width: 30ch; font-size: var(--text-section); } h3 { max-width: 40ch; font-size: var(--text-title); line-height: 1.2; }
.lead { font-size: var(--text-lead); line-height: 1.45; max-width: 52ch; }
p { margin: 0; text-wrap: pretty; }
p:not([class]) { max-width: 65ch; }
img, video { max-width: 100%; height: auto; display: block; }
svg { display: block; }
[hidden] { display: none !important; }
button, input, select, textarea { font: inherit; }
.container { width: 100%; max-width: var(--container); margin-inline: auto; padding-inline: var(--gutter); box-sizing: border-box; }
.num, .figure, td.num { font-variant-numeric: tabular-nums; }
.visually-hidden { position: absolute; width: 1px; height: 1px; overflow: hidden; clip-path: inset(50%); white-space: nowrap; }
@media (max-width: 60rem) { :root { --gutter: 24px; --section-gap-s: 80px; --section-gap: 96px; --section-gap-l: 120px; } }
@media (max-width: 40rem) { :root { --gutter: 16px; --section-gap-s: 56px; --section-gap: 72px; --section-gap-l: 96px; --gap-columns: 16px; } }
@media (prefers-reduced-motion: reduce) { *:not(.keep-motion), *:not(.keep-motion)::before, *:not(.keep-motion)::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; scroll-behavior: auto !important; } }
```

The theme's token block must declare `--color-paper`, `--color-ink`, `--color-muted`, `--color-accent`, `--color-focus`, `--font-display`, `--font-body`, `--tracking-display` and `--display-weight`; the base reads them.

## The Floor

Rules that hold on every build and in every theme; no theme waives them. Values in plain text are [HALLMARK]; this wording is [DERIVED] from the upstream rules.

- Tokens only: colour and font-family come from the declared `:root` tokens; no literal colour or font stack after that block.
- Motion: never `transition: all`; never animate `width`, `height`, `top` or `left`; every animation has a `prefers-reduced-motion: reduce` branch and the content shows with scripting off.
- Labels: no eyebrow line and no label in tracked capitals or small caps; labels, captions, table heads, tags and nav links use the body face (or the theme's label face) one step smaller, sentence case, untracked. No single italic word inside a roman heading.
- Overflow: `overflow-x: clip` on `html` and `body`, never `hidden` or `100vw`; image-bearing grid tracks `minmax(0, 1fr)`; display heads wrap with `overflow-wrap: break-word; min-width: 0`.
- Focus and honesty: every interactive element has an instant `:focus-visible` ring. Invent no metric, testimonial, logo wall or case-study count; a missing fact is a visible dashed slot.
- No decoration tells: no middle-dot meta strings, arrows glued to link text or decorative status dots; no purple-to-blue gradient, card inside a card, emoji icon, or drawn browser or OS window.
- Above the fold at 1280 x 800: a headline of 7 words or fewer, one sentence and the primary action; about 80 words on any one screen; a centred container that does not grow past its cap.

## Defaults a theme may override

These come from Hallmark's shared craft, layout and gate files. Where a theme states a different value, the theme's value stands: Hallmark ranks a theme above its craft, genre and shape files on material, controls and motion, and the theme files set their own type voice (Sticker tracks its display faces positively, Lumen, Studio and Wayfind set display line-heights under 1.0) [DERIVED reading]. The Floor and the User's own words beat both.

- Contrast: body text 4.5:1 (aim for 7:1); large text, icons, focus rings and field edges 3:1. Measure with `scripts/contrast.py`.
- Type: at most two families plus one outlier with a single role; at most three weights on the page; body 16px or more, line-height 1.5 to 1.65, measure 45 to 75ch; display line-height 1.0 to 1.15 and tracking -0.02 to -0.04em; `text-wrap: balance` on heads, `pretty` on body; `tabular-nums` on figures that are compared.
- Controls: 44 to 52px tall on a marketing page (app screens 32 to 40px with a 44px hit area), one filled primary a page, disabled = opacity 0.55 plus `cursor: not-allowed` plus the native attribute, border width never changes with state.
- Control edges: a theme's hairline or faint rim (`--color-rule`, `--color-edge`) is decoration and often measures under 3:1; the label (4.5:1) and the fill step then identify the control, and an input, a ghost button or any control that stands alone takes a 3:1 edge such as `--color-muted`.
- Motion values: `transform` and `opacity` move, and a theme's own recipe may also transition a shadow or a colour (a key's `box-shadow`, a pill's `background-color`); durations are `--dur-micro` 120ms, `--dur-short` 220ms, `--dur-long` 420ms; easing is `--ease-out` for arrivals, `--ease-in` for exits, `--ease-in-out` for toggles, never bare `ease`; at most one reveal a page; no parallax, custom cursor or auto-rotating carousel.
- Canvas: 12 columns inside a 1440px container, gutter 64px (24px under 60rem, 16px under 40rem), column gap 32px; 6 to 9 sections including hero and footer; section gaps 120, 144 or 176px (smaller under 60rem and 40rem as the tokens say); one radius per nesting level; 450 visible words a page at most.
- Copy: use the owner's own nouns; section heads 6 words or fewer; no em or en dashes; no buzzwords such as seamless, robust, empower, elevate, unlock or world-class; a button names its verb.
