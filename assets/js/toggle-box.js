function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Chiude tutte le box
      document.querySelectorAll('.toggle-box').forEach(collapseBox);
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      // Apre solo se non era già aperta
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

  // forza reflow
  box.offsetHeight;

  // imposta max-height per l’animazione
  box.style.maxHeight = box.scrollHeight + "px";
  box.style.opacity = 1;

  // aggiorna sezione contenitore
  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + "px";
  box.offsetHeight;
  box.style.maxHeight = "0";
  box.style.opacity = 0;
  box.classList.remove("active");

  // aggiorna sezione contenitore
  const section = box.closest(".toggle-section.expanded");
  if (section) {
    section.style.maxHeight = section.scrollHeight + "px";
  }

  setTimeout(() => {
    if (!box.classList.contains("active")) {
      box.style.display = "none";
    }
  }, 500); // deve coincidere con la transition
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
