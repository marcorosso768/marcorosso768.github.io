#!/usr/bin/env python3
"""Controllo dei titoli h1-h6 sulle pagine costruite (_site).

Regole: un solo <h1> per pagina; nessun salto di livello scendendo (h2 -> h4);
nessun titolo dentro un link o un pulsante (il pulsante va dentro il titolo).
Uso: python3 tools/check-headings.py _site [pagine da escludere come glob...]
Stampa un rapporto in Markdown ed esce con 1 se trova errori.
"""
import fnmatch
import pathlib
import sys
from html.parser import HTMLParser

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr"}


class Outline(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stack = []
        self.headings = []  # (livello, testo, dentro link/pulsante)
        self.current = None

    def handle_starttag(self, tag, attrs):
        if tag in VOID:
            return
        if len(tag) == 2 and tag[0] == "h" and tag[1] in "123456":
            inside = any(t in ("a", "button") for t in self.stack)
            self.current = [int(tag[1]), "", inside]
        self.stack.append(tag)

    def handle_endtag(self, tag):
        if tag in VOID:
            return
        if tag in self.stack:
            while self.stack and self.stack.pop() != tag:
                pass
        if self.current and tag == f"h{self.current[0]}":
            self.headings.append((self.current[0], " ".join(self.current[1].split())[:60], self.current[2]))
            self.current = None

    def handle_data(self, data):
        if self.current is not None:
            self.current[1] += data


def check(path):
    parser = Outline()
    parser.feed(path.read_text(encoding="utf-8"))
    problems = []
    levels = [h[0] for h in parser.headings]
    if levels.count(1) != 1:
        problems.append(f"{levels.count(1)} titoli h1 (deve essercene uno)")
    for (a, ta, _), (b, tb, _) in zip(parser.headings, parser.headings[1:]):
        if b > a + 1:
            problems.append(f"salto h{a} -> h{b}: «{ta}» -> «{tb}»")
    for level, text, inside in parser.headings:
        if inside:
            problems.append(f"h{level} «{text}» dentro un link o un pulsante")
    return problems


def main():
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "_site")
    excluded = sys.argv[2:]
    pages = sorted(p for p in root.rglob("*.html") if not any(fnmatch.fnmatch(str(p.relative_to(root)), g) for g in excluded))
    report, errors = [], 0
    for page in pages:
        problems = check(page)
        if problems:
            errors += len(problems)
            report.append(f"- `{page.relative_to(root)}`")
            report += [f"  - {p}" for p in problems]
    print(f"## Titoli h1-h6: {errors} problemi su {len(pages)} pagine\n")
    print("\n".join(report) if report else "Nessun problema.")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
