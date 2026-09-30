# frozen_string_literal: true

# Elenco completo dei post del blog (solo in inglese), uguale nelle tre build di jekyll-polyglot: gli indici
# /blog/, /it/blog/ e /es/blog/ lo leggono da site.data['blog_posts'] (dal piu' recente). L'hook gira prima
# del coordinamento dei documenti di polyglot e calcola il tempo di lettura sul testo sorgente, cosi' e' lo
# stesso nelle tre lingue.
Jekyll::Hooks.register :site, :post_read, priority: :high do |site|
  posts = site.posts.docs.sort_by(&:date).reverse
  posts.each do |post|
    words = post.content.to_s.gsub(/\{%.*?%\}|\{\{.*?\}\}|<[^>]+>/m, ' ').split.size
    post.data['read_time'] = words / 180 + 1
  end
  site.data['blog_posts'] = posts
end
