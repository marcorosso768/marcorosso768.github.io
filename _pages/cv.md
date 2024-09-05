---
layout: cv
permalink: /cv/
title: cv
nav: true
nav_order: 4
# cv_pdf: example_pdf.pdf
# description: This is a description of the page. You can modify it in '_pages/cv.md'. You can also change or remove the top pdf download button.
# toc:
#  sidebar: left
---

<script>
  // Function to switch PDF based on theme mode
  function updateCvPdfLink() {
    const link = document.getElementById('cv-pdf-link');
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      link.href = '{{ "assets/pdf/cv-dark.pdf" | relative_url }}';
    } else {
      link.href = '{{ "assets/pdf/cv-light.pdf" | relative_url }}';
    }
  }

  // Run on page load
  updateCvPdfLink();

  // Listen for changes in the color scheme
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateCvPdfLink);
</script>
