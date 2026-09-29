# frozen_string_literal: true

# Le pagine _pages/<lingua>/dropdown.md servono solo a definire il menu "altro" dell'intestazione
# (dropdown: true, con le voci in children): non hanno contenuto proprio, ma Jekyll le pubblicava
# comunque come /_pages/<lingua>/dropdown.html, una pagina vuota che Google trovava.
# Dopo il rendering (quando l'intestazione le ha già usate) si tolgono dalle pagine da scrivere.
Jekyll::Hooks.register :site, :post_render do |site|
  site.pages.reject! { |page| page.data['dropdown'] }
end
