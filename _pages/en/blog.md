---
page_id: blog
layout: default
permalink: /blog/
title: blog
subtitle: >
    <p style="color: var(--global-theme-color); margin-top: -15px;"><a href='https://marcorosso.com/it/blog/'>Italian</a>&nbsp;|&nbsp;<a href='https://marcorosso.com/es/blog/'>Spanish</a></p>
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
