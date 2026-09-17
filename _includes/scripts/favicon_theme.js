// Favicon allineata al tema scelto sul sito (pulsante chiaro/scuro), non solo a quello del sistema.
// Caricato nel <head> subito dopo theme.js: al primo caricamento le icone sono già quelle giuste
// prima che il browser le legga, quindi funziona anche su Safari. Il cambio "al volo" dal pulsante
// funziona su Chrome, Edge e Firefox; Safari lo applica al caricamento della pagina successiva.
(function () {
  var base = "/assets/img/favicons/v3/";
  var files = {
    light: { dir: "favicon_light/" },
    dark: { dir: "favicon_dark/" },
  };
  var current = null;

  function apply() {
    var theme = document.documentElement.getAttribute("data-theme") === "dark" ? "dark" : "light";
    if (theme === current) return;
    current = theme;
    var f = files[theme];
    var head = document.head;
    document.querySelectorAll("link[data-favicon]").forEach(function (old) {
      var kind = old.getAttribute("data-favicon");
      var link = old.cloneNode(false);
      link.removeAttribute("media");
      var dir = base + f.dir;
      if (kind === "svg") link.href = dir + "favicon.svg";
      else if (kind === "apple") link.href = dir + "apple-touch-icon.png";
      else if (kind === "ico") link.href = theme === "dark" ? dir + "favicon.ico" : "/favicon.ico";
      else if (kind === "png-dark") {
        // la variante legata al tema di sistema non serve più: resta una sola PNG
        old.parentNode.removeChild(old);
        return;
      } else link.href = dir + "favicon-96x96.png";
      // sostituire l'elemento (non solo l'href) fa aggiornare l'icona nei browser che la memorizzano
      old.parentNode.removeChild(old);
      head.appendChild(link);
    });
  }

  apply();
  new MutationObserver(apply).observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });
})();
