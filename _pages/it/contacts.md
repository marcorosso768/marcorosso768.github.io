---
page_id: contacts
layout: page
permalink: /contatti/
lang: it
title: contatti
description: <i>Il mio indirizzo e-mail. Di seguito, i link ai miei profili accademici e a LinkedIn.</i>
meta_description: "Il mio indirizzo e-mail, con i link ai profili accademici e a LinkedIn."
---

<!-- E-mail Section -->

{% include section-toggle.liquid id="content-1" title="e-mail" expanded=true %}

<div id="content-1" class="toggle-section expanded contact-list">

  <div class="icon-link indented">
    <i class="fa-regular fa-envelope fa-fw"></i>
    <a href="mailto:{{ "marco@marcorosso.com" | encode_email }}">{{ "marco@marcorosso.com" | email_entities }}</a>
  </div>

</div>

<!-- Profiles Section -->

{% include section-toggle.liquid id="content-2" title="profili" expanded=true %}

<div id="content-2" class="toggle-section expanded contact-list">

  <div class="icon-link indented">
    <i class="fa-solid fa-school fa-fw"></i>
    <a href="https://crenos.unica.it/index.php/marco-rosso">profilo su CRENoS</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-solid fa-building-columns fa-fw"></i>
    <a href="https://www.unibo.it/sitoweb/marco.rosso4/">profilo su UniBo</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-linkedin fa-fw"></i>
    <a href="https://www.linkedin.com/in/marcorosso768">LinkedIn</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-github fa-fw"></i>
    <a href="https://github.com/marcorosso768">GitHub</a>
  </div>

</div>

<!-- Research Section -->

{% include section-toggle.liquid id="content-3" title="ricerca" expanded=true %}

<div id="content-3" class="toggle-section expanded contact-list">

  <div class="icon-link indented">
    <i class="ai ai-google-scholar fa-fw"></i>
    <a href="https://scholar.google.com/citations?user=KYPkHrIAAAAJ">Google Scholar</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-ideas-repec fa-fw"></i>
    <a href="https://ideas.repec.org/f/pro1382.html">IDEAS/RePEc</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-ssrn-square fa-fw"></i>
    <a href="https://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=4602100">SSRN</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-orcid fa-fw"></i>
    <a href="https://orcid.org/0000-0002-3814-2210">ORCID</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-clarivate ai-fw"></i>
    <a href="https://www.webofscience.com/wos/author/record/OIU-6176-2025">Web of Science</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-researchgate fa-fw"></i>
    <a href="https://www.researchgate.net/profile/Marco-Rosso-2">ResearchGate</a>
  </div>

</div>

{% comment %}
Sezione "indirizzo", pronta ma disattivata: per mostrarla togliere le due righe comment ed endcomment che racchiudono la sezione qui sotto.
Da completare: l'indirizzo (al posto del testo tra parentesi quadre) e in data-src l'indirizzo di incorporamento
della mappa (Google Maps, Condividi > Incorpora una mappa, solo l'URL dentro src="..."). La mappa si carica
solo quando si preme il pulsante, così senza clic il browser non contatta Google.
{% endcomment %}
{% comment %}
{% include section-toggle.liquid id="content-4" title="indirizzo" %}

<div id="content-4" class="toggle-section">

  <div class="icon-link indented">
    <i class="fa-solid fa-location-dot fa-fw"></i>
    <span class="contact-address">[indirizzo da inserire]</span>
  </div>

  <div class="embed-facade contact-map" data-type="map" data-src="" data-height="450">
    <button type="button" class="embed-facade__button" aria-expanded="false"><i class="fa-solid fa-map-location-dot fa-fw"></i> <span class="embed-facade__label" data-title="Mappa" data-show="Mostra mappa" data-hide="Nascondi mappa">Mostra mappa</span></button>
  </div>

</div>
{% endcomment %}
