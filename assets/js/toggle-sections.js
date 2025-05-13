function toggleVisibility(id) {
  const content = document.getElementById(id);
  const toggle = document.getElementById(`toggle-${id}`);
  const icon = toggle.querySelector("i");

  const isVisible = content.style.display !== "none";

  if (isVisible) {
    content.style.display = "none";
    icon.style.transform = "rotate(0deg)";
  } else {
    content.style.display = "block";
    icon.style.transform = "rotate(90deg)";
  }
}
