function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);

  const isVisible = section.style.display === "block";
  section.style.display = isVisible ? "none" : "block";

  // Ruota la freccia
  if (chevron) {
    chevron.classList.toggle("rotated", !isVisible);
    chevron.classList.remove("fa-chevron-down", "fa-chevron-right");
    chevron.classList.add(!isVisible ? "fa-chevron-down" : "fa-chevron-right");
  }

  // Chiude eventuali abstract aperti nella sezione
  if (isVisible) {
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  }
}
