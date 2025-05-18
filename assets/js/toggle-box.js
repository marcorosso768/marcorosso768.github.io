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
    box.style.maxHeight = box.scrollHeight + "em";

    const section = box.closest('.toggle-section.expanded');
    if (section) {
      section.style.maxHeight = section.scrollHeight + "em";
    }
  });

  // Fallback nel caso transitionend non venga chiamato
  setTimeout(() => {
    updateSectionHeight(box);
  }, 700);
}

function collapseBox(box) {
  const section = box.closest('.toggle-section.expanded');

  // imposta subito altezza attuale per entrambe
  box.style.maxHeight = box.scrollHeight + "em";
  if (section) {
    section.style.maxHeight = section.scrollHeight + "em";
  }

  box.offsetHeight; // forza reflow

  // avvia transizione contemporanea
  box.style.maxHeight = '0';
  box.style.opacity = 0;
  box.classList.remove('active');

  if (section) {
    // sottrai box chiusa dal totale per la transizione
    const otherBoxes = Array.from(section.querySelectorAll('.toggle-box.active'));
    const otherHeights = otherBoxes.reduce((sum, el) => sum + el.scrollHeight, 0);
    section.style.maxHeight = (section.scrollHeight - box.scrollHeight + otherHeights) + 'em';
  }

  setTimeout(() => {
    if (!box.classList.contains('active')) {
      box.style.display = 'none';
    }
  }, 600); // = durata transition
}

function updateSectionHeight(box) {
  const section = box.closest('.toggle-section.expanded');
  if (section) {
    section.style.maxHeight = section.scrollHeight + "em";
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
