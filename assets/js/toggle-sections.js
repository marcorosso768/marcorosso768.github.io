function toggleVisibility(id) {
  const section = document.getElementById(id);
  const chevron = document.querySelector(`a[onclick*="${id}"] i`);

  const isVisible = section.style.display === 'block';
  section.style.display = isVisible ? 'none' : 'block';

  // Se stiamo chiudendo, chiudi anche gli abstract all’interno
  if (isVisible) {
    section.querySelectorAll('.abstract').forEach(el => {
      el.classList.remove('open');
    });
  }
}
