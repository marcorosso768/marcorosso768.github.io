# frozen_string_literal: true

# Archivi del blog (tag, anni, categorie) anche in italiano e spagnolo: /it/blog/tag/academia/ ecc.
# jekyll-archives li crea solo nella build inglese, perche' nelle build it/es i post (solo in inglese,
# lang-exclusive) non ci sono. Qui, nelle build delle altre lingue, si creano le stesse pagine con gli
# stessi layout (archive-tag, archive-year, archive-category) a partire da site.data['blog_posts']
# (_plugins/blog-posts-all-langs.rb). I post restano in inglese; cambia solo la cornice della pagina.
module BlogArchivesI18n
  class ArchivePage < Jekyll::Page
    def initialize(site, dir, layout, data)
      @site = site
      @base = site.source
      @dir = dir
      @name = 'index.html'
      process(@name)
      @content = ''
      @data = { 'layout' => layout, 'lang' => site.active_lang, 'sitemap' => false }.merge(data)
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      return if site.active_lang.nil? || site.active_lang == site.default_lang

      posts = site.data['blog_posts'] || []
      return if posts.empty?

      enabled = Array(site.config.dig('jekyll-archives', 'enabled'))
      layouts = site.config.dig('jekyll-archives', 'layouts') || {}

      if enabled.include?('tags')
        group(posts, 'tags').each do |tag, list|
          dir = "blog/tag/#{Jekyll::Utils.slugify(tag)}"
          site.pages << ArchivePage.new(site, dir, layouts['tag'] || 'archive-tag', 'title' => tag, 'posts' => list, 'type' => 'tag')
        end
      end

      if enabled.include?('categories')
        group(posts, 'categories').each do |cat, list|
          dir = "blog/category/#{Jekyll::Utils.slugify(cat)}"
          site.pages << ArchivePage.new(site, dir, layouts['category'] || 'archive-category', 'title' => cat, 'posts' => list, 'type' => 'category')
        end
      end

      return unless enabled.include?('year')

      posts.group_by { |p| p.date.year }.each do |year, list|
        site.pages << ArchivePage.new(site, "blog/#{year}", layouts['year'] || 'archive-year',
                                      'title' => year.to_s, 'date' => list.first.date, 'posts' => list, 'type' => 'year')
      end
    end

    def group(posts, key)
      out = Hash.new { |h, k| h[k] = [] }
      posts.each { |p| Array(p.data[key]).each { |v| out[v] << p } }
      out
    end
  end
end
