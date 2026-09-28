module.exports = {
  content: ["_site/**/*.html", "_site/**/*.js"],
  css: ["_site/assets/css/*.css"],
  output: "_site/assets/css/",
  skippedContentGlobs: ["_site/assets/**/*.html"],
  // i selettori sull'indirizzo dei link (a[href^="mailto:"], che sostituisce la classe aggiunta dal vecchio
  // script dei link esterni) non vengono riconosciuti nel contenuto e sarebbero tolti: si tengono tutti
  // data-bs-popper: Bootstrap 5 lo aggiunge ai menu a tendina aperti (allineamento a destra, dropdown-menu-end)
  dynamicAttributes: ["href", "data-bs-popper"],
};
