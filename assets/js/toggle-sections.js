function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById("chevron-" + id);
  const isVisible = section.style.display === "block";

  // Toggle visibilità sezione
  section.style.display = isVisible ? "none" : "block";

  if (chevron) {
    // Temporaneamente scala la freccia
    chevron.style.transform = `rotate(${isVisible ? 0 : 90}deg) scale(1.2)`;

    // Dopo l'animazione torna a scala 1
    setTimeout(() => {
      chevron.style.transform = `rotate(${isVisible ? 0 : 90}deg) scale(1)`;
    }, 300);
  }

  // Chiudi gli abstract, se presenti
  if (isVisible) {
    section.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  }
}
