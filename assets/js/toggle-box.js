// Pillole (abstract, keywords, JEL, Cite): apertura e chiusura con un'unica animazione.
// Ogni pillola è un <button class="toggle-pill" aria-controls aria-expanded data-target> (markup in
// _includes/research/entry.liquid); qui si aggiorna aria-expanded quando la casella si apre o si chiude.
// Si anima l'altezza della casella fra due valori in pixel misurati prima di partire; padding, margini
// e bordo seguono la stessa transizione CSS, così il testo sotto si sposta in un solo movimento.
// La sezione che contiene la pillola non viene toccata: aperta, ha altezza libera (max-height: none).
const BOX_FALLBACK_MS = 700; // se transitionend non arriva (movimento ridotto, scheda nascosta)
const CLOSE_LABEL = { en: "Close", it: "Chiudi", es: "Cerrar" };
const COPIED_LABEL = { en: "Copied", it: "Copiato", es: "Copiado" };

function finishBox(box) {
  clearTimeout(box._toggleTimer);
  if (box.classList.contains("active")) {
    box.style.height = "auto"; // aperta: segue il contenuto anche se la finestra cambia larghezza
  } else {
    box.style.display = "none";
    box.style.height = "";
  }
}

function watchBox(box) {
  clearTimeout(box._toggleTimer);
  box._toggleTimer = setTimeout(() => finishBox(box), BOX_FALLBACK_MS);
}

// Da mobile la casella appena aperta può finire sotto il bordo dello schermo (per esempio sotto un abstract
// già aperto): la pagina scorre quanto basta per mostrarla, senza mai portarne l'inizio sotto la barra in alto.
function revealBox(box, target) {
  const rect = box.getBoundingClientRect();
  const navbar = document.getElementById("navbar");
  const topLimit = (navbar ? Math.max(navbar.getBoundingClientRect().bottom, 0) : 0) + 8;
  const overflow = rect.top + target + 16 - window.innerHeight; // 16: margine sotto la casella aperta
  if (overflow <= 0) return;
  const delta = Math.min(overflow, rect.top - topLimit);
  if (delta <= 0) return;
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  window.scrollBy({ top: delta, behavior: reduce ? "auto" : "smooth" });
}

function expandBox(box) {
  if (box.classList.contains("active")) return;
  const start = box.style.display === "block" ? box.offsetHeight : 0; // riapertura durante la chiusura
  // misura dell'altezza finale, senza animazione
  box.style.transition = "none";
  box.style.display = "block";
  box.classList.add("active");
  box.style.height = "auto";
  const target = box.offsetHeight;
  box.classList.remove("active");
  box.style.height = start + "px";
  box.offsetHeight; // applica lo stato iniziale prima di riattivare la transizione
  box.style.transition = "";
  box.classList.add("active");
  box.style.height = target + "px";
  watchBox(box);
  revealBox(box, target);
}

function collapseBox(box) {
  if (!box.classList.contains("active")) return;
  box.style.height = box.offsetHeight + "px";
  box.offsetHeight;
  box.classList.remove("active");
  box.style.height = "0px";
  watchBox(box);
}

// "×" dentro la casella: si chiude da dove si legge, senza risalire alla pillola.
// Il pulsante è creato qui, così il markup delle pagine non cambia.
function addCloseButton(box, pill) {
  const lang = (document.documentElement.lang || "en").slice(0, 2);
  const labelEl = pill.querySelector(".toggle-label");
  const label = `${CLOSE_LABEL[lang] || CLOSE_LABEL.en} ${labelEl ? labelEl.textContent.trim() : ""}`.trim();
  const button = document.createElement("button");
  button.type = "button";
  button.className = "toggle-box-close";
  button.setAttribute("aria-label", label);
  button.title = label;
  button.textContent = "×";
  button.addEventListener("click", () => {
    collapseBox(box);
    pill.classList.remove("rotated");
    pill.setAttribute("aria-expanded", "false");
    pill.focus({ preventScroll: true }); // la tastiera riparte dalla pillola, la pagina non scorre
  });
  box.prepend(button);
}

// pulsante "Copia" della casella di citazione: copia il testo del <pre> indicato da data-copy-target
function initCopyButtons() {
  const lang = (document.documentElement.lang || "en").slice(0, 2);
  document.querySelectorAll(".copy-bibtex[data-copy-target]").forEach((button) => {
    const source = document.getElementById(button.getAttribute("data-copy-target"));
    if (!source) return;
    const label = button.textContent;
    button.addEventListener("click", async () => {
      const text = source.textContent;
      try {
        await navigator.clipboard.writeText(text);
      } catch (err) {
        // senza accesso agli appunti: seleziona il testo, così basta Cmd/Ctrl+C
        const range = document.createRange();
        range.selectNodeContents(source);
        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
        return;
      }
      button.textContent = COPIED_LABEL[lang] || COPIED_LABEL.en;
      clearTimeout(button._copyTimer);
      button._copyTimer = setTimeout(() => (button.textContent = label), 1500);
    });
  });
}

// pulsante "Scarica": crea il file .bib dal testo del <pre> (nome dalla chiave BibTeX), senza file nel repository
function initDownloadButtons() {
  document.querySelectorAll(".download-bibtex[data-copy-target]").forEach((button) => {
    const source = document.getElementById(button.getAttribute("data-copy-target"));
    if (!source) return;
    button.addEventListener("click", () => {
      const text = source.textContent.trim() + "\n";
      const key = /^@\w+\{([^,\s]+),/.exec(text);
      const url = URL.createObjectURL(new Blob([text], { type: "application/x-bibtex;charset=utf-8" }));
      const link = document.createElement("a");
      link.href = url;
      link.download = (key ? key[1] : "citation") + ".bib";
      document.body.appendChild(link);
      link.click();
      link.remove();
      setTimeout(() => URL.revokeObjectURL(url), 1000);
    });
  });
}

function initTogglePills() {
  document.querySelectorAll(".toggle-box").forEach((box) => {
    box.addEventListener("transitionend", (e) => {
      if (e.target === box && e.propertyName === "height") finishBox(box);
    });
  });
  document.querySelectorAll(".toggle-pill").forEach((pill) => {
    const box = document.getElementById(pill.getAttribute("data-target"));
    if (!box) return;
    addCloseButton(box, pill);
    pill.addEventListener("click", () => {
      // ogni pillola è indipendente; le caselle aperte si chiudono con la sezione (toggle-sections.js)
      const isOpen = box.classList.contains("active");
      if (isOpen) {
        collapseBox(box);
        pill.classList.remove("rotated");
      } else {
        expandBox(box);
        pill.classList.add("rotated");
      }
      pill.setAttribute("aria-expanded", isOpen ? "false" : "true");
    });
  });
}

function initBoxes() {
  initTogglePills();
  initCopyButtons();
  initDownloadButtons();
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initBoxes);
} else {
  initBoxes();
}
