document.addEventListener("DOMContentLoaded", () => {
  // 1. Prendi tutti i testi da data/not_found_texts
  const texts = window.__NOT_FOUND_TEXTS__;

  // 2. Determina la lingua da URL
  const path = window.location.pathname;
  const lang = path.startsWith("/it") ? "it"
             : path.startsWith("/es") ? "es"
             : "en";

  // 3. Prendi il messaggio localizzato (fallback su EN se manca)
  const raw = (texts.message && texts.message[lang]) || (texts.message && texts.message.en) || "";

  // 4. Converte link markdown in <a> e splitta in righe
  const lines = raw
    .replace(/\[([^\]]+)]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    .split(/\n|<br\s*\/?>|\s{2,}/);

  // 5. Popola i paragrafi
  document.getElementById("message-line-1").innerHTML = lines[0] || "";
  document.getElementById("message-line-2").innerHTML = lines[1] || "";

  // 6. Imposta dinamicamente <title>, descrizione e header
  if (texts.title?.[lang]) {
    document.title = texts.title[lang];
    const elTitle = document.getElementById("error-title");
    if (elTitle) elTitle.textContent = texts.title[lang];
  }

  if (texts.description?.[lang]) {
    const elDesc = document.getElementById("error-description");
    if (elDesc) elDesc.textContent = texts.description[lang];

    let meta = document.querySelector('meta[name="description"]');
    if (meta) {
      meta.setAttribute("content", texts.description[lang]);
    } else {
      meta = document.createElement("meta");
      meta.name = "description";
      meta.content = texts.description[lang];
      document.head.appendChild(meta);
    }
  }

  // 7. Redirect automatico dopo 7 secondi alla home localizzata
  setTimeout(() => {
    const home = lang === "en" ? "/" : `/${lang}/`;
    window.location.replace(home);
  }, 7000);
});
