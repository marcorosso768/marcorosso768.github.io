function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Chiude tutte le box
      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      // Apre se non era aperta
      if (!isOpen) {
        expandBox(box);
        pill.classList.add('rotated');
      }
    });
  });
}

function expandBox(box) {
  box.style.display = "block";
  box.classList.add("active");
  box.style.maxHeight = box.scrollHeight + "px";
  box.style.opacity = 1;

  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + "px";
  box.offsetHeight; // forzo reflow
  box.style.maxHeight = "0";
  box.style.opacity = 0;
  box.classList.remove("active");

  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }

  setTimeout(() => {
    box.style.display = "none";
  }, 500); // deve corrispondere alla durata della transition
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initTogglePills);
} else {
  initTogglePills();
}
