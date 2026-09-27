#!/usr/bin/env python3
"""Riassume l'output JSON del validatore Nu (vnu.jar --format json) in Markdown.

Raggruppa i messaggi per testo, con il numero di occorrenze e le pagine coinvolte.
Uso: python3 tools/vnu-report.py vnu.json _site   — esce con 1 se ci sono errori.
"""
import collections
import json
import re
import sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
root = sys.argv[2].rstrip("/") + "/" if len(sys.argv) > 2 else ""
groups = collections.defaultdict(lambda: [0, set()])
for m in data.get("messages", []):
    kind = "errore" if m.get("type") == "error" else "avviso"
    text = re.sub(r"“[^”]{60,}”", "“…”", m.get("message", ""))
    page = m.get("url", "").replace("file:", "").split(root, 1)[-1]
    groups[(kind, text)][0] += 1
    groups[(kind, text)][1].add(page)
errors = sum(v[0] for k, v in groups.items() if k[0] == "errore")
warnings = sum(v[0] for k, v in groups.items() if k[0] == "avviso")
print(f"## Validatore W3C (Nu): {errors} errori, {warnings} avvisi\n")
for (kind, text), (n, pages) in sorted(groups.items(), key=lambda kv: (kv[0][0] != "errore", -kv[1][0])):
    shown = ", ".join(sorted(pages)[:4]) + (f" e altre {len(pages) - 4}" if len(pages) > 4 else "")
    print(f"- **{kind}** ×{n}: {text} ({shown})")
sys.exit(1 if errors else 0)
