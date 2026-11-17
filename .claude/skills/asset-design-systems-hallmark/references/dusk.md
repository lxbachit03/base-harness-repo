# Dusk (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/dusk.md`, last changed 1e33562 (2026-10-22), MIT; live sample usehallmark.com/themes/dusk/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, dark slate paper, committed posture: money software at the calm end of the day. A real photograph of land at dusk sits behind the hero, the head set dark on its palest part, the product beside it in smoked glass. Below, the page turns to slate and light surfaces are bone wells. It reads as expensive and unhurried. [HALLMARK]
- Best for: treasury, banking and fintech, payments, reconciliation and ledgers, accounting and month-end close, audit and compliance, cash management, payouts and settlement, finance-team tools.
- Not a neon trading screen or a dashboard of tiles.

## Tokens

```css
:root {
  --color-paper: oklch(17.5% 0.014 268); --color-paper-2: oklch(21% 0.016 268); --color-paper-3: oklch(25% 0.017 268);
  --color-ink: oklch(96% 0.006 75); --color-ink-2: oklch(85% 0.010 262); --color-muted: oklch(70% 0.016 262);
  --color-rule: oklch(30% 0.016 266); --color-light: oklch(100% 0 0); --color-shade: oklch(10% 0.022 268);
  --color-accent: oklch(77% 0.10 274); --color-accent-ink: oklch(19% 0.035 274); --color-accent-hi: oklch(84% 0.085 274);
  --color-accent-deep: oklch(44% 0.13 274); --color-accent-soft: oklch(91% 0.038 274); --color-focus: oklch(80% 0.10 274);
  --color-accent-2: oklch(83% 0.095 62); --color-dusk: oklch(70% 0.12 330);
  --color-day-ink: oklch(22% 0.022 268); --color-day-muted: oklch(38% 0.022 266); --color-fog: oklch(94% 0.012 70);
  --color-well: oklch(95.5% 0.008 75); --color-well-2: oklch(92% 0.010 75); --color-well-ink: oklch(21% 0.016 268); --color-well-muted: oklch(47% 0.016 265); --color-well-rule: oklch(87.5% 0.009 75); --color-card: oklch(99.5% 0.003 75);
  --glass: oklch(22% 0.018 268 / 0.58); --glass-blur: 22px;
  --glass-hi: inset 0 1px 0 oklch(100% 0 0 / 0.10), inset 0 0 0 1px oklch(100% 0 0 / 0.06);
  --shadow-card: 0 1px 0 oklch(100% 0 0 / 0.06) inset, 0 40px 80px -32px oklch(8% 0.02 268 / 0.7);
  --font-display: "Wix Madefor Display", ui-sans-serif, system-ui, sans-serif; --font-body: "Wix Madefor Text", ui-sans-serif, system-ui, sans-serif;
  --radius-card: 18px; --radius-inner: 10px; --radius-pill: 999px; --rule-hair: 1px;
  --tracking-display: -0.022em; --display-weight: 500;
}
```

Three dials [HALLMARK], each stated once on the page; two Dusk pages in one run differ on two: **Hour** (the hero photograph): `fog` (default, a valley of fog under an apricot sky), `shore` (water at dusk, boats or a quay), `ridge` (mountain ridges in haze at first light). **Signals**: `periwinkle-apricot` (default) or `sage-apricot`, with `oklch(80% 0.07 160)` as the first signal. **Product surface**: `glass` (default, smoked glass on slate) or `well` (bone wells carry the hero product too, glass only over photographs).

```css no-preview
:root[data-signals="sage-apricot"] { --color-accent: oklch(80% 0.07 160); }
```

- Type [HALLMARK]: Wix Madefor Display 500 for display (`--tracking-display`, line-height 1.02 to 1.1, sentence case); heads stay modest, the photograph and the product are the loud parts. Body Wix Madefor Text 400 and 500 at 17px, line-height 1.55, leads in `--color-ink-2` or `--color-muted`. Figures use the same faces with `tabular-nums`, cents in `--color-muted` at the same size and never raised; a figure set as a statement goes to Display 500 at 34 to 44px with its cents at 0.6em. Labels, column heads and status: Text 500 one step smaller, sentence case, `--color-muted`; never mono, never tracked capitals.
- Fonts [HALLMARK]: the source loads them with `<link href="https://fonts.googleapis.com/css2?family=Wix+Madefor+Display:wght@400;500;600&family=Wix+Madefor+Text:wght@400;500;600&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Wix Madefor Display (vietnamese yes), Wix Madefor Text (vietnamese yes).
- Dusk is a dark theme: add the foundation's dark error and success pair. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- The hour: a library photograph of land at the turn of the light fills the hero, the head in `--color-day-ink` on its palest part over a fog scrim (`--color-fog` at 40 to 78%, radial, behind the text only), the product in glass on its darker side, the foot fading to `--color-paper`; a second photograph of the same hour may close the page behind the form, two at most. Never a drawn or generated sky.
- Glass: the product's surface, `--glass` blurred, `--glass-hi` for the lit edge, `--shadow-card`; rows inside split on `--color-light` at 7%, inner parts sit on it at 4 to 6% with `--radius-inner`. Wells: a light surface is a bone well at 5:4 holding one white `--color-card`, the caption under it (a title and one muted line). Slate: every band below the hero is `--color-paper`; the nav turns to slate glass once it leaves the photograph.
- Compositions: a run as an account list (accounts with a round initial, line counts in muted, a status word with its icon, balances right-aligned with muted cents, the open item closing the list as an apricot strip with its action); a tour as a list beside one pane (four jobs in a ruled list, the chosen one marked by a periwinkle dot and opened to one line, one glass pane beside it changing with it); a month as a strip of nights (one slim rounded bar a day in periwinkle, its height the work done, a flagged day marked by an apricot dot, the open day in apricot, days still to come hatched, a ruled tally of four figures under it); a hand-off in a well (the note or message the product sends, set as the real card on bone).
- Controls: one periwinkle pill (`--color-accent` under `--color-accent-ink`, a light inset top edge), hover lifting to `--color-accent-hi` with a soft periwinkle ring, and a ghost pill beside it in `--color-light` at 4%. An email field and its button share one pill (frosted fog over a photograph, smoked glass on slate). Tabs are a ruled list with a dot, never boxed segments; switches are periwinkle when on. Two signals, two jobs: periwinkle is done, matched, on and focused; apricot is open, waiting or owed; neither is ever a large fill.
- Motion: the hero photograph drifts 6% over 48 seconds, the product's rows rise in once and staggered, the open dot breathes, panes cross-fade, bars grow from their feet when seen; reduced motion keeps all of it still. Voice: calm and exact, what ran, when, what is left.

## Component recipes

```css
h1, h2, h3 { font-family: var(--font-display); font-weight: var(--display-weight); letter-spacing: var(--tracking-display); }
.num { font-variant-numeric: tabular-nums; } .num .c { color: var(--color-muted); }
.glass { background: var(--glass); border-radius: var(--radius-card); -webkit-backdrop-filter: blur(var(--glass-blur)) saturate(1.35); backdrop-filter: blur(var(--glass-blur)) saturate(1.35); box-shadow: var(--glass-hi), var(--shadow-card); }
.btn { min-height: 48px; padding: 0 var(--space-lg); border: 0; border-radius: var(--radius-pill); background: var(--color-accent); color: var(--color-accent-ink); font: 600 0.9375rem/1 var(--font-body); box-shadow: inset 0 1px 0 color-mix(in oklab, var(--color-light) 35%, transparent); }
.btn:hover { background: var(--color-accent-hi); }
.hero__photo { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
.hero__scrim { position: absolute; inset: 0; background: radial-gradient(ellipse 50% 58% at 20% 56%, color-mix(in oklab, var(--color-fog) 78%, transparent), transparent 78%), linear-gradient(to bottom, transparent 72%, var(--color-paper)); }
.btn--ghost { background: color-mix(in oklab, var(--color-light) 4%, transparent); color: var(--color-ink); box-shadow: inset 0 0 0 1px var(--color-rule); }
.well { padding: var(--space-md); border-radius: var(--radius-card); background: var(--color-well); color: var(--color-well-ink); }
.well .card { padding: var(--space-md); border-radius: var(--radius-inner); background: var(--color-card); }
.strip { padding: var(--space-sm) var(--space-md); border-radius: var(--radius-inner); background: var(--color-accent-2); color: var(--color-accent-ink); font-weight: 500; }
.glass--pale { background: oklch(22% 0.018 268 / 0.70); }
@supports not (backdrop-filter: blur(1px)) { .glass { background: oklch(22% 0.018 268 / 0.94); } }
```

The `@supports` branch is a [DERIVED] fallback so the smoked glass stays legible where `backdrop-filter` is missing; the hero photograph itself is a real library photograph the build supplies, never a drawn one.

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.88:1 (AAA); ink-2 on paper 12.03:1; muted on paper 7.14:1; ink on smoked glass over the slate paper 16.06:1 and over the palest fog, the worst case, only 4.29:1, so where glass sits over the palest part of a photograph raise its alpha to 0.70 (`.glass--pale`, 6.28:1) [DERIVED]; dark label on the periwinkle pill 8.85:1; periwinkle focus ring or dot on paper 9.06:1; the apricot strip's dark label 10.80:1; hero head `--color-day-ink` on fog 14.58:1; well ink on bone well 15.50:1 and well muted 5.96:1.
- [HALLMARK] Never a drawn or generated sky, and never text on the busy part of a photograph. Never a gradient button, a third signal colour or a red debit. Never a grid of stat tiles: figures live in rows, lists and one ruled tally. Never glass on glass, a glow behind glass or glass without its lit edge.
- [DERIVED] Keep the `@supports not (backdrop-filter)` branch with every glass surface.

## Choose when / avoid when
- Choose: finance and accounting software that wants a calm, expensive, photograph-led hero and a smoked-glass product surface: close, reconciliation, treasury, payouts.
- Avoid: playful or consumer brands, light-first pages, loud trading or crypto looks, products with no photograph or product surface to show.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://fonts.googleapis.com/css2?family=Wix+Madefor+Display:wght@400;500;600&family=Wix+Madefor+Text:wght@400;500;600&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.1rem,9vw,3.2rem)}.hero{position:relative;padding-block:var(--space-xl) var(--space-lg)}.hero__bg{position:absolute;inset:0;background:linear-gradient(to bottom,var(--color-fog) 55%,var(--color-paper))}.hero>.container{position:relative;display:grid;gap:var(--space-md)}</style>
<div class="hero"><div class="hero__bg"></div><div class="container">
<h1 style="color:var(--color-day-ink)">Close the month by dusk.</h1><p class="lead" style="color:var(--color-day-muted)">Reconciliation that finishes while you are away.</p>
<div class="row"><button class="btn">See a close</button><button class="btn btn--ghost" style="color:var(--color-day-ink);box-shadow:inset 0 0 0 1px var(--color-day-muted)">Talk to us</button></div>
<div class="glass" style="padding:var(--space-md);display:grid;gap:var(--space-sm)"><div class="row" style="justify-content:space-between"><span>Operating account</span><span class="num">48,210<span class="c">.40</span></span></div><div class="row" style="justify-content:space-between"><span>Payroll</span><span class="num">12,980<span class="c">.00</span></span></div><div class="strip">3 items open</div></div>
</div></div>
```
