function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);
  const isExpanded = section.classList.contains("expanded");

  if (isExpanded) {
    collapseSection(section);
    if (chevron) chevron.classList.remove("rotated");

    // Chiude tutte le toggle-box nella sezione
    section.querySelectorAll(".toggle-box").forEach(box => collapseBox(box));
    section.querySelectorAll(".toggle-pill").forEach(p => p.classList.remove("rotated"));

    // Chiude eventuali .abstract legacy
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
  section.style.maxHeight = section.scrollHeight + "px";
  section.offsetHeight;
  section.style.maxHeight = "0";
  section.style.opacity = 0;
  section.classList.remove("expanded");
}

// Toggle pill behavior
function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const container = pill.closest('.pill-container');
      const boxes = container.parentElement.querySelectorAll('.toggle-box');
      const pills = container.querySelectorAll('.toggle-pill');
      const isOpen = box.classList.contains('active');

      // Chiudi tutte
      boxes.forEach(b => collapseBox(b));
      pills.forEach(p => p.classList.remove('rotated'));

      // Apre se era chiusa
      if (!isOpen) {
        expandBox(box);
        pill.classList.add('rotated');
      }
    });
  });
}

function expandBox(box) {
  box.classList.add("active");
  box.style.maxHeight = box.scrollHeight + "px";
  box.style.opacity = 1;

  // Aggiorna la sezione contenitore
  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + "px";
  box.offsetHeight;
  box.style.maxHeight = "0";
  box.style.opacity = 0;
  box.classList.remove("active");

  // Aggiorna la sezione contenitore
  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }
}

// Inizializza sezioni già aperte al load
function initExpandedSections() {
  document.querySelectorAll('.toggle-section.expanded').forEach(section => {
    section.style.maxHeight = section.scrollHeight + "px";
    section.style.opacity = 1;
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => {
    initExpandedSections();
    initTogglePills();
  });
} else {
  initExpandedSections();
  initTogglePills();
}
