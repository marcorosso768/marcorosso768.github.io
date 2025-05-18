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

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initExpandedSections);
} else {
  initExpandedSections();
}
