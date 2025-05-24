document.addEventListener("DOMContentLoaded", () => {
  // 1. Prendi tutti i testi da data/not_found_texts
  const texts = window.__NOT_FOUND_TEXTS__;

  // 2. Determina la lingua da URL
  const path = window.location.pathname;
  const lang = path.startsWith("/it") ? "it"
             : path.startsWith("/es") ? "es"
             : "en";

  // 3. Prendi il messaggio raw (fallback su EN se manca)
  const raw = texts.message[lang] || texts.message.en;

  // 4. Converti Markdown-link in <a> e splitta in righe
  const lines = raw
    .replace(/\[([^\]]+)]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    .split(/\n|<br\s*\/?>|\s{2,}/);

  // 5. Popola i due paragrafi
  document.getElementById("message-line-1").innerHTML = lines[0] || "";
  document.getElementById("message-line-2").innerHTML = lines[1] || "";

  // 6. (Opzionale) redirect automatico
  setTimeout(() => {
    const home = lang === "en" ? "/" : `/${lang}/`;
    window.location.replace(home);
  }, 7000);
});
