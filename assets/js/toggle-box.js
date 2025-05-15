function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Chiude tutto
      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      if (!isOpen) {
        expandBox(box);
        pill.classList.add('rotated');
      }
    });
  });
}

function expandBox(box) {
  box.style.display = 'block';
  box.classList.add('active');
  box.style.opacity = 1;

  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + 'px';
  });

  // Aggiorna la sezione DOPO l'espansione effettiva
  box.addEventListener('transitionend', () => updateSectionHeight(box), { once: true });

  // Fallback in caso il browser ignori transitionend
  setTimeout(() => {
    updateSectionHeight(box);
  }, 600);
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + 'px';
  box.offsetHeight;
  box.style.maxHeight = '0';
  box.style.opacity = 0;
  box.classList.remove('active');

  setTimeout(() => {
    if (!box.classList.contains('active')) {
      box.style.display = 'none';
      updateSectionHeight(box);
    }
  }, 500);
}

function updateSectionHeight(box) {
  const section = box.closest('.toggle-section.expanded');
  if (section) {
    section.style.maxHeight = section.scrollHeight + 'px';
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
