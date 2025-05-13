function toggleAbstract(id, showText, hideText) {
  const abstract = document.getElementById(id);
  const icon = document.getElementById("icon-" + id);
  const label = document.getElementById("label-" + id);

  const isOpen = abstract.classList.contains("open");

  // Chiudi tutto prima
  document.querySelectorAll('.abstract').forEach(el => el.classList.remove('open'));
  document.querySelectorAll('.toggle-label').forEach(el => el.innerText = showText);
  document.querySelectorAll('.abstract-toggle-pill i').forEach(el => el.className = "fa-solid fa-chevron-right fa-2xs");

  // Se non era aperto, aprilo
  if (!isOpen) {
    abstract.classList.add("open");
    icon.className = "fa-solid fa-chevron-down fa-2xs";
    label.innerText = hideText;
  }
}
