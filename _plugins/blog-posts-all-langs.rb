# frozen_string_literal: true

# Il blog e' solo in inglese: i post hanno lang-exclusive: ["en"] e jekyll-polyglot li toglie dalle build
# it/es nel suo hook :site :post_read. Gli indici tradotti /it/blog/ e /es/blog/ devono pero' elencarli.
# Questo hook, a priorita' alta, gira prima di quello di polyglot e mette l'elenco completo dei post
# (dal piu' recente) in site.data['blog_posts'], con il tempo di lettura calcolato sul testo sorgente,
# cosi' e' lo stesso nelle tre lingue. I link ai post restano /blog/... (blog e' in exclude_from_localization).
Jekyll::Hooks.register :site, :post_read, priority: :high do |site|
  posts = site.posts.docs.sort_by(&:date).reverse
  posts.each do |post|
    words = post.content.to_s.gsub(/\{%.*?%\}|\{\{.*?\}\}|<[^>]+>/m, ' ').split.size
    post.data['read_time'] = words / 180 + 1
  end
  site.data['blog_posts'] = posts
end
