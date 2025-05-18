function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);
  const isExpanded = section.classList.contains("expanded");

  if (isExpanded) {
    collapseSection(section);
    
    if (chevron) chevron.classList.remove("rotated");
    section.querySelectorAll(".toggle-box").forEach(box => collapseBox(box));
    section.querySelectorAll(".toggle-pill").forEach(p => p.classList.remove("rotated"));
  } else {
    expandSection(section);
    if (chevron) chevron.classList.add("rotated");
  }
}

function expandSection(section) {
  section.classList.add("expanded");
  // 👇 HACK: uso "em" al posto di "px" per rendere la transizione visivamente più fluida.
  // ATTENZIONE: scrollHeight è in pixel, quindi questo non è tecnicamente corretto, ma funziona..
  section.style.maxHeight = section.scrollHeight + "em";
  section.style.opacity = 1;
}

function collapseSection(section) {
  section.style.maxHeight = section.scrollHeight + "em";
  section.offsetHeight;
  section.style.maxHeight = "0";
  section.style.opacity = 0;
  section.classList.remove("expanded");
}

function initExpandedSections() {
  document.querySelectorAll('.toggle-section.expanded').forEach(section => {
    section.style.maxHeight = section.scrollHeight + "em";
    section.style.opacity = 1;
  });
}

function resetSubsectionsIn(section) {
  section.querySelectorAll('.toggle-subsection').forEach(subsection => {
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
