function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Chiudi tutto
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

  // Forza reflow
  box.offsetHeight;

  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + 'px';

    const section = box.closest('.toggle-section.expanded');
    if (section) {
      section.style.maxHeight = section.scrollHeight + 'px';
    }
  });

  // Fallback nel caso transitionend non venga chiamato
  setTimeout(() => {
    updateSectionHeight(box);
  }, 700);
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
  }, 600);
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
