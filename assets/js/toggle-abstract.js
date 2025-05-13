function toggleAbstract(id, showText, hideText) {
  const allAbstracts = document.querySelectorAll(".abstract");
  const allIcons = document.querySelectorAll(".abstract-toggle i");
  const allLabels = document.querySelectorAll(".abstract-toggle span.toggle-label");

  allAbstracts.forEach(el => el.classList.remove("open"));
  allIcons.forEach(icon => icon.className = "fa-solid fa-chevron-right fa-2xs");
  allLabels.forEach(label => label.innerText = showText);

  const abstract = document.getElementById(id);
  const icon = document.getElementById("icon-" + id);
  const label = document.getElementById("label-" + id);

  if (!abstract.classList.contains("open")) {
    abstract.classList.add("open");
    icon.className = "fa-solid fa-chevron-down fa-2xs";
    label.innerText = hideText;
  }
}
