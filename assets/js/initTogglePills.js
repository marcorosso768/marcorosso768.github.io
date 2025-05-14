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

      // Chiude tutto
      boxes.forEach(b => b.classList.remove('open'));
      pills.forEach(p => p.querySelector('i')?.classList.remove('rotated'));

      // Se non era già aperta, apri
      if (!isOpen) {
        currentBox.classList.add('open');
        icon?.classList.add('rotated');
      }
    });
  });
}
