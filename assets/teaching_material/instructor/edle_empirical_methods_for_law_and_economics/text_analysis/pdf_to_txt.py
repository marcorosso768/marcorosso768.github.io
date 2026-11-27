"""
LECTURE 8 - FROM PDF TO TEXT (shown in class; students do not need to run it)

Turns the 25 constitution PDFs of Constitute Project into plain-text files,
one sentence (or numbered clause) per line, ready to be read by Stata.

Folder text_analysis/ (next to the folder stata/):
  constitutions_pdf/   input: the 25 PDF files (e.g. Italy_2012-en.pdf)
  constitutions_txt/   output: one .txt file per constitution (e.g. Italy_2012.txt)
                       and constitutions_list.csv, one row per constitution
The text files are then read by Stata (Lecture 8, Guided Stata 1), which builds
stata/do/data/constitutions_text.dta.

Requirements: Python 3 and the program pdftotext (part of poppler).
  With Anaconda:  conda install -c conda-forge poppler
Run from the folder text_analysis/:
  python pdf_to_txt.py

What a PDF contains, and what we drop:
  - pdftotext -bbox writes every word with its position on the page and its height;
  - page 1 is a cover page: dropped;
  - tables of contents and topic indexes: dropped;
  - page headers and footers (top and bottom of the page): dropped by position;
  - the topic labels printed in the margin are in a smaller font: dropped by height;
  - article and chapter headings are in a larger font: used to start a new sentence, not kept;
  - the remaining lines are joined and split into sentences.
"""
import collections
import csv
import glob
import html
import os
import re
import subprocess

PDF_DIR = "constitutions_pdf"
TXT_DIR = "constitutions_txt"

ISO3 = {"Austria": "AUT", "Belgium": "BEL", "Bulgaria": "BGR", "Croatia": "HRV",
        "Czech_Republic": "CZE", "Denmark": "DNK", "Estonia": "EST", "Finland": "FIN",
        "France": "FRA", "German_Federal_Republic": "DEU", "Greece": "GRC",
        "Hungary": "HUN", "Ireland": "IRL", "Italy": "ITA", "Latvia": "LVA",
        "Lithuania": "LTU", "Netherlands": "NLD", "Norway": "NOR", "Poland": "POL",
        "Portugal": "PRT", "Romania": "ROU", "Slovenia": "SVN", "Spain": "ESP",
        "Sweden": "SWE", "Switzerland": "CHE"}
NAMES = {"Czech_Republic": "Czechia", "German_Federal_Republic": "Germany"}


# ---- Step 1. Words with their position --------------------------------------
def words(page):
    """List of (x_min, y_min, x_max, y_max, word) for one page of pdftotext -bbox."""
    found = re.findall(r'<word xMin="([\d.]+)" yMin="([\d.]+)" '
                       r'xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</word>', page)
    return [(float(a), float(b), float(c), float(d), html.unescape(t))
            for a, b, c, d, t in found]


def lines_of(ws):
    """Group words into lines by their vertical position; return (height, text)."""
    rows = collections.defaultdict(list)
    for w in ws:
        rows[round((w[1] + w[3]) / 2)].append(w)
    merged = []
    for k in sorted(rows):                       # words up to 2 points apart = same line
        if merged and k - merged[-1][0] <= 2:
            merged[-1][1].extend(rows[k])
        else:
            merged.append([k, list(rows[k])])
    out = []
    for _, r in merged:
        r.sort(key=lambda w: w[0])               # left to right
        height = max(w[3] - w[1] for w in r)
        out.append((height, " ".join(w[4] for w in r)))
    return out


# ---- Step 2. Keep the body text ---------------------------------------------
def body_lines(bbox_file):
    """('H', text) for headings, ('B', text) for body lines."""
    pages = open(bbox_file, encoding="utf-8").read().split("<page ")[1:]
    units = []
    for i, p in enumerate(pages):
        if i == 0:                               # cover page
            continue
        # drop margin labels (small font) and page headers/footers (top/bottom)
        ws = [w for w in words(p) if (w[3] - w[1]) > 9.5 and 35 < w[1] < 750]
        txt = " ".join(w[4] for w in ws)
        if re.search(r"Table of contents|Topic index", txt) or txt.count(". . .") > 3:
            continue                             # table of contents, index
        for height, t in lines_of(ws):
            units.append(("H" if height >= 13.5 else "B", t))
    return units


# ---- Step 3. Split into sentences -------------------------------------------
def sentences(units):
    out, buf = [], ""

    def flush():
        nonlocal buf
        if buf.strip():
            # a sentence ends with . ; or : followed by a capital letter, a digit or a bracket
            for s in re.split(r'(?<=[.;:])\s+(?=[A-Z0-9(\[“"‘])', buf.strip()):
                s = s.strip()
                while len(s) > 600:              # very long clauses: cut at a space
                    cut = s.rfind(" ", 0, 600)
                    cut = cut if cut > 100 else 600
                    out.append(s[:cut].strip())
                    s = s[cut:].strip()
                if s:
                    out.append(s)
        buf = ""

    for kind, t in units:
        if kind == "H":                          # a heading closes the previous text
            flush()
            continue
        if re.match(r"^(\d+|[a-z]|[ivx]+)[.)]\s", t) or re.match(r"^\(\d+\)\s", t):
            flush()                              # a numbered clause starts a new sentence
        if buf.endswith("-") and t[:1].islower():
            buf = buf[:-1] + t                   # word hyphenated across two lines
        else:
            buf = (buf + " " + t) if buf else t
    flush()

    res, carry = [], ""                          # attach lone numbers ("1.", "(2)") to the next sentence
    for t in out:
        if len(t.split()) <= 2 or re.fullmatch(r"[\d\s°.()a-z]+", t):
            carry = (carry + " " + t).strip()
            continue
        res.append((carry + " " + t).strip() if carry else t)
        carry = ""
    return res


# ---- Run on all PDFs --------------------------------------------------------
os.makedirs(TXT_DIR, exist_ok=True)
rows = []
for pdf in sorted(glob.glob(os.path.join(PDF_DIR, "*-en.pdf"))):
    cid = os.path.basename(pdf).replace("-en.pdf", "")          # e.g. Italy_2012
    key, year_text = cid.rsplit("_", 1)
    bbox = os.path.join(TXT_DIR, cid + "_bbox.html")
    subprocess.run(["pdftotext", "-bbox", pdf, bbox], check=True)
    cover = subprocess.run(["pdftotext", "-f", "1", "-l", "1", pdf, "-"],
                           capture_output=True, text=True, encoding="utf-8").stdout
    m = re.search(r"Constitution of\s+(\d{4})", cover)
    sents = sentences(body_lines(bbox))
    os.remove(bbox)
    with open(os.path.join(TXT_DIR, cid + ".txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(sents) + "\n")
    rows.append([cid, ISO3[key], NAMES.get(key, key.replace("_", " ")),
                 m.group(1) if m else "", year_text])
    print(f"{cid:30s} {len(sents):6d} sentences")

with open(os.path.join(TXT_DIR, "constitutions_list.csv"), "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f)
    w.writerow(["constitute_id", "economy_code", "country", "year_adopted", "year_text"])
    w.writerows(rows)
