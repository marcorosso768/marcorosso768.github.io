---
page_id: contacts
layout: page
permalink: /contacts/
title: contacts
description:
subtitle: >
    <p style="color: var(--global-theme-color); margin-top: -20px; font-weight: normal;"><a href='https://marcorosso.com/it/contatti/'>contatti</a>&nbsp;|&nbsp;<a href='https://marcorosso.com/es/contactos/'>contactos</a></p>
---

<!-- E-mail Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-1')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> e-mail </h2>
  </a>
</div>

<div id="content-1" style="display: block;">
  <div class="icon-link indented">
    <i class="fa-regular fa-envelope fa-fw"></i>
    <a href="mailto:m.rosso@me.com">m.rosso@me.com</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-solid fa-envelope fa-fw"></i>
    <a href="mailto:marco.rosso4@unibo.it">marco.rosso4@unibo.it</a>
  </div>
</div>

<!-- Online Resources Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-2')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> online resources </h2>
  </a>
</div>

<div id="content-2" style="display: block;">
  <div class="icon-link indented">
    <i class="fa-solid fa-landmark fa-fw"></i>
    <a href="https://www.unibo.it/sitoweb/marco.rosso4/en" target="_blank" rel="noopener noreferrer">personal page on UniBo website</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-orcid fa-fw"></i>
    <a href="https://orcid.org/{{ site.orcid_id }}" target="_blank" rel="noopener noreferrer">ORCID</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-google-scholar fa-fw"></i>
    <a href="https://scholar.google.com/citations?user={{ site.scholar_userid }}" target="_blank" rel="noopener noreferrer">Google Scholar</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-researchgate fa-fw"></i>
    <a href="https://www.researchgate.net/profile/{{ site.research_gate_profile }}/" target="_blank" rel="noopener noreferrer">ResearchGate</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-github fa-fw"></i>
    <a href="https://github.com/{{ site.github_username }}" target="_blank" rel="noopener noreferrer">GitHub</a>
  </div>
</div>

<!-- Social Networks Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-3')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> social networks </h2>
  </a>
</div>

<div id="content-3" style="display: block;">
  <div class="icon-link indented">
    <i class="fa-brands fa-linkedin fa-fw"></i>
    <a href="https://www.linkedin.com/in/{{ site.linkedin_username }}" target="_blank" rel="noopener noreferrer">LinkedIn</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-bluesky fa-fw"></i>
    <a href="https://bsky.app/profile/{{ site.bluesky_url }}" target="_blank" rel="noopener noreferrer">Bluesky</a>
  </div>

  <div class="icon-link">
    <i class="fa-brands fa-x-twitter fa-fw"></i>
    <a href="https://x.com/{{ site.x_username }}" target="_blank" rel="noopener noreferrer"><em>R.I.P.</em> Twitter</a>
  </div>
</div>

<!-- Location Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-4')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> location </h2>
  </a>
</div>

<div id="content-4" style="display: block;">
  <div style="display: flex; justify-content: center;">
    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d5691.752434268042!2d11.352124100000001!3d44.4972031!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x477fd4bb0ed9d74f%3A0x851bdc6a12c818e2!2sFaculty%20of%20Economics%20-%20University%20of%20Bologna!5e0!3m2!1sen!2sit!4v1745046255408!5m2!1sen!2sit" width="800" height="600" style="border:0; border-radius: 15px;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
  </div>
</div>

<!-- Inline script -->
<script>
    // Toggle the visibility of the sections
    function toggleVisibility(id) {
      var content = document.getElementById(id);
      var icon = content.previousElementSibling.querySelector('i');
    
      if (content.style.display === "none") {
        content.style.display = "block";
        icon.className = "fa-solid fa-chevron-down fa-2xs";
      } else {
        content.style.display = "none";
        icon.className = "fa-solid fa-chevron-right fa-2xs";
      }
    }
</script>
