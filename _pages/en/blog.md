---
page_id: blog
layout: default
permalink: /blog/
title: blog
subtitle: >
    <div class="lang-links">
        <a href="/it/blog/" hreflang="it">italiano</a>&nbsp;|&nbsp;<a href="/es/blog/" hreflang="es">español</a>
    </div>
nav: false
nav_order:
pagination:
  enabled: true
  collection: posts
  permalink: /page/:num/
  per_page: 5
  sort_field: date
  sort_reverse: true
  trail:
    before: 1 # The number of links before the current page
    after: 3 # The number of links after the current page
---

  <div class="header-bar">
    <h1>{{ page.title }}</h1>
    <h2>{{ page.subtitle }}</h2>
  </div>

<br>

<i>Coming soon...</i>
