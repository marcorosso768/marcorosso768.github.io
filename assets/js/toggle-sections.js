function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);
  const isExpanded = section.classList.contains("expanded");

  if (isExpanded) {
    collapseSection(section);

    if (chevron) chevron.classList.remove("rotated");
    section.querySelectorAll(".toggle-box").forEach((box) => collapseBox(box));
    section.querySelectorAll(".toggle-pill").forEach((p) => p.classList.remove("rotated"));
  } else {
    expandSection(section);
    if (chevron) chevron.classList.add("rotated");
  }
}

function expandSection(section) {
  section.classList.add("expanded");
  section.style.maxHeight = section.scrollHeight + "px";
  section.style.opacity = 1;
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

function initExpandedSections() {
  document.querySelectorAll(".toggle-section.expanded").forEach((section) => {
    section.style.maxHeight = "none";
    section.style.opacity = 1;
  });
}

function resetSubsectionsIn(section) {
  section.querySelectorAll(".toggle-subsection").forEach((subsection) => {
    collapseSubsection(subsection);
    subsection.style.color = "";
    subsection.style.fontStyle = "";
    subsection.style.textDecoration = "";
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initExpandedSections);
} else {
  initExpandedSections();
}
