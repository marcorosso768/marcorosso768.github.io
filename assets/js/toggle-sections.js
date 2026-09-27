// Sezioni apribili. Il titolo contiene un <button class="section-toggle" aria-controls="id-della-sezione">
// (markup in _includes/section-toggle.liquid); qui lo stato aperto/chiuso, l'animazione e l'accessibilità:
// aria-expanded sul pulsante, e la sezione chiusa esclusa da lettori di schermo e tastiera (aria-hidden, inert).

// sezione chiusa: fuori dall'albero di accessibilità e dal Tab
function setSectionHidden(section, hidden) {
  if (hidden) {
    section.setAttribute("aria-hidden", "true");
    section.setAttribute("inert", "");
  } else {
    section.removeAttribute("aria-hidden");
    section.removeAttribute("inert");
  }
}

function syncSectionToggle(section) {
  const expanded = section.classList.contains("expanded");
  document.querySelectorAll(`.section-toggle[aria-controls="${section.id}"]`).forEach((button) => {
    button.setAttribute("aria-expanded", expanded ? "true" : "false");
  });
  setSectionHidden(section, !expanded);
}

function toggleVisibility(id) {
  const section = document.getElementById(id);
  if (!section) return;
  const chevron = document.getElementById("chevron-" + id);
  const isExpanded = section.classList.contains("expanded");

  if (isExpanded) {
    collapseSection(section);
    if (chevron) chevron.classList.remove("rotated");
    // le caselle aperte (abstract, keywords…) si chiudono con la sezione; collapseBox è in toggle-box.js
    section.querySelectorAll(".toggle-box").forEach((box) => collapseBox(box));
    section.querySelectorAll(".toggle-pill").forEach((pill) => {
      pill.classList.remove("rotated");
      pill.setAttribute("aria-expanded", "false");
    });
  } else {
    expandSection(section);
    if (chevron) chevron.classList.add("rotated");
  }
  syncSectionToggle(section);
}

function expandSection(section) {
  // prima l'altezza, poi la classe: con la classe il CSS dà max-height: none e, alla prima apertura (senza stile
  // in linea), leggere scrollHeight dopo averla aggiunta applicava subito quel valore, che non si anima:
  // il contenuto compariva di colpo
  section.style.maxHeight = section.scrollHeight + "px";
  section.style.opacity = 1;
  section.classList.add("expanded");
  // a transizione conclusa rimuove il limite, così le sezioni annidate possono aprirsi senza essere tagliate
  section.addEventListener("transitionend", function handler(e) {
    if (e.propertyName !== "max-height") return;
    if (section.classList.contains("expanded")) section.style.maxHeight = "none";
    section.removeEventListener("transitionend", handler);
  });
}

function collapseSection(section) {
  section.style.maxHeight = section.scrollHeight + "px";
  section.offsetHeight;
  section.style.maxHeight = "0";
  section.style.opacity = 0;
  section.classList.remove("expanded");
}

function initSections() {
  document.querySelectorAll(".toggle-section.expanded").forEach((section) => {
    section.style.maxHeight = "none";
    section.style.opacity = 1;
  });
  document.querySelectorAll(".section-toggle[aria-controls]").forEach((button) => {
    const id = button.getAttribute("aria-controls");
    const section = document.getElementById(id);
    if (!section) return;
    syncSectionToggle(section);
    button.addEventListener("click", () => toggleVisibility(id));
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initSections);
} else {
  initSections();
}
