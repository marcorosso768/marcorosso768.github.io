// Classi Bootstrap sulle tabelle (prima con jQuery): table-dark nel tema scuro (la cambia anche theme.js)
// e table-hover sulle tabelle fuori da news, card, archivi e blocchi di codice.
document.addEventListener("DOMContentLoaded", function () {
  const dark = determineComputedTheme() == "dark";
  document.querySelectorAll("table").forEach(function (table) {
    table.classList.toggle("table-dark", dark);
    if (!table.closest('[class*="news"], [class*="card"], [class*="archive"], code')) {
      table.setAttribute("data-toggle", "table");
      table.classList.add("table-hover");
    }
  });
});
