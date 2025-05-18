function toggleSubsectionVisibility(id) {
  const subsection = document.getElementById(id);
  const isExpanded = subsection.classList.contains("expanded");

  if (isExpanded) {
    collapseSubsection(subsection);
  } else {
    expandSubsection(subsection);
  }
}

function expandSubsection(subsection) {
  subsection.classList.add("expanded");
  subsection.style.maxHeight = subsection.scrollHeight + "em";
  subsection.style.opacity = 1;
}

function collapseSubsection(subsection) {
  subsection.style.maxHeight = subsection.scrollHeight + "em";
  subsection.offsetHeight;
  subsection.style.maxHeight = "0";
  subsection.style.opacity = 0;
  subsection.classList.remove("expanded");
}

function initExpandedSubsections() {
  document.querySelectorAll('.toggle-subsection.expanded').forEach(subsection => {
    subsection.style.maxHeight = subsection.scrollHeight + "em";
    subsection.style.opacity = 1;
  });
}

function initSubsectionHover() {
  document.querySelectorAll('.toggle-subsection').forEach(subsection => {
    subsection.addEventListener('mouseenter', () => {
      subsection.style.color = "var(--global-theme-color)";
      subsection.style.fontStyle = "italic";
      subsection.style.textDecoration = "underline";
    });
    subsection.addEventListener('mouseleave', () => {
      subsection.style.color = "var(--global-text-color)";
      subsection.style.fontStyle = "normal";
      subsection.style.textDecoration = "none";
    });
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => {
    initExpandedSubsections();
    initSubsectionHover();
  });
} else {
  initExpandedSubsections();
  initSubsectionHover();
}
