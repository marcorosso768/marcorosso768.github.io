function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');

    pill.addEventListener('click', () => {
      const container = pill.closest('.pill-container');
      const boxes = container.parentElement.querySelectorAll('.toggle-box');
      const pills = container.querySelectorAll('.toggle-pill');
    
      const currentBox = document.getElementById(targetId);
      const isOpen = currentBox.classList.contains('open');
    
      // Chiude tutte le box e rimuove la rotazione
      boxes.forEach(b => b.classList.remove('open'));
      pills.forEach(p => p.classList.remove('rotated'));
    
      // Apre quella cliccata (se era chiusa)
      if (!isOpen) {
        currentBox.classList.add('open');
        pill.classList.add('rotated');
      }
    });
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initTogglePills);
} else {
  initTogglePills();
}
