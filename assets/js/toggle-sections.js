function toggleVisibility(id) {
  const content = document.getElementById(id);
  const toggle = document.getElementById(`toggle-${id}`);
  const icon = toggle.querySelector("i");

  const isOpen = content.style.display !== "none";

  content.style.display = isOpen ? "none" : "block";
  icon.style.transform = isOpen ? "rotate(0deg)" : "rotate(90deg)";
}
