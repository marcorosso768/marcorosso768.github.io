function toggleVisibility(id) {
  const content = document.getElementById(id);
  const toggleButton = document.getElementById('toggle-' + id).querySelector('i');

  const isVisible = content.style.display !== "none";

  if (isVisible) {
    content.style.display = "none";
    toggleButton.className = "fa-solid fa-chevron-right fa-2xs";

    // Chiude tutti gli abstract dentro la sezione chiusa
    content.querySelectorAll(".abstract").forEach(el => {
      el.classList.remove("open");
    });
    content.querySelectorAll(".abstract-toggle-pill").forEach(el => {
      el.title = el.dataset.show;
    });
    content.querySelectorAll(".abstract-toggle-pill i").forEach(el => {
      el.style.transform = "rotate(0deg)";
    });

  } else {
    content.style.display = "block";
    toggleButton.className = "fa-solid fa-chevron-down fa-2xs";
  }
}
