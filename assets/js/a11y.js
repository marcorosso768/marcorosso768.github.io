// Accessibilità: stato delle tendine per i lettori di schermo e uso da tastiera
(function () {
  function setHidden(el, hidden) {
    if (!el) return;
    if (hidden) {
      el.setAttribute("aria-hidden", "true");
      el.setAttribute("inert", "");
    } else {
      el.removeAttribute("aria-hidden");
      el.removeAttribute("inert");
    }
  }

  function activateOnKey(el) {
    el.addEventListener("keydown", function (e) {
      if (e.key === " " || e.key === "Spacebar" || (e.key === "Enter" && el.tagName !== "A")) {
        e.preventDefault();
        el.click();
      }
    });
  }

  function initSectionToggles() {
    var triggers = document.querySelectorAll('a[onclick*="toggleVisibility"]');
    triggers.forEach(function (a) {
      var m = a.getAttribute("onclick").match(/toggleVisibility\(\s*['"]([^'"]+)['"]/);
      if (!m) return;
      var section = document.getElementById(m[1]);
      if (!section) return;
      // se il link contiene un titolo, niente role="button": i figli di un pulsante perdono la semantica di titolo
      if (!a.querySelector("h1, h2, h3, h4, h5, h6")) a.setAttribute("role", "button");
      a.setAttribute("aria-controls", m[1]);
      var expanded = section.classList.contains("expanded");
      a.setAttribute("aria-expanded", expanded ? "true" : "false");
      setHidden(section, !expanded);
      activateOnKey(a);
      a.addEventListener("click", function () {
        var isExpanded = section.classList.contains("expanded");
        a.setAttribute("aria-expanded", isExpanded ? "true" : "false");
        setHidden(section, !isExpanded);
      });
    });
  }

  function initPills() {
    var pills = document.querySelectorAll(".toggle-pill[data-target]");
    function sync() {
      pills.forEach(function (p) {
        var box = document.getElementById(p.getAttribute("data-target"));
        p.setAttribute("aria-expanded", box && box.classList.contains("active") ? "true" : "false");
      });
    }
    pills.forEach(function (p) {
      p.setAttribute("role", "button");
      p.setAttribute("tabindex", "0");
      p.setAttribute("aria-controls", p.getAttribute("data-target"));
      activateOnKey(p);
      p.addEventListener("click", sync);
    });
    sync();
  }

  function init() {
    initSectionToggles();
    initPills();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
