---
page_id: blog
layout: default
permalink: /blog/
title: blog
subtitle: >
    <p style="color: var(--global-theme-color); margin-top: -20px;"><a href="#" onclick="window.location.href='https://marcorosso.com/blog/'; return false;">English</a>&nbsp;|&nbsp;<a href='https://marcorosso.com/it/blog/'>italiano</a></p>
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

{% assign blog_name_size = page.blog_name | size %}
{% assign blog_description_size = page.description | size %}

{% if blog_name_size > 0 or blog_description_size > 0 %}

  <div class="header-bar">
    <h1>{{ page.blog_name }}</h1>
    <h2>{{ page.subtitle }}</h2>
    <h3>{{ page.description }}</h3>
  </div>
  {% endif %}

<br>

<i>Coming soon...</i>
