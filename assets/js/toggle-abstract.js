function toggleAbstract(id, showText, hideText) {
  const abstract = document.getElementById(id);
  const toggle = document.getElementById("toggle-" + id);
  const icon = document.getElementById("icon-" + id);
  const isOpen = abstract.classList.contains("open");

  // Chiudi tutti
  document.querySelectorAll(".abstract").forEach(el => el.classList.remove("open"));
  document.querySelectorAll(".abstract-toggle-pill").forEach(el => el.title = showText);
  document.querySelectorAll(".abstract-toggle-pill i").forEach(el => {
    el.className = "fa-solid fa-chevron-right fa-2xs";
  });

  // Apri se non era già aperto
  if (!isOpen) {
    abstract.classList.add("open");
    icon.className = "fa-solid fa-chevron-down fa-2xs";
    toggle.title = hideText;
  }
}
