---
page_id: contacts
layout: page
permalink: /contactos/
lang: es
title: contactos
description: <i>Direcciones de correo electrónico en la University of Cagliari y en la University of Bologna, junto con una dirección personal. Más abajo, los enlaces a mis perfiles académicos y a LinkedIn.</i>
meta_description: "Direcciones de correo electrónico en la University of Cagliari y en la University of Bologna, con enlaces a mis perfiles académicos y a LinkedIn."
---

<!-- E-mail Section -->

{% include section-toggle.liquid id="content-1" title="correo electrónico" expanded=true %}

<div id="content-1" class="toggle-section expanded contact-list">

  <div class="icon-link indented">
    <i class="fa-solid fa-envelope fa-fw"></i>
    <a href="mailto:marco.rosso@unica.it">marco.rosso@unica.it</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-solid fa-envelope fa-fw"></i>
    <a href="mailto:marco.rosso4@unibo.it">marco.rosso4@unibo.it</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-regular fa-envelope fa-fw"></i>
    <a href="mailto:marco@marcorosso.com">marco@marcorosso.com</a>
  </div>

</div>

<!-- Online Resources Section -->

{% include section-toggle.liquid id="content-2" title="recursos en línea" expanded=true %}

<div id="content-2" class="toggle-section expanded contact-list">

  <div class="icon-link indented">
    <i class="fa-solid fa-school fa-fw"></i>
    <a href="https://crenos.unica.it/index.php/marco-rosso">página personal en el sitio web de CRENoS</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-solid fa-building-columns fa-fw"></i>
    <a href="https://www.unibo.it/sitoweb/marco.rosso4/en">página personal en UniBo</a>
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
    <i class="ai ai-google-scholar fa-fw"></i>
    <a href="https://scholar.google.com/citations?user=KYPkHrIAAAAJ">Google Scholar</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-ideas-repec fa-fw"></i>
    <a href="https://ideas.repec.org/f/pro1382.html">IDEAS/RePEc</a>
  </div>

  <div class="icon-link indented">
    <i class="ai ai-researchgate fa-fw"></i>
    <a href="https://www.researchgate.net/profile/Marco-Rosso-2">ResearchGate</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-github fa-fw"></i>
    <a href="https://github.com/marcorosso768">GitHub</a>
  </div>

  <div class="icon-link indented">
    <i class="fa-brands fa-linkedin fa-fw"></i>
    <a href="https://www.linkedin.com/in/marcorosso768">LinkedIn</a>
  </div>
  
</div>

{% comment %}
Sezione "ubicación", pronta ma disattivata: per mostrarla togliere le due righe comment ed endcomment che racchiudono la sezione qui sotto.
Da completare: l'indirizzo (al posto del testo tra parentesi quadre) e in data-src l'indirizzo di incorporamento
della mappa (Google Maps, Condividi > Incorpora una mappa, solo l'URL dentro src="..."). La mappa si carica
solo quando si preme il pulsante, così senza clic il browser non contatta Google.
{% endcomment %}
{% comment %}
{% include section-toggle.liquid id="content-4" title="ubicación" %}

<div id="content-4" class="toggle-section">

  <div class="icon-link indented">
    <i class="fa-solid fa-location-dot fa-fw"></i>
    <span class="contact-address">[dirección por completar]</span>
  </div>

  <div class="embed-facade contact-map" data-type="map" data-src="" data-height="450">
    <button type="button" class="embed-facade__button" aria-expanded="false"><i class="fa-solid fa-map-location-dot fa-fw"></i> <span class="embed-facade__label" data-title="Mapa" data-show="Mostrar mapa" data-hide="Ocultar mapa">Mostrar mapa</span></button>
  </div>

</div>
{% endcomment %}
