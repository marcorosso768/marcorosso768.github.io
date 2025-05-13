function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.getElementById('chevron-' + id);

  const isVisible = section.style.display === 'block';
  section.style.display = isVisible ? 'none' : 'block';

  // Cambio direzione della freccia
  if (chevron) {
    chevron.classList.toggle('rotated', !isVisible); // aggiunge se è visibile
  }

  // Chiudi anche eventuali abstract
  if (isVisible) {
    section.querySelectorAll('.abstract').forEach(el => {
      el.classList.remove('open');
    });
  }
}
