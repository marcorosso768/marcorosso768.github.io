function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.querySelector(`a[onclick*="${id}"] i`);
  const isVisible = section.style.display === 'block';

  section.style.display = isVisible ? 'none' : 'block';

  // Rotazione classe
  if (chevron) {
    chevron.classList.toggle('rotated', !isVisible);
  }

  // Chiudi gli abstract se chiudi la sezione
  if (isVisible) {
    section.querySelectorAll('.abstract').forEach(el => el.classList.remove('open'));
  }
}
