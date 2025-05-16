document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const box = document.getElementById(pill.dataset.target);

    pill.addEventListener('click', () => {
      // Chiudo tutte le altre
      document.querySelectorAll('.toggle-pill.rotated').forEach(p => {
        const b = document.getElementById(p.dataset.target);
        b.classList.remove('active');
        p.classList.remove('rotated');
      });

      // Toggle di quella cliccata
      const willOpen = !box.classList.contains('active');
      box.classList.toggle('active', willOpen);
      pill.classList.toggle('rotated', willOpen);
    });
  });
});
