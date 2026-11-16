---
name: asset-design-style
description: "Design styles: apply, choose or compare a named UI style from researched tokens, CSS recipes and contrast guardrails. Use for any design, HTML page, artifact or UI that names a style: Swiss/International Typographic, Neumorphism/soft UI, Glassmorphism/frosted glass, Brutalism/neubrutalism, Claymorphism, Aurora/mesh gradient, Retro-futurism/Cyberpunk/neon, 3D/hyperrealism/skeuomorphism, Vibrant color-block/Maximalist, Dark/OLED luxury, Organic/Biomorphic, Anthropic/Claude look; or when the User asks which style fits a brief."
---

# Asset Design Style

Twelve UI styles, each researched into a reference with tokens, CSS recipes,
guardrails and dated sources. This file lists them, resolves the User's pick,
runs the build and verifies it; the style's own file holds every value.

## 1. Resolve the style

1. The call or request names a style (number, name or alias from the table): use
   it and skip the menu.
2. No style named: print the menu below and end the turn; the reply starts the
   build. Keep any brief that came with the call.
3. A project design system (CLAUDE.md, token or theme file, existing styles)
   outranks this skill; use the reference to fill its gaps. Precedence: the
   User's words, the project's system, this skill.

Done when one primary style, and at most one accent, is named.

| # | Style | Feel | Choose when | Reference |
|---|---|---|---|---|
| 1 | Swiss Minimalism | objective, ordered, grid-led | documentation, editorial, data-dense reading, institutions | [swiss-minimalism](references/swiss-minimalism.md) |
| 2 | Neumorphism | soft, molded, tactile | device-control or music dashboards, calculators, a few hero cards | [neumorphism](references/neumorphism.md) |
| 3 | Glassmorphism | frosted, layered, luminous | overlays and panels over imagery or gradients, media players, OS-like shells | [glassmorphism](references/glassmorphism.md) |
| 4 | Brutalism | raw, blunt, thick-outlined | creative tools, indie SaaS, campaigns (Neo); manifestos, directories (Raw) | [brutalism](references/brutalism.md) |
| 5 | Claymorphism | puffy, friendly, toy-like | kids and learning apps, wellness, playful onboarding | [claymorphism](references/claymorphism.md) |
| 6 | Aurora / Mesh Gradient | dark, glowing, ambient | premium SaaS and AI heroes, launches, creative tools | [aurora-mesh-gradient](references/aurora-mesh-gradient.md) |
| 7 | Retro-Futurism / Cyberpunk | chrome optimism or neon night | games, security and dev tools, launches (Neon); brand stories, events (Atomic) | [retro-futurism-cyberpunk](references/retro-futurism-cyberpunk.md) |
| 8 | 3D Hyperrealism | real materials, depth, lit | product and hardware showcases, games, immersive storytelling | [3d-hyperrealism](references/3d-hyperrealism.md) |
| 9 | Vibrant Block / Maximalist | loud colour slabs, layered excess | campaigns, agencies, events, fashion, Gen Z launches | [vibrant-block-maximalist](references/vibrant-block-maximalist.md) |
| 10 | Dark OLED Luxury | black, gold, editorial calm | luxury and hospitality, premium media, night-use mobile apps | [dark-oled-luxury](references/dark-oled-luxury.md) |
| 11 | Organic / Biomorphic | curved, earthy, warm | wellness, sustainability, food, botanical, hospitality | [organic-biomorphic](references/organic-biomorphic.md) |
| 12 | Anthropic | warm ivory, serif, calm clarity | pages about Anthropic or Claude (brand look); technical references, catalogs and tools people scan (documentation look) | [anthropic](references/anthropic.md) |

### The menu

Print one line per table row in the User's language, style names in English:
`<#>. <Style> - <Feel>. Best for: <Choose when>`. Close with one line that
explains the replies:

- a number or a name picks that style;
- `a + b` picks a primary and an accent (say so once when the pair sits under
  Opposed languages in Combining, then proceed);
- `xem mẫu a b` (or `preview a b`) renders those styles: run
  `python -I <skill folder>/scripts/preview.py a b` from the working folder
  (`<skill folder>` is the base directory shown when this skill loads), report
  the page it writes, then repeat the closing line.

After the pick, a brief in hand goes to step 2; without one, ask once what to
build and in which form: a local .html file (the default) or a claude.ai
Artifact.

When the User asks which style fits a brief, answer with one pick and one
runner-up using these shortcuts, then offer the menu: dense data or forms lean on
Swiss, Anthropic (documentation look) or the neutral dark system in Dark OLED
Luxury; long reading on Swiss, Anthropic or Organic; playful on Claymorphism or
Vibrant Block; premium on Dark OLED Luxury, Aurora or Glassmorphism; technical or
gamey on Cyberpunk, Brutalism or 3D.

A new style is a reference file with the standard sections and a `## Preview`
block, plus one table row; the menu and the preview pick it up.

## 2. Read the reference

Open the chosen file in full. Its **Tokens** and **Guardrails** sections bind the
build. Source tags show confidence: bracketed names mark first-party or standards
sources; `[REF]` marks a third-party guide and `[DERIVED]` a value computed or
chosen by the reference's author, both practice rather than standard.

## 3. Build from tokens

- Start from the reference's `:root` block; derive every colour, radius, shadow,
  type and spacing choice from it.
- Use the substitute value wherever the reference marks a source value as failing
  contrast.
- Output is a local .html file in the working folder. Deliver a claude.ai
  Artifact only when the User asks for one (publishing needs that request): load
  `artifact-design` first and build under its page contract (theme tokens in
  three states, safe-area gutters, allowed hosts); the reference supplies
  palette, type and effects.
- Load fonts from Google Fonts with a real fallback stack.

## 4. Verify

1. Run `python -I <skill folder>/scripts/contrast.py FG:BG ...` on
   every text and control colour pair; the bar is 4.5 for text and `--min 3` for
   large text and UI edges. Join translucent layers with `>` so glass fills and
   scrims are measured over the worst background behind them.
2. Walk the reference's Guardrails bullet by bullet.
3. Add the fallbacks the style uses: `prefers-reduced-motion`,
   `prefers-reduced-transparency`, `forced-colors`, `:focus-visible`, an
   `@supports` branch for `backdrop-filter`.
4. Check a 400px width for horizontal scroll; headless Edge or Chrome renders
   local files, the built-in browser pane cannot open them.

Done when every pair meets its bar and every Guardrails bullet is applied or
marked not applicable.

## 5. Report

One short line: the style used, the tokens substituted for contrast, and what
stayed unrendered or unverified.

## Combining

- Primary plus accent; confine the accent to one component family.
- Shared material language: Aurora with Glassmorphism (glass panels carry the
  text), Dark OLED Luxury with Glassmorphism, Cyberpunk with Glassmorphism, 3D
  with Glassmorphism, Claymorphism with Organic, Swiss with Anthropic
  (documentation look), Neumorphism as an accent on a calm style.
- Opposed languages: Brutalism against Glassmorphism, Neumorphism,
  Claymorphism or Aurora (hard flat edges against soft depth); Swiss against
  Maximalist; Organic against Cyberpunk.
