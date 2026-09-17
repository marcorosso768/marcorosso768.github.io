# frozen_string_literal: true

# jekyll-polyglot 1.8.1: {% static_href %} scrive temporaneamente l'attributo al contrario ("ferh=")
# per non farlo riscrivere con il prefisso di lingua, e poi lo ripristina solo per gli indirizzi relativi.
# Con un indirizzo assoluto (https://marcorosso.com/...) resta "ferh=", e il tag hreflang non vale.
# Questo hook, dopo la scrittura del sito, ripristina "href=" nei soli tag <link rel="alternate">.
Jekyll::Hooks.register :site, :post_write do |site|
  Dir.glob(File.join(site.dest, '**', '*.html')).each do |path|
    content = File.read(path, encoding: 'UTF-8')
    next unless content.include?('ferh=')

    fixed = content.gsub(/(<link rel="alternate"[^>]*?)\sferh=/, '\1 href=')
    File.write(path, fixed) if fixed != content
  end
end
