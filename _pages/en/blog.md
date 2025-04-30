---
page_id: blog
layout: default
permalink: /blog/
title: blog
subtitle: >
    <p style="color: var(--global-theme-color); margin-top: -5px; font-weight: normal;"><a href='https://marcorosso.com/it/blog/'>italiano</a>&nbsp;|&nbsp;<a href='https://marcorosso.com/es/blog/'>español</a></p>
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
