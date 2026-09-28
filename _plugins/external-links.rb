# frozen_string_literal: true

require 'cgi'

# Link esterni: aggiunge target e rel ai link verso altri siti, come faceva jekyll-link-attributes.
# Il plugin originale rileggeva ogni pagina con il parser HTML4 di Nokogiri e la riscriveva: così
# aggiungeva un secondo <meta http-equiv="Content-Type"> e chiudeva <source> dentro <picture>.
# Qui si modificano solo i tag <a>, lasciando il resto della pagina com'è.
# Configurazione in _config.yml, sezione external_links (enabled, rel, target, exclude, new_tab_extensions):
# rel e target si aggiungono solo se il link non li ha già. È l'unico meccanismo per i link: niente JavaScript
# a runtime e niente target="_blank" scritti a mano nelle pagine.
# Anche i file del sito con le estensioni in new_tab_extensions (PDF, do-file, notebook) si aprono in una nuova
# scheda, con rel="noopener"; i link con la classe no-external restano come sono.
module Jekyll
  module ExternalLinks
    # parti da non toccare: script, stili e commenti (il parser di Nokogiri non vi cercava link)
    SKIP = %r{(<script\b.*?</script\s*>|<style\b.*?</style\s*>|<!--.*?-->)}im.freeze
    A_TAG = /<a\b(?:[^>"']|"[^"]*"|'[^']*')*>/i.freeze
    HREF = /\shref\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'>]+))/i.freeze
    REL = /\srel\s*=/i.freeze
    TARGET = /\starget\s*=/i.freeze
    NO_EXTERNAL = /\sclass\s*=\s*["'][^"']*\bno-external\b/i.freeze

    module_function

    def process(item)
      return unless item.output_ext == '.html' && item.output

      config = item.site.config
      ext = config['external_links'] || {}
      return if ext['enabled'] == false

      site_url = config['url']
      rel = ext['rel'] || 'external noopener'
      target = ext['target'] || '_blank'
      excludes = Array(ext['exclude']).compact.map { |pattern| Regexp.new("^#{pattern}$") }
      extensions = Array(ext['new_tab_extensions']).compact.map { |e| e.to_s.downcase }

      item.output = item.output.split(SKIP).each_with_index.map do |part, i|
        i.odd? ? part : part.gsub(A_TAG) { |tag| add_attributes(tag, site_url, rel, target, excludes, extensions) }
      end.join
    end

    def add_attributes(tag, site_url, rel, target, excludes, extensions)
      match = tag.match(HREF)
      return tag unless match

      href = CGI.unescapeHTML(match[1] || match[2] || match[3])
      if href.match?(%r{\Ahttps?://}) && !(site_url && href.start_with?(site_url))
        return tag if excludes.any? { |pattern| pattern.match?(href) }

        link_rel = rel
      elsif site_file?(href, site_url, extensions) && !tag.match?(NO_EXTERNAL)
        link_rel = 'noopener'
      else
        return tag
      end

      extra = +''
      extra << %( rel="#{link_rel}") unless tag.match?(REL)
      extra << %( target="#{target}") unless tag.match?(TARGET)
      return tag if extra.empty?

      tag.sub(%r{\s*/?>\z}) { |close| extra + close }
    end

    # file del sito (percorso che inizia con / o indirizzo del sito) con una delle estensioni indicate
    def site_file?(href, site_url, extensions)
      return false if extensions.empty?

      path = href.sub(/[?#].*\z/, '')
      path = path.delete_prefix(site_url) if site_url && path.start_with?(site_url)
      return false unless path.start_with?('/') && !path.start_with?('//')

      extensions.include?(File.extname(path).delete_prefix('.').downcase)
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |item|
  Jekyll::ExternalLinks.process(item)
end
