# Coral (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/coral.md`, last changed 3d760dd (2026-10-21), MIT; live sample usehallmark.com/themes/coral/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Modern-minimal genre, light paper, restrained posture: a warm, plain product voice made physical. Fine stationery on a felt desk, seen from above in one daylight from the left. Records are cotton sheets, envelopes and index cards with real edges; controls are letterpress cards; one coral ink is pressed in where something is settled. [HALLMARK]
- General Sans carries every role; Geist Mono sets figures in a column. [HALLMARK]
- Best for: SaaS and platforms, billing, payments and invoicing, fintech, dashboards for small teams, onboarding and trust-led products with a warm, human, calm tone.
- Not a cream editorial page, a skeuomorphic toy or a blue SaaS template.

## Tokens

```css
:root {
  --color-paper: oklch(97% 0.006 55); --color-paper-2: oklch(94.5% 0.007 55); --color-paper-3: oklch(91.5% 0.009 55);
  --color-ink: oklch(21% 0.012 38); --color-ink-2: oklch(29% 0.013 40); --color-muted: oklch(47% 0.013 45);
  --color-rule: oklch(87% 0.009 55); --color-rule-2: oklch(81% 0.011 55);
  --color-accent: oklch(74% 0.125 30); --color-accent-ink: oklch(21% 0.012 38); --color-accent-2: oklch(54% 0.165 29); --color-focus: oklch(54% 0.17 30);
  --color-cotton: oklch(98.8% 0.0045 80); --color-desk: oklch(94.3% 0.008 64); --color-print: oklch(23% 0.012 38);
  --color-board: oklch(22% 0.011 40); --color-board-type: oklch(96.5% 0.006 70); --color-paid: oklch(55.5% 0.15 33);
  --tex-cotton: url("cotton.svg"); --tex-desk: url("felt.svg");
  --shade: 32% 0.03 50; --lit: 100% 0.005 80; --deep: 7% 0.01 40;
  --font-display: "General Sans", ui-sans-serif, system-ui, sans-serif; --font-body: var(--font-display);
  --font-outlier: "Geist Mono", ui-monospace, monospace;
  --radius-card: 8px; --radius-input: 6px; --radius-pill: 999px; --radius-stock: 8px; --rule-hair: 1px;
  --shadow-card: 0 1px 2px oklch(20% 0.01 35 / 0.05);
  --edge-stock: inset 0 1px 0 oklch(var(--lit) / 0.9), inset 0 -1px 0 oklch(var(--shade) / 0.07), 0 0 0 0.5px oklch(var(--shade) / 0.22), 0 1px 0 oklch(var(--shade) / 0.12);
  --cast-stock: 6px 5px 10px -6px oklch(var(--shade) / 0.3); --cast-stock-lift: 12px 10px 18px -8px oklch(var(--shade) / 0.3);
  --press-groove: inset 1px 1.5px 2px oklch(var(--shade) / 0.16), inset -1px -1px 0 oklch(var(--lit) / 0.9), 0 0 0 0.5px oklch(var(--shade) / 0.2);
  --tracking-display: -0.03em; --display-weight: 600;
}
```

- Type [HALLMARK]: General Sans 600 for display (`--tracking-display`, line-height 1.02 to 1.08, sentence case, roman); a lone price sets at two to three times `--text-display`, tracked -0.05em, line-height 0.85, its unit beside it at `--text-title` in 500. Body General Sans 400 and 500: `--color-print` on stock, `--color-board-type` on the board. Labels 500 one step smaller, sentence case, `--color-muted`. Figures in a column: Geist Mono 400 (General Sans has no tabular figures); a price inside a sentence or head stays General Sans.
- Fonts [HALLMARK]: the source loads them with `<link href="https://api.fontshare.com/v2/css?f[]=general-sans@400,500,600&display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Geist+Mono:wght@400&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Geist Mono (vietnamese yes). Fontshare is not an allowed Artifact host: General Sans (substitute Hanken Grotesk, vietnamese yes) [DERIVED]; Fontshare's own vietnamese coverage was not measured.
- The source names `--tex-cotton` and `--tex-desk` as files its build writes (`cotton.svg`, `felt.svg`); the recipes below redefine them as inline SVG [DERIVED]. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- One light, from the left: each paper object takes a lit edge top and left, a shade edge bottom and right and a cast falling right (`--edge-stock`, `--cast-stock`). The colour parts of those shadows are the `--shade`, `--lit` and `--deep` triplets.
- The hero ground is a desk: `--color-desk` under a daylight radial from the left and a felt texture. Records the product handles are stationery on it: invoices, letters and statements on cotton sheets, a window envelope with glassine showing the address, replies as correspondence index cards, a groove pressed into a card. Each is CSS on `--color-cotton`, sized from one unit so it scales whole. Texture is generated, never a picture; sections stay plain.
- The settled state (paid, signed, booked) is pressed into the stock: the word in General Sans 600 in `--color-paid`, through an SVG filter that offsets a shade wall into the letterforms and lets a noise mask leave the ink uneven, tilted a few degrees. One `--color-ink` band, the board; stationery on it casts from `--deep`. Photographs are rare: work at arm's length in daylight, muted.
- Compositions: the job played as paperwork on the desk (a sheet into an envelope, a reply card tucked under, the outcome pressed in); records as an index of cotton cards with offset tabs beside the full sheet; the price on the board as a huge lone figure in paper beside a ruled list; the recipient's side built on cotton with a groove control rewriting it live.
- Controls are letterpress cards, not pills: 8px radius, 48px tall, cotton stock with `--edge-stock` and `--cast-stock` and the label pressed in (a lit text shadow below it); the primary is ink board with the label pressed the other way. Hover lifts 1px into `--cast-stock-lift`; active presses 1px down. A choice of two to four is a groove (`--press-groove`, 12px radius) with a cotton card riding in it. Inputs 48px, 6px radius, 1px `--color-muted` border, deep coral focus. Status is an ink outline; coral is spent only on the pressed settled state, link underlines and focus.
- Motion: once, after fonts load and in view, the job plays on the desk in about six seconds with transforms and opacity only, paused off screen, then still; reduced motion and no script show the finished state. Voice: plain, warm second-person sentences about the work and the money; never cute.

## Component recipes

```css
:root {
  --tex-cotton: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='360' height='360'%3E%3Cfilter id='c' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.011 .9' numOctaves='2' seed='3' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .5 0 0 0 0 .42 0 0 0 0 .32 0 0 0 .35 -.14'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23c)'/%3E%3C/svg%3E");
  --tex-desk: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Cfilter id='d' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.55' numOctaves='3' seed='8' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .4 0 0 0 0 .34 0 0 0 0 .28 0 0 0 .55 -.2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23d)'/%3E%3C/svg%3E");
}
h1, h2, h3 { font-weight: var(--display-weight); }
.desk { background-color: var(--color-desk); background-image: radial-gradient(90% 120% at 0% 30%, var(--color-cotton), transparent 62%), var(--tex-desk); }
.stock { background-color: var(--color-cotton); background-image: linear-gradient(100deg, var(--color-cotton), transparent 45%), var(--tex-cotton); color: var(--color-print); box-shadow: var(--edge-stock), var(--cast-stock); }
.btn { min-height: 48px; padding: 0 var(--space-lg); border: 0; border-radius: var(--radius-stock); font-weight: 500; transition: transform var(--dur-short) var(--ease-out); }
.btn--card { background-color: var(--color-cotton); background-image: var(--tex-cotton); color: var(--color-print); text-shadow: 0.5px 0.75px 0 var(--color-cotton); box-shadow: var(--edge-stock), var(--cast-stock); }
.btn--ink { background: var(--color-board); color: var(--color-board-type); text-shadow: 0 -0.75px 0 var(--color-ink); box-shadow: var(--cast-stock); }
.btn:hover { transform: translateY(-1px); box-shadow: var(--edge-stock), var(--cast-stock-lift); } .btn:active { transform: translateY(1px); }
.fig { font-family: var(--font-outlier); font-variant-numeric: tabular-nums; }
a:hover { text-decoration-color: var(--color-accent-2); }
.groove { display: inline-flex; padding: 4px; border-radius: 12px; background: var(--color-paper-3); box-shadow: var(--press-groove); }
.groove > * { min-height: 40px; padding: 0 var(--space-md); border: 0; border-radius: 8px; background: transparent; font-weight: 500; color: var(--color-ink); }
.groove > [aria-pressed="true"] { background-color: var(--color-cotton); background-image: var(--tex-cotton); box-shadow: var(--edge-stock), var(--cast-stock); }
.paid { display: inline-block; font-weight: 600; color: var(--color-paid); rotate: -4deg; mix-blend-mode: multiply; text-shadow: 0.6px 0.8px 0 oklch(var(--shade) / 0.35); }
```

The `.paid` rule is a [DERIVED] static stand-in for the upstream pressed-ink SVG filter; keep the word in `--color-paid`, tilted, and uneven if the page can afford the filter.

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: print ink on cotton 16.41:1 (AAA); body ink on paper 16.31:1; muted on paper 6.26:1 and on cotton 6.63:1; board type on the ink board 15.69:1; deep coral link or focus on paper 5.02:1; the settled word in `--color-paid` on cotton 4.94:1. Coral `--color-accent` on cotton is 2.35:1 (fail): it is a pressed ink on one settled state, never type or a fill behind text.
- [HALLMARK] Never cool paper, a blue signal or a second light; every shadow falls right. Never a pill button or a flat square button: controls are pressed cards. Never a photograph of paper; stationery is built in CSS. Never coral as a band, a fill behind text or a head.
- [HALLMARK] General Sans has no tabular figures: set figures in a column in Geist Mono; keep a price inside a sentence in General Sans.
- [DERIVED] The two textures are static inline-SVG stand-ins for the generated cotton and felt; keep them faint, they sit under every paper object and the desk, never under running text on plain sections.

## Choose when / avoid when
- Choose: warm, plain B2B or consumer products about money and paperwork (billing, invoicing, payments, onboarding, small-team dashboards) where trust and calm matter.
- Avoid: developer or API products, loud consumer brands, dark mode requests, pages that need a cool or technical register.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://api.fontshare.com/v2/css?f[]=general-sans@400,500,600&display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Geist+Mono:wght@400&display=swap" rel="stylesheet">
<style>.row{display:flex;gap:var(--space-sm);flex-wrap:wrap;align-items:center}h1{font-size:clamp(2.1rem,8vw,3rem)}</style>
<div class="desk" style="min-height:640px"><main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Get paid, plainly.</h1><p class="lead">Invoices, reminders and receipts on one desk.</p>
<div class="row"><button class="btn btn--ink">Send an invoice</button><button class="btn btn--card">See the ledger</button></div>
<div class="stock" style="padding:var(--space-lg);border-radius:var(--radius-card);display:grid;gap:var(--space-xs)"><b>Invoice 0412</b><span class="fig">£1,240.00 due 14 Dec</span><span class="paid">Paid</span></div>
<div class="groove" role="group" aria-label="View"><button aria-pressed="true">Open</button><button aria-pressed="false">Settled</button></div>
</main></div>
```
