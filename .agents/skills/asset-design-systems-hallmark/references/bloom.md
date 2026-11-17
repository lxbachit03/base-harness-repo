# Bloom (Hallmark theme)

Evidence labels: [HALLMARK] Nutlope/hallmark `skills/hallmark/references/themes/bloom.md`, last changed 0857f9c (2026-10-27), MIT; live sample usehallmark.com/themes/bloom/ · [DERIVED] computed or chosen here. Read 2026-11-16.

## Identity
- Atmospheric genre, light warm paper, committed posture: daylight on a working sheet. Warm off-white paper with a faint grain, the medium's own grid (a piano roll, a timeline, a ruler) printed into the ground and fading out from the stage, umber ink, Ranade with one roman Gambarino moment. The making happens on the grid in rounded clips; the parts you touch are physical, a rubber cap in a bezel, cases slid from a stack. [HALLMARK]
- Best for: generative and creative AI, music, song, video, image and voice tools, expressive consumer creative products, portrait and retouch apps, playgrounds where the user makes something from a prompt.
- Not a dark generative canvas with neon glows, a cream editorial page or a terracotta poster.

## Tokens

```css
:root {
  --color-paper: oklch(97% 0.010 72); --color-paper-2: oklch(94.6% 0.013 70); --color-paper-3: oklch(91.5% 0.016 66);
  --color-ink: oklch(21% 0.024 40); --color-ink-2: oklch(31% 0.022 46); --color-muted: oklch(49% 0.02 56);
  --color-rule: oklch(88% 0.014 64); --color-sheet: oklch(98.7% 0.007 78);
  --color-accent: oklch(53% 0.145 36); --color-accent-2: oklch(66% 0.10 55); --color-accent-soft: oklch(53% 0.145 36 / 0.11);
  --color-accent-ink: oklch(98.5% 0.008 72); --color-focus: oklch(53% 0.145 36);
  --lane-1: oklch(50% 0.04 55); --lane-2: oklch(48% 0.105 28); --lane-3: oklch(70% 0.115 72); --lane-4: oklch(65% 0.085 12);
  --grid-16: oklch(21% 0.024 40 / 0.035); --grid-beat: oklch(21% 0.024 40 / 0.075); --grid-bar: oklch(21% 0.024 40 / 0.15); --grid-row: oklch(21% 0.024 40 / 0.045);
  --rubber: oklch(55% 0.15 34); --rubber-hi: oklch(66% 0.125 42); --rubber-lo: oklch(43% 0.125 31);
  --umber: oklch(30% 0.03 45); --bezel: oklch(92.5% 0.014 68); --case: oklch(93.5% 0.012 70);
  --hi: oklch(99.6% 0.006 80 / 0.75); --shade-1: oklch(21% 0.024 40 / 0.08); --shade-2: oklch(21% 0.024 40 / 0.16); --shade-3: oklch(30% 0.06 40 / 0.28);
  --font-display: "Ranade", ui-sans-serif, system-ui, sans-serif; --font-body: var(--font-display);
  --font-outlier: "Gambarino", Georgia, serif; --font-code: "Geist Mono", ui-monospace, monospace;
  --radius-card: 18px; --radius-inner: 10px; --radius-clip: 6px; --radius-pill: 999px; --rule-hair: 1px;
  --shadow-card: 0 1px 2px oklch(21% 0.024 40 / 0.06), 0 18px 36px -18px oklch(21% 0.024 40 / 0.26);
  --shadow-lift: 0 2px 4px oklch(21% 0.024 40 / 0.07), 0 36px 72px -32px oklch(45% 0.1 40 / 0.34);
  --tracking-display: -0.024em; --display-weight: 600;
}
```

- Type [HALLMARK]: Ranade 600 for every head (`--tracking-display`, line-height 1.04 to 1.08, sentence case, one colour: the ink). Body Ranade 400 at 17 to 18px, line-height 1.55; 500 for labels and controls; three weights in all. The serif moment: Gambarino 400, roman, once a page, either one figure at 160px or more or one lede; never a head, never italic. Labels: Ranade 500 one step smaller, sentence case, `--color-muted`. Geist Mono only for a ruler's fine numerals and timecodes inside the built product.
- Fonts [HALLMARK]: the source loads them with `<link href="https://api.fontshare.com/v2/css?f[]=ranade@400,500,600&display=swap" rel="stylesheet"> <link href="https://api.fontshare.com/v2/css?f[]=gambarino@400&display=swap" rel="stylesheet"> <link href="https://fonts.googleapis.com/css2?family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">`. Google Fonts, so allowed in an Artifact: Geist Mono (vietnamese yes). Fontshare is not an allowed Artifact host: Ranade (substitute Nunito Sans, vietnamese yes), Gambarino (substitute Newsreader, vietnamese yes) [DERIVED]; Fontshare's own vietnamese coverage was not measured.
- The source names a 180px feTurbulence grain without defining it; the recipes below define a stand-in [DERIVED]. The shared scale tokens come from [foundation](foundation.md).

## Surfaces and range
- The ground is the medium's grid in CSS: stacked linear gradients for bars, beats, sixteenths and rows (black-key rows tinted every octave for a piano roll) on `--color-sheet` behind the stage, then continued faintly past it and masked to fade out radially; the grid returns in small crops beside steps and at the close.
- On the grid, the work: four part lanes in `--lane-1` to `--lane-4` tones as rounded clips (`--radius-clip`, a tinted gradient, an inset hairline in the lane tone, a lit top edge) carrying bar waveforms or notes; a hairline playhead; a key strip and a fine-numeral ruler.
- Light from above on every part. Texture is generated: a grain at 5% over the paper and at 30% soft-light on rubber. Two warm blooms stay, quieter than before and fixed: `--color-accent` near 8% top right, `--color-accent-2` near 5% bottom left. Raised warm surfaces, never hairline boxes: `--shadow-card`, and `--shadow-lift` for the one that matters. Two bands at most, never terracotta. Photographs: daylight at home, hands, an instrument by a window, never a studio at night.
- Compositions: the input becoming the output on one grid (what the user gives, a hum, a sketch or a line, drawn as a trace that settles onto the grid with the result growing in lanes beneath, and Play really plays it); choices as cased spines (a stack of cases, each a colour band striped with light, a card label and pips for its parts, the chosen one sliding out while the grid re-arranges); one figure in the serif beside three steps, each with a small crop of the grid; the result as one clip on the grid at the close, downloadable.
- Controls: the primary is a rubber cap in a recessed bezel (a domed `--rubber` radial gradient lit from the top, grain, set in a `--bezel` well with an inset shade) sitting at the left of a `--color-sheet` pill with its label, its ring breathing while the product listens; press sinks it 1px. Secondary: a sheet pill with a shade ring and a lit top edge, or an `--umber` pill. Links are terracotta, underlined on hover; inputs are 52px pills with a 1px `--color-muted` edge.
- Motion: once, in view, the input draws in (about 3 s), notes settle, the playhead glides home and lanes grow; transforms and opacity, paused off screen; reduced motion or no script shows the finished arrangement with the playhead at the start; the blooms never move. Voice: warm, daylight, specific (the verb hum, make or listen; the output song, part or scene; and where).

## Component recipes

```css
:root { --grain: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180'%3E%3Cfilter id='g' x='0' y='0' width='100%25' height='100%25'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='2' stitchTiles='stitch'/%3E%3CfeColorMatrix values='0 0 0 0 .3 0 0 0 0 .22 0 0 0 0 .14 0 0 0 .5 -.2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23g)'/%3E%3C/svg%3E"); }
h1, h2, h3 { font-weight: var(--display-weight); color: var(--color-ink); }
.roll { --beat: 40px; --row: 14px; background-color: var(--color-sheet); background-image: linear-gradient(to right, var(--grid-bar) 1px, transparent 1px), linear-gradient(to right, var(--grid-beat) 1px, transparent 1px), linear-gradient(to right, var(--grid-16) 1px, transparent 1px), linear-gradient(to bottom, var(--grid-row) 1px, transparent 1px); background-size: calc(var(--beat) * 4) 100%, var(--beat) 100%, calc(var(--beat) / 4) 100%, 100% var(--row); }
.clip { --c: var(--lane-1); border-radius: var(--radius-clip); background: linear-gradient(color-mix(in oklab, var(--c) 18%, var(--color-sheet)), color-mix(in oklab, var(--c) 28%, var(--color-sheet))); box-shadow: inset 0 0 0 1px color-mix(in oklab, var(--c) 42%, transparent), inset 0 1px 0 var(--hi); }
.rec { border-radius: 50%; background: radial-gradient(circle at 50% 30%, var(--bezel), var(--color-paper-3)); box-shadow: inset 0 2px 3px var(--shade-2), 0 1px 0 var(--hi); }
.rec__cap { border-radius: 50%; background: radial-gradient(120% 110% at 50% 18%, var(--rubber-hi), var(--rubber) 48%, var(--rubber-lo)); box-shadow: inset 0 1px 0.5px var(--hi), 0 5px 9px -3px var(--shade-3); }
.pill { border-radius: var(--radius-pill); background: var(--color-sheet); box-shadow: 0 0 0 1px var(--shade-1), 0 8px 18px -10px var(--shade-2), inset 0 1px 0 var(--hi); font-weight: 500; }
a { color: var(--color-accent); text-underline-offset: 0.2em; }
.stage { position: relative; background: var(--grain), var(--color-paper); }
.stage::before { content: ""; position: absolute; inset: 0; pointer-events: none; background: radial-gradient(circle at 100% 0, color-mix(in oklab, var(--color-accent) 8%, transparent), transparent 55%), radial-gradient(circle at 0 100%, color-mix(in oklab, var(--color-accent-2) 5%, transparent), transparent 55%); }
.stage > * { position: relative; }
.input { min-height: 52px; padding: 0 var(--space-lg); border: var(--rule-hair) solid var(--color-muted); border-radius: var(--radius-pill); background: var(--color-sheet); color: var(--color-ink); }
```

## Guardrails
- [DERIVED] Contrast, measured with `scripts/contrast.py`: ink on paper 16.24:1 (AAA); ink-2 on paper 12.12:1; muted on paper 5.74:1 and on a sheet pill 6.03:1; terracotta link on paper 5.18:1; ink on the sheet pill 17.06:1; paper-coloured label on the terracotta accent 5.42:1; the pale terracotta `--color-accent-2` on paper 2.94:1 (fail), so it is a bloom and an accent fill, never type.
- [HALLMARK] Never a dark canvas, a neon glow or a third bloom. Never a terracotta field or card: terracotta is rubber, a link or a lane. Never a grid at full strength across a whole section: it fades from the stage. Never an italic serif, and never the serif in a head or in two places.
- [DERIVED] Lane tones are mid-value tints on `--color-sheet`; keep clip labels in `--color-ink`, and measure any text placed on a lane before shipping.

## Choose when / avoid when
- Choose: creative and generative products (music, image, video, voice, portrait) that should feel warm, physical and daylight-lit, with the working surface (a roll, a timeline) as the picture.
- Avoid: dark-first or neon-leaning AI tools, finance or compliance products, minimal developer pages.

## Preview

Sample copy and figures are for the preview only; keep them out of a build, because the Floor bars invented metrics and claims.

```html
<link href="https://api.fontshare.com/v2/css?f[]=ranade@400,500,600&display=swap" rel="stylesheet"><link href="https://api.fontshare.com/v2/css?f[]=gambarino@400&display=swap" rel="stylesheet">
<style>h1{font-size:clamp(2.1rem,9vw,3.2rem)}</style>
<div class="stage"><main class="container" style="display:grid;gap:var(--space-md);padding-block:var(--space-lg)">
<h1>Hum it. We'll make the song.</h1><p class="lead">Turn a hum into a four-part arrangement in your browser.</p>
<div class="pill" style="display:inline-flex;align-items:center;gap:12px;padding:6px 22px 6px 6px;justify-self:start"><span class="rec" style="width:48px;height:48px;display:grid;place-items:center"><span class="rec__cap" style="width:30px;height:30px"></span></span><b>Start humming</b></div>
<div class="roll" style="position:relative;height:140px;border-radius:var(--radius-inner);box-shadow:var(--shadow-card)"><div class="clip" style="--c:var(--lane-2);position:absolute;left:8%;top:14px;width:46%;height:26px"></div><div class="clip" style="--c:var(--lane-3);position:absolute;left:30%;top:50px;width:50%;height:26px"></div><div class="clip" style="--c:var(--lane-4);position:absolute;left:12%;top:86px;width:36%;height:26px"></div></div>
<p style="font-family:var(--font-outlier);font-size:5rem;line-height:1;margin:0">04</p>
</main></div>
```
