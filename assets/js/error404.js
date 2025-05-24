document.addEventListener("DOMContentLoaded", function () {
  // 1. Prendi tutti i testi da data/not_found_texts
  var texts = window.__NOT_FOUND_TEXTS__;

  // 2. Determina la lingua da URL
  var path = window.location.pathname;
  var lang = path.indexOf("/it") === 0 ? "it"
           : path.indexOf("/es") === 0 ? "es"
           : "en";

  // 3. Prendi il messaggio localizzato (fallback su EN se manca)
  var raw = (texts.message && texts.message[lang]) || (texts.message && texts.message.en) || "";

  // 4. Converte link markdown in <a> e splitta in righe
  var lines = raw
    .replace(/\[([^\]]+)]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    .split(/\n|<br\s*\/?>|\s{2,}/);

  // 5. Popola i paragrafi
  document.getElementById("message-line-1").innerHTML = lines[0] || "";
  document.getElementById("message-line-2").innerHTML = lines[1] || "";

  // 6. Imposta dinamicamente <title>, descrizione e header
  if (texts.title && texts.title[lang]) {
    document.title = texts.title[lang];
    var elTitle = document.getElementById("error-title");
    if (elTitle) elTitle.textContent = texts.title[lang];
  }

  if (texts.description && texts.description[lang]) {
    var elDesc = document.getElementById("error-description");
    if (elDesc) elDesc.textContent = texts.description[lang];

    var meta = document.querySelector('meta[name="description"]');
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
  setTimeout(function () {
    var home = lang === "en" ? "/" : "/" + lang + "/";
    window.location.replace(home);
  }, 7000);

  // 8. Aggiorna dinamicamente la navbar nella pagina 404 con la lingua corrente
  const supportedLanguages = ["en", "it", "es"];

  document.querySelectorAll("nav a[href^='/']").forEach((link) => {
    const href = link.getAttribute("href");
    if (!href) return;

    const alreadyLocalized = supportedLanguages.some(l => href.startsWith(`/${l}/`));
    const currentLang = lang;

    if (!alreadyLocalized) {
      // Non ha prefisso lingua: aggiungilo (tranne che per "en")
      if (currentLang !== "en") {
        link.setAttribute("href", `/${currentLang}${href}`);
      }
    } else {
      // Ha un prefisso lingua sbagliato: correggilo
      supportedLanguages.forEach(l => {
        if (l !== currentLang && href.startsWith(`/${l}/`)) {
          const newHref = href.replace(`/${l}/`, currentLang === "en" ? "/" : `/${currentLang}/`);
          link.setAttribute("href", newHref);
        }
      });
    }
  });
});
