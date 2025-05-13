function toggleAbstract(id, showText, hideText) {
  const abstract = document.getElementById(id);
  const toggle = document.getElementById("toggle-" + id);
  const icon = document.getElementById("icon-" + id);
  const isOpen = abstract.classList.contains("open");

  if (isOpen) {
    abstract.classList.remove("open");
    toggle.title = showText;
    icon.style.transform = "rotate(0deg)";
  } else {
    abstract.classList.add("open");
    toggle.title = hideText;
    icon.style.transform = "rotate(90deg)";
  }
}
