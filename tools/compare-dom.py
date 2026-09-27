#!/usr/bin/env python3
"""Confronto del DOM di due build del sito, come lo costruisce il browser (html5lib).

Normalizza le differenze che il browser non vede: hash di cache busting, codifica degli URL,
meta Content-Type duplicato, commenti. Stampa le pagine diverse e le differenze più frequenti.
Uso: python3 tools/compare-dom.py <build_prima> <build_dopo>   (richiede: pip install html5lib)
"""
import collections
import difflib
import pathlib
import re
import sys
import urllib.parse

import html5lib


def canon(path):
    doc = html5lib.parse(path.read_text(encoding="utf-8"), treebuilder="etree", namespaceHTMLElements=False)
    out = []

    def walk(el, depth):
        if not isinstance(el.tag, str):  # commenti
            return
        attrs = dict(el.attrib)
        if el.tag == "meta" and attrs.get("http-equiv", "").lower() == "content-type":
            return
        for key in ("href", "src"):
            if key in attrs:
                attrs[key] = re.sub(r"\?[0-9a-f]{8,}$", "?H", urllib.parse.unquote(attrs[key]))
        out.append("  " * depth + el.tag + " " + " ".join(f"{k}={v}" for k, v in sorted(attrs.items())))
        text = " ".join((el.text or "").split())
        if text:
            out.append("  " * depth + "  #" + (str(hash(text)) if el.tag in ("script", "style") else text))
        for child in el:
            walk(child, depth + 1)
            tail = " ".join((child.tail or "").split())
            if tail:
                out.append("  " * depth + "  #" + tail)

    walk(doc, 0)
    return out


def pages(root):
    return {str(p.relative_to(root)) for p in root.rglob("*.html") if "_pages" not in p.parts}


def main():
    before, after = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
    b, a = pages(before), pages(after)
    if b - a:
        print("Solo prima:", sorted(b - a))
    if a - b:
        print("Solo dopo:", sorted(a - b))
    counts, changed = collections.Counter(), []
    for page in sorted(a & b):
        x, y = canon(before / page), canon(after / page)
        if x != y:
            changed.append(page)
            for line in difflib.unified_diff(x, y, lineterm="", n=0):
                if line[:1] in "+-" and not line.startswith(("+++", "---")):
                    counts[" ".join(line.split())[:160]] += 1
    print(f"Pagine con DOM diverso: {len(changed)} di {len(a & b)}")
    for page in changed:
        print("  ", page)
    for line, n in counts.most_common(60):
        print(n, line)


if __name__ == "__main__":
    main()
