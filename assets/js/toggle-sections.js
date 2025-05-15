function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);
  const isExpanded = section.classList.contains("expanded");

  if (isExpanded) {
    collapseSection(section);
    if (chevron) chevron.classList.remove("rotated");

    // Chiudi tutte le toggle-box all'interno della sezione
    section.querySelectorAll(".toggle-box").forEach(box => collapseBox(box));
    section.querySelectorAll(".toggle-pill").forEach(p => p.classList.remove("rotated"));

    // Chiude eventuali abstract (legacy)
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  } else {
    expandSection(section);
    if (chevron) chevron.classList.add("rotated");
  }
}

function expandSection(section) {
  section.classList.add("expanded");
  section.style.maxHeight = section.scrollHeight + "px";
  section.style.opacity = 1;
}

function collapseSection(section) {
  section.style.maxHeight = section.scrollHeight + "px"; // imposta altezza attuale
  section.offsetHeight; // forza reflow
  section.style.maxHeight = "0";
  section.style.opacity = 0;
  section.classList.remove("expanded");
}

function expandBox(box) {
  box.classList.add("active");
  box.style.maxHeight = box.scrollHeight + "px";
  box.style.opacity = 1;
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + "px";
  box.offsetHeight; // forza reflow
  box.style.maxHeight = "0";
  box.style.opacity = 0;
  box.classList.remove("active");
}

// Inizializza sezioni aperte di default
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('.toggle-section.expanded').forEach(section => {
    section.style.maxHeight = section.scrollHeight + "px";
    section.style.opacity = 1;
  });
});
