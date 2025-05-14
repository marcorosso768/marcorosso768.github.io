function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);

  const isVisible = section.style.display === "block";
  section.style.display = isVisible ? "none" : "block";

  // Ruota freccia sezione
  if (chevron) {
    chevron.classList.toggle("rotated", !isVisible);
  }

  // Se stai chiudendo la sezione, chiudi anche tutte le box e rimuovi rotazioni
  if (isVisible) {
    // Chiude eventuali abstract (legacy)
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));

    // Chiude tutte le toggle-box
    section.querySelectorAll(".toggle-box").forEach(el => el.classList.remove("open"));

    // Rimuove .rotated da tutte le icone delle pill
    section.querySelectorAll(".toggle-pill i").forEach(icon => icon.classList.remove("rotated"));
  }
}
