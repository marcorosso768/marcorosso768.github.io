function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);

  const isVisible = section.style.display === "block";

  // Toggle visibilità sezione
  section.style.display = isVisible ? "none" : "block";

  // Aggiorna rotazione freccia
  if (chevron) {
    chevron.classList.toggle("rotated", !isVisible);
    chevron.classList.remove("fa-chevron-right", "fa-chevron-down");
    chevron.classList.add(!isVisible ? "fa-chevron-down" : "fa-chevron-right");
  }

  // Chiude tutti gli abstract nella sezione (se presenti)
  if (isVisible) {
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  }
}
