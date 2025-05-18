function initTogglePills() {
  document.querySelectorAll('.toggle-pill').forEach(pill => {
    const targetId = pill.getAttribute('data-target');
    const box = document.getElementById(targetId);

    pill.addEventListener('click', () => {
      const isOpen = box.classList.contains('active');

      // Close all boxes
      document.querySelectorAll('.toggle-box').forEach(b => collapseBox(b));
      document.querySelectorAll('.toggle-pill').forEach(p => p.classList.remove('rotated'));

      // Open if not already open
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

  box.offsetHeight; // force reflow

  requestAnimationFrame(() => {
    box.style.maxHeight = box.scrollHeight + "em";

    const section = box.closest('.toggle-section.expanded');
    if (section) {
      section.style.maxHeight = section.scrollHeight + "em";
    }
  });

  // fallback update
  setTimeout(() => {
    updateSectionHeight(box);
  }, 700);
}

function collapseBox(box) {
  const section = box.closest('.toggle-section.expanded');

  // set current height before transition
  box.style.maxHeight = box.scrollHeight + "em";
  if (section) {
    section.style.maxHeight = section.scrollHeight + "em";
  }

  box.offsetHeight; // force reflow

  // initiate transition
  box.style.maxHeight = '0';
  box.style.opacity = 0;
  box.classList.remove('active');

  if (section) {
    // compute new max-height immediately for smooth section update
    const otherBoxes = Array.from(section.querySelectorAll('.toggle-box.active'));
    const otherHeights = otherBoxes.reduce((sum, el) => sum + el.scrollHeight, 0);
    section.style.maxHeight = (section.scrollHeight - box.scrollHeight + otherHeights) + 'em';
  }

  setTimeout(() => {
    if (!box.classList.contains('active')) {
      box.style.display = 'none';
    }
  }, 600); // match transition duration
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
