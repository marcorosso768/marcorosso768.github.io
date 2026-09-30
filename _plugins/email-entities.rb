# frozen_string_literal: true

# Filtro {{ "nome@dominio" | email_entities }}: scrive l'indirizzo come entità HTML (&#109;&#97;...).
# Il browser lo mostra normalmente; i programmi che cercano "nome@dominio" nel sorgente della pagina
# non lo trovano. Per il link si usa encode_email (jekyll-email-protect), che codifica in %XX.
module EmailEntities
  def email_entities(input)
    input.to_s.each_char.map { |c| "&##{c.ord};" }.join
  end
end

Liquid::Template.register_filter(EmailEntities)
