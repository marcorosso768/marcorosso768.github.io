---
layout: page
permalink: /cv/
title: curriculum vitae
description:
nav: true
nav_order: 4
cv_pdf: assets/pdf/cv-light.pdf
---

<!-- Centered download button -->
<div style="text-align: center;">
  <a href="{{ cv_pdf | relative_url }}" download="[Marco Rosso] Curriculum Vitae.pdf" class="download-button">
    download curriculum vitae
  </a>
</div>

<!-- Responsive PDF viewer with fallback -->
<div style="text-align: center;">
  <object data="{{ cv_pdf | relative_url }}" type="application/pdf" width="80%" height="600px">
    Your browser does not support viewing PDFs
  </object>
</div>
