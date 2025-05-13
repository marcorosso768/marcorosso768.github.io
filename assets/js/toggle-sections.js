function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.querySelector(`a[onclick*="${id}"] i`);

  const isVisible = section.style.display === 'block';
  section.style.display = isVisible ? 'none' : 'block';

  // Toggle chevron rotation
  if (chevron) {
    chevron.style.transform = isVisible ? 'rotate(0deg)' : 'rotate(180deg)';
    chevron.style.transition = 'transform 0.3s ease';
  }

  // Se stiamo chiudendo, chiudi anche gli abstract all’interno
  if (isVisible) {
    section.querySelectorAll('.abstract').forEach(el => {
      el.classList.remove('open');
    });
  }
}
