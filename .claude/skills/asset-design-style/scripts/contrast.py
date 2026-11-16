#!/usr/bin/env python3
"""WCAG 2.x contrast checker for the asset-design-style skill.

Usage:
  python -I contrast.py [--min RATIO] FG:BG [FG:BG ...]

Colours: #rgb, #rrggbb, rgb(r,g,b) or rgba(r,g,b,a).
A translucent FG is composited over the resolved BG. BG may be layers joined by
'>' (top first) that end in an opaque colour, for example
  #ffffff:rgba(17,25,40,.45)>#00d2ff     white text on a dark glass fill over cyan

Prints one row per pair. Exit 0 when every pair meets --min (default 4.5),
1 when a pair falls below it, 2 on unreadable input.
Bars: 4.5 body text (AA), 3 large text and UI edges, 7 enhanced (AAA).
"""
import re
import sys

COLOUR = re.compile(
    r"^(?:#([0-9a-f]{3}|[0-9a-f]{6})"
    r"|rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*([0-9]*\.?[0-9]+)\s*)?\))$"
)


def parse(text):
    m = COLOUR.match(text.strip().lower())
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
        print("%6.2f:1  %-13s %s  %s on %s (bg %s)"
              % (r, band(r), "ok " if ok else "LOW", fg_spec, bg_spec, hex_of(bg)))
    return 1 if below else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
