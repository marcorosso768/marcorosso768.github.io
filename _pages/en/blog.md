---
page_id: blog
layout: default
permalink: /blog/
title: blog
subtitle: >
    <div class="blog-links">
      <a href="https://marcorosso.com/it/blog/">italiano</a>
      <span class="separator">|</span>
      <a href="https://marcorosso.com/es/blog/">español</a>
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
<div id="content-text" class="toggle-section expanded">
<i>Coming soon...</i>
</div>
