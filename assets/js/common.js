// Comportamenti comuni (prima con jQuery): pulsanti abstract/award/bibtex delle pubblicazioni al-folio
// e stile dei notebook Jupyter incorporati. Oggi il sito non usa né gli uni né gli altri, ma restano pronti.
document.addEventListener("DOMContentLoaded", function () {
  const panels = ["abstract", "award", "bibtex"];
  panels.forEach(function (name) {
    document.querySelectorAll("a." + name).forEach(function (link) {
      link.addEventListener("click", function () {
        const entry = link.parentElement && link.parentElement.parentElement;
        if (!entry) return;
        panels.forEach(function (other) {
          const selector = other === name ? "." + other + ".hidden" : "." + other + ".hidden.open";
          entry.querySelectorAll(selector).forEach(function (el) {
            el.classList.toggle("open");
          });
        });
      });
    });
  });

  // notebook Jupyter incorporati: foglio di stile e tema scuro
  const jupyterTheme = determineComputedTheme();
  document.querySelectorAll(".jupyter-notebook-iframe-container iframe").forEach(function (frame) {
    frame.addEventListener("load", function () {
      const doc = frame.contentDocument;
      if (!doc) return;
      const cssLink = doc.createElement("link");
      cssLink.href = "../css/jupyter.css";
      cssLink.rel = "stylesheet";
      cssLink.type = "text/css";
      doc.head.appendChild(cssLink);
      if (jupyterTheme == "dark") {
        doc.body.setAttribute("data-jp-theme-light", "false");
        doc.body.setAttribute("data-jp-theme-name", "JupyterLab Dark");
      }
    });
  });
});
