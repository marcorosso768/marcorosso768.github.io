function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const icon = pill.querySelector('i');

    pill.addEventListener('click', () => {
      const container = pill.closest('.pill-container');
      const boxes = container.parentElement.querySelectorAll('.toggle-box');
      const pills = container.querySelectorAll('.toggle-pill');

      const currentBox = document.getElementById(targetId);
      const isOpen = currentBox.classList.contains('open');

      // Chiude tutte
      boxes.forEach(b => b.classList.remove('open'));
      pills.forEach(p => p.querySelector('i')?.classList.remove('rotated'));

      // Apre quella cliccata (se chiusa)
      if (!isOpen) {
        currentBox.classList.add('open');
        icon?.classList.add('rotated');
      }
    });
  });
}

// Avvio automatico dopo caricamento DOM
document.addEventListener("DOMContentLoaded", initTogglePills);
