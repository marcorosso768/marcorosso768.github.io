function toggleAbstract(id, showText, hideText) {
  const abstract = document.getElementById(id);
  const toggle = document.getElementById("toggle-" + id);
  const icon = document.getElementById("icon-" + id);
  const label = document.getElementById("label-" + id);
  const isOpen = abstract.classList.contains("open");

  if (isOpen) {
    abstract.classList.remove("open");
    icon.style.transform = "rotate(0deg)";
    toggle.title = showText;
    label.classList.remove("open");
  } else {
    abstract.classList.add("open");
    icon.style.transform = "rotate(90deg)";
    toggle.title = hideText;
    label.classList.add("open");
  }
}
