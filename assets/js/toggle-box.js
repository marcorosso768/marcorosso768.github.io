function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      document.querySelectorAll('.toggle-box').forEach(b => {
        b.classList.remove('active');
        b.style.display = 'none';
      });
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      if (!isOpen) {
        box.style.display = 'block';
        requestAnimationFrame(() => {
          box.classList.add('active');
        });
        pill.classList.add('rotated');
      }
    });
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
