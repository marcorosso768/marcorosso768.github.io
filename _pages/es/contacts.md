---
page_id: contacts
layout: page
permalink: /contactos/
title: contactos
description:
subtitle: >
    <div class="lang-links">
        <a href="https://marcorosso.com/contacts/">contacts</a>&nbsp;|&nbsp;<a href="https://marcorosso.com/it/contatti/">contatti</a>
    </div>
---

<!-- e-mail -->
<!-- Section title toggle link with Font Awesome icons -->
<div class="projects">
  <a id="toggle-content-1" href="javascript:void(0);" onclick="toggleVisibility('content-1')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> correo electrónico </h2>
  </a>
</div>

<!-- e-mail section show by default -->
<div id="content-1" style="display: block;">
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-regular fa-envelope" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="mailto:m.rosso@me.com">m.rosso@me.com</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-solid fa-envelope" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="mailto:marco.rosso4@unibo.it">marco.rosso4@unibo.it</a> </span>
    </div>
<!--  style="color:var(--global-text-color);" -->
</div>
<!-- end -->

<!-- online resources -->
<!-- Section title toggle link with Font Awesome icons -->
<div class="projects">
  <a id="toggle-content-2" href="javascript:void(0);" onclick="toggleVisibility('content-2')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> recursos en línea </h2>
  </a>
</div>

<!-- online resources section show by default -->
<div id="content-2" style="display: block;">
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-solid fa-landmark" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="https://www.unibo.it/sitoweb/marco.rosso4/en">Página web personal de UniBo</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="ai ai-orcid" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="https://orcid.org/{{ site.orcid_id }}">ORCID</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="ai ai-google-scholar" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;&nbsp;<a href="https://scholar.google.com/citations?user={{ site.scholar_userid }}">Google Scholar</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="ai ai-researchgate" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;&nbsp;<a href="https://www.researchgate.net/profile/{{site.research_gate_profile}}/">ResearchGate</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-brands fa-github" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="https://github.com/{{ site.github_username }}">GitHub</a> </span>
    </div>
</div>
<!-- end -->

<!-- social networks -->
<!-- Section title toggle link with Font Awesome icons -->
<div class="projects">
  <a id="toggle-content-3" href="javascript:void(0);" onclick="toggleVisibility('content-3')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> redes sociales </h2>
  </a>
</div>

<!-- social networks section show by default -->
<div id="content-3" style="display: block;">
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-brands fa-linkedin" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;&nbsp;<a href="https://www.linkedin.com/in/{{ site.linkedin_username }}">LinkedIn</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-brands fa-bluesky" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;<a href="https://bsky.app/profile/{{ site.bluesky_url }}">Bluesky</a> </span>
    </div>
    <div>
        <span style="font-size:12pt;">&thinsp;&#8202;<i class="fa-brands fa-x-twitter" style="color:var(--global-theme-color); vertical-align: middle; line-height: 1;"></i>&nbsp;&nbsp;&#8202;<a href="https://x.com/{{ site.x_username }}"><i>Q.E.P.D. Twitter</i></a> </span>
    </div>
</div>
<!-- end -->

<!-- location -->
<!-- Section title toggle link with Font Awesome icons -->
<div class="projects">
  <a id="toggle-content-4" href="javascript:void(0);" onclick="toggleVisibility('content-4')">
    <h2 class="category"><i class="fa-solid fa-chevron-down fa-2xs"></i> ubicación </h2>
  </a>
</div>

<!-- location section show by default -->
<div id="content-4" style="display: block;">
    <div style="display: flex; justify-content: center;">
      <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d5691.752434268042!2d11.352124100000001!3d44.4972031!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x477fd4bb0ed9d74f%3A0x851bdc6a12c818e2!2sFaculty%20of%20Economics%20-%20University%20of%20Bologna!5e0!3m2!1ses!2sit!4v1745048654188!5m2!1ses!2sit" width="800" height="600" style="border:0; border-radius: 15px;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>
</div>
<!-- end -->

<!-- Inline script -->
<script>
  // Toggle the visibility of the sections
  function toggleVisibility(id) {
    var content = document.getElementById(id);
    var toggleButton = document.getElementById('toggle-' + id).querySelector('i');
    
    if (content.style.display === "none") {
      content.style.display = "block";
      toggleButton.className = "fa-solid fa-chevron-down fa-2xs"; // Change to down icon
    } else {
      content.style.display = "none";
      toggleButton.className = "fa-solid fa-chevron-right fa-2xs"; // Change to right icon
    }
  }
</script>

<style>
  div.b {
    margin-top: 5px;
  }
</style>
