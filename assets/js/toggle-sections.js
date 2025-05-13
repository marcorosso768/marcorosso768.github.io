function toggleVisibility(id) {
  const content = document.getElementById(id);
  const icon = content.previousElementSibling.querySelector("i");

  if (content.style.display === "none" || content.style.display === "") {
    content.style.display = "block";
    icon.className = "fa-solid fa-chevron-down fa-2xs";
  } else {
    content.style.display = "none";
    icon.className = "fa-solid fa-chevron-right fa-2xs";
  }
}
