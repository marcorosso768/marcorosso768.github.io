# frozen_string_literal: true

# kramdown scrive gli elementi vuoti in stile XHTML (<br />, <hr />); il minificatore li lascia come <br/>.
# In HTML la barra finale non serve e il validatore W3C la segnala. Dopo la scrittura del sito si toglie
# dagli elementi vuoti dell'HTML (non tocca SVG né XML: solo i file .html e solo questi nomi di elemento).
VOID_ELEMENTS = %w[area base br col embed hr img input link meta source track wbr].freeze
VOID_SLASH = %r{<(#{VOID_ELEMENTS.join('|')})\b([^<>]*?)\s*/>}.freeze

Jekyll::Hooks.register :site, :post_write do |site|
  Dir.glob(File.join(site.dest, '**', '*.html')).each do |path|
    content = File.read(path, encoding: 'UTF-8')
    next unless content.include?('/>')

    fixed = content.gsub(VOID_SLASH, '<\1\2>')
    File.write(path, fixed) if fixed != content
  end
end
