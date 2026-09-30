---
page_id: blog
layout: default
permalink: /blog/
lang: en
lang-exclusive: ["en"] # blog solo in inglese: nessuna copia in /it/ e /es/ (il menu delle tre lingue punta qui)
hreflang: false
title: blog
blog_name: blog
description: Occasional posts on academia and on whatever else I care about.
meta_description: "Blog of Marco Rosso: occasional posts on academia and other interests."
nav: false
---

<div class="post">

  <div class="header-bar">
    <h1>{{ page.blog_name }}</h1>
    <h2>{{ page.description }}</h2>
  </div>

{% if site.display_tags.size > 0 or site.display_categories.size > 0 %}

  <div class="tag-category-list">
    <ul class="p-0 m-0">
      {% for tag in site.display_tags %}
        <li>
          <i class="fa-solid fa-hashtag fa-sm"></i> <a href="{{ tag | slugify | prepend: '/blog/tag/' | relative_url }}">{{ tag }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
      {% endfor %}
      {% if site.display_categories.size > 0 and site.display_tags.size > 0 %}
        <p>&bull;</p>
      {% endif %}
      {% for category in site.display_categories %}
        <li>
          <i class="fa-solid fa-tag fa-sm"></i> <a href="{{ category | slugify | prepend: '/blog/category/' | relative_url }}">{{ category }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
      {% endfor %}
    </ul>
  </div>
{% endif %}

{% assign featured_posts = site.posts | where: "featured", true %}
{% if featured_posts.size > 0 %}

  <div class="container featured-posts mt-4">
    <div class="row row-cols-1 row-cols-md-2">
      {% for post in featured_posts %}
        {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
        {% assign year = post.date | date: "%Y" %}
        <div class="col mb-4">
          <a href="{{ post.url | relative_url }}">
            <div class="card hoverable">
              <div class="card-body">
                <div class="float-end"><i class="fa-solid fa-thumbtack fa-xs"></i></div>
                <h3 class="card-title text-lowercase">{{ post.title }}</h3>
                <p class="card-text">{{ post.description }}</p>
                <p class="post-meta">{{ read_time }} min read &nbsp; &middot; &nbsp; {{ year }}</p>
              </div>
            </div>
          </a>
        </div>
      {% endfor %}
    </div>
  </div>
  <hr>
{% endif %}

  <ul class="post-list">
    {% for post in site.posts %}
      {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
      {% assign year = post.date | date: "%Y" %}
      <li>
        <h3><a class="post-title" href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
        <p>{{ post.description }}</p>
        <p class="post-meta">
          {{ read_time }} min read &nbsp; &middot; &nbsp;
          {% include date_format.liquid format="long" date=post.date %}
        </p>
        <p class="post-tags">
          <a href="{{ year | prepend: '/blog/' | relative_url }}"><i class="fa-solid fa-calendar fa-sm"></i> {{ year }}</a>
          {% if post.tags.size > 0 %}
            &nbsp; &middot; &nbsp;
            {% for tag in post.tags %}
              <a href="{{ tag | slugify | prepend: '/blog/tag/' | relative_url }}"><i class="fa-solid fa-hashtag fa-sm"></i> {{ tag }}</a>
              {% unless forloop.last %}&nbsp;{% endunless %}
            {% endfor %}
          {% endif %}
        </p>
      </li>
    {% endfor %}
  </ul>

</div>
