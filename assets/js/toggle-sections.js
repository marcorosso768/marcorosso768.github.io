function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);

  const isVisible = section.style.display === "block";
  section.style.display = isVisible ? "none" : "block";

  // Ruota
  if (chevron) {
    chevron.classList.toggle("rotated", !isVisible);
  }

  // Chiudi abstract se stai chiudendo la sezione
  if (isVisible) {
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  }
}
