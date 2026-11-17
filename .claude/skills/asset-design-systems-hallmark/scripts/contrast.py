#!/usr/bin/env python3
"""WCAG 2.x contrast checker for the asset-design-systems-hallmark skill.

Usage:
  python -I contrast.py [--min RATIO] FG:BG [FG:BG ...]

Colours: #rgb, #rrggbb, rgb(r,g,b), rgba(r,g,b,a) or oklch(L C H [/ A]). Hallmark
writes its colours in OKLCH; an OKLCH colour outside sRGB is mapped into it by
reducing chroma (CSS Color 4), the way a browser draws it on an sRGB screen.
Quote an argument that holds spaces: 'oklch(20% 0.014 255):oklch(97% 0.012 95)'.
A translucent FG is composited over the resolved BG. BG may be layers joined by
'>' (top first) that end in an opaque colour, for example
  #ffffff:rgba(17,25,40,.45)>#00d2ff     white text on a dark glass fill over cyan

Prints one row per pair. Exit 0 when every pair meets --min (default 4.5),
1 when a pair falls below it, 2 on unreadable input.
Bars: 4.5 body text (AA), 3 large text and UI edges, 7 enhanced (AAA).
"""
import math
import re
import sys

COLOUR = re.compile(
    r"^(?:#([0-9a-f]{3}|[0-9a-f]{6})"
    r"|rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*([0-9]*\.?[0-9]+)\s*)?\))$"
)
OKLCH = re.compile(r"^oklch\(\s*([^)]*?)\s*\)$")


def _lin_from_oklab(L, a, b):
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    return (4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
            -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
            -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s)


def _oklab_from_lin(r, g, b):
    l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    l_, m_, s_ = (math.copysign(abs(x) ** (1 / 3), x) for x in (l, m, s))
    return (0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
            1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
            0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_)


def _inside(rgb):
    return all(-1e-6 <= v <= 1 + 1e-6 for v in rgb)


def _clip(rgb):
    return tuple(min(1.0, max(0.0, v)) for v in rgb)


def _byte(v):
    v = min(1.0, max(0.0, v))
    v = 12.92 * v if v <= 0.0031308 else 1.055 * v ** (1 / 2.4) - 0.055
    return int(round(255 * v))


def oklch_to_rgb(L, C, hue):
    """Map an OKLCH colour into sRGB bytes (CSS Color 4 chroma-reduction mapping)."""
    if L >= 1:
        return (255, 255, 255)
    if L <= 0:
        return (0, 0, 0)
    h = math.radians(hue)
    rgb = _lin_from_oklab(L, C * math.cos(h), C * math.sin(h))
    if _inside(rgb):
        return tuple(_byte(v) for v in rgb)
    lo, hi, lo_inside = 0.0, C, True
    jnd, eps = 0.02, 0.0001
    while hi - lo > eps:
        chroma = (lo + hi) / 2
        a, b = chroma * math.cos(h), chroma * math.sin(h)
        cur = _lin_from_oklab(L, a, b)
        if lo_inside and _inside(cur):
            lo = chroma
            continue
        clipped = _clip(cur)
        cl, ca, cb = _oklab_from_lin(*clipped)
        delta = math.sqrt((cl - L) ** 2 + (ca - a) ** 2 + (cb - b) ** 2)
        if delta < jnd:
            if jnd - delta < eps:
                return tuple(_byte(v) for v in clipped)
            lo_inside, lo = False, chroma
        else:
            hi = chroma
    a, b = lo * math.cos(h), lo * math.sin(h)
    return tuple(_byte(v) for v in _clip(_lin_from_oklab(L, a, b)))


def _number(text, percent_scale):
    text = text.strip()
    if text.endswith("%"):
        return float(text[:-1]) / 100.0 * percent_scale
    if text.endswith("deg"):
        text = text[:-3]
    return float(text)


def _parse_oklch(body):
    main, _, alpha = body.partition("/")
    parts = [p for p in re.split(r"[\s,]+", main.strip()) if p]
    if len(parts) != 3:
        raise ValueError("oklch needs L C H: %r" % body)
    L = _number(parts[0], 1.0)
    C = _number(parts[1], 0.4)
    hue = _number(parts[2], 360.0)
    a = _number(alpha, 1.0) if alpha.strip() else 1.0
    return oklch_to_rgb(L, C, hue) + (min(max(a, 0.0), 1.0),)


def parse(text):
    text = text.strip().lower()
    ok = OKLCH.match(text)
    if ok:
        try:
            return _parse_oklch(ok.group(1))
        except ValueError:
            raise ValueError("unreadable colour: %r" % text)
    m = COLOUR.match(text)
    if not m:
        raise ValueError("unreadable colour: %r" % text)
    if m.group(1):
        h = m.group(1)
        if len(h) == 3:
            h = "".join(c * 2 for c in h)
        return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), 1.0)
    rgb = tuple(min(255, int(m.group(i))) for i in (2, 3, 4))
    alpha = float(m.group(5)) if m.group(5) else 1.0
    return rgb + (min(alpha, 1.0),)


def over(top, bottom):
    a = top[3]
    return tuple(round(top[i] * a + bottom[i] * (1 - a)) for i in range(3)) + (1.0,)


def flatten(spec):
    layers = [parse(part) for part in spec.split(">")]
    base = layers[-1]
    if base[3] < 1.0:
        raise ValueError("end the background chain with an opaque colour: %r" % spec)
    for layer in reversed(layers[:-1]):
        base = over(layer, base)
    return base


def channel(v):
    s = v / 255.0
    return s / 12.92 if s <= 0.03928 else ((s + 0.055) / 1.055) ** 2.4


def luminance(c):
    return 0.2126 * channel(c[0]) + 0.7152 * channel(c[1]) + 0.0722 * channel(c[2])


def ratio(a, b):
    la, lb = luminance(a), luminance(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)


def band(r):
    if r >= 7:
        return "AAA"
    if r >= 4.5:
        return "AA"
    if r >= 3:
        return "large/UI only"
    return "fail"


def hex_of(c):
    return "#%02x%02x%02x" % c[:3]


def main(argv):
    minimum = 4.5
    pairs = []
    args = list(argv)
    while args:
        a = args.pop(0)
        if a in ("-h", "--help"):
            print(__doc__)
            return 0
        if a == "--min":
            try:
                minimum = float(args.pop(0))
            except (IndexError, ValueError):
                print("--min needs a number", file=sys.stderr)
                return 2
        else:
            pairs.append(a)
    if not pairs:
        print(__doc__, file=sys.stderr)
        return 2
    below = False
    for pair in pairs:
        if ":" not in pair:
            print("pair needs FG:BG, got %r" % pair, file=sys.stderr)
            return 2
        fg_spec, bg_spec = pair.split(":", 1)
        try:
            bg = flatten(bg_spec)
            fg = parse(fg_spec)
        except ValueError as err:
            print(err, file=sys.stderr)
            return 2
        if fg[3] < 1.0:
            fg = over(fg, bg)
        r = ratio(fg, bg)
        ok = r >= minimum
        below = below or not ok
        print("%6.2f:1  %-13s %s  %s on %s (fg %s, bg %s)"
              % (r, band(r), "ok " if ok else "LOW", fg_spec, bg_spec, hex_of(fg), hex_of(bg)))
    return 1 if below else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
