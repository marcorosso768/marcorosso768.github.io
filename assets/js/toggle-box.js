function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.dataset.target;
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Chiudi tutto
      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      if (!isOpen) {
        expandBox(box, pill);
      }
    });
  });
}

/** Espande il singolo toggle-box e la section padre */
function expandBox(box, pill) {
  const section = box.closest('.toggle-section');

  // Imposta altezza iniziale
  box.style.display = 'block';
  box.style.maxHeight = '0';
  box.style.opacity = '0';
  box.classList.add('active');
  pill.classList.add('rotated');

  // Forza reflow
  box.offsetHeight;

  // Inizia entrambe le transizioni in un colpo solo
  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + 'px';
    box.style.opacity = '1';

    if (section) {
      section.style.maxHeight = section.scrollHeight + 'px';
      section.style.opacity = '1';
    }
  });

  // Al termine della transizione del box, “sblocca” la section
  const onEnd = e => {
    if (e.propertyName === 'max-height') {
      if (section) {
        // Rimuovi la max-height per renderla auto-adattante
        section.style.maxHeight = 'none';
      }
      box.removeEventListener('transitionend', onEnd);
    }
  };
  box.addEventListener('transitionend', onEnd);
}

function collapseBox(box) {
  const pill = document.querySelector(`.toggle-pill[data-target="${box.id}"]`);
  const section = box.closest('.toggle-section');

  // Se la section era “auto”, prima la blocchiamo alla sua altezza corrente
  if (section && getComputedStyle(section).maxHeight === 'none') {
    section.style.maxHeight = section.scrollHeight + 'px';
  }

  // Forza reflow
  box.offsetHeight;

  // Avvia collasso
  box.style.maxHeight = '0';
  box.style.opacity = '0';
  box.classList.remove('active');
  if (pill) pill.classList.remove('rotated');

  if (section) {
    section.style.maxHeight = section.scrollHeight + 'px'; // partenza
    section.offsetHeight; // reflow
    section.style.maxHeight = '0';
    section.style.opacity = '0';
    section.classList.remove('expanded');
  }

  // Alla fine nascondi il box
  box.addEventListener('transitionend', function hide(e) {
    if (e.propertyName === 'max-height') {
      box.style.display = 'none';
      box.removeEventListener('transitionend', hide);
    }
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
