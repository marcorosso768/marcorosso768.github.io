function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isExpanded = box.classList.contains('active');

      // Chiude tutti gli altri box
      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      // Se non era aperto, aprilo
      if (!isExpanded) {
        expandBox(box);
        pill.classList.add('rotated');
      }
    });
  });
}

function expandBox(box) {
  box.classList.add('active');
  box.style.maxHeight = box.scrollHeight + 'px';
}

function collapseBox(box) {
  box.style.maxHeight = box.scrollHeight + 'px'; // imposta prima l'altezza attuale
  // forza un reflow per far funzionare la transizione
  box.offsetHeight;
  box.style.maxHeight = '0';
  box.classList.remove('active');
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initTogglePills);
} else {
  initTogglePills();
}
