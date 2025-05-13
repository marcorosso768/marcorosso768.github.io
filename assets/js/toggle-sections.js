function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);

  const isVisible = section.style.display === "block";

  // Toggle visibilità sezione
  section.style.display = isVisible ? "none" : "block";

  // Gestione freccia
  if (chevron) {
    // Cambia l'icona base
    chevron.classList.remove("fa-chevron-right", "fa-chevron-down");
    chevron.classList.add(isVisible ? "fa-chevron-right" : "fa-chevron-down");

    // Per l'effetto scala e rotazione:
    if (isVisible) {
      // Aspetta un attimo prima di rimuovere la classe .rotated per non troncare l'animazione
      setTimeout(() => {
        chevron.classList.remove("rotated");
      }, 300); // Durata della transizione in _layout.scss
    } else {
      chevron.classList.add("rotated");
    }
  }

  // Chiude tutti gli abstract nella sezione (se presenti)
  if (isVisible) {
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  }
}
