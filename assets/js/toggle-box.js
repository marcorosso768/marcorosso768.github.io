document.addEventListener('DOMContentLoaded', initTogglePills);

function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const box = document.getElementById(pill.dataset.target);
    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // chiudo tutte le altre
      document.querySelectorAll('.toggle-pill.rotated').forEach(p => {
        const b = document.getElementById(p.dataset.target);
        collapseBox(b, p);
      });

      if (!isOpen) expandBox(box, pill);
    });
  });
}

function expandBox(box, pill) {
  const section = box.closest('.toggle-section.expanded');

  // preparo il box
  box.style.display    = 'block';
  box.style.maxHeight  = '0px';
  box.style.opacity    = '0';
  box.classList.add('active');
  pill.classList.add('rotated');

  // forza reflow
  box.offsetHeight;

  // parte animazione box (altezza + opacità) e sezione (solo altezza)
  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + 'px';
    box.style.opacity   = '1';
    if (section) section.style.maxHeight = section.scrollHeight + 'px';
  });

  // dopo che il box ha finito di crescere:
  box.addEventListener('transitionend', function handler(e) {
    if (e.propertyName === 'max-height') {
      // sblocco l'altezza perché si adatti a qualunque contenuto futuro
      box.style.maxHeight = 'none';
      if (section) section.style.maxHeight = 'none';
      box.removeEventListener('transitionend', handler);
    }
  });
}

function collapseBox(box, pill) {
  const section = box.closest('.toggle-section.expanded');

  // sezione ferma all'altezza corrente
  if (section) section.style.maxHeight = section.scrollHeight + 'px';

  // preparo il box per collassare
  box.style.maxHeight = box.scrollHeight + 'px';
  box.offsetHeight; // reflow
  box.style.maxHeight = '0px';
  box.style.opacity   = '0';
  box.classList.remove('active');
  pill.classList.remove('rotated');

  box.addEventListener('transitionend', function handler(e) {
    if (e.propertyName === 'max-height') {
      box.style.display = 'none';
      if (section) {
        // ridà alla sezione l'altezza giusta per il nuovo contenuto
        section.style.maxHeight = section.scrollHeight + 'px';
        // poi sblocco anch’essa
        setTimeout(() => section.style.maxHeight = 'none', 0);
      }
      box.removeEventListener('transitionend', handler);
    }
  });
}
