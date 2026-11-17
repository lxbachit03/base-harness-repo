#!/usr/bin/env python3
"""Render a style preview page for the asset-design-systems skill.

Usage:
  python -I preview.py STYLE [STYLE ...] [--out FILE]

STYLE is a number from the table in SKILL.md, a style name, a reference slug or
a unique fragment of one ("glass", "clay", "retro"). The page holds one isolated
iframe per style, built from that reference's CSS blocks plus its `## Preview`
block, and is written to ./style-preview.html unless --out names another file.
A css block marked `css no-preview` is left out.
Exit 0 on success, 2 on an unknown or ambiguous style or a missing Preview block.
"""
import html
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SKILL = os.path.dirname(HERE)

PAGE = (
    "<!doctype html><meta charset=utf-8>"
    '<meta name=viewport content="width=device-width,initial-scale=1">'
    "<title>Style preview</title>"
    "<style>body{margin:0;background:#8a8a8a;font:14px system-ui,sans-serif}"
    "main{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:12px;padding:12px}"
    "figure{margin:0}figcaption{background:#111;color:#fff;padding:6px 10px;font-weight:600}"
    "figcaption small{font-weight:400;opacity:.7;margin-left:6px}"
    "iframe{width:100%;height:640px;border:0;display:block;background:#fff}</style>"
    "<main>{{CELLS}}</main>"
)


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read().replace("\r\n", "\n")


def styles():
    """Rows of (number, name, reference path) taken from the table in SKILL.md."""
    rows = []
    for line in read(os.path.join(SKILL, "SKILL.md")).split("\n"):
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) >= 5 and cells[0].isdigit():
            link = re.search(r"\((references/[^)]+\.md)\)", cells[-1])
            if link:
                rows.append((int(cells[0]), cells[1], link.group(1)))
    return rows


def norm(text):
    return re.sub(r"[^a-z0-9]+", "", text.lower())


def pick(token, rows):
    token = token.strip()
    if token.isdigit():
        for row in rows:
            if row[0] == int(token):
                return row
        raise ValueError("no style numbered %s" % token)
    key = norm(token)
    if not key:
        raise ValueError("empty style")
    hits = [r for r in rows if key in norm(r[1]) or key in norm(os.path.basename(r[2]))]
    if len(hits) == 1:
        return hits[0]
    if not hits:
        raise ValueError("no style matches %r" % token)
    raise ValueError("%r matches %s; use a number" % (token, ", ".join(h[1] for h in hits)))


def fences(text):
    """Yield (language, info, body) for every fenced block."""
    out, lang, info, buf = [], None, "", []
    for line in text.split("\n"):
        if line.startswith("```"):
            if lang is None:
                head = line[3:].strip().split(None, 1)
                lang = head[0] if head else ""
                info = head[1] if len(head) > 1 else ""
                buf = []
            else:
                out.append((lang, info, "\n".join(buf)))
                lang = None
        elif lang is not None:
            buf.append(line)
    return out


def parts(text):
    """Return (css, preview markup or None) for one reference file."""
    found = re.search(r"^## Preview[^\n]*\n(.*?)(?=^## |\Z)", text, re.S | re.M)
    preview = found.group(1) if found else ""
    rest = text.replace(found.group(0), "") if found else text
    markup = next((body for lang, _, body in fences(preview) if lang == "html"), None)
    css = "\n".join(body for lang, info, body in fences(rest)
                    if lang == "css" and "no-preview" not in info)
    return css, markup


def cell(number, name, ref, css, markup):
    doc = ("<!doctype html><meta charset=utf-8>"
           "<meta name=viewport content='width=device-width,initial-scale=1'>"
           "<style>" + css + "</style>" + markup)
    return ('<figure><figcaption>%d. %s<small>%s</small></figcaption>'
            '<iframe title="%s" srcdoc="%s"></iframe></figure>'
            % (number, html.escape(name), html.escape(ref), html.escape(name),
               html.escape(doc, quote=True)))


def main(argv):
    out = "style-preview.html"
    tokens = []
    args = list(argv)
    while args:
        arg = args.pop(0)
        if arg in ("-h", "--help"):
            print(__doc__)
            return 0
        if arg == "--out":
            if not args:
                print("--out needs a file name", file=sys.stderr)
                return 2
            out = args.pop(0)
        else:
            tokens.append(arg)
    if not tokens:
        print(__doc__, file=sys.stderr)
        return 2
    rows = styles()
    if not rows:
        print("no style table found in SKILL.md", file=sys.stderr)
        return 2
    chosen, cells = [], []
    for token in tokens:
        try:
            number, name, ref = pick(token, rows)
        except ValueError as err:
            print(err, file=sys.stderr)
            return 2
        if number in [c[0] for c in chosen]:
            continue
        css, markup = parts(read(os.path.join(SKILL, ref)))
        if markup is None:
            print("%s has no Preview block" % ref, file=sys.stderr)
            return 2
        chosen.append((number, name))
        cells.append(cell(number, name, ref, css, markup))
    with open(out, "w", encoding="utf-8", newline="\n") as f:
        f.write(PAGE.replace("{{CELLS}}", "".join(cells)))
    print("wrote %s (%s)" % (os.path.abspath(out), ", ".join("%d %s" % c for c in chosen)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
