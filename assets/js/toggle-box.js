function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      if (!isOpen) {
        expandBox(box);
        pill.classList.add('rotated');
      }
    });
  });
}

function expandBox(box) {
  box.style.display = 'block';
  box.classList.add('active');
  box.style.opacity = 1;

  box.offsetHeight;

  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + "em";

    const section = box.closest('.toggle-section.expanded');
    if (section) {
      section.style.maxHeight = section.scrollHeight + "em";
    }
  });

  setTimeout(() => {
    updateSectionHeight(box);
  }, 700);
}

function collapseBox(box) {
  const section = box.closest('.toggle-section.expanded');

  box.style.maxHeight = box.scrollHeight + "em";
  if (section) {
    section.style.maxHeight = section.scrollHeight + "em";
  }

  box.offsetHeight;

  box.style.maxHeight = '0';
  box.style.opacity = 0;
  box.classList.remove('active');

  requestAnimationFrame(() => {
    if (section) {
      const openBoxes = section.querySelectorAll('.toggle-box.active');
      const openHeight = Array.from(openBoxes).reduce((sum, el) => sum + el.scrollHeight, 0);
      const extra = 4;
      section.style.maxHeight = (openHeight + extra) + "em";
    }
  });

  setTimeout(() => {
    if (!box.classList.contains('active')) {
      box.style.display = 'none';
    }
  }, 600);
}

function updateSectionHeight(box) {
  const section = box.closest('.toggle-section.expanded');
  if (section) {
    section.style.maxHeight = section.scrollHeight + "em";
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTogglePills);
} else {
  initTogglePills();
}
